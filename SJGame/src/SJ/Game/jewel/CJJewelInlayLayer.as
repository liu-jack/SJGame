package SJ.Game.jewel
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstJewel;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_jewel;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfEquipmentbar;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfInlayHero;
	import SJ.Game.data.CJDataOfInlayJewel;
	import SJ.Game.data.CJDataOfInlayPosition;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfItemEquipProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfOpenJewelHoleProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_open_jewel_hole;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.layer.CJMsgBoxSilverNotEnough;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 装备强化layer
	 * @author sangxu
	 * 
	 */	
	public class CJJewelInlayLayer extends SLayer
	{
		public function CJJewelInlayLayer()
		{
			super();
		}
		
		/** 装备图标组 */
		private var _vecEqp:Vector.<CJJewelEquip>;
		/** 装备宝石孔图标组 */
		private var _dicHole:Dictionary;
		
		/** 宝石滑动条 */
		private var _tpJewel:CJTurnPage;
		
		/** datas */
		/** 数据 - 武将 */
		private var _dataHeroList:CJDataOfHeroList;
		/** 数据 - 武将装备 */
//		private var _dataHeroEquip:CJDataOfHeroEquip;
		/** 数据 - 装备栏 */
		private var _dataEquip:CJDataOfEquipmentbar;
		/** 数据 - 角色 */
		private var _dataRole:CJDataOfRole;
		/** 数据 - 背包 */
		private var _dataBag:CJDataOfBag;
		/** 数据 - 镶嵌 */
		private var _dataInlay:CJDataOfInlayJewel;
		
		/** 是否有数据标志位 */
		private var _dataHeroListInit:Boolean = false;
//		private var _dataHeroEquipInit:Boolean = false;
		private var _dataEquipInit:Boolean = false;
		private var _dataRoleInit:Boolean = false;
		private var _dataBagInit:Boolean = false;
		private var _dataInlayInit:Boolean = false;
		/** 是否已初始化控件标志位 */
		private var _controlsInit:Boolean = false;
		
		/** 武将配置 */
		private var _heroConfig:CJDataOfHeroPropertyList;
		/** 道具配置 */
		private var _itemConfig:CJDataOfItemProperty;
		/** 道具装备配置 */
		private var _equipConfig:CJDataOfItemEquipProperty;
		/** 开孔配置表 */
		private var _openHoleConfig:CJDataOfOpenJewelHoleProperty;
		
		/** 当前武将数据 */
//		private var _curDataHero:CJDataOfHero;
		/** 当前武将装备 */
//		private var _curHeroEquip:Object;
		/** 当前选中装备 */
//		private var _curEquipId:String = "";
		/** 武将数组, 对_dataHeroList排序所得 */
		private var _heroArray:Array = new Array();
		/** 当前武将索引，在_heroArray中的索引 */
		private var _curHeroIndex:int = 0;
		
//		private var _inlayJewelId:String = "";
//		private var _removeJewelId:String = "";
		
		
		/** 武将头像层 */
		private var _layerHero:CJJewelInlayHeroLayer;
		
		/** 当前选中武将id */
		private var _curHeroId:String = "";
		/** 当前武将宝石镶嵌信息 */
		private var _curHeroInlayData:CJDataOfInlayHero;
		/** 当前装备位类型 */
		private var _curPosType:int = -1;
		/** 当前装备位镶嵌数据 */
		private var _curInlayPositionData:CJDataOfInlayPosition;
		
//		private var _tooltip:CJItemTooltip;
		
		/** 宝石镶嵌时临时存储宝石道具id */
		private var _jewelItemId:String = "";
		/** 宝石卸下时临时存储宝石道具id */
		private var _removeItemId:String = "";
		private var _removeIndex:int = -1;
		/** 开孔时临时存索引 */
		private var _openHoleIndex:int = -1;
		
		private var _img:ImageLoader;
		
		/** 弹出框按钮 - 镶嵌 */
		private var _btnXiangqian:Button;
		/** 弹出框按钮 - 卸下 */
		private var _btnXiexia:Button;
		
		/** 打开武将id */
		private var _openHeroId:String = "";
		
//		private var _LockKeyDrawEquip:String = "LockKeyDrawEquip";
//		private var _LockKeyDrawHero:String = "LockKeyDrawHero";
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initControls();
			
			this._initData();
			
//			this._initShow();
			this._initListener();
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			// 边框
//			var texture:Texture = SApplication.assets.getTexture("common_waibiankuang");
//			var bgScaleRange:Rectangle = new Rectangle(14, 14, 4, 4);
//			var bgTexture:Scale9Textures = new Scale9Textures(texture, bgScaleRange);
//			this._imgBiankuang = new Scale9Image(bgTexture);
//			this._imgBiankuang.width = this.width;
//			this._imgBiankuang.height = this.height;
//			this.addChildAt(this._imgBiankuang, 0);
			
			this.imgBg = new SImage(SApplication.assets.getTexture("baoshi_youcedi"));
			this.imgBg.x = 198;
			this.imgBg.y = 10;
			this.imgBg.width = 212;
			this.imgBg.height = 256;
			this.imgBg.scaleX = this.imgBg.scaleY = 2.6;
			this.addChildAt(this.imgBg, 0);
			
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
			
			var fontFormatEqp:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x7CF738, true, null, null, null, null, TextFormatAlign.CENTER);
			
			this._layerHero = new CJJewelInlayHeroLayer();
			this._layerHero.x = 9;
			this._layerHero.y = 10;
			this._layerHero.width = 65;
			this._layerHero.height = 256;
			this.addChild(this._layerHero);

			
			
			// 装备图标 - 武器
			this._jeWuqi = new CJJewelEquip(ConstItem.SCONST_ITEM_SUBTYPE_WEAPON, true);
			this._jeWuqi.x = 76;
			this._jeWuqi.y = 38;
			this._jeWuqi.width = ConstBag.BAG_ITEM_WIDTH;
			this._jeWuqi.height = ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(this._jeWuqi);
			
			// 装备图标 - 头盔
			this._jeToukui = new CJJewelEquip(ConstItem.SCONST_ITEM_SUBTYPE_HELMET);
			this._jeToukui.x = 134;
			this._jeToukui.y = 38;
			this._jeToukui.width = ConstBag.BAG_ITEM_WIDTH;
			this._jeToukui.height = ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(this._jeToukui);
			
			// 装备图标 - 披风
			this._jePifeng = new CJJewelEquip(ConstItem.SCONST_ITEM_SUBTYPE_CLOAK);
			this._jePifeng.x = 76;
			this._jePifeng.y = 110;
			this._jePifeng.width = ConstBag.BAG_ITEM_WIDTH;
			this._jePifeng.height = ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(this._jePifeng);
			
			// 装备图标 - 护甲
			this._jeHujia = new CJJewelEquip(ConstItem.SCONST_ITEM_SUBTYPE_ARMOUR);
			this._jeHujia.x = 134;
			this._jeHujia.y = 110;
			this._jeHujia.width = ConstBag.BAG_ITEM_WIDTH;
			this._jeHujia.height = ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(this._jeHujia);
			
			// 装备图标 - 鞋子
			this._jeXiezi = new CJJewelEquip(ConstItem.SCONST_ITEM_SUBTYPE_SHOES);
			this._jeXiezi.x = 76;
			this._jeXiezi.y = 182;
			this._jeXiezi.width = ConstBag.BAG_ITEM_WIDTH;
			this._jeXiezi.height = ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(this._jeXiezi);
			
			// 装备图标 - 腰带
			this._jeYaodai = new CJJewelEquip(ConstItem.SCONST_ITEM_SUBTYPE_BELT);
			this._jeYaodai.x = 134;
			this._jeYaodai.y = 182;
			this._jeYaodai.width = ConstBag.BAG_ITEM_WIDTH;
			this._jeYaodai.height = ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(this._jeYaodai);
			
			this._vecEqp = new Vector.<CJJewelEquip>;
			this._vecEqp.push(this._jeWuqi,
				this._jeToukui,
				this._jePifeng,
				this._jeHujia,
				this._jeXiezi,
				this._jeYaodai);
			
