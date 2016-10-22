package SJ.Game.moneytree
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_moneytree;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfMoneyTreeMine;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfMoneyTreeProperty;
	import SJ.Game.data.json.Json_money_tree_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 装备强化layer
	 * @author sangxu
	 * 
	 */	
	public class CJMoneyTreeHarvestOperate extends SLayer
	{
		public function CJMoneyTreeHarvestOperate()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 摇钱树配置数据 */
		private var _moneyTreeConfig:CJDataOfMoneyTreeProperty;
		
		/** 数据 - 我的摇钱树 */
		private var _dataMTMine:CJDataOfMoneyTreeMine;
		/** 数据 - 玩家数据 */
		private var _dataRole:CJDataOfRole;
		
		/** 是否为我的摇钱树 */
		private var _isMyTree:Boolean = true;
		/** 是否是VIP */
		private var _isVip:Boolean;
		/** 是否可收获 */
		private var _canHarvest:Boolean;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
			this._addDataLiteners();
			
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			this._dataMTMine = CJDataManager.o.getData("CJDataOfMoneyTreeMine") as CJDataOfMoneyTreeMine;
			this._dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			this._moneyTreeConfig = CJDataOfMoneyTreeProperty.o;
			
			if (this._dataRole.vipLevel > 0)
			{
				this._isVip = true;
			}
			else
			{
				this._isVip = false;
			}
//			this._isVip = true;
			// 是否可收获
			this._setCanHarvest();
		}
		/**
		 * 设置数据 - 是否可收获标志位
		 * 
		 */		
		private function _setCanHarvest():void
		{
			var leftHarvestTime:int = this._dataMTMine.treeLevel - this._dataMTMine.harvestLevel;
			if (leftHarvestTime > 0)
			{
				this._canHarvest = true;
			}
			else
			{
				this._canHarvest = false;
			}
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			var texture:Texture;
			// 边框
			var imgBiankuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_tankuangwenzidi");
			var bkScaleRange:Rectangle = new Rectangle(11,11,1,1);
			var bkTexture:Scale9Textures = new Scale9Textures(texture, bkScaleRange);
			imgBiankuang = new Scale9Image(bkTexture);
			imgBiankuang.x = 5;
			imgBiankuang.y = 25;
			imgBiankuang.width = 192;
			imgBiankuang.height = this._isVip ? 130 : 166;
			this.addChild(imgBiankuang);
			
			var fontFormatBigTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFF960, null, null, null, null, null, TextFormatAlign.CENTER);
			// 文字 - 标题
			var labTitle:Label = new Label();
			labTitle.textRendererFactory = textRender.standardTextRender;
			labTitle.textRendererProperties.textFormat = fontFormatBigTitle;
			labTitle.text = CJLang("MONEYTREE_TITLE_SHOUHUO");
			labTitle.x = 60;
			labTitle.y = 4;
			labTitle.width = 83;
			labTitle.height = 16;
			this.addChild(labTitle);
			
