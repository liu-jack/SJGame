package SJ.Game.bag
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_horse;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfFunctionList;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfHeroTag;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.data.json.Json_horsebaseinfo;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.enhanceequip.CJEnhanceLayer;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	import SJ.Game.task.CJTaskFlowString;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.utils.Logger;
	
	import feathers.controls.Button;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * 背包tooltip层
	 * @author sangxu
	 * 
	 */	
	public class CJBagItemTooltip extends CJItemTooltip
	{
		/** 按钮附加高度 */
		private const _BUTTON_ADD_HEIGHT:int = 3;
		/** 数据 - 功能开启 */
		private var _dataFunctionList:CJDataOfFunctionList;
		
		public function CJBagItemTooltip()
		{
			super();
		}
		
		override protected function _initData():void
		{
			super._initData();
			_dataFunctionList = CJDataManager.o.getData("CJDataOfFunctionList");
		}
		
		override protected function initButtons():void
		{
			super.initButtons();
			
			if (this._itemTemplate.type == ConstItem.SCONST_ITEM_TYPE_EQUIP)
			{
				// 装备
				this._initButtonsEquip();
			}
			else if (this._itemTemplate.type == ConstItem.SCONST_ITEM_TYPE_JEWEL)
			{
				// 宝石
				this._initButtonsJewel();
			}
			else if (this._itemTemplate.type == ConstItem.SCONST_ITEM_TYPE_USE)
			{
				// 道具
				this._initButtonsUse();
			}
			else if (this._itemTemplate.type == ConstItem.SCONST_ITEM_TYPE_MATERIAL)
			{
				// 材料
				this._initButtonsMaterial();
			}
			
			
		}
		
		/**
		 * 初始化按钮 - 装备
		 * 
		 */		
		private  function _initButtonsEquip():void
		{
			// 字体 - 按钮文字
			var fontFormatBtn:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE4C200,null,null,null,null,null, TextFormatAlign.CENTER );
			
			var hasSellBtn:Boolean = false;
			if (parseInt(this._itemTemplate.sellstate) == ConstItem.SCONST_ITEM_SELL_STATE_CAN)
			{
				// 卖出按钮
				this.btnSell = new Button();
				this.btnSell.y = currentY;
				this.btnSell.x = 133;
				this.btnSell.width = ConstBag.BUTTON_WIDTH_MIN;
				this.btnSell.height = ConstBag.BUTTON_HEIGHT_MIN;
				this.btnSell.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
				this.btnSell.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
				this.btnSell.defaultLabelProperties.textFormat = fontFormatBtn;
				this.btnSell.label = CJLang("ITEM_TOOLTIP_BTN_SELL");
				this._infoLayer.addChild(this.btnSell);
				this.btnSell.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickSell);
				hasSellBtn = true;
			}
			
			// 装备按钮
			this.btnEquip = new Button();
			this.btnEquip.y = currentY;
			this.btnEquip.x = hasSellBtn ? 41 : 88;
			this.btnEquip.width = ConstBag.BUTTON_WIDTH_MIN;
			this.btnEquip.height = ConstBag.BUTTON_HEIGHT_MIN;
			this.btnEquip.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnEquip.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnEquip.defaultLabelProperties.textFormat = fontFormatBtn;
//			var itemTmplType:int = parseInt(this._itemTemplate.type)
//			if (ConstItem.SCONST_ITEM_TYPE_USE == itemTmplType
//				|| ConstItem.SCONST_ITEM_TYPE_JEWEL == itemTmplType
//				|| ConstItem.SCONST_ITEM_TYPE_MATERIAL == itemTmplType)
//			{
//				// 道具/宝石/材料 - 显示“使用”
//				btnTemp.label = CJLang("ITEM_TOOLTIP_BTN_USE");
//			}
//			else if(ConstItem.SCONST_ITEM_TYPE_EQUIP == itemTmplType)
//			{
//				// 装备 - 显示“装备”
//				btnTemp.label = CJLang("ITEM_TOOLTIP_BTN_EQP");
//			}
			this.btnEquip.label = CJLang("ITEM_TOOLTIP_BTN_EQP");
			this._infoLayer.addChild(this.btnEquip);
			this.btnEquip.addEventListener(Event.TRIGGERED, _onBtnClickEquip);
			
			// 存入按钮 
