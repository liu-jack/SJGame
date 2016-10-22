package SJ.Game.mall
{

	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstMall;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_mall;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 商城layer
	 * @author sangxu
	 * @date:2013-06-28
	 */	
	public class CJMallLayer extends SLayer
	{
		public function CJMallLayer()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 角色数据 */
		private var _dataRole:CJDataOfRole;
		/** 数据 - 商城数据 */
//		private var _dataMall:CJDataOfMall;
		
		/** 图标按钮组 */
		private var _btnVec:Vector.<Button>;
		
		/** 物品显示层宽高 */
		private const _operatLayerWidth:int = 419;
		private const _operatLayerHeight:int = 267;
		
		private const _operatLayerX:int = 58;
		private const _operatLayerY:int = 49;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
			this._addDataLiteners();
			
			this._initDraw();
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			SocketCommand_mall.getAllItems();
		}
		
		/**
		 * 添加事件监听
		 * 
		 */		
		private function _addDataLiteners():void
		{
			// 监听RPC结果
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			
//			this._dataMall.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMall);
		}
		
		/**
		 * 接收到商城数据
		 * 
		 */		
		private function _onDataLoadedMall():void
		{
			// 按钮状态变更
//			this._changeButton(this._dataMall.type);
		}
		
		/**
		 * 初始绘制
		 * 
		 */		
		private function _initDraw():void
		{
			// 设置我的元宝数量
			this._resetGold();
			this._resetCredit();
			
//			this.btnHot.isSelected = true;
			
			// 请求商城热卖类型数据
			this._onSelectMallType(ConstMall.MALL_ITEM_TYPE_HOT);
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			
			var texture:Texture;
			var optIdx:int = 0;
			
			// 背景
			texture = SApplication.assets.getTexture("common_quanbingdise");
			var imgBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
			imgBg.width = width;
			imgBg.height = height;
//			imgBg.alpha = 0.9;
			this.addChildAt(imgBg, optIdx++);
			
			// 边角
			var imgBgcorner:Scale9Image;
			var textureCorner:Texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			var corScaleRange:Rectangle = new Rectangle(14, 14, 1, 1);
			var corTexture:Scale9Textures = new Scale9Textures(textureCorner, corScaleRange);
			imgBgcorner = new Scale9Image(corTexture);
			imgBgcorner.x = 0;
			imgBgcorner.y = 0;
			imgBgcorner.width = SApplicationConfig.o.stageWidth;
			imgBgcorner.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(imgBgcorner, optIdx++);
			
			var img:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			img.width = SApplicationConfig.o.stageWidth;
			img.x = 0;
			img.y = 0;
			img.height = 19;
			this.addChild(img);
			
			// 标题
			var title:CJPanelTitle = new CJPanelTitle(CJLang("MALL_TITLE"));
			this.addChild(title);
			title.x = SApplicationConfig.o.stageWidth - title.width >> 1 ;
			
			// 图片 - 我的元宝背景
			var imgBgGold:Scale9Image;
			var ttBgGold:Texture = SApplication.assets.getTexture("shangcheng_zuoshangjiaodi");
			var recBgGold:Rectangle = new Rectangle(12, 12, 1, 1);
			var stBgGold:Scale9Textures = new Scale9Textures(ttBgGold, recBgGold);
			imgBgGold = new Scale9Image(stBgGold);
			imgBgGold.x = 4;
			imgBgGold.y = 18;
			imgBgGold.width = 155;
			imgBgGold.height = 29;
			this.addChild(imgBgGold);
			
			// 图片 - 我的积分背景
			var imgBgCredit:Scale9Image;
			imgBgCredit = new Scale9Image(stBgGold);
			imgBgCredit.x = 170;
			imgBgCredit.y = 18;
			imgBgCredit.width = 155;
			imgBgCredit.height = 29;
			this.addChild(imgBgCredit);
			
			// 字体 - 我的元宝
			var ffMyGold:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x63BF25, true);
			// 字体 - 按钮
			var ffBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xD5CDA1, null, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 元宝
			var ffGold:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xF4FF43, null, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 充值按钮
			var ffBtnRecharge:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFEFBD, null, null, null, null, null, TextFormatAlign.CENTER);
			
			// 文字 - 我的元宝
			var labMyGold:Label;
			labMyGold = new Label();
			labMyGold.x = 25;
			labMyGold.y = 25;
			labMyGold.width = 61;
			labMyGold.height = 13;
			labMyGold.text = CJLang("MALL_MY_GOLD");
			labMyGold.textRendererProperties.textFormat = ffMyGold;
			this.addChild(labMyGold);
			
			// 文字 - 元宝
			this.labGold = new Label();
			this.labGold.x = 74;
			this.labGold.y = 25;
			this.labGold.width = 52;
			this.labGold.height = 12;
			this.labGold.textRendererProperties.textFormat = ffGold;
			this.addChild(this.labGold);
			
			// 文字 - 我的积分
			var labMyCredit:Label;
			labMyCredit = new Label();
			labMyCredit.x = 191;
			labMyCredit.y = 25;
			labMyCredit.width = 61;
			labMyCredit.height = 13;
			labMyCredit.text = CJLang("MALL_MY_CREDIT");
			labMyCredit.textRendererProperties.textFormat = ffMyGold;
			this.addChild(labMyCredit);
			
			// 文字 - 积分
			this.labCredit = new Label();
			this.labCredit.x = 240;
			this.labCredit.y = 25;
			this.labCredit.width = 52;
			this.labCredit.height = 12;
			this.labCredit.textRendererProperties.textFormat = ffGold;
			this.addChild(this.labCredit);
			
			// 图片 - 元宝
			var imgGold:SImage = new SImage(SApplication.assets.getTexture("common_yuanbao"));
			imgGold.x = 126;
			imgGold.y = 27;
			imgGold.width = 15;
			imgGold.height = 11;
			this.addChild(imgGold);
			
			// 按钮 - 快速充值
			this.btnRecharge = new Button();
