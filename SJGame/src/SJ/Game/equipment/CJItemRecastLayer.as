package SJ.Game.equipment
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstItemRecast;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_itemRecast;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfRecast;
	import SJ.Game.data.CJDataOfRecastHero;
	import SJ.Game.data.CJDataOfRecastPosition;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfRecastProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_recastpropertyvalueconfig;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import starling.events.Event;
	
	/**
	 * 洗练层
	 * @author	zhengzheng
	 */
	
	public class CJItemRecastLayer extends SLayer
	{
		private var _layerMain:SLayer;
		private var _layerLeft:SLayer;
		private var _layerRight:SLayer;
		private var _arr_recasteEquipLayers:Array;
		
		private var _layer_propertyKind:SLayer;
		private var _label_property1:Label;
		private var _label_property2:Label;
		private var _label_property3:Label;
		private var _label_property4:Label;
		private var _button_refreshProperty:Button;
		private var _layer_propertyValue:SLayer;
		private var _label_propertyName1:Label;
		private var _label_propertyName2:Label;
		private var _label_propertyName3:Label;
		private var _label_propertyName4:Label;
		
		//附加属性标签
		private var _label_staticBonus:Label;
		private var _label_propertyNameBottom1:Label;
		private var _label_propertyNameBottom2:Label;
		private var _label_propertyNameBottom3:Label;
		private var _label_propertyNameBottom4:Label;
		private var _label_propertyValue1:Label;
		private var _label_propertyValue2:Label;
		private var _label_propertyValue3:Label;
		private var _label_propertyValue4:Label;
		private var _label_staticRecastPropertyValueCost:Label;
		private var _image_yinliang:ImageLoader;
		private var _label_recastPropertyValueCost:Label;
		private var _button_refreshPropertyValue:Button;
		private var _label_recastPropertyKindCost:Label;
		private var _image_yuanbao:ImageLoader;
		private var _label_warning:Label;
		/** 战斗力底图*/
		private var _imgFightNameBg:ImageLoader;
		/** 战斗力名称*/
		private var _labelFightName:Label;
		/** 战斗力数值*/
		private var _labelFightValue:Label;
		/** 附加属性底图*/
		private var _imgAddPropertyNameBg:ImageLoader;
		/** 上方属性名数组*/
		private var _arr_labelsPropertyName:Array;
		/** 上方属性标题数组*/
		private var _arr_labelsProperty:Array;
		/** 下方属性名数组*/
		private var _arr_labelsPropertyNameBottom:Array;
		/** 下方属性值数组*/
		private var _arr_labelsPropertyValueBottom:Array;
		/** 判断是否所有属性已经达到洗练上限*/
		private var _flag_isAllFull:Boolean = false;
		/** 武将头像层 */
		private var _layerHero:CJItemRecastHeroLayer;
		/** 当前武将id */
		private var _curHeroId:String;
		/** 当前选中的装备位 */
		private var _currentPos:int;
		/** 当前选中武将的品质 */
		private var _curHeroQuality:int;
		/** 当前选中武将的等级 */
		private var _curHeroLevel:int;
		/** 打开武将id */
		private var _openHeroId:String = "";
		/** 当前武将洗练信息 */
		private var _curHeroRecastData:CJDataOfRecastHero;
		/** 玩家洗练数据 */
		private var _dataRecast:CJDataOfRecast;
		/**主角信息*/
		private var _roleData:CJDataOfRole;
		/**玩家的vip等级*/
		private var _vipLevel:int;
		/**武将洗练需要的的最低等级*/
		private var _recastNeedLevel:int;
		/**vip功能配置*/
		private var _vipFuncJs:Json_vip_function_setting;
		/**装备位显示层*/
		private var _equipLayer:CJRecastEquipLayer;
		/**刷新消耗*/
		private var _refreshcost:int;
		public function CJItemRecastLayer()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
			_addEventListener();
		}
		/**
		 * 添加监听
		 * 
		 */		
		private function _addEventListener():void
		{
			_dataRecast.addEventListener(DataEvent.DataLoadedFromRemote , _refreshWithCurrentHero);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onReceiveSocketMessage);
			CJEventDispatcher.o.addEventListener(CJRecastEquipLayer.EventRecastPosClicked, _onEquipSelected);
			this.button_refreshProperty.addEventListener(starling.events.Event.TRIGGERED, _onRefreshPropertyKindButtonClicked);
			this.button_refreshPropertyValue.addEventListener(starling.events.Event.TRIGGERED, _onRefreshPropertyValueButtonClicked);
		}
		
		
		
		override public function dispose():void
		{
			if (_dataRecast)
			{
				_dataRecast.removeEventListener(DataEvent.DataLoadedFromRemote, _refreshWithCurrentHero);
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onReceiveSocketMessage);
			CJEventDispatcher.o.removeEventListener(CJRecastEquipLayer.EventRecastPosClicked, _onEquipSelected);
			super.dispose();
		}
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			//设置默认选中主角
			_curHeroId = CJDataManager.o.DataOfHeroList.getRoleId();
			_currentPos = ConstItem.SCONST_ITEM_POSITION_WEAPON;
			_roleData = CJDataManager.o.DataOfRole;
			_vipLevel = _roleData.vipLevel;
			_vipFuncJs = CJDataOfVipFuncSetting.o.getData(String(_vipLevel));
			_recastNeedLevel = int(CJDataOfGlobalConfigProperty.o.getData("RECAST_NEED_LEVEL"));
			_arr_labelsProperty = new Array(_label_property1, _label_property2, _label_property3, _label_property4);
			_arr_labelsPropertyName = new Array(_label_propertyName1, _label_propertyName2, _label_propertyName3, _label_propertyName4);
			_arr_labelsPropertyNameBottom = new Array(_label_propertyNameBottom1, _label_propertyNameBottom2, _label_propertyNameBottom3, _label_propertyNameBottom4);
			_arr_labelsPropertyValueBottom = new Array(_label_propertyValue1, _label_propertyValue2, _label_propertyValue3, _label_propertyValue4);
			
			_dataRecast = CJDataManager.o.DataOfRecast;
			if (_dataRecast.dataIsEmpty)
			{
				_dataRecast.loadFromRemote();
			}
			else
			{
				_refreshWithCurrentHero();
			}
		}
		/**
		 * 绘制内容
		 */		
		private function _drawContent():void
		{
			
			//背景底图
			var imgOperateBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinew", 1 ,1 , 1, 1);
			imgOperateBg.width = this.layerMain.width;
			imgOperateBg.height = this.layerMain.height;
			this.layerMain.addChildAt(imgOperateBg, 0);
			
			//右侧背景底图
			var imgRightBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 40,40 ,3,3);
			imgRightBg.x = 193;
			imgRightBg.y = 10;
			imgRightBg.width = 216;
			imgRightBg.height = this.layerMain.height - 20;
			this.layerMain.addChildAt(imgRightBg, 1);
			//分割线
			var line:ImageLoader = new ImageLoader();
			line.source = SApplication.assets.getTexture("common_fengexian");
			line.pivotX = line.width / 2;
			line.pivotY = line.height / 2;
			line.rotation = Math.PI / 2;
			line.x = 195;
			line.y = 10;
			line.width = 247;
			line.height = 5;
			this.layerMain.addChildAt(line, 2);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.layerMain.width - 8 , this.layerMain.height - 8);
			bgBall.x = 4;
			bgBall.y = 4;
			this.layerMain.addChildAt(bgBall, 3);
			
			//操作层 - 外边框图
			var imgOutFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew", 15 , 15 , 1, 1);
			imgOutFrame.width = this.layerMain.width;
			imgOutFrame.height = this.layerMain.height;
			this.layerMain.addChildAt(imgOutFrame, 4);
			
			var recastEquipXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlItemRecastEquipLayer) as XML;
			_equipLayer = SFeatherControlUtils.o.genLayoutFromXML(recastEquipXml, CJRecastEquipLayer) as CJRecastEquipLayer;
			_equipLayer.x = 75;
			_equipLayer.y = 9;
			this.addChild(_equipLayer);
			
			
			this.button_refreshPropertyValue.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			this.button_refreshPropertyValue.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			this.button_refreshPropertyValue.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new"));
			this.button_refreshPropertyValue.label = CJLang("RECAST_RECAST");
			this.button_refreshPropertyValue.defaultLabelProperties.textFormat = new TextFormat("黑体", 13, 0xB3A977, null, null, null, null, null, TextFormatAlign.CENTER);
			this.image_yinliang.source = SApplication.assets.getTexture("common_yinliang");
			
			
			//刷新属性,刷新属性值按钮
			this.button_refreshProperty.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.button_refreshProperty.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.button_refreshProperty.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			this.button_refreshProperty.defaultLabelProperties.textFormat = new TextFormat("黑体", 9, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			this.button_refreshProperty.label = CJLang("RECAST_REFRESH");
			//附加属性label
			this.label_staticRecastPropertyValueCost.text = CJLang("RECAST_COST2");
			this.label_staticBonus.textRendererProperties.textFormat = new TextFormat("黑体", 10, 0xB3A977, null, null, null, null, null, TextFormatAlign.CENTER);
			this.label_staticRecastPropertyValueCost.textRendererProperties.textFormat = new TextFormat("黑体", 10, 0x00FF00, null, null, null, null, null, TextFormatAlign.CENTER);
			this.button_refreshPropertyValue.defaultSelectedLabelProperties.textFormat = new TextFormat("黑体", 13, 0xB3A977, null, null, null, null, null, TextFormatAlign.CENTER);
			
			this.label_recastPropertyKindCost.textRendererProperties.textFormat = new TextFormat("黑体", 10, 0xFE6A00, null, null, null, null, null, TextFormatAlign.RIGHT);
			
			this.image_yuanbao.source = SApplication.assets.getTexture("common_yuanbao");
			this.label_warning.textRendererProperties.textFormat = new TextFormat("黑体", 12, 0xAAD293, null, null, null, null, null, TextFormatAlign.CENTER);
			
			//设置右边所有label的字体
			var arr_labels:Array = new Array(_label_property1, _label_property2, _label_property3, _label_property4,
				_label_propertyName1, _label_propertyName2, _label_propertyName3, _label_propertyName4,
				_label_propertyNameBottom1, _label_propertyNameBottom2, _label_propertyNameBottom3, _label_propertyNameBottom4,
				_label_propertyValue1, _label_propertyValue2, _label_propertyValue3, _label_propertyValue4,
				_label_recastPropertyValueCost, _label_recastPropertyKindCost, _labelFightName, _labelFightValue);
			for each (var label_temp:Label in arr_labels)
			{
				label_temp.textRendererProperties.textFormat = new TextFormat("黑体", 10, 0xF9F7D4, null, null, null, null, null, TextFormatAlign.CENTER);
			}
			for (var i:int = 0; i < _arr_labelsProperty.length; i++) 
			{
				var labelProperty:Label = _arr_labelsProperty[i] as Label
				labelProperty.text = CJLang("RECAST_PROPERTY" + (i + 1));
				labelProperty.visible = false;
			}
			
			//上方属性label的背景框
			var imageLabBg:Scale9Image;
			var label_hasBackImage:Label;
			for (var j:int = 0; j < _arr_labelsPropertyName.length; j++) 
			{
				imageLabBg = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_renwu_wenzidi", 2, 2,1,1);
				imageLabBg.alpha = 0.5;
				label_hasBackImage = _arr_labelsPropertyName[j] as Label;
				imageLabBg.width = label_hasBackImage.width;
				imageLabBg.height = label_hasBackImage.height;
				label_hasBackImage.addChild(imageLabBg);
				label_hasBackImage.visible = false;
			}
			//下方属性label的背景框
			for (j = 0; j < _arr_labelsPropertyValueBottom.length; j++) 
			{
				imageLabBg = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_renwu_wenzidi", 2, 2,1,1);
				imageLabBg.alpha = 0.5;
				label_hasBackImage = _arr_labelsPropertyValueBottom[j] as Label;
				imageLabBg.width = label_hasBackImage.width;
				imageLabBg.height = label_hasBackImage.height;
				label_hasBackImage.addChild(imageLabBg);
				label_hasBackImage.visible = false;
			}
			
			_imgFightNameBg.visible = false;
			_labelFightName.text = CJLang("RECAST_FIGHTING");
			this.label_staticBonus.text = CJLang("RECAST_ATTRIBUTEDBONUS");
			this.label_staticRecastPropertyValueCost.text = CJLang("RECAST_COST");
			this.layer_propertyValue.visible = false;
			this.layer_propertyKind.visible = false;
			
			this._refreshWithCurrentHero();
		}
		
		override protected function draw():void
		{
			super.draw();
			if (_openHeroId != "")
			{
				this.onSelectHero(_openHeroId);
				this._layerHero.selectHero(_openHeroId);
			}
			_openHeroId = "";
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
			_currentPos = ConstItem.SCONST_ITEM_POSITION_WEAPON;
			_equipLayer.onSelEquip(_currentPos);
			this._refreshWithCurrentHero();
			
		}
		
		/**
		 * 设置当前武将洗练数据
		 * 
		 */		
		private function _setCurHeroRecastData():void
		{
			
			_curHeroRecastData = _dataRecast.getHeroRecastInfo(this._curHeroId);
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
		}
		/**
		 * 设置不能刷新的界面显示
		 * 
		 */		
		private function _setPropertysCannotRefresh():void
		{
			var refreshPropertyKindCostConfig:Json_recastpropertyvalueconfig = CJDataOfRecastProperty.o.getRecastConfigWithQuality(_curHeroQuality);
			var labelPropertyName:Label;
			var labelProperty:Label;
			var propertyCount:int = refreshPropertyKindCostConfig.propertycount;
			//当武将没有刷新出特殊属性时
			for (var i:int = 0; i < propertyCount; i++)
			{
				labelPropertyName = _arr_labelsPropertyName[i] as Label;
				labelPropertyName.visible = true;
				labelPropertyName.text = CJLang("RECAST_PROPERTYNULL");
				labelProperty = _arr_labelsProperty[i] as Label;
				labelProperty.visible = true;
				labelProperty.text = CJLang("RECAST_PROPERTY" + (i + 1));
			}
			
			this.layer_propertyValue.visible = false;
			this.label_warning.text = CJLang("RECAST_CAN_NOT_RECAST_WARNING", {"level":_recastNeedLevel});
			this.label_warning.visible = true;
			label_recastPropertyKindCost.visible = false;
			this.button_refreshProperty.isEnabled = false;
			this.button_refreshPropertyValue.isEnabled = false;
		}
		
		/**
		 * 根据当前武将刷新界面
		 */
		private function _refreshWithCurrentHero():void
		{
			_setCurHeroRecastData();
			
			var recastPosData:CJDataOfRecastPosition = _curHeroRecastData.getRecastPosition(_currentPos);
			var arrBonuses:Array = new Array(recastPosData.addattrjin, recastPosData.addattrmu, 
				recastPosData.addattrshui, recastPosData.addattrhuo, recastPosData.addattrtu, 
				recastPosData.addattrbaoji, recastPosData.addattrrenxing, recastPosData.addattrshanbi, 
				recastPosData.addattrmingzhong, recastPosData.addattrzhiliao, recastPosData.addattrjianshang, 
				recastPosData.addattrxixue, recastPosData.addattrshanghai);
			_resetLabelsVisible();
			_refreshProperyKindWithPos(arrBonuses);
		}
		
		
		/**
		 * 装备选中后刷新右边界面
		 */
		private function _onEquipSelected(e:Event):void
		{
			_currentPos = e.data.curPosType;
			_refreshWithCurrentHero();
		}
		
		/**
		 * 根据当前选中的装备刷新右边的界面
		 */
		private function _refreshProperyKindWithPos(arrBonuses:Array):void
		{
			//取装备的模板信息
			var heroData:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(_curHeroId);
			var heroConfig:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(heroData.templateid);
			var isRole:Boolean = heroData.isRole;
			if (isRole)
			{
				_curHeroQuality = int(CJDataOfGlobalConfigProperty.o.getData("RECAST_ROLE_QUALITY"));
			}
			else
			{
				_curHeroQuality = int(heroConfig.quality);
			}
			_curHeroLevel = int(heroData.level);
			var recastConfig:Json_recastpropertyvalueconfig = CJDataOfRecastProperty.o.getRecastConfigWithParams(_curHeroLevel, _curHeroQuality);
			//获取洗练属性值的相对配置
			if (recastConfig == null)
			{
				_setPropertysCannotRefresh();
			}
			else
			{
				
				var arr_propertyNames:Array = new Array(CJLang("RECAST_PROPERTYNAME1"), CJLang("RECAST_PROPERTYNAME2"), 
					CJLang("RECAST_PROPERTYNAME3"), CJLang("RECAST_PROPERTYNAME4"), CJLang("RECAST_PROPERTYNAME5"), 
					CJLang("RECAST_PROPERTYNAME6"), CJLang("RECAST_PROPERTYNAME7"), CJLang("RECAST_PROPERTYNAME8"), 
					CJLang("RECAST_PROPERTYNAME9"), CJLang("RECAST_PROPERTYNAME10"), CJLang("RECAST_PROPERTYNAME11"), 
					CJLang("RECAST_PROPERTYNAME12"), CJLang("RECAST_PROPERTYNAME13"));
				var arr_bonusesValueLabels:Array = new Array(_label_propertyValue1, _label_propertyValue2, _label_propertyValue3, _label_propertyValue4);
				var refreshPropertyKindCostConfig:Json_recastpropertyvalueconfig = CJDataOfRecastProperty.o.getRecastConfigWithParams(_curHeroLevel, _curHeroQuality);
				this.label_recastPropertyKindCost.text = String(refreshPropertyKindCostConfig.refreshcost);
				
				if (_vipFuncJs)
				{
					var recast_silver:int = int(_vipFuncJs.recast_silver);
					var recastcost:int = int(refreshPropertyKindCostConfig.recastcost);
					recastcost = int(recastcost * ((100- recast_silver) / 100.0))
					this.label_recastPropertyValueCost.text = String(recastcost);
					
					var recast_gold:int = int(_vipFuncJs.recast_gold);
					_refreshcost = int(refreshPropertyKindCostConfig.refreshcost);
					_refreshcost = int(_refreshcost * ((100- recast_gold) / 100.0))
					label_recastPropertyKindCost.text = String(_refreshcost);
				}
				label_recastPropertyKindCost.visible = true;
				var arr_attributeUpLimit:Array = CJDataOfRecastProperty.o.getTopLimitArrayByLevel(_curHeroLevel);
				//取可洗的条数
				var count_property:int = int(recastConfig.propertycount);
				this.button_refreshProperty.isEnabled = !(count_property == 0);
				this.button_refreshPropertyValue.isEnabled = !(count_property == 0);
				if (!button_refreshProperty.isEnabled)
				{
					this.label_warning.text = CJLang("RECAST_CAN_NOT_RECAST_WARNING", {"level":_recastNeedLevel});
					this.label_warning.visible = true;
				}
				var index:int = 0;
				var flag_isAlreadyRecasted:Boolean = false;
				var tempCount:int = 0;
				_flag_isAllFull = false;
				for (var i:int = 0; i < count_property; i++)
				{
					var label_tempTop:Label = _arr_labelsPropertyName[i] as Label;
					var labelProperty:Label = _arr_labelsProperty[i] as Label;
					var label_tempBottom:Label = _arr_labelsPropertyNameBottom[i] as Label;
					var labelPropertyValueBottom:Label = _arr_labelsPropertyValueBottom[i] as Label;
					var label_bonusesValue:Label = arr_bonusesValueLabels[i] as Label;
					label_tempTop.visible = true;
					label_tempBottom.visible = true;
					labelProperty.visible = true;
					labelPropertyValueBottom.visible = true;
					var value_upLimit:int = int(arr_attributeUpLimit[i]);
					label_bonusesValue.text = CJLang("RECAST_PROPERTYNULL");
					var index_found:int = -1;
					while (index < arrBonuses.length)
					{
						var value:int = int(arrBonuses[index]);
						if (0 != value)
						{
							index_found = index;
							index++;
							break;
						}
						index++;
					}
					//根据index判断是哪个属性，然后给Label赋值
					if (-1 != index_found)
					{
						var str_propertyName:String = arr_propertyNames[index_found];
						
						label_tempTop.text = str_propertyName;
						label_tempBottom.text = str_propertyName;
						label_bonusesValue.text = String(arrBonuses[index_found]) + "/" + arr_attributeUpLimit[index_found];
						if (int(arrBonuses[index_found]) == int(arr_attributeUpLimit[index_found]))
						{
							tempCount ++;
						}
						if (tempCount == count_property)
						{
							_flag_isAllFull = true;
							button_refreshPropertyValue.isEnabled = false;
						}
						flag_isAlreadyRecasted= true;
					}
					else if (flag_isAlreadyRecasted)
					{
						label_tempTop.visible = false;
						label_tempBottom.visible = false;
						labelProperty.visible = false;
						labelPropertyValueBottom.visible = false;
					}
				}
				
				//刷新下面的属性信息
				if (!flag_isAlreadyRecasted)
				{
					this.layer_propertyValue.visible = false;
					this.label_warning.text = CJLang("RECAST_REFRESHPROPERTYKINDFIRST_WARNING");
					_button_refreshPropertyValue.isEnabled = false;
					this.label_warning.visible = true;
					for (var j:int = 0; j < count_property; j++)
					{
						label_tempTop = _arr_labelsPropertyName[j] as Label;
						label_tempTop.text = CJLang("RECAST_PROPERTYNULL");
					}
				}
				else
				{
					this.layer_propertyValue.visible = true;
					this.label_warning.visible = false;
				}
			}
			
		}
		
		/**
		 * 刷新属性按钮摁下
		 */
		private function _onRefreshPropertyKindButtonClicked(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			var recastConfig:Json_recastpropertyvalueconfig = CJDataOfRecastProperty.o.getRecastConfigWithParams(_curHeroLevel, _curHeroQuality);
			//获取洗练属性值的相对配置
			if (recastConfig)
			{
				var gold:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).gold;
				if (_refreshcost > gold)
				{
					CJFlyWordsUtil(CJLang("NOT_ENOUGH_GOLD"));
				}
				else
				{
					CJConfirmMessageBox(CJLang("RECAST_REFRESHPROPERTYKIND_CONFIRM", {"cost":_refreshcost}), _refreshPropertyKind);
				}
			}
		}
		/**
		 * 刷新属性种类
		 */
		private function _refreshPropertyKind():void
		{
			SocketCommand_itemRecast.recastPropertyKind(_curHeroId, _currentPos);
		}
		
		/**
		 * 洗练按钮 摁下
		 */
		private function _onRefreshPropertyValueButtonClicked(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			if (_flag_isAllFull)
			{
				CJFlyWordsUtil(CJLang("RECAST_ALL_PROPERTY_TOPEST"));
				return;
			}
			
			var recastConfig:Json_recastpropertyvalueconfig = CJDataOfRecastProperty.o.getRecastConfigWithParams(_curHeroLevel, _curHeroQuality);
			//获取洗练属性值的相对配置
			if (recastConfig)
			{
				var cost:int = int(recastConfig.recastcost);
				var silver:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).silver;
				if (cost > silver)
				{
					CJConfirmMessageBox(CJLang("RECAST_SILVER_LESS"), 
						function():void{
							SApplication.moduleManager.exitModule("CJEnhanceModule");
							SApplication.moduleManager.enterModule("CJMoneyTreeModule");
						});
				}
				else
				{
					_refreshPropertyValue();
				}
			}
		}
		/**
		 * 刷新属性值
		 */
		private function _refreshPropertyValue():void
		{
			SocketCommand_itemRecast.recastPropertyValue(_curHeroId, _currentPos);
		}
		
		
		/**
		 * 收到SOCKET信息
		 */
		private function _onReceiveSocketMessage(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_ITEMRECAST_PROPERTYKIND)
			{
				switch(message.retcode)
				{
					case ConstItemRecast.RECAST_REFRESH_SUCCESS:
						CJFlyWordsUtil(CJLang("RECAST_REFRESH_SUCCESS"));
						_dataRecast.loadFromRemote();
						this._refreshUserInfo();
						break;
					case ConstItemRecast.RECAST_HERO_NOT_EXIST:
						CJFlyWordsUtil(CJLang("RECAST_HERO_NOT_EXIST"));
						break;
					case ConstItemRecast.RECAST_INVILIDATE_POS:
						CJFlyWordsUtil(CJLang("RECAST_INVILIDATE_POS"));
						break;
					case ConstItemRecast.RECAST_GOLD_LESS:
						CJFlyWordsUtil(CJLang("RECAST_GOLD_LESS"));
						break;
					case ConstItemRecast.RECAST_REFRESH_FAIL:
						CJFlyWordsUtil(CJLang("RECAST_REFRESH_FAIL"));
						break;
					default:
						break;
				}
			}
			if (message.getCommand() == ConstNetCommand.CS_ITEMRECAST_PROPERTYVALUE)
			{
				switch(message.retcode)
				{
					case ConstItemRecast.RECAST_RECAST_SUCCESS:
						CJFlyWordsUtil(CJLang("RECAST_RECAST_SUCCESS"));
						_dataRecast.loadFromRemote();
						this._refreshUserInfo();
						CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_EQUIPRECAST});
						break;
					case ConstItemRecast.RECAST_SILVER_LESS:
						CJConfirmMessageBox(CJLang("RECAST_SILVER_LESS"), 
							function():void{
								SApplication.moduleManager.exitModule("CJEnhanceModule");
								SApplication.moduleManager.enterModule("CJMoneyTreeModule");
							});
						break;
					case ConstItemRecast.RECAST_RECAST_FAIL:
						CJFlyWordsUtil(CJLang("RECAST_RECAST_FAIL"));
						break;
					default:
						break;
				}
			}
		}
		
		
		/**
		 * 刷新用户信息，主要用来更新用户的金钱，总战斗力
		 */
		private function _refreshUserInfo():void
		{
			SocketCommand_role.get_role_info();
			SocketCommand_hero.get_heros();
		}
		/**
		 * 重新设置武将洗练属性的不可见状态
		 * 
		 */		
		private function _resetLabelsVisible():void
		{
			for (var i:int = 0; i < _arr_labelsPropertyName.length; i++)
			{
				var label_tempTop:Label = _arr_labelsPropertyName[i] as Label;
				var labelProperty:Label = _arr_labelsProperty[i] as Label;
				var label_tempBottom:Label = _arr_labelsPropertyNameBottom[i] as Label;
				var labelPropertyValueBottom:Label = _arr_labelsPropertyValueBottom[i] as Label;
				label_tempTop.visible = false;
				label_tempBottom.visible = false;
				labelProperty.visible = false;
				labelPropertyValueBottom.visible = false;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		public function get layerMain():SLayer
		{
			return _layerMain;
		}

		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}

		public function get layerLeft():SLayer
		{
			return _layerLeft;
		}

		public function set layerLeft(value:SLayer):void
		{
			_layerLeft = value;
		}

		public function get layerRight():SLayer
		{
			return _layerRight;
		}

		public function set layerRight(value:SLayer):void
		{
			_layerRight = value;
		}

		public function get layer_propertyKind():SLayer
		{
			return _layer_propertyKind;
		}

		public function set layer_propertyKind(value:SLayer):void
		{
			_layer_propertyKind = value;
		}


		public function get label_property1():Label
		{
			return _label_property1;
		}

		public function set label_property1(value:Label):void
		{
			_label_property1 = value;
		}

		public function get label_property2():Label
		{
			return _label_property2;
		}

		public function set label_property2(value:Label):void
		{
			_label_property2 = value;
		}

		public function get label_property3():Label
		{
			return _label_property3;
		}

		public function set label_property3(value:Label):void
		{
			_label_property3 = value;
		}

		public function get label_property4():Label
		{
			return _label_property4;
		}

		public function set label_property4(value:Label):void
		{
			_label_property4 = value;
		}

		public function get button_refreshProperty():Button
		{
			return _button_refreshProperty;
		}

		public function set button_refreshProperty(value:Button):void
		{
			_button_refreshProperty = value;
		}

		public function get layer_propertyValue():SLayer
		{
			return _layer_propertyValue;
		}

		public function set layer_propertyValue(value:SLayer):void
		{
			_layer_propertyValue = value;
		}

		public function get label_propertyName1():Label
		{
			return _label_propertyName1;
		}

		public function set label_propertyName1(value:Label):void
		{
			_label_propertyName1 = value;
		}

		public function get label_propertyName2():Label
		{
			return _label_propertyName2;
		}

		public function set label_propertyName2(value:Label):void
		{
			_label_propertyName2 = value;
		}

		public function get label_propertyName3():Label
		{
			return _label_propertyName3;
		}

		public function set label_propertyName3(value:Label):void
		{
			_label_propertyName3 = value;
		}

		public function get label_propertyName4():Label
		{
			return _label_propertyName4;
		}

		public function set label_propertyName4(value:Label):void
		{
			_label_propertyName4 = value;
		}

		public function get label_staticBonus():Label
		{
			return _label_staticBonus;
		}

		public function set label_staticBonus(value:Label):void
		{
			_label_staticBonus = value;
		}

		public function get label_propertyNameBottom1():Label
		{
			return _label_propertyNameBottom1;
		}

		public function set label_propertyNameBottom1(value:Label):void
		{
			_label_propertyNameBottom1 = value;
		}

		public function get label_propertyNameBottom2():Label
		{
			return _label_propertyNameBottom2;
		}

		public function set label_propertyNameBottom2(value:Label):void
		{
			_label_propertyNameBottom2 = value;
		}

		public function get label_propertyNameBottom3():Label
		{
			return _label_propertyNameBottom3;
		}

		public function set label_propertyNameBottom3(value:Label):void
		{
			_label_propertyNameBottom3 = value;
		}

		public function get label_propertyNameBottom4():Label
		{
			return _label_propertyNameBottom4;
		}

		public function set label_propertyNameBottom4(value:Label):void
		{
			_label_propertyNameBottom4 = value;
		}

		public function get label_propertyValue1():Label
		{
			return _label_propertyValue1;
		}

		public function set label_propertyValue1(value:Label):void
		{
			_label_propertyValue1 = value;
		}

		public function get label_propertyValue2():Label
		{
			return _label_propertyValue2;
		}

		public function set label_propertyValue2(value:Label):void
		{
			_label_propertyValue2 = value;
		}

		public function get label_propertyValue3():Label
		{
			return _label_propertyValue3;
		}

		public function set label_propertyValue3(value:Label):void
		{
			_label_propertyValue3 = value;
		}

		public function get label_propertyValue4():Label
		{
			return _label_propertyValue4;
		}

		public function set label_propertyValue4(value:Label):void
		{
			_label_propertyValue4 = value;
		}

		public function get label_staticRecastPropertyValueCost():Label
		{
			return _label_staticRecastPropertyValueCost;
		}

		public function set label_staticRecastPropertyValueCost(value:Label):void
		{
			_label_staticRecastPropertyValueCost = value;
		}

		public function get image_yinliang():ImageLoader
		{
			return _image_yinliang;
		}

		public function set image_yinliang(value:ImageLoader):void
		{
			_image_yinliang = value;
		}

		public function get label_recastPropertyValueCost():Label
		{
			return _label_recastPropertyValueCost;
		}

		public function set label_recastPropertyValueCost(value:Label):void
		{
			_label_recastPropertyValueCost = value;
		}

		public function get button_refreshPropertyValue():Button
		{
			return _button_refreshPropertyValue;
		}

		public function set button_refreshPropertyValue(value:Button):void
		{
			_button_refreshPropertyValue = value;
		}

		public function get label_recastPropertyKindCost():Label
		{
			return _label_recastPropertyKindCost;
		}

		public function set label_recastPropertyKindCost(value:Label):void
		{
			_label_recastPropertyKindCost = value;
		}

		public function get image_yuanbao():ImageLoader
		{
			return _image_yuanbao;
		}

		public function set image_yuanbao(value:ImageLoader):void
		{
			_image_yuanbao = value;
		}

		public function get label_warning():Label
		{
			return _label_warning;
		}

		public function set label_warning(value:Label):void
		{
			_label_warning = value;
		}

		/** 战斗力底图*/
		public function get imgFightNameBg():ImageLoader
		{
			return _imgFightNameBg;
		}
		/**
		 * @private
		 */
		public function set imgFightNameBg(value:ImageLoader):void
		{
			_imgFightNameBg = value;
		}

		/** 战斗力名称*/
		public function get labelFightName():Label
		{
			return _labelFightName;
		}

		/**
		 * @private
		 */
		public function set labelFightName(value:Label):void
		{
			_labelFightName = value;
		}

		/** 战斗力数值*/
		public function get labelFightValue():Label
		{
			return _labelFightValue;
		}

		/**
		 * @private
		 */
		public function set labelFightValue(value:Label):void
		{
			_labelFightValue = value;
		}

		/** 附加属性底图*/
		public function get imgAddPropertyNameBg():ImageLoader
		{
			return _imgAddPropertyNameBg;
		}

		/**
		 * @private
		 */
		public function set imgAddPropertyNameBg(value:ImageLoader):void
		{
			_imgAddPropertyNameBg = value;
		}

		/** 武将头像层 */
		public function get layerHero():CJItemRecastHeroLayer
		{
			return _layerHero;
		}

		/**
		 * @private
		 */
		public function set layerHero(value:CJItemRecastHeroLayer):void
		{
			_layerHero = value;
		}
	}
}