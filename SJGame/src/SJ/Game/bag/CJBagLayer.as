package SJ.Game.bag
{
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfBagProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_bag_property_setting;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 背包层
	 * @author sangxu
	 * 
	 */	
	public class CJBagLayer extends SLayer
	{
		
		public function CJBagLayer()
		{
			super();
		}
		
		
		/** 道具tooltip layer */		
//		private var _tooltipLayer:CJBagItemTooltip;
		/** 背包扩充layer */
		private var _expandLayer:CJBagExpandLayer;

		/** 初始化上次选中的背包物品栏按钮 */
		private var _oldBtn:Button = null;		
		
		/** 物品框总页数 */ 
		private var _pageNum:uint;
		/** 当前页索引,默认是第一页 */
		private var _currentPage:uint = 1;
		/** 背包单页显示的物品框 */
		private var _bagFrameItems:Array = new Array();
		/** 背包物品种类 */
		private var _bagGoodsKind:uint = 5;
		/** 背包显示的物品 */
		private var _bagGoodsItems:Array;
		/** 背包物品选项栏种类 */
		private var _bagBtnLeftId:uint;
		/** 当前背包类型 */
		private var _curBagType:uint = 0;
		
		/** 当前已经解锁的物品框数 */
		private var _currentUnlockedFrameNum:uint = 0;
		/** 背包容量上限 */
		private var _bagMaxCount:uint = 10;
		
		/** 单页行数 */
		private var _bagRowNum:uint = 5;
		/** 单页列数 */
		private var _bagColNum:uint = 4;
		/** 单页格子数量 */
		private var _onePageNum:uint = _bagRowNum * _bagColNum;
		
		private var _itemSpaceX:uint = ConstBag.TwoGoodsFrameDistanceH;
		private var _itemSpaceY:uint = ConstBag.TwoGoodsFrameDistanceV;
		/** 背包数据 */
		private var _bagData:CJDataOfBag;
		/** 武将数据 */
		private var _dataHeroList:CJDataOfHeroList;
		private var _dataMainHero:CJDataOfHero;
//		private var _equipBar:CJDataOfEquipmentbar = CJDataManager.o.getData("CJDataOfEquipmentbar");
		/** 道具容器配置数据 */
		private var _bagSettingData:CJDataOfBagProperty;
		/** 道具容器配置数据 - 背包 */
		private var _bagSetting:Json_bag_property_setting;
		/** 扩充背包时点击的格子索引 */
		private var _expandIndex:int;
		
		/** 按钮 - 背包类型 */
		private var beibaoBtns:Vector.<Button> = new Vector.<Button>(ConstBag.ConstBagItemsNum);
		
		private var _LockKeyTurnPage:String = "BagModuleTurnPage";
		/** 当前选项卡下，所有道具 */
		private var _curItemDatas:Array;
		
		/** 提示火圈，等级礼包提示用 */
		private var _fireArrowLvP:SAnimate = null;
		private var _showFireArrowLvP:Boolean = false;
		/** 背包一键出售状态 */
		private var _sellStatus:Boolean = false;
		override protected function initialize():void
		{
			super.initialize();
			// 初始化数据
			this._initData();
			
			// 初始化控件
			this._initControls();
			// 增加监听
			this._addListeners();
			
			// 请求服务器数据
			this._remoteDataRequest();
			
			if (_bagData.itemsArray != null)
			{
				this._currentUnlockedFrameNum = this._bagData.bagCount;
				this._drawOnePage();
			}
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			this.width = SApplicationConfig.o.stageWidth
			this.height = SApplicationConfig.o.stageHeight
			/** 字体 - 按钮选中 */
			var fontBtnSel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFDCA8B, null, null, null, null, null, TextFormatAlign.CENTER);
			/** 字体 - 按钮未选中 */
			var fontBtnUnsel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xE5DB8E, null, null, null, null, null, TextFormatAlign.CENTER);
			/** 字体 - 标题 */
//			var fontTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xE9B543, null, null, null, null, null, TextFormatAlign.CENTER);
			
			// 初始化背包物品栏按钮
			
			for(var i:uint = 0; i < this.beibaoBtns.length; i++)
			{
				beibaoBtns[i] = this["beibaoBtn" + i] as Button;
				if(beibaoBtns[i] == null)
				{
					continue;
				}
				beibaoBtns[i].x = 20;
				beibaoBtns[i].defaultSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka02"));
				beibaoBtns[i].defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka01"));
				beibaoBtns[i].width = 70;
				beibaoBtns[i].height = 44;
				beibaoBtns[i].defaultLabelProperties.textFormat = fontBtnUnsel;
				beibaoBtns[i].selectedDownLabelProperties.textFormat = fontBtnSel;
				beibaoBtns[i].selectedHoverLabelProperties.textFormat = fontBtnSel;
				beibaoBtns[i].selectedUpLabelProperties.textFormat = fontBtnSel;
				//为每个背包物品栏按钮添加监听
				beibaoBtns[i].addEventListener(starling.events.Event.TRIGGERED, _buttonChangeHandler);
			}
			this.beibaoBtn0.label = CJLang("BAG_BTN_NAME_ALL");
			this.beibaoBtn1.label = CJLang("BAG_BTN_NAME_PROP");
			this.beibaoBtn2.label = CJLang("BAG_BTN_NAME_EQUIP");
			this.beibaoBtn3.label = CJLang("BAG_BTN_NAME_MATERIAL");
			this.beibaoBtn4.label = CJLang("BAG_BTN_NAME_JEWEL");
			
//			this.labTitle.text = CJLang("BAG_TITLE");
//			this.labTitle.textRendererProperties.textFormat = fontTitle;
//			
			// 背包层背景
//			var textureBg:Texture = SApplication.assets.getTexture("common_tankuangdi");
//			var bgScaleRange:Rectangle = new Rectangle(19,19,1,1);
//			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
//			var bgImage:Scale9Image = new Scale9Image(bgTexture);
//			bgImage.width = ConstBag.BAG_LAYER_WIDTH;
//			bgImage.height = ConstBag.BAG_LAYER_HEIGHT;
//			this.bagLayer.addChildAt(bgImage, 0);
			
			var optIdx:int = 0;
			// 操作层 - 底图
			var imgOptBgKuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_dinew");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(1, 1, 1, 1)));
			imgOptBgKuang.x = 0;
			imgOptBgKuang.y = 0;
			imgOptBgKuang.width = ConstBag.BAG_LAYER_WIDTH;
			imgOptBgKuang.height = ConstBag.BAG_LAYER_HEIGHT;
			this.bagLayer.addChildAt(imgOptBgKuang, optIdx++);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(44, 44, 1, 1)));
			imgOptBgKuang.x = 0;
			imgOptBgKuang.y = 0;
			imgOptBgKuang.width = ConstBag.BAG_LAYER_WIDTH;
			imgOptBgKuang.height = ConstBag.BAG_LAYER_HEIGHT;
			this.bagLayer.addChildAt(imgOptBgKuang, optIdx++);
			
			// 花框
