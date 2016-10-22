package SJ.Game.bag
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJBattleEffectUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJTextFormatUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfEquipmentbar;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfItemEquipProperty;
	import SJ.Game.data.config.CJDataOfItemJewelProperty;
	import SJ.Game.data.config.CJDataOfItemPackageProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_equip_config;
	import SJ.Game.data.json.Json_item_jewel_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.jewelCombine.CJJewelCombineUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	import engine_starling.utils.SManufacturerUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.CObjectUtils;
	import lib.engine.utils.functions.Assert;
	
	import starling.textures.Texture;
	
	/**
	 * 道具tooltip层
	 * 需预先加载配置文件：
	 * 道具模板配置 : ConstResource.sResItemSetting
	 * 装备道具模板配置 : ConstResource.sResJsonItemEquipConfig
	 * 宝石道具模板配置 : ConstResource.sResJsonItemJewelConfig
	 * 战斗力系数配置 : ConstResource.sResBattleEffectSetting
	 * @author sangxu
	 * 
	 */	
	public class CJItemTooltipBase extends SLayer
	{
		
		public function CJItemTooltipBase()
		{
			super();
		}
		
		/** 道具id */
		protected var _itemId:String = "";
		/** 道具容器类型 */
		protected var _containerType:int = ConstBag.CONTAINER_TYPE_BAG;
		/** 道具数据 */
		protected var _itemData:CJDataOfItem;
		/** 道具模板 */
		protected var _itemTemplate:Json_item_setting;
		/** 装备模板 */
		protected var _equipTemplate:Json_item_equip_config;
		/** 宝石模板 */
		protected var _jewelTemplate:Json_item_jewel_config;
		/** 背包数据 */
		protected var _bagData:CJDataOfBag;
		/** 装备栏数据 */
		protected var _equipData:CJDataOfEquipmentbar;
		protected var _itemTemplateSetting:CJDataOfItemProperty;
		protected var _jewelTemplateProperty:CJDataOfItemJewelProperty;
		protected var _packageTemplateProperty:CJDataOfItemPackageProperty;
		
		/** 文字颜色 */
		/** 文字颜色 - 标题 */
		private const TEXT_COLOR_TITLE:Object = 0xFFFFCC;
		/** 文字颜色 - 内容 */
		private const TEXT_COLOR_CONTANT:Object = 0x97F2A1;
		/** 文字颜色 - 战斗力 */
		private const TEXT_COLOR_ZHANDOULI:Object = 0x4189FF;
		
		/** 文字大小 */
		private const TEXT_SIZE_NORMAL:int = 9;
		
		private const LABEL_HEIGHT_NORMAL:int = 10;
		
		private const LABEL_TITEL_INIT_X:int = 10;
		
		private const SIGN_ADD:String = "+";
		
		/** y坐标 */
		protected var currentY:int = 0;
		/** tooltip显示高度 */
		protected var bgHeight:int = 0;
		
		/** 字体 */
		/** 字体 - 道具名 */
		private const _tfName:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xCCB89B);
		/** 字体 - 标题 */
		private const _tfTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, TEXT_SIZE_NORMAL, TEXT_COLOR_TITLE);
		/** 字体 - 内容 */
		private const _tfCont:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, TEXT_SIZE_NORMAL, TEXT_COLOR_CONTANT);
		
		protected var _layerEquip:CJBagItem;
		
		protected var _infoLayer:SLayer;
		
		/** 是否有按钮 - 用于控制面板高度 */
		private var _hasButton:Boolean = false;
		private var _btnHeight:int = 0;
		
		/** tooltip类型，0:根据道具id; 1:根据道具模板id */
		private var _type:int = 0;
		
		/** tooltip类型 - 根据道具模板id */
		private static const TOOLTIP_TYPE_ITEMID:int = 0;
		/** tooltip类型 - 根据道具模板id */
		private static const TOOLTIP_TYPE_ITEMTEMPLATEID:int = 1;
		/** tooltip类型 - 根据其他人道具模板id */
		private static const TOOLTIP_TYPE_OTHERITEMID:int = 2;
		
		/** 其他人(好友)数据, 从服务器传来的数据  */
		private var _otherData:Object;
		
		/** 关闭回调 */
		private var _funcCloseCallback:Function;
		/** 是否显示出售价格 */
		private var _showSellPrice:Boolean = true;
		
		/** 按钮 */
		private var _arrayBtns:Array = new Array();
		/** 刷新是否使用当前按钮（不必再重新加载按钮，目前武将界面装备显示用） */
		private var _useCurBtns:Boolean = false;
		/** 最小高度 */
		private var _heightMin:int = 0;
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			if (this._type == TOOLTIP_TYPE_ITEMID)
			{
				this._initData();
			}
			else if (this._type == TOOLTIP_TYPE_ITEMTEMPLATEID)
			{
				this._initTemplateData(this._itemData.templateid);
			}
			else if (this._type == TOOLTIP_TYPE_OTHERITEMID)
			{
//				if (this._otherData != null)
//				{
//					this._initOtherItemData(this._otherData, );
//				}
			}
			
