package lib.engine.ui.uicontrols.builder
{
	import lib.engine.iface.IResource;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.data.controls.XDG_UI_Data_MC;
	import lib.engine.ui.uicontrols.XDG_UI_Control;
	import lib.engine.ui.uicontrols.XDG_UI_MC;
	import lib.engine.utils.CTimerUtils;
	
	/**
	 * MC基础构造器 
	 * @author caihua
	 * 
	 */
	public class XDG_UI_Builder_MC extends XDG_UI_Builder
	{
		public function XDG_UI_Builder_MC(IResourceBuilder:IResource)
		{
			super(IResourceBuilder);
		}
		
		public override function Builder_valid(type:String):Boolean
		{
			
			return type == XDG_UI_Data_MC.TYPE;
		}
		
		
		public  override function CreateCtrlInfo(type:String, name:String=null):XDG_UI_Data
		{
			
			var control:XDG_UI_Data_MC = new XDG_UI_Data_MC();
			if(name != null)
			{
				control.name = name;
			}
			else
			{
				control.name = "unname-mc_"+CTimerUtils.getCurrentTime();
			}
			return control;
		}
		
		public override function CreateViewControl(controlinfo:XDG_UI_Data,_callback:Function):void
		{
			
			var _ctrl:XDG_UI_Control = new XDG_UI_MC();
			_ctrl.LoadProperty(controlinfo);
			_callback(controlinfo,_ctrl);
		}

	}
}