//			this.btnRecharge.visible = !SCompileUtils.o.isOnVerify();
			this.btnRecharge.x = 340;
			this.btnRecharge.y = 17;
			this.btnRecharge.width = 112;
			this.btnRecharge.height = 30;
			this.btnRecharge.label = CJLang("MALL_RECHARGE");
			this.btnRecharge.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			this.btnRecharge.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			this.btnRecharge.defaultLabelProperties.textFormat = ffBtnRecharge;
			this.addChild(this.btnRecharge);
			this.btnRecharge.addEventListener(starling.events.Event.TRIGGERED, _onClickBtnRecharge);

			var imgOptBgKuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_dinew");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
			imgOptBgKuang.x = _operatLayerX;
			imgOptBgKuang.y = _operatLayerY;
			imgOptBgKuang.width = _operatLayerWidth;
			imgOptBgKuang.height = _operatLayerHeight;
			this.addChildAt(imgOptBgKuang, optIdx++);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(44, 44, 1, 1)));
			imgOptBgKuang.x = _operatLayerX;
			imgOptBgKuang.y = _operatLayerY;
			imgOptBgKuang.width = _operatLayerWidth;
			imgOptBgKuang.height = _operatLayerHeight;
			this.addChildAt(imgOptBgKuang, optIdx++);
			
			// 花框