//			btnTemp = new Button();
//			btnTemp.y = currentY;
//			btnTemp.x = 90;
//			btnTemp.width = ConstBag.BUTTON_WIDTH_MIN;
//			btnTemp.height = ConstBag.BUTTON_HEIGHT_MIN;
//			btnTemp.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
//			btnTemp.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
//			btnTemp.defaultLabelProperties.textFormat = fontFormatBtn;
//			btnTemp.label = CJLang("ITEM_TOOLTIP_BTN_SAVE");
//			this._infoLayer.addChild(btnTemp);
//			btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickSave);
			
			
			this.currentY += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
			this.bgHeight += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
		}
		
		/**
		 * 初始化按钮 - 道具
		 * 
		 */		
		private  function _initButtonsUse():void
		{
			// 字体 - 按钮文字
			var fontFormatBtn:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE4C200,null,null,null,null,null, TextFormatAlign.CENTER );
			
			//三个按钮，x分别为:12, 90, 164
			
			var hasSellBtn:Boolean = false;
			if (parseInt(this._itemTemplate.sellstate) == ConstItem.SCONST_ITEM_SELL_STATE_CAN)
			{
				// 按钮 - 卖出
				btnTemp = new Button();
				btnTemp.y = currentY;
				btnTemp.x = 133;
				btnTemp.width = ConstBag.BUTTON_WIDTH_MIN;
				btnTemp.height = ConstBag.BUTTON_HEIGHT_MIN;
				btnTemp.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
				btnTemp.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
				btnTemp.defaultLabelProperties.textFormat = fontFormatBtn;
				btnTemp.label = CJLang("ITEM_TOOLTIP_BTN_SELL");
				this._infoLayer.addChild(btnTemp);
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickSell);
				hasSellBtn = true;
			}
			
			var btnTemp:Button;
			// 按钮 - 使用
			this.btnUse = new Button();
			this.btnUse.y = currentY;
			this.btnUse.x = hasSellBtn ? 41 : 88;
			this.btnUse.width = ConstBag.BUTTON_WIDTH_MIN;
			this.btnUse.height = ConstBag.BUTTON_HEIGHT_MIN;
			this.btnUse.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnUse.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnUse.defaultLabelProperties.textFormat = fontFormatBtn;
//			var itemTmplType:int = parseInt(this._itemTemplate.type);
			var itemTmplLogicId:int = int(this._itemTemplate.uselogicid);
			if (itemTmplLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEITEM
				|| itemTmplLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHERO
				|| itemTmplLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHORSE)
			{
				this.btnUse.label = CJLang("BAG_BTN_NAME_COMPOSE");
			}
			else
			{
				this.btnUse.label = CJLang("ITEM_TOOLTIP_BTN_USE");
			}
			this._infoLayer.addChild(this.btnUse);
			this.btnUse.addEventListener(Event.TRIGGERED, _onBtnClickUse);
			
			// 按钮 - 存入
//			btnTemp = new Button();
//			btnTemp.y = currentY;
//			btnTemp.x = 90;
//			btnTemp.width = ConstBag.BUTTON_WIDTH_MIN;
//			btnTemp.height = ConstBag.BUTTON_HEIGHT_MIN;
//			btnTemp.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
//			btnTemp.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
//			btnTemp.defaultLabelProperties.textFormat = fontFormatBtn;
//			btnTemp.label = CJLang("ITEM_TOOLTIP_BTN_SAVE");
//			this._infoLayer.addChild(btnTemp);
//			btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickSave);
			
			
			
			this.currentY += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
			this.bgHeight += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
		}
		/**
		 * 初始化按钮 - 宝石
		 * 
		 */		
		private  function _initButtonsJewel():void
		{
			// 字体 - 按钮文字
			var fontFormatBtn:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE4C200,null,null,null,null,null, TextFormatAlign.CENTER );
			
			// 按钮 - 镶嵌
			this.btnInlay = new Button();
			this.btnInlay.y = currentY;
			this.btnInlay.x = 41;
			this.btnInlay.width = ConstBag.BUTTON_WIDTH_MIN;
			this.btnInlay.height = ConstBag.BUTTON_HEIGHT_MIN;
			this.btnInlay.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnInlay.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnInlay.defaultLabelProperties.textFormat = fontFormatBtn;
			var itemTmplType:int = parseInt(this._itemTemplate.type)
			this.btnInlay.label = CJLang("JEWEL_BTN_XIANGQIAN");
			this._infoLayer.addChild(this.btnInlay);
			this.btnInlay.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickJewelInlay);
			
			// 按钮 - 合成
			this.btnCombine = new Button();
			this.btnCombine.y = currentY;
			this.btnCombine.x = 133;
			this.btnCombine.width = ConstBag.BUTTON_WIDTH_MIN;
			this.btnCombine.height = ConstBag.BUTTON_HEIGHT_MIN;
			this.btnCombine.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnCombine.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnCombine.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnCombine.label = CJLang("JEWEL_BTN_HECHENG");
			this._infoLayer.addChild(this.btnCombine);
			this.btnCombine.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickJewelCombine);
			
