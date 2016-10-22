package SJ.Game.friends
{
	import SJ.Common.Constants.ConstFriend;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFriends;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	
	import flash.text.TextFormat;
	
	import starling.events.Event;
	
	/**
	 * 好友层
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendLayer extends SLayer
	{
		
		/** 按钮类型 */
		/** 我的好友 */
		private static const BTN_TYPE_MY_FRIEND:int = 0;
		/** 最近联系 */
		private static const BTN_TYPE_RECENT_CONTACT:int = 1;
		/** 好友申请 */
		private static const BTN_TYPE_REQUEST:int = 2;
		/** 黑名单 */
		private static const BTN_TYPE_BLACKLIST:int = 3;
		/** 好友管理 */
		private static const BTN_TYPE_MANAGE:int = 4;
		private static const BTN_TYPES:Array = [BTN_TYPE_MY_FRIEND, BTN_TYPE_RECENT_CONTACT,
			BTN_TYPE_REQUEST, BTN_TYPE_BLACKLIST, BTN_TYPE_MANAGE];
		
		/** 按钮 */
		private var _btnVec:Vector.<Button>;
		/** 当前按钮类型 */
		private var _currentBtnType:int = 0;
		
		/** 我的好友层 */
		private var _layerMyFriend:CJFriendMyFriendLayer;
		/** 最近联系层 */
		private var _layerRecentContact:CJFriendRecentContactLayer;
		/** 好友申请层 */
		private var _layerRequest:CJFriendRequestLayer;
		/** 黑名单层 */
		private var _layerBlacklist:CJFriendBlacklistLayer;
		/** 好友管理层 */
		private var _layerManage:CJFriendManageLayer;
		/** 好友数据 */
		private var _friendsInfo:CJDataOfFriends;
		/** 主角的等级 */
		private var _roleLevel:String;
		/** 最近联系人上限 */
		private var _maxRecentContactNum:String;
		/** 黑名单上限*/
		private var _maxBlacklistNum:String;
		/** 页面类型 */
		private var _pageType:int = 0;
		
		
		public function CJFriendLayer()
		{
			super();
			this.setSize(423,296);
		}
		/**
		 * 设置分页类型
		 * @param type
		 * 
		 */		
		public function setPageType(type:int = BTN_TYPE_MY_FRIEND):void
		{
			if (type in BTN_TYPES)
			{
				this._pageType = type;
			}
		}
		override protected function initialize():void
		{
			super.initialize();
			
			//背景底图
			var imgOperateBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinew",1 ,1 , 1, 1);
			imgOperateBg.width = this.operatLayer.width;
			imgOperateBg.height = this.operatLayer.height;
			this.operatLayer.addChild(imgOperateBg);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.operatLayer.width - 8 , this.operatLayer.height - 8);
			bgBall.x = 4;
			bgBall.y = 4;
			this.operatLayer.addChild(bgBall);
			
			//操作层遮罩
			var imgOperateShade:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 40, 40,1,1);
			imgOperateShade.width = this.operatLayer.width - 20;
			imgOperateShade.height = this.operatLayer.height - 20;
			imgOperateShade.x = 10;
			imgOperateShade.y = 10;
			this.operatLayer.addChild(imgOperateShade);
			
			//操作层 - 外边框图
			var imgOutFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew", 15 , 15 , 1, 1);
			imgOutFrame.width = this.operatLayer.width;
			imgOutFrame.height = this.operatLayer.height;
			this.operatLayer.addChild(imgOutFrame);
			
			//标题
			var labTitle:CJPanelTitle = new CJPanelTitle(this._getLang("FRIEND_RELATION_FRIEND"));
			labTitle.x = 90;
			labTitle.y = 2;
			this.addChild(labTitle);
			
			this.setChildIndex(btnClose, this.numChildren - 1);
			this.setChildIndex(labTitle, this.getChildIndex(btnClose) - 1);
			this.setChildIndex(this.operatLayer, this.getChildIndex(btnClose) - 2);
			// 页签按钮
			this._btnVec = new Vector.<Button>;
			this._btnVec.push(this.btnMyFriend, this.btnRecentContact, 
				this.btnRequest, this.btnBlacklist, this.btnFriendManage);
			
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.defaultSelectedSkin = this._getImgBtnSel();
				btnTemp.defaultLabelProperties.textFormat = new TextFormat("Arial", 10, 0xF7E399);
				btnTemp.labelFactory = textRender.htmlTextRender;
				
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
			}
