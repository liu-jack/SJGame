package SJ.Game.chat
{
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.richtext.CJRichText;
	
	/**
	 +------------------------------------------------------------------------------
	 * 富文本小组件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-13 下午14:13:22  
	 +------------------------------------------------------------------------------
	 */
	public class CJChatRichTextItem extends CJItemTurnPageBase
	{
		private var _id:int;
		private var _richText:CJRichText;
		private var _elementArray:Array;
		
		public function CJChatRichTextItem()
		{
			super("CJChatRichTextItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(data == null)
			{
				return;
			}
			const isAllInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isAllInvalid)
			{
				_richText.draWithElementArray(data as Array);
			}
		}
		
		override protected function onSelected():void
		{
			
		}
		
		private function drawContent():void
		{
			_richText = new CJRichText(322);
			_richText.x = 3;
			this.addChild(_richText);
		}
		
		public function currentHeight():Number
		{
			return _richText.height;
		}
	}
}