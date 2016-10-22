package SJ.Game.enhanceequip
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstEnhance;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_enhance;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJHeartbeatEffectUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnhanceEquip;
	import SJ.Game.data.CJDataOfEnhanceEquipConfigSingle;
	import SJ.Game.data.CJDataOfEnhanceHero;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfEnhanceEquipProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.layer.CJMsgBoxSilverNotEnough;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	/**
	 * 装备强化layer
	 * @author sangxu
	 * 
	 */	
	public class CJEnhanceEquipLayer extends SLayer
	{
		public function CJEnhanceEquipLayer()
		{
			super();
		}
		
		/** 图标按钮组 */
		private var _btnVec:Vector.<Button>;
		/** 服务器装备强化数据 */
		private var _enhanceEquipData:CJDataOfEnhanceEquip;
		/** 装备强化配置数据 */
		private var _enhanceEquipConfig:CJDataOfEnhanceEquipProperty;
		/** 玩家等级 */
//		private var _playLv:int;
		/** 当前选中装备位类型 */
		private var _curPosType:int = -1;
		/** 武将头像层 */
		private var _layerHero:CJEnhanceHeroLayer;
		/** 当前选中武将id */
		private var _curHeroId:String = "";
		/** 当前选中武将强化数据 */
		private var _curHeroEnhanceData:CJDataOfEnhanceHero;
		/**用户武将信息**/
		private var _heroList:CJDataOfHeroList;
		/** 装备按钮字典 */
		private var _eqpBtnDic:Dictionary;
		/** 强化成功动画播放标识位 */
		private var _isCmplAnimPlay:Boolean = false;
		/** 是否初始化 */
		private var _isInit:Boolean = false;
		/** 使用元宝增加成功率默认值 */
		private var _checkBoxDefault:Boolean  = false;
		
		private var _dataRole:CJDataOfRole;
		
		/** 一键合成次数 */
		private const ENHANCE_ONEKEY_COUNT:int = 10;
		
//		private const EQUIP_INIT_X:int = 81;
//		private const EQUIP_INIT_Y:int = 46;
//		private const EQUIP_SPACE_X:int = 57;
//		private const EQUIP_SPACE_Y:int = 62;
		private const IMGSEL_SPACE_X:int = -1;
		private const IMGSEL_SPACE_Y:int = -1;
		
//		private var _LockKeyDrawOnePosition = "LockKeyDrawOnePosition";
//		private var _LockKeyDrawOneHero = "LockKeyDrawOneHero";
		
		/** 数据 - 全局配置 */
		private var _globalConfig:CJDataOfGlobalConfigProperty;
		private var _enhanceMaxLv:int = 0;
		
		/** 武器货币量倍数 */
		private var _weaponPriceWeight:int = 2;
		
		/** 打开武将id */
		private var _openHeroId:String = "";
		
		private static var _checkBoxCheck:Boolean = false;
		
		private var _filter:ColorMatrixFilter;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
			// 添加数据监听
			_addDataLiteners();
			// 请求服务器数据
			_remoteDataRequest();
			
			this._isInit = true;
		}
		
		public function setOpenHeroId(heroId:String):void
		{
			if (heroId == null)
			{
				return;
			}
			if (heroId == "")
			{
				return;
			}
			_openHeroId = heroId;
//			_curHeroId = heroId;
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			var optIdx:int = 0;
			var texture:Texture;
			// 操作层 - 底图
			var imgOptBgKuang:Scale9Image;
//			texture = SApplication.assets.getTexture("common_dinew");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew"), new Rectangle(1 ,1 , 1, 1)));
			imgOptBgKuang.x = 0;
			imgOptBgKuang.y = 0;
			imgOptBgKuang.width = this.width;
			imgOptBgKuang.height = this.height;
			this.addChildAt(imgOptBgKuang, optIdx++);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(44, 44, 1, 1)));
			imgOptBgKuang.x = 0;
			imgOptBgKuang.y = 0;
			imgOptBgKuang.width = this.width;
			imgOptBgKuang.height = this.height;
			this.addChildAt(imgOptBgKuang, optIdx++);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.width - 8 , this.height - 8);
			bgBall.x = 4;
			bgBall.y = 4;
			this.addChildAt(bgBall, optIdx++);
			
			// 边框
			var textureBiankuang:Texture = SApplication.assets.getTexture("common_waikuangnew");
			var bgScaleRangeBk:Rectangle = new Rectangle(15 , 15 , 1, 1);
			var bgTextureBk:Scale9Textures = new Scale9Textures(textureBiankuang, bgScaleRangeBk);
			var imgBiankuang:Scale9Image = new Scale9Image(bgTextureBk);
			imgBiankuang.width = this.width;
			imgBiankuang.height = this.height;
			this.addChildAt(imgBiankuang, optIdx++);
			
			//右侧背景底图
			var imgRightBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 40,40 ,3,3);
			imgRightBg.x = 193;
			imgRightBg.y = 10;
			imgRightBg.width = 216;
			imgRightBg.height = this.height - 20;
			this.addChildAt(imgRightBg, optIdx++);
			
			// 成功率背景
//			var scaleRangeTemp:Rectangle = new Rectangle(14, 16, 2, 2);
//			var scale9Textures:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("zhuangbei_wenzidi"), scaleRangeTemp);
//			var imgS9Temp:Scale9Image = new Scale9Image(scale9Textures);
//			imgS9Temp.x = 193;
//			imgS9Temp.y = 172;
//			imgS9Temp.width = 216;
//			imgS9Temp.height = 43;
//			this.addChildAt(imgS9Temp, optIdx++);
			
			this._layerHero = new CJEnhanceHeroLayer();
			this._layerHero.x = 9;
			this._layerHero.y = 9;
			this._layerHero.width = 65;
			this._layerHero.height = 259;