//			// 分割线 - 横
//			var imgBiaotiFenge:SImage = new SImage(SApplication.assets.getTexture("yaoqianshu_tanchuangfengexian03"));
//			imgBiaotiFenge.x = 9;
//			imgBiaotiFenge.y = 12;
//			imgBiaotiFenge.width = 45;
//			imgBiaotiFenge.height = 5;
//			this.addChild(imgBiaotiFenge);
			
			// 图片 - 收获
			var imgShouhuo:SImage = new SImage(SApplication.assets.getTexture("yaoqianshu_shouhuo"));
			imgShouhuo.x = 13;
			imgShouhuo.y = this._isVip ? 44 : 60;
			imgShouhuo.width = 40;
			imgShouhuo.height = 40;
			this.addChild(imgShouhuo);
			
			var fontFormatLevel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x73FF42, null, null, null, null, null, TextFormatAlign.CENTER);
			var fontFormatTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFF7E00, null, null, null, null, null, TextFormatAlign.LEFT);
			var fontFormatCont:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xE8FF99, null, null, null, null, null, TextFormatAlign.LEFT);
			var fontFormatVip:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x5DFDFF, null, null, null, null, null, TextFormatAlign.LEFT);
			var fontFormatToVip:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x73FF42, null, null, true, null, null, TextFormatAlign.LEFT);
			
			// 文字 - 等级
			var label:Label = new Label();
			label.textRendererProperties.textFormat = fontFormatLevel;
			var sLevel:String = CJLang("MONEYTREE_LV");
			sLevel = sLevel.replace("{level}", String(this._dataMTMine.treeLevel));
			label.text = sLevel;
			label.x = 7;
			label.y = this._isVip ? 91 : 130;
			label.width = 57;
			label.height = 13;
			this.addChild(label);
			
			var mtCfg:Json_money_tree_setting;
			// TODO 此处为临时处理
			if (this._dataMTMine.treeLevel == 0)
			{
				mtCfg = _moneyTreeConfig.getConfig(1);
			}
			else
			{
				mtCfg = _moneyTreeConfig.getConfig(this._dataMTMine.treeLevel);
			}
			
			if (!_isVip) 
			{
				//您是普通玩家可享有：
				label = new Label();
				label.x = 78;
				label.y = 31;
				label.width = 112;
				label.height = 12;
				label.textRendererProperties.textFormat = fontFormatTitle;
				label.text = CJLang("MONEYTREE_SHOUHUO_DESC");
				this.addChild(label);
				
				// 当前摇钱树 LV
				labLevelVip = new Label();
				labLevelVip.x = 78;
				labLevelVip.y = 46;
				labLevelVip.width = 112;
				labLevelVip.height = 12;
				labLevelVip.textRendererProperties.textFormat = fontFormatCont;
//				labLevelVip.text = CJLang("MONEYTREE_SHOUHUO_LV").replace("{level}", String(this._dataMTMine.treeLevel));
				this.addChild(labLevelVip);
				
				// 银两 +
				labelSilverVip = new Label();
				labelSilverVip.x = 78;
				labelSilverVip.y = 59;
				labelSilverVip.width = 112;
				labelSilverVip.height = 12;
				labelSilverVip.textRendererProperties.textFormat = fontFormatCont;
//				labelSilverVip.text = CJLang("MONEYTREE_SHOUHUO_SLIVER").replace("{value}", mtCfg.levelupsliver);
				this.addChild(labelSilverVip);
				
				// 您当前是非VIP
				label = new Label();
				label.x = 78;
				label.y = 140;
				label.width = 70;
				label.height = 12;
				label.textRendererProperties.textFormat = fontFormatVip;
				label.text = CJLang("MONEYTREE_SHOUHUO_NOTVIP");
				this.addChild(label);
				
				// 成为VIP
				label = new Label();
				label.x = 153;
				label.y = 140;
				label.width = 40;
				label.height = 12;
				label.textRendererProperties.textFormat = fontFormatToVip;
				label.text = CJLang("MONEYTREE_SHOUHUO_TOBEVIP");
				this.addChild(label);
				
				// 分割线 - 横
				var imgFenge:SImage = new SImage(SApplication.assets.getTexture("yaoqianshu_fengexian"));
				imgFenge.x = 73;
				imgFenge.y = 73;
				imgFenge.width = 120;
				imgFenge.height = 5;
				this.addChild(imgFenge);
				
				imgFenge = new SImage(SApplication.assets.getTexture("yaoqianshu_fengexian"));
				imgFenge.x = 73;
				imgFenge.y = 133;
				imgFenge.width = 120;
				imgFenge.height = 5;
				this.addChild(imgFenge);
				
			}
			//您是VIP玩家可享有：
			label = new Label();
			label.x = 78;
			label.y = _isVip ? 31 : 79;
			label.width = 112;
			label.height = 12;
			label.textRendererProperties.textFormat = fontFormatTitle;
			label.text = CJLang("MONEYTREE_SHOUHUO_VIP_DESC");
			this.addChild(label);
			
			
			// 当前摇钱树 LV
			labLevel = new Label();
			labLevel.x = 78;
			labLevel.y = _isVip ? 46 : 93;
			labLevel.width = 112;
			labLevel.height = 12;
			labLevel.textRendererProperties.textFormat = fontFormatCont;