//			this._initControls();
			
			this._addListener();
		}
		
		private function _refreshItemInfo():void
		{
			this._initData();
			this._initControls();
		}
		
		
		/**
		 * 初始化数据
		 * 
		 */
		protected function _initData():void
		{
			this._bagData = CJDataManager.o.getData("CJDataOfBag");
			this._equipData = CJDataManager.o.getData("CJDataOfEquipmentbar");
			if (this.containerType == ConstBag.CONTAINER_TYPE_BAG)
			{
				this._itemData = this._bagData.getItemByItemId(this._itemId);
			}
			else if (this.containerType == ConstBag.CONTAINER_TYPE_EQUIP)
			{
				this._itemData = this._equipData.getEquipbarItem(this._itemId);
			}
			else if (this.containerType == ConstBag.CONTAINER_TYPE_HOLE)
			{
				this._itemData = this._equipData.getHoleItem(this._itemId);
			}
			Assert(this._itemData != null, "CJItemTooltip item data is null!!! Item id is:" + this._itemId + ", container type is:" + this.containerType);
			
			var templateId:int = this._itemData.templateid;
			this._itemTemplateSetting = CJDataOfItemProperty.o;
			this._jewelTemplateProperty = CJDataOfItemJewelProperty.o;
			this._packageTemplateProperty = CJDataOfItemPackageProperty.o;
			
			this._itemTemplate = this._itemTemplateSetting.getTemplate(templateId);
				
			if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_EQUIP)
			{
				var itemEquipProperty:CJDataOfItemEquipProperty = CJDataOfItemEquipProperty.o;
				this._equipTemplate = itemEquipProperty.getItemEquipConfigById(templateId);
			}
			else if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_JEWEL)
			{
				var itemJewelProperty:CJDataOfItemJewelProperty = CJDataOfItemJewelProperty.o;
				this._jewelTemplate = itemJewelProperty.getItemJewelConfigById(templateId);
			}
		}
		
		protected function _initControls():void
		{
//			this.x = 127;
//			this.y = 35;
			
			var labTemp:Label;
			var imgLine:Scale3Image;
			var imgTemp:SImage;
			var imgLineNew:SImage;
			
			this.bgHeight = 72;
			
			if (this._infoLayer == null)
			{
				this._infoLayer = new SLayer();
			}
			else
			{
				_infoLayer.removeChildren(0);
				this.currentY = 0;
				this.bgHeight = 70;
			}
			this._infoLayer.width = 226;
			
			// 道具图标
			if (this._layerEquip == null)
			{
				this._layerEquip = new CJBagItem(ConstBag.FrameCreateStateUnlock);
				this._layerEquip.x = 160;
				this._layerEquip.y = 8;
				this._layerEquip.width = 50;
				this._layerEquip.height = 50;
				this._infoLayer.addChild(_layerEquip);
			}
			this._layerEquip.setBagGoodsItem(this._itemTemplate.picture);
			
			// 文字 - 装备名
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfName);
			labTemp.textRendererProperties.textFormat.color = CJTextFormatUtil._getTextColor(parseInt(this._itemTemplate.quality));
			labTemp.text = CJLang(this._itemTemplate.itemname);
			labTemp.x = LABEL_TITEL_INIT_X;
			labTemp.y = this.currentY + 5;
			labTemp.width = 155;
			labTemp.height = 12;
			this._infoLayer.addChild(labTemp);
			
			// 分割线
			var textureLine:Texture = SApplication.assets.getTexture("common_fengexian");
			imgLineNew = new SImage(textureLine);
			imgLineNew.x = 18;
			imgLineNew.y = 62;
			imgLineNew.width = 138;
			imgLineNew.height = 2;
			this._infoLayer.addChild(imgLineNew);
			
			// 装备
			if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_EQUIP)
			{
				// 装备基本信息
				this._initEquipInfo();
				
				this.currentY += 63;
				
				// 装备基础属性 
				this._initEquipBaseProp();
				
				// 装备洗练属性
				this._initEquipXilianProp();
				
				// 镶嵌宝石孔属性
//				this._initEquipJewelProp();
			}
			// 道具
			else if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_USE)
			{
				// 礼包
				var subType:int = parseInt(this._itemTemplate.subtype)
				if (subType == ConstItem.SCONST_ITEM_SUBTYPE_USE_PACKAGE
					|| subType == ConstItem.SCONST_ITEM_SUBTYPE_USE_LVPACKAGE)
				{
					this._initPackageItemInfo();
				}
				this.currentY += 63;
			}
			else
			{
				this.currentY += 63;
			}
			
			// 宝石
			if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_JEWEL)
			{
				this._initJewelInfo();
			}
			
			this.addChild(this._infoLayer);
			
			// 功能描述
			this._initDescription();

			// 出售价格
			this._initSellPrice();
			
			// 增加按钮
			this.initButtons();
			
			
			// 背景
			if (_bgImage == null)
			{
				var texture:Texture = SApplication.assets.getTexture("common_tankuangdi");
				var bgScaleRange:Rectangle = new Rectangle(19,19,1,1);
				var bgTexture:Scale9Textures = new Scale9Textures(texture, bgScaleRange);
				this._bgImage = new Scale9Image(bgTexture);
				bgImage.width = 226;
//				bgImage.height = this.bgHeight;
				this._infoLayer.addChildAt(bgImage, 0);	//aaaaaaaaaaaaaa
			}
			this.bgImage.height = this.bgHeight;
			this._infoLayer.height = this.bgHeight;
			
			// 重新绘制高度
			_resetHeight();
			
			_refreshAllButtonY();
		}
		
		/**
		 * 重新绘制按钮
		 * 
		 */		
		protected function _refreshButtons():void
		{
			if (false == _useCurBtns)
			{
				// 不使用已有按钮
				_arrayBtns = null;
			}
			else
			{
				// 使用已有按钮
				for each (var btn:Button in _arrayBtns)
				{
					btn.y = 0;
					this._addButton(btn, false);
				}
			}
		}
		
		/**
		 * 添加监听事件
		 * 
		 */		
		protected function _addListener():void
		{
			
		}
		
		private function _initPackageItemInfo():void
		{
			var htmlLab:Label = new Label();
			htmlLab.textRendererFactory = _getPackageInfoRender;
			var tf:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, TEXT_SIZE_NORMAL);
			
