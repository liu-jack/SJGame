package engine_starling.display
{
	import engine_starling.Events.AnimateEvent;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SMuiscChannel;
	
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import mx.utils.ObjectUtil;

	public class SAnimateFrameScriptAction implements ISAnimateFrameScript
	{

		private var _owner:SAnimate;
		public function SAnimateFrameScriptAction()
		{
			_propertys = new Vector.<SAnimateFrameScriptActionParams>();
		}
		
		public function execute(owner:SAnimate):void
		{
			
			var length:int = _propertys.length;
			var param:SAnimateFrameScriptActionParams;
			_owner = owner;
			for(var i:int = 0;i<length;i++)
			{
				param = _propertys[i];
				//定义了特殊属性访问器
				if(hasOwnProperty(param.propertyName))
				{
					this[param.propertyName] = param.propertyValue;
				}
				else if(owner.hasOwnProperty(param.propertyName))
				{
					owner[param.propertyName] = param.propertyValue;
				}
			}
			
			_owner = null;
			
	
			
		}
		
		private var _propertys:Vector.<SAnimateFrameScriptActionParams>;
		
		private static var _propertysCache:Dictionary = new Dictionary();
		
		
		/**
		 * 添加属性 
		 * @param key
		 * @param value
		 * 
		 */
		public function addPropertys(key:String,value:*):void
		{
			var _cacheKey:String = key + "__" + value;
			var params:SAnimateFrameScriptActionParams = null;
			if(value is String && _propertysCache.hasOwnProperty(_cacheKey))
			{
				params = _propertysCache[_cacheKey];
			}
			else
			{
				params = new SAnimateFrameScriptActionParams(key,value);
				_propertysCache[_cacheKey] = params;
			}
			 
			_propertys.push(params);
		}
		
		/**
		 * 删除属性 
		 * @param key
		 * 
		 */
		public function removePropertys(key:String):void
		{
			var length:int = _propertys.length;
			var param:SAnimateFrameScriptActionParams;
			for(var i:int = 0;i<length;i++)
			{
				param = _propertys[i];
				if(param.propertyName == key)
				{
					_propertys.splice(i,1);
					break;
				}
			}
		}
		
		/**
		 * 设置属性,修改 
		 * @param key
		 * @param value
		 * 
		 */
		public function setPropertys(key:String,value:*):void
		{
			var length:int = _propertys.length;
			var param:SAnimateFrameScriptActionParams;
			for(var i:int = 0;i<length;i++)
			{
				param = _propertys[i];
				if(param.propertyName == key)
				{
					_propertys.splice(i,1);
					break;
				}
			}
		}

		
		/**
		 * 生成命令 
		 * @param keyAndValues 属性名称,属性值....
		 * @return 
		 * 
		 */
		public static function genWithKeyAndValue(...keyAndValues):SAnimateFrameScriptAction
		{
			var ins:SAnimateFrameScriptAction = new SAnimateFrameScriptAction();
			
			var length:int = keyAndValues.length;
			for(var i:int=0;i<length;i+=2)
			{
				ins.addPropertys(keyAndValues[i],keyAndValues[i+1]);
			}
			
			return ins;
		}
		
		/**
		 * 生成特定的脚本执行器 
		 * @param property
		 * @param scriptClass = null SAnimateFrameScriptAction 特殊的脚本解释器
		 * @return 
		 * 
		 */
		public static function genWithPropertyObject(property:Object,scriptClass:Class = null):SAnimateFrameScriptAction
		{
			if(scriptClass == null)
			{
				scriptClass = SAnimateFrameScriptAction
			}
			var ins:SAnimateFrameScriptAction = new scriptClass();
			
			var properties:Array;
			//获取类模板
			properties = ObjectUtil.getClassInfo(property,null,null).properties as Array;
			
			var length:int = properties.length;
			var n:QName;
			for(var i:int =0;i<length;++i)
			{
				n = properties[i];
				ins.addPropertys(n.localName,property[n.localName]);
			}
			
			return ins;
		}
		
		
		//属性设置器
		/**
		 * 设置声音 
		 * @param value
		 * 
		 */
		public function set Sound(value:*):void
		{
			var sound:flash.media.Sound = AssetManagerUtil.o.getObject(value) as flash.media.Sound;
			SMuiscChannel.SMuiscChannelCreate(sound).fadeIn(false,0.1,1);
		}
		
		
		public function set event(value:*):void
		{
			_owner.dispatchEventWith(AnimateEvent.Event_Custom,false,{"value":value});
		}
		
		
		public function set eventbatch(value:*):void
		{
			var key:String = "";
			for( key in value)
			{
				_owner.dispatchEventWith(key,false,value[key]);
			}
		}
		
		public function set offsetx(value:*):void
		{
			_owner.x += parseFloat(value);
		}
		
		public function set offsety(value:*):void
		{
			_owner.y += parseFloat(value);
		}
		
	}
}
 
/**
 * 动画参数类 
 * @author caihua
 * 
 */
class SAnimateFrameScriptActionParams
{
	public function SAnimateFrameScriptActionParams(propertyName:String,propertyValue:*)
	{
		_propertyName = propertyName;
		_propertyValue = propertyValue;
	}
	private var _propertyName:String;
	
	/**
	 * 属性名称 
	 */
	public function get propertyName():String
	{
		return _propertyName;
	}
	
	/**
	 * @private
	 */
	public function set propertyName(value:String):void
	{
		_propertyName = value;
	}
	
	private var _propertyValue:*;
	
	/**
	 * 属性值 
	 */
	public function get propertyValue():*
	{
		return _propertyValue;
	}
	
	/**
	 * @private
	 */
	public function set propertyValue(value:*):void
	{
		_propertyValue = value;
	}
}