//			for each (var position:CJJewelEquip in this._vecEqp)
//			{
//				position.addEventListener(TouchEvent.TOUCH, _onClickPosition);
//			}
			
			this._jeWuqi.addEventListener(TouchEvent.TOUCH, _onClickEqpWuqi);
			this._jeToukui.addEventListener(TouchEvent.TOUCH, _onClickEqpToukui);
			this._jePifeng.addEventListener(TouchEvent.TOUCH, _onClickEqpPifeng);
			this._jeHujia.addEventListener(TouchEvent.TOUCH, _onClickEqpHujia);
			this._jeXiezi.addEventListener(TouchEvent.TOUCH, _onClickEqpXiezi);
			this._jeYaodai.addEventListener(TouchEvent.TOUCH, _onClickEqpYaodai);
			
			this.labEqpWuqi.text = CJLang("EQUIP_POSITION_WUQI");
			this.labEqpWuqi.textRendererProperties.textFormat = fontFormatEqp;
			this.labEqpToukui.text = CJLang("EQUIP_POSITION_TOUKUI");
			this.labEqpToukui.textRendererProperties.textFormat = fontFormatEqp;
			this.labEqpPifeng.text = CJLang("EQUIP_POSITION_PIFENG");
			this.labEqpPifeng.textRendererProperties.textFormat = fontFormatEqp;
			this.labEqpHujia.text = CJLang("EQUIP_POSITION_KAIJIA");
			this.labEqpHujia.textRendererProperties.textFormat = fontFormatEqp;
			this.labEqpXiezi.text = CJLang("EQUIP_POSITION_XIEZI");
			this.labEqpXiezi.textRendererProperties.textFormat = fontFormatEqp;
			this.labEqpYaodai.text = CJLang("EQUIP_POSITION_YAODAI");
			this.labEqpYaodai.textRendererProperties.textFormat = fontFormatEqp;
			
			// 宝石孔
			this._jhHole0 = new CJJewelHole(0);
			this._jhHole0.x = 222;
			this._jhHole0.y = 14;
			this._jhHole0.width = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
			this._jhHole0.height = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
			this.addChild(this._jhHole0);
			
			this._jhHole1 = new CJJewelHole(1);
			this._jhHole1.x = 328;
			this._jhHole1.y = 14;
			this._jhHole1.width = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
			this._jhHole1.height = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
			this.addChild(this._jhHole1);
			
			this._jhHole2 = new CJJewelHole(2);
			this._jhHole2.x = 196;
			this._jhHole2.y = 87;
			this._jhHole2.width = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
			this._jhHole2.height = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
			this.addChild(this._jhHole2);
			
			this._jhHole3 = new CJJewelHole(3);
			this._jhHole3.x = 356;
			this._jhHole3.y = 87;
			this._jhHole3.width = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
			this._jhHole3.height = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
			this.addChild(this._jhHole3);
			
			this._jhHole4 = new CJJewelHole(4);
			this._jhHole4.x = 222;
			this._jhHole4.y = 155;
			this._jhHole4.width = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
			this._jhHole4.height = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
			this.addChild(this._jhHole4);
			
			this._jhHole5 = new CJJewelHole(5);
			this._jhHole5.x = 328;
			this._jhHole5.y = 155;
			this._jhHole5.width = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
			this._jhHole5.height = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
			this.addChild(this._jhHole5);
			
			this._dicHole = new Dictionary();
			this._dicHole["0"] = this._jhHole0;
			this._dicHole["1"] = this._jhHole1;
			this._dicHole["2"] = this._jhHole2;
			this._dicHole["3"] = this._jhHole3;
			this._dicHole["4"] = this._jhHole4;
			this._dicHole["5"] = this._jhHole5;
			
//			for each (var hole:CJJewelHole in this._dicHole)
//			{
//				hole.addEventListener(TouchEvent.TOUCH, _onTouchHole);
//			}
			this._jhHole0.addEventListener(TouchEvent.TOUCH, _onClickHole0);
			this._jhHole1.addEventListener(TouchEvent.TOUCH, _onClickHole1);
			this._jhHole2.addEventListener(TouchEvent.TOUCH, _onClickHole2);
			this._jhHole3.addEventListener(TouchEvent.TOUCH, _onClickHole3);
			this._jhHole4.addEventListener(TouchEvent.TOUCH, _onClickHole4);
			this._jhHole5.addEventListener(TouchEvent.TOUCH, _onClickHole5);
			
			this._tpJewel = new CJTurnPage(3);
			this._tpJewel.setRect(174, 68);
			this._tpJewel.x = 216;
			this._tpJewel.y = 212;
			this._tpJewel.type = CJTurnPage.SCROLL_H;
			
			const listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