//			var imgOutFrameDecorate:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_zhuangshinew", 15, 15,7,3);
//			imgOutFrameDecorate.x = 58;
//			imgOutFrameDecorate.y = 49;
//			imgOutFrameDecorate.width = 419;
//			imgOutFrameDecorate.height = 267;
//			this.addChild(imgOutFrameDecorate);
			var panelFrame:CJPanelFrame = new CJPanelFrame(_operatLayerWidth - 6, _operatLayerHeight - 6);
			panelFrame.x = _operatLayerX + 3;
			panelFrame.y = _operatLayerY + 3;
			this.addChildAt(panelFrame, optIdx++);
			
			// 边框
			var imgBiankuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_waikuangnew");
			var bkScaleRange:Rectangle = new Rectangle(15 , 15 , 1, 1);
			var bkTexture:Scale9Textures = new Scale9Textures(texture, bkScaleRange);
			imgBiankuang = new Scale9Image(bkTexture);
			imgBiankuang.x = _operatLayerX;
			imgBiankuang.y = _operatLayerY;
			imgBiankuang.width = 419;
			imgBiankuang.height = 267;
			this.addChildAt(imgBiankuang, optIdx++);
			
			
			
			// 关闭按钮
			this.btnClose = new Button();
			this.btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			this.btnClose.width = 42;
			this.btnClose.height = 43;
			this.btnClose.x = 438;
			this.btnClose.y = 0;
			//为关闭按钮添加监听
			this.btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
			this.addChild(this.btnClose);
			
			// 按钮 - 热卖
			this.btnHot = new Button();
			this.btnHot.y = 67;
			this.btnHot.label = CJLang("MALL_TYPE_HOT");
			
			// 按钮 - 宝石
			this.btnJewel = new Button();
			this.btnJewel.y = 112;
			this.btnJewel.label = CJLang("MALL_TYPE_JEWEL");
			
			// 按钮 - 材料
			this.btnMaterial = new Button();
			this.btnMaterial.y = 157;
			this.btnMaterial.label = CJLang("MALL_TYPE_MATERIAL");
			
			// 按钮 - 声望
			this.btnCredit = new Button();
			this.btnCredit.y = 202;
			this.btnCredit.label = CJLang("MALL_TYPE_CREDIT");
			
			this._btnVec = new Vector.<Button>;
			this._btnVec.push(this.btnHot, 
							  this.btnJewel, 
							  this.btnMaterial, 
							  this.btnCredit);
			
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.defaultSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka02"));
				btnTemp.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka01"));
				btnTemp.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xF1D98E);
				btnTemp.x = 5;
				btnTemp.width = 55;
				btnTemp.height = 39;
				this.addChild(btnTemp);
				
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
			}
			
			// 操作层
			this.operateLayer = new CJMallOperateLayer();
			this.operateLayer.x = 59;
			this.operateLayer.y = 49;
			this.operateLayer.width = 420;
			this.operateLayer.height = 267;
			this.addChild(this.operateLayer);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function _onClickTypeBtn(event:Event):void
		{
			var itemType:int = -1;
			switch(event.target)
			{
				case this.btnHot:
					itemType = ConstMall.MALL_ITEM_TYPE_HOT;
					break;
				case this.btnJewel:
					itemType = ConstMall.MALL_ITEM_TYPE_JEWEL;
					break;
				case this.btnMaterial:
					itemType = ConstMall.MALL_ITEM_TYPE_MATERIAL;
					break;
				case this.btnCredit:
					itemType = ConstMall.MALL_ITEM_TYPE_CREDIT;
					break;
			}
			if (-1 == itemType)
			{
				return;
			}
			this._onSelectMallType(itemType);
		}
		
		/**
		 * 选择商城类型
		 * @param itemType	商城道具类型
		 * 
		 */		
		private function _onSelectMallType(itemType:int):void
		{
//			if (_pageType == itemType)
//			{
//				return;
//			}
			// 按钮状态变更
			this._changeButton(itemType);
			// 请求远程数据
//			this._requestRemoteData(itemType);
			
			(operateLayer as CJMallOperateLayer).setPageType(String(itemType));
		}
		
		/**
		 * 请求获取商城道具数据
		 * @param itemType	
		 * 
		 */		
