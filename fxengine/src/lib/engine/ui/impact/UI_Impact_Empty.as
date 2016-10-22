package lib.engine.ui.impact
{
	/**
	 * 空闲时间影响器
	 * 直接设置 lefttime
	 * @author caihua
	 * 
	 */
	public class UI_Impact_Empty extends UI_Impact
	{
		public function UI_Impact_Empty()
		{
			super();
		}
		
		override protected function _onInit():void
		{
			// TODO Auto Generated method stub
			this.autodelete = true;
			super._onInit();
		}
	}
}