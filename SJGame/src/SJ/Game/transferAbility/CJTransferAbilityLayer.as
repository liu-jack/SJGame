package SJ.Game.transferAbility
{
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTransferAbility;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_enhance;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_herostar;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_itemRecast;
	import SJ.Game.SocketServer.SocketCommand_jewel;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketCommand_transferAbility;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJHeartbeatEffectUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfTransferAbility;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.enhanceequip.CJEnhanceLayerCheckbox;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 传功界面
	 * @author zhengzheng
	 * 
	 */	
	public class CJTransferAbilityLayer extends SLayer
	{
		/** 武将头像层 */
		private var _layerHero:CJTransferAbilityHeroLayer;
		/** 右侧操作层 */
		private var _operatLayer:SLayer;
		/** 使用传功丹说明*/
		private var _labUseMyax:Label;
		/** 拥有传功丹*/
		private var _labHaveMyax:Label;
		/** 传功按钮*/
		private var _btnTransferAbility:Button;
		/** 关闭按钮*/
		private var _btnClose:Button;
		/** 复选框*/
		private var _checkbox:CJEnhanceLayerCheckbox;
		/**选中按钮点击区域*/
		private var _btnSelectRegion:Button;
		/** 购买*/
		private var _labBuy:Label;
		/** 当前武将id */
		private var _curHeroId:String;
		/** 当前武将模板id */
		private var _curHeroTmplId:int;
		/** 显示武将数组 */
		private var _arrayHero:Array;
		/** 传功阵型信息 */
		private var _transferAbilityData:CJDataOfTransferAbility;
		/** 背包数据 */
		private var _dataBag:CJDataOfBag;
		/** 传功丹模板id*/
		private var _tansMyaxTmplId:int;
		/** 传功后延迟调用*/
		private var _delayHandle:DelayedCall;
		/** 接收传功武将id*/
		private var _heroIdNew:String;
		/** 发出传功武将id*/
		private var _heroIdOld:String;
		public function CJTransferAbilityLayer()
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
		 * 
		 */		
		private function _initData():void
		{
			this._arrayHero = new Array();
			_transferAbilityData = CJDataOfTransferAbility.o;
			_dataBag = CJDataManager.o.DataOfBag;
			// 全局配置
			var globalConfig:CJDataOfGlobalConfigProperty = CJDataOfGlobalConfigProperty.o;
			// 传功需要的传功丹模板id
			_tansMyaxTmplId = int(globalConfig.getData("TRANS_ITEM_TEMPLATE_ID"));
		}
		
		/**
		 * 绘制内容
		 * 
		 */		
		private function _drawContent():void
		{
			// 背景遮罩图
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanbingdise", 1, 1,1,1);
			imgBg.width = SApplicationConfig.o.stageWidth;
			imgBg.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(imgBg, 0);
			
			// 全屏头部底
			var imgHeadBg:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			imgHeadBg.width = SApplicationConfig.o.stageWidth;
			this.addChildAt(imgHeadBg, 1);
			
			// 边角
			var imgBgcorner:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanpingzhuangshi", 14, 13, 1, 1);
			imgBgcorner.width = SApplicationConfig.o.stageWidth;
			imgBgcorner.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(imgBgcorner, 2);
			
			//标题
			var labTitle:CJPanelTitle = new CJPanelTitle(CJLang("TRANSFER_ABILITY_TRANSFER_ABILITY"));
			this.addChildAt(labTitle, 3);
			labTitle.x = 90;
			labTitle.y = 0;
			
			//操作层背景底图
			var imgOperateBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinew", 1, 1,1,1);
			imgOperateBg.width = this.operatLayer.width;
			imgOperateBg.height = this.operatLayer.height;
			this.operatLayer.addChildAt(imgOperateBg, 0);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.operatLayer.width - 8 , this.operatLayer.height - 8);
			bgBall.x = 4;
			bgBall.y = 4;
			this.operatLayer.addChildAt(bgBall, 1);
			
			//操作层遮罩
			var imgOperateShade:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 40, 40,1,1);
			imgOperateShade.width = this.operatLayer.width - 20;
			imgOperateShade.height = this.operatLayer.height - 20;
			imgOperateShade.x = 10;
			imgOperateShade.y = 10;
			this.operatLayer.addChildAt(imgOperateShade, 2);
			
			//操作层 - 外边框图
			var imgOutFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew", 15 , 15 , 1, 1);
			imgOutFrame.width = this.operatLayer.width;
			imgOutFrame.height = this.operatLayer.height;
			this.operatLayer.addChildAt(imgOutFrame, 3);
			//显示武将单元
			var initX:int = 20;
			var initY:int = 15;
			var unitWidth:int = 195;
			for (var i:int = 0; i < ConstTransferAbility.TRANSFER_ABILITY_HERO_NUM; i++) 
			{
				var transferAbilityItemXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlTransferAbilityHero) as XML;
				var heroItem:CJTransferAbilityHeroItemLayer = SFeatherControlUtils.o.genLayoutFromXML(transferAbilityItemXml, 
					CJTransferAbilityHeroItemLayer) as CJTransferAbilityHeroItemLayer;
				heroItem.x = initX + i * unitWidth;
				heroItem.y = initY;
				heroItem.id = i;
				this._arrayHero.push(heroItem);
				this.operatLayer.addChildAt(heroItem, (4 + i));
			}
			
			// 分割线
			var imgLine:ImageLoader = new ImageLoader();
			imgLine.source = SApplication.assets.getTexture("common_fengexian");
			imgLine.x = 10;
			imgLine.y = 158;
			this.operatLayer.addChildAt(imgLine, 6);
			
			// 复选框
			_checkbox = new CJEnhanceLayerCheckbox;
			_checkbox.initLayer();
			_checkbox.x = 26;
			_checkbox.y = 232;
			_checkbox.checked = false;
			this.operatLayer.addChildAt(_checkbox, 7);
			
			//选中按钮点击区域
			_btnSelectRegion = new Button();
			_btnSelectRegion.defaultSkin = new SImage(Texture.fromColor(25,25,0x00FFFFFF,false,SApplication.assets.scaleFactor),true);
			_btnSelectRegion.x = 23;
			_btnSelectRegion.y = 229;
			this.operatLayer.addChildAt(_btnSelectRegion, 8);
			
			_labBuy = new Label();
			_labBuy.x = 181;
			_labBuy.y = 249;
			this.operatLayer.addChildAt(_labBuy, 9);
			
			// 传功箭头
			var imgArrow:ImageLoader = new ImageLoader();
			imgArrow.source = SApplication.assets.getTexture("chuangong_jiantou");
			imgArrow.x = 185;
			imgArrow.y = 76;
			this.operatLayer.addChildAt(imgArrow, 10);
			
			// 传功后文字
			var imgAfterTrans:ImageLoader = new ImageLoader();
			imgAfterTrans.source = SApplication.assets.getTexture("chuangong_wenzi");
			imgAfterTrans.x = 130;
			imgAfterTrans.y = 24;
			this.operatLayer.addChildAt(imgAfterTrans, 11);
			
			this.setChildIndex(btnClose, this.numChildren - 1);
			this.setChildIndex(labTitle, this.getChildIndex(btnClose) - 1);
			
			_setTextShow();
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		/**
		 * 设置文本显示
		 */		
		private function _setTextShow():void
		{
			var fontFormat:TextFormat = new TextFormat( "黑体", 10, 0x8FF24D);
			_labUseMyax.textRendererProperties.textFormat = fontFormat;
			_labUseMyax.text = CJLang("TRANSFER_ABILITY_USE_MYAX").replace("{count}", "0");
			
			fontFormat = new TextFormat( "Arial", 10, 0xE8EC61);
			_labHaveMyax.textRendererProperties.textFormat = fontFormat;
			var myaxCount:int = _dataBag.getItemCountByTmplId(_tansMyaxTmplId);
			_labHaveMyax.text = CJLang("TRANSFER_ABILITY_HAVE_MYAX").replace("{count}", myaxCount);
			
			fontFormat = new TextFormat( "黑体", 10, 0xC36508, null, null, true);
			_labBuy.textRendererProperties.textFormat = fontFormat;
			_labBuy.text = CJLang("TRANSFER_ABILITY_BUY");
			
			fontFormat = new TextFormat( "黑体", 12, 0xC2B68F);
			_btnTransferAbility.defaultLabelProperties.textFormat = fontFormat;
			_btnTransferAbility.labelFactory = textRender.standardTextRender;
			_btnTransferAbility.label = CJLang("TRANSFER_ABILITY_TRANSFER_ABILITY");
		}
		/**
		 * 添加监听
		 * 
		 */		
		private function _addListeners():void
		{
			//添加背包数据改变监听
			_dataBag.addEventListener(DataEvent.DataLoadedFromRemote , _bagDataChangeHandler);
			_labBuy.addEventListener(starling.events.TouchEvent.TOUCH, _labBuyClicked);
			// 为关闭按钮添加监听
			this._btnClose.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				// 退出模块
				SApplication.moduleManager.exitModule("CJTransferAbilityModule");
			});
			CJEventDispatcher.o.addEventListener(ConstTransferAbility.TRANSFER_ABILITY_NEED_MYAX_NUM ,_updateTransInfo);
			_btnTransferAbility.addEventListener(starling.events.Event.TRIGGERED, _tansClicked);
			_btnSelectRegion.addEventListener(Event.TRIGGERED , this._checkboxClicked);
		}	
		
		
		
		/**
		 * 背包数据改变处理
		 * 
		 */		
		private function _bagDataChangeHandler():void
		{
			var myaxCount:int = _dataBag.getItemCountByTmplId(_tansMyaxTmplId);
			_labHaveMyax.text = CJLang("TRANSFER_ABILITY_HAVE_MYAX").replace("{count}", myaxCount);
		}
		/**
		 * 触发传功事件
		 * 
		 */		
		private function _tansClicked():void
		{
			SSoundEffectUtil.playButtonNormalSound();
			_heroIdNew = _transferAbilityData.getHeroIdByPos(0);
			_heroIdOld = _transferAbilityData.getHeroIdByPos(1);
			var isInFormation:Boolean = CJDataManager.o.DataOfFormation.isHeroPlaced(_heroIdOld);
			if (int(_heroIdOld) != -1 && int(_heroIdOld) != 0)
			{
				if (int(_heroIdNew) != -1 && int(_heroIdNew) != 0)
				{
					if (!isInFormation)
					{
						var leftHeroItem:CJTransferAbilityHeroItemLayer = _arrayHero[0] as CJTransferAbilityHeroItemLayer;
						var leftHeroLvAfterTrans:int = ConstTransferAbility.leftHeroLvAfterTrans;
						var heroLvNew:int = int(CJDataManager.o.DataOfHeroList.getHero(_heroIdNew).level);
						if (ConstTransferAbility.isLvReach)
						{
							CJConfirmMessageBox(CJLang("TRANSFER_ABILITY_HERO_LV_LOWER", {"curlevel":heroLvNew, "tolevel":leftHeroLvAfterTrans}), _confirmTrans)
						}
						else
						{
							//添加数据到达监听 
							SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadHeroTransInfo);
							SocketCommand_transferAbility.heroTrans(_heroIdNew, _heroIdOld, _checkbox.isChecked);
						}
					}
					else
					{
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_IN_FORMATION"));
					}
				}
				else
				{
					CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_NEW_NOT_EXIST"));
				}
			}
			else
			{
				CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_NOT_EXIST"));
			}
			
		}
		
		private function _confirmTrans():void
		{
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadHeroTransInfo);
			SocketCommand_transferAbility.heroTrans(_heroIdNew, _heroIdOld, _checkbox.isChecked);
		}
		
		/**
		 * 加载服务器武将传功后数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadHeroTransInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_TRANS_HERO_TRANS)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadHeroTransInfo);
				switch(message.retcode)
				{
					case ConstTransferAbility.TRANSFER_ABILITY_SUCCESS:
						var retData:Object = message.retparams;
						var heroIdNew:String = retData.heroidnew;
						var heroIdOld:String = retData.heroidold;
//						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_SUCCESS"));
						_playAnim(heroIdOld);
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_NEW_NOT_EXIST:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_NEW_NOT_EXIST"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_NOT_EXIST:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_NOT_EXIST"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_NEW_IS_MAIN_HERO:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_NEW_IS_MAIN_HERO"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_IS_MAIN_HERO:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_IS_MAIN_HERO"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_LV_NOT_REACH:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_LV_NOT_REACH"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_MYAX_NOT_ENOUGH:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_MYAX_NOT_ENOUGH"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_MYAX_USE_FAIL:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_MYAX_NOT_ENOUGH"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_IN_FORMATION:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_IN_FORMATION"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_BAG_SPACE_NOT_ENOUGH:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_BAG_SPACE_NOT_ENOUGH"));
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_LEVEL_HIGHER:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_LEVEL_HIGHER"));
						break;
					default:
						Assert(false, "传功返回码错误");
						break;
				}
			}
		}
		
		private function _playAnim(heroIdOld:String):void
		{
			CJHeartbeatEffectUtil("chuangong_kaishichuangong", 1, 2);
			var animate:SAnimate = new SAnimate(SApplication.assets.getTextures(ConstResource.sResUplevelAnims));
			animate.x = -37;
			animate.y = -46;
			animate.scaleX = animate.scaleY = 1.5;
			Starling.juggler.add(animate);
			animate.gotoAndPlay();
			(this._arrayHero[0] as CJTransferAbilityHeroItemLayer).addChild(animate);
			animate.addEventListener(Event.COMPLETE , function(e:Event):void
			{
				if(e.target is SAnimate)
				{
					animate.removeFromParent();
					animate.removeFromJuggler();
				}
			});
			//获取背包数据
			_dataBag.loadFromRemote();
			ConstTransferAbility.transInfo = null;
			
//			rightHeroItem.diposeShowData(rightHeroItem.id);
			//获取装备强化信息
			SocketCommand_enhance.getEquipEnhanceInfo();
			//获取武将星级数据
			SocketCommand_herostar.get_herostarInfo();
			//获取宝石镶嵌数据
			SocketCommand_jewel.getInlayInfo();
			// 请求装备栏数据
			SocketCommand_item.get_equipmentbar();
			// 请求武将装备数据
			SocketCommand_hero.get_puton_equip();
			// 更新主界面战斗力
			SocketCommand_hero.get_heros();
			// 洗练属性
			SocketCommand_itemRecast.getEquipRecastInfo();
			CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_HEROTRANSFER});
			_delayHandle = Starling.juggler.delayCall(function ():void{
				var rightHeroItem:CJTransferAbilityHeroItemLayer = _arrayHero[1] as CJTransferAbilityHeroItemLayer;
				//			rightHeroItem.npc.dead();
				var rightHeroData:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(heroIdOld);
				rightHeroItem.setCurHeroInfo(rightHeroData);
//				_transferAbilityData.saveFormation(heroIdOld, -1, rightHeroItem.id);
//				if (rightHeroItem.npc)
//				{
//					rightHeroItem.npc.removeFromParent(true);
//				}
				Starling.juggler.remove(_delayHandle);
				_delayHandle = null;
			}, 1);
		}
		
		/**
		 * 更新传功需要的传功丹个数
		 * @param e
		 * 
		 */		
		private function _updateTransInfo(e:Event):void
		{
			var count:int = e.data.count;
			_labUseMyax.text = CJLang("TRANSFER_ABILITY_USE_MYAX").replace("{count}", String(count));
		}
		
		override public function dispose():void
		{
			if (_dataBag)
			{
				_dataBag.removeEventListener(DataEvent.DataLoadedFromRemote , _bagDataChangeHandler);
			}
			CJEventDispatcher.o.removeEventListener(ConstTransferAbility.TRANSFER_ABILITY_NEED_MYAX_NUM ,_updateTransInfo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadHeroTransInfo);
			super.dispose();
		}
		/**
		 * 点击复选框事件
		 * @param e
		 * 
		 */		
		private function _checkboxClicked():void
		{
			SSoundEffectUtil.playButtonNormalSound();
			_checkbox.checked = !_checkbox.isChecked;
			(this._arrayHero[0] as CJTransferAbilityHeroItemLayer).updateDataIsUseMyax();
		}
		/**
		 * 点击购买事件
		 * @param e
		 * 
		 */		
		private function _labBuyClicked(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			if (!touch)
			{
				return;
			}
			SSoundEffectUtil.playTipSound();
			// 退出传功模块
			SApplication.moduleManager.exitModule("CJTransferAbilityModule");
			// 进入商城模块
			SApplication.moduleManager.enterModule("CJMallModule");
			
		}
		

		
		
		
		
		
		
		
		/** 武将头像层 */
		public function get layerHero():CJTransferAbilityHeroLayer
		{
			return _layerHero;
		}

		public function set layerHero(value:CJTransferAbilityHeroLayer):void
		{
			_layerHero = value;
		}

		/** 右侧操作层 */
		public function get operatLayer():SLayer
		{
			return _operatLayer;
		}

		public function set operatLayer(value:SLayer):void
		{
			_operatLayer = value;
		}

		/** 使用传功丹说明*/
		public function get labUseMyax():Label
		{
			return _labUseMyax;
		}

		public function set labUseMyax(value:Label):void
		{
			_labUseMyax = value;
		}

		/** 拥有传功丹*/
		public function get labHaveMyax():Label
		{
			return _labHaveMyax;
		}

		public function set labHaveMyax(value:Label):void
		{
			_labHaveMyax = value;
		}

		/** 传功按钮*/
		public function get btnTransferAbility():Button
		{
			return _btnTransferAbility;
		}

		public function set btnTransferAbility(value:Button):void
		{
			_btnTransferAbility = value;
		}

		/** 关闭按钮*/
		public function get btnClose():Button
		{
			return _btnClose;
		}

		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		/** 显示武将数组 */
		public function get arrayHero():Array
		{
			return _arrayHero;
		}

		/**
		 * @private
		 */
		public function set arrayHero(value:Array):void
		{
			_arrayHero = value;
		}

		/** 复选框*/
		public function get checkbox():CJEnhanceLayerCheckbox
		{
			return _checkbox;
		}

		/**
		 * @private
		 */
		public function set checkbox(value:CJEnhanceLayerCheckbox):void
		{
			_checkbox = value;
		}


	}
}