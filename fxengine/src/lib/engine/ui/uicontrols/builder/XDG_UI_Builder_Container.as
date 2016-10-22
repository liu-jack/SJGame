package lib.engine.ui.uicontrols.builder
{
	import lib.engine.iface.IResource;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.data.controls.XDG_UI_Data_Container;
	import lib.engine.ui.uicontrols.XDG_UI_Container;
	import lib.engine.ui.uicontrols.XDG_UI_Control;
	import lib.engine.utils.CTimerUtils;
	
	public class XDG_UI_Builder_Container extends XDG_UI_Builder
	{
		public function XDG_UI_Builder_Container(IResourceBuilder:IResource)
		{
			super(IResourceBuilder);
		}
		
		override public function Builder_valid(type:String):Boolean
		{
			return type == XDG_UI_Data_Container.TYPE;
		}
		
		override public function CreateCtrlInfo(type:String, name:String=null):XDG_UI_Data
		{
			var control:XDG_UI_Data = new XDG_UI_Data_Container();
			if(name != null)
			{
				control.name = name;
			}
			else
			{
				control.name = "unname-container_"+CTimerUtils.getCurrentTime();
			}
			control.width = 100;
			control.height = 100;
			return control;
		}
		
		override public function CreateViewControl(controlinfo:XDG_UI_Data, _callback:Function):void
		{
			var _ctrl:XDG_UI_Control = new XDG_UI_Container();
			_ctrl.LoadProperty(controlinfo);
			_callback(controlinfo,_ctrl);
		}
		
		
	}
}