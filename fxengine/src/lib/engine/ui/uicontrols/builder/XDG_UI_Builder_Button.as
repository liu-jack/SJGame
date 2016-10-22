package lib.engine.ui.uicontrols.builder
{
	import lib.engine.iface.IResource;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.data.controls.XDG_UI_Data_Button;
	import lib.engine.ui.uicontrols.XDG_UI_Button;
	import lib.engine.ui.uicontrols.XDG_UI_Control;
	import lib.engine.utils.CTimerUtils;
	
	/**
	 * 按钮基础构造器 
	 * @author caihua
	 * 
	 */
	public class XDG_UI_Builder_Button extends XDG_UI_Builder
	{
		public function XDG_UI_Builder_Button(IResourceBuilder:IResource)
		{
			super(IResourceBuilder);
		}
		
		public override function Builder_valid(type:String):Boolean
		{
			return type == XDG_UI_Data_Button.TYPE;
		}
		
		
		public override function CreateCtrlInfo(type:String, name:String=null):XDG_UI_Data
		{
			
			var control:XDG_UI_Data_Button = new XDG_UI_Data_Button();
			if(name != null)
			{
				control.name = name;
			}
			else
			{
				control.name = "unname-button_"+ CTimerUtils.getCurrentTime();
			}
			
			return control;
		}
		public override function CreateViewControl(controlinfo:XDG_UI_Data,_callback:Function):void
		{
			
			var _ctrl:XDG_UI_Control = new XDG_UI_Button();
			_ctrl.LoadProperty(controlinfo);
			_callback(controlinfo,_ctrl);
		}
		
		
	}
}