//			var defaultBtnType:int = BTN_TYPE_MY_FRIEND;
			this._currentBtnType = _pageType;
			this._onAddOperatLayer(_pageType);
			
			// 为关闭按钮添加监听
			this._btnClose.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				// 退出好友模块
				SApplication.moduleManager.exitModule("CJFriendModule");
			});
			_friendsInfo = CJDataManager.o.DataOfFriends;
			_roleLevel = CJDataManager.o.DataOfHeroList.getMainHero().level;
			
			// 全局配置
			var globalConfig:CJDataOfGlobalConfigProperty = CJDataOfGlobalConfigProperty.o;
			_maxRecentContactNum = globalConfig.getData("FRIENDS_TEMP_MAX");
			_maxBlacklistNum = globalConfig.getData("FRIENDS_BLACKLIST_MAX");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onloadFriendInfo);
			// 添加网络锁
			SocketCommand_friend.getAllFriendInfo();
			SocketCommand_friend.getAllFriendTempInfo();
			SocketCommand_friend.getAllRequestsInfo();
			SocketCommand_friend.getBlacklist();
			
			_setPlayerNum();
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData , this._onloadFriendInfo);
			super.dispose();
		}
		/**
		 * 加载服务器返回我的好友、最近联系人、好友申请、黑名单中数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadFriendInfo(e:Event):void
		{
			var retParams:Array;
			var listData:Array;
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_INFO && message.retcode == 0)
			{
				retParams = message.retparams;
				listData = retParams[1] as Array;
				ConstFriend.myFriendPlayerNum = getNotNullCount(listData);
				_setPlayerNum();
			}
			else if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_TEMP_INFO && message.retcode == 0)
			{
				retParams = message.retparams;
				listData = retParams[1] as Array;
				ConstFriend.recentContactPlayerNum = getNotNullCount(listData);
				_setPlayerNum();
			}
			else if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_ALL_REQUESTS_INFO && message.retcode == 0)
			{
				retParams = message.retparams;
				listData = retParams[1] as Array;
				ConstFriend.requestPlayerNum = getNotNullCount(listData);
				_setPlayerNum();
			}
			else if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_BLACKLIST && message.retcode == 0)
			{
				retParams = message.retparams;
				listData = retParams[1] as Array;
				ConstFriend.blacklistPlayerNum = getNotNullCount(listData);
				_setPlayerNum();
			}
		}
		/**
		 * 获取数组中非空的元素个数
		 * @param listData
		 * @return 
		 * 
		 */		
		private function getNotNullCount(listData:Array):int
		{
			var count:int = 0;
			for (var i:int = 0; i < listData.length; i++) 
			{
				if (listData[i])
				{
					count ++;
				}
			}
			return count;
		}
		/**
		 * 设置玩家的个数
		 * @param event
		 * 
		 */		
		private function _setPlayerNum():void
		{
			this.btnMyFriend.label = this._getLang("FRIEND_MY_FRIEND")
				.replace("{curnum}", ConstFriend.myFriendPlayerNum).replace("{totalNum}", _roleLevel);
			this.btnRecentContact.label = this._getLang("FRIEND_RECENT_CONTACTS")
				.replace("{curnum}", ConstFriend.recentContactPlayerNum).replace("{totalNum}", _maxRecentContactNum);
			this.btnRequest.label = this._getLang("FRIEND_REQUESTER")
				.replace("{curnum}", ConstFriend.requestPlayerNum);
			this.btnBlacklist.label = this._getLang("FRIEND_BLACKLIST")
				.replace("{curnum}", ConstFriend.blacklistPlayerNum).replace("{totalNum}", _maxBlacklistNum);
			this.btnFriendManage.label = this._getLang("FRIEND_MANAGE")
				.replace("{curnum}", ConstFriend.myFriendPlayerNum).replace("{totalNum}", _roleLevel);
		}
		
		private function _onClickTypeBtn(event:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			var btnType:int = -1;
			switch(event.target)
			{
				case this.btnMyFriend:
					btnType = BTN_TYPE_MY_FRIEND;
					break;
				case this.btnRecentContact:
					btnType = BTN_TYPE_RECENT_CONTACT;
					break;
				case this.btnRequest:
					btnType = BTN_TYPE_REQUEST;
					break;
				case this.btnBlacklist:
					btnType = BTN_TYPE_BLACKLIST;
					break;
				case this.btnFriendManage:
					btnType = BTN_TYPE_MANAGE;
					break;
			}
			if (-1 == btnType)
			{
				return;
			}
			if (btnType == this._currentBtnType)
			{
				return;
			}
			// 原按钮类型
			var oldBtnType:int = this._currentBtnType;
			// 移除现在显示信息
			this._onRemoveOperatLayer(oldBtnType);
			
			// 将当前按钮类型赋值为当前点击按钮类型
			this._currentBtnType = btnType;
			this._pageType = btnType;
			// 显示选择页签信息
			this._onAddOperatLayer(btnType);
		}
		
		/**
		 * 移除操作层内容
		 * @param type 原按钮类型
		 * 
		 */		
		private function _onRemoveOperatLayer(type:int):void
		{
			switch(type)
			{
				case BTN_TYPE_MY_FRIEND:
					// 我的好友
					this.operatLayer.removeChild(_layerMyFriend, true);
					break;
				case BTN_TYPE_RECENT_CONTACT:
					// 最近联系
					this.operatLayer.removeChild(_layerRecentContact , true);
					break;
				case BTN_TYPE_REQUEST:
					// 好友申请
					this.operatLayer.removeChild(_layerRequest, true);
					break;
				case BTN_TYPE_BLACKLIST:
					// 黑名单
					this.operatLayer.removeChild(_layerBlacklist , true);
					break;
				case BTN_TYPE_MANAGE:
					// 好友管理
					this.operatLayer.removeChild(_layerManage , true);
					break;
			}
		}
		
		/**
		 * 根据按钮类型显示相应页面信息
		 * @param type 按钮类型
		 * 
		 */		
		private function _onAddOperatLayer(type:int):void
		{
			// 变更页签按钮显示
			this._changeButton(type);
			
			switch(type)
			{
				case BTN_TYPE_MY_FRIEND:
					this._onEnterMyFriendLayer();
					break;
				case BTN_TYPE_RECENT_CONTACT:
					this._onEnterRecentContactLayer();
					break;
				case BTN_TYPE_REQUEST:
					this._onEnterRequestLayer();
					break;
				case BTN_TYPE_BLACKLIST:
					this._onEnterBlacklistLayer();
					break;
				case BTN_TYPE_MANAGE:
					this._onEnterManageLayer();
					break;
				
			}
		}
		
		/**
		 * 我的好友
		 * 
		 */		
		private function _onEnterMyFriendLayer():void
		{
			_layerMyFriend = new CJFriendMyFriendLayer();
			this._addOperation(_layerMyFriend);
		}
		
		/**
		 * 最近联系
		 * 
		 */		
		private function _onEnterRecentContactLayer():void
		{
			_layerRecentContact = new CJFriendRecentContactLayer();
			this._addOperation(_layerRecentContact);
		}
		
		/**
		 * 好友申请
		 * 
		 */		
		private function _onEnterRequestLayer():void
		{
			_layerRequest = new CJFriendRequestLayer();
			this._addOperation(_layerRequest);
		}
		
		/**
		 * 黑名单
		 * 
		 */		
		private function _onEnterBlacklistLayer():void
		{
			_layerBlacklist = new CJFriendBlacklistLayer();
			this._addOperation(_layerBlacklist);
		}
		/**
		 * 好友管理
		 * 
		 */		
		private function _onEnterManageLayer():void
		{
			_layerManage = new CJFriendManageLayer();
			this._addOperation(_layerManage);
		}
		/**
		 * 向操作层添加layer, 将显示于我的好友界面关闭按钮下方
		 * @param layer
		 * 
		 */		
		private function _addOperation(layer:SLayer):void
		{
			this.operatLayer.addChild(layer);
			this.setChildIndex(this.btnClose, this.numChildren - 1);
		}
		
		/**
		 * 功能按钮显示变更
		 * 
		 */		
		private function _changeButton(buttonType:int):void
		{
			for(var i:uint = 0; i < this._btnVec.length; i++)
			{
				if (buttonType == i)
				{
					// 选中
					this._btnVec[i].isSelected = true;
					this._btnVec[i].width = 82;
					this._btnVec[i].height = 47;
					this._btnVec[i].x = 2;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat("Arial", 12, 0xE6B47F );
				}
				else
				{
					// 未选中
					this._btnVec[i].isSelected = false;
					this._btnVec[i].width = 70;
					this._btnVec[i].height = 42;
					this._btnVec[i].x = 13;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat("Arial", 10, 0xF7E399 );
				}
			}
		}
		
		/**
		 * 获取按钮选中图片
		 * @return 
		 * 
		 */		
		private function _getImgBtnSel():SImage
		{
			return new SImage(SApplication.assets.getTexture("common_xuanxiangka01"))
		}
		
		
		/**
		 * 获取语言表对应语言
		 * @param langKey
		 * @return 
		 * 
		 */		
		private function _getLang(langKey:String) : String
		{
			return CJLang(langKey);
		}
		
		/** 背景图 */
		private var _imgBg:Scale9Image;
		/** 背景角 */
		private var _imgBgcorner:Scale9Image;
		/** 分割线 */
		private var _imgLine:Scale3Image;
		/** 标题背景图 */
		private var _imgTitleBg:SImage;
		/** 我的好友按钮 */
		private var _btnMyFriend:Button;
		/** 最近联系按钮 */
		private var _btnRecentContact:Button;
		/** 好友申请按钮 */
		private var _btnRequest:Button;
		/** 黑名单按钮 */
		private var _btnBlacklist:Button;
		/** 好友管理按钮 */
		private var _btnFriendManage:Button;
		/** 关闭按钮 */
		private var _btnClose:Button;
		/** 操作界面层 */
		private var _operatLayer:SLayer;
		
		public function set imgBg(value:Scale9Image):void
		{
			this._imgBg = value;
		}
		public function set imgBgcorner(value:Scale9Image):void
		{
			this._imgBgcorner = value;
		}
		public function set imgLine(value:Scale3Image):void
		{
			this._imgLine = value;
		}
		public function set imgTitleBg(value:SImage):void
		{
			this._imgTitleBg = value;
		}
		public function set btnClose(value:Button):void
		{
			this._btnClose = value;
		}
		public function set operatLayer(value:SLayer):void
		{
			this._operatLayer = value;
		}
		
		public function get imgBg():Scale9Image
		{
			return this._imgBg;
		}
		public function get imgBgcorner():Scale9Image
		{
			return this._imgBgcorner;
		}
		public function get imgLine():Scale3Image
		{
			return this._imgLine;
		}
		public function get imgTitleBg():SImage
		{
			return this._imgTitleBg;
		}
		public function get btnClose():Button
		{
			return this._btnClose;
		}
		public function get operatLayer():SLayer
		{
			return this._operatLayer;
		}

		/** 我的好友按钮 */
		public function get btnMyFriend():Button
		{
			return _btnMyFriend;
		}
		public function set btnMyFriend(value:Button):void
		{
			_btnMyFriend = value;
		}

		/** 最近联系按钮 */
		public function get btnRecentContact():Button
		{
			return _btnRecentContact;
		}
		public function set btnRecentContact(value:Button):void
		{
			_btnRecentContact = value;
		}

		/** 好友申请按钮 */
		public function get btnRequest():Button
		{
			return _btnRequest;
		}
		public function set btnRequest(value:Button):void
		{
			_btnRequest = value;
		}

		/** 黑名单按钮 */
		public function get btnBlacklist():Button
		{
			return _btnBlacklist;
		}
		public function set btnBlacklist(value:Button):void
		{
			_btnBlacklist = value;
		}

		/** 好友管理按钮 */
		public function get btnFriendManage():Button
		{
			return _btnFriendManage;
		}
		public function set btnFriendManage(value:Button):void
		{
			_btnFriendManage = value;
		}

	}
}