//			var imgOutFrameDecorate:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_zhuangshinew", 15, 15,7,3);
//			imgOutFrameDecorate.x = 3;
//			imgOutFrameDecorate.y = 3;
//			imgOutFrameDecorate.width = ConstBag.BAG_LAYER_WIDTH - 6;
//			imgOutFrameDecorate.height = ConstBag.BAG_LAYER_HEIGHT - 6;
//			this.bagLayer.addChildAt(imgOutFrameDecorate, optIdx++);
			var panelFrame:CJPanelFrame = new CJPanelFrame(ConstBag.BAG_LAYER_WIDTH - 6, ConstBag.BAG_LAYER_HEIGHT - 6);
			panelFrame.x = 3;
			panelFrame.y = 3;
			this.bagLayer.addChildAt(panelFrame, optIdx++);
			
			// 操作层 - 边框
			var textureBiankuang:Texture = SApplication.assets.getTexture("common_waikuangnew");
			var bgScaleRangeBk:Rectangle = new Rectangle(15 , 15 , 1, 1);
			var bgTextureBk:Scale9Textures = new Scale9Textures(textureBiankuang, bgScaleRangeBk);
			var imgBiankuang:Scale9Image = new Scale9Image(bgTextureBk);
			imgBiankuang.width = ConstBag.BAG_LAYER_WIDTH;
			imgBiankuang.height = ConstBag.BAG_LAYER_HEIGHT;
			this.bagLayer.addChildAt(imgBiankuang, optIdx++);
			
			// 标题
			var title:CJPanelTitle = new CJPanelTitle(CJLang("BAG_TITLE"));
			title.x = 106;
			title.y = 6;
			this.addChild(title);
			
			// 获取页码底条纹理
			var texture:Texture = SApplication.assets.getTexture("common_fanyeyemawenzidi");
			// 设置伸缩纹理
			var scale9texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(5, 5, 1, 1));
			_imgYemaditiao.defaultSkin= new Scale9Image(scale9texture);
			
			// 设置页码的字体格式
			var fontFormat:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFFFFF );
			this.imgYemaditiao.defaultLabelProperties.textFormat = fontFormat;
			this._setPageIndexLabel();
			
			var imgFenge:SImage = new SImage(SApplication.assets.getTexture("common_fengexian"));
			imgFenge.x = 11;
			imgFenge.y = 251;
			imgFenge.width = 315;
			imgFenge.height = 2;
			this.bagLayer.addChild(imgFenge);
			
			// 关闭按钮
			this.btnGuanbi.defaultSkin  = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			this.btnGuanbi.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			// 为关闭按钮添加监听
			this.btnGuanbi.addEventListener(starling.events.Event.TRIGGERED, this._onClickClose);
			
			this.btnJiantouzuo.defaultSkin  = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnJiantouzuo.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnJiantouzuo.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnJiantouzuo.scaleX = -1;
//			this.btnJiantouzuo.x += this.btnJiantouzuo.width + 33;
			this.btnJiantouzuo.x += 15;
