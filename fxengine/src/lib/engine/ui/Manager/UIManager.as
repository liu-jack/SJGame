package lib.engine.ui.Manager
{
	import lib.engine.iface.IResource;
	import lib.engine.iface.ui.I_XGD_UIBuilder;
	import lib.engine.ui.uicontrols.*;
	
	/**
	 * 
	 */
	
	/**
	 * UI系统管理器,所有UI系统必须首先初始化这个玩意
	 * @author caihua
	 * 
	 */
	
	public class UIManager extends UIManagerControls
	{
		private static var _ins:UIManager;
		public static function get o():UIManager
		{
			if(_ins == null)
			{
				_ins = new UIManager();
			}
			return _ins;
		}
		public function UIManager()
		{
		}
		
		/**
		 * 初始化函数 
		 * @param ui_Factory
		 * @param ResourceManager
		 * @param ResourceClassBuilder
		 * 
		 */
		public function Initializa(ui_Factory:I_XGD_UIBuilder
								   ,ResourceManager:IResource):void
		{
			_ui_Factory = ui_Factory;
			_ResourceManager  = ResourceManager;
		}
		
		
	}
}