//			listLayout.gap = -1;
			this._tpJewel.layout = listLayout;
			
			_tpJewel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			_tpJewel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			_tpJewel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			_tpJewel.preButton.x = -3;
			_tpJewel.preButton.y = 20;
			_tpJewel.preButton.width = 14;
			_tpJewel.preButton.height = 28;
			_tpJewel.preButton.scaleX = -1;
			
			_tpJewel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			_tpJewel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			_tpJewel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			_tpJewel.nextButton.x = 175;
			_tpJewel.nextButton.y = 20;
			_tpJewel.nextButton.width = 14;
			_tpJewel.nextButton.height = 28;
			
//			this.btnJewelLeft.scaleX = -1;
//			this.btnJewelLeft.addEventListener(Event.TRIGGERED, this._onBtnClickJewelLeft);
//			this.btnJewelRight.addEventListener(Event.TRIGGERED, this._onBtnClickJewelRight);
			
			this.addChild(this._tpJewel);
			
			this._controlsInit = true;
			
			// 宝石孔中间装备图标
			_img = new ImageLoader;
			_img.source = SApplication.assets.getTexture("zhuzao_leixing_xuanzhong1");
			_img.x = 269;
			_img.y = 82;
			addChild(_img);
			
			
			// 分割线
			var imgLine:SImage;
//			var textureLine:Texture = SApplication.assets.getTexture("common_fengexian");
//			var lineTexture:Scale3Textures = new Scale3Textures(textureLine, textureLine.width/2-1, 1);
			imgLine = new SImage(SApplication.assets.getTexture("common_fengexian"));
			imgLine.x = 204;
			imgLine.y = 210;
			imgLine.width = 202;
			imgLine.height = 2;
			this.addChild(imgLine);
			
			imgLine = new SImage(SApplication.assets.getTexture("common_fengexian"));
			imgLine.x = 199;
			imgLine.y = 11;
			imgLine.width = 252;
			imgLine.height = 2;
			imgLine.rotation = Math.PI / 2;
//			imgLine.x += imgLine.width/2 + 5;
//			imgLine.y += imgLine.height/2;
			this.addChild(imgLine);
			
			
//			this.setChildIndex(this.imgBg, 1);
//			this.imgBg.y += 4;
//			this.imgBg.height -= 4;
//			this.imgBg.width += 2;
			
//			if (_openHeroId != "")
//			{
//				_curHeroId = _openHeroId;
////				this.onSelectHero(_openHeroId);
//				this._layerHero.selectHero(_openHeroId);
//			}
//			_openHeroId = "";
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
		 * 获取背包中宝石数据，用于滑动条显示
		 * @return 
		 * 
		 */
		private function _getJewelData():Array
		{
			var dataArray:Array = new Array();
			var jewelArray:Array = this._dataBag.getItemsByContainerType(ConstBag.BAG_TYPE_JEWEL);
			var itemTemplate:Json_item_setting;
			for each(var itemData:CJDataOfItem in jewelArray)
			{
				itemTemplate = this._itemConfig.getTemplate(itemData.templateid);
				var data:Object = {
					"itemid":itemData.itemid,
					"count":itemData.count,
					"picture":itemTemplate.picture,			
					"name":CJLang(itemTemplate.itemname),
					"level":itemTemplate.level
				}
				dataArray.unshift(data);
			}
			//从级高到级低，级别相同按照ID排
			dataArray.sort(_sortOnLevel);
			return dataArray;
		}
		
		private function _sortOnLevel(a: Object, b: Object): Number{
			if(parseInt(a["level"]) < parseInt(b["level"])){
				return 1;
			}
			else if (parseInt(a["level"]) > parseInt(b["level"])){
				return -1;
			}
			else {
				if(parseInt(a["itemid"]) > parseInt(b["itemid"])){
					return 1;
				}
				else if (parseInt(a["itemid"]) < parseInt(b["itemid"])){
					return -1;
				}
				else {
					return 0;
				}
			}
		}
		

		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 配置数据
			this._heroConfig = CJDataOfHeroPropertyList.o;
			this._itemConfig = CJDataOfItemProperty.o;
			this._equipConfig = CJDataOfItemEquipProperty.o;
			this._openHoleConfig = CJDataOfOpenJewelHoleProperty.o;
			
			// 服务器数据
			this._dataHeroList = CJDataManager.o.getData("CJDataOfHeroList") as CJDataOfHeroList;
//			this._dataHeroEquip = CJDataManager.o.getData("CJDataOfHeroEquip") as CJDataOfHeroEquip;
			this._dataEquip = CJDataManager.o.getData("CJDataOfEquipmentbar") as CJDataOfEquipmentbar;
			this._dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			this._dataBag = CJDataManager.o.getData("CJDataOfBag") as CJDataOfBag;
			this._dataInlay = CJDataManager.o.getData("CJDataOfInlayJewel") as CJDataOfInlayJewel;
			
			this._dataHeroList.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
//			this._dataHeroEquip.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataEquip.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataRole.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataBag.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataInlay.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			
			// 武将数据，武将列表
			if (this._dataHeroList.dataIsEmpty)
			{
				this._dataHeroList.loadFromRemote();
			}
			else
			{
				this._dataHeroListInit = true;
				this._onDataLoadedHeroList();
			}
			
			// 武将装备数据，左侧装备显示