//			this._layerHero.selectHero(_openHeroId);
			this.addChild(this._layerHero);
			
			// 字体 - 静态文字
			var fontFormatTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xE5E3AB);
			// 字体 - 内容绿色
			var fontFormatCont:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x89EE4F);
			// 字体 - 内容属性红色
			var fontFormatContProp:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xCB6563);
			// 字体 - 按钮
			var fontFormatBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xEDCB99);
			// 字体 - 提示
			var fontFormatExplain:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x46B744);
			// 字体 - 消耗
			var ffCost:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFB84);
			
			_filter = new ColorMatrixFilter();
			_filter.adjustSaturation(-1);
			
			// 装备位按钮
			this.btnWeapon.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_WUQI));
			this.btnWeapon.name = String(ConstItem.SCONST_ITEM_POSITION_WEAPON);
			this.btnWeapon.filter = _filter;
			
			this.btnHead.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_TOUKUI));
			this.btnHead.name = String(ConstItem.SCONST_ITEM_POSITION_HEAD);
			this.btnHead.filter = _filter;
			
			this.btnCloak.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_PIFENG));
			this.btnCloak.name = String(ConstItem.SCONST_ITEM_POSITION_CLOAK);
			this.btnCloak.filter = _filter;
			
			this.btnArmor.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_KUIJIA));
			this.btnArmor.name = String(ConstItem.SCONST_ITEM_POSITION_ARMOR);
			this.btnArmor.filter = _filter;
			
			this.btnShoe.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_XIEZI));
			this.btnShoe.name = String(ConstItem.SCONST_ITEM_POSITION_SHOE);
			this.btnShoe.filter = _filter;
			
			this.btnBelt.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_YAODAI));
			this.btnBelt.name = String(ConstItem.SCONST_ITEM_POSITION_BELT);
			this.btnBelt.filter = _filter;
			
			this._eqpBtnDic = new Dictionary();
			this._eqpBtnDic[String(ConstItem.SCONST_ITEM_POSITION_WEAPON)] = this.btnWeapon;
			this._eqpBtnDic[String(ConstItem.SCONST_ITEM_POSITION_HEAD)] = this.btnHead;
			this._eqpBtnDic[String(ConstItem.SCONST_ITEM_POSITION_CLOAK)] = this.btnCloak;
			this._eqpBtnDic[String(ConstItem.SCONST_ITEM_POSITION_ARMOR)] = this.btnArmor;
			this._eqpBtnDic[String(ConstItem.SCONST_ITEM_POSITION_SHOE)] = this.btnShoe;
			this._eqpBtnDic[String(ConstItem.SCONST_ITEM_POSITION_BELT)] = this.btnBelt;
			
			// 装备位按钮组
			this._btnVec = new Vector.<Button>();
			this._btnVec.push(this.btnWeapon, 
				this.btnHead, 
				this.btnCloak, 
				this.btnArmor, 
				this.btnShoe, 
				this.btnBelt);
			this._addBtnVecListener();
			
			// 文字 - 对应部位
			this.labPosition.text = this._getLang("ENHANCE_EQUIP_LAB_POSITION");
			this.labPosition.textRendererProperties.textFormat = fontFormatTitle;
			// 文字 - 强化等级
			this.labEnhancelv.text = this._getLang("ENHANCE_EQUIP_LAB_EFFECT");
			this.labEnhancelv.textRendererProperties.textFormat = fontFormatTitle;
			// 文字 - 当前效果
			this.labCureffect.text = this._getLang("ENHANCE_EQUIP_LAB_CUREFFECT");
			this.labCureffect.textRendererProperties.textFormat = fontFormatTitle;
			// 文字 - 当前效果 基础属性
			this.labCurbase.text = this._getLang("ENHANCE_EQUIP_LAB_BASEPROP");
			this.labCurbase.textRendererProperties.textFormat = fontFormatTitle;
			// 文字 - 升级效果
			this.labUpeffect.text = this._getLang("ENHANCE_EQUIP_LAB_NEXTEFFECT");
			this.labUpeffect.textRendererProperties.textFormat = fontFormatTitle;
			// 文字 - 升级效果 基础属性
			this.labUpbase.text = this._getLang("ENHANCE_EQUIP_LAB_BASEPROP");
			this.labUpbase.textRendererProperties.textFormat = fontFormatTitle;
			// 文字 - 成功率
			this.labRate.text = this._getLang("ENHANCE_EQUIP_LAB_RATE");
			this.labRate.textRendererProperties.textFormat = ffCost;
			// 文字 - 银两消耗
			this.labCost.text = this._getLang("ENHANCE_EQUIP_LAB_COST");
			this.labCost.textRendererProperties.textFormat = ffCost;
			// 文字 - 银两消耗内容
			this.labContCost.textRendererProperties.textFormat = ffCost;
			// 文字 - 拥有
			this.labHas.text = this._getLang("ENHANCE_LAB_HAS");
			this.labHas.textRendererProperties.textFormat = ffCost;
			// 内容 - 拥有银两
			this.labContSilver.textRendererProperties.textFormat = ffCost;
			this.labContSilver.text = CJItemUtil.getMoneyFormat(_dataRole.silver);
			// 内容 - 拥有元宝
			this.labContGoldHas.textRendererProperties.textFormat = ffCost;
			this.labContGoldHas.text = CJItemUtil.getMoneyFormat(_dataRole.gold);
			
			// 字体 - 内容
			this.labContPosition.textRendererProperties.textFormat = fontFormatCont;
			this.labContEffectpos.textRendererProperties.textFormat = fontFormatCont;
			this.labContUpeffectpos.textRendererProperties.textFormat = fontFormatCont;
			this.labContEnhancelv.textRendererProperties.textFormat = fontFormatCont;
			// 字体 - 基础属性 红色
			this.labContCurbase.textRendererProperties.textFormat = fontFormatContProp;
			this.labContUpbase.textRendererProperties.textFormat = fontFormatContProp;
			// 字体 - 白色
			this.labContAdd.textRendererProperties.textFormat = fontFormatTitle;
			this.labContRate.textRendererProperties.textFormat = fontFormatTitle;
			
			this.labContAdd.addEventListener(TouchEvent.TOUCH, _onClickAddRate);
			
			// 按钮 - 强化
			this.btnEnhance.label = this._getLang("ENHANCE_EQUIP_BTN_ENHANCE");
			this.btnEnhance.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnEnhance.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnEnhance.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnEnhance.addEventListener(starling.events.Event.TRIGGERED, _onClickEnhance);
//			this.btnEnhance.isEnabled = false;
			
			this.btnEnhanceTen.label = this._getLang("ENHANCE_EQUIP_BTN_ENHANCETEN");
			this.btnEnhanceTen.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnEnhanceTen.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnEnhanceTen.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnEnhanceTen.addEventListener(starling.events.Event.TRIGGERED, _onClickEnhanceTen);
			
			// 星星
			this.layerStar = new CJEnhanceLayerStar();
			this.layerStar.initLayer();
			this.layerStar.x = 212;
			this.layerStar.y = 68;
			this.layerStar.width = 170;
			this.layerStar.height=17;
			this.addChild(this.layerStar);
			
			this.cbAddRate = new CJEnhanceLayerCheckbox();
			this.cbAddRate.initLayer();
			this.cbAddRate.x = 243;
			this.cbAddRate.y = 143;
//			this.cbAddRate.checked = this._checkBoxDefault;
			this.cbAddRate.checked = _checkBoxCheck;
			this.addChild(this.cbAddRate);
			this.cbAddRate.addEventListener(starling.events.TouchEvent.TOUCH, _onClickAddRate);
			
			// 分割线
//			var textureTemp:Texture = SApplication.assets.getTexture("common_fengexian");//zhuangbeiqianghua_fengexian
//			var scale3texture:Scale3Textures = new Scale3Textures(textureTemp, textureTemp.width/2-1,1);
			var imgTemp:SImage = new SImage(SApplication.assets.getTexture("common_fengexian"));
			imgTemp.x = 206;
			imgTemp.y = 135;
			imgTemp.height = 2;
			imgTemp.width = 200;
			this.addChild(imgTemp);
			
//			imgTemp = new SImage(SApplication.assets.getTexture("common_fengexian"));
//			imgTemp.x = 236;
//			imgTemp.y = 171;
//			imgTemp.height = 2;
//			imgTemp.width = 170;
//			this.addChild(imgTemp);
			
//			imgTemp = new SImage(SApplication.assets.getTexture("common_fengexian"));
//			imgTemp.x = 236;
//			imgTemp.y = 212;
//			imgTemp.height = 2;
//			imgTemp.width = 170;
//			this.addChild(imgTemp);
			
			// 选中框
			this._imgSel = new ImageLoader();
			this._imgSel.source = SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_KUANG);
			this._imgSel.visible = true;
			this._imgSel.x = this.btnWeapon.x + IMGSEL_SPACE_X;
			this._imgSel.y = this.btnWeapon.y + IMGSEL_SPACE_Y;
			this._imgSel.width = this.btnWeapon.width;
			this._imgSel.height = this.btnWeapon.height;
			this.addChild(this._imgSel);
			
			// 提示
