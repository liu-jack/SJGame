package lib.engine.ui.Manager
{
	import flash.display.Sprite;
	
	import lib.engine.ui.uicontrols.XDG_UI_Control;
	import lib.engine.ui.uicontrols.XDG_UI_Tooltip;
	import lib.engine.utils.functions.Assert;

	/**
	 * Tooltip管理类 
	 * @author caihua
	 * 
	 */
	public class TooltipManager
	{
		private static var _ins:TooltipManager;
		/**
		 * Tooltip空间层 
		 */
		private var _parent:Sprite;
		private var _tooltip:XDG_UI_Tooltip;
		private var _tooltipedControl:XDG_UI_Control;
		
		public function TooltipManager()
		{
		}
		
		public static function get o():TooltipManager
		{
			if(_ins == null)
				_ins = new TooltipManager();
			return _ins;
		}
		
		/**
		 * 注册到图层 
		 * @param parent 注册到的图层
		 * 
		 */
		public function register(parent:Sprite):void
		{
			_parent = parent;
			_parent.mouseEnabled = false;
			_tooltip = new XDG_UI_Tooltip();

			_parent.addChild(_tooltip);
		}
		/**
		 * 显示Tooltip 
		 * @param text
		 * @param x
		 * @param y
		 * @param fadeIntime
		 * 
		 */
		public function showTip(text:String,x:int,y:int,fadeIntime:Number):void
		{
			Assert(_parent != null,"显示tooltip之前必须先注册");
			_tooltip.SetProperty("x",x);
			_tooltip.SetProperty("y",y);
			_tooltip.SetProperty("text",text);
			_tooltip.ShowToolTip(fadeIntime);
			
		}
		
		public function showTipByControl(mcontrol:XDG_UI_Control):void
		{
			if(_tooltipedControl != null && _tooltipedControl == mcontrol)
			{
				
			}
		}
		
		public function closeTip(fadeOutTime:Number):void
		{
			_tooltip.CloseTooltip(fadeOutTime);
		}
	}
}