//			if (this._dataHeroEquip.dataIsEmpty)
//			{
//				this._dataHeroEquip.loadFromRemote();
//			}
//			else
//			{
//				this._dataHeroEquipInit = true;
//			}
			
			// 装备栏数据，装备孔数据
			if (this._dataEquip.dataIsEmpty)
			{
//				SocketLockManager.KeyLock();
				this._dataEquip.loadFromRemote();
			}
			else
			{
				this._dataEquipInit = true;
			}
			
			// 角色数据，主将名
			if (this._dataRole.dataIsEmpty)
			{
				this._dataRole.loadFromRemote();
			}
			else
			{
				this._dataRoleInit = true;
			}
			
			// 背包数据，未镶嵌宝石
			if (this._dataBag.dataIsEmpty)
			{
				this._dataBag.loadFromRemote();
			}
			else
			{
				this._dataBagInit = true;
				this._setJewelData();
			}
			// 宝石镶嵌数据
			if (this._dataInlay.dataIsEmpty)
			{
				this._dataInlay.loadFromRemote();
			}
			else
			{
				this._dataInlayInit = true;
				this._setInlayJewelData();
			}
			
			this._redraw();
		}
		
		/**
		 * 接收到服务器端数据
		 * @param e
		 * 
		 */		
		private function _onDataLoaded(e:Event):void
		{
			if (e.target is CJDataOfHeroList)
			{
				this._dataHeroListInit = true;
				this._onDataLoadedHeroList();
			}
//			else if (e.target is CJDataOfHeroEquip)
//			{
//				this._dataHeroEquipInit = true;
//			}
			else if (e.target is CJDataOfEquipmentbar)
			{
				this._dataEquipInit = true;
				this._onReceiveDataEquip();
			}
			else if (e.target is CJDataOfRole)
			{
				this._dataRoleInit = true;
			}
			else if (e.target is CJDataOfBag)
			{
				this._dataBagInit = true;
				this._onReceiveDataBag();
			}
			else if (e.target is CJDataOfInlayJewel)
			{
				this._dataInlayInit = true;
				this._onReceiveDataInlay();
			}
			this._redraw();
		}
		
		/**
		 * 初始化监听器
		 * 
		 */		
		private function _initListener():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			