//			this.labExplain.text = this._getLang("ENHANCE_EXPLAIN");
//			this.labExplain.textRendererProperties.textFormat = fontFormatExplain;
			
			if (_openHeroId != "")
			{
				this.onSelectHero(_openHeroId);
				this._layerHero.selectHero(_openHeroId);
			}
			_openHeroId = "";
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 玩家等级
//			this._playLv = parseInt(CJDataManager.o.DataOfHeroList.getMainHero().level);
			// 服务器数据
			this._enhanceEquipData = CJDataManager.o.getData("CJDataOfEnhanceEquip");
			// 配置数据
			this._enhanceEquipConfig = CJDataOfEnhanceEquipProperty.o;
			/// 武将字典< heroid, heroInfo >
			this._heroList = CJDataManager.o.DataOfHeroList;
			
			this._dataRole = CJDataManager.o.getData("CJDataOfRole");
			
			// 全局配置
			this._globalConfig = CJDataOfGlobalConfigProperty.o;
			// 强化最大等级
			_enhanceMaxLv = int(_globalConfig.getData("ENHANCE_MAX_LV"));
		}
		
		/**
		 * 添加相关监听器
		 */
		private function _addDataLiteners():void
		{
			// 监听数据获取成功
			this._enhanceEquipData.addEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveEnhanceData);
			// 监听RPC结果
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
		}
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_ENHANCE_ENHANCEEQUIP)
			{
				if (msg.retcode == 0)
				{
					// 获取装备强化信息消息
					var retData:Object = msg.retparams;
					if (true == retData.result)
					{
						// 强化成功
						// 飘字
//						new CJTaskFlowImage("texiaozi_qianghuachenggong").addToLayer();
						CJHeartbeatEffectUtil("texiaozi_qianghuachenggong");
						if (retData.heroid == this._curHeroId)
						{
							// 强化成功，且此时为所强化武将
							if (true == this._isCmplAnimPlay)
							{
								if (this._completeAnimation != null)
								{
//									this._completeAnimation.removeFromParent(true);
//									this._completeAnimation.removeFromJuggler();
//									this._completeAnimation = null;
									this._animCompleteOver();
								}
							}
							
							// 装备位动画特效
							var moveeffectObject:Object = AssetManagerUtil.o.getObject("anim_qianghuachenggong");
							if(moveeffectObject)
							{
								this._isCmplAnimPlay = true;
								
								var btn:Button = this._eqpBtnDic[String(retData.position)]
								this._completeAnimation = SAnimate.SAnimateFromAnimJsonObject(moveeffectObject);
								this._completeAnimation.addEventListener(Event.COMPLETE, _onQianghuaTexiaoComplete);
								this._completeAnimation.x = btn.x + (btn.width / 2) + 2;
								this._completeAnimation.y = btn.y + (btn.height / 2) + 14;
//								this._completeAnimation.width = btn.width;
//								this._completeAnimation.height = btn.height;
								this.addChild(_completeAnimation);
								this._completeAnimation.gotoAndPlay();
								Starling.juggler.add(_completeAnimation);
							}
							
							if (parseInt(retData.position) == this._curPosType)
							{
								// 强化成功，且此时装备位为所强化装备位
								// 界面内容刷新
								var posType:int = retData.position;
								var enLvTemp:uint = 0;
								var curHeroLv:int = this._getCurHeroLevel();
								switch (posType)
								{
									case ConstItem.SCONST_ITEM_POSITION_WEAPON:
										enLvTemp = this._curHeroEnhanceData.weapon;
										if (enLvTemp <= _enhanceMaxLv && enLvTemp < curHeroLv)
										{
											enLvTemp += 1;
											this._curHeroEnhanceData.weapon = enLvTemp;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_HEAD:
										enLvTemp = this._curHeroEnhanceData.head;
										if (enLvTemp <= _enhanceMaxLv && enLvTemp < curHeroLv)
										{
											enLvTemp += 1;
											this._curHeroEnhanceData.head = enLvTemp;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_CLOAK:
										enLvTemp = this._curHeroEnhanceData.cloak;
										if (enLvTemp <= _enhanceMaxLv && enLvTemp < curHeroLv)
										{
											enLvTemp += 1;
											this._curHeroEnhanceData.cloak = enLvTemp;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_ARMOR:
										enLvTemp = this._curHeroEnhanceData.armour;
										if (enLvTemp <= _enhanceMaxLv && enLvTemp < curHeroLv)
										{
											enLvTemp += 1;
											this._curHeroEnhanceData.armour = enLvTemp;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_SHOE:
										enLvTemp = this. _curHeroEnhanceData.shoe;
										if (enLvTemp <= _enhanceMaxLv && enLvTemp < curHeroLv)
										{
											enLvTemp += 1;
											this._curHeroEnhanceData.shoe = enLvTemp;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_BELT:
										enLvTemp = this._curHeroEnhanceData.belt;
										if (enLvTemp <= _enhanceMaxLv && enLvTemp < curHeroLv)
										{
											enLvTemp += 1;
											this._curHeroEnhanceData.belt = enLvTemp;
										}
										break;
								}
								this._refresh(enLvTemp);
							}
						}
						// 刷新武将总战斗力
						SocketCommand_hero.get_heros();
					}
					else
					{
						// 强化失败
						// 飘字
//						new CJTaskFlowImage("texiaozi_qianghuashibai").addToLayer();
						CJHeartbeatEffectUtil("texiaozi_qianghuashibai");
					}
					// 活跃度
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_EQUIPENHANCE});
					
					// 请求服务器更新货币信息
					SocketCommand_role.get_role_info();
				}
				// 解除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_ENHANCE_ENHANCEEQUIP);
			}
			else if (msg.getCommand() == ConstNetCommand.CS_ROLE_GET_ROLE_INFO)
			{
				if (msg.retcode == 0)
				{
					// 角色信息更新
					this.labContSilver.text = CJItemUtil.getMoneyFormat(_dataRole.silver);
					this.labContGoldHas.text = CJItemUtil.getMoneyFormat(_dataRole.gold);
				}
			}
			else if (msg.getCommand() == ConstNetCommand.CS_ENHANCE_ENHANCEEQUIPTEN)
			{
				if (msg.retcode == 0)
				{
					// 获取装备强化信息消息
					var retDataTen:Object = msg.retparams;
					if (true == retDataTen.result)
					{
						// 强化成功
						if (retDataTen.heroid == this._curHeroId)
						{
							var retinfo:String = retDataTen.retinfo;
							var arrayEnhanceRet:Array = retinfo.split(",");
							
							var addLv:int = 0;
							for each (var enhanceRet:String in arrayEnhanceRet)
							{
								addLv += int(enhanceRet);
							}
							
							// 飘字
							_showEnhanceTenPiaozi(arrayEnhanceRet);
							
							// 强化成功，且此时为所强化武将
							if (true == this._isCmplAnimPlay)
							{
								if (this._completeAnimation != null)
								{
									this._animCompleteOver();
								}
							}
							
							// 装备位动画特效
							var moveeffectObjectTen:Object = AssetManagerUtil.o.getObject("anim_qianghuachenggong");
							if(moveeffectObjectTen)
							{
								this._isCmplAnimPlay = true;
								
								var btnTen:Button = this._eqpBtnDic[String(retDataTen.position)]
								this._completeAnimation = SAnimate.SAnimateFromAnimJsonObject(moveeffectObjectTen);
								this._completeAnimation.addEventListener(Event.COMPLETE, _onQianghuaTexiaoComplete);
								this._completeAnimation.x = btnTen.x + (btnTen.width / 2) + 2;
								this._completeAnimation.y = btnTen.y + (btnTen.height / 2) + 14;
//								this._completeAnimation.width = btn.width;
//								this._completeAnimation.height = btn.height;
								this.addChild(_completeAnimation);
								this._completeAnimation.gotoAndPlay();
								Starling.juggler.add(_completeAnimation);
							}
							
							if (parseInt(retDataTen.position) == this._curPosType)
							{
								// 强化成功，且此时装备位为所强化装备位
								// 界面内容刷新
								var posTypeTen:int = int(retDataTen.position);
								var enLvTempTen:uint = 0;
								var curHeroLvTen:int = this._getCurHeroLevel();
								switch (posTypeTen)
								{
									case ConstItem.SCONST_ITEM_POSITION_WEAPON:
										enLvTempTen = this._curHeroEnhanceData.weapon;
										if (enLvTempTen <= _enhanceMaxLv && enLvTempTen < curHeroLvTen)
										{
											enLvTempTen += addLv;
											this._curHeroEnhanceData.weapon = enLvTempTen;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_HEAD:
										enLvTempTen = this._curHeroEnhanceData.head;
										if (enLvTempTen <= _enhanceMaxLv && enLvTempTen < curHeroLvTen)
										{
											enLvTempTen += addLv;
											this._curHeroEnhanceData.head = enLvTempTen;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_CLOAK:
										enLvTempTen = this._curHeroEnhanceData.cloak;
										if (enLvTempTen <= _enhanceMaxLv && enLvTempTen < curHeroLvTen)
										{
											enLvTempTen += addLv;
											this._curHeroEnhanceData.cloak = enLvTempTen;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_ARMOR:
										enLvTempTen = this._curHeroEnhanceData.armour;
										if (enLvTempTen <= _enhanceMaxLv && enLvTempTen < curHeroLvTen)
										{
											enLvTempTen += addLv;
											this._curHeroEnhanceData.armour = enLvTempTen;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_SHOE:
										enLvTempTen = this. _curHeroEnhanceData.shoe;
										if (enLvTempTen <= _enhanceMaxLv && enLvTempTen < curHeroLvTen)
										{
											enLvTempTen += addLv;
											this._curHeroEnhanceData.shoe = enLvTempTen;
										}
										break;
									case ConstItem.SCONST_ITEM_POSITION_BELT:
										enLvTempTen = this._curHeroEnhanceData.belt;
										if (enLvTempTen <= _enhanceMaxLv && enLvTempTen < curHeroLvTen)
										{
											enLvTempTen += addLv;
											this._curHeroEnhanceData.belt = enLvTempTen;
										}
										break;
								}
								this._refresh(enLvTempTen);
							}
						}
						else
						{
							_btnEnhanceTen.isEnabled = true;
						}
					}
					else
					{
						_btnEnhanceTen.isEnabled = true;
					}
					// 活跃度
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_EQUIPENHANCE});
					
					// 请求服务器更新货币信息
					SocketCommand_role.get_role_info();
					
					// 刷新武将总战斗力
					SocketCommand_hero.get_heros();
				}
				else
				{
					_btnEnhanceTen.isEnabled = true;
					if (msg.retcode == 1)
					{
						// 超过最大强化等级设定
						CJMessageBox(this._getLang("ENHANCE_LV_NOT_ENOUGH"));
					}
					else if (msg.retcode == 2)
					{
						// 已达到武将等级, 不可强化
						CJMessageBox(this._getLang("ENHANCE_LV_NOT_ENOUGH"));
					}
					else if (msg.retcode == 3)
					{
						// 强化基础货币(银两)不足
						CJMsgBoxSilverNotEnough(CJLang("NOT_ENOUGH_YINLIANG"), 
							"", 
							function():void{
								SApplication.moduleManager.exitModule("CJEnhanceModule");
							});
					}
					else if (msg.retcode == 4)
					{
						CJMessageBox(CJLang("NOT_ENOUGH_GOLD"));
					}
				}
			}
		}
		
		private function _showEnhanceTenPiaozi(arrayEnhanceRet:Array):void
		{
			var idx:int = 0;
			
			var seccessLabel:Label = new Label();
			var textTween:STween;
			
			var arrayTween:Array = new Array();
			
			var completeCount:int = 0;
			var failCount:int = 0;
			var contant:String = "";
			
			for (var i:int = 0; i < arrayEnhanceRet.length; i++)
			{
				if (int(arrayEnhanceRet[i]) > 0)
				{
					completeCount++;
				}
				else
				{
					failCount++;
				}
			}
			
			if (completeCount > 0)
			{
				contant += CJTaskHtmlUtil.colorText(CJLang("ENHANCE_RESULT_COMPLETE") + CJLang("ENHANCE_TIME", {"count":completeCount}), "#FFFFFF");
			}
			if (failCount > 0)
			{
				if (contant.length > 0)
				{
					contant += "  ";
				}
				var failCountCont:String = "";
				failCountCont = _getHtmlColorText(String(failCount), "#FF0000");
				contant += _getHtmlColorText(CJLang("ENHANCE_RESULT_FAIL") + CJLang("ENHANCE_TIME", {"count":failCountCont}), "#FFFFFF");
					
//					CJLang("ENHANCE_RESULT_FAIL") + CJLang("ENHANCE_TIME", {"count":failCount});
			}
			
			seccessLabel.text = contant;
			seccessLabel.textRendererFactory = _getPackageInfoRender;
			seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			seccessLabel.x = 0;
			seccessLabel.y = (SApplicationConfig.o.stageHeight - seccessLabel.height) / 2 - this.y;
			seccessLabel.width = SApplicationConfig.o.stageWidth;
//			seccessLabel.visible = false;
			textTween = new STween(seccessLabel, 1.6, Transitions.LINEAR);
			textTween.moveTo(seccessLabel.x, seccessLabel.y- 50);
			
			textTween.onStart = function():void
			{
//				seccessLabel.visible = true;
			}
			
			textTween.onComplete = function():void
			{
				seccessLabel.removeFromParent(true);
				Starling.juggler.remove(textTween);
				_btnEnhanceTen.isEnabled = true;
			}
			arrayTween.push(textTween);
			
			this.addChild(seccessLabel);
			Starling.juggler.add(textTween);
		}
		
		/**
		 * 为字符串增加HTML颜色标签
		 * @param text	文字
		 * @param color	颜色#FFFFFF
		 * @return 
		 * 
		 */		
		private function _getHtmlColorText(text:String, color:String):String
		{
//			text = wipeHtmlTag(text);
			return "<font color='" + color + "'>" + text + "</font>";
		}
		
		private function _getPackageInfoRender():ITextRenderer
		{
			var htmltextRender:TextFieldTextRendererEx;
			htmltextRender = new TextFieldTextRendererEx()
			htmltextRender.isHTML = true;
			return htmltextRender;
		}
		
		/**
		 * 飘字
		 * @param str 飘字内容
		 * 
		 */		
//		private function _showEnhanceTenPiaozi(arrayEnhanceRet:Array):void
//		{
//			var idx:int = 0;
//			
//			var seccessLabel:Label;
//			var textTween:STween;
//			
//			var arrayLab:Array = new Array();
//			var arrayTween:Array = new Array();
//			
//			var startIdx:int = 0;
//			var completeIdx:int = 0;
//			
//			for (var i:int = 0; i < arrayEnhanceRet.length; i++)
//			{
//				var result:int = int(arrayEnhanceRet[i]);
//				
//				seccessLabel = new Label();
//				if (int(result) > 0)
//				{
//					seccessLabel.text = CJLang("ENHANCE_RESULT_COMPLETE");
//				}
//				else
//				{
//					seccessLabel.text = CJLang("ENHANCE_RESULT_FAIL");
//				}
//				seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
//				seccessLabel.x = 0;
//				seccessLabel.y = (SApplicationConfig.o.stageHeight - seccessLabel.height) / 2 - this.y;
//				seccessLabel.width = SApplicationConfig.o.stageWidth;
//				seccessLabel.visible = false;
//				textTween = new STween(seccessLabel, 1.6, Transitions.LINEAR);
//				textTween.moveTo(seccessLabel.x, seccessLabel.y- 50);
//				
//				textTween.onStart = function():void
//				{
//					var lab:Label = arrayLab[startIdx];
//					lab.visible = true;
//					
//					startIdx++;
//				}
//				
//				textTween.onComplete = function():void
//				{
//					var lab:Label = arrayLab[completeIdx];
//					lab.removeFromParent(true);
//					var tween:STween = arrayTween[completeIdx];
//					Starling.juggler.remove(tween);
//					if (completeIdx >= (ENHANCE_ONEKEY_COUNT - 1))
//					{
//						_btnEnhanceTen.isEnabled = true;
//					}
//					completeIdx++;
//				}
//				textTween.delay = 0.54 * i;
//				
//				arrayLab.push(seccessLabel);
//				arrayTween.push(textTween);
//				
//				this.addChild(seccessLabel);
//				Starling.juggler.add(textTween);
//			}
//		}
		
		/**
		 * 强化成功动画播放完毕
		 * @param event
		 * 
		 */		
		private function _onQianghuaTexiaoComplete(event:Event):void
		{
			this._animCompleteOver();
		}
		
		/**
		 * 强化成功动画结束播放
		 * 
		 */		
		private function _animCompleteOver():void
		{
			this._completeAnimation.removeFromParent(true);
			this._completeAnimation.removeFromJuggler();
			this._completeAnimation.removeEventListener(Event.COMPLETE, _onQianghuaTexiaoComplete);
			this._completeAnimation = null;
			
			this._isCmplAnimPlay = false;
		}
		
		/**
		 * checkbox点击事件响应
		 * @param event
		 * 
		 */		
		private function _onClickAddRate(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.cbAddRate, TouchPhase.BEGAN);
			if (!touch)
			{
				touch = event.getTouch(this.labContAdd, TouchPhase.BEGAN);
				if (!touch)
				{
					return;
				}
			}
			if (this._curPosType < 0)
			{
				// 未选中图标
				return;
			}
			if (this._getCurPosLv() >= _enhanceMaxLv)
			{
				return;
			}
			if (this._getNextLvConfigData() == null)
			{
				return;
			}
			this.cbAddRate.toggle();
			_checkBoxCheck = this.cbAddRate.isChecked;
//			var btnEnhanceEnabled:Boolean = this._isEnhanceEnable();
//			this.btnEnhance.isEnabled = btnEnhanceEnabled;
		}
		
		/**
		 * 接收到装备强化数据
		 * 
		 */		
		private function _onReceiveEnhanceData():void
		{
			if (this._curHeroId == "")
			{
				
//				this._curHeroId = this._heroList.getMainHero().heroid;
//				// 设置当前武将数据
//				this._setCurHeroEnhanceData();
//				this._initShow();
				this.onSelectHero(this._heroList.getMainHero().heroid);
			}
			else
			{
				
			}
		}
		
		/**
		 * 请求服务器数据
		 */
		private function _remoteDataRequest():void
		{
			if (this._enhanceEquipData.dataIsEmpty)
			{
				SocketCommand_enhance.getEquipEnhanceInfo();
			}
			else
			{
				this._onReceiveEnhanceData();
			}
		}
		
		/**
		 * 点击强化按钮
		 * @param event
		 * 
		 */		
		private function _onClickEnhance(event:Event):void
		{
//			if (true == this.btnEnhance.isEnabled)
//			{
//				if (this._curPosType != -1)
//				{
//					SocketCommand_enhance.enhanceEquip(this._curPosType, this.cbAddRate.isChecked);
//				}
//			}
			
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			if (true == this._isEnhanceEnable())
			{
				SocketCommand_enhance.enhanceEquip(this._curHeroId, this._curPosType, this.cbAddRate.isChecked);
			}
		}
		/**
		 * 点击强化按钮
		 * @param event
		 * 
		 */		
		private function _onClickEnhanceTen(event:Event):void
		{
			
			if (true == this._isEnhanceEnable(1))
			{
				_btnEnhanceTen.isEnabled = false;
				SocketCommand_enhance.enhanceEquipTen(this._curHeroId, this._curPosType, this.cbAddRate.isChecked);
			}
		}
		
		/**
		 * 点击图标事件处理
		 * @param event
		 * 
		 */		
		private function _onClickEquip(event:Event):void
		{
			var posType:int = 0;
			switch(event.target)
			{
				case this.btnWeapon:
					// 武器
					posType = ConstItem.SCONST_ITEM_POSITION_WEAPON;
					break;
				case this.btnHead:
					// 头盔
					posType = ConstItem.SCONST_ITEM_POSITION_HEAD;
					break;
				case this.btnCloak:
					// 披风
					posType = ConstItem.SCONST_ITEM_POSITION_CLOAK;
					break;
				case this.btnArmor:
					// 铠甲
					posType = ConstItem.SCONST_ITEM_POSITION_ARMOR;
					break;
				case this.btnShoe:
					// 鞋子
					posType = ConstItem.SCONST_ITEM_POSITION_SHOE;
					break;
				case this.btnBelt:
					// 腰带
					posType = ConstItem.SCONST_ITEM_POSITION_BELT;
					break;
			}
			
			// 添加网络锁
//			SocketLockManager.KeyLock(_LockKeyDrawOnePosition);
			
			this._onSelEquip(posType);
			
			// 解除网络锁
//			SocketLockManager.KeyUnLock(_LockKeyDrawOnePosition);
		}
		
		/**
		 * 设置当前选中装备位后，调用此方法刷新界面显示
		 * @return 
		 * 
		 */		
		private function _onSelEquip(curPosType:int):void
		{
			this._curPosType = curPosType;
			for each (var btnTemp:Button in this._btnVec)
			{
				if (btnTemp.name == String(curPosType))
				{
					btnTemp.isSelected = true;
					this._imgSel.x = btnTemp.x + IMGSEL_SPACE_X;
					this._imgSel.y = btnTemp.y + IMGSEL_SPACE_Y;
					btnTemp.filter = null;
				}
				else
				{
					btnTemp.isSelected = false;
					btnTemp.filter = _filter;
				}
			}
			
			var lang:String = "";
			var curLv:int = 0;
			switch(this._curPosType)
			{
				case ConstItem.SCONST_ITEM_POSITION_WEAPON:
					// 武器
					lang = this._getLang("EQUIP_POSITION_WUQI");
					curLv = this._curHeroEnhanceData.weapon;
					break;
				case ConstItem.SCONST_ITEM_POSITION_HEAD:
					// 头盔
					lang = this._getLang("EQUIP_POSITION_TOUKUI");
					curLv = this._curHeroEnhanceData.head;
					break;
				case ConstItem.SCONST_ITEM_POSITION_CLOAK:
					// 披风
					lang = this._getLang("EQUIP_POSITION_PIFENG");
					curLv = this._curHeroEnhanceData.cloak;
					break;
				case ConstItem.SCONST_ITEM_POSITION_ARMOR:
					// 铠甲
					lang = this._getLang("EQUIP_POSITION_KAIJIA");
					curLv = this._curHeroEnhanceData.armour;
					break;
				case ConstItem.SCONST_ITEM_POSITION_SHOE:
					// 鞋子
					lang = this._getLang("EQUIP_POSITION_XIEZI");
					curLv = this._curHeroEnhanceData.shoe;
					break;
				case ConstItem.SCONST_ITEM_POSITION_BELT:
					// 腰带
					lang = this._getLang("EQUIP_POSITION_YAODAI");
					curLv = this._curHeroEnhanceData.belt;
					break;
			}
			this.labContPosition.text = lang;
			this.labContEffectpos.text = lang;
			this.labContUpeffectpos.text = lang;
			
//			this.cbAddRate.checked = this._checkBoxDefault;
			this.cbAddRate.checked = _checkBoxCheck;
			
			this._refresh(curLv);
		}
		
		/**
		 * 默认选中武器
		 * 
		 */		
		private function _initShow():void
		{
			var lang:String = "";
			var curLv:int = 0;
			lang = this._getLang("EQUIP_POSITION_WUQI");
			curLv = this._curHeroEnhanceData.weapon;
			this._curPosType = ConstItem.SCONST_ITEM_POSITION_WEAPON;
			this.labContPosition.text = lang;
			this.labContEffectpos.text = lang;
			this.labContUpeffectpos.text = lang;
			this.btnWeapon.isSelected = true;
			this._imgSel.x = this.btnWeapon.x + IMGSEL_SPACE_X;
			this._imgSel.y = this.btnWeapon.y + IMGSEL_SPACE_Y;
			this._imgSel.width = 64;
			this._imgSel.height = 64;
			this._refresh(curLv);
		}
		
		/**
		 * 刷新显示内容
		 * @param curLv
		 * 
		 */		
		private function _refresh(curLv:int):void
		{
			// 等级
			this.labContEnhancelv.text = curLv + "/" + this._getCurHeroLevel();
			// 当前效果
			if (curLv <= 0)
			{
				this.labContCurbase.text = "";
			}
			else
			{
				var curLvCfg:CJDataOfEnhanceEquipConfigSingle = this._enhanceEquipConfig.getConfigDataByLevel(curLv);
				this.labContCurbase.text = "+" + (curLvCfg.addPropRate / ConstEnhance.SCONST_RATE_BASE) + "%";
			}
			
			// 强化星级显示
			var starLv:int = curLv / ConstEnhance.SCONST_ENHANCE_STARLV_PRECOUNT;
			this.layerStar.setLevelAndRedraw(starLv);
			
			// 升级效果
			if (curLv < _enhanceMaxLv)
			{
				var nextCfg:CJDataOfEnhanceEquipConfigSingle = this._enhanceEquipConfig.getConfigDataByLevel(curLv + 1);
				if (nextCfg != null)
				{
					var weight:int = _getCostWeight();
					
					// 升级效果基础属性
					this.labContUpbase.text = "+" + (nextCfg.addPropRate / ConstEnhance.SCONST_RATE_BASE) + "%";
					
					// 加成文字
					var addLang:String = this._getLang("ENHANCE_EQUIP_ADDRATE");
					
					// VIP 强化成功率
					if (_getVipEnhanceSucc())
					{
						addLang = addLang.replace("{money}", "0");
					}
					else
					{
						addLang = addLang.replace("{money}", (nextCfg.addPrice));
					}
					addLang = addLang.replace("{rate}", "100");
					this.labContAdd.text = addLang;
					
					// VIP	// 成功率
					var vipLv:int = CJDataManager.o.DataOfRole.vipLevel;
					var vipConf:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vipLv));
					if(int(vipConf.enhance_succeed))
					{
						this.labContRate.text = (ConstEnhance.SCONST_RATE_BASE) + "%";
					}
					else
					{
						this.labContRate.text = (nextCfg.baseRate/ ConstEnhance.SCONST_RATE_BASE) + "%";
					}
					
					// 银两消耗
					this.labContCost.text = String(nextCfg.costPrice * weight);
					
					// 强化按钮
//					var btnEnhanceEnabled:Boolean = this._isEnhanceEnable();
//					this.btnEnhance.isEnabled = btnEnhanceEnabled;
				}
				else
				{
					this.labContRate.text = "";
					this.labContCost.text = "";
					this.labContUpbase.text = "";
					this.labContAdd.text = "";
//					this.btnEnhance.isEnabled = false;
				}
			}
			else
			{
				this.labContRate.text = "";
				this.labContCost.text = "";
				this.labContUpbase.text = "";
				this.labContAdd.text = "";
//				this.btnEnhance.isEnabled = false;
			}
		}
		
		/**
		 * 获取当前vip等级对应的强化花费数值
		 * @return 
		 * 
		 */		
		private function _getVipEnhanceSucc():int
		{
			// VIP判定是否可批量摇钱
			var vipLv:int = CJDataManager.o.DataOfRole.vipLevel;
			var vipCfg:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vipLv));
			if (vipCfg)
			{
				return int(vipCfg.enhance_succeed);
			}
			return 0;
		}
		
		/**
		 * 获取装备位对应权重
		 * @return 
		 * 
		 */		
		private function _getCostWeight():int
		{
			var weight:int = 1;
			if ((_curPosType == ConstItem.SCONST_ITEM_POSITION_WEAPON))
			{
				weight = _weaponPriceWeight;
			}
			return weight;
		}
		
		/**
		 * 按钮组加监听事件
		 * 
		 */		
		private function _addBtnVecListener():void
		{
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickEquip);
			}
		}
		
		/**
		 * 获取当前选中装备位强化等级
		 * @return 
		 * 
		 */		
		private function _getCurPosLv():int
		{
			var curLv:int = -1;
			// 点击强化按钮
			switch(this._curPosType)
			{
				case ConstItem.SCONST_ITEM_POSITION_WEAPON:
					curLv = this._curHeroEnhanceData.weapon;
					break;
				case ConstItem.SCONST_ITEM_POSITION_HEAD:
					curLv = this._curHeroEnhanceData.head;
					break;
				case ConstItem.SCONST_ITEM_POSITION_CLOAK:
					curLv = this._curHeroEnhanceData.cloak;
					break;
				case ConstItem.SCONST_ITEM_POSITION_ARMOR:
					curLv = this._curHeroEnhanceData.armour;
					break;
				case ConstItem.SCONST_ITEM_POSITION_SHOE:
					curLv = this._curHeroEnhanceData.shoe;
					break;
				case ConstItem.SCONST_ITEM_POSITION_BELT:
					curLv = this._curHeroEnhanceData.belt;
					break;
			}
			return curLv;
		}
		
		/**
		 * 获取当前强化等级配置数据
		 * @return 
		 * 
		 */		
		private function _getCurLvConfigData():CJDataOfEnhanceEquipConfigSingle 
		{
			var curLv:int = _getCurPosLv();
			return this._enhanceEquipConfig.getConfigDataByLevel(curLv);
		}
		
		/**
		 * 获取下一强化等级配置数据, 若当前达到最大强化等级返回null
		 * @return 
		 * 
		 */		
		private function _getNextLvConfigData():CJDataOfEnhanceEquipConfigSingle
		{
			var curLv:int = _getCurPosLv();
			if (curLv < _enhanceMaxLv)
			{
				return this._enhanceEquipConfig.getConfigDataByLevel(curLv + 1);
			}
			return null;
		}
		
		/**
		 * 获取强化配置数据数组，从当前等级强化次数
		 * @param enhanceLvCount 强化次数
		 * @return Array[CJDataOfEnhanceEquipConfigSingle]
		 * 
		 */		
		private function _getEnhanceLvConfigData(enhanceLvCount:int):Array
		{
			var arrayCfg:Array = [];
			var curLv:int = _getCurPosLv();
			var endLv:int = curLv + enhanceLvCount;
			var curHeorLevel:int = this._getCurHeroLevel();
			if (endLv > curHeorLevel)
			{
				endLv = curHeorLevel;
			}
			var cfgData:CJDataOfEnhanceEquipConfigSingle;
			for (var i:int = curLv + 1; i <= endLv; i++)
			{
				cfgData = this._enhanceEquipConfig.getConfigDataByLevel(i);
				arrayCfg.push(cfgData);
			}
			return arrayCfg;
		}
		
		/**
		 * 强化按钮是否可点击
		 * @return 可强化返回true, 不可强化返回false
		 * 
		 */		
		private function _isEnhanceEnable(enhanceCount:int = 1):Boolean
		{
			var curLv:int = _getCurPosLv();
			var afterLv:int = curLv + enhanceCount;
			// 不能超过强化最大等级
			if(curLv < 0 || afterLv > _enhanceMaxLv)
			{
				CJMessageBox(this._getLang("ENHANCE_LV_NOT_ENOUGH"));
				return false;
			}
			
			// 强化等级不能大于玩家等级
			var curHeorLevel:int = this._getCurHeroLevel();
			if (afterLv > curHeorLevel)
			{
				CJMessageBox(this._getLang("ENHANCE_LV_NOT_ENOUGH"));
				return false;
			}
			
			// 是否有足够货币
//			var nextCfg:CJDataOfEnhanceEquipConfigSingle = this._getNextLvConfigData();
			var needSilverSum:int = 0;
			var needGoldSum:int = 0;
			var arrayCfg:Array = this._getEnhanceLvConfigData(enhanceCount);
			
			var weight:int = _getCostWeight();
			for each(var cfg:CJDataOfEnhanceEquipConfigSingle in arrayCfg)
			{
				// 强化花费货币货币量
				needSilverSum += cfg.costPrice * weight;
				// 强化概率加成花费货币量
				needGoldSum += cfg.addPrice;
			}
			
			var silver:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).silver;
			if (silver < needSilverSum)
			{
				var contantSliver:String = this._getAlertMoneyContant(CJLang("CURRENCY_NAME_SILVER"), 
																	  String(needSilverSum), 
																	  CJLang("BAG_ADDMONEY_SILVER"));
//				CJMessageBox(contantSliver);
				CJMsgBoxSilverNotEnough(contantSliver, 
										"", 
										function():void{
											SApplication.moduleManager.exitModule("CJEnhanceModule");
										});
				return false;
			}
			
			// 使用概率加成
			if (true == this.cbAddRate.isChecked)
			{
				// 是否有足够金
				var gold:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).gold;
				if (gold < needGoldSum)
				{
					var contantGold:String = this._getAlertMoneyContant(CJLang("CURRENCY_NAME_GOLD"), 
																		String(needGoldSum), 
																		CJLang("BAG_ADDMONEY_GOLD"));
					CJMessageBox(contantGold);
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 
		 * @param currency	替换的货币名称
		 * @param count		替换的货币数量
		 * @param type		替换的获取货币方式
		 * 
		 */		
		private function _getAlertMoneyContant(currency:String, count:String, type:String):String
		{
			var contant:String = CJLang("BAG_MONEY_NOT_ENOUGH");
			contant = contant.split("{currency}").join(currency);
			contant = contant.replace("{count}", count);
			contant = contant.replace("{type}", type);
			return contant;
		}
		
		/**
		 * 获取玩家等级
		 * @return 
		 * 
		 */		
//		private function _getPlayerLevel():int
//		{
//			return parseInt(CJDataManager.o.DataOfHeroList.getMainHero().level);
//		}
		
		/**
		 * 获取当前武将等级
		 * @return 
		 * 
		 */		
		private function _getCurHeroLevel():int
		{
			return this._getHeroLevel(this._curHeroId);
		}
		
		/**
		 * 获取武将等级
		 * @param heroId
		 * @return 
		 * 
		 */		
		private function _getHeroLevel(heroId:String):int
		{
			var heroData:CJDataOfHero = this._heroList.getHero(heroId);
			return parseInt(heroData.level);
		}
		
		/**
		 * 选中武将，由武将TurnPage点击武将头像时调用
		 * @param heroId	武将id
		 * 
		 */		
		public function onSelectHero(heroId:String):void
		{
			if (this._curHeroId == heroId)
			{
				return;
			}
			
			this._curHeroId = heroId;
			
			this._setCurHeroEnhanceData();
			
			this._onSelEquip(ConstItem.SCONST_ITEM_POSITION_WEAPON);
			
			// 花费元宝加成默认为非选中
//			this.cbAddRate.checked = this._checkBoxDefault;
			this.cbAddRate.checked = _checkBoxCheck;
		}
		
		/**
		 * 根据当前武将id（this._curHeroId）设置当前武将强化数据（this._curHeroEnhanceData）
		 * 
		 */		
		private function _setCurHeroEnhanceData():void
		{
			this._curHeroEnhanceData = this._enhanceEquipData.getHeroEnhanceInfo(this._curHeroId);
			if (null == this._curHeroEnhanceData)
			{
				var addEnhanceData:Boolean = this._enhanceEquipData.addNewHeroEnhance(this._curHeroId);
				Assert(addEnhanceData == true, "add enhance data error, hero id is:" + this._curHeroId);
				this._curHeroEnhanceData = this._enhanceEquipData.getHeroEnhanceInfo(this._curHeroId);
			}
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
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			if (this._isInit)
			{
				this.labContAdd.removeEventListener(TouchEvent.TOUCH, _onClickAddRate);
				
				this.btnEnhance.removeEventListener(starling.events.Event.TRIGGERED, _onClickEnhance);
				
				this.cbAddRate.removeEventListener(starling.events.TouchEvent.TOUCH, _onClickAddRate);
				
				for each (var btnTemp:Button in this._btnVec)
				{
					btnTemp.removeEventListener(starling.events.Event.TRIGGERED, _onClickEquip);
				}
				this._layerHero.removeAllEventListener();
				
				
				this._enhanceEquipData.removeEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveEnhanceData);
				
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
		}
		
		/** controls */
		/** 动画 - 强化成功 */
		private var _completeAnimation:SAnimate;
		private var _imgBiankuang:Scale9Image
		
		private var _btnWeapon:Button;
		private var _btnHead:Button;
		private var _btnCloak:Button;
		private var _btnArmor:Button;
		private var _btnShoe:Button;
		private var _btnBelt:Button;
		
		/** 文字 - 对应部位 */
		private var _labPosition:Label;
		/** 文字 - 强化等级 */
		private var _labEnhancelv:Label;
		/** 内容  - 对应部位 */
		private var _labContPosition:Label;
		/** 内容 - 强化等级 */
		private var _labContEnhancelv:Label;
		
		/** 强化图标 - 等级星 */
		private var _layerStar:CJEnhanceLayerStar;
		
		/** 文字 - 当前效果 */
		private var _labCureffect:Label;
		/** 内容 - 当前效果 */
		private var _labContEffectpos:Label;
		/** 文字 - 当前效果 基础属性 */
		private var _labCurbase:Label;
		/** 内容 - 当前效果 基础属性 */
		private var _labContCurbase:Label;
		
		/** 文字 - 升级效果 */
		private var _labUpeffect:Label;
		/** 内容 - 升级效果 */
		private var _labContUpeffectpos:Label;
		/** 文字 - 升级效果 基础属性 */
		private var _labUpbase:Label;
		/** 内容 - 升级效果 基础属性 */
		private var _labContUpbase:Label;
		/** 内容 - 加成 */
		private var _labContAdd:Label;
		/** checkbox - 使用加成 */
		private var _layerCheckadd:SLayer;
		
		/** 文字 - 成功率 */
		private var _labRate:Label;
		/** 文字 - 银两消耗 */
		private var _labCost:Label;
		/** 内容 - 成功率 */
		private var _labContRate:Label;
		/** 内容 - 银两消耗 */
		private var _labContCost:Label;
		/** 按钮 - 强化 */
		private var _btnEnhance:Button;
		/** 按钮 - 强化10次 */
		private var _btnEnhanceTen:Button;
		/** checkbox - 加成 */
		private var _cbAddRate:CJEnhanceLayerCheckbox;
		
		/** 选中 */
		private var _imgSel:ImageLoader;
		/** 文字 - 说明 */
//		private var _labExplain:Label;
		/** 文字 - 拥有 */
		private var _labHas:Label;
		/** 文字 - 拥有银两 */
		private var _labContSilver:Label;
		/** 文字 - 拥有元宝 */
		private var _labContGoldHas:Label;
		
		
		/** setter */
		public function set imgBiankuang(value:Scale9Image):void
		{
			this._imgBiankuang = value;
		}
		public function set btnWeapon(value:Button):void
		{
			this._btnWeapon = value;
		}
		public function set btnHead(value:Button):void
		{
			this._btnHead = value;
		}
		public function set btnCloak(value:Button):void
		{
			this._btnCloak = value;
		}
		public function set btnArmor(value:Button):void
		{
			this._btnArmor = value;
		}
		public function set btnShoe(value:Button):void
		{
			this._btnShoe = value;
		}
		public function set btnBelt(value:Button):void
		{
			this._btnBelt = value;
		}
		public function set labPosition(value:Label):void
		{
			this._labPosition = value;
		}
		public function set labEnhancelv(value:Label):void
		{
			this._labEnhancelv = value;
		}
		public function set labContPosition(value:Label):void
		{
			this._labContPosition = value;
		}
		public function set labContEnhancelv(value:Label):void
		{
			this._labContEnhancelv = value;
		}
		public function set layerStar(value:CJEnhanceLayerStar):void
		{
			this._layerStar = value;
		}
		public function set labCureffect(value:Label):void
		{
			this._labCureffect = value;
		}
		public function set labContEffectpos(value:Label):void
		{
			this._labContEffectpos = value;
		}
		public function set labCurbase(value:Label):void
		{
			this._labCurbase = value;
		}
		public function set labContCurbase(value:Label):void
		{
			this._labContCurbase = value;
		}
		public function set labUpeffect(value:Label):void
		{
			this._labUpeffect = value;
		}
		public function set labContUpeffectpos(value:Label):void
		{
			this._labContUpeffectpos = value;
		}
		public function set labUpbase(value:Label):void
		{
			this._labUpbase = value;
		}
		public function set labContUpbase(value:Label):void
		{
			this._labContUpbase = value;
		}
		public function set labContAdd(value:Label):void
		{
			this._labContAdd = value;
		}
		public function set layerCheckadd(value:SLayer):void
		{
			this._layerCheckadd = value;
		}
		public function set labRate(value:Label):void
		{
			this._labRate = value;
		}
		public function set labCost(value:Label):void
		{
			this._labCost = value;
		}
		public function set labContRate(value:Label):void
		{
			this._labContRate = value;
		}
		public function set labContCost(value:Label):void
		{
			this._labContCost = value;
		}
		public function set btnEnhance(value:Button):void
		{
			this._btnEnhance = value;
		}
		public function set btnEnhanceTen(value:Button):void
		{
			this._btnEnhanceTen = value;
		}
		public function set cbAddRate(value:CJEnhanceLayerCheckbox):void
		{
			this._cbAddRate = value;
		}
//		public function set labExplain(value:Label):void
//		{
//			this._labExplain = value;
//		}
		public function set labHas(value:Label):void
		{
			this._labHas = value;
		}
		public function set labContSilver(value:Label):void
		{
			this._labContSilver = value;
		}
		public function set labContGoldHas(value:Label):void
		{
			this._labContGoldHas = value;
		}
		
		
		
		
		/** getter */
		public function get imgBiankuang():Scale9Image
		{
			return this._imgBiankuang;
		}
		public function get btnWeapon():Button
		{
			return this._btnWeapon;
		}
		public function get btnHead():Button
		{
			return this._btnHead;
		}
		public function get btnCloak():Button
		{
			return this._btnCloak;
		}
		public function get btnArmor():Button
		{
			return this._btnArmor;
		}
		public function get btnShoe():Button
		{
			return this._btnShoe;
		}
		public function get btnBelt():Button
		{
			return this._btnBelt;
		}
		public function get labPosition():Label
		{
			return this._labPosition;
		}
		public function get labEnhancelv():Label
		{
			return this._labEnhancelv;
		}
		public function get labContPosition():Label
		{
			return this._labContPosition;
		}
		public function get labContEnhancelv():Label
		{
			return this._labContEnhancelv;
		}
		public function get layerStar():CJEnhanceLayerStar
		{
			return this._layerStar;
		}
		public function get labCureffect():Label
		{
			return this._labCureffect;
		}
		public function get labContEffectpos():Label
		{
			return this._labContEffectpos;
		}
		public function get labCurbase():Label
		{
			return this._labCurbase;
		}
		public function get labContCurbase():Label
		{
			return this._labContCurbase;
		}
		public function get labUpeffect():Label
		{
			return this._labUpeffect;
		}
		public function get labContUpeffectpos():Label
		{
			return this._labContUpeffectpos;
		}
		public function get labUpbase():Label
		{
			return this._labUpbase;
		}
		public function get labContUpbase():Label
		{
			return this._labContUpbase;
		}
		public function get labContAdd():Label
		{
			return this._labContAdd;
		}
		public function get layerCheckadd():SLayer
		{
			return this._layerCheckadd;
		}
		public function get labRate():Label
		{
			return this._labRate;
		}
		public function get labCost():Label
		{
			return this._labCost;
		}
		public function get labContRate():Label
		{
			return this._labContRate;
		}
		public function get labContCost():Label
		{
			return this._labContCost;
		}
		public function get btnEnhance():Button
		{
			return this._btnEnhance;
		}
		public function get btnEnhanceTen():Button
		{
			return this._btnEnhanceTen;
		}
		public function get cbAddRate():CJEnhanceLayerCheckbox
		{
			return this._cbAddRate;
		}
		public function get labHas():Label
		{
			return this._labHas;
		}
		public function get labContSilver():Label
		{
			return this._labContSilver;
		}
		public function get labContGoldHas():Label
		{
			return this._labContGoldHas;
		}
		
		override public function dispose():void
		{
			super.dispose();
			this._filter.dispose();
		}
	}
}