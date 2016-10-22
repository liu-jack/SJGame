package SJ.Game.chat
{
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.richtext.CJRichText;
	
	/**
	 +------------------------------------------------------------------------------
	 * 翻页item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-26 上午10:02:36  
	 +------------------------------------------------------------------------------
	 */
	public class CJRichTextWrapper extends CJItemTurnPageBase
	{
		private var _richText:CJRichText;
		
		public function CJRichTextWrapper()
		{
			super("CJRichTextWrapper");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			_richText = new CJRichText(328);
			this.addChild(_richText);
		}
		
		override protected function canSelectItem():Boolean
		{
			return false;
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
			this.width = 330;
			this.height = _richText.height;
		}
	}
}