//		private function _requestRemoteData(itemType:int):void
//		{
//			// 添加网络锁
////			SocketLockManager.Lock(ConstNetLockID.MallModule);
//			
//			SocketCommand_mall.getItems(itemType);
//		}
		
		/**
		 * 功能按钮显示变更
		 * @param buttonType	按钮类型
		 * 
		 */			
		private function _changeButton(buttonType:int):void
		{
			for(var i:uint = 0; i < this._btnVec.length; i++)
			{
				if (buttonType == (i + 1))
				{
					// 选中
					this._btnVec[i].isSelected = true;
				}
				else
				{
					// 未选中
					this._btnVec[i].isSelected = false;
				}
			}
		}
		
		/**
		 * 按钮点击 - 关闭
		 * @param event
		 * 
		 */		
		private function _onBtnClickClose(event:Event):void
		{
			//退出模块
			SApplication.moduleManager.exitModule("CJMallModule");
		}
		
		/**
		 * 按钮点击 - 快速充值
		 * @param event
		 * 
		 */		
		private function _onClickBtnRecharge(event:Event):void
		{
			// 退出商城模块
			SApplication.moduleManager.exitModule("CJMallModule");
			if(ConstPlatformId.isWebChargeChannel())
			{
				CJMapUtil.enterCharge();
				return;
			}
			// 进入充值模块
			SApplication.moduleManager.enterModule("CJRechargeModule");
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 角色数据
			_dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			// 商城数据
//			this._dataMall = CJDataManager.o.getData("CJDataOfMall") as CJDataOfMall;
		}
		
		/**
		 * 设置我的元宝数量
		 * 
		 */		
		private function _resetGold():void
		{
			this.labGold.text = String(this._dataRole.gold);
		}
		
		/**
		 * 设置我的元宝数量
		 * 
		 */		
		private function _resetCredit():void
		{
			this.labCredit.text = String(this._dataRole.credit);
		}
		
		/**
		 * 接收到我的摇钱树数据
		 * 
		 */		
		private function _onDataLoadedMoneyTreeMine():void
		{
			
		}
		
		/**
		 * 接收到服务器端数据
		 * @param e
		 * 
		 */		
		private function _onDataLoaded(e:Event):void
		{
			
		}
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if (msg.getCommand() == ConstNetCommand.CS_ROLE_GET_ROLE_INFO)
			{
				// 角色信息更新
				this._rpcReturnHandleRoleInfo(msg);
			}
		}
		
		/**
		 * RPC返回结果处理 - 给好友施肥
		 * @param msg
		 * @return 
		 * 
		 */		
		private function _rpcReturnHandleRoleInfo(msg:SocketMessage):void
		{
			if (msg.retcode == 0)
			{
				_resetGold();
				_resetCredit();
			}
		}
		
		/**
		 * 飘字
		 * @param str 飘字内容
		 * 
		 */		
		private function _showPiaozi(str:String):void
		{
			var seccessLabel:Label = new Label();
			seccessLabel.text = str;
			seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			seccessLabel.x = 0;
			seccessLabel.y = (SApplicationConfig.o.stageHeight - seccessLabel.height) / 2 - this.y;
			seccessLabel.width = SApplicationConfig.o.stageWidth;
			var textTween:STween = new STween(seccessLabel, 2, Transitions.LINEAR);
			textTween.moveTo(seccessLabel.x, seccessLabel.y- 50);
			
			textTween.onComplete = function():void
			{
				Starling.juggler.remove(textTween);
				seccessLabel.removeFromParent(true);
			}
			this.addChild(seccessLabel);
			Starling.juggler.add(textTween);
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			
//			this._dataMall.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMall);
			this.btnRecharge.removeEventListener(starling.events.Event.TRIGGERED, _onClickBtnRecharge);
			this.btnClose.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.addEventListener(Event.TRIGGERED, _onClickTypeBtn);
			}
			
		}
		
		override public function dispose():void
		{
			removeAllEventListener();
//			((this.operateLayer) as CJMallOperateLayer).removeFromParent(true);
			operateLayer.removeFromParent(true);
			operateLayer = null;
			
			super.dispose();
		}
		
		/** controls */
		/** 操作层 */
		private var _operateLayer:SLayer;
		/** 按钮 - 热卖 */
		private var _btnHot:Button;
		/** 按钮 - 宝石 */
		private var _btnJewel:Button;
		/** 按钮 - 材料 */
		private var _btnMaterial:Button;
		/** 按钮 - 声望 */
		private var _btnCredit:Button;
		/** 文字 - 元宝 */
		private var _labGold:Label;
		/** 文字 - 积分 */
		private var _labCredit:Label;
		/** 按钮 - 快速充值 */
		private var _btnRecharge:Button;
		/** 按钮 - 关闭 */
		private var _btnClose:Button;
		
		/** setter */
		public function set operateLayer(value:SLayer):void
		{
			this._operateLayer = value;
		}
		public function set btnHot(value:Button):void
		{
			this._btnHot = value;
		}
		public function set btnJewel(value:Button):void
		{
			this._btnJewel = value;
		}
		public function set btnMaterial(value:Button):void
		{
			this._btnMaterial = value;
		}
		public function set btnCredit(value:Button):void
		{
			this._btnCredit = value;
		}
		public function set labGold(value:Label):void
		{
			this._labGold = value;
		}
		public function set labCredit(value:Label):void
		{
			this._labCredit = value;
		}
		public function set btnRecharge(value:Button):void
		{
			this._btnRecharge = value;
		}
		public function set btnClose(value:Button):void
		{
			this._btnClose = value;
		}
		
		/** getter */
		public function get operateLayer():SLayer
		{
			return this._operateLayer;
		}
		public function get btnHot():Button
		{
			return this._btnHot;
		}
		public function get btnJewel():Button
		{
			return this._btnJewel;
		}
		public function get btnMaterial():Button
		{
			return this._btnMaterial;
		}
		public function get btnCredit():Button
		{
			return this._btnCredit;
		}
		public function get labGold():Label
		{
			return this._labGold;
		}
		public function get labCredit():Label
		{
			return this._labCredit;
		}
		public function get btnRecharge():Button
		{
			return this._btnRecharge;
		}
		public function get btnClose():Button
		{
			return this._btnClose;
		}
	}
}