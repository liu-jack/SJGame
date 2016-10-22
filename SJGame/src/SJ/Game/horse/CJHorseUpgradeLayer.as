package SJ.Game.horse
{
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_horse;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.json.Json_horsebaseinfo;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMsgBoxSilverNotEnough;
	import SJ.Game.player.CJHorseSprite;
	import SJ.Game.task.CJTaskFlowImage;
	import SJ.Game.task.CJTaskFlowString;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
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
	 * @author	Weichao 骑术培养界面
	 * 2013-5-7
	 * @modified caihua 13/06/04
	 */
	public class CJHorseUpgradeLayer extends SLayer
	{
		private var _imageBack:ImageLoader;
		private var _labelCurrentRankStar:Label;
		private var _layerStars:SLayer;
		private var _barExperience:ProgressBar;
		private var _labelExperience:Label;
		private var _imageHorse:ImageLoader;
		private var _currentSelected:int = 0;
		private var _labelHorseName:Label;
		private var _imageNextLevel:ImageLoader;
		
		private var _layerMain:SLayer;
		private var _layer_currentLevelProperty:CJHorsePropertyLayer;
		private var _layer_nextLevelProperty:CJHorsePropertyLayer;
		private var _layer_max:CJHorsePropertyMax;
		
		private var _buttonRide:Button;
		private var _buttonUpgradeNormal:Button;
		private var _buttonUpgradeRank:Button;
		private var _buttonUpgradeGold:Button;
		
		private var _labelTip:Label;
		
		private var _buttonLeft:Button;
		private var _buttonRight:Button;
		
		private var _horseAnimate:CJHorseSprite;
		/*坐骑没加载完的时候的动画*/
		private var _horseLoading:SAnimate;
		
		private var _silverUpgradeCostContent:Label
		private var _goldUpgradeCostContent:Label
		
		private var _yuanquan:ImageLoader;
		private var _tween:STween;
		private var _imgYuanbao:ImageLoader;
		
		public function CJHorseUpgradeLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawBackground();
			this._drawButton();
			this._drawBar();
			this._drawUpgradeNeedSilver();
			this._drawAni();
			this._addEventListeners();
			labelCurrentRankStar.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xfff54d, null, null, null, null, null, TextFormatAlign.CENTER);
			this.labelHorseName.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			this.labelHorseName.textRendererFactory = textRender.htmlTextRender;
			_refresh();
			this._refreshCurrentHorse();
		}
		
		private function _drawAni():void
		{
			_yuanquan.pivotX = 42;
			_yuanquan.pivotY = 42;
			_yuanquan.scaleX = _yuanquan.scaleY = 2;
			
			_tween = new STween(_yuanquan, 20);
			_tween.animate("rotation", 2*Math.PI);
			_tween.loop = 1;
			Starling.juggler.add(_tween);
		}
		
		private function _drawUpgradeNeedSilver():void
		{
			this.silverUpgradeCostContent.textRendererFactory = textRender.htmlTextRender;
			this.goldUpgradeCostContent.textRendererFactory = textRender.htmlTextRender;
		}
		
		private function _drawBar():void
		{
			//进度条背景
			var progressBG:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("zuoqi_jindutiaodi"),20,3));
			progressBG.x = 110;
			progressBG.y = 283;
			progressBG.width = 315;
			this.addChild(progressBG);
			
			//进度条
			_barExperience = new ProgressBar();
			_barExperience.fillSkin = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("zuoqi_jindutiao"),1,1));
			_barExperience.maximum = 1;
			_barExperience.minimum = 0;
			_barExperience.x = 126;
			_barExperience.y = 287;
			_barExperience.width = 284;
			_barExperience.height = 11;
			this.addChild(_barExperience);
			
			//进度条上面的字
			_labelExperience = new Label();
			_labelExperience.x = 235;
			_labelExperience.y = 284;
			_labelExperience.width = 70;
			_labelExperience.height = 12;
			_labelExperience.textRendererProperties.textFormat = new TextFormat(null,null,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			this.addChild(_labelExperience);
		}
		
		private function _refresh():void
		{
			//			阶数
			this._refreshRankText();
			//			设置上面的星数显示
			this._refreshStar();
			//			经验值
			this._refreshExp();
			//			更新属性值
			this._refreshHorseBonus();
			//			更新按钮状态
			this._refreshButtonState();
			//  		更新当前需要的银币
			this._refreshUpgradeCost();
		}
		
		private function _drawBackground():void
		{
			//整个框设置背景
			var image9Back:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew"), new Rectangle(1,1 , 1,1)));
			image9Back.y = 15;
			image9Back.width = 482;
			image9Back.height = 240;
			this.addChildAt(image9Back , 0);
			
			//坐骑属性背景
			var horseBG:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zuoqi_shuxingkuang") , new Rectangle(12 ,12 , 1, 1)));
			horseBG.width = 195;
			horseBG.height = 150;
			horseBG.x = 266;
			horseBG.y = 32;
			this.addChildAt(horseBG , 1);
			
			//装饰
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(15 ,13 , 1, 1)));
			bgWrap.width = 450;
			bgWrap.height = 243;
			bgWrap.x = 0;
			bgWrap.y = 2;
			this.layerMain.addChildAt(bgWrap , 0);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(208 , 215);
			bgBall.x = 14;
			bgBall.y = 22;
			this.layerMain.addChildAt(bgBall , 3);
			
			//坐骑背景
			var horseBgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			horseBgWrap.width = 214;
			horseBgWrap.height = 222;
			horseBgWrap.x = 12;
			horseBgWrap.y = 19;
			this.layerMain.addChildAt(horseBgWrap , 4);
			
			//坐骑背景花边
			var flower:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangzhuangshinew") , new Rectangle(66 ,31 , 1, 1)));
			flower.width = 194;
			flower.height = 201;
			flower.x = 21;
			flower.y = 29;
			this.layerMain.addChildAt(flower , 5);
			
			_labelTip.textRendererFactory = textRender.htmlTextRender;
			var tf:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI);
			tf.size = 10;
			_labelTip.textRendererProperties.textFormat = tf;
			_labelTip.text = CJLang("HORSE_TIP_LABEL");
		}
		
		private function _drawButton():void
		{
			var arr_temp:Array = new Array();
			arr_temp.push(this.buttonRide, this.buttonUpgradeNormal,
				this.buttonUpgradeRank, this.buttonUpgradeGold);
			for each (var button_temp:Button in arr_temp)
			{
				button_temp.defaultLabelProperties.textFormat = CJHorseUtil.TextFormat_Orange;
				button_temp.labelOffsetY = -1;
				button_temp.labelFactory = textRender.htmlTextRender;
			}
			
			this.buttonRide.label = CJLang("HORSE_RIDE");
			this.buttonRide.name = "CJHorse_0";
			
			this.buttonUpgradeNormal.label =  CJLang("HORSE_NORMALUPGRADEBUTTON");
			this.buttonUpgradeNormal.name = "buttonUpgradeNormal";
			this.buttonUpgradeRank.label =  CJLang("HORSE_UPGRADERANKBUTTON");
			this.buttonUpgradeGold.label =  CJLang("HORSE_SPECIALUPGRADEBUTTON");
			this.buttonUpgradeGold.name = "buttonUpgradeGold";
			this.buttonUpgradeRank.visible = false;
			
			this.buttonLeft.pivotX = this.buttonLeft.width >> 1;
			this.buttonLeft.pivotY = this.buttonLeft.height >> 1;
			this.buttonLeft.scaleX = -1;
		}
		
		private function _addEventListeners():void
		{
			this.buttonRide.addEventListener(starling.events.Event.TRIGGERED, this._onRide);
			this.buttonUpgradeNormal.addEventListener(starling.events.Event.TRIGGERED, this._onUpgradeRideSkill);
			this.buttonUpgradeGold.addEventListener(starling.events.Event.TRIGGERED, _onUpgradeRideSkill);
			this.buttonUpgradeRank.addEventListener(starling.events.Event.TRIGGERED, _onUpgradeRank);
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_refreshUpgradeCost);
			
			//监听坐骑数据的变化
			CJDataManager.o.DataOfHorse.addEventListener(DataEvent.DataChange, _onHorseDataChange);
			CJDataManager.o.DataOfHorse.addEventListener("horsedatachange", _onHorseDataChange);
			
			this.buttonLeft.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				_onLeftButtonClicked();
			});
			this.buttonRight.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				_onRightButtonClicked();
			});
			
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_HORSE_LOAD_COMPLETE , this._onHorseLoadComplete);
		}
		
		private function _onLeftButtonClicked():void
		{
			var index_new:int = this._currentSelected - 1;
			if (0 > index_new)
			{
				index_new = 0;
			}
			this._currentSelected = index_new;
			this._refresh();
			//			更新当前坐骑
			this._refreshCurrentHorse();
		}
		
		private function _onRightButtonClicked():void
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var arr_horseList:Array = data.arr_horseList;
			var index_new:int = this._currentSelected + 1;
			if (arr_horseList.length - 1 < index_new)
			{
				index_new = arr_horseList.length - 1;
			}
			this._currentSelected = index_new;
			this._refresh();
			//			更新当前坐骑
			this._refreshCurrentHorse();
		}
		
		private function _refreshUpgradeCost():void
		{
			//取普通培养的该等级信息，要显示的信息
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var level:int = int(data.dic_baseInfo["rideskilllevel"]);
			
			var silverConfig:Object = CJHorseUtil.getUpgradeConfigByUpgradeType(ConstCurrency.CURRENCY_TYPE_SILVER);
			var goldConfig:Object = CJHorseUtil.getUpgradeConfigByUpgradeType(ConstCurrency.CURRENCY_TYPE_GOLD);
			var silverCost:int = int(silverConfig["costcoinnormal"]);
			var goldCost:int = int(goldConfig["costgoldspecial"]);
			
			//更新银币，金币数量
			var silver:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).silver;
			var gold:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).gold;
			
			if(silver > 1000000)
			{
				this.silverUpgradeCostContent.text = CJTaskHtmlUtil.colorText(""+silverCost+"/"+int(silver/10000) + CJLang("MAIN_UI_MONEY_UINT_MYRIAD") , "#FFFB84");
			}
			else
			{
				this.silverUpgradeCostContent.text = CJTaskHtmlUtil.colorText(""+silverCost+"/"+silver , "#FFFB84");
			}
			
			if(gold > 1000000)
			{
				this.goldUpgradeCostContent.text = CJTaskHtmlUtil.colorText(""+goldCost+"/"+int(gold/10000) + CJLang("MAIN_UI_MONEY_UINT_MYRIAD") , "#FFFB84");
			}
			else
			{
				this.goldUpgradeCostContent.text = CJTaskHtmlUtil.colorText(""+goldCost+"/"+gold , "#FFFB84");
			}
			
		}
		
		private function _refreshRankText():void
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var level:int = parseInt(data.dic_baseInfo["rideskilllevel"]);
			var rank:int = CJHorseUtil.getRank(level);
			var str_level:String = String(rank)+"  " + CJLang("HORSE_JIE");
			labelCurrentRankStar.text = str_level;
		}
		
		private function _refreshExp():void
		{
			var data:CJDataOfHorse = CJDataManager.o.DataOfHorse;
			var exp_left:int = parseInt(data.dic_baseInfo["leftexp"]);
			var level:int = parseInt(data.dic_baseInfo["rideskilllevel"]);
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseRideSkill) as Array;
			
			var rideSkillJson:Object = obj[level];
			
			var exp_total:Number = parseInt(rideSkillJson["upgradeexp"]);
			this._refreshExperienceBar(exp_left, exp_total);
		}
		
		private function _refreshStar():void
		{
			var data:CJDataOfHorse = CJDataManager.o.DataOfHorse;
			var starCount:int = CJHorseUtil.getStarCount(int(data.dic_baseInfo["rideskilllevel"]));
			this._layerStars.removeChildren();
			
			var textureStarOn:Texture = SApplication.assets.getTexture("zuoqi_xing01");
			var textureStarOff:Texture = SApplication.assets.getTexture("zuoqi_xing02");
			
			for (var i:int = 0; i < 10; i++)
			{
				var image_star:ImageLoader = new ImageLoader();
				image_star.x = textureStarOn.width + (i*30);
				image_star.y = 0;
				if (i < starCount)
				{
					image_star.source = textureStarOn;
				}
				else
				{
					image_star.source = textureStarOff;
				}
				_layerStars.addChild(image_star);
			}
		}
		
		private function _refreshExperienceBar(expLeft:Number, expMax:Number):void
		{
			var rate:Number = 0.0;
			
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var dic_baseInfo:Object = data.dic_baseInfo;
			var levelCurrent:int = parseInt(dic_baseInfo["rideskilllevel"]);
			if(levelCurrent >= 100)
			{
				rate = 1;
				_labelExperience.text = String("max/max");
				_barExperience.value = rate;
				return;
			}
			
			rate = expLeft * 1.0 / expMax;
			//溢出的情况
			if (1 < rate)
			{
				rate = 1;
				expLeft = expMax;
			}
			if (0.0001 > rate)
			{
				rate = 0;
			}
			
			_barExperience.value = rate;
			_labelExperience.text = String(expLeft) + "/" + String(expMax)
		}
	
		private function _refreshCurrentHorse():void
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			
			var arr_horseList:Array = data.arr_horseList;
			if (0 >= arr_horseList.length)
			{
				return;	
			}
			if (_currentSelected >= arr_horseList.length)
			{
				_currentSelected = 0;
			}
			var horseInfo:Object = arr_horseList[_currentSelected];
			var id_currentHorse:int = parseInt(horseInfo["horseid"]);
			var arr_horseConfiglist:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseBaseInfo) as Array;
			for (var i:int = 0; i < arr_horseConfiglist.length; i++)
			{
				var horseInfoTemp:Object = arr_horseConfiglist[i];
				if (parseInt(horseInfoTemp["horseid"]) == id_currentHorse)
				{
					var str_textureName:String = horseInfoTemp["resourcename"];
					
					if(_horseAnimate)
					{
						this._horseAnimate.removeFromParent();
					}
					
					if(_horseLoading)
					{
						_horseLoading.removeFromJuggler();
						_horseLoading.removeFromParent();
					}
					
					_horseLoading = new SAnimate(SApplication.assets.getTextures("ma_dutiaorun_"));
					_horseLoading.scaleX = _horseLoading.scaleY = 4;
					Starling.juggler.add(_horseLoading);
					this._layerMain.addChildTo(_horseLoading , 20 , 50);
					_horseAnimate = new CJHorseSprite(id_currentHorse); 
					
					_horseAnimate.visible = false;
					_horseAnimate.touchable = false;
					this._layerMain.addChildTo(_horseAnimate , 110 , 160);
					_horseAnimate.bringMetofrount();
					
					var str_horseName:String = horseInfoTemp["name"];
					this._labelHorseName.text = CJLang(str_horseName);
				}
			}
		}
	
		private function _refreshHorseBonus():void
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var dic_baseInfo:Object = data.dic_baseInfo;
			var levelCurrent:int = parseInt(dic_baseInfo["rideskilllevel"]);
			var arr_horseList:Array = data.arr_horseList;
			if (0 >= arr_horseList.length)
			{
				return;	
			}
			if (_currentSelected >= arr_horseList.length)
			{
				_currentSelected = 0;
			}
			var horseInfo:Object = arr_horseList[_currentSelected];
			var id_currentHorse:int = parseInt(horseInfo["horseid"]);
			//取得当前坐骑的属性加成比
			var horseInfoJson:Json_horsebaseinfo = null;
			horseInfoJson = CJHorseUtil.getHorseBaseInfoWithHorseID(id_currentHorse);
			
			//取得当前等级的属性加成
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseRideSkill) as Array;
			if(obj == null)
			{
				return;
			}
			var rate:Number = 0;
			var isFull:Boolean = false;
			var rideSkillJson:Object = obj[levelCurrent];
			var rideSkillJson_nextLevel:Object = null
			var levelNext:int = 1 + levelCurrent;
			if(levelNext >= obj.length)
			{
				isFull = true;
			}
			else
			{
				rideSkillJson_nextLevel = obj[levelNext];
			}
			
			//当前属性
			var xml_horseProerty:XML = AssetManagerUtil.o.getObject("horsePropertyLayout.sxml") as XML;
			if (null == this._layer_currentLevelProperty)
			{
				this._layer_currentLevelProperty = 
					SFeatherControlUtils.o.genLayoutFromXML(xml_horseProerty,CJHorsePropertyLayer) as CJHorsePropertyLayer;
				this._layer_currentLevelProperty.x = 244;
				this._layer_currentLevelProperty.y = 28;
				this.layerMain.addChildAt(this._layer_currentLevelProperty, 1);
			}
			this._layer_currentLevelProperty.labelTitle.text = CJLang("HORSE_CURRENTBONUS");
			var dic_propertyBonusCurrent:Object = this._genFinalPropertyBonus(rideSkillJson, horseInfoJson);
			this._layer_currentLevelProperty.refreshWithParams(dic_propertyBonusCurrent);
			
			if(isFull)
			{
				if (null != this._layer_nextLevelProperty)
				{
					_layer_nextLevelProperty.visible = false;
				}
				this._layer_max = new CJHorsePropertyMax();
				this._layer_max.x = 343;
				this._layer_max.y = 28;
				this.layerMain.addChildAt(this._layer_max, 1);
			}
			else
			{
				//下一级属性
				if (null == this._layer_nextLevelProperty)
				{
					this._layer_nextLevelProperty = 
						SFeatherControlUtils.o.genLayoutFromXML(xml_horseProerty,CJHorsePropertyLayer) as CJHorsePropertyLayer;
					this._layer_nextLevelProperty.x = 343;
					this._layer_nextLevelProperty.y = 28;
					this.layerMain.addChildAt(this._layer_nextLevelProperty, 1);
				}
				this._layer_nextLevelProperty.labelTitle.text = CJLang("HORSE_NEXTBONUS");
				var dic_propertyBonusNext:Object = this._genFinalPropertyBonus(rideSkillJson_nextLevel, horseInfoJson);
				this._layer_nextLevelProperty.refreshWithParams(dic_propertyBonusNext);
			}
		}
	
		private function _refreshButtonState():void
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var dic_baseInfo:Object = data.dic_baseInfo;
			var isRiding:int = int(dic_baseInfo["isriding"]);
			var currentActivedHorseid:int = int(dic_baseInfo["currenthorseid"]);
			var arr_horseList:Array = data.arr_horseList;
			
			var horseInfo:Object = arr_horseList[_currentSelected];
			var id_currentHorse:int = int(horseInfo["horseid"]);
			if (CJHorseUtil.canDismount(data) && id_currentHorse == currentActivedHorseid)
			{
				this.buttonRide.label = CJLang("HORSE_UNMOUNT");
			}
			else
			{
				this.buttonRide.label = CJLang("HORSE_RIDE");
			}
			
			var canUpgrade:Boolean = CJHorseUtil.canUpgrade(data);
			var canUpgradeRank:Boolean = CJHorseUtil.canUpgradeRank(data);
			
			this.buttonUpgradeNormal.visible = !canUpgradeRank;
			this.buttonUpgradeGold.visible = !canUpgradeRank;
			this.goldUpgradeCostContent.visible = !canUpgradeRank;
			this.silverUpgradeCostContent.visible = !canUpgradeRank;
			this.imgYuanbao.visible = !canUpgradeRank;
			this.buttonUpgradeRank.visible = canUpgradeRank;
			
			if(_currentSelected > 0)
			{
				this.buttonLeft.isEnabled = true;
			}
			else
			{
				this.buttonLeft.isEnabled = false;
			}
			
			if (null != arr_horseList && _currentSelected < arr_horseList.length - 1)
			{
				this.buttonRight.isEnabled = true;
				this.buttonLeft.filter = null;
			}
			else
			{
				this.buttonRight.isEnabled = false;
			}
		}
		
		private function _genFinalPropertyBonus(baseBonus:Object, horseBonus:Json_horsebaseinfo):Object
		{
			//满级
			if(baseBonus == null)
			{
				return null;
			}
			
			var RetValue:Object = new Object();
			
			RetValue["goldbonus"] = Number(baseBonus["goldbonus"]) * Number(horseBonus.metalbonusrate);
			RetValue["woodbonus"] = Number(baseBonus["woodbonus"]) * Number(horseBonus.woodbonusrate);
			RetValue["waterbonus"] = Number(baseBonus["waterbonus"]) * Number(horseBonus.waterbonusrate);
			RetValue["firebonus"] = Number(baseBonus["firebonus"]) * Number(horseBonus.firebonusrate);
			RetValue["eartchbonus"] = Number(baseBonus["eartchbonus"]) * Number(horseBonus.earthbonusrate);
			return RetValue;
		}
	
	
		private function _onRide(e:Event):void
		{
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			//取得现在的骑乘状态
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var horseBaseInfo:Object = data.dic_baseInfo;
			var isRiding:int = int(horseBaseInfo["isriding"]);
			var currentActivedHorseid:int = int(horseBaseInfo["currenthorseid"]);
			var arr_horseList:Array = data.arr_horseList;
			var horseInfo:Object = arr_horseList[_currentSelected];
			var id_currentHorse:int = parseInt(horseInfo["horseid"]);
			if (1 == isRiding && id_currentHorse == currentActivedHorseid)
			{
				SocketCommand_horse.dismount();
			}
			else
			{
				SocketCommand_horse.rideHorse(String(id_currentHorse));
				CJDataManager.o.DataOfHorse.clickType = "ride";
			}
		}
		
		private function _onUpgradeRideSkill(e:Event):void
		{
			if(e.target is Button)
			{
				var button:Button = e.target as Button;
				//处理指引
				if(CJDataManager.o.DataOfFuncList.isIndicating)
				{
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
				}
				
				//检测坐骑等级是否高于主角等级
				var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
				var level:int = int(data.dic_baseInfo["rideskilllevel"]);
				var roleLevel:int = int(CJDataManager.o.DataOfHeroList.getMainHero().level);
				if(level >= roleLevel)
				{
					new CJTaskFlowString(CJLang("HORSE_LEVEL_NOT_ENOUGH" , {"level":(roleLevel + 1) }), 1 , 10).addToLayer();
					return;
				}
				
				//取当前点击次数下的培养配置
				var config:Object;
				var cost:int;
				var exp:int;
				var beishu:int;
				if(button.name == "buttonUpgradeNormal")
				{
					config = CJHorseUtil.getUpgradeConfigByUpgradeType(ConstCurrency.CURRENCY_TYPE_SILVER);
					cost = int(config["costcoinnormal"]);
					exp = int(config["expnormal"]);
					beishu = int(config["jichubaojibeishu"]);
					var silver:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).silver;
					if(silver < cost)
					{
						CJMsgBoxSilverNotEnough(CJLang("ITEM_MAKE_RESULT_STATE_LACK_SILVER"), 
							"", 
							function():void{
								SApplication.moduleManager.exitModule("CJHorseModule");
							});
					}
					else
					{
						SocketCommand_horse.upgradeRideSkill(String(0), String(1));
					}
				}
				else
				{
					config = CJHorseUtil.getUpgradeConfigByUpgradeType(ConstCurrency.CURRENCY_TYPE_GOLD);
					cost = int(config["costgoldspecial"]);
					exp = int(config["expgoldnormal"]);
					beishu = int(config["teshupeiyangbaojibeishu"]);
					var gold:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).gold;
					if(gold < cost)
					{
						CJMsgBoxSilverNotEnough(CJLang("ITEM_MAKE_RESULT_STATE_LACK_GOLD"), 
							"", 
							function():void{
								SApplication.moduleManager.exitModule("CJHorseModule");
							});
					}
					else
					{
						SocketCommand_horse.upgradeRideSkill(String(1), String(1));
					}
				}
				
			}
		}
		
		private function _onUpgradeRank(e:Event):void
		{
			var xml:XML = AssetManagerUtil.o.getObject("horseUpgradeRank.sxml") as XML;
			var layer_upgradeRank:CJHorseUpgradeRankLayer = SFeatherControlUtils.o.genLayoutFromXML(xml,CJHorseUpgradeRankLayer) as CJHorseUpgradeRankLayer;
			CJLayerManager.o.addModuleLayer(layer_upgradeRank);
		}
		
		private function _getCurrentHorseid():int
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var arr_horseList:Array = data.arr_horseList;
			if (0 >= arr_horseList.length)
			{
				return 0;	
			}
			if (_currentSelected >= arr_horseList.length)
			{
				_currentSelected = 0;
			}
			var horseInfo:Object = arr_horseList[_currentSelected];
			var id_currentHorse:int = parseInt(horseInfo["horseid"]);
			return id_currentHorse;
		}
		
		private function _onHorseDataChange(e:Event):void
		{
			this._refresh();
			
			if(e.target is CJDataOfHorse && e.type == "horsedatachange")
			{
				if(e.data.type == "upgraderideskill")
				{
					var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
					
					new CJTaskFlowString(CJLang("HORSE_UPGRADE_RESULT" , 
						{"totalcount":e.data.totalCount , "upgradetotalexp":e.data.upgradetotalexp , "critical":e.data.criticalCount})
					,1.5 , 20).addToLayer();
					
					//播特效  0 - 普通 1 - 元宝
					if(e.data.upgradetype == 0)
					{
						this._setUpAnimate("zuoqi_putongpeiyang" , -33 , -36 , 4);
					}
					else
					{
						this._setUpAnimate("zuoqi_gaojipeiyang" , -33 , -36 , 4);
					}
					
				}
				else 
				{
					if(e.data.type == "ridehorse")
					{
						//激活窗口
						(this.parent.parent as CJHorseLayer).activeLayer("upgrade");
						
						_currentSelected = 0;
						
						this._setUpAnimate("zuoqihuanhua_chenggongtexiao" , -15 , 0 , 4);
						
						if(CJDataManager.o.DataOfHorse.clickType == "huanhua")
						{
							//飘字
							new CJTaskFlowImage("texiaozi_zuoqihuanhuachenggong").addToLayer();
						}
						
						this._refreshButtonState();
						this._refreshHorseBonus();
					}
					else if (e.data.type == "activeHorse")
					{
						_currentSelected = 0;
						this._setUpAnimate("zuoqihuanhua_jihuotexiao" , -15 , 0 , 4);
					}
					this._refreshCurrentHorse();
				}
			}
		}
		
		private function _setUpAnimate(texturePrefix:String, x:int, y:int , scale:Number = 1):void
		{
			//播特效
			var anim:SAnimate = new SAnimate(SApplication.assets.getTextures(texturePrefix) , 8);
			if(!anim)
			{
				return;
			}
			
			anim.x = x;
			anim.y = y;
			anim.scaleX = anim.scaleY = scale;
			this.layerMain.addChild(anim);
			
			Starling.juggler.add(anim);
			
			anim.addEventListener(Event.COMPLETE , function(e:Event):void
			{
				if(e.target is SAnimate)
				{
					_removeAnims(e.target as SAnimate);
				}
			});
		}
		
		override public function dispose():void
		{
			super.dispose();
			Starling.juggler.remove(_tween);
			_tween = null;
			//移除监听
			CJDataManager.o.DataOfHorse.removeEventListener(DataEvent.DataChange , this._onHorseDataChange);
			CJDataManager.o.DataOfHorse.removeEventListener("horsedatachange" , this._onHorseDataChange);
			
			this.buttonRide.removeEventListener(starling.events.Event.TRIGGERED, this._onRide);
			this.buttonUpgradeNormal.removeEventListener(starling.events.Event.TRIGGERED, this._onUpgradeRideSkill);
			this.buttonUpgradeGold.removeEventListener(starling.events.Event.TRIGGERED, _onUpgradeRideSkill);
			this.buttonUpgradeRank.removeEventListener(starling.events.Event.TRIGGERED, _onUpgradeRank);
			
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_refreshUpgradeCost);
			
			this.buttonLeft.removeEventListeners(starling.events.Event.TRIGGERED);
			this.buttonRight.removeEventListeners(starling.events.Event.TRIGGERED);
			
			CJEventDispatcher.o.removeEventListeners(CJEvent.EVENT_HORSE_LOAD_COMPLETE);
			
		}
		
		private function _onHorseLoadComplete(e:Event):void
		{
			if(this._horseLoading)
			{
				_horseLoading.removeFromParent();
				_horseLoading.removeFromJuggler();
			}
			_horseAnimate.visible = true;
			_horseAnimate.touchable = true;
			_horseAnimate.addEventListener(TouchEvent.TOUCH , _showHorseTip);
		}
		
		private function _showHorseTip(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_horseAnimate);	
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				var xml_tip:XML = AssetManagerUtil.o.getObject("horseHuanhuaTip.sxml") as XML;
				var tip:CJHorseHuanhuaTipLayer = SFeatherControlUtils.o.genLayoutFromXML(xml_tip, CJHorseHuanhuaTipLayer) as CJHorseHuanhuaTipLayer;
				CJLayerManager.o.addModuleLayer(tip);
				tip.refreshWithHorseid(_horseAnimate.horseId , CJHorseUtil.calcHorseStatus(_horseAnimate.horseId));
			}
		}
		
		private function _removeAnims(anim:SAnimate):void
		{
			if(anim!= null)
			{
				anim.removeFromParent();
				anim.removeFromJuggler();
			}
		}
		
		public function get labelTip():Label
		{
			return _labelTip;
		}
		
		public function set labelTip(value:Label):void
		{
			_labelTip = value;
		}
		
		public function get imageNextLevel():ImageLoader
		{
			return _imageNextLevel;
		}
		
		public function set imageNextLevel(value:ImageLoader):void
		{
			_imageNextLevel = value;
		}
		
		public function get labelExperience():Label
		{
			return _labelExperience;
		}
		
		public function set labelExperience(value:Label):void
		{
			_labelExperience = value;
		}
		
		public function get buttonRide():Button
		{
			return _buttonRide;
		}
		
		public function set buttonRide(value:Button):void
		{
			_buttonRide = value;
		}
		
		public function get buttonUpgradeNormal():Button
		{
			return _buttonUpgradeNormal;
		}
		
		public function set buttonUpgradeNormal(value:Button):void
		{
			_buttonUpgradeNormal = value;
		}
		
		public function get buttonUpgradeRank():Button
		{
			return _buttonUpgradeRank;
		}
		
		public function set buttonUpgradeRank(value:Button):void
		{
			_buttonUpgradeRank = value;
		}
		
		public function get buttonUpgradeGold():Button
		{
			return _buttonUpgradeGold;
		}
		
		public function set buttonUpgradeGold(value:Button):void
		{
			_buttonUpgradeGold = value;
		}
		
		public function get layerMain():SLayer
		{
			return _layerMain;
		}
		
		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}
		
		public function get layer_currentLevelProperty():CJHorsePropertyLayer
		{
			return _layer_currentLevelProperty;
		}
		
		public function set layer_currentLevelProperty(value:CJHorsePropertyLayer):void
		{
			_layer_currentLevelProperty = value;
		}
		
		public function get layer_nextLevelProperty():CJHorsePropertyLayer
		{
			return _layer_nextLevelProperty;
		}
		
		public function set layer_nextLevelProperty(value:CJHorsePropertyLayer):void
		{
			_layer_nextLevelProperty = value;
		}
		
		public function get labelHorseName():Label
		{
			return _labelHorseName;
		}
		
		public function set labelHorseName(value:Label):void
		{
			_labelHorseName = value;
		}
		
		public function get imageHorse():ImageLoader
		{
			return _imageHorse;
		}
		
		public function set imageHorse(value:ImageLoader):void
		{
			_imageHorse = value;
		}
		
		public function get imageBack():ImageLoader
		{
			return _imageBack;
		}
		public function set imageBack(value:ImageLoader):void
		{
			_imageBack = value;
		}
		
		public function get labelCurrentRankStar():Label
		{
			return _labelCurrentRankStar;
		}
		public function set labelCurrentRankStar(value:Label):void
		{
			_labelCurrentRankStar = value;
		}
		public function get layerStars():SLayer
		{
			return _layerStars;
		}
		public function set layerStars(value:SLayer):void
		{
			_layerStars = value;
		}
		public function get buttonRight():Button
		{
			return _buttonRight;
		}
		
		public function set buttonRight(value:Button):void
		{
			_buttonRight = value;
		}
		
		public function get buttonLeft():Button
		{
			return _buttonLeft;
		}
		
		public function set buttonLeft(value:Button):void
		{
			_buttonLeft = value;
		}

		public function get silverUpgradeCostContent():Label
		{
			return _silverUpgradeCostContent;
		}

		public function set silverUpgradeCostContent(value:Label):void
		{
			_silverUpgradeCostContent = value;
		}

		public function get yuanquan():ImageLoader
		{
			return _yuanquan;
		}

		public function set yuanquan(value:ImageLoader):void
		{
			_yuanquan = value;
		}

		public function get goldUpgradeCostContent():Label
		{
			return _goldUpgradeCostContent;
		}

		public function set goldUpgradeCostContent(value:Label):void
		{
			_goldUpgradeCostContent = value;
		}

		public function get imgYuanbao():ImageLoader
		{
			return _imgYuanbao;
		}

		public function set imgYuanbao(value:ImageLoader):void
		{
			_imgYuanbao = value;
		}


	}
}