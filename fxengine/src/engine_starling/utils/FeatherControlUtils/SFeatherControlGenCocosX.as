package engine_starling.utils.FeatherControlUtils
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SStringUtils;
	
	import feathers.core.FeathersControl;
	
	public class SFeatherControlGenCocosX
	{
		private var _log:Logger;
		private var _propertygen:Dictionary;
		/**
		 * 控件名称映射 
		 */		
		private var _cocosxclass2feathername:Dictionary = new Dictionary();
		/**
		 * 默认的属性构造器 
		 */
		private var _propertygenDefaultBuilder:IFeatherControlPropertyBuilder;

		public function SFeatherControlGenCocosX()
		{
			_log = Logger.getInstance(SFeatherControlUtils);
			_registerBuilders();
			_cocosxclass2feathername["Panel"] = "engine_starling.display.SLayer";
			_cocosxclass2feathername["Button"] = "feathers.controls.Button";
			_cocosxclass2feathername["TextButton"] = "feathers.controls.Button";
			_cocosxclass2feathername["ImageView"] = "feathers.controls.ImageLoader";
			_cocosxclass2feathername["LoadingBar"] = "feathers.controls.ProgressBar";
			_cocosxclass2feathername["TextArea"] = "feathers.controls.Label";
			_cocosxclass2feathername["TextField"] = "feathers.controls.TextInput";
			_cocosxclass2feathername["CheckBox"] = "feathers.controls.Check";
			_cocosxclass2feathername["ScrollView"] = "feathers.controls.List";
			
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
			_propertygenDefaultBuilder = new FeatherControlCocosXPropertyBuilderDefault();
			
			_registerBuilder(new FeatherControlCocosXPropertyBuilderButton);
			_registerBuilder(new FeatherControlCocosXPropertyBuilderImageLoader);
			_registerBuilder(new FeatherControlCocosXPropertyBuilderLabel());
			_registerBuilder(new FeatherControlCocosXPropertyBuilderCheckBox());
			_registerBuilder(new FeatherControlCocosXPropertyBuilderProgressBar());
			_registerBuilder(new FeatherControlCocosXPropertyBuilderSLayer());
			_registerBuilder(new FeatherControlCocosXPropertyBuilderTextInput());
			_registerBuilder(new FeatherControlCocosXPropertyBuilderList());
		}
		
		/**
		 *  生成布局文件 
		 * @param jsonObj
		 * @param ownerClass 必须是 SLayer的子类
		 * @return 
		 * 
		 */
		public function genLayoutFromcocosJson(jsonObj:Object,ownerClass:Class = null):FeathersControl
		{
			//生成根控件
			var uirootobject:Object = jsonObj.widgetTree;
			
			var rootControl:FeathersControl = _buildControl(uirootobject,ownerClass,null);
			
			for each (var c:Object in uirootobject.children)
			{
				//如果拥有类为 null 则传null 否则传入生成的类 rootControl 为拥有类
				var childControl:FeathersControl = _processJsonLayout(c,rootControl);		
				if(childControl != null)
				{
					rootControl.addChild(childControl);
				}
			}
			return rootControl;
		}
		
		private function _processJsonLayout(jsonObj:Object,parentControl:FeathersControl = null):FeathersControl
		{
			var parentControl:FeathersControl = _buildControl(jsonObj,null,parentControl);
			for each (var c:Object in jsonObj.children)
			{
				var childControl:FeathersControl = _processJsonLayout(c,parentControl);	
				if(childControl != null)
				{
					parentControl.addChild(childControl);
				}
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
		private function _buildControl(jsonObj:Object,customClass:Class = null,parentControl:FeathersControl = null):FeathersControl
		{
			//			_log.info(layout.name());
			var cls:Class = null;
			var fullclassName:String = null;
			
			

			
			fullclassName = _cocosxclass2feathername[jsonObj.classname];
			//为了测试 先用这个
			if(SStringUtils.isEmpty(fullclassName))
			{
				fullclassName = "engine_starling.display.SLayer";
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
			_propertyBuilder.beginEdit(control,parentControl);
			//			/设置属性
			for (var propertykey:String in jsonObj.options){
				_propertyBuilder.setProperty(propertykey,jsonObj.options[propertykey]);
			}
			
			_propertyBuilder.endEdit();
			
			return control;
		}
	}
}