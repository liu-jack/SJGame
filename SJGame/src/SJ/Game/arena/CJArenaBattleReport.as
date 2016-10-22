package SJ.Game.arena
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class CJArenaBattleReport extends SLayer
	{
		public function CJArenaBattleReport()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			this.setSize(411,211)
			var bg:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi"),new Rectangle(19,19,1,1))	
			var img:Scale9Image = new Scale9Image(bg);
			img.width = 411
			img.height = 211
			this.addChild(img)
			
			var frame:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tankuangwenzidi"),new Rectangle(11,11,2,2));
			var frameimg:Scale9Image = new Scale9Image(frame)
			frameimg.width = 401
			frameimg.height = 185
			frameimg.x = 5
			frameimg.y = 23
			this.addChild(frameimg)
			
			var fengexian:SImage = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"))
			fengexian.x = 61;
			fengexian.y = 13
			this.addChild(fengexian)
			
			var fengexian2:SImage = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"))
			fengexian2.scaleX = -1
			fengexian2.x = 350;
			fengexian2.y = 13
			this.addChild(fengexian2)
				
			var rankTitleText:Label = new Label
			rankTitleText.textRendererProperties.textFormat = ConstTextFormat.arenaranktitle
			rankTitleText.text = CJLang("ARENA_REPORT_PERSONAL")
			rankTitleText.x = 169;
			rankTitleText.y = 6
			this.addChild(rankTitleText);
			
			var btn:Button = new Button();
			btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			btn.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			btn.addEventListener(Event.TRIGGERED , this._closePanel);
			btn.x = 387;
			btn.y = -18;
			this.addChild(btn);
		}
		
		public function update(data:Object):void
		{
			var j:int = 0
			for(var i:String in data)
			{
				var item:CJArenaRecordItem = new CJArenaRecordItem
					item.update(data[i]);
					item.x = 13
					item.y = 37+j*(21)
				this.addChild(item)
				j++;
			}
		}
		
		private function _closePanel(e:Event):void
		{
			this.removeFromParent(true);
		}
	}
}