//			this.btnJiantouzuo.pivotX = this.btnJiantouzuo.width/2;
//			this.btnJiantouzuo.pivotY = this.btnJiantouzuo.height/2;
//			this.btnJiantouzuo.x += this.btnJiantouzuo.width/2;
//			this.btnJiantouzuo.y += this.btnJiantouzuo.height/2;
//			this.btnJiantouzuo.rotation = Math.PI / 2;
//			this.btnJiantouzuo.skewY = Math.PI;
			// 为箭头左按钮添加监听
			this.btnJiantouzuo.addEventListener(starling.events.Event.TRIGGERED, this._onClickBtnLeft);
			
			this.btnJiantouyou.defaultSkin  = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnJiantouyou.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnJiantouyou.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
//			this.btnJiantouyou.pivotX = this.btnJiantouyou.width/2;
//			this.btnJiantouyou.pivotY = this.btnJiantouyou.height/2;
//			this.btnJiantouyou.x += this.btnJiantouyou.width/2;
//			this.btnJiantouyou.y += this.btnJiantouyou.height/2;
//			this.btnJiantouyou.rotation = Math.PI / 2 * 3;
			// 为箭头右按钮添加监听
			this.btnJiantouyou.addEventListener(starling.events.Event.TRIGGERED, this._onClickBtnRight);
			// 重绘设置翻页按钮可用性
			this._redrawPageBtn();
			
			this.setChildIndex(this.btnGuanbi, this.numChildren - 1);
			
			this._bagData = CJDataManager.o.getData("CJDataOfBag");
			
			// tooltip layer
//			this._tooltipLayer = new CJBagItemTooltip();
			
			// expand layer
//			var expandXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlBagExpand) as XML;
//			this._expandLayer = SFeatherControlUtils.o.genLayoutFromXML(expandXml, CJBagExpandLayer) as CJBagExpandLayer;
			
			btnSellQuick = new Button();
			btnSellQuick.defaultSkin  = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			btnSellQuick.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			btnSellQuick.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			btnSellQuick.addEventListener(starling.events.Event.TRIGGERED, this._onClickBtnSellQuick);
			btnSellQuick.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			btnSellQuick.label = CJLang("BAG_SELL_QUICK");
			btnSellQuick.width = 82;
			btnSellQuick.height = 22;
			btnSellQuick.x = 234	;
			btnSellQuick.y = 254;
//			btnSellQuick.visible = false;
			this.bagLayer.addChild(btnSellQuick);
			
//			this.addEventListener(starling.events.TouchEvent.TOUCH, this._onClickLayerBackGround);
		}
		
		/**
		 * 点击一键卖出
		 * @param e
		 * 
		 */		
		private function _onClickBtnSellQuick(e:Event):void
		{
			
			// 改变背包状态为一键出售状态
			_changeQuickSellState();
		}

//		private function _onClickLayerBackGround(event:TouchEvent):void
//		{
//			var touch:Touch = event.getTouch(this.bagLayer, TouchPhase.BEGAN);
//			if (!touch)
//			{
//				return;
//			}
//			_changeQuickSellState();
//		}
		
		/**
		 * 切换一键出售状态
		 * 
		 */		
		private function _changeQuickSellState():void
		{
			if (false == _sellStatus)
			{
				// 普通状态 -> 一键出售状态 
				// 弹出提示框
				var contant:String = CJLang("BAG_QUICKSELL_MSG");
				CJMessageBox(contant);
				
				_sellStatus = true;
				btnSellQuick.label = CJLang("BAG_SELL_CANCEL");
			}
			else
			{
				// 一键出售状态 -> 普通状态
				_sellStatus = false;
				btnSellQuick.label = CJLang("BAG_SELL_QUICK");
			}
		}
		/**
		 * 添加监听事件
		 * 
		 */		
		private function _addListeners():void
		{
			// 添加数据监听
			this._addDataLiteners();
			
//			this._expandLayer.addEventListener(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE, _onCompleteExpand);
		}
		
		/**
		 * 初始化数据
		 * 
		 */
		private function _initData():void
		{
			//默认第一个背包物品栏按钮选中，其他的未选中
			_beibaoBtn0.isSelected = true;
			
			//设置背包物品层的起始坐标
			this.bagLayer.x = ConstBag.BagLayerX;
			this.bagLayer.y = ConstBag.BagLayerY;
			
			this._bagSettingData = CJDataOfBagProperty.o;
			this._bagSetting = this._bagSettingData.getBagType(ConstBag.CONTAINER_TYPE_BAG);
			// 背包容量上限
			this._bagMaxCount = parseInt(this._bagSetting.maxcount);
			// 单页行数
			this._bagRowNum = parseInt(this._bagSetting.rownum);
			// 单页列数
			this._bagColNum = parseInt(this._bagSetting.colnum);
			this._itemSpaceX = parseInt(this._bagSetting.rowdist);
			this._itemSpaceY = parseInt(this._bagSetting.coldist);
			// 单页格子数量
			this._onePageNum = _bagRowNum * _bagColNum;
			
			// 解锁的物品框数 
			this._currentUnlockedFrameNum = 0;
			
			//物品框总页数
			this._pageNum = this._bagMaxCount % this._onePageNum > 0 ? 
				(this._bagMaxCount / this._onePageNum + 1) :
				this._bagMaxCount / this._onePageNum;
			
			// 未解锁页不计入可翻显示页面，如下3行
//			_pageNum = _currentUnlockedFrameNum % _onePageNum > 0 ? 
//				(_currentUnlockedFrameNum / _onePageNum + 1) :
//				_currentUnlockedFrameNum / _onePageNum;
			
//			_bagFrameItems = new Array();
			_dataHeroList = CJDataManager.o.DataOfHeroList;
			_dataMainHero = _dataHeroList.getMainHero();
		}
		/**
		 * 添加相关监听器
		 */
		private function _addDataLiteners():void
		{
			// 监听背包数据获取成功
			this._bagData.addEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveBagData);
