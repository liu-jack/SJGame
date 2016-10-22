package lib.engine.ui.uicontrols
{
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventVar;
	import lib.engine.ui.data.controls.XDG_UI_Data_Tooltips;
	import lib.engine.ui.impact.UI_Impact;
	import lib.engine.ui.impact.UI_Impact_fade_In;

	public class XDG_UI_Tooltip extends XDG_UI_Label
	{
		public function XDG_UI_Tooltip()
		{
			super();
			
		}
		
		override protected function _onInit_ui():void
		{
			
			super._onInit_ui();
			var tooltipdata:XDG_UI_Data_Tooltips = new XDG_UI_Data_Tooltips();
			tooltipdata.name = "testtooltip";
			LoadProperty(tooltipdata);
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
		}
		
		/**
		 * 显示Tooptip 
		 * @param fadetime
		 * 
		 */
		public function ShowToolTip(fadetime:Number):void
		{
			this.impact.AddImpact(new UI_Impact_fade_In(fadetime));
			this.visible = true;
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,0.70);
			this.graphics.drawRoundRect(0,0,this._textfield.textWidth + 4,this._textfield.textHeight + 2,10);
			this.graphics.endFill();
			
		}
		
		public function CloseTooltip(fadetime:Number):void
		{
			this.impact.removeAllImpact();
			var impact:UI_Impact = new UI_Impact_fade_In(fadetime,1,0);
			impact.addEventListener(CEventVar.E_UI_IMPACT_END,
				function e(e:CEvent):void
				{
					this.visible = false;
				}
			);
			this.impact.AddImpact(impact);
		}
		
		
	}
}