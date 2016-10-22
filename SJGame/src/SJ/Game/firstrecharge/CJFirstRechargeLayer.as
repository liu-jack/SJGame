package SJ.Game.firstrecharge
{
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstFirstRecharge;
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_firstrecharge;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfItemPackageProperty;
	import SJ.Game.data.json.Json_item_package_config;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.jewelCombine.CJJewelCombineUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	/**
	 * 首次充值层
	 * @author zhengzheng
	 * 
	 */	
	public class CJFirstRechargeLayer extends SLayer
	{
		/** 充值奖励配置物品数组 */
		private var _arrayPkgCfg:Array;
		/** 星星动画显示坐标数组 */
		private var _arraySatrAnimCoord:Array = [
			[0, 40],
			[164, 32],
			[280, 103],
			[303, 174],
			[116, 180]
		];
		/**星星特效*/
		private var _starAnim:SAnimate;
		/**星星特效数组*/
		private var _starAnims:Array;
		
		public function CJFirstRechargeLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
			_addListeners();
		}
		
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			var packageTemplateProperty:CJDataOfItemPackageProperty = CJDataOfItemPackageProperty.o;
			var giftTmpl:String  = String(CJDataOfGlobalConfigProperty.o.getData("FIRSTRECHARGE_GIFT_TMPL"));
			_arrayPkgCfg = packageTemplateProperty.getPackageConfig(giftTmpl);
			_starAnims = new Array();
		}
		
		/**
		 * 绘制界面内容
		 */		
		private function _drawContent():void
		{
			//背景底图
			var imgBg:ImageLoader = new ImageLoader();
			imgBg.source = SApplication.assets.getTexture("shouchong_bitu");
			imgBg.x = 9;
			imgBg.y = 52;
			imgBg.width = 466;
			imgBg.height = 249;
			this.addChildAt(imgBg, 0);
			
			//背景装饰图
			var imgFrameDecorate:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("kfcontend_kuang", 100 ,25 , 1, 1);
			imgFrameDecorate.x = 0;
			imgFrameDecorate.y = 46;
			imgFrameDecorate.width = 480;
			imgFrameDecorate.height = 265;
			this.addChildAt(imgFrameDecorate, 1);
			
			//文字底图1
			var imgBgFont1:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("shouchong_xiaokuang", 10 ,10 , 1, 1);
			imgBgFont1.x = 150;
			imgBgFont1.y = 118;
			imgBgFont1.width = 314;
			imgBgFont1.height = 33;
			this.addChildAt(imgBgFont1, getChildIndex(labDes3) - 1);
			
			//文字底图2
			var imgBgFont2:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("shouchong_xiaokuang", 10 ,10, 1, 1);
			imgBgFont2.x = 77;
			imgBgFont2.y = 189;
			imgBgFont2.width = 334;
			imgBgFont2.height = 33;
			this.addChildAt(imgBgFont2, getChildIndex(labDes4) - 1);
			
			
			//奖励物品底图
			var imgBgGift:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("shouchong_jianglikuang", 5 ,5 , 1, 1);
			imgBgGift.x = 77;
			imgBgGift.y = 223;
			imgBgGift.width = 332;
			imgBgGift.height = 69;
			this.addChildAt(imgBgGift, getChildIndex(imgBgFont2) - 1);
			
			var imgArrowLeft:ImageLoader = new ImageLoader();
			imgArrowLeft.source = SApplication.assets.getTexture("shouchong_jiantou");
			imgArrowLeft.x = 247;
			imgArrowLeft.y = 134;
			imgArrowLeft.width = 33;
			imgArrowLeft.height = 33;
			imgArrowLeft.pivotX = imgArrowLeft.width / 2;
			imgArrowLeft.pivotY = imgArrowLeft.height / 2;
			imgArrowLeft.rotation = Math.PI / 2;
//			this.addChild(imgArrowLeft);
			
			_imgArrowDown.visible = false;
			
			_setTextShow();
			_drawRechargeItem();
			_drawStarAnim();
		}
		
		/**
		 * 绘制星星动画
		 * 
		 */		
		private function _drawStarAnim():void
		{
			var imgStars:Vector.<Texture> = SApplication.assets.getTextures("xiangqiankaikong_");
			for (var i:int = 0; i < _arraySatrAnimCoord.length; i++) 
			{
				_starAnim = new SAnimate(imgStars, 5);
				//设置动画的坐标
				_starAnim.x = _arraySatrAnimCoord[i][0];
				_starAnim.y = _arraySatrAnimCoord[i][1];
				_starAnim.touchable = false;
				this.addChild(_starAnim);
				Starling.juggler.add(_starAnim);
				_starAnim.play();
				_starAnims.push(_starAnim);
			}
			
		}
		/**
		 * 绘制奖励物品
		 */		
		private function _drawRechargeItem():void
		{
			var initX:int = 84;
			var initY:int = 233;
			var unitWidth:int = 55;
			var index:int = 0;
			for each (var packageCfg:Json_item_package_config in _arrayPkgCfg)
			{
				var item:CJBagItem = new CJBagItem();
				item.x = initX + index * unitWidth;
				item.y = initY;
				index ++;
				item.setBagGoodsItemByTmplId(int(packageCfg.itemid));
				item.setBagGoodsCount(String(packageCfg.itemcount));
				this.addChild(item);
				item.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItem);
			}
			
		}
		
		/**
		 * 触发点击一个CJBagItem事件
		 * @param event
		 * 
		 */
		private function _onClickItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (!touch || touch.phase != TouchPhase.ENDED)
			{
				return;
			}
			var item:CJBagItem = event.currentTarget as CJBagItem;
			var templateId:int = item.templateId;
			if (templateId != 0)
			{
				CJJewelCombineUtil.o.showJeweltip(templateId);
			}
		}
		
		/**
		 * 设置文本显示
		 */
		private function _setTextShow():void
		{
			var fontFormat:TextFormat = new TextFormat( "Arial", 12, 0xE4A35E);
			labDes1.textRendererProperties.textFormat = fontFormat;
			labDes1.textRendererFactory = textRender.htmlTextRender;
			labDes1.text = CJLang("FIRST_RECHARGE_DES1");
			labDes2.textRendererProperties.textFormat = fontFormat;
			labDes2.textRendererFactory = textRender.htmlTextRender;
			labDes2.text = CJLang("FIRST_RECHARGE_DES2");
			labDes3.textRendererProperties.textFormat = fontFormat;
			labDes3.textRendererFactory = textRender.htmlTextRender;
			labDes3.text = CJLang("FIRST_RECHARGE_DES3");
			labDes4.textRendererProperties.textFormat = fontFormat;
			labDes4.textRendererFactory = textRender.htmlTextRender;
			labDes4.text = CJLang("FIRST_RECHARGE_DES4");
			
			fontFormat = new TextFormat( "Arial", 10, 0xFF0000);
			labDes5.textRendererProperties.textFormat = fontFormat;
			labDes5.textRendererProperties.wordWrap = true;
			labDes5.text = CJLang("FIRST_RECHARGE_GET_DES");
			
			
			fontFormat = new TextFormat( "Arial", 12, 0xE7F0AA);
			btnRecharge.defaultLabelProperties.textFormat = fontFormat;
			btnRecharge.label = CJLang("FIRST_RECHARGE_RECHARGE");
			
			btnGetGift.defaultLabelProperties.textFormat = fontFormat;
			btnGetGift.label = CJLang("FIRST_RECHARGE_GET_GIFT");
			btnGetGift.visible = false;
		}
		/**
		 * 添加监听
		 */
		private function _addListeners():void
		{
			_btnRecharge.addEventListener(Event.TRIGGERED, _rechargeTriggered);
			_btnGetGift.addEventListener(Event.TRIGGERED, _getGiftTriggered);
			_btnClose.addEventListener(Event.TRIGGERED, _closeTriggered);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onGetGiftRequestReturn);
		}
		
		/**
		 * 立即领取按钮触发
		 * 
		 */
		private function _getGiftTriggered(e:Event):void
		{
			SocketCommand_firstrecharge.getGiftBag();
		}
		/**
		 * 充值按钮触发
		 * 
		 */		
		private function _rechargeTriggered(e:Event):void
		{
			_closeTriggered(e);
			if(ConstPlatformId.isWebChargeChannel())
			{
				CJMapUtil.enterCharge();
				return;
			}
			SApplication.moduleManager.enterModule("CJRechargeModule");
		}
		
		/**
		 * 领取首充礼包返回响应
		 * @param e
		 * 
		 */		
		private function _onGetGiftRequestReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_FIRST_RECHARGE_GET_GIFT_BAG)
			{
				switch(msg.retcode)
				{
					case ConstFirstRecharge.FIRST_RECHARGE_GET_SUCCESS:
						_closeTriggered(e);
						CJFlyWordsUtil(CJLang("FIRST_RECHARGE_GET_SUCCESS"));
						SApplication.moduleManager.enterModule("CJDynamicModule", {"pagetype":ConstDynamic.DYNAMIC_TYPE_SYSTEM});
						break;
					case ConstFirstRecharge.FIRST_RECHARGE_NO_RECHARGE:
						CJFlyWordsUtil(CJLang("FIRST_RECHARGE_NO_RECHARGE"));
						break;
					case ConstFirstRecharge.FIRST_RECHARGE_GET_ALREADY:
						CJFlyWordsUtil(CJLang("FIRST_RECHARGE_GET_ALREADY"));
						break;
					case ConstFirstRecharge.FIRST_RECHARGE_BAG_FULL:
						CJFlyWordsUtil(CJLang("FIRST_RECHARGE_BAG_FULL"));
						break;
					default:
						break;
				}
			}
		}
		
		
		
		/**
		 * 关闭按钮触发
		 * 
		 */	
		private function _closeTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJFirstRechargeModule");
		}
		
		override public function dispose():void
		{
			super.dispose();
			if (_starAnims)
			{
				for (var i:int = 0; i < _starAnims.length; i++) 
				{
					if (_starAnims[i])
					{
						_starAnims[i].removeFromJuggler();
					}
				}
				
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onGetGiftRequestReturn);
		}
		
		
		
		
		private var _imgArrowDown:ImageLoader;
		/** 向下箭头图 **/
		public function get imgArrowDown():ImageLoader
		{
			return _imgArrowDown;
		}
		/** @private **/
		public function set imgArrowDown(value:ImageLoader):void
		{
			_imgArrowDown = value;
		}

		private var _btnClose:Button;
		/** 关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		private var _btnGetGift:Button;
		/** 领取奖励按钮 **/
		public function get btnGetGift():Button
		{
			return _btnGetGift;
		}
		/** @private **/
		public function set btnGetGift(value:Button):void
		{
			_btnGetGift = value;
		}
		private var _imgPerson:ImageLoader;
		/** 人物图 **/
		public function get imgPerson():ImageLoader
		{
			return _imgPerson;
		}
		/** @private **/
		public function set imgPerson(value:ImageLoader):void
		{
			_imgPerson = value;
		}
		private var _labDes2:Label;
		/** 充值说明2 **/
		public function get labDes2():Label
		{
			return _labDes2;
		}
		/** @private **/
		public function set labDes2(value:Label):void
		{
			_labDes2 = value;
		}
		private var _labDes3:Label;
		/** 充值说明3 **/
		public function get labDes3():Label
		{
			return _labDes3;
		}
		/** @private **/
		public function set labDes3(value:Label):void
		{
			_labDes3 = value;
		}
		private var _labDes1:Label;
		/** 充值说明1 **/
		public function get labDes1():Label
		{
			return _labDes1;
		}
		/** @private **/
		public function set labDes1(value:Label):void
		{
			_labDes1 = value;
		}
		private var _btnRecharge:Button;
		/** 前往充值按钮 **/
		public function get btnRecharge():Button
		{
			return _btnRecharge;
		}
		/** @private **/
		public function set btnRecharge(value:Button):void
		{
			_btnRecharge = value;
		}
		private var _labDes4:Label;
		/** 充值说明4 **/
		public function get labDes4():Label
		{
			return _labDes4;
		}
		/** @private **/
		public function set labDes4(value:Label):void
		{
			_labDes4 = value;
		}
		private var _labDes5:Label;
		/** 充值说明5 **/
		public function get labDes5():Label
		{
			return _labDes5;
		}
		/** @private **/
		public function set labDes5(value:Label):void
		{
			_labDes5 = value;
		}
		private var _imgTitle:ImageLoader;
		/** 标头 **/
		public function get imgTitle():ImageLoader
		{
			return _imgTitle;
		}
		/** @private **/
		public function set imgTitle(value:ImageLoader):void
		{
			_imgTitle = value;
		}

	}
}