//			this._equipBar.addEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveEquipData);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, this._onRpcReturn);
		}
		
		/**
		 * 请求服务器数据
		 */
		private function _remoteDataRequest():void
		{
			if (!this._bagData.dataIsEmpty 
//				&& !this._equipBar.dataIsEmpty
			)
			{
				this._onReceiveData();
			}
			
			if (this._bagData.dataIsEmpty)
			{
				SocketCommand_item.getBag();
			}
			
//			if (this._equipBar.dataIsEmpty)
//			{
//				SocketCommand_item.get_equipmentbar();
//			}
		}

		/**
		 * 获取远程背包数据完成
		 */
		private function _onReceiveBagData(e:Event):void
		{
			this._onReceiveData();
		}
		
		private function _onReceiveEquipData(e:Event):void
		{
			this._onReceiveData();
		}
		
		private function _onReceiveData():void
		{
			if (this._bagData.dataIsEmpty 
//				|| this._equipBar.dataIsEmpty
			)
			{
				return;
			}
			// 当前已经解锁的物品框数
			this._currentUnlockedFrameNum = this._bagData.bagCount;
			
			this._drawOnePage();
			
			// 解除网络锁
//			SocketLockManager.KeyUnLock(ConstNetCommand.CS_ITEM_GET_BAG));
		}
		
		/**
		 * 点击关闭按钮
		 * @param e
		 * 
		 */		
		private function _onClickClose(e:Event):void{
			//退出背包模块
			SApplication.moduleManager.exitModule("CJBagModule");
		}
		/**
		 * 点击翻页按钮 - 左
		 * @param e
		 * 
		 */		
		private function _onClickBtnLeft(e:Event):void{
			
			if(this._currentPage <= 1) 
			{
				return;
			}
			
			this._currentPage --;
			this._onChangePageInfo();
		}
		/**
		 * 点击翻页按钮 - 右
		 * @param e
		 * 
		 */		
		private function  _onClickBtnRight(e:*):void{
			if(this._currentPage >= this._pageNum)
			{
				return;
			}
			
			this._currentPage++;
			this._onChangePageInfo();
		}
		
		private function _onChangePageInfo():void
		{
			// 添加网络锁
//			SocketLockManager.KeyLock(_LockKeyTurnPage);
			
			this._drawOnePage();
			this._setPageIndexLabel();
			this._redrawPageBtn();
			
			// 解除网络锁
//			SocketLockManager.KeyUnLock(_LockKeyTurnPage);
		}
		
		/**
		 * 重新绘制翻页按钮
		 * 
		 */		
		private function _redrawPageBtn():void
		{
			if(this._currentPage <= 1) 
			{
				this.btnJiantouzuo.isEnabled = false;
			}
			else
			{
				this.btnJiantouzuo.isEnabled = true;
			}
			if(this._currentPage >= this._pageNum)
			{
				this.btnJiantouyou.isEnabled = false;
			}
			else
			{
				this.btnJiantouyou.isEnabled = true;
			}
		}
		
		/**
		 * 设置页码索引
		 * @param scrollPage 
		 * @param imgYemaditiao
		 * 
		 */		
		private function _setPageIndexLabel():void
		{
			this._imgYemaditiao.label = this._currentPage + " / " + this._pageNum;
		}
		/**
		 *背包物品栏点击事件处理 
		 * @param event
		 * 
		 */		
		private function _buttonChangeHandler(event:Event):void
		{
			//获得当前点击的背包物品栏按钮
			var currentBtn:Button = event.currentTarget as Button;
			//如果当前点击的按钮不是默认的选中按钮，则把默认选中按钮的选中状态改为未选中
			if (this._beibaoBtn0 != currentBtn)
			{
				this._beibaoBtn0.isSelected = false;
			}
			if (this._oldBtn == currentBtn)
			{
				return;
			}
			//把当前点击的按钮设置为选中状态，上次选中的按钮设置为未选中状态
			if (null != _oldBtn)
			{
				this._oldBtn.isSelected = false;
			}
			currentBtn.isSelected = true;
			//把当前点击的按钮设置为上次选中的按钮
			this._oldBtn = currentBtn;
			//当选中装备按钮时
			if (this._beibaoBtn1 == currentBtn)
			{
				this._bagBtnLeftId = 1;
			}
			switch (currentBtn)
			{
				case _beibaoBtn0:
					this._curBagType = ConstBag.BAG_TYPE_ALL;
					break;
				case _beibaoBtn1:
					this._curBagType = ConstBag.BAG_TYPE_PROP;
					break;
				case _beibaoBtn2:
					this._curBagType = ConstBag.BAG_TYPE_EQUIP;
					break;
				case _beibaoBtn3:
					this._curBagType = ConstBag.BAG_TYPE_MATERIAL;
					break;
				case _beibaoBtn4:
					this._curBagType = ConstBag.BAG_TYPE_JEWEL;
					break;
			}
			this._currentPage = 1;
			this._onChangePageInfo();
		}

		/**
		 * 初始化背包物品栏控件
		 */
		private function _initFrameItems():Boolean
		{
			/** 物品框*/
			var imgTubiaoKuang:CJBagItem;

			var bagFrameItems:Array = new Array();
			
			//循环行数
			for(var j:uint = 0; j < _bagRowNum; j++)
			{
				//循环列数
				for (var k:uint = 0; k < this._bagColNum; k++)
				{
					imgTubiaoKuang = new CJBagItem(ConstBag.FrameCreateStateLocked);
					imgTubiaoKuang.x += this._itemSpaceX * k + ConstBag.BAG_ITEM_INITX;
					imgTubiaoKuang.y += this._itemSpaceY * j + ConstBag.BAG_ITEM_INITY;
					imgTubiaoKuang.width = ConstBag.BAG_ITEM_WIDTH;
					imgTubiaoKuang.height = ConstBag.BAG_ITEM_HEIGHT;
					imgTubiaoKuang.index = j * _bagColNum + k;
					imgTubiaoKuang.name = "bagitem_"+imgTubiaoKuang.index;
					bagFrameItems.push(imgTubiaoKuang);
					this.bagLayer.addChild(imgTubiaoKuang);
				}
			}
			//重新创建物品框数组
			this._bagFrameItems = bagFrameItems;
			return true;
		}
		/**
		 * 
		 * 创建背包物品框 
		 * @return 是否画完
		 * 
		 */
		private function _drawBagFrameItems():Boolean
		{
			if (this._bagFrameItems.length > 0)
			{
				return true;
			}
			this._initFrameItems();
			return true;
		}
		/**
		 *画出每一页的物品框 
		 * 
		 */
		private function _drawOnePage():void
		{
			// 绘制背包格
			var isDrawFinish:Boolean = _drawBagFrameItems();
			//当锁定物品框画完，将已经解锁的物品框解锁
			if(isDrawFinish)
			{
				this._drawBagGoodsItems();
			}
		}
		
		/**
		 * 创建背包物品框 
		 * @return 是否画完
		 */			
		private function _drawBagGoodsItems():void
		{
			// 当前应显示页格子数量
			var curPageMaxCount:uint = 0;
			if (this._currentPage == _pageNum)
			{
				curPageMaxCount = this._bagMaxCount - (this._currentPage - 1) * this._onePageNum;
			}
			else
			{
				curPageMaxCount = this._onePageNum;
			}
			
			// 当前页已解锁格子数量
			var curPageUnlockCount:int = this._currentUnlockedFrameNum - (this._currentPage - 1) * this._onePageNum;
			if (curPageUnlockCount > this._onePageNum)
			{
				curPageUnlockCount = this._onePageNum;
			}
			// 绘制前格子数量
			var countBefore:uint = this._bagFrameItems.length;
			
			// 绘制背包格数量
			if (countBefore != curPageMaxCount)
			{
				// 显示格子数量需要修改
				if (countBefore > curPageMaxCount)
				{
					// 背包格数量需要减少
					for (var index:uint = countBefore; index > curPageMaxCount; index--)
					{
						var cjBagItem:CJBagItem = this._bagFrameItems[index - 1];
						this.bagLayer.removeChild(cjBagItem);
						this._bagFrameItems[index - 1] = null;
						this._bagFrameItems.length--;
					}
				}
				else
				{
					// 背包格数量需要增加
					var k:uint = 0;
					var j:uint = 0;
					var imgTubiaoKuang:CJBagItem;
					for (var idx:uint=countBefore; idx < curPageMaxCount; idx++)
					{
						j = idx / this._bagColNum;
						k = idx % this._bagColNum;
						imgTubiaoKuang = new CJBagItem(ConstBag.FrameCreateStateLocked);
						imgTubiaoKuang.x += ConstBag.TwoGoodsFrameDistanceH * k;
						imgTubiaoKuang.y += ConstBag.TwoGoodsFrameDistanceV * j;
						this._bagFrameItems.push(imgTubiaoKuang);
						this.bagLayer.addChild(imgTubiaoKuang);
					}
				}
			}
			
			// 绘制背包格锁状态与道具
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			var bagItemDatas : Array = _getItemsByContainerType(_curBagType);
			_curItemDatas = bagItemDatas;
			var itemData:CJDataOfItem;
			var itemTemplate:Json_item_setting;
			// 本页背包格数起始位置
			var indexBegin:uint = _onePageNum * (_currentPage - 1);
			var bagItem:CJBagItem;
			_showFireArrowLvP = false;
			for (var i:uint=0; i < _bagFrameItems.length; i++)
			{
				bagItem = this._bagFrameItems[i];
//				if (bagItem == null)
//				{
//					continue;
//				}
				// 绘制锁状态
				if (i < curPageUnlockCount)
				{
					bagItem.status = ConstBag.FrameCreateStateUnlock;
				}
				else
				{
					bagItem.status = ConstBag.FrameCreateStateLocked;
				}
				bagItem.updateFrame();
				
				// 绘制道具
				if ((i + indexBegin) < bagItemDatas.length)
				{
					// 有道具
					itemData = bagItemDatas[i + indexBegin];
					itemTemplate = templateSetting.getTemplate(itemData.templateid)
					bagItem.setBagGoodsItem(itemTemplate.picture);
					bagItem.setQuality(int(itemTemplate.quality));
					bagItem.tmplData = itemTemplate;
					if (parseInt(itemTemplate.maxcount) > 1)
					{
						// 可叠加道具，显示数量
						bagItem.setBagGoodsCount(String(itemData.count));
					}
					else
					{
						// 不可叠加道具，不显示数量
						bagItem.setBagGoodsCount("");
					}
					bagItem.itemId = itemData.itemid;
					// 等级礼包选中
					_refreshLvPackage(itemTemplate, bagItem);
				}
				else
				{
					bagItem.setBagGoodsItem("");
					bagItem.clearItemId();
				}
				bagItem.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItem);
			}
			// 不显示等级礼包提示信息
			if (false == _showFireArrowLvP)
			{
				if (_fireArrowLvP != null)
				{
					this.bagLayer.removeChild(_fireArrowLvP);
					Starling.juggler.remove(_fireArrowLvP);
					_fireArrowLvP = null;
				}
			}
		}
		
		/**
		 * 显示toolTip
		 * @param event
		 * 
		 */
		private function _onClickItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.bagLayer, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
			}
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			var item:CJBagItem = event.currentTarget as CJBagItem;
			if (item.status == ConstBag.FrameCreateStateUnlock)
			{
				// 已解锁
				if ((item.itemId.length <= 0) || (parseInt(item.itemId) <= 0))
				{
					// 空格不做操作
					return;
				}
				
				if (false == _sellStatus)
				{
					// 非一键出售状态
					// 弹出tooltip框
					this._showTooltip(item.itemId)
				}
				else
				{
					// 一键出售状态
					if (int(item.templData.quality) >= ConstItem.SCONST_ITEM_QUALITY_TYPE_ORANGE)
					{
						CJConfirmMessageBox(CJLang("BAG_QUICKSELL_SELL_QUANLITY"), function():void{_sellItem(item);}, null);
					}
					else
					{
						_sellItem(item);
					}
				}
				
			}
			else if (item.status == ConstBag.FrameCreateStateLocked)
			{
				// 未解锁, 弹出解锁框
				this._showExpandLayer(item.index);
			}
		}
		
		private function _sellItem(item:CJBagItem):void
		{
			var itemTemplate:Json_item_setting = item.templData;
			if (ConstItem.SCONST_ITEM_SELL_STATE_CAN != parseInt(itemTemplate.sellstate))
			{
				// 不可出售道具
				CJFlyWordsUtil(CJLang("BAG_SELL_CANNOT"));
				return;
			}
			// 出售道具
			SocketCommand_item.sellItem(ConstBag.CONTAINER_TYPE_BAG, String(item.itemId));
		}
		
		/**
		 * 显示扩包界面
		 * @param event
		 * 
		 */		
		private function _showExpandLayer(index:int):void
		{
			var expandIndex:int = this._getExpadIndex(index);
			var expandCount:int = this._getExpandCount();
			
			this._expandIndex = expandIndex;
			
			var expandXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlBagExpand) as XML;
			this._expandLayer = SFeatherControlUtils.o.genLayoutFromXML(expandXml, CJBagExpandLayer) as CJBagExpandLayer;
			if (!this._expandLayer.hasEventListener(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE))
			{
				this._expandLayer.addEventListener(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE, _onCompleteExpand);
			}
			CJLayerManager.o.addModuleLayer(this._expandLayer);
			
			this._expandLayer.drawInfoWithData(expandIndex, expandCount);
		}
		
		/**
		 * 响应扩包成功事件
		 * @param event
		 * 
		 */		
		private function _onCompleteExpand(event:Event):void
		{
			// 已开格数量
			this._currentUnlockedFrameNum = this._bagData.bagCount;
			var curPageOpenCount:uint = this._bagData.bagCount - ((this._currentPage - 1) * this._bagRowNum * this._bagColNum)
			var bagItem:CJBagItem;
			for (var i:int = 0; i < this._bagFrameItems.length; i++)
			{
				bagItem = this._bagFrameItems[i];
				if (ConstBag.FrameCreateStateLocked == bagItem.status)
				{
					if (curPageOpenCount >= (i + 1))
					{
						bagItem.status = ConstBag.FrameCreateStateUnlock;
						bagItem.updateFrame();
					}
					else
					{
						break;
					}
				}
			}
			this._expandLayer.removeEventListener(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE, _onCompleteExpand);
		}
		
		/**
		 * 点击未解锁背包格，获取当前未解锁背包格索引数
		 * @param index 当前背包格在当前页索引
		 * @return 
		 * 
		 */		
		private function _getExpadIndex(index:int):int
		{
			var openCount:int = this._bagData.bagCount;
			var expandIndex:int = 0;
			if (this._currentPage <= 1)
			{
				expandIndex = index + 1 - openCount;
			}
			else
			{
				expandIndex = this._bagRowNum * this._bagColNum * (this._currentPage - 1) + index + 1 - openCount
			}
			return expandIndex;
		}
		
		/**
		 * 获取已经过解锁的背包格数量
		 * @return 
		 * 
		 */		
		private function _getExpandCount():int
		{
			// 已开格数量
			var openCount:int = this._bagData.bagCount;
			// 容器初始数量
			var initCount:int = this._bagSetting.initcount;
			return openCount - initCount;
		}
		
		/**
		 * 显示道具tooltip
		 * @param itemId 道具id
		 * 
		 */
		private function _showTooltip(itemId:String):void
		{
//			var tooltipLayer:CJBagItemTooltip = new CJBagItemTooltip();
//			tooltipLayer.setItemIdAndRefresh(ConstBag.CONTAINER_TYPE_BAG, itemId);
//			CJLayerManager.o.addModuleLayer(tooltipLayer);
			CJItemUtil.showItemInBagTooltips(itemId);
		}

		/**
		 * 根据容器类型获取对应类型的道具
		 */
		private function _getItemsByContainerType(type : int) : Array
		{
			return this._bagData.getItemsByContainerType(type);
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			for(var i:uint = 0; i < this.beibaoBtns.length; i++)
			{
				beibaoBtns[i].removeEventListener(starling.events.Event.TRIGGERED, _buttonChangeHandler);
			}
			this.btnGuanbi.removeEventListener(starling.events.Event.TRIGGERED, this._onClickClose);
			
			
			this.btnJiantouzuo.removeEventListener(starling.events.Event.TRIGGERED, this._onClickBtnLeft);
			this.btnJiantouyou.removeEventListener(starling.events.Event.TRIGGERED, this._onClickBtnRight);
			if (this._expandLayer != null)
			{
				this._expandLayer.removeEventListener(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE, _onCompleteExpand);
			}
			if (this._bagData != null)
			{
				this._bagData.removeEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveBagData);
			}
