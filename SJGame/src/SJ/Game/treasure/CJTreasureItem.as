package SJ.Game.treasure
{
	import SJ.Game.data.CJDataOfTreasure;
	import SJ.Game.event.CJEvent;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.Events.MouseEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import flash.net.dns.AAAARecord;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵 - 灵丸组件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-3 上午11:13:57  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasureItem extends CJItemTurnPageBase
	{
		private var _treasure:CJDataOfTreasure;
		private var _nameLabl:CJTaskLabel;
		public function CJTreasureItem()
		{
			super("CJTreasureItem");
		}
		
		override protected function initialize():void
		{
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			var bg:SImage = new SImage(SApplication.assets.getTexture("juling_tubiaokuang"));
			bg.width = 40;
			bg.height = 40;
			this.addChild(bg);
			
			_nameLabl = new CJTaskLabel();
			_nameLabl.fontColor = 0xFFDC64;
			_nameLabl.fontSize = 9;
			_nameLabl.text = "";
			_nameLabl.x = 0;
			_nameLabl.y = 27;
			this.addChild(_nameLabl);
			
			//			todo 图标
		}
		
		override protected function draw():void
		{
			super.draw();
			_treasure = this.data as CJDataOfTreasure;
			_nameLabl.text = CJLang("ITEM_NAME_"+_treasure.treasureConfig.templateid);
		}
		
		override protected function onSelected():void
		{
				trace(CJLang("ITEM_NAME_"+_treasure.treasureConfig.templateid));
		}
	}
}