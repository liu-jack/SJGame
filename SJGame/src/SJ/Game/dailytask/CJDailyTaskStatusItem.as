package SJ.Game.dailytask
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_dailyTask;
	import SJ.Game.controls.CJTimerUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJPanelMessageBox;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 每日任务状态界面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-16 上午11:58:15  
	 +------------------------------------------------------------------------------
	 */
	public class CJDailyTaskStatusItem extends SLayer
	{
		private var button:Button;
		private var _remainTime:CJTimerUtil;
		private var _remainRefershCount:CJTaskLabel;
		private var _imdRefreshGold:CJTaskLabel;
		private var _totalCount:int = 10;

		private var _refreshRemainTimeT:CJTaskLabel;
		
		public function CJDailyTaskStatusItem()
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
			this._drawRectangBg();
			
			button = new Button();
			button.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			button.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			button.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			button.width = 95;
			button.height = 29;
			button.x = 324;
			button.y = 35;
			this.addChild(button);
			button.labelOffsetY = 1;
			button.addEventListener(Event.TRIGGERED , this._triggerHandler);
			var fontFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xffffff);
			button.defaultLabelProperties.textFormat = fontFormat;
			button.label = CJLang('DAILYTASK_IMDREFRESH');
			
			//各个label
			_refreshRemainTimeT = new CJTaskLabel();
			_refreshRemainTimeT.fontFamily = "黑体";
			_refreshRemainTimeT.fontSize = 10;
			_refreshRemainTimeT.fontColor = 0xffffff;
			_refreshRemainTimeT.x = 25;
			_refreshRemainTimeT.y = 15;
			this.addChild(_refreshRemainTimeT);
			_refreshRemainTimeT.text = CJLang("DAILYTASK_REFRESHLABEL");
			
			_remainTime = new CJTimerUtil();
			var tf:TextFormat = new TextFormat();
			tf.font = "黑体";
			tf.size = 10;
			tf.color = 0x98FF42;
			_remainTime.labelTextForamt = tf;
			_remainTime.x = 114;
			_remainTime.y = 15;
			this.addChild(_remainTime);
			
			var remainCountT:CJTaskLabel = new CJTaskLabel();
			remainCountT.fontFamily = "黑体";
			remainCountT.fontSize = 10;
			remainCountT.fontColor = 0xffffff;
			remainCountT.x = 25;
			remainCountT.y = 40;
			this.addChild(remainCountT);
			remainCountT.text = CJLang("DAILYTASK_REMAINREFRESHCOUNT");
			
			_remainRefershCount = new CJTaskLabel();
			_remainRefershCount.fontFamily = "黑体";
			_remainRefershCount.fontSize = 10;
			_remainRefershCount.fontColor = 0xFD8B00;
			_remainRefershCount.x = 125;
			_remainRefershCount.y = 40;
			_remainRefershCount.fontSize = 10;
			this.addChild(_remainRefershCount);
			
			_imdRefreshGold = new CJTaskLabel();
			_imdRefreshGold.fontFamily = "黑体";
			_imdRefreshGold.fontSize = 10;
			_imdRefreshGold.fontColor = 0xFD8B00;
			_imdRefreshGold.x = 311;
			_imdRefreshGold.y = 13;
			_imdRefreshGold.fontSize = 10;
			this.addChild(_imdRefreshGold);
			
			_totalCount = int(CJDataOfGlobalConfigProperty.o.getData('dailytask_refresh_count'));
		}
		
		/**
		 * 点击按钮
		 */		
		private function _triggerHandler(e:Event):void
		{
			//判断有木有钱
			var needGold:Number = int(CJDataOfGlobalConfigProperty.o.getData('dailytask_refresh_gold'));
			var gold:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).gold;
			if(gold < needGold)
			{
				CJPanelMessageBox(CJLang("ITEM_MAKE_RESULT_STATE_LACK_GOLD"));
			}
			else
			{
				CJConfirmMessageBox(CJLang('DAILYTASK_IMDREFRESHGOLD' , {"value":CJDataOfGlobalConfigProperty.o.getData('dailytask_refresh_gold')}) , function():void
				{
					SocketCommand_dailyTask.imdRefresh();
				});
			}
		}
		
		//矩形框
		private function _drawRectangBg():void
		{
			//背景色
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_renwu_wenzidi") , new Rectangle(8 , 8 , 1, 1)));
			bg.width = 450;
			bg.height = 74;
			this.addChild(bg);
		}
		
		override protected function draw():void
		{
			super.draw();
			_imdRefreshGold.text = CJLang('DAILYTASK_IMDREFRESHGOLD' , {"value":CJDataOfGlobalConfigProperty.o.getData('dailytask_refresh_gold')});
			
			_remainRefershCount.text = ""+Math.max(0,(_totalCount - int(CJDataManager.o.DataOfDailyTask.refreshcount)))+"/"+ _totalCount;
			if(_totalCount - int(CJDataManager.o.DataOfDailyTask.refreshcount) <= 0)
			{
				button.isEnabled = false;
				_refreshRemainTimeT.visible = false;
				_remainTime.removeFromParent(true);
			}
			else
			{
				button.isEnabled = true;
				_refreshRemainTimeT.visible = true;
			}
			
			_remainTime.setTimeAndRun(CJDataManager.o.DataOfDailyTask.remainTime , function():void
			{
				CJDataManager.o.DataOfDailyTask.loadFromRemote();
			}
			);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}