//			this._dataEquip.addEventListener(DataEvent.DataLoadedFromRemote, );
//			this._dataInlay.addEventListener(DataEvent.DataLoadedFromRemote, );
		}
		
		/**
		 * 接收到背包数据
		 * 
		 */		
		private function _onReceiveDataBag():void
		{
			this._setJewelData();
		}
		
		/**
		 * 接收到装备栏数据（孔信息）
		 * 
		 */		
		private function _onReceiveDataEquip():void
		{
			this._onReceiveDataEquipAndInlay();
		}
		/**
		 * 接收到镶嵌数据
		 * 
		 */		
		private function _onReceiveDataInlay():void
		{
			this._onReceiveDataEquipAndInlay();
		}
		
		/**
		 * 接收到孔内道具数据与镶嵌数据
		 * 
		 */		
		private function _onReceiveDataEquipAndInlay():void
		{
			if (true == this._dataEquipInit && true == this._dataInlayInit)
			{
				this._setInlayJewelData();
			}
		}
		
		private function _redraw():void
		{
			if (!(this._dataHeroListInit 
				&& this._dataEquipInit 
				&& this._dataRoleInit
				&& this._dataBagInit
				&& this._dataInlayInit
				&& this._controlsInit))
			{
				return;
			}
			
			if (this._openHeroId != "")
			{
				this.onSelectHero(_openHeroId);
				this._layerHero.selectHero(_openHeroId);
				_openHeroId = "";
				return;
			}
			
			if (this._curHeroId == "")
			{
				this._initHeroData();
				
				this._clickEqp(this._jeWuqi);
			}
		}
		
		private function _initHeroData():void
		{
			if (this._curHeroId == "")
			{
				this._onSelHero(this._layerHero.getFirstHeroid());
			}
		}
		
		/**
		 * 设置宝石数据
		 * 
		 */		
		private function _setJewelData():void
		{
			var groceryList:ListCollection = new ListCollection(this._getJewelData());
			this._tpJewel.dataProvider = groceryList;
//			this._tpJewel.invalidate();
			this._tpJewel.itemRendererFactory =  function _getRenderFatory():IListItemRenderer
			{
				const render:CJJewelItem = new CJJewelItem();
				render.owner = _tpJewel;
				return render;
			};
		}
		
		/**
		 * 设置宝石镶嵌数据
		 * 
		 */		
		private function _setInlayJewelData():void
		{
			if (this._curHeroId != "")
			{
				if (this._curPosType != -1)
				{
					this._onSelHero(this._curHeroId);
					this._onSelPosition(this._curPosType);
				}
			}
		}
		
		/**
		 * 已获取武将信息数据后
		 * 
		 */		
		private function _onDataLoadedHeroList():void
		{
			this._heroArray = new Array();
			for each(var dataHero:CJDataOfHero in this._dataHeroList.herolist)
			{
				this._heroArray.push(dataHero);
			}
			this._heroArray.sort(this._heroSort);
		}
		
		/**
		 * 武将排序
		 * 规则：主将 > 非主将; 高品质 > 低品质
		 * @param heroA
		 * @param heroB
		 * @return 
		 * 
		 */		
		private function _heroSort(heroA:CJDataOfHero, heroB:CJDataOfHero):int
		{
			if (heroA.isRole)
			{
				return -1;
			}
			if (heroB.isRole)
			{
				return 1;
			}
			var heroATmpl:CJDataHeroProperty = this._heroConfig.getProperty(heroA.templateid);
			var heroBTmpl:CJDataHeroProperty = this._heroConfig.getProperty(heroB.templateid);
			if (int(heroATmpl.quality) > int(heroBTmpl.quality))
			{
				return -1;
			}
			else if (int(heroATmpl.quality) < int(heroBTmpl.quality))
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_JEWEL_INLAYJEWEL)
			{
				if (msg.retcode == 0)
				{
					// 宝石镶嵌消息
					var retDataInlay:Object = msg.retparams;
					if (true == retDataInlay.result)
					{
						// 宝石镶嵌成功
						this._dataInlayInit = false;
						this._dataEquipInit = false;
						this._dataBagInit = false;
						
						SocketCommand_item.getBag();
						SocketCommand_item.get_equipmentbar();
						SocketCommand_jewel.getInlayInfo();
						
						this._jewelItemId = "";
//						if (this._tooltip != null)
//						{
//							this._tooltip.removeFromParent();
//							this._tooltip = null;
//						}
						// 活跃度
						CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_JEWELINLAY});
					}
					
					// 刷新武将总战斗力
					SocketCommand_hero.get_heros();
				}
			}
			else if(msg.getCommand() == ConstNetCommand.CS_JEWEL_REMOVEJEWEL)
			{
				if (msg.retcode == 0)
				{
					// 宝石摘取消息
					var retDataRemove:Object = msg.retparams;
					if (true == retDataRemove.result)
					{
						// 宝石摘取成功
						this._dataInlayInit = false;
						this._dataEquipInit = false;
						this._dataBagInit = false;
						
						SocketCommand_item.getBag();
						SocketCommand_item.get_equipmentbar();
						SocketCommand_jewel.getInlayInfo();
						
						this._removeItemId = "";
						this._removeIndex = -1;
//						if (this._tooltip != null)
//						{
//							this._tooltip.removeFromParent();
//							this._tooltip = null;
//						}
					}
					// 刷新武将总战斗力
					SocketCommand_hero.get_heros();
				}
				else if (msg.retcode == 2)
				{
					// 飘字 - 您的背包空间不足
					new CJTaskFlowString(CJLang("BAG_HAS_NOT_ENOUGH_GRID"), 1.8, 40).addToLayer();
				}
			}
			else if(msg.getCommand() == ConstNetCommand.CS_JEWEL_OPENJEWELINLAY)
			{
				if (msg.retcode == 0)
				{
					// 镶嵌开孔消息
					var retDataOpen:Object = msg.retparams;
					if (true == retDataOpen.result)
					{
						// 镶嵌开孔成功
						this._dataInlayInit = false;
						
//						SocketCommand_jewel.getInlayInfo();
						// 更新页面货币显示
						SocketCommand_role.get_role_info();
						
						var heroId:String = String(retDataOpen.heroid);
						var position:int = int(retDataOpen.position);
						var index:int = int(retDataOpen.index);
						
						var dataHeroInlay:CJDataOfInlayHero = _dataInlay.getHeroInlayInfo(heroId);
						var dataPositionInley:CJDataOfInlayPosition = dataHeroInlay.getInlayPosition(position);
						dataPositionInley.setHoleOpen(index);
						
						this._openHoleIndex = -1;
						
						if (int(retDataOpen.position) == _curPosType)
						{
							(this._dicHole[String(index)] as CJJewelHole).openHole();
						}
					}
				}
			}
		}
		
		
		/**
		 * 判断是否点击装备位
		 * @param event
		 * @param eqp
		 * @return 
		 * 
		 */		
		private function _checkClickEqp(event:TouchEvent, eqp:CJJewelEquip):Boolean
		{
			var touch:Touch = event.getTouch(eqp, TouchPhase.BEGAN);
			if (!touch)
			{
				return false;
			}
			return true;
		}
		
		
		/**
		 * 点击装备
		 * @param eqpClick
		 * 
		 */		
		private function _clickEqp(eqpClick:CJJewelEquip):void
		{
			if (!eqpClick.canSelect)
			{
				return;
			}
			
			// 添加网络锁
//			SocketLockManager.KeyLock(_LockKeyDrawEquip);
			
			this._onSelPosition(eqpClick.type);
			
			// 解除网络锁
//			SocketLockManager.KeyUnLock(_LockKeyDrawEquip);
		}
		
		private function _onClickEqpWuqi(event:TouchEvent):void
		{
			var touch:Boolean = this._checkClickEqp(event, this._jeWuqi);
			if (!touch)
			{
				return;
			}
			this._clickEqp(this._jeWuqi);
		}
		
		private function _onClickEqpToukui(event:TouchEvent):void
		{
			var touch:Boolean = this._checkClickEqp(event, this._jeToukui);
			if (!touch)
			{
				return;
			}
			this._clickEqp(this._jeToukui);
		}
		private function _onClickEqpPifeng(event:TouchEvent):void
		{
			var touch:Boolean = this._checkClickEqp(event, this._jePifeng);
			if (!touch)
			{
				return;
			}
			this._clickEqp(this._jePifeng);
		}
		private function _onClickEqpHujia(event:TouchEvent):void
		{
			var touch:Boolean = this._checkClickEqp(event, this._jeHujia);
			if (!touch)
			{
				return;
			}
			this._clickEqp(this._jeHujia);
		}
		private function _onClickEqpXiezi(event:TouchEvent):void
		{
			var touch:Boolean = this._checkClickEqp(event, this._jeXiezi);
			if (!touch)
			{
				return;
			}
			this._clickEqp(this._jeXiezi);
		}
		private function _onClickEqpYaodai(event:TouchEvent):void
		{
			var touch:Boolean = this._checkClickEqp(event, this._jeYaodai);
			if (!touch)
			{
				return;
			}
			this._clickEqp(this._jeYaodai);
		}
		
		/**
		 * 检验是否点击宝石孔
		 * @param event
		 * @param hole
		 * @return 
		 * 
		 */		
		private function _checkClickHole(event:TouchEvent, hole:CJJewelHole):Boolean
		{
			var touch:Touch = event.getTouch(hole, TouchPhase.BEGAN);
			if (!touch)
			{
				return false;
			}
			return true;
		}
		
		private function _onClickHole0(event:TouchEvent):void
		{
			var jhHole:CJJewelHole = this._jhHole0;
			var touch:Boolean = this._checkClickHole(event, jhHole);
			if (!touch)
			{
				return;
			}
			this._onClickHole(jhHole);
		}
		private function _onClickHole1(event:TouchEvent):void
		{
			var jhHole:CJJewelHole = this._jhHole1;
			var touch:Boolean = this._checkClickHole(event, jhHole);
			if (!touch)
			{
				return;
			}
			this._onClickHole(jhHole);
		}
		private function _onClickHole2(event:TouchEvent):void
		{
			var jhHole:CJJewelHole = this._jhHole2;
			var touch:Boolean = this._checkClickHole(event, jhHole);
			if (!touch)
			{
				return;
			}
			this._onClickHole(jhHole);
		}
		private function _onClickHole3(event:TouchEvent):void
		{
			var jhHole:CJJewelHole = this._jhHole3;
			var touch:Boolean = this._checkClickHole(event, jhHole);
			if (!touch)
			{
				return;
			}
			this._onClickHole(jhHole);
		}
		private function _onClickHole4(event:TouchEvent):void
		{
			var jhHole:CJJewelHole = this._jhHole4;
			var touch:Boolean = this._checkClickHole(event, jhHole);
			if (!touch)
			{
				return;
			}
			this._onClickHole(jhHole);
		}
		private function _onClickHole5(event:TouchEvent):void
		{
			var jhHole:CJJewelHole = this._jhHole5;
			var touch:Boolean = this._checkClickHole(event, jhHole);
			if (!touch)
			{
				return;
			}
			this._onClickHole(jhHole);
		}
		
		private function _onTouchHole(event:TouchEvent):void
		{
			for each (var hole:CJJewelHole in this._dicHole)
			{
				var touch:Touch = event.getTouch(hole, TouchPhase.BEGAN);
				if (!touch)
				{
					touch = event.getTouch(hole, TouchPhase.BEGAN);
					if (!touch)
					{
						continue;
					}
					
					_onClickHole(hole);
				}
			}
		}
		
		/**
		 * 
		 * @param hole
		 * 
		 */		
		private function _onClickHole(hole:CJJewelHole):void
		{
			if (hole.status == ConstBag.FrameCreateStateLocked)
			{
				// 锁
				this._openHoleIndex = hole.index;
				
				var vipLv:int = CJDataManager.o.DataOfRole.vipLevel;
				var vipCfg:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vipLv));
				if (int(vipCfg.jewel_openhole))
				{
					_onOpenHole();
					return;
				}

				
				var openIndex:int = this._curInlayPositionData.getOpenIndex();
				var openCfg:Json_open_jewel_hole = _openHoleConfig.getOpenProperty(openIndex);
				var lang:String = "";
				if (openCfg.costtype == ConstCurrency.CURRENCY_TYPE_SILVER)
				{
					var silver:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).silver;
					if (silver >= int(openCfg.costprice))
					{
						// 足够
						lang = CJLang("JEWEL_INLAY_OPENHOLE_CONFIRM");
						lang = lang.replace("{price}", openCfg.costprice);
						lang = lang.replace("{currency}", CJLang("CURRENCY_NAME_SILVER"));
						lang = lang.replace("{index}", String(this._openHoleIndex + 1));
						CJConfirmMessageBox(lang, this._onOpenHole);
					}
					else
					{
						lang = CJLang("JEWEL_INLAY_OPEN_MONEYNOTENOUGH");
						lang = lang.replace("{currency}", CJLang("CURRENCY_NAME_SILVER"));
//						CJMessageBox(lang);
						CJMsgBoxSilverNotEnough(lang, 
							"", 
							function():void{
								SApplication.moduleManager.exitModule("CJJewelModule");
							});
					}
				}
				else if (openCfg.costtype == ConstCurrency.CURRENCY_TYPE_GOLD)
				{
					var gold:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).gold;
					if (gold >= int(openCfg.costprice))
					{
						// 足够
						lang = CJLang("JEWEL_INLAY_OPENHOLE_CONFIRM");
						lang = lang.replace("{price}", openCfg.costprice);
						lang = lang.replace("{currency}", CJLang("CURRENCY_NAME_GOLD"));
						lang = lang.replace("{index}", String(this._openHoleIndex + 1));
						CJConfirmMessageBox(lang, this._onOpenHole);
					}
					else
					{
						lang = CJLang("JEWEL_INLAY_OPEN_MONEYNOTENOUGH");
						lang = lang.replace("{currency}", CJLang("CURRENCY_NAME_GOLD"));
						CJMessageBox(lang);
					}
				}
			}
			else if (hole.status == ConstBag.FrameCreateStateUnlock)
			{
				if (hole.itemId != "")
				{
					// 字体 - 按钮文字
					var fontFormatBtn:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE4C200,null,null,null,null,null, TextFormatAlign.CENTER );
					
					this._removeIndex = hole.index;
					this._removeItemId = hole.itemId;
					
					/** ------ tooltip start ------ */
					// 点击镶嵌孔弹出tooltip，此段注释保留，若点击宝石卸下仍需要弹出tooltip放开以下段注释
//					// 按钮 - 卸下
//					_btnXiexia = new Button();
//					_btnXiexia.x = 88;
//					_btnXiexia.width = 51;
//					_btnXiexia.height = 22;
//					_btnXiexia.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
//					_btnXiexia.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
//					_btnXiexia.defaultLabelProperties.textFormat = fontFormatBtn;
//					_btnXiexia.label = CJLang("JEWEL_INLAY_BTN_REMOVE");
//					_btnXiexia.addEventListener(starling.events.Event.TRIGGERED, this._removeJewel);
//					this._tooltip = new CJItemTooltip();
//					this._tooltip.setItemIdAndRefresh(ConstBag.CONTAINER_TYPE_HOLE, hole.itemId);
//					this._tooltip.addButton(_btnXiexia);
//					CJLayerManager.o.addModuleLayer(this._tooltip);
					/** ------ tooltip end ------ */
					
					SocketCommand_jewel.removejewel(this._curHeroId, this._curPosType, this._removeIndex);
				}
				else
				{
					// 空孔
					CJFlyWordsUtil(CJLang("JEWEL_INLAY_HOLE_EMPTY"));
				}
			}
		}
		/**
		 * 确认开孔
		 * @param event
		 * 
		 */		
		private function _onOpenHole():void
		{
			// 添加网络锁
//			SocketLockManager.KeyLock(ConstNetCommand.CS_JEWEL_OPENJEWELINLAY);
			
			SocketCommand_jewel.openJewelInlay(this._curHeroId, this._curPosType, this._openHoleIndex);
		}
		/**
		 * 卸下宝石
		 * @param event
		 * 
		 */		
		private function _removeJewel(event:Event):void
		{
			var jewelItem:CJDataOfItem = _dataEquip.getHoleItem(this._removeItemId);
			var canPutInBag:Boolean = CJItemUtil.canPutItemInBag(this._dataBag, jewelItem.templateid, 1);
			if (!canPutInBag)
			{
				CJMessageBox(CJLang("JEWEL_INLAY_ALERT_NOBAG"));
				return;
			}
			if (this._removeIndex >= 0)
			{
				// 添加网络锁
//				SocketLockManager.KeyLock(ConstNetCommand.CS_JEWEL_REMOVEJEWEL);
				
				SocketCommand_jewel.removejewel(this._curHeroId, this._curPosType, this._removeIndex);
			}
		}
		
