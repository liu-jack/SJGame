package lib.engine.ui.uicontrols.builder
{
	import lib.engine.iface.IResource;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.data.controls.XDG_UI_Data_FreeSizeImage;
	import lib.engine.ui.uicontrols.XDG_UI_Control;
	import lib.engine.ui.uicontrols.XDG_UI_FreeSizeImage;
	import lib.engine.utils.CTimerUtils;
	
	public class XDG_UI_Builder_FreeSizeImage extends XDG_UI_Builder
	{
		public function XDG_UI_Builder_FreeSizeImage(IResourceBuilder:IResource)
		{
			super(IResourceBuilder);
		}
		
		override public function Builder_valid(type:String):Boolean
		{
			return type == XDG_UI_Data_FreeSizeImage.TYPE;
		}
		
		override public function CreateCtrlInfo(type:String, name:String=null):XDG_UI_Data
		{
			var control:XDG_UI_Data = new XDG_UI_Data_FreeSizeImage();
			if(name != null)
			{
				control.name = name;
			}
			else
			{
				control.name = "unname-freeSizeImage_"+CTimerUtils.getCurrentTime();
			}
			control.width = 50;
			control.height = 50;
			return control;
		}
		
		override public function CreateViewControl(controlinfo:XDG_UI_Data, _callback:Function):void
		{
			var _ctrl:XDG_UI_Control = new XDG_UI_FreeSizeImage();
			_ctrl.LoadProperty(controlinfo);
			_callback(controlinfo,_ctrl);
		}
		
	}
}