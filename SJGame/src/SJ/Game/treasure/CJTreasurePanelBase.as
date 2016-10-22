package SJ.Game.treasure
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_Treasure;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.display.Shape;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵初始指引面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午5:51:39  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasurePanelBase extends SLayer
	{
		private var _buttonNameList:Array = ["GETTREASURE" , "GETTREASURE50" , "TRANSFERALL" , "SHOWSCORESHOP" , "PUTONTREASURE"];
		
		public function CJTreasurePanelBase()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			var bgBig:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waibiankuang1") , new Rectangle(10 , 10 , 3, 3)));
			bgBig.width = 470;
			bgBig.height = 273;
			this.addChild(bgBig);
			
			var bgSmall:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waibiankuang02") , new Rectangle(10 , 10 , 3, 3)));
			bgSmall.width = 400;
			bgSmall.height = 220;
			bgSmall.x = 33;
			bgSmall.y = 21;
			this.addChild(bgSmall);
			
			var line:SImage = new SImage(SApplication.assets.getTexture("common_fengetiao"));
			line.x = 35;
			line.y = 15;
			line.width = 400;
			this.addChild(line);
			
			for(var k:int = 0 ; k < 5 ; k++)
			{
				var button:Button = new Button();
				button.name = this._buttonNameList[k];
				button.label = CJTaskHtmlUtil.colorText(CJLang("TREASURE_BUTTON_"+button.name) , "#D5CDA1");
				button.labelFactory = textRender.standardTextRender;
				button.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu0"));
				button.downSkin = new SImage(SApplication.assets.getTexture("common_anniu1"));
				button.x = 36 + k *80;
				button.y = 240;
				button.addEventListener(Event.TRIGGERED , this._triggerHandler);
				button.labelOffsetY = -1;
				this.addChild(button);
			}
		}
		
		private function _triggerHandler(e:Event):void
		{
			if(e.target is Button)
			{
				var button:Button = e.target as Button;
//				获取灵丸
				if(button.name == this._buttonNameList[0])
				{
					SocketCommand_Treasure.getTreasure(1);
				}
//				获取50次
				else if (button.name == this._buttonNameList[1])
				{
					SocketCommand_Treasure.getTreasure(50);
				}
//				全部转化
				else if (button.name == this._buttonNameList[2])
				{
					
				}
//				显示积分商城界面
				else if (button.name == this._buttonNameList[3])
				{
					
				}
//				显示装备灵丸界面
				else
				{
					
				}
			}
		}
	}
}