//		/**
//		 * 按钮点击处理 - 宝石左
//		 * @param event
//		 * 
//		 */		
//		private function _onBtnClickJewelLeft(event:Event):void
//		{
//			this._tpJewel.prevPage();
//		}
//		/**
//		 * 按钮点击处理 - 宝石右
//		 * @param event
//		 * 
//		 */		
//		private function _onBtnClickJewelRight(event:Event):void
//		{
//			this._tpJewel.nextPage();
//		}
		
		/**
		 * 宝石镶嵌
		 * @param itemId	宝石道具id
		 * 
		 */		
		private function _inlayJewel(jewelItemId:String):void
		{
			if (this._curInlayPositionData == null)
			{
				// 未选中装备位
				return;
			}
			
			var emptyHoleIndex:int = this._curInlayPositionData.getFirstEmptyHoleIndex();

			if (emptyHoleIndex == -1)
			{
				// 没有可用的宝石孔！
				CJMessageBox(CJLang("JEWEL_INLAY_ALERT_NOHOLE"));
				return;
			}
			
			var jewelItem:CJDataOfItem = this._dataBag.getItemByItemId(jewelItemId);
			var jewelItemTmpl:Json_item_setting = this._itemConfig.getTemplate(jewelItem.templateid);
			
			// 已镶嵌的宝石
			var posJewelArray:Array = this._curInlayPositionData.getAllJewels();
			var holeJewelItemTmpl:Json_item_setting;
			var holeJewelItem:CJDataOfItem;
			var hasSameJewel:Boolean = false;
			for (var idx:int=0; idx < posJewelArray.length; idx++)
			{
				holeJewelItem = this._dataEquip.getHoleItem(posJewelArray[idx]);
				holeJewelItemTmpl = this._itemConfig.getTemplate(holeJewelItem.templateid);
				if (holeJewelItemTmpl.subtype == jewelItemTmpl.subtype)
				{
					hasSameJewel = true;
					break;
				}
			}
			if (hasSameJewel == true)
			{
				// 已镶有相同类型宝石
				CJMessageBox(CJLang("JEWEL_INLAY_ALERT_SAME"));
				return;
			}
			
			SocketCommand_jewel.inlayJewel(this._curHeroId, this._curPosType, emptyHoleIndex, jewelItemId);
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
			
			this._onSelHero(heroId);

			this._onSelPosition(ConstItem.SCONST_ITEM_POSITION_WEAPON);
		}
		
		/**
		 * 设置当前武将镶嵌数据
		 * 
		 */		
		private function _setCurHeroInlayData():void
		{
			this._curHeroInlayData = this._dataInlay.getHeroInlayInfo(this._curHeroId);
		}
		
		/**
		 * 选中装备位
		 * @param position
		 * 
		 */		
		private function _selPositionType(position:int):void
		{
			// 当前选中装备位类型
			this._curPosType = position;
			// 当前选中装备位镶嵌数据
			this._setInlayPositionData();
			switch(position)
			{
				case ConstItem.SCONST_ITEM_POSITION_ARMOR:
					_img.source = SApplication.assets.getTexture("baoshi_kuijia")
					break;
				case ConstItem.SCONST_ITEM_POSITION_SHOE:
					_img.source = SApplication.assets.getTexture("baoshi_xuezi")
					break;
				case ConstItem.SCONST_ITEM_POSITION_BELT:
					_img.source = SApplication.assets.getTexture("baoshi_yaodai")
					break;
				case ConstItem.SCONST_ITEM_POSITION_WEAPON:
					_img.source = SApplication.assets.getTexture("baoshi_wuqi")
					break;
				case ConstItem.SCONST_ITEM_POSITION_HEAD:
					_img.source = SApplication.assets.getTexture("baoshi_toukui")
					break;
				case ConstItem.SCONST_ITEM_POSITION_CLOAK:
					_img.source = SApplication.assets.getTexture("baoshi_pifeng")
					break;
			}
		}
		/**
		 * 当前选中装备位镶嵌数据
		 * 
		 */		
		private function _setInlayPositionData():void
		{
			if (_curHeroInlayData != null)
			{
				this._curInlayPositionData = this._curHeroInlayData.getInlayPosition(this._curPosType);
			}
		}
		
		/**
		 * 选中武将
		 * @param heroId
		 * 
		 */		
		private function _onSelHero(heroId:String):void
		{
			this._curHeroId = heroId;
			
			this._setCurHeroInlayData();
		}
		
		/**
		 * 选择装备位
		 * @param position
		 * 
		 */		
		private function _onSelPosition(position:int):void
		{
			for each (var eqpTemp:CJJewelEquip in this._vecEqp)
			{
				if (eqpTemp.type == position)
				{
					eqpTemp.select = true;
				}
				else
				{
					eqpTemp.select = false;
				}
			}
			
			this._selPositionType(position);
			
			for (var i:int = 0; i < 6; i++)
			{
				this._showHoleInfo(i, String(this._curInlayPositionData.getHoleItemId(String(i))));
			}
		}
		
		/**
		 * 显示装备位镶嵌孔信息
		 * @param index	孔索引
		 * @param value	孔在数据库中的值。[0:空; -1:锁; 其他:宝石道具id]
		 * 
		 */		
		private function _showHoleInfo(index:int, value:String):void
		{
			var hole:CJJewelHole = this._dicHole[String(index)];
			if (value == ConstBag.INLAY_HOLE_STATE_LOCK)
			{
				hole.status = ConstBag.FrameCreateStateLocked;
				hole.setHoleGoodsItem("");
				hole.clearItemName();
				hole.itemId = "";
			}
			else if (value == ConstBag.INLAY_HOLE_STATE_EMPTY)
			{
				hole.status = ConstBag.FrameCreateStateUnlock;
				hole.setHoleGoodsItem("");
				hole.clearItemName();
				hole.itemId = "";
			}
			else
			{
				hole.status = ConstBag.FrameCreateStateUnlock;
				var item:CJDataOfItem = this._dataEquip.getHoleItem(value);
				Assert(item != null, "_showSingleEquip item is null, itemId is:" + value);
				hole.itemId = value;
				hole.setHoleGoodsByTmplId(item.templateid);
			}
			hole.updateFrame();
		}
		
		/**
		 * 点击背包中宝石，弹出宝石tooltip
		 * @param jewelItemId	宝石道具id
		 * 
		 */		
		public function onSelectJewelItem(jewelItemId:String):void
		{
			// 字体 - 按钮文字
			var fontFormatBtn:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE4C200,null,null,null,null,null, TextFormatAlign.CENTER );
			
			this._jewelItemId = jewelItemId;
			
			
			/** ------ tooltip start ------ */
			// 点击宝石弹出tooltip，此段注释保留，若点击宝石仍需要弹出tooltip放开以下段注释