//			if (this._equipBar != null)
//			{
//				this._equipBar.removeEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveEquipData);
//			}
			
			var bagItem:CJBagItem;
			for (var idx:uint=0; idx < _bagFrameItems.length; idx++)
			{
				bagItem = this._bagFrameItems[idx];
				if (bagItem != null)
				{
					bagItem.removeEventListener(starling.events.TouchEvent.TOUCH, _onClickItem);
				}
			}
		}
		
		private function _refreshLvPackage(itemTemplate:Json_item_setting, bagItem:CJBagItem):void
		{
			if (true == _showFireArrowLvP)
			{
				return;
			}
			if (int(itemTemplate.type) != ConstItem.SCONST_ITEM_TYPE_USE)
			{
				return;
			}
			if (int(itemTemplate.subtype) != ConstItem.SCONST_ITEM_SUBTYPE_USE_LVPACKAGE)
			{
				return;
			}
			if (int(itemTemplate.level) > int(_dataMainHero.level))
			{
				return;
			}
			if (_fireArrowLvP == null)
			{
//				_showFireArrowLvP = true;
				_fireArrowLvP = new SAnimate(SApplication.assets.getTextures("common_kaiqi"), 6);
				_fireArrowLvP.width = bagItem.width + 30;
				_fireArrowLvP.height = bagItem.height + 30;
				_fireArrowLvP.touchable = false;
				this.bagLayer.addChild(_fireArrowLvP);
				Starling.juggler.add(_fireArrowLvP);
//				return;
			}
			
			_fireArrowLvP.x = bagItem.x - 15;
			_fireArrowLvP.y = bagItem.y - 15;
//			_fireArrowLvP.scaleX = _fireArrow.scaleY = 1.9;
			_showFireArrowLvP = true;
			
		}
		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_ITEM_SELL_ITEM)
			{
				// 出售道具
				if (msg.retcode == 0)
				{
					var retData:Object = msg.retparams;
					var sellType:int = retData.sellType;
					var money:int = retData.money;
					switch(sellType)
					{
						case ConstCurrency.CURRENCY_TYPE_SILVER:
							CJFlyWordsUtil(CJLang("BAG_SELL_ITEM_GET_CURRENCY", {"money":money}) + CJLang("CURRENCY_NAME_SILVER"));
							break;
						case ConstCurrency.CURRENCY_TYPE_GOLD:
							CJFlyWordsUtil(CJLang("BAG_SELL_ITEM_GET_CURRENCY", {"money":money}) + CJLang("CURRENCY_NAME_GOLD"));
							break;
						default:
							break;
					}
					// 更新页面货币显示
					SocketCommand_role.get_role_info();
					SocketCommand_item.getBag();
				}
			}
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, this._onRpcReturn);
		}
		
		/** Controls */
		/** *页码底条图片 */
		private var _imgYemaditiao:Button;
		/** 页码 */
		private var _labelPage:Label;
		/** 全部选中按钮 */
		private var _beibaoBtn0:Button;
		/** 道具按钮 */
		private var _beibaoBtn1:Button;
		/** 装备按钮 */
		private var _beibaoBtn2:Button;
		/** 材料按钮 */
		private var _beibaoBtn3:Button;
		/** 材料按钮 */
		private var _beibaoBtn4:Button;
		/** 箭头左按钮 */
		private var _btnJiantouzuo:Button;
		/** 箭头右按钮 */
		private var _btnJiantouyou:Button;
		/** 背包的物品层 */	
		private var _bagLayer:SLayer;
		/** 关闭按钮 */
		private var _btnGuanbi:Button;
		/** 背包背景图 */
		private var _imgBagLayerBg:ImageLoader;
		/** 标题 */
		private var _labTitle:Label;
		
		private var _btnSellQuick:Button;
		
		/** Controlers getter */
		/**
		 *页码底条图片 
		 */
		public function get imgYemaditiao():Button
		{
			return _imgYemaditiao;
		}
		/**
		 * @private
		 */
		/**
		 *页码 
		 */
		public function get labelPage():Label
		{
			return _labelPage;
		}
		/**
		 * 全部选中按钮
		 * 
		 */
		public function get beibaoBtn0():Button
		{
			return _beibaoBtn0;
		}
		/**
		 * 道具按钮
		 * 
		 */
		public function get beibaoBtn1():Button
		{
			return _beibaoBtn1;
		}
		/**
		 * 装备按钮
		 * 
		 */
		public function get beibaoBtn2():Button
		{
			return _beibaoBtn2;
		}
		/**
		 * 材料按钮
		 * 
		 */
		public function get beibaoBtn3():Button
		{
			return _beibaoBtn3;
		}
		/**
		 * 宝石按钮
		 * 
		 */
		public function get beibaoBtn4():Button
		{
			return _beibaoBtn4;
		}
		/**
		 * 箭头左按钮
		 * 
		 */
		public function get btnJiantouzuo():Button
		{
			return _btnJiantouzuo;
		}
		/**
		 * 箭头右按钮
		 * 
		 */
		public function get btnJiantouyou():Button
		{
			return _btnJiantouyou;
		}
		/**
		 * 关闭按钮
		 * 
		 */
		public function get btnGuanbi():Button
		{
			return _btnGuanbi;
		}
		/**
		 * 背包的物品层
		 * 
		 */		
		public function get bagLayer():SLayer
		{
			return _bagLayer;
		}
		public function get imgBagLayerBg():ImageLoader
		{
			return _imgBagLayerBg;
		}
		public function get labTitle():Label
		{
			return _labTitle;
		}
		public function get btnSellQuick():Button
		{
			return _btnSellQuick;
		}
		
		
		
		/** Controlers setter */
		public function set imgYemaditiao(value:Button):void
		{
			_imgYemaditiao = value;
		}
		public function set labelPage(value:Label):void
		{
			_labelPage = value;
		}
		public function set beibaoBtn0(value:Button):void
		{
			_beibaoBtn0 = value;
		}
		public function set beibaoBtn1(value:Button):void
		{
			_beibaoBtn1 = value;
		}
		public function set beibaoBtn2(value:Button):void
		{
			_beibaoBtn2 = value;
		}
		public function set beibaoBtn3(value:Button):void
		{
			_beibaoBtn3 = value;
		}
		public function set beibaoBtn4(value:Button):void
		{
			_beibaoBtn4 = value;
		}
		public function set btnJiantouzuo(value:Button):void
		{
			_btnJiantouzuo = value;
		}
		public function set btnJiantouyou(value:Button):void
		{
			_btnJiantouyou = value;
		}
		public function set btnGuanbi(value:Button):void
		{
			_btnGuanbi = value;
		}
		public function set bagLayer(value:SLayer):void
		{
			_bagLayer = value;
		}
		public function set imgBagLayerBg(value:ImageLoader):void
		{
			_imgBagLayerBg = value;
		}
		public function set labTitle(value:Label):void
		{
			_labTitle = value;
		}
		public function set btnSellQuick(value:Button):void
		{
			_btnSellQuick = value;
		}
	}
}