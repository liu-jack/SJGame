package SJ.Game.Notice
{
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.richtext.CJRichText;
	
	/**
	 +------------------------------------------------------------------------------
	 * 公告的每个item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-09 上午10:02:36  
	 +------------------------------------------------------------------------------
	 */
	public class CJNoticeItem extends CJItemTurnPageBase
	{
		private var _richText:CJRichText;
		
		public function CJNoticeItem()
		{
			super("CJNoticeItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			_richText = new CJRichText(300);
			this.addChild(_richText);
		}
		
		override protected function draw():void
		{
			super.draw();
			var itemList:Array = this._data as Array;
			if(!itemList || itemList.length == 0 )
			{
				return;
			}
			_richText.draWithElementArray(itemList);
			this.width = 300;
			this.height = _richText.height;
		}
	}
}