//			// 按钮 - 镶嵌 
//			_btnXiangqian = new Button();
//			_btnXiangqian.x = 88;
//			_btnXiangqian.width = 51;
//			_btnXiangqian.height = 22;
//			_btnXiangqian.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
//			_btnXiangqian.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
//			_btnXiangqian.defaultLabelProperties.textFormat = fontFormatBtn;
//			_btnXiangqian.label = CJLang("JEWEL_BTN_XIANGQIAN");
//			_btnXiangqian.addEventListener(Event.TRIGGERED, this._jewelInlay);
//			this._tooltip = new CJItemTooltip();
//			this._tooltip.setItemIdAndRefresh(ConstBag.CONTAINER_TYPE_BAG, jewelItemId);
//			this._tooltip.addButton(_btnXiangqian);
//			CJLayerManager.o.addModuleLayer(this._tooltip);
			/** ------ tooltip end ------ */
			
			this._inlayJewel(this._jewelItemId);
		}
		
		override public function dispose():void
		{
//			this.btnJewelLeft.removeEventListener(Event.TRIGGERED, this._onBtnClickJewelLeft);
//			this.btnJewelRight.removeEventListener(Event.TRIGGERED, this._onBtnClickJewelRight);
			
			this._jeWuqi.removeEventListener(TouchEvent.TOUCH, _onClickEqpWuqi);
			this._jeToukui.removeEventListener(TouchEvent.TOUCH, _onClickEqpToukui);
			this._jePifeng.removeEventListener(TouchEvent.TOUCH, _onClickEqpPifeng);
			this._jeHujia.removeEventListener(TouchEvent.TOUCH, _onClickEqpHujia);
			this._jeXiezi.removeEventListener(TouchEvent.TOUCH, _onClickEqpXiezi);
			this._jeYaodai.removeEventListener(TouchEvent.TOUCH, _onClickEqpYaodai);
			
			this._jhHole0.removeEventListener(TouchEvent.TOUCH, _onClickHole0);
			this._jhHole1.removeEventListener(TouchEvent.TOUCH, _onClickHole1);
			this._jhHole2.removeEventListener(TouchEvent.TOUCH, _onClickHole2);
			this._jhHole3.removeEventListener(TouchEvent.TOUCH, _onClickHole3);
			this._jhHole4.removeEventListener(TouchEvent.TOUCH, _onClickHole4);
			this._jhHole5.removeEventListener(TouchEvent.TOUCH, _onClickHole5);
			
			this._dataHeroList.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataEquip.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataRole.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataBag.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			this._dataInlay.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			
			if (_btnXiangqian != null)
			{
				_btnXiangqian.removeEventListener(Event.TRIGGERED, this._jewelInlay);
			}
			if (_btnXiexia != null)
			{
				_btnXiexia.removeEventListener(Event.TRIGGERED, _removeJewel);
			}
			this._layerHero.removeAllEventListener();
			super.dispose();
		}
		
		/**
		 * 宝石tooltip框，镶嵌按钮回调
		 * 
		 */		
		private function _jewelInlay():void
		{
			this._inlayJewel(this._jewelItemId);
		}
		
		/** controls */
		private var _imgBg:SImage;
		/** 按钮 - 宝石左 */
		private var _btnJewelLeft:Button;
		/** 按钮 - 宝石右 */
		private var _btnJewelRight:Button;
		
		/** 装备图标 - 武器 */
		private var _jeWuqi:CJJewelEquip;
		/** 装备图标 - 头盔 */
		private var _jeToukui:CJJewelEquip;
		/** 装备图标 - 披风 */
		private var _jePifeng:CJJewelEquip;
		/** 装备图标 - 护甲 */
		private var _jeHujia:CJJewelEquip;
		/** 装备图标 - 鞋子 */
		private var _jeXiezi:CJJewelEquip;
		/** 装备图标 - 腰带 */
		private var _jeYaodai:CJJewelEquip;
		
		/** 文字 - 武器 */
		private var _labEqpWuqi:Label;
		/** 文字 - 头盔 */
		private var _labEqpToukui:Label;
		/** 文字 - 披风 */
		private var _labEqpPifeng:Label;
		/** 文字 - 护甲 */
		private var _labEqpHujia:Label;
		/** 文字 - 鞋子 */
		private var _labEqpXiezi:Label;
		/** 文字 - 腰带 */
		private var _labEqpYaodai:Label;
		
		/** 装备孔 */
		private var _jhHole0:CJJewelHole;
		private var _jhHole1:CJJewelHole;
		private var _jhHole2:CJJewelHole;
		private var _jhHole3:CJJewelHole;
		private var _jhHole4:CJJewelHole;
		private var _jhHole5:CJJewelHole;
		
		/** setter */
		public function set imgBg(value:SImage):void
		{
			this._imgBg = value;
		}
		public function set btnJewelLeft(value:Button):void
		{
			this._btnJewelLeft = value;
		}
		public function set btnJewelRight(value:Button):void
		{
			this._btnJewelRight = value;
		}
		public function set labEqpWuqi(value:Label):void
		{
			this._labEqpWuqi = value;
		}
		public function set labEqpToukui(value:Label):void
		{
			this._labEqpToukui = value;
		}
		public function set labEqpPifeng(value:Label):void
		{
			this._labEqpPifeng = value;
		}
		public function set labEqpHujia(value:Label):void
		{
			this._labEqpHujia = value;
		}
		public function set labEqpXiezi(value:Label):void
		{
			this._labEqpXiezi = value;
		}
		public function set labEqpYaodai(value:Label):void
		{
			this._labEqpYaodai = value;
		}
		/** getter */
		public function get imgBg():SImage
		{
			return this._imgBg;
		}
		public function get btnJewelLeft():Button
		{
			return this._btnJewelLeft;
		}
		public function get btnJewelRight():Button
		{
			return this._btnJewelRight;
		}
		public function get labEqpWuqi():Label
		{
			return this._labEqpWuqi;
		}
		public function get labEqpToukui():Label
		{
			return this._labEqpToukui;
		}
		public function get labEqpPifeng():Label
		{
			return this._labEqpPifeng;
		}
		public function get labEqpHujia():Label
		{
			return this._labEqpHujia;
		}
		public function get labEqpXiezi():Label
		{
			return this._labEqpXiezi;
		}
		public function get labEqpYaodai():Label
		{
			return this._labEqpYaodai;
		}
	}
}