package SJ.Game.arena
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_arena;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.controls.CJTimerUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfArenaAwardProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.json.Json_arena_award_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 *  副本信息显示界面
	 * @author yongjun
	 * 
	 */
	public class CJArenaLayer extends SLayer
	{
		public function CJArenaLayer()
		{
			super();
			this.setSize(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight);
			_init()
		}
		private var _itemList:Vector.<CJArenaPlayerBaseItem> = new Vector.<CJArenaPlayerBaseItem>
		private function _init():void
		{
			_drawQuads();
			_initBg();
			_initContent();
			_initButtons();
			_initBases();
			_initData();
			_initBattleStart();
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		private function _initBg():void
		{
			//界面底图
			var bgFrame:Scale9Image = new Scale9Image(new  Scale9Textures(SApplication.assets.getTexture("common_wujiangxuanzedi"),new Rectangle(14,14,1,1)));
			bgFrame.width = Starling.current.stage.stageWidth
			bgFrame.height = Starling.current.stage.stageHeight;
			this.addChildAt(bgFrame,0);
			//面板上面的横底
			var topBg:Quad = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0x16221c);
			this.addChild(topBg)
			//面板最上的横条
			var topImage:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			topImage.width = SApplicationConfig.o.stageWidth;
			this.addChild(topImage);
			
			//金币，银币，声望 背景
			var moneyBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_fanyeyemawenzidi"),new Rectangle(8,8,2,2)));
			moneyBg.width = 219;
			moneyBg.height = 25;
			moneyBg.x = 2;
			moneyBg.y = 16;
			this.addChild(moneyBg);
			
			var moneyBgFrame:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tanchuagnzhuangshi"),new Rectangle(8,7,2,2)));
			moneyBgFrame.width = 212;
			moneyBgFrame.height = 18;
			moneyBgFrame.x = 6;
			moneyBgFrame.y = 20;
			this.addChild(moneyBgFrame);
			
			var arenaBgImage:SImage = new SImage(SApplication.assets.getTexture("jingjichang_ditu"))
			arenaBgImage.x = 7;
			arenaBgImage.y = 52;
			arenaBgImage.scaleX = arenaBgImage.scaleY = 2;
			this.addChild(arenaBgImage)
			//边框花纹
			var panelFrame:CJPanelFrame = new CJPanelFrame(475,267);
			panelFrame.x = 2
			panelFrame.y = 48;
			this.addChild(panelFrame)
			
			//下面内容边框
			var contentFrame:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew"),new Rectangle(15 , 15 , 1, 1)));
			contentFrame.width = Starling.current.stage.stageWidth
			contentFrame.height = 275;
			contentFrame.y = 45;
			this.addChild(contentFrame);
			
			var leftNumbg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("jingjichang_wenzidi"),new Rectangle(6,6,1,1)));
			leftNumbg.width = 67;
			leftNumbg.height = 16
			leftNumbg.x = 81;
			leftNumbg.y = 275
			this.addChild(leftNumbg);
			
			var timecolddownbg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("jingjichang_wenzidi"),new Rectangle(6,6,1,1)));
			timecolddownbg.width = 67;
			timecolddownbg.height = 16;
			timecolddownbg.x = 328;
			timecolddownbg.y = 275;
			this.addChild(timecolddownbg);
		}
		
		//玩家信息
		private var _goldLabel:Label
		private var _silverLabel:Label
		private var _creditLabel:Label
		
		//奖励信息
		private var _awardSilverLabel:Label
		private var _awardCreditLabel:Label
		private var _awardExpLabel:Label
		//上轮排名
		private var _lastRankText:Label
		//领奖冷却
		private var _awardCDText:Label
		private var _awardCDTimeLabel:CJTimerUtil
		
		//右下侧信息
		private var _leftNumLabel:Label
		private var _colddownTimeLabel:CJTimerUtil
		private var _rewardBtn:Button 
		//最近战绩
		private var _latestrecord:Label
		private var _reporttxtlabel:Label
		private var _reportrecord:Label
		//
		private var _rankImage:SImage
		
		//战斗UI显示用 
		private var _targetInfo:Object;
		private function _initContent():void
		{
			/******* 标头基础信息 **************************/
			//title
			var title:CJPanelTitle = new CJPanelTitle(CJLang("ARENA_TITLE_NAME"))
				title.x = 91
				title.y = 0
				this.addChild(title)
			//元宝图标
			var goldImage:SImage = new SImage(SApplication.assets.getTexture("common_yuanbao"))
			goldImage.x = 15;
			goldImage.y = 25;
			this.addChild(goldImage);
			//银两图标
			var silverImage:SImage = new SImage(SApplication.assets.getTexture("common_yinliang"))
			silverImage.x = 78;
			silverImage.y = 25;
			this.addChild(silverImage);
			//声望图标
			var creditImage:SImage = new SImage(SApplication.assets.getTexture("jingjichang_tubiaoshengwang"));
			creditImage.x = 159
			creditImage.y = 20;
			this.addChild(creditImage);
			//排名图标
			_rankImage = new SImage(SApplication.assets.getTexture("jingjichang_tubiao"))
			_rankImage.name = "rank"
			_rankImage.addEventListener(TouchEvent.TOUCH,touchHandler);
			_rankImage.x = 155
			_rankImage.y = 72
			this.addChild(_rankImage)
				
			//银两图标
			var silverImage2:SImage = new SImage(SApplication.assets.getTexture("common_yinliang"))
			silverImage2.x = 190;
			silverImage2.y = 82;
			this.addChild(silverImage2);
			//声望图标
			var creditImage2:SImage = new SImage(SApplication.assets.getTexture("jingjichang_tubiaoshengwang"));
			creditImage2.width = creditImage2.height = 14;
			creditImage2.x = 261
			creditImage2.y = 82;
			this.addChild(creditImage2);
			//经验图标
			var expImage2:SImage = new SImage(SApplication.assets.getTexture("exp"));
//			expImage2.width = expImage2.height = 14;
			expImage2.x = 330
			expImage2.y = 82;
			this.addChild(expImage2);
			
			_goldLabel = new Label;
			_goldLabel.textRendererProperties.textFormat = ConstTextFormat.arenaMoneyFormat
			_goldLabel.x = 37;
			_goldLabel.y = 23;
			this.addChild(_goldLabel);
			
			_silverLabel = new Label;
			_silverLabel.textRendererProperties.textFormat = ConstTextFormat.arenaMoneyFormat
			_silverLabel.x = 103
			_silverLabel.y = 23;
			this.addChild(_silverLabel)
			
			_creditLabel = new Label
			_creditLabel.textRendererProperties.textFormat = ConstTextFormat.arenaMoneyFormat
			_creditLabel.x = 177
			_creditLabel.y = 23
			this.addChild(_creditLabel)
				
			_awardSilverLabel = new Label
			_awardSilverLabel.textRendererProperties.textFormat = ConstTextFormat.arenaAwardFormat
			_awardSilverLabel.x = 210;
			_awardSilverLabel.y = 82;
			this.addChild(_awardSilverLabel);
				
			_awardCreditLabel = new Label
			_awardCreditLabel.textRendererProperties.textFormat = ConstTextFormat.arenaAwardFormat;
			_awardCreditLabel.x = 284;
			_awardCreditLabel.y = 82;
			this.addChild(_awardCreditLabel);
				
			_awardExpLabel = new Label;
			_awardExpLabel.textRendererProperties.textFormat = ConstTextFormat.arenaAwardFormat;
			_awardExpLabel.x = 365;
			_awardExpLabel.y = 82;
			this.addChild(_awardExpLabel);
			
			_lastRankText = new Label;
			_lastRankText.textRendererProperties.textFormat = ConstTextFormat.arenarankwhite
			_lastRankText.x = 281;
			_lastRankText.y = 24;
			_lastRankText.text = CJLang("ARENA_RANK_TEXT")
			_lastRankText.visible = false;
			this.addChild(_lastRankText);
			
			/************* 领奖冷却 ********/			
			_awardCDText = new Label
			_awardCDText.textRendererProperties.textFormat = ConstTextFormat.arenarankwhite
			_awardCDText.x = 334
			_awardCDText.y = 25
			_awardCDText.text = CJLang("ARENA_AWARD_CDTIME")
			_awardCDText.visible = false;
			this.addChild(_awardCDText);
			
			_awardCDTimeLabel = new CJTimerUtil
			_awardCDTimeLabel.x = 395
			_awardCDTimeLabel.y = 25
			_awardCDTimeLabel.visible = false;
			this.addChild(_awardCDTimeLabel)
			/************* 领奖冷却 ********/	
			
			
			/********************* 右下侧信息 ***************/
			var battleNums:Label = new Label
			battleNums.textRendererProperties.textFormat = ConstTextFormat.arenainfolatesttxt
			battleNums.x = 20;
			battleNums.y = 275;
			battleNums.text = CJLang("ARENA_BATTLE_NUMS")
			this.addChild(battleNums);
			
			var battleCd:Label = new Label
			battleCd.textRendererProperties.textFormat = ConstTextFormat.arenainfolatesttxt
			battleCd.x = 265;
			battleCd.y = 275;
			battleCd.text = CJLang("ARENA_BATTLE_CDS")
			this.addChild(battleCd);
				
			_leftNumLabel = new Label;
			_leftNumLabel.textRendererProperties.textFormat = ConstTextFormat.arenaBattleFormat
			_leftNumLabel.x = 96;
			_leftNumLabel.y = 275;
			this.addChild(_leftNumLabel);
				
			_colddownTimeLabel = new CJTimerUtil;
			_colddownTimeLabel.x = 340;
			_colddownTimeLabel.y = 275;
			this.addChild(_colddownTimeLabel)
				
			/********************* 右下侧信息 ***************/	
			//最近战绩
			var latestBattleReports:Label = new Label;
			latestBattleReports.x = 20
			latestBattleReports.y = 293
			latestBattleReports.textRendererProperties.textFormat = ConstTextFormat.arenainfolatesttxt
			latestBattleReports.text = CJLang("ARENA_LATEST_BATTLEREPORTS");
			this.addChild(latestBattleReports);
			
			_latestrecord = new Label
			_latestrecord.textRendererFactory = function ():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.textFormat = ConstTextFormat.arenainforeport;
				_htmltextRender.isHTML = true;
				return _htmltextRender
			}
			_latestrecord.x = 84;
			_latestrecord.y = 293;
			this.addChild(_latestrecord)
				
			_reporttxtlabel = new Label
			_reporttxtlabel.visible = false;
			_reporttxtlabel.name = "report"
			_reporttxtlabel.textRendererProperties.textFormat = ConstTextFormat.arenainforeporttxt
			_reporttxtlabel.addEventListener(TouchEvent.TOUCH,touchHandler);
			_reporttxtlabel.text = CJLang("ARENA_REPORT_TEXT")
			_reporttxtlabel.x = 288
			_reporttxtlabel.y = 293
