package SJ.Game.arena
{
	import SJ.Game.data.config.CJDataOfArenaProperty;
	import SJ.Game.data.json.Json_arena_box_setting;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.display.Shape;
	import starling.events.Event;
	
	
	/**
	 +------------------------------------------------------------------------------
	 * 竞技场 宝箱tip列表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-7-13 上午11:29:18  
	 +------------------------------------------------------------------------------
	 */
	public class CJArenaTreasureTip extends SLayer
	{
		private var bg:Shape;
		private var ITEMWIDTH:Number = 290;
		private var ITEMHEIGHT:Number = 295;
		
		public function CJArenaTreasureTip()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
		}
		
		private function drawContent():void
		{
			this.width = ITEMWIDTH;
			this.height = ITEMHEIGHT;
			this._drawRectangBg();
			this._drawItemList();
			this._drawButton()
		}
		
		private function _drawButton():void
		{
			var btn:Button = new Button();
			btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			btn.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			btn.addEventListener(Event.TRIGGERED , this._closePanel);
			btn.x = ITEMWIDTH - 12;
			btn.y = -20;
			this.addChild(btn);
		}
		
		private function _closePanel(e:Event):void
		{
			this.removeFromParent(true);
		}
		
		private function _drawItemList():void
		{
			var configList:Array = CJDataOfArenaProperty.o.getAllTreasureList();
			for(var i:String in configList)
			{
				var item:CJAreanaTreasureItem = new CJAreanaTreasureItem(configList[i]);
				item.x = 0 ;
				item.y = int(i)*37;
				this.addChild(item);
			}
		}
		
		//矩形框
		private function _drawRectangBg():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_fanyeyemawenzidi") , new Rectangle(8,8,1,1)));
			bg.width = ITEMWIDTH + 10;
			bg.height = ITEMHEIGHT + 10;
			this.addChild(bg);
		}
	}
}