//			htmlLab.textRendererProperties.wordWrap = true;
//			htmlLab.textRendererProperties.textFormat = tf;
			htmlLab.text = CJItemUtil.getPackageItemsDescHtml(this._itemTemplate.id);
			htmlLab.x = LABEL_TITEL_INIT_X;
			htmlLab.y = this.currentY + 20;
			htmlLab.width = 145;
			htmlLab.height = 90;
			
			htmlLab.textRendererProperties.wordWrap = true;
			if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_IOS)
			{
				// iOS
				htmlLab.textRendererProperties.textFormat = tf;
				htmlLab.textRendererProperties.wordWrap = true;
				htmlLab.textRendererFactory = textRender.htmlTextRender;
			}
			else
			{
				// 其他设备
				htmlLab.textRendererFactory = function():ITextRenderer
				{
					var tr:TextFieldTextRenderer = new TextFieldTextRenderer();
					tr.width = 170;
					tr.wordWrap = true;
					tr.maxWidth = 170;
					tr.isHTML = true;
					var tf:TextFormat = new TextFormat(); 
					tf.align = TextFormatAlign.LEFT;
					tf.color = 0xffffff;
					tf.size = TEXT_SIZE_NORMAL;
					tf.font = ConstTextFormat.FONT_FAMILY_HEITI;
					tr.textFormat = tf;
					return tr;
				};
			}
			this._infoLayer.addChild(htmlLab);
			
			
		}
		
		private function _getPackageInfoRender():ITextRenderer
		{
			var htmltextRender:TextFieldTextRendererEx;
			htmltextRender = new TextFieldTextRendererEx()
			htmltextRender.isHTML = true;
			return htmltextRender;
		}
		
		/**
		 * 装备基础信息
		 * 
		 */		
		private function _initEquipInfo():void
		{
			var labTemp:Label;
			
			// 文字 - 战斗力数字
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfName);
			labTemp.textRendererProperties.textFormat.color = TEXT_COLOR_ZHANDOULI;
			labTemp.text = String(this._getBattleEffectValue()) + CJLang("ITEM_TOOLTIP_ZHANDOULI");
			labTemp.x = LABEL_TITEL_INIT_X;
			labTemp.y = this.currentY + 20;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
			
			// 文字 - 战斗力
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfTitle;
//			labTemp.textRendererProperties.textFormat.color = TEXT_COLOR_ZHANDOULI;
//			labTemp.text = CJLang("ITEM_TOOLTIP_ZHANDOULI");
//			labTemp.x = 43;
//			labTemp.y = this.currentY + 24;
//			this.addChild(labTemp);
			
			// 文字 - 需要等级
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
			labTemp.text = CJLang("ITEM_TOOLTIP_NEEDLV");
			labTemp.x = LABEL_TITEL_INIT_X;
			labTemp.y = this.currentY + 38;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
			
			// 文字 - 需要等级数字
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = this._tfCont;
			labTemp.text = this._itemTemplate.level;
			labTemp.x = 49;
			labTemp.y = this.currentY + 38;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
			
			// 文字 - 需要职业
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
			labTemp.text = CJLang("ITEM_TOOLTIP_NEEDOCCUPATION");
			labTemp.x = LABEL_TITEL_INIT_X;
			labTemp.y = this.currentY + 49;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
			
			// 文字 - 需要职业内容
			var needJob:String = "";
			var needoccupation:int = parseInt(this._itemTemplate.needoccupation);
			if (needoccupation & ConstHero.constHeroJobFighter)
			{
				needJob += CJLang("JOB_NAME_1") + " ";
			}
			if (needoccupation & ConstHero.constHeroJobWizard)
			{
				needJob += CJLang("JOB_NAME_2") + " ";
			}
			if (needoccupation & ConstHero.constHeroJobPastor)
			{
				needJob += CJLang("JOB_NAME_4") + " ";
			}
			if (needoccupation & ConstHero.constHeroJobArcher)
			{
				needJob += CJLang("JOB_NAME_8") + " ";
			}
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = this._tfCont;
			labTemp.text = needJob;
			labTemp.x = 49;
			labTemp.y = this.currentY + 49;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
		}
		
		/**
		 * 装备基础属性
		 * @param elmArray
		 * 
		 */		
		private function _initEquipBaseProp():void
		{
			var labTemp:Label;
			var equipPropCount:int = 0;
			var posY:int = 0;
			if (parseInt(this._equipTemplate.shengmingadd) > 0)
			{
				// 文字 - 基础生命
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
				labTemp.text = CJLang("ITEM_TOOLTIP_JICHUSHENGMING");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 文字 - 基础生命内容
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfCont;
				labTemp.text = this._equipTemplate.shengmingadd;
				labTemp.x = 49;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				equipPropCount++;
				posY += 11;
			}
			if (parseInt(this._equipTemplate.wugongadd) > 0)
			{
				// 文字 - 基础物攻
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
				labTemp.text = CJLang("ITEM_TOOLTIP_JICHUWUGONG");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 文字 - 基础物攻内容
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfCont;
				labTemp.text = this._equipTemplate.wugongadd;
				labTemp.x = 49;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				equipPropCount++;
				posY += 11;
			}
			
			if (parseInt(this._equipTemplate.wufangadd) > 0)
			{
				// 文字 - 基础物防
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
				labTemp.text = CJLang("ITEM_TOOLTIP_JICHUWUFANG");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 文字 - 基础物攻内容
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfCont;
				labTemp.text = this._equipTemplate.wufangadd;
				labTemp.x = 49;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				equipPropCount++;
				posY += 11;
			}
			
			if (parseInt(this._equipTemplate.fagongadd) > 0)
			{
				// 文字 - 基础法攻
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
				labTemp.text = CJLang("ITEM_TOOLTIP_JICHUFAGONG");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 文字 - 基础法攻内容
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfCont;
				labTemp.text = this._equipTemplate.fagongadd;
				labTemp.x = 49;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				equipPropCount++;
				posY += 11;
			}
			
			if (parseInt(this._equipTemplate.fafangadd) > 0)
			{
				// 文字 - 基础法防
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
				labTemp.text = CJLang("ITEM_TOOLTIP_JICHUFAFANG");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 文字 - 基础法攻内容
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfCont;
				labTemp.text = this._equipTemplate.fafangadd;
				labTemp.x = 49;
				labTemp.y = this.currentY + posY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				equipPropCount++;
				posY += 11;
			}
			if (equipPropCount > 0)
			{
//				var textureLine:Texture = SApplication.assets.getTexture("common_fengexian");
//				var lineTexture:Scale3Textures = new Scale3Textures(textureLine, textureLine.width/2-1, 1);
//				var imgLine:Scale3Image = new Scale3Image(lineTexture);
//				imgLine.x = 18;
//				imgLine.y = this.currentY + posY;
//				imgLine.width = 205;
//				imgLine.height = 5;
//				this._infoLayer.addChild(imgLine);
				this._addLine(this.currentY + posY);
				
				posY += 5;
			}
			
			this.currentY += posY;
			this.bgHeight += posY;
		}
		
		/**
		 * 增加装备洗练属性
		 * @param elmArray
		 * 
		 */		
		private function _initEquipXilianProp():void
		{
			if (this._itemData.addattrjin > 0 
				|| this._itemData.addattrmu > 0
				|| this._itemData.addattrshui > 0
				|| this._itemData.addattrhuo > 0
				|| this._itemData.addattrtu > 0
				|| this._itemData.addattrbaoji > 0
				|| this._itemData.addattrrenxing > 0
				|| this._itemData.addattrshanbi > 0
				|| this._itemData.addattrmingzhong > 0
				|| this._itemData.addattrzhiliao > 0
				|| this._itemData.addattrjianshang > 0
				|| this._itemData.addattrxixue > 0
				|| this._itemData.addattrshanghai > 0)
			{
				// 文字 - 洗练属性
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
				labTemp.text = CJLang("ITEM_TOOLTIP_XILIANSHUXING");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
			}
			else
			{
				return;
			}
			
			var labTemp:Label;
			var posY:int = 11;
			var isLeft:Boolean = true;
			
			// 金
			if (this._itemData.addattrjin > 0)
			{
				// 文字 - 金
				_addXilianTitle(CJLang("PROP_TYPE_GOLD"), ConstTextFormat.TEXT_COLOR_WUXING_JIN, isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
//				labTemp.textRendererProperties.textFormat.color = ConstTextFormat.TEXT_COLOR_WUXING_JIN;
//				labTemp.text = CJLang("PROP_TYPE_GOLD");
//				labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				// 文字 - 金内容
				_addXilianCont(String(this._itemData.addattrjin), isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = this._tfCont;
//				labTemp.text = SIGN_ADD + String(this._itemData.addattrjin);
//				labTemp.x = 49 + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 木
			if (this._itemData.addattrmu > 0)
			{
				// 文字 - 木
				_addXilianTitle(CJLang("PROP_TYPE_WOOD"), ConstTextFormat.TEXT_COLOR_WUXING_MU, isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
//				labTemp.textRendererProperties.textFormat.color = ConstTextFormat.TEXT_COLOR_WUXING_MU;
//				labTemp.text = CJLang("PROP_TYPE_WOOD");
//				labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				// 文字 - 木内容
				_addXilianCont(String(this._itemData.addattrmu), isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = this._tfCont;
//				labTemp.text = SIGN_ADD + String(this._itemData.addattrmu);
//				labTemp.x = 49 + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 水
			if (this._itemData.addattrshui > 0)
			{
				// 文字 - 水
				_addXilianTitle(CJLang("PROP_TYPE_WATER"), ConstTextFormat.TEXT_COLOR_WUXING_SHUI, isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
//				labTemp.textRendererProperties.textFormat.color = ConstTextFormat.TEXT_COLOR_WUXING_SHUI;
//				labTemp.text = CJLang("PROP_TYPE_WATER");
//				labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				// 文字 - 水内容
				_addXilianCont(String(this._itemData.addattrshui), isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = this._tfCont;
//				labTemp.text = SIGN_ADD + String(this._itemData.addattrshui);
//				labTemp.x = 49 + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			// 火
			if (this._itemData.addattrhuo > 0)
			{
				// 文字 - 火
				_addXilianTitle(CJLang("PROP_TYPE_FIRE"), ConstTextFormat.TEXT_COLOR_WUXING_HUO, isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
//				labTemp.textRendererProperties.textFormat.color = ConstTextFormat.TEXT_COLOR_WUXING_HUO;
//				labTemp.text = CJLang("PROP_TYPE_FIRE");
//				labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				// 文字 - 火内容
				_addXilianCont(String(this._itemData.addattrhuo), isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = this._tfCont;
//				labTemp.text = SIGN_ADD + String(this._itemData.addattrhuo);
//				labTemp.x = 49 + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 土
			if (this._itemData.addattrtu > 0)
			{
				// 文字 - 土
				_addXilianTitle(CJLang("PROP_TYPE_EARTH"), ConstTextFormat.TEXT_COLOR_WUXING_TU, isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
//				labTemp.textRendererProperties.textFormat.color = ConstTextFormat.TEXT_COLOR_WUXING_TU;
//				labTemp.text = CJLang("PROP_TYPE_EARTH");
//				labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				// 文字 - 土内容
				_addXilianCont(String(this._itemData.addattrtu), isLeft, posY);
//				labTemp = new Label();
//				labTemp.textRendererProperties.textFormat = this._tfCont;
//				labTemp.text = SIGN_ADD + String(this._itemData.addattrtu);
//				labTemp.x = 49 + (isLeft? 0 : 100);
//				labTemp.y = this.currentY + posY;
//				labTemp.height = LABEL_HEIGHT_NORMAL;
//				labTemp.width = 100;
//				this._infoLayer.addChild(labTemp);
				
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 暴击
			if (this._itemData.addattrbaoji > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_CRIT"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrbaoji), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 韧性
			if (this._itemData.addattrrenxing > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_TOUGHNESS"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrrenxing), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 闪避
			if (this._itemData.addattrshanbi > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_DODGE"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrshanbi), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 命中
			if (this._itemData.addattrmingzhong > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_HIT"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrmingzhong), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 治疗
			if (this._itemData.addattrzhiliao > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_CURE"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrzhiliao), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 减伤
			if (this._itemData.addattrjianshang > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_REDUCEHURT"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrjianshang), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 吸血
			if (this._itemData.addattrxixue > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_BLOOD"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrxixue), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			// 伤害加深
			if (this._itemData.addattrshanghai > 0)
			{
				_addXilianTitle(CJLang("HERO_UI_INCHURT"), TEXT_COLOR_TITLE, isLeft, posY);
				_addXilianCont(String(this._itemData.addattrshanghai), isLeft, posY);
				if (false == isLeft)
				{
					posY += 11;
				}
				isLeft = !isLeft;
			}
			
			posY += (!isLeft ? 11 : 0);
			
			this._addLine(this.currentY + posY);
			
			posY += 5;
			this.currentY += posY;
			this.bgHeight += posY;
		}
		
		private function _addXilianTitle(text:String, color:Object, isLeft:Boolean, posY:int):void
		{
			var labTemp:Label = new Label();
			labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
			labTemp.textRendererProperties.textFormat.color = color;
			labTemp.text = text;
			labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
			labTemp.y = this.currentY + posY;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
		}
		
		private function _addXilianCont(text:String, isLeft:Boolean, posY:int):void
		{
			// 文字 - 内容
			var labTemp:Label = new Label();
			labTemp.textRendererProperties.textFormat = this._tfCont;
			labTemp.text = SIGN_ADD + text;
			labTemp.x = 49 + (isLeft? 0 : 100);
			labTemp.y = this.currentY + posY;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
		}
		
//		/**
//		 * 装备孔镶嵌宝石属性
//		 * 
//		 */		
//		private function _initEquipJewelProp():void
//		{
//			// 文字 - 洗练属性
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfTitle;
//			labTemp.text = CJLang("ITEM_TOOLTIP_JEWEL");
//			labTemp.x = LABEL_TITEL_INIT_X;
//			labTemp.y = this.currentY;
//			labTemp.height = LABEL_HEIGHT_NORMAL;
//			labTemp.width = 100;
//			this._infoLayer.addChild(labTemp);
//			
//			var labTemp:Label;
//			var posY:int = 11;
//			var isLeft:Boolean = true;
//			var jewelItemTmpl:Json_item_setting;
//			var jewelTmpl:Json_item_jewel_config;
//			
//			var itemData:CJDataOfItem;
//			
//			// 孔0
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfCont;
//			labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//			labTemp.y = this.currentY + posY;
//			labTemp.height = LABEL_HEIGHT_NORMAL;
//			labTemp.width = 100;
//			if (this._itemData.holeitemid0 != "0")
//			{
//				itemData = this._equipData.getHoleItem(this._itemData.holeitemid0);
//				Assert(itemData != null, "item tooltip hole0 jewel item is null, jewel itemid is:" + this._itemData.holeitemid0);
//				jewelItemTmpl = this._itemTemplateSetting.getTemplate(itemData.templateid);
//				jewelTmpl = this._jewelTemplateProperty.getItemJewelConfigById(itemData.templateid);
//				labTemp.text = CJLang(jewelItemTmpl.itemname) 
//							+ " "
//							+ CJLang(jewelTmpl.type)
//							+ " "
//							+ SIGN_ADD
//							+ CJJewelCombineUtil.o.getJewelPropertyBySubtype(parseInt(jewelItemTmpl.subtype), jewelTmpl);
//			}
//			else
//			{
//				labTemp.text = CJLang("ITEM_TOOLTIP_JEWEL_NONE");
//			}
//			this._infoLayer.addChild(labTemp);
//			if (false == isLeft)
//			{
//				posY += 11;
//			}
//			isLeft = !isLeft;
//			
//			
//			// 孔1
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfCont;
//			labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//			labTemp.y = this.currentY + posY;
//			labTemp.height = LABEL_HEIGHT_NORMAL;
//			labTemp.width = 100;
//			if (this._itemData.holeitemid1 != "0")
//			{
//				itemData = this._equipData.getHoleItem(this._itemData.holeitemid1);
//				Assert(itemData != null, "item tooltip hole0 jewel item is null, jewel itemid is:" + this._itemData.holeitemid1);
//				jewelItemTmpl = this._itemTemplateSetting.getTemplate(itemData.templateid);
//				jewelTmpl = this._jewelTemplateProperty.getItemJewelConfigById(itemData.templateid);
//				labTemp.text = CJLang(jewelItemTmpl.itemname) 
//							+ " "
//							+ CJLang(jewelTmpl.type)
//							+ " "
//							+ SIGN_ADD
//							+ CJJewelCombineUtil.o.getJewelPropertyBySubtype(parseInt(jewelItemTmpl.subtype), jewelTmpl);
//			}
//			else
//			{
//				labTemp.text = CJLang("ITEM_TOOLTIP_JEWEL_NONE");
//			}
//			this._infoLayer.addChild(labTemp);
//			if (false == isLeft)
//			{
//				posY += 11;
//			}
//			isLeft = !isLeft;
//			
//			// 孔2
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfCont;
//			labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//			labTemp.y = this.currentY + posY;
//			labTemp.height = LABEL_HEIGHT_NORMAL;
//			labTemp.width = 100;
//			if (this._itemData.holeitemid2 != "0")
//			{
//				itemData = this._equipData.getHoleItem(this._itemData.holeitemid2);
//				Assert(itemData != null, "item tooltip hole0 jewel item is null, jewel itemid is:" + this._itemData.holeitemid2);
//				jewelItemTmpl = this._itemTemplateSetting.getTemplate(itemData.templateid);
//				jewelTmpl = this._jewelTemplateProperty.getItemJewelConfigById(itemData.templateid);
//				labTemp.text = CJLang(jewelItemTmpl.itemname) 
//							+ " "
//							+ CJLang(jewelTmpl.type)
//							+ " "
//							+ SIGN_ADD
//							+ CJJewelCombineUtil.o.getJewelPropertyBySubtype(parseInt(jewelItemTmpl.subtype), jewelTmpl);
//			}
//			else
//			{
//				labTemp.text = CJLang("ITEM_TOOLTIP_JEWEL_NONE");
//			}
//			this._infoLayer.addChild(labTemp);
//			if (false == isLeft)
//			{
//				posY += 11;
//			}
//			isLeft = !isLeft;
//			
//			// 孔3
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfCont;
//			labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//			labTemp.y = this.currentY + posY;
//			labTemp.height = LABEL_HEIGHT_NORMAL;
//			labTemp.width = 100;
//			if (this._itemData.holeitemid3 != "0")
//			{
//				itemData = this._equipData.getHoleItem(this._itemData.holeitemid3);
//				Assert(itemData != null, "item tooltip hole0 jewel item is null, jewel itemid is:" + this._itemData.holeitemid3);
//				jewelItemTmpl = this._itemTemplateSetting.getTemplate(itemData.templateid);
//				jewelTmpl = this._jewelTemplateProperty.getItemJewelConfigById(itemData.templateid);
//				labTemp.text = CJLang(jewelItemTmpl.itemname) 
//							+ " "
//							+ CJLang(jewelTmpl.type)
//							+ " "
//							+ SIGN_ADD
//							+ CJJewelCombineUtil.o.getJewelPropertyBySubtype(parseInt(jewelItemTmpl.subtype), jewelTmpl);
//			}
//			else
//			{
//				labTemp.text = CJLang("ITEM_TOOLTIP_JEWEL_NONE");
//			}
//			this._infoLayer.addChild(labTemp);
//			if (false == isLeft)
//			{
//				posY += 11;
//			}
//			isLeft = !isLeft;
//			
//			// 孔4
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfCont;
//			labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//			labTemp.y = this.currentY + posY;
//			labTemp.height = LABEL_HEIGHT_NORMAL;
//			labTemp.width = 100;
//			if (this._itemData.holeitemid4 != "0")
//			{
//				itemData = this._equipData.getHoleItem(this._itemData.holeitemid4);
//				Assert(itemData != null, "item tooltip hole0 jewel item is null, jewel itemid is:" + this._itemData.holeitemid4);
//				jewelItemTmpl = this._itemTemplateSetting.getTemplate(itemData.templateid);
//				jewelTmpl = this._jewelTemplateProperty.getItemJewelConfigById(itemData.templateid);
//				labTemp.text = CJLang(jewelItemTmpl.itemname) 
//							+ " "
//							+ CJLang(jewelTmpl.type)
//							+ " "
//							+ SIGN_ADD
//							+ CJJewelCombineUtil.o.getJewelPropertyBySubtype(parseInt(jewelItemTmpl.subtype), jewelTmpl);
//			}
//			else
//			{
//				labTemp.text = CJLang("ITEM_TOOLTIP_JEWEL_NONE");
//			}
//			this._infoLayer.addChild(labTemp);
//			if (false == isLeft)
//			{
//				posY += 11;
//			}
//			isLeft = !isLeft;
//			
//			// 孔5
//			labTemp = new Label();
//			labTemp.textRendererProperties.textFormat = this._tfCont;
//			labTemp.x = LABEL_TITEL_INIT_X + (isLeft? 0 : 100);
//			labTemp.y = this.currentY + posY;
//			labTemp.height = LABEL_HEIGHT_NORMAL;
//			labTemp.width = 100;
//			if (this._itemData.holeitemid5 != "0")
//			{
//				itemData = this._equipData.getHoleItem(this._itemData.holeitemid5);
//				Assert(itemData != null, "item tooltip hole0 jewel item is null, jewel itemid is:" + this._itemData.holeitemid5);
//				jewelItemTmpl = this._itemTemplateSetting.getTemplate(itemData.templateid);
//				jewelTmpl = this._jewelTemplateProperty.getItemJewelConfigById(itemData.templateid);
//				labTemp.text = CJLang(jewelItemTmpl.itemname) 
//							+ " "
//							+ CJLang(jewelTmpl.type)
//							+ " "
//							+ SIGN_ADD
//							+ CJJewelCombineUtil.o.getJewelPropertyBySubtype(parseInt(jewelItemTmpl.subtype), jewelTmpl);
//			}
//			else
//			{
//				labTemp.text = CJLang("ITEM_TOOLTIP_JEWEL_NONE");
//			}
//			this._infoLayer.addChild(labTemp);
//			if (false == isLeft)
//			{
//				posY += 11;
//			}
//			isLeft = !isLeft;
//			
//			
//			posY += (!isLeft ? 11 : 0);
//			
//			this._addLine(this.currentY + posY);
//			
//			posY += 5;
//			this.currentY += posY;
//			this.bgHeight += posY;
//		}
		
		/**
		 * 增加宝石属性
		 * 
		 */		
		private function _initJewelInfo():void
		{
			var value:int = CJJewelCombineUtil.o.getJewelPropertyBySubtype(parseInt(this._itemTemplate.subtype), 
																			this._jewelTemplate);
			var labTemp:Label;
			var posY:int = 0;
			
			// 文字 - 属性
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = this._tfTitle;
			labTemp.text = CJLang("ITEM_TOOLTIP_JEWELPRO");
			labTemp.x = LABEL_TITEL_INIT_X;
			labTemp.y = this.currentY + posY;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
			
			posY += 11;
			
			// 文字 - 属性名
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = this._tfTitle;
			labTemp.text = CJLang(this._jewelTemplate.type);
			labTemp.x = LABEL_TITEL_INIT_X;
			labTemp.y = this.currentY + posY;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
			
			// 文字 - 属性值
			labTemp = new Label();
			labTemp.textRendererProperties.textFormat = this._tfCont;
			labTemp.text = SIGN_ADD + value;
			labTemp.x = 49;
			labTemp.y = this.currentY + posY;
			labTemp.height = LABEL_HEIGHT_NORMAL;
			labTemp.width = 100;
			this._infoLayer.addChild(labTemp);
			
			posY += 11;
			
			this._addLine(this.currentY + posY + 2);
			
			this.currentY += posY + 9;
			this.bgHeight += posY + 9;
		}
		
		/**
		 * 出售价格信息
		 * 
		 */		
		private function _initSellPrice():void
		{
			if (false == _showSellPrice)
			{
				return;
			}
			if (parseInt(this._itemTemplate.sellstate) == ConstItem.SCONST_ITEM_SELL_STATE_CAN)
			{
				this._addLine(this.currentY + 2, 205);
				
				this.currentY += 7;
				
				var labTemp:Label;
				// 可出售
				// 文字 - 出售价格
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfTitle;
				labTemp.text = CJLang("ITEM_TOOLTIP_SELL");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 文字 - 出售价格数字
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfCont;
				labTemp.text = this._itemTemplate.sellprice;
				labTemp.x = 50;
				labTemp.y = this.currentY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 图片 - 银两
				var imgTemp:SImage;
				if (ConstCurrency.CURRENCY_TYPE_SILVER == this._itemTemplate.selltype)
				{
					imgTemp = new SImage(SApplication.assets.getTexture("common_yinliang"));
				}
				else if (ConstCurrency.CURRENCY_TYPE_GOLD == this._itemTemplate.selltype)
				{
					imgTemp = new SImage(SApplication.assets.getTexture("common_yuanbao"));
				}
				if (imgTemp != null)
				{
					imgTemp.x = 85;
					imgTemp.y = currentY;
					imgTemp.width = 15;
					imgTemp.height = 11;
					this._infoLayer.addChild(imgTemp);
				}
				
				this.currentY += 15;
				this.bgHeight += 20;
			}
		}
		
		/**
		 * 增加功能描述
		 * 
		 */		
		private function _initDescription():void
		{
			var subType:int = parseInt(this._itemTemplate.subtype)
			if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_USE
				&& (subType == ConstItem.SCONST_ITEM_SUBTYPE_USE_PACKAGE
					|| subType == ConstItem.SCONST_ITEM_SUBTYPE_USE_LVPACKAGE))
			{
				// 文字 - 需要等级
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = CObjectUtils.clone(this._tfTitle);
				labTemp.text = CJLang("ITEM_TOOLTIP_NEEDLV");
				labTemp.x = LABEL_TITEL_INIT_X;
				labTemp.y = this.currentY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				// 文字 - 需要等级数字
				labTemp = new Label();
				labTemp.textRendererProperties.textFormat = this._tfCont;
				labTemp.text = this._itemTemplate.level;
				labTemp.x = 49;
				labTemp.y = this.currentY;
				labTemp.height = LABEL_HEIGHT_NORMAL;
				labTemp.width = 100;
				this._infoLayer.addChild(labTemp);
				
				this.currentY += LABEL_HEIGHT_NORMAL;
				this.bgHeight += LABEL_HEIGHT_NORMAL;
			}
			var showLine:int = 3;
			// 文字 - 功能描述
			var labTemp:Label = new Label();
			labTemp.textRendererProperties.textFormat = this._tfTitle;
			labTemp.text = CJLang("ITEM_TOOLTIP_DESC") + " " + CJLang(this._itemTemplate.description);
			labTemp.x = LABEL_TITEL_INIT_X;
			labTemp.y = this.currentY;
			labTemp.height = LABEL_HEIGHT_NORMAL * showLine;
			labTemp.width = 205;
			labTemp.textRendererProperties.wordWrap = true;
			this._infoLayer.addChild(labTemp);
			
			this.currentY += LABEL_HEIGHT_NORMAL * showLine + 2;
			this.bgHeight += LABEL_HEIGHT_NORMAL * showLine + 2;
			
		}
		
		/**
		 * 增加分割线，高度自动设置为5，x坐标自动设置为18
		 * @param y		y坐标
		 * @param width	宽度
		 * 
		 */		
		private function _addLine(y:int, width:int = 205):void
		{
			var textureLine:Texture = SApplication.assets.getTexture("common_fengexian");
//			var lineTexture:Scale3Textures = new Scale3Textures(textureLine, textureLine.width/2-1, 1);
//			var imgLine:Scale3Image = new Scale3Image(lineTexture);
			var imgLine:SImage = new SImage(textureLine);
			imgLine.x = 18;
			imgLine.y = y + 2;
			imgLine.width = width;
			imgLine.height = 2;
			this._infoLayer.addChild(imgLine);
		}
		
		/**
		 * 添加按钮
		 * 
		 */		
		protected function initButtons():void
		{
			this.currentY += 2;
			if (true == this._hasButton)
			{
				this.currentY += this._btnHeight;
				this.bgHeight += this._btnHeight;
			}
		}
		
		/**
		 * 增加多个按钮
		 * @param buttonArray	按钮数组
		 * 
		 */		
		public function addButtons(buttonArray:Array):void
		{
			for each (var button:Button in buttonArray)
			{
				this.addButton(button);
			}
		}
		
		/**
		 * 增加按钮, 若按钮宽高小于通用标准将设置为标准最小值, 最小值见ConstBag.BUTTON_WIDTH_MIN,ConstBag.BUTTON_WIDTH_MIN
		 * @param button	增加的按钮
		 * 
		 */		
		public function addButton(button:Button):void
		{
			if (button.width < ConstBag.BUTTON_WIDTH_MIN)
			{
				button.width = ConstBag.BUTTON_WIDTH_MIN;
			}
			if (button.height < ConstBag.BUTTON_HEIGHT_MIN)
			{
				button.height = ConstBag.BUTTON_HEIGHT_MIN;
			}
			_addButton(button, true);
		}
		
		/**
		 * 增加按钮
		 * @param button	按钮
		 * @param addToArray	是否加入array
		 * 
		 */		
		protected function _addButton(button:Button, addToArray:Boolean):void
		{
			if (false == this._hasButton)
			{
				this._hasButton = true;
			}
			this._infoLayer.addChild(button);	//aaaaaaaaaaaaa
			
			_resetButtonY(button);
			
			if (true == addToArray)
			{
				_arrayBtns.push(button);
			}
		}
		
		/**
		 * 刷新所有按钮y坐标
		 * 
		 */		
		private function _refreshAllButtonY():void
		{
			for each(var button:Button in _arrayBtns)
			{
				_resetButtonY(button);
			}
		}
		
		/**
		 * 获取按钮y坐标
		 * 
		 */		
		private function _resetButtonY(button:Button):void
		{
			if (0 == _heightMin)
			{
				// 未设置最小高度
				if (0 == button.y)
				{
					button.y = this.currentY;
				} 
				else
				{
					button.y = this.currentY - button.height;
				}
			}
			else
			{
				// 设置最小高度
				button.y = this.bgHeight - button.height - 11;
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			this.bgImage.height = this.bgHeight;
//			this.height = this.bgHeight;
		}
		
		/**
		 * 关闭tooltip
		 * 
		 */		
		public function closeToolTip(dispose:Boolean = true):void
		{
//			this.removeFromParent(dispose);
			_closeLayer(dispose);
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeAllEventListener();
		}
		
		/**
		 * 设置当前道具所属容器类型
		 * @param value
		 * 
		 */		
		public function set containerType(value:int):void
		{
			this._containerType = value;
		}
		
		public function get containerType():int
		{
			return this._containerType;
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
		
		public function set itemId(value:String):void
		{
			this._itemId = value;
		}
		
		/**
		 * 设置道具id显示tooltip
		 * @param containerType	容器类型
		 * @param itemId	道具唯一id
		 * 
		 */		
		public function setItemIdAndRefresh(containerType:int, itemId:String, useCurBtns:Boolean = false):void
		{
			this._type = TOOLTIP_TYPE_ITEMID;
			this.containerType = containerType;
			this.itemId = itemId;
			this._useCurBtns = useCurBtns;
			this._refreshItemInfo();
		}
		
		/**
		 * 设置道具模板id显示tooltip
		 * @param itemTemplateId	道具模板id
		 * 
		 */
		public function setItemTemplateIdAndRefresh(itemTemplateId:int):void
		{
			this._type = TOOLTIP_TYPE_ITEMTEMPLATEID;
			this._initTemplateData(itemTemplateId);
			this._initControls();
		}
		
		/**
		 * 设置其他人(好友)数据显示道具tooltips
		 * @param objData	从服务器获取的好友数据
		 * @param itemId	道具唯一id
		 * 
		 */		
		public function setOtherItemDataAndRefresh(data:Object, itemId:String):void
		{
			this._type = TOOLTIP_TYPE_OTHERITEMID;
			this._initOtherItemData(data, itemId);
			this._initControls();
		}
		
		/**
		 * 重新设置高度
		 * 
		 */		
		private function _resetHeight():void
		{
			if (this.bgHeight < _heightMin)
			{
				this.bgHeight = _heightMin;
				
				bgImage.height = this.bgHeight;
				this._infoLayer.height = this.bgHeight;
			}
		}
		
		/**
		 * 初始化其他人(好友)数据
		 * @param objData	从服务器获取的好友数据
		 * @param itemId	道具唯一id
		 * 
		 */		
		private function _initOtherItemData(objData:Object, itemId:String):void
		{
			this._otherData = objData;
			var objEquip:Object = objData.equipmentbar;
			var equipItemData:Object = objEquip[itemId];
			this._itemData = _getCJItemDataByFriendData(equipItemData);
			
//			Assert(this._itemData != null, "CJItemTooltip item data is null!!! Item id is:" + this._itemId + ", container type is:" + this.containerType);
			
			var templateId:int = this._itemData.templateid;
			this._itemTemplateSetting = CJDataOfItemProperty.o;
			this._jewelTemplateProperty = CJDataOfItemJewelProperty.o;
			
			this._itemTemplate = this._itemTemplateSetting.getTemplate(templateId);
			
			if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_EQUIP)
			{
				var itemEquipProperty:CJDataOfItemEquipProperty = CJDataOfItemEquipProperty.o;
				this._equipTemplate = itemEquipProperty.getItemEquipConfigById(templateId);
			}
			else if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_JEWEL)
			{
				var itemJewelProperty:CJDataOfItemJewelProperty = CJDataOfItemJewelProperty.o;
				this._jewelTemplate = itemJewelProperty.getItemJewelConfigById(templateId);
			}
		}
		
		/**
		 * 根据好友装备数据生成CJDataOfItem
		 * @param obj
		 * @return 
		 * 
		 */		
		private static function _getCJItemDataByFriendData(obj:Object):CJDataOfItem
		{
			var itemData:CJDataOfItem = new CJDataOfItem();
			itemData.itemid = obj.itemid;
			itemData.templateid = int(obj.templateid);
			itemData.count = int(obj.count);
			itemData.containertype = int(obj.containertype);
			itemData.addattrjin = int(obj.addattrjin);
			itemData.addattrmu = int(obj.addattrmu);
			itemData.addattrshui = int(obj.addattrshui);
			itemData.addattrhuo = int(obj.addattrhuo);
			itemData.addattrtu = int(obj.addattrtu);
			
			return itemData;
		}
		
		private function _initTemplateData(itemTemplateId:int):void
		{
			this._itemData = new CJDataOfItem();
			this._itemData.templateid = itemTemplateId;
			
			this._itemTemplateSetting = CJDataOfItemProperty.o;
			
			this._itemTemplate = this._itemTemplateSetting.getTemplate(itemTemplateId);
			
			if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_EQUIP)
			{
				var itemEquipProperty:CJDataOfItemEquipProperty = CJDataOfItemEquipProperty.o;
				this._equipTemplate = itemEquipProperty.getItemEquipConfigById(itemTemplateId);
			}
			else if (parseInt(this._itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_JEWEL)
			{
				this._jewelTemplateProperty = CJDataOfItemJewelProperty.o;
				this._jewelTemplate = this._jewelTemplateProperty.getItemJewelConfigById(itemTemplateId);
			}
		}
		
		private function _getBattleEffectValue():int
		{
			var value:int = 0;
			if (this._type == TOOLTIP_TYPE_ITEMID || this._type == TOOLTIP_TYPE_OTHERITEMID)
			{
				value = CJBattleEffectUtil.getEquipValue(this._itemData);
			}
			else if (this._type == TOOLTIP_TYPE_ITEMTEMPLATEID)
			{
				value = CJBattleEffectUtil.getEquipTemplateValue(this._itemData.templateid);
			}
			return value;
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		protected function removeAllEventListener():void
		{
			
		}
		
		/**
		 * 设置界面最小高度，如果当前高度小于设置高度则设置当前界面高度为所设置的高度
		 * @param heightMin	最小高度值
		 * 
		 */		
		public function setHeightMin(heightMin:int):void
		{
			this._heightMin = heightMin;
			if (this.bgImage.height < heightMin)
			{
				this.bgImage.height = heightMin;
			}
		}
		
		/**
		 * 关闭
		 * 
		 */		
		private function _closeLayer(dispose:Boolean = false):void
		{
			CJLayerManager.o.removeFromLayerFadeout(this);
			if (_funcCloseCallback != null)
			{
				_funcCloseCallback();
			}
		}
		
		/**
		 * 设置关闭回调方法
		 * @param func	回调方法
		 * 
		 */		
		public function setCloseFunction(func:Function):void
		{
			_funcCloseCallback = func;
		}
		
		/**
		 * 设置是否显示出售价格
		 * @param show	是否显示出售价格
		 * 
		 */		
		public function setShowSellPrice(show:Boolean):void
		{
			_showSellPrice = show;
		}
		
		/**
		 * 背景图片
		 */		
		private var _bgImage : Scale9Image;
		

		/**
		 * 控件 getter
		 */
		public function get bgImage():Scale9Image
		{
			return this._bgImage;
		}
		
		/**
		 * 控件setter
		 */
	}
}