//			this.addChild(_reporttxtlabel)
			
			//查看个人
			_reportrecord = new Label
			_reportrecord.textRendererProperties.textFormat = ConstTextFormat.arenareportrecord
			_reportrecord.addEventListener(TouchEvent.TOUCH,touchHandler)
			_reportrecord.name = "record"
			_reportrecord.text = CJLang("ARENA_REPORT_LINKTEXT")
			_reportrecord.x = 288
			_reportrecord.y = 293
			this.addChild(_reportrecord)
		}
		
		private function _initButtons():void
		{
			var closeBtn:Button = new Button
			closeBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			closeBtn.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			closeBtn.x = Starling.current.stage.stageWidth - 42
			closeBtn.y = 0
			closeBtn.addEventListener(Event.TRIGGERED,closeHandler);
			this.addChild(closeBtn)
			//竞技榜
			var jButton:Button = CJButtonUtil.createJingjiBangButton();
			jButton.name = "rank"
			jButton.addEventListener(Event.TRIGGERED,clickHandler);
			jButton.x = 122
			jButton.y = 45;
			this.addChild(jButton);
			
			//连胜榜
			var lButton:Button = CJButtonUtil.createLianShenBangButton();
			lButton.name = "last"
			lButton.addEventListener(Event.TRIGGERED,clickHandler);
			lButton.x = 241;
			lButton.y = 45;
			this.addChild(lButton);
			
			//增加次数
			var awardBtn:Button = CJButtonUtil.createYellowSmallButton(CJLang("ARENA_ADDNUMBTN_TEXT"))
			awardBtn.name = "addnum"
			awardBtn.addEventListener(Event.TRIGGERED,clickHandler);
			awardBtn.x = 153
			awardBtn.y = 273
			this.addChild(awardBtn)
			//结束冷却
			var addNumBtn:Button = CJButtonUtil.createYellowSmallButton(CJLang("ARENA_ENDCDBTN_TEXT"))
			addNumBtn.addEventListener(Event.TRIGGERED,clickHandler);
			addNumBtn.name = "endcd"
			addNumBtn.x = 407
			addNumBtn.y = 273
			this.addChild(addNumBtn);
			//领取按钮
			_rewardBtn = CJButtonUtil.createCommonButton(CJLang("AREBA_AWARDBTN_TEXT"))
			_rewardBtn.labelOffsetY = -1;
			_rewardBtn.addEventListener(Event.TRIGGERED,clickHandler);
			_rewardBtn.name = "award"
			_rewardBtn.x = 365
			_rewardBtn.y = 18;
			_rewardBtn.visible = false;
			this.addChild(_rewardBtn)
		}
		
		private function _initBases():void
		{
			for(var i:int=0;i<6;i++)
			{
				var baseItem:CJArenaPlayerBaseItem = new CJArenaPlayerBaseItem;
				baseItem.x = 12+i*(75+2);
				baseItem.y = 240;
				var own:CJArenaLayer = this;
				if(i>0)
				{
					baseItem.addEventListener(TouchEvent.TOUCH,function(e:TouchEvent):void
					{
						var touch:Touch = e.getTouch(own,TouchPhase.BEGAN)
						if(touch)
						{
							
							//处理指引
							if(CJDataManager.o.DataOfFuncList.isIndicating)
							{
								CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
							}
							
							var item:CJArenaPlayerBaseItem = e.currentTarget as CJArenaPlayerBaseItem
							var arenaPlayer:CJArenaPlayerItem = (e.currentTarget as CJArenaPlayerBaseItem).player;
							
							var content:CJArenaBattleConfirmContent = new CJArenaBattleConfirmContent

							var awardObj:Json_arena_award_setting = getAwardByRankId(item.rankNum)
							var failAwardObj:Json_arena_award_setting = getAwardByRankId(_myarenaInfo.rankid)
							content.updateData(awardObj,failAwardObj)

							content.x = (Starling.current.stage.stageWidth - content.width)>>1;
							content.y = (Starling.current.stage.stageHeight - content.height)>>1;
							content.callBack = function():void
							{
								_targetInfo = item.player.userInfo;
								SApplication.moduleManager.enterModule("CJFormationModule",{"arenauid":item.player.uid});
							}
							CJLayerManager.o.addToModal(content);
							content.reSize(250,160);
							content.updateTitle(arenaPlayer.roleName);
						}
					});
				}
				this.addChild(baseItem);
				_itemList.push(baseItem)
			}
		}
		private function _onSocketBattleStart(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage
			if(msg.getCommand() == ConstNetCommand.CS_ARENA_BATTLE)
			{
				var retCode:int = msg.retcode
				if(retCode!=0)
				{
					switch(retCode)
					{
						case 1:
							CJMessageBox(CJLang("ARENA_BATTLE_NONUMS"));
							break;
						case 2:
							CJMessageBox(CJLang("ARENA_BATTLE_CDTIMESEND"));
							break;
					}
					return;
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketBattleStart);
				SApplication.moduleManager.exitModule("CJArenaModule");
				SApplication.moduleManager.enterModule("CJArenaBattleModule",{"battleret":msg.retparams, "targetinfo":_targetInfo});
			}
		}
		private function _initBattleStart():void
		{
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketBattleStart);
		}
		
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if(touch)
			{
				var dis:DisplayObject = e.currentTarget as DisplayObject
				switch(dis.name)
				{
					case "rank":
						var tipLayer:CJArenaTreasureTip = new CJArenaTreasureTip
						CJLayerManager.o.addModuleLayer(tipLayer)
						break;
					case "report":
						if(this._reportid.length>0)
						{
							SocketCommand_arena.report(this._reportid)
						}
						break;
					case "record":
						SocketCommand_arena.getrecord()
						break;
				}

			}
		}
		
		private function clickHandler(e:Event):void
		{
			switch((e.currentTarget as Button).name)
			{
				case "addnum":
					var confirmStr:String = CJLang("ARENA_CONFIRM_BUYCHANCE");
					var costParams:int = int(CJDataOfGlobalConfigProperty.o.getData("DAY_BUYCHALLENGE_COST"));//购买系数
					var costMax:int  = int(CJDataOfGlobalConfigProperty.o.getData("DAY_BUYCHALLENGE_COSTMAX"));//购买花费上限
					SocketManager.o.callwithRtn(ConstNetCommand.CS_ARENA_GETBUYTIMES,function(message:SocketMessage):void
					{
						currentBuyTime = int(message.retparams)
						//计算花费金额
						var cost:int = (currentBuyTime) * costParams;
						cost = cost > costMax ? costMax : cost;
						
						confirmStr = confirmStr.replace("{cost}", cost);
						CJConfirmMessageBox(confirmStr, function():void{
							SocketCommand_arena.buyChallegeChance(1);
						})
					})

					break;
				case "endcd":
					var confirmstr:String = CJLang("ARENA_CONFIRM_CLEARCD");
					confirmstr = confirmstr.replace("{cost}",CJDataOfGlobalConfigProperty.o.getData("ARENA_CLEARCD_COST"))
					CJConfirmMessageBox(confirmstr,function():void{
						SocketCommand_arena.clearCD();
					})
					break;
				case "rank":
					SocketCommand_arena.getRank()
					break;
				case "last":
					
					break;
				case "award":
					SocketCommand_arena.reward();
					break;
			}
		}
		
		public function _initData():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,dataRet);
			SocketCommand_arena.getInfo();
		}
		/**
		 * 服务器返回处理 
		 * @param e
		 * 
		 */		
		private function dataRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_ARENA_GETINFO)
			{
				getInfoRet(message);
			}
			if(message.getCommand() == ConstNetCommand.CS_ARENA_BUYCHALLENGECHANCE)
			{
				addNumRet(message);
			}
			if(message.getCommand() == ConstNetCommand.CS_ARENA_CLEARCDTIME)
			{
				clearCDRet(message);
			}
			if(message.getCommand() == ConstNetCommand.CS_ARENA_GETRNAK)
			{
				showRank(message);
			}
			if(message.getCommand() == ConstNetCommand.CS_ARENA_GETRECORD)
			{
				showRecord(message);
			}
			if(message.getCommand() == ConstNetCommand.CS_ARENA_REWARD)
			{
				reward(message);
			}
			if(message.getCommand() == ConstNetCommand.CS_ARENA_REPORT)
			{
				report(message);
			}
			if(message.getCommand() == ConstNetCommand.CS_ARENA_CHECKTIME)
			{
				_resetAwardInfo(message.retparams);
			}
			if(message.getCommand() ==ConstNetCommand.CS_ROLE_GET_ROLE_INFO)
			{
				_resetBaseInfo()
			}
			
		}
		
		/**
		 * 清除CD 
		 * @param data
		 * 
		 */		
		private function clearCDRet(data:Object):void
		{
			if(data.retcode !=0)
			{
				switch(data.retcode)
				{
					case 1:
						CJMessageBox(CJLang("ERROR_HEROTAG_GOLD"))
						break;
				}
				return;
			}
			_colddownTimeLabel.stop();
			_colddownTimeLabel.labelTextForamt = ConstTextFormat.arenaRetFormat;
			SocketCommand_role.get_role_info()

		}
		
		//当前购买次数
		private var currentBuyTime:int;
		
		/**
		 * 增加次数 
		 * @param data
		 * 
		 */		
		private function addNumRet(data:Object):void
		{
			if(data.retcode !=0)
			{
				switch(data.retcode)
				{
					case 1:
						CJMessageBox(CJLang("ARENA_HASMAX_LEFTTIMES"))
						break;
					case 2:
						CJMessageBox(CJLang("ERROR_HEROTAG_GOLD"))
						break;
				}
				return;
			}
			
			var leftNum:int = int(data.retparams);
			updateTimeStr(leftNum);
			SocketCommand_role.get_role_info()
			
			var toadyNumTip:String = CJLang("ARENA_TODAYNUMTIP_TEXT");
			toadyNumTip = toadyNumTip.replace("{num}", currentBuyTime);
			new CJTaskFlowString(toadyNumTip, 1.5, 30).addToLayer();//飘字
		}
		
		private function showRank(data:Object):void
		{
			var rankLayer:CJArenaRank = new CJArenaRank;
			rankLayer.updateData(data.retparams)
			CJLayerManager.o.addModuleLayer(rankLayer)
		}
		private function showRecord(data:Object):void
		{
			var recordLayer:CJArenaBattleReport = new CJArenaBattleReport
			recordLayer.update(data.retparams)
			CJLayerManager.o.addModuleLayer(recordLayer)
		}
		
		private function reward(data:Object):void
		{
			if(data.retcode !=0)
			{
				switch(data.retcode)
				{
					case 1:
						CJMessageBox(CJLang("ARENA_NOAWARD_DO"))
						break;
				}
				return;
			}
			_resetAwardInfo(data.retparams)
			SocketCommand_role.get_role_info()
			SocketCommand_hero.get_heros();
			var tips:String = CJLang("ARENA_AWARD_TEXT",{"silver":data.retparams['silver'],"credit":data.retparams['credit'],"exp":data.retparams['exp']})
			CJFlyWordsUtil(tips)
		}
		
		private function report(data:Object):void
		{
			if(data.retcode !=0)
			{
				CJMessageBox(data.retcode)
				return;
			}
			SApplication.moduleManager.exitModule("CJArenaModule");
			SApplication.moduleManager.enterModule("CJArenaBattleModule",{"battleret":[data.retparams]});
		}
		/**
		 * 基本信息返回 
		 * @param data
		 * 
		 */
		private function getInfoRet(data:Object):void
		{
			if(data.retcode != 0)
			{
				SApplication.moduleManager.exitModule("CJArenaModule");
				return;
			}
			
			var myArenaInfo:Object = data.retparams[0];
			var otherArenaInfo:Object = data.retparams[1];
			
			//保存已购买的次数
			currentBuyTime = myArenaInfo.countbuytimes;
			
			//更新金钱等基本信息
			updateBaseInfo(myArenaInfo);
			
			var j:int = 1;
			for (var i:String in otherArenaInfo)
			{
				var data:Object = {};
				data.userid = otherArenaInfo[i].userid;
				data.templateId = otherArenaInfo[i].template;
				data.level = otherArenaInfo[i].level;
				data.battlelevel = otherArenaInfo[i].battleeffectsum;
				data.rolename = otherArenaInfo[i].rolename;
				var playerItem:CJArenaPlayerItem = new CJArenaPlayerItem;
				playerItem.userInfo = data;
				var baseItem:CJArenaPlayerBaseItem = _itemList[j]
				baseItem.updateRankNum(otherArenaInfo[i].rankid)
				baseItem.addPlayer(playerItem);
				j++;
			}
		}
		
		override public function dispose():void
		{
			_colddownTimeLabel.stop();
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketBattleStart);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,dataRet);
			super.dispose();
		}
		
		
		/**
		 * @caihua  用于指引位置
		 */ 
		private function _drawQuads():void
		{
			var quadLayer:SLayer = new SLayer();
			quadLayer.touchable = false;
			quadLayer.visible = false;
			for(var i:int =0;i<= 5 ; i++)
			{
				var quad:Quad = new Quad(73 , 158 , 0xffffff);
				quad.alpha = 0 ;
				quad.x = 16 + i * 68;
				quad.y = 103;
				quadLayer.addChild(quad);
				quad.name = "CJArena_"+i;
			}
			this.addChild(quadLayer);
		}
		
		private function updateTimeStr(leftTime:int):void
		{
			var timesStr:String = CJLang("ARENA_LEFTTIMES");
			if(leftTime<=0)
			{
				_leftNumLabel.textRendererProperties.textFormat = ConstTextFormat.arenaBattleRedFormat;
			}
			else
			{
				_leftNumLabel.textRendererProperties.textFormat = ConstTextFormat.arenaRetFormat;
			}
			timesStr = timesStr.replace("{times}",leftTime);
			_leftNumLabel.text = timesStr;
		}
		/**
		 * 更新基本信息 
		 * 
		 */
		private var _reportid:String
		private var _myarenaInfo:Object
		private function updateBaseInfo(areanObj:Object):void
		{
			_myarenaInfo = areanObj
			_resetBaseInfo();
			var roleInfo:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole")
			var timesStr:String = CJLang("ARENA_LEFTTIMES");
			updateTimeStr(areanObj.lefttimes)

			_colddownTimeLabel.setTimeAndRun(areanObj.cdendtime,function():void
			{
				_colddownTimeLabel.labelTextForamt = ConstTextFormat.arenaRetFormat;
			})
			if(areanObj.iscolddown == 1)
			{
				_colddownTimeLabel.labelTextForamt = ConstTextFormat.arenaBattleRedFormat;
			}
			else
			{
				_colddownTimeLabel.labelTextForamt = ConstTextFormat.arenaRetFormat;
			}
			//更新领奖信息
			_resetAwardInfo(areanObj)
			//更新玩家自己信息
			var mydata:Object = {}
			var heroInfo:CJDataOfHeroList = CJDataManager.o.getData("CJDataOfHeroList")
			var mainHero:CJDataOfHero = heroInfo.getMainHero()
			mydata.userid = areanObj.uid
			mydata.templateId = mainHero.templateid
			mydata.level = mainHero.level
			mydata.battlelevel = mainHero.battleeffectsum
			mydata.rolename = roleInfo.name;
			var myPlayerItem:CJArenaPlayerItem = new CJArenaPlayerItem;
			myPlayerItem.userInfo = mydata
			var baseItem:CJArenaPlayerBaseItem = _itemList[0];
			baseItem.updateRankNum(areanObj.rankid);
			baseItem.addPlayer(myPlayerItem)

			//最近战绩,最后一场战斗战斗记录
			var txt:String
			if(areanObj.battlerecord)
			{
				if(areanObj.lastRecord.master==1)
				{
					if(areanObj.lastRecord.result == ConstBattle.BattleResultSuccess)
					{
						txt = CJLang("ARENA_REPORT_DETAIL")
						txt = txt.replace("{ranknum}",areanObj.lastRecord.rankid)
					}
					else
					{
						txt = CJLang("AREAN_REPORT_FAIL_DETAIL")
					}
				}
				else
				{
					if(areanObj.lastRecord.result == ConstBattle.BattleResultSuccess)
					{
						txt = CJLang("ARENA_SLAVEREPORT_FAIL_DETAIL")
					}
					else
					{
						txt = CJLang("ARENA_SLAVEREPORT_SUCC_DETAIL")
						txt = txt.replace("{ranknum}",areanObj.lastRecord.rankid)
					}
				}
				txt = txt.replace("{rolename}",areanObj.lastRecord.rolename)
				//战报ID
				_reportid = String(areanObj.lastRecord.reportid)
				_reporttxtlabel.visible = true;
				_latestrecord.text = txt;
			}
		}
		/**
		 * 更新基本信息 
		 * 
		 */		
		private function _resetBaseInfo():void
		{
			var roleInfo:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole")
			_goldLabel.text = String(roleInfo.gold);
			_silverLabel.text = String(roleInfo.silver);
			_creditLabel.text = String(roleInfo.credit);
		}
		
		private function checkAwardtime():void
		{
			SocketCommand_arena.checkawardtime()
		}
		/**
		 * 更新奖励信息 
		 * @param areanObj
		 * 
		 */		
		private function _resetAwardInfo(areanObj:Object):void
		{
			var awardObj:Json_arena_award_setting;
			if(int(areanObj.isaward) == 1)
			{
				_lastRankText.text = _lastRankText.text.replace("{ranknum}",areanObj.awardrankid)
				_lastRankText.visible = true;
				_rewardBtn.visible = true
				_awardCDText.visible = false;
				_awardCDTimeLabel.clear();
				_awardCDTimeLabel.visible = false;
				awardObj = getAwardByRankId(areanObj.awardrankid)
			}
			else
			{
				_lastRankText.visible = false;
				_rewardBtn.visible = false
				_awardCDText.visible = true;
				_awardCDTimeLabel.visible = true;
				_awardCDTimeLabel.setTimeAndRun(areanObj.awardtime,checkAwardtime)
				awardObj = getAwardByRankId(areanObj.rankid)
			}
			_awardSilverLabel.text = awardObj.silver;
			_awardCreditLabel.text = awardObj.credit;
			_awardExpLabel.text = awardObj.exp;
		}
		
		private function closeHandler(e:Event):void
		{
			SApplication.moduleManager.exitModule("CJArenaModule");
		}
		
		private function getAwardByRankId(rankId:int):Json_arena_award_setting
		{
			var config:Json_arena_award_setting = CJDataOfArenaAwardProperty.o.getPropertyById(rankId);
			return config
		}
		
		public function clear():void
		{
			_reportrecord.removeEventListener(TouchEvent.TOUCH,touchHandler)
			_rankImage.removeEventListener(TouchEvent.TOUCH,touchHandler);
			_reporttxtlabel.removeEventListener(TouchEvent.TOUCH,touchHandler);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,dataRet);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketBattleStart);
		}
		
	}
}