//			// 卖出按钮
//			btnTemp = new Button();
//			btnTemp.y = currentY;
//			btnTemp.x = 165;
//			btnTemp.width = ConstBag.BUTTON_WIDTH_MIN;
//			btnTemp.height = ConstBag.BUTTON_HEIGHT_MIN;
//			btnTemp.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
//			btnTemp.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
//			btnTemp.defaultLabelProperties.textFormat = fontFormatBtn;
//			btnTemp.label = CJLang("ITEM_TOOLTIP_BTN_SELL");
//			this._infoLayer.addChild(btnTemp);
//			btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onBtnSellClick);
			
			this.currentY += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
			this.bgHeight += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
		}
		/**
		 * 初始化按钮 - 材料
		 * 
		 */		
		private  function _initButtonsMaterial():void
		{
			// 字体 - 按钮文字
			var fontFormatBtn:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE4C200,null,null,null,null,null, TextFormatAlign.CENTER );
			var hasSellBtn:Boolean = false;
			if (parseInt(this._itemTemplate.sellstate) == ConstItem.SCONST_ITEM_SELL_STATE_CAN)
			{
				// 按钮 - 卖出
				this.btnSell = new Button();
				this.btnSell.y = currentY;
				this.btnSell.x = 133;
				this.btnSell.width = ConstBag.BUTTON_WIDTH_MIN;
				this.btnSell.height = ConstBag.BUTTON_HEIGHT_MIN;
				this.btnSell.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
				this.btnSell.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
				this.btnSell.defaultLabelProperties.textFormat = fontFormatBtn;
				this.btnSell.label = CJLang("ITEM_TOOLTIP_BTN_SELL");
				this._infoLayer.addChild(this.btnSell);
				this.btnSell.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickSell);
				
				hasSellBtn = true;
			}
			
			// 按钮 - 使用
			this.btnUse = new Button();
			this.btnUse.y = currentY;
			this.btnUse.x = hasSellBtn ? 41 : 88;
			this.btnUse.width = ConstBag.BUTTON_WIDTH_MIN;
			this.btnUse.height = ConstBag.BUTTON_HEIGHT_MIN;
			this.btnUse.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnUse.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnUse.defaultLabelProperties.textFormat = fontFormatBtn;
			var itemTmplSubType:int = parseInt(this._itemTemplate.subtype);
			if (itemTmplSubType == ConstItem.SCONST_ITEM_SUBTYPE_METAIL_ZHUZAO)
			{
				this.btnUse.label = CJLang("ENHANCE_BTN_ZHUZAO");
			} 
			else if (itemTmplSubType == ConstItem.SCONST_ITEM_SUBTYPE_METAIL_SHENGXING)
			{
				this.btnUse.label = CJLang("ITEM_TOOLTIP_BTN_SHENGXING");
			}
			else if (itemTmplSubType == ConstItem.SCONST_ITEM_SUBTYPE_METAIL_CHUANGONG)
			{
				this.btnUse.label = CJLang("ITEM_TOOLTIP_BTN_CHUANGONG");
			}
			else
			{
				this.btnUse.label = CJLang("ITEM_TOOLTIP_BTN_USE");
			}
			
			this._infoLayer.addChild(this.btnUse);
			this.btnUse.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickMaterialUse);
			
			
			this.currentY += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
			this.bgHeight += ConstBag.BUTTON_HEIGHT_MIN + _BUTTON_ADD_HEIGHT;
		}
		
		/**
		 * 添加监听事件
		 * 
		 */		
		override protected function _addListener():void
		{
			super._addListener();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, this._onRpcReturn);
		}
		
		
		
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_ITEM_SELL_ITEM)
			{
				// 出售道具
				if (msg.retcode == 0)
				{
					// 更新页面货币显示
//					SocketCommand_role.get_role_info();
//					SocketCommand_item.getBag();
					this.closeToolTip();
				}
			}
			else if(msg.getCommand() == ConstNetCommand.CS_ITEM_USE_ITEM)
			{
				// 使用道具
				if (msg.retcode == 0)
				{
					// 更新页面道具显示
					var retData:Object = msg.retparams;
					if (retData.hasOwnProperty("logicid"))
					{
						var logicId:int = int(retData.logicid);
						if (logicId == ConstItem.SCONST_ITEM_USE_LOGIC_MONEY)
						{
							// 增加货币类道具 - 获取货币信息
//							SocketCommand_role.get_role_info();
							var itemTemplateId:int = int(retData.itemtmplid);
							var itemTemplate:Json_item_setting = _itemTemplateSetting.getTemplate(itemTemplateId);
							var showMoney:String = "";
							var currencyType:String = "";
							if (int(itemTemplate.useparam0) == ConstCurrency.CURRENCY_TYPE_GOLD)
							{
								currencyType = CJLang("CURRENCY_NAME_GOLD");
							}
							else if (int(itemTemplate.useparam0) == ConstCurrency.CURRENCY_TYPE_SILVER)
							{
								currencyType = CJLang("CURRENCY_NAME_SILVER");
							}
							showMoney = currencyType + " + " + String(int(itemTemplate.useparam1) * int(retData.count))
							new CJTaskFlowString(showMoney, 1.8, 40).addToLayer();
						}
						else if (logicId == ConstItem.SCONST_ITEM_USE_LOGIC_PACKAGE)
						{
							// 飘字
							if (retData.hasOwnProperty("itemtmplid"))
							{
								var showWord:String = "";
								showWord = CJItemUtil.getPackageItemsDescHtml(String(retData.itemtmplid), int(retData.count), CJTaskHtmlUtil.br);
								
								new CJTaskFlowString(showWord, 1.8, 40).addToLayer();
							}
						}
						else if (logicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEITEM)
						{
							// 合成道具
							var itemTmpl:Json_item_setting = this._itemTemplateSetting.getData(String(retData.itemtmplid));
							var newItemTmpl:Json_item_setting = this._itemTemplateSetting.getData(String(itemTmpl.useparam0));
							var useItemCount:int = int(retData.count);
							var newCount:int = useItemCount / int(itemTmpl.useparam1);
							var showWordComposeItem:String = CJLang("BAG_USE_COMPOSE_COMPLETE", {"name":CJLang(newItemTmpl.itemname), "count":newCount})
							new CJTaskFlowString(showWordComposeItem, 1.8, 40).addToLayer();
						}
						else if (logicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHERO)
						{
							// 合成武将
							var itemTmplOldHero:Json_item_setting = this._itemTemplateSetting.getData(String(retData.itemtmplid));
							var heroTmpl:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(itemTmplOldHero.useparam0));
							var heroItemCount:int = int(retData.count);
							var newHeroCount:int = heroItemCount / int(itemTmplOldHero.useparam1);
							
							var showWordComposeHero:String = CJLang("BAG_USE_COMPOSE_COMPLETE", {"name":CJLang(heroTmpl.name), "count":newHeroCount})
							new CJTaskFlowString(showWordComposeHero, 1.8, 40).addToLayer();
							
							SocketCommand_hero.get_heros();
						}
						else if (logicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHORSE)
						{
							// 合成坐骑
							var itemTmplOldHorse:Json_item_setting = this._itemTemplateSetting.getData(String(retData.itemtmplid));
							var horseTmpl:Json_horsebaseinfo = CJHorseUtil.getHorseBaseInfoWithHorseID(int(itemTmplOldHorse.useparam0));
							var horseItemCount:int = int(retData.count);
							var newHorseCount:int = horseItemCount / int(itemTmplOldHorse.useparam1);
							
							var showWordComposeHorse:String = CJLang("BAG_USE_COMPOSE_COMPLETE", {"name":CJLang(horseTmpl.name), "count":newHorseCount})
							new CJTaskFlowString(showWordComposeHorse, 1.8, 40).addToLayer();
							
							SocketCommand_horse.getHorseInfo();
						}
					}
					
					SocketCommand_item.getBag();
					SocketCommand_role.get_role_info();
					this.closeToolTip();
					//发出使用道具的事件
					CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED , false , {"type":CJTaskEvent.TASK_EVENT_USE_TOOL});
				}
				else if (msg.retcode == 3)
				{
					// 未到使用等级
					CJMessageBox(CJLang("BAG_USE_NOT_LV_CONTANT"));
					return;
				}
				else if (msg.retcode == 5)
				{
					// 不可使用的道具
					CJMessageBox(CJLang("BAG_USE_NOT_CONTANT"));
					return;
				}
				else if (msg.retcode == 6)
				{
					// 道具使用失败
					CJMessageBox(CJLang("BAG_USE_ERROR_CONTANT"));
					return;
				}
				else if (msg.retcode == 10)
				{
					// 道具使用失败 - 体力超上限
					CJMessageBox(CJLang("BAG_USE_ERROR_VIT"));
					return;
				}
				else if (msg.retcode == 13)
				{
					// 道具使用失败 - 合成 - 数量不足
					CJMessageBox(CJLang("BAG_USE_COMPOSE_COUNTLESS"));
					return;
				}
				else if (msg.retcode == 15)
				{
					// 道具使用失败 - 合成 - 背包空间不足
					CJMessageBox(CJLang("BAG_HAS_NOT_ENOUGH_GRID"));
					return;
				}
				else if (msg.retcode == 16)
				{
					// 道具使用失败 - 合成 - 没有足够武将位
					CJMessageBox(CJLang("BAG_USE_COMPOSE_HEROMAX"));
					return;
				}
				else if (msg.retcode == 17)
				{
					// 道具使用失败 - 合成 - 坐骑只能合成一个
					CJMessageBox(CJLang("BAG_USE_COMPOSE_HORSECOUNT"));
					return;
				}
				else if (msg.retcode == 18)
				{
					// 道具使用失败 - 合成 - 已有该坐骑，不能合成
					CJMessageBox(CJLang("BAG_USE_COMPOSE_HORSEHAVE"));
					return;
				}
			}
			
		}
		
		/**
		 * 按钮点击处理 - 道具使用
		 * @param event
		 * 
		 */		
		private function _onBtnClickUse(event:Event):void
		{
			// 使用
//			if (parseInt(this._itemTemplate.usestate) != ConstItem.SCONST_ITEM_USE_STATE_CAN)
			if (parseInt(this._itemTemplate.uselogicid) == ConstItem.SCONST_ITEM_USE_LOGIC_CANNOT)
			{
				// 不可使用的道具
				CJMessageBox(CJLang("BAG_USE_NOT_CONTANT"));
				return;
			}
			if (parseInt(this._itemTemplate.level) > parseInt(CJDataManager.o.DataOfHeroList.getMainHero().level))
			{
				// 未到使用等级
				CJMessageBox(CJLang("BAG_USE_NOT_LV_CONTANT"));
				return;
			}
			
//			if (parseInt(this._itemTemplate.uselogicid) == ConstItem.SCONST_ITEM_USE_LOGIC_ADDPROP)
//			{
//				
//			}
			
			if (parseInt(this._itemTemplate.uselogicid) == ConstItem.SCONST_ITEM_USE_LOGIC_RANDOMBOX)
			{
				SApplication.moduleManager.enterModule("CJRandomBoxModule", {itemid:this._itemData.itemid});
				SApplication.moduleManager.exitModule("CJBagModule");
//				this.removeFromParent(true);
				CJLayerManager.o.removeFromLayerFadeout(this);
				return;
			}
			
			// 道具
			if (_itemData.count > 1)
			{
				// 大于1，弹出使用框
				var itemUseLogicId:int = int(this._itemTemplate.uselogicid);
				
				var countLayer:CJItemUseCountLayer = new CJItemUseCountLayer();
				countLayer.sureCallBack = this._onCountBtnSureClick;
				if (itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEITEM
					|| itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHERO
					|| itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHORSE)
				{
					countLayer.maxValue = this._itemData.count / int(this._itemTemplate.useparam1);
				}
				else
				{
					countLayer.maxValue = this._itemData.count;
				}
				countLayer.useMax = (int(this._itemTemplate.usemax) > 0) ? true : false;
				countLayer.useLogicId = int(this._itemTemplate.uselogicid);
				countLayer.x = (Starling.current.stage.stageWidth - countLayer.width)>>1;
				countLayer.y = (Starling.current.stage.stageHeight - countLayer.height)>>1;
				CJLayerManager.o.addModuleLayer(countLayer);
			}
			else
			{
				Assert(_itemData.count > 0, "item count <= 0");
				// 数量为1，直接使用
				this._useItem(_itemData.count);
			}
		}
		
		/**
		 * 按钮点击处理 - 装备按钮
		 * @param event
		 * 
		 */		
		private function _onBtnClickEquip(event:Event) : void
		{
			if (false == _isFunctionOpen("CJHeroPropertyUIModule"))
			{
				return;
			}
				
			SApplication.moduleManager.enterModule("CJHeroPropertyUIModule");
			this.closeToolTip();
			SApplication.moduleManager.exitModule("CJBagModule");
		}
		
		/**
		 * 按钮点击处理 - 镶嵌
		 * @param event
		 * 
		 */		
		private function _onBtnClickJewelInlay(event:Event) : void
		{
			if (false == _isFunctionOpen("CJJewelModule"))
			{
				return;
			}
			
			var param:Object = new Object();
			param["pagetype"] = 0;
			SApplication.moduleManager.enterModule("CJJewelModule", param);
			this.closeToolTip();
			SApplication.moduleManager.exitModule("CJBagModule");
		}
		/**
		 * 按钮点击处理 - 合成
		 * @param event
		 * 
		 */		
		private function _onBtnClickJewelCombine(event:Event) : void
		{
			if (false == _isFunctionOpen("CJJewelModule"))
			{
				return;
			}
			
			var param:Object = new Object();
			param["pagetype"] = 1;
			SApplication.moduleManager.enterModule("CJJewelModule", param);
			this.closeToolTip();
			SApplication.moduleManager.exitModule("CJBagModule");
		}
		
		/**
		 * 按钮点击处理 - 存入按钮
		 * @param event
		 * 
		 */		
		private function _onBtnClickSave(event:Event) : void
		{
			Logger.log("CJBagLayer" , "!!!!!!!!! _onBtnSaveClick click!");
		}
		/**
		 * 按钮点击处理 - 材料使用
		 * @param event
		 * 
		 */		
		private function _onBtnClickMaterialUse(event:Event) : void
		{
			var itemTmplSubType:int = parseInt(this._itemTemplate.subtype);
			if (itemTmplSubType == ConstItem.SCONST_ITEM_SUBTYPE_METAIL_ZHUZAO)
			{
				// 铸造
				if (false == _isFunctionOpen("CJEnhanceModule_1"))
				{
					return;
				}
				
				var param:Object = new Object();
				param["pagetype"] = CJEnhanceLayer.BTN_TYPE_ZHUZAO;
				SApplication.moduleManager.enterModule("CJEnhanceModule", param);
			} 
			else if (itemTmplSubType == ConstItem.SCONST_ITEM_SUBTYPE_METAIL_SHENGXING)
			{
				// 升星
				if (false == _isFunctionOpen("CJHeroStarModule"))
				{
					return;
				}
				
				SApplication.moduleManager.enterModule("CJHeroStarModule");
			}
			else if (itemTmplSubType == ConstItem.SCONST_ITEM_SUBTYPE_METAIL_CHUANGONG)
			{
				// 传功
				if (false == _isFunctionOpen("CJTransferAbilityModule"))
				{
					return;
				}
				SApplication.moduleManager.enterModule("CJTransferAbilityModule");
			}
			else
			{
				
			}
			
			this.closeToolTip();
			SApplication.moduleManager.exitModule("CJBagModule");
		}
		/**
		 * 按钮点击处理 - 卖出
		 * @param event
		 * 
		 */	
		private function _onBtnClickSell(event:Event) : void
		{
			if (ConstItem.SCONST_ITEM_SELL_STATE_CAN != parseInt(_itemTemplate.sellstate))
			{
				// 道具不可出售
				CJMessageBox(CJLang("BAG_SELL_NOT_CONTANT"));
				return;
			}
			var money:int = parseInt(this._itemTemplate.sellprice) * this._itemData.count; 
			var contant:String = CJLang("BAG_SELL_CONTANT");
			contant = contant.replace("{item}", CJLang(this._itemTemplate.itemname));
			contant = contant.replace("{money}", money);
			var sellType:int = parseInt(this._itemTemplate.selltype);
			if (sellType == ConstCurrency.CURRENCY_TYPE_SILVER)
			{
				contant = contant.replace("{currency}", CJLang("CURRENCY_NAME_SILVER"));
			}
			else if (sellType == ConstCurrency.CURRENCY_TYPE_GOLD)
			{
				contant = contant.replace("{currency}", CJLang("CURRENCY_NAME_GOLD"));
			}
			CJConfirmMessageBox(contant, _onSellCfmClickSure, null);
		}
		
		/**
		 * 使用道具
		 * @param count 使用数量
		 * 
		 */		
		private function _useItem(count:int):void
		{
			if (parseInt(this._itemTemplate.uselogicid) == ConstItem.SCONST_ITEM_USE_LOGIC_PACKAGE)
			{
				/** 礼包道具 */
				var addItemData:Array = CJItemUtil.getPackageData(this._itemTemplate.id);
				var bagData:CJDataOfBag = CJDataManager.o.getData("CJDataOfBag");
				var canPutInBag:Boolean = CJItemUtil.canPutItemsInBag(bagData, addItemData);
				if (false == canPutInBag)
				{
					var contant:String = CJLang("ITEM_NOTUSE_BAGNOTENOUGH");
					contant = contant.replace("{container}", this._getLangContainertype());
					CJMessageBox(contant);
					return;
				}
			}
			var itemUseLogicId:int = int(this._itemTemplate.uselogicid);
//			var itemTmplType:int = parseInt(this._itemTemplate.type);
//			var itemTmplSubtype:int = int(this._itemTemplate.subtype);
//			if (itemTmplType == ConstItem.SCONST_ITEM_TYPE_USE
//				&& (itemTmplSubtype == ConstItem.SCONST_ITEM_SUBTYPE_USE_COMPOSEITEM
//					|| itemTmplSubtype == ConstItem.SCONST_ITEM_SUBTYPE_USE_COMPOSEHERO
//					|| itemTmplSubtype == ConstItem.SCONST_ITEM_SUBTYPE_USE_COMPOSEHORSE))
			if (itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEITEM
				|| itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHERO
				|| itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHORSE)
			{
				/** 使用逻辑 - 合成 */
				var cfgCount:int = int(this._itemTemplate.useparam1);
				var useItemcount:int = cfgCount * count;
				if (this._itemData.count < useItemcount)
				{
					CJMessageBox(CJLang("BAG_USE_COMPOSE_COUNTLESS"));
					return;
				}
				if (itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEITEM)
				{
					// 合成道具
					var newItemTmplId:String = String(this._itemTemplate.useparam0);
					if (!CJItemUtil.canPutItemInBag(this._bagData, int(newItemTmplId), count))
					{
						CJMessageBox(CJLang("BAG_HAS_NOT_ENOUGH_GRID"));
						return;
					}
				}
				else if (itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHERO)
				{
					// 合成武将
					var newHeroTmplId:String = String(this._itemTemplate.useparam0);
					var dataHeroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
					var dataHeroTag:CJDataOfHeroTag = CJDataManager.o.DataOfHeroTag;
					if (dataHeroTag != null)
					{
						if (dataHeroTag.herotaglist != null)
						{
							if ((dataHeroTag.herotaglist.length - dataHeroList.heroCount) < count)
							{
								CJMessageBox(CJLang("BAG_USE_COMPOSE_HEROMAX"));
								return;
							}
						}
					}
				}
				else if (itemUseLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHORSE)
				{
					// 合成坐骑
					if (count > 1)
					{
						CJMessageBox(CJLang("BAG_USE_COMPOSE_HORSECOUNT"));
						return;
					}
					var newHorseTmplId:String = String(this._itemTemplate.useparam0);
					
					var horseList:Array = CJDataManager.o.DataOfHorse.arr_horseList;
					for each (var horseInfo:Object in horseList)
					{
						if (String(horseInfo.horseid) == newHorseTmplId)
						{
							CJMessageBox(CJLang("BAG_USE_COMPOSE_HORSEHAVE"));
							return;
						}
					}
				}
				
				count = useItemcount;
			}
				
			// 向服务器发送使用道具
			SocketCommand_item.useItem(this._containerType, this._itemId, count);
		}
		
		/**
		 * 使用道具弹出界面确认按钮回调方法
		 * @param count
		 * 
		 */		
		private function _onCountBtnSureClick(count:int):void
		{
			this._useItem(count);
		}
		
		/**
		 * 出售道具，点击confirm确认按钮
		 * @param event
		 * 
		 */		
		private function _onSellCfmClickSure() : void
		{
			// 添加网络锁
//			SocketLockManager.KeyLock(ConstNetCommand.CS_ITEM_SELL_ITEM);
			
			SocketCommand_item.sellItem(ConstBag.CONTAINER_TYPE_BAG, String(this._itemData.itemid));
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		override protected function removeAllEventListener():void
		{
			super.removeAllEventListener();
			
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, this._onRpcReturn);
			
//			if (this.btnEquip != null)
//			{
//				this.btnEquip.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickEquip);
//			}
//			if (this.btnSell != null)
//			{
//				this.btnSell.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickSell);
//			}
//			if (this.btnInlay != null)
//			{
//				this.btnInlay.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickJewelInlay);
//			}
//			if (this.btnCombine != null)
//			{
//				this.btnCombine.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickJewelCombine);
//			}
//			if (this.btnUse != null)
//			{
//				this.btnUse.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickMaterialUse);
//				this.btnUse.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickUse);
//			}
		}
		
		/**
		 * 判断是否已开启功能
		 * @param moudleName
		 * @return 
		 * 
		 */		
		private function _isFunctionOpen(moudleName:String):Boolean
		{
			var isOpen:Boolean = _dataFunctionList.isFunctionOpen(moudleName);
			if (false == isOpen)
			{
				var funcCfg:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByModulename(moudleName);
				CJFlyWordsUtil(CJLang("ITEM_TOOLTIP_ALERT_LVLOW", {"level":String(funcCfg.level)}));
			}
			return isOpen;
		}
		
		/**
		 * 根据当前道具所属容器类型获取语言表中容器名
		 * @return 
		 * 
		 */		
		private function _getLangContainertype():String
		{
			switch (this._containerType)
			{
				case ConstBag.CONTAINER_TYPE_BAG:
					return CJLang("CONTAINER_TYPE_BAG");
				case ConstBag.CONTAINER_TYPE_WH:
					return CJLang("CONTAINER_TYPE_WH");
			}
			return "";
		}
		
		/** controls */
		/** 按钮 - 装备 */
		private var _btnEquip:Button;
		/** 按钮 - 卖出 */
		private var _btnSell:Button;
		/** 按钮 - 镶嵌 */
		private var _btnInlay:Button;
		/** 按钮 - 合成 */
		private var _btnCombine:Button;
		/** 按钮 - 使用 */
		private var _btnUse:Button;
		
		/** setter */
		public function set btnEquip(value:Button):void
		{
			this._btnEquip = value;
		}
		public function set btnSell(value:Button):void
		{
			this._btnSell = value;
		}
		public function set btnInlay(value:Button):void
		{
			this._btnInlay = value;
		}
		public function set btnCombine(value:Button):void
		{
			this._btnCombine = value;
		}
		public function set btnUse(value:Button):void
		{
			this._btnUse = value;
		}
		
		/** getter */
		public function get btnEquip():Button
		{
			return this._btnEquip;
		}
		public function get btnSell():Button
		{
			return this._btnSell;
		}
		public function get btnInlay():Button
		{
			return this._btnInlay;
		}
		public function get btnCombine():Button
		{
			return this._btnCombine
		}
		public function get btnUse():Button
		{
			return this._btnUse
		}
	}
}