package lib.engine.ui.uicontrols.builder
{
	import lib.engine.iface.IResource;
	import lib.engine.iface.ui.I_XGD_UIBuilder;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	
	/**
	 * 构造器基础类 
	 * @author caihua
	 * 
	 */
	public class XDG_UI_Builder implements I_XGD_UIBuilder
	{
		public function XDG_UI_Builder(IResourceBuilder:IResource)
		{
			_IResourceBuilder = IResourceBuilder;
		}
		
		/**
		 * 资源管理器 
		 */
		protected var _IResourceBuilder:IResource;
		
		public function Builder_valid(type:String):Boolean
		{
			return false;
		}
		
		public function CreateViewControl(controlinfo:XDG_UI_Data, _callback:Function):void
		{
		}
		
		public function CreateCtrlInfo(type:String, name:String=null):XDG_UI_Data
		{
			return null;
		}
	}
}