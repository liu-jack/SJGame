package lib.engine.ui.uicontrols.builder
{
	import lib.engine.iface.IResource;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.data.controls.XDG_UI_Data_TextInput;
	import lib.engine.ui.uicontrols.XDG_UI_TextInput;
	import lib.engine.utils.CTimerUtils;
	
	public class XDG_UI_Builder_TextInput extends XDG_UI_Builder
	{
		public function XDG_UI_Builder_TextInput(IResourceBuilder:IResource)
		{
			super(IResourceBuilder);
			
		}
		
		override public function Builder_valid(type:String):Boolean
		{
			return type == XDG_UI_Data_TextInput.TYPE;
		}
		
		override public function CreateViewControl(controlinfo:XDG_UI_Data, _callback:Function):void
		{
			var _ctrl:XDG_UI_TextInput = new XDG_UI_TextInput();
			_ctrl.LoadProperty(controlinfo);
			_callback(controlinfo,_ctrl);
		}
		
		override public function CreateCtrlInfo(type:String, name:String=null):XDG_UI_Data
		{
			var control:XDG_UI_Data_TextInput = new XDG_UI_Data_TextInput();
			if(name != null)
			{
				control.name = name;
			}
			else
			{
				control.name = "unname-textinput_"+CTimerUtils.getCurrentTime();
			}
			control.width = 50;
			control.height = 20;
			return control;
		}
	}
}