//			labLevel.text = CJLang("MONEYTREE_SHOUHUO_LV").replace("{level}", String(this._dataMTMine.treeLevel));
			this.addChild(labLevel);
			
			// 银两 +
			labelSilver = new Label();
			labelSilver.x = 78;
			labelSilver.y = _isVip ? 59 : 106;
			labelSilver.width = 112;
			labelSilver.height = 12;
			labelSilver.textRendererProperties.textFormat = fontFormatCont;
//			labelSilver.text = CJLang("MONEYTREE_SHOUHUO_SLIVER").replace("{value}", mtCfg.levelupsliver);
			this.addChild(labelSilver);
			
			// 经验 +{value}
			labelGold = new Label();
			labelGold.x = 78;
			labelGold.y = _isVip ? 72 : 118;
			labelGold.width = 112;
			labelGold.height = 12;
			labelGold.textRendererProperties.textFormat = fontFormatCont;
//			labelGold.text = CJLang("MONEYTREE_SHOUHUO_GOLD").replace("{value}", mtCfg.levelupgold);
			this.addChild(labelGold);
			
			// 分割线 - 横
			var imgFengeHeng:SImage = new SImage(SApplication.assets.getTexture("yaoqianshu_tanchuangfengexian02"));
			imgFengeHeng.x = 8;
			imgFengeHeng.y = _isVip ? 117 : 156;
			imgFengeHeng.width = 185;
			imgFengeHeng.height = 2;
			this.addChild(imgFengeHeng);
			
			// 分割线 - 竖
			var imgFengeShu:SImage = new SImage(SApplication.assets.getTexture("yaoqianshu_tanchuangfengexian01"));
			imgFengeShu.x = 70;
			imgFengeShu.y = 30;
			imgFengeShu.width = 2;
			imgFengeShu.height = _isVip ? 82 : 122;
			this.addChild(imgFengeShu);
			
			var fontFormatBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xD5CDA1, null, null, null, null, null, TextFormatAlign.CENTER);
			
			// 收获按钮
			this.btnHarvest = new Button();
			this.btnHarvest.x = 67;
			this.btnHarvest.y = _isVip ? 124 :161;
			this.btnHarvest.width = 65;
			this.btnHarvest.height = 28;
			this.btnHarvest.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnHarvest.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnHarvest.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnHarvest.addEventListener(Event.TRIGGERED, _onBtnClickHarvest);
			this.addChild(this.btnHarvest);
			
			this._setBtnTextHarvest();
			
			_reloadInfo();
		}
		
		
		private function _onDataLoadedMTMine(e:Event):void
		{
			_reloadInfo();
		}
		/**
		 * 
		 * 
		 */		
		private function _reloadInfo():void
		{
			var mtCfg:Json_money_tree_setting;
			// TODO 此处为临时处理
			if (this._dataMTMine.treeLevel == 0)
			{
				mtCfg = _moneyTreeConfig.getConfig(1);
			}
			else
			{
				mtCfg = _moneyTreeConfig.getConfig(this._dataMTMine.harvestLevel);
			}
			
			if (labLevelVip != null)
			{
				labLevelVip.text = CJLang("MONEYTREE_SHOUHUO_LV").replace("{level}", String(this._dataMTMine.harvestLevel));
			}
			if (labelSilverVip != null)
			{
				labelSilverVip.text = CJLang("MONEYTREE_SHOUHUO_SLIVER").replace("{value}", mtCfg.levelupsliver);
			}
			labLevel.text = CJLang("MONEYTREE_SHOUHUO_LV").replace("{level}", String(this._dataMTMine.harvestLevel));
			labelSilver.text = CJLang("MONEYTREE_SHOUHUO_SLIVER").replace("{value}", mtCfg.levelupsliver);
			labelGold.text = CJLang("MONEYTREE_SHOUHUO_GOLD").replace("{value}", mtCfg.levelupgold);
		}
		
		
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			this.btnHarvest.removeEventListener(Event.TRIGGERED, _onBtnClickHarvest);
		}
		
		/**
		 * 设置收获按钮文字
		 * 
		 */		
		private function _setBtnTextHarvest():void
		{
			if (this._canHarvest)
			{
				this.btnHarvest.label = CJLang("MONEYTREE_BTN_SHOUHUO");
			}
			else
			{
				this.btnHarvest.label = CJLang("MONEYTREE_BTN_SHOHOUZAILAI");
			}
		}
		
		/**
		 * 点击收获按钮
		 * @param event
		 * 
		 */		
		private function _onBtnClickHarvest(event:Event):void
		{
			if (this._canHarvest)
			{
				// 收获
				SocketCommand_moneytree.harverstMoneyTreeLevel();
			}
			else
			{
				// 稍后再来
				this.parent.removeFromParent();
			}
		}
		
		/**
		 * 增加数据事件监听
		 * 
		 */		
		private function _addDataLiteners():void
		{
			// 监听RPC结果
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			_dataMTMine.addEventListener(DataEvent.DataLoadedFromRemote, _onDataLoadedMTMine);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if (msg.getCommand() == ConstNetCommand.CS_MONEYTREE_HARVERSTMONEYTREELEVEL)
			{
				// 收获金银果
				if (msg.retcode == 0)
				{
					var retData:Object = msg.retparams;
					var isSucc:Boolean = retData[0];
					if (!isSucc)
					{
						return;
					}
					
					var addSliver:int = int(retData[1]);
					var addGold:int = int(retData[2]);
					// TODO 飘字内容 _showPiaozi
					var str:String = "";
					if (addSliver > 0)
					{
						str += CJLang("CURRENCY_NAME_SILVER") + " +" + String(addSliver);
					}
					if (addGold > 0)
					{
						str += ", " + CJLang("CURRENCY_NAME_GOLD") + " +" + String(addGold);
					}
					this._showPiaozi(str);
					
					// 向服务器申请我的摇钱树数据，更新收获次数
					SocketCommand_moneytree.getSelfMoneyTreeInfo();
					// 更新用户信息
					SocketCommand_role.get_role_info();
				}
			}
			else if (msg.getCommand() == ConstNetCommand.CS_MONEYTREE_GETSELFMONEYTREEINFO)
			{
				// 我的摇钱树数据
				this._setCanHarvest();
				this._setBtnTextHarvest();
			}
		}
		
		/**
		 * 飘字
		 * @param str 飘字内容
		 * 
		 */		
		private function _showPiaozi(str:String):void
		{
//			var seccessLabel:Label = new Label();
//			seccessLabel.text = str;
//			seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
//			seccessLabel.x = 0;
//			seccessLabel.y = (SApplicationConfig.o.stageHeight) / 2;
//			seccessLabel.width = SApplicationConfig.o.stageWidth;
//			var textTween:STween = new STween(seccessLabel, 2, Transitions.LINEAR);
//			textTween.moveTo(seccessLabel.x, seccessLabel.y- 50);
//			
//			textTween.onComplete = function():void
//			{
//				Starling.juggler.remove(textTween);
//				seccessLabel.removeFromParent(true);
//			}
//			this.parent.parent.addChild(seccessLabel);
//			Starling.juggler.add(textTween);
			
			CJFlyWordsUtil(str);
		}
		
		
		/** controls */
		private var _btnHarvest:Button;
		private var _labLevel:Label;
		private var _labLevelVip:Label;
		private var _labelSilver:Label;
		private var _labelSilverVip:Label;
		private var _labelGold:Label;
		
		/** setter */
		private function set btnHarvest(value:Button):void
		{
			this._btnHarvest = value;
		}
		private function set labLevel(value:Label):void
		{
			this._labLevel = value;
		}
		private function set labLevelVip(value:Label):void
		{
			this._labLevelVip = value;
		}
		private function set labelSilver(value:Label):void
		{
			this._labelSilver = value;
		}
		private function set labelSilverVip(value:Label):void
		{
			this._labelSilverVip = value;
		}
		private function set labelGold(value:Label):void
		{
			this._labelGold = value;
		}
		
		/** getter */
		private function get btnHarvest():Button
		{
			return this._btnHarvest;
		}
		private function get labLevel():Label
		{
			return this._labLevel;
		}
		private function get labLevelVip():Label
		{
			return this._labLevelVip;
		}
		private function get labelSilver():Label
		{
			return this._labelSilver;
		}
		private function get labelSilverVip():Label
		{
			return this._labelSilverVip;
		}
		private function get labelGold():Label
		{
			return this._labelGold;
		}
	}
}