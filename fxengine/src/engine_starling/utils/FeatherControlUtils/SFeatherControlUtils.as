package engine_starling.utils.FeatherControlUtils
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SStringUtils;
	
	import feathers.core.FeathersControl;
	
	import lib.engine.utils.functions.Assert;

	public class SFeatherControlUtils
	{

		
		private static var _o:SFeatherControlUtils = null;
		private var _log:Logger;
		private var _cocosxgen:SFeatherControlGenCocosX;
		
		
		private var _propertygen:Dictionary;
		/**
		 * 默认的属性构造器 
		 */
		private var _propertygenDefaultBuilder:IFeatherControlPropertyBuilder;
		
		public static function get o():SFeatherControlUtils
		{
			if(_o == null)
			{
				_o = new SFeatherControlUtils();
				
				
			}
			return _o;
		}
		
		
		public function SFeatherControlUtils()
		{
			_log = Logger.getInstance(SFeatherControlUtils);
			_registerBuilders();
			
			_cocosxgen = new SFeatherControlGenCocosX();
		
			
		}
		
		

		
		/**
		 * 注册属性构造器 
		 * @param builder
		 * 
		 */
		private function _registerBuilder(builder:IFeatherControlPropertyBuilder):void
		{
			_propertygen[builder.fullClassName] = builder;
		}
		private function _registerBuilders():void
		{
			_propertygen = new Dictionary();
			//注册默认的属性构造器
			_propertygenDefaultBuilder = new FeatherControlPropertyBuilderDefault;
			
			_registerBuilder(new FeatherControlPropertyBuilderButton);
			_registerBuilder(new FeatherControlPropertyBuilderImageLoader);
			_registerBuilder(new FeatherControlPropertyBuilderLabel());
			_registerBuilder(new FeatherControlPropertyBuilderSAtlasLabel());
			_registerBuilder(new FeatherControlPropertyBuilderProgressBar());
		}
		
		public function genLayoutFromcocosJson(jsonObj:Object,ownerClass:Class = null):FeathersControl
		{
			return _cocosxgen.genLayoutFromcocosJson(jsonObj,ownerClass);
		}
		
		/**
		 * 生成布局文件助手了 
		 * 如果没有xml  会抛出异常
		 * @param xmlname xml文件名称,会从AssetManagerUtil.o.getObject 中获取
		 * @param ownerClass 宿主类
		 * @return 
		 * 
		 */
		public static function genLayoutFromXMLHelp(xmlname:String,ownerClass:Class = null):*
		{
			var layoutxml:XML = AssetManagerUtil.o.getObject(xmlname) as XML;
			Assert(layoutxml!= null,"生成配置文件 XML不存在 :" + xmlname);
			return o.genLayoutFromXML(layoutxml,ownerClass);
		}
		
		/**
		 * 生成布局文件 
		 * @param xml
		 * @return 
		 * 
		 */
		public function genLayoutFromXML(xml:XML,ownerClass:Class = null):FeathersControl
		{
			//生成根控件
			var rootControl:FeathersControl = _buildControl(xml,ownerClass,null);
			for each (var c:XML in xml.children())
			{
				//如果拥有类为 null 则传null 否则传入生成的类 rootControl 为拥有类
				var childControl:FeathersControl = _processXMLLayouts(c,ownerClass == null?null:rootControl);		
				
				rootControl.addChild(childControl);
				
			}
			return rootControl;
		}
		
		
		

		/**
		 * 递归 处理布局文件 
		 * @param layout
		 * @param ownerControl 拥有控件
		 * @return 
		 * 
		 */
		private function _processXMLLayouts(layout:XML,ownerControl:FeathersControl = null):FeathersControl
		{
			//生成父控件
			var parentControl:FeathersControl = _buildControl(layout,null,ownerControl);
			for each (var c:XML in layout.children())
			{
				var childControl:FeathersControl = _processXMLLayouts(c,ownerControl);	
				parentControl.addChild(childControl);
			}
			return parentControl;
		}
		/**
		 * 创建控件 
		 * @param layout
		 * @param customClass 自定义类 如果为null 则使用配置文件中的类
		 * @param ownerControl 拥有类
		 * @return 
		 * 
		 */
		private function _buildControl(layout:XML,customClass:Class = null,ownerControl:FeathersControl = null):FeathersControl
		{
//			_log.info(layout.name());
			var cls:Class = null;
			var fullclassName:String = null;
			

			if(layout.hasOwnProperty("@customPrefix") && !SStringUtils.isEmpty(layout.@customPrefix.toString()))
			{
				fullclassName = layout.@customPrefix +"." + layout.name();
			}
			else
			{
				fullclassName = "feathers.controls." + layout.name();
			}
			
			cls = getDefinitionByName(fullclassName) as Class;
			if(customClass != null)
				cls = customClass;
			
			var control:FeathersControl = new cls() as FeathersControl;
			
			//设置属性编辑器
			var _propertyBuilder:IFeatherControlPropertyBuilder = _propertygen[fullclassName];
			if(_propertyBuilder == null)
			{
				_propertyBuilder = _propertygenDefaultBuilder;
			}
			_propertyBuilder.beginEdit(control,ownerControl);
//			/设置属性
			for each(var kid:XML in layout.attributes()){
				_propertyBuilder.setProperty(kid.name().localName,kid.toString());
			}
			
			_propertyBuilder.endEdit();
			
			return control;
		}
	}
}