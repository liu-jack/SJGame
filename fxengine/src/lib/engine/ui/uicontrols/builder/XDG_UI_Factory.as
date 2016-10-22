package lib.engine.ui.uicontrols.builder
{
	import lib.engine.iface.IResource;
	import lib.engine.iface.ui.I_XGD_UIBuilder;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	

	/**
	 * 控件显示构造器 
	 * 工厂类
	 * @author caihua
	 * 
	 */
	public class XDG_UI_Factory implements I_XGD_UIBuilder
	{
		private var _builders:Array = new Array();
		protected var _ResourceClassBuilder:IResource;
		
		
		/**
		 * 控件构造工厂 
		 * @param ResourceClassBuilder
		 * 
		 */
		public function XDG_UI_Factory(ResourceClassBuilder:IResource)
		{
			_ResourceClassBuilder = ResourceClassBuilder;
		}
		

		/**
		 * 初始化 方案
		 * @param isLoadDefault 是否加载初始化方案,默认为T
		 * 如果为 F,子类必须重新 _init_custom 否则抛出异常
		 * 
		 */
		public final function init(isLoadDefault:Boolean = true):void
		{
			if(isLoadDefault)
			{
				_init_default_builders();
			}
			else
			{
				_init_custom_builders();
			}
			
		}
		protected final function _init_default_builders():void
		{
			_register_builder(new XDG_UI_Builder_Button(_ResourceClassBuilder));
			_register_builder(new XDG_UI_Builder_MC(_ResourceClassBuilder));
			_register_builder(new XDG_UI_Builder_Label(_ResourceClassBuilder));
			_register_builder(new XDG_UI_Builder_TextInput(_ResourceClassBuilder));
			_register_builder(new XDG_UI_Builder_Tooltip(_ResourceClassBuilder));
			_register_builder(new XDG_UI_Builder_Container(_ResourceClassBuilder));
			_register_builder(new XDG_UI_Builder_FreeSizeImage(_ResourceClassBuilder));
			_register_builder(new XDG_UI_Builder_ProgressBar(_ResourceClassBuilder));
			
		}
		protected function _init_custom_builders():void
		{
			throw Error("子类必须重写_init_custom_builders,父类_init_custom_builders 不可调用");
		}
		protected final function _register_builder(_builder:I_XGD_UIBuilder):void
		{
			_builders.push(_builder);
		}
		
		/**
		 * 此方法不调用 
		 * @param type
		 * @return 
		 * 
		 */
		public function Builder_valid(type:String):Boolean
		{
			
			return false;
		}
		
		
		public final function CreateViewControl(controlinfo:XDG_UI_Data,_callback:Function):void
		{
			
			for each(var _builder:I_XGD_UIBuilder in _builders)
			{
				if(_builder.Builder_valid(controlinfo.type))
				{
					_builder.CreateViewControl(controlinfo,_callback);
					return;
				}
			}
			
		}
		
		public function CreateCtrlInfo(type:String, name:String=null):XDG_UI_Data
		{
			var _ctrlinfo:XDG_UI_Data = null;
			for each(var _builder:I_XGD_UIBuilder in _builders)
			{
				if(_builder.Builder_valid(type))
				{
					_ctrlinfo = _builder.CreateCtrlInfo(type,name);
					return _ctrlinfo;
				}
			}
			return _ctrlinfo;
		}
		
		
		
	}
}