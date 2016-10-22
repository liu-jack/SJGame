package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJBattleEffectUtil;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnhanceEquip;
	import SJ.Game.data.CJDataOfEnhanceHero;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.config.CJDataOfItemEquipProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.data.json.Json_item_equip_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.enhanceequip.CJEnhanceLayer;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.jewel.CJJewelLayer;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJHeroUIEquipTip extends SLayer
	{
		/** 宽度 **/
		private const _CONST_WIDTH_:int = 175;
		/** 最小高度 **/
		private const _CONST_MIN_HEIGHT_:int = 205;
		
		// 按钮宽高
		private static const ConstBtnWidth:int = 53;
		private static const ConstBtnHeight:int = 28;
		
		private static const ConstBtnOffsetX:int = 5;
		private static const ConstBtnOffsetY:int = 168;
		private static const ConstBtnGapX:int = 2;
		
		
		/** 特殊属性显示个数 **/
		private static const ConstSpecialCount:int = 4;
		
		/** itemIcon **/
		private var _bagItem:CJBagItem;
		/** 装备名 **/
		private var _itemname:Label;
		/** 战斗力 **/
		private var _fightvalue:Label;
		
		/** 需求等级 **/
		private var _level:Label;
		/** 需求职业 **/
		private var _job:Label;
		
		/** 基础属性 **/
		private var _base0:Label;
		/** 基础属性值 **/
		private var _baseValue0:Label;
		/** 基础属性提升 **/
		private var _baseValueUp0:Label;
		/** 基础属性 **/
		private var _base1:Label;
		/** 基础属性值 **/
		private var _baseValue1:Label;
		/** 基础属性提升 **/
		private var _baseValueUp1:Label;
		
//		/** 特殊属性 **/
//		private var _special0:Label;
//		/** 特殊属性 **/
//		private var _special1:Label;
//		/** 特殊属性 **/
//		private var _special2:Label;
//		/** 特殊属性 **/
//		private var _special3:Label;
////		/** 特殊属性 **/
////		private var _special4:Label;
		/** 特殊属性 **/
		private var _vecSpecialLabel:Vector.<Label>;
		/** 特殊属性数值 **/
		private var _vecSpecialValueLabel:Vector.<Label>;
		
		// 3个按钮
		private var _btnLeft:Button;
		private var _btnCenter:Button;
		private var _btnRight:Button;
		
		// 武将id
		private var _heroId:String;
		
		public function CJHeroUIEquipTip()
		{
			super();
			
			_doinit();
		}
		
		private function _doinit():void
		{
			var texture:Texture;
			var scale9Texture:Scale9Textures;
			var bg:Scale9Image;
			
			var tIndex:int = 0;
			
			// 底框
			bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi"), new Rectangle(19,19,1,1)));
			bg.width = _CONST_WIDTH_;
			bg.height = _CONST_MIN_HEIGHT_;
			addChild(bg);
			
			// 装备显示格
			_bagItem = new CJBagItem(ConstBag.FrameCreateStateUnlock);
			_bagItem.x = 9;
			_bagItem.y = 12;
			_bagItem.width = ConstBag.BAG_ITEM_WIDTH;
			_bagItem.height = ConstBag.BAG_ITEM_HEIGHT;
			addChild(_bagItem);
			
			// 道具名称
			_itemname = new Label;
			_itemname.x = 65;
			_itemname.y = 25;
			_itemname.width = 100;
			_itemname.height = 15;
			addChild(_itemname);
			// 战斗力
			_fightvalue = new Label;
			_fightvalue.x = 65;
			_fightvalue.y = 40;
			_fightvalue.width = 100;
			_fightvalue.height = 15;
			addChild(_fightvalue);
			_fightvalue.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			
			// 分割线
			var cutline:SImage = new SImage(SApplication.assets.getTexture("wujiang_fx01"));
			cutline.x = 5;
			cutline.y = 70;
			addChild(cutline);
			
			// 需求等级
			_level = new Label;
			_level.x = 10;
			_level.y = 80;
			_level.width = 150;
			_level.height = 12;
			addChild(_level);
			_level.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
			// 需求职业
			_job = new Label;
			_job.x = 93;
			_job.y = 80;
			_job.width = 150;
			_job.height = 12;
			addChild(_job);
			_job.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
			
			// 基础属性
			_base0 = new Label;
			_base0.x = _level.x;
			_base0.y = 95;
			_base0.width = 155;
			_base0.height = 12;
			addChild(_base0);
			_base0.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
			_baseValue0 = new Label;
			_baseValue0.x = _base0.x + 50;
			_baseValue0.y = _base0.y;
			_baseValue0.width = 155;
			_baseValue0.height = 12;
			addChild(_baseValue0);
			_baseValue0.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
			_baseValueUp0 = new Label;
			_baseValueUp0.x = _baseValue0.x + 50;
			_baseValueUp0.y = _base0.y;
			_baseValueUp0.width = 150;
			_baseValueUp0.height = 12;
			addChild(_baseValueUp0);
			_baseValueUp0.textRendererProperties.textFormat = ConstTextFormat.textformatgreen;
			
			_base1 = new Label;
			_base1.x = _level.x;
			_base1.y = 110;
			_base1.width = 155;
			_base1.height = 12;
			addChild(_base1);
			_base1.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
			_baseValue1 = new Label;
			_baseValue1.x = _base1.x + 50;
			_baseValue1.y = _base1.y;
			_baseValue1.width = 155;
			_baseValue1.height = 12;
			addChild(_baseValue1);
			_baseValue1.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
			_baseValueUp1 = new Label;
			_baseValueUp1.x = _baseValue1.x + 50;
			_baseValueUp1.y = _base1.y;
			_baseValueUp1.width = 150;
			_baseValueUp1.height = 12;
			addChild(_baseValueUp1);
			_baseValueUp1.textRendererProperties.textFormat = ConstTextFormat.textformatgreen;
			
			
			// 特殊属性Label
			_vecSpecialLabel = new Vector.<Label>;
			_vecSpecialValueLabel = new Vector.<Label>;
			var i:int = 0;
			// 
			var posLeftX:int = _level.x;
			var posRightX:int = _job.x;
			// Y初始坐标
			var posY:int = 125;
			// Y累增
			var addupY:int = 0;
			for (i=0; i<ConstSpecialCount; ++i)
			{
				// 前缀
				var perLabel:Label = new Label;
				perLabel.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
				addChild(perLabel);
				// 值
				var valueLabel:Label = new Label;
				valueLabel.textRendererProperties.textFormat = ConstTextFormat.textformatllblue;
				addChild(valueLabel);
				if (i%2 == 0) // 左侧的
				{
					perLabel.x = posLeftX;
					perLabel.y = posY + addupY;
					
					valueLabel.x = perLabel.x + 50;
					valueLabel.y = perLabel.y
				}
				else // 右侧的
				{
					perLabel.x = posRightX;
					perLabel.y = posY + addupY;
					addupY += 15;
					
					valueLabel.x = perLabel.x + 50;
					valueLabel.y = perLabel.y
				}
				
				// 添加
				_vecSpecialLabel.push(perLabel);
				_vecSpecialValueLabel.push(valueLabel);
			}
			
			var isOpen:Boolean = false;
			// 初始化三个按钮
			_btnLeft = new Button;
			_btnLeft.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			_btnLeft.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btnLeft.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_btnLeft.label = CJLang("ENHANCE_BTN_QIANGHUA");
			_btnLeft.x = ConstBtnOffsetX;
			_btnLeft.y = ConstBtnOffsetY;
			_btnLeft.width = ConstBtnWidth;
			_btnLeft.height = ConstBtnHeight;
			addChild(_btnLeft);
			_btnLeft.addEventListener(Event.TRIGGERED, function (e:Event):void{
				_EnterMoudle("CJEnhanceModule", "CJEnhanceModule_0", {"pagetype":CJEnhanceLayer.BTN_TYPE_QIANGHUA, "heroid":_heroId});
//				SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
//				SApplication.moduleManager.enterModule("CJEnhanceModule", {"pagetype":CJEnhanceLayer.BTN_TYPE_QIANGHUA});
			});
			_btnLeft.visible = CJDataManager.o.DataOfFuncList.isFunctionOpen("CJEnhanceModule_0");
			
			
			_btnCenter = new Button;
			_btnCenter.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			_btnCenter.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btnCenter.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_btnCenter.label = CJLang("ENHANCE_BTN_XILIAN");
			_btnCenter.x = _btnLeft.x + ConstBtnWidth + ConstBtnGapX;
			_btnCenter.y = ConstBtnOffsetY;
			_btnCenter.width = ConstBtnWidth;
			_btnCenter.height = ConstBtnHeight;
			addChild(_btnCenter);
			_btnCenter.addEventListener(Event.TRIGGERED, function (e:Event):void{
				_EnterMoudle("CJEnhanceModule", "CJEnhanceModule_2", {"pagetype":CJEnhanceLayer.BTN_TYPE_XILIAN, "heroid":_heroId});
//				SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
//				SApplication.moduleManager.enterModule("CJEnhanceModule", {"pagetype":CJEnhanceLayer.BTN_TYPE_XILIAN});
			});
			_btnCenter.visible = CJDataManager.o.DataOfFuncList.isFunctionOpen("CJEnhanceModule_2");
			var btnNeedOpenLevel:int = CJDataOfFuncPropertyList.o.getPropertyByModulename("CJEnhanceModule_2").level;
			_btnCenter.visible = int(CJDataManager.o.DataOfHeroList.getMainHero().level) < btnNeedOpenLevel ? false : true;
			
			_btnRight = new Button;
			_btnRight.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			_btnRight.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btnRight.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_btnRight.label = CJLang("BAG_BTN_NAME_JEWEL");
			_btnRight.x = _btnCenter.x + ConstBtnWidth + ConstBtnGapX;
			_btnRight.y = ConstBtnOffsetY;
			_btnRight.width = ConstBtnWidth;
			_btnRight.height = ConstBtnHeight;
			addChild(_btnRight);
			_btnRight.addEventListener(Event.TRIGGERED, function (e:Event):void{
				_EnterMoudle("CJJewelModule", "CJJewelModule", {"pagetype":CJJewelLayer.BTN_TYPE_XIANGQIAN, "heroid":_heroId});
//				SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
//				SApplication.moduleManager.enterModule("CJJewelModule");
			});
			_btnRight.visible = CJDataManager.o.DataOfFuncList.isFunctionOpen("CJJewelModule");
		}
		
		/**
		 * 更新显示
		 * @param itemid
		 */
		public function updateShow(heroid:String, itemid:String):void
		{
			_heroId = heroid;
			// 装备基础数据
			var itemInfo:CJDataOfItem;
			// 从背包中获取
			itemInfo = CJDataManager.o.DataOfBag.getItemByItemId(itemid);
			if (null == itemInfo)
				// 从装备栏中获取该道具信息
				itemInfo = CJDataManager.o.DataOfEquipmentbar.getEquipbarItem(itemid);
			
			// 没有找到相关信息
			if (null == itemInfo)
				return;
			
			// 道具模板信息
			var itemTemplate:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemInfo.templateid);
			if (null==itemTemplate)
				return;
			// 道具装备配置
			var itemEquipConfig:Json_item_equip_config = CJDataOfItemEquipProperty.o.getItemEquipConfigById(itemInfo.templateid);
			if (null==itemEquipConfig)
				return;
			
			// 显示道具图标
			_bagItem.setBagGoodsItemByTmpl(itemTemplate, true);
			
			// 道具名字
			_itemname.textRendererProperties.textFormat = ConstTextFormat.getFormatByQuality(int(itemTemplate.quality));
			_itemname.text = CJLang(itemTemplate.itemname);
			// 战斗力
			_fightvalue.text = CJLang("HERO_EQUIP_FIGHT") + CJBattleEffectUtil.getEquipValue(itemInfo);
			
			// 等级
			_level.text = CJLang("HERO_UI_NEED_LEVEL") + " " + itemTemplate.level;
			// 需要职业
			var strJob:String = CJLang("HERO_UI_NEED_JOB");
			var markjob:uint = itemTemplate.needoccupation;
			if (markjob == 15) // 全职业
			{
				strJob += CJLang("HERO_UI_JOB_ALL");
			}
			else // 单独判断4个职业
			{
				// 四个职业
				if ( (markjob & ConstHero.constHeroJobFighter) == ConstHero.constHeroJobFighter)
					strJob += CJLang("HERO_UI_JOB"+ConstHero.constHeroJobFighter) + " ";
				if ( (markjob & ConstHero.constHeroJobWizard) == ConstHero.constHeroJobWizard)
					strJob += CJLang("HERO_UI_JOB"+ConstHero.constHeroJobWizard) + " ";
				if ( (markjob & ConstHero.constHeroJobPastor) == ConstHero.constHeroJobPastor)
					strJob += CJLang("HERO_UI_JOB"+ConstHero.constHeroJobPastor) + " ";
				if ( (markjob & ConstHero.constHeroJobArcher) == ConstHero.constHeroJobArcher)
					strJob += CJLang("HERO_UI_JOB"+ConstHero.constHeroJobArcher) + " ";
			}
			// 职业说明
			_job.text = strJob;
			
			// 该函数应放在基础属性与特殊属性之前调用
			cleanText();
			
			var enhanceEquipData:CJDataOfEnhanceEquip = CJDataManager.o.getData("CJDataOfEnhanceEquip");
			var curHeroEnhanceData:CJDataOfEnhanceHero = enhanceEquipData.getHeroEnhanceInfo(heroid);
			var i:int = 0;
			var upStr:String;
			// 判断基础属性
			if (int(itemEquipConfig.shengmingadd) != 0)
			{
				upStr = formatBaseUp(itemTemplate.positiontype, curHeroEnhanceData);
				setBaseLabelText(i++, CJLang("HERO_UI_BASE_HP"), itemEquipConfig.shengmingadd, upStr);
			}
			if (int(itemEquipConfig.wugongadd) != 0)
			{
				upStr = formatBaseUp(itemTemplate.positiontype, curHeroEnhanceData);
				setBaseLabelText(i++, CJLang("HERO_UI_BASE_PATTACK"), itemEquipConfig.wugongadd, upStr);
			}
			if (int(itemEquipConfig.wufangadd) != 0)
			{
				upStr = formatBaseUp(itemTemplate.positiontype, curHeroEnhanceData);
				setBaseLabelText(i++, CJLang("HERO_UI_BASE_PDEF"), itemEquipConfig.wufangadd, upStr);
			}
			if (int(itemEquipConfig.fagongadd) != 0)
			{
				upStr = formatBaseUp(itemTemplate.positiontype, curHeroEnhanceData);
				setBaseLabelText(i++, CJLang("HERO_UI_BASE_MATTACK"), itemEquipConfig.fagongadd, upStr);
			}
			if (int(itemEquipConfig.fafangadd) != 0)
			{
				upStr = formatBaseUp(itemTemplate.positiontype, curHeroEnhanceData);
				setBaseLabelText(i++, CJLang("HERO_UI_BASE_MDEF"), itemEquipConfig.fafangadd, upStr);
			}
			
			
			i = 0;
			// 洗练属性
			if (int(itemInfo.addattrjin) != 0)
				setSpecialLabelText(i++, CJLang("JEWEL_TYPE_GOLD"), itemInfo.addattrjin);
			if (int(itemInfo.addattrmu) != 0)
				setSpecialLabelText(i++, CJLang("JEWEL_TYPE_WOOD"), itemInfo.addattrmu);
			if (int(itemInfo.addattrshui) != 0)
				setSpecialLabelText(i++, CJLang("JEWEL_TYPE_WATER"), itemInfo.addattrshui);
			if (int(itemInfo.addattrhuo) != 0)
				setSpecialLabelText(i++, CJLang("JEWEL_TYPE_FIRE"), itemInfo.addattrhuo);
			if (int(itemInfo.addattrtu) != 0)
				setSpecialLabelText(i++, CJLang("JEWEL_TYPE_EARTH"), itemInfo.addattrtu);
			
			if (int(itemInfo.addattrbaoji) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_CRIT"), itemInfo.addattrbaoji);
			if (int(itemInfo.addattrrenxing) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_TOUGHNESS"), itemInfo.addattrrenxing);
			if (int(itemInfo.addattrshanbi) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_DODGE"), itemInfo.addattrshanbi);
			if (int(itemInfo.addattrmingzhong) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_HIT"), itemInfo.addattrmingzhong);
			if (int(itemInfo.addattrzhiliao) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_CURE"), itemInfo.addattrzhiliao);
			if (int(itemInfo.addattrjianshang) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_REDUCEHURT"), itemInfo.addattrjianshang);
			if (int(itemInfo.addattrxixue) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_BLOOD"), itemInfo.addattrxixue);
			if (int(itemInfo.addattrshanghai) != 0)
				setSpecialLabelText(i++, CJLang("HERO_UI_INCHURT"), itemInfo.addattrshanghai);
		}
		
		/**
		 * 判断是否已开启功能
		 * @param moudleName		模块名
		 * @param judgeMoudleName	判断名
		 * @param param
		 * 
		 */
		private function _EnterMoudle(moudleName:String, judgeMoudleName:String, param:*=null):void
		{
			var isOpen:Boolean = CJDataManager.o.DataOfFuncList.isFunctionOpen(judgeMoudleName);
			if (!isOpen)
			{
				var funcCfg:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByModulename(judgeMoudleName);
				CJFlyWordsUtil(CJLang("ITEM_TOOLTIP_ALERT_LVLOW", {"level":String(funcCfg.level)}));
				return;
			}
			
			SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
			SApplication.moduleManager.enterModule(moudleName, param);
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_HERO_UI_CLOSE_EQUIP_TIP_LAYER);
		}
		
		/**
		 * 格式化基础属性增长文字
		 * @param posType				装备位置
		 * @param curHeroEnhanceData	强化信息
		 * @return 						"+20%"
		 * 
		 */
		private function formatBaseUp(posType:uint, curHeroEnhanceData:CJDataOfEnhanceHero):String
		{
			var enLvTemp:uint=0;
			if (null != curHeroEnhanceData)
			{
				switch (posType)
				{
					case ConstItem.SCONST_ITEM_POSITION_WEAPON:
						enLvTemp = curHeroEnhanceData.weapon;
						break;
					case ConstItem.SCONST_ITEM_POSITION_HEAD:
						enLvTemp = curHeroEnhanceData.head;
						break;
					case ConstItem.SCONST_ITEM_POSITION_CLOAK:
						enLvTemp = curHeroEnhanceData.cloak;
						break;
					case ConstItem.SCONST_ITEM_POSITION_ARMOR:
						enLvTemp = curHeroEnhanceData.armour;
						break;
					case ConstItem.SCONST_ITEM_POSITION_SHOE:
						enLvTemp = curHeroEnhanceData.shoe;
						break;
					case ConstItem.SCONST_ITEM_POSITION_BELT:
						enLvTemp = curHeroEnhanceData.belt;
						break;
					default :
						return "";
				}
			}
			
			var str:String = "+" + String(enLvTemp) + "%";
			return str;
		}
		
		/**
		 * 清除信息
		 */
		private function cleanText():void
		{
			_base0.text = "";
			_base1.text = "";
			_baseValueUp0.text = "";
			_baseValue0.text = "";
			_baseValue1.text = "";
			_baseValueUp1.text = "";
			
			// 特殊属性赋空
			for (var i:int=0; i<_vecSpecialLabel.length; ++i)
			{
				_vecSpecialLabel[i].text = "";
				_vecSpecialValueLabel[i].text = "";
			}
		}
		
		/**
		 * 设置基础属性值
		 * @param index      索引
		 * @param perStr     显示文字	"基础物攻"
		 * @param valueStr   显示文字	"465"
		 * @param valueStr   增长		"+20%"
		 */
		private function setBaseLabelText(index:int, perStr:String, valueStr:int, upStr:String):void
		{
			var perLabel:Label = this["_base"+index] as Label;
			var valueLabel:Label = this["_baseValue"+index] as Label;
			var upLabel:Label = this["_baseValueUp"+index] as Label;
			if (null == perLabel || null == valueLabel || null == upLabel)
				return;
			
			perLabel.text = perStr+":";
			valueLabel.text = String(valueStr);
			upLabel.text = upStr;
		}
		
		/**
		 * 设置特殊属性数值
		 * @param index		索引
		 * @param perStr	显示文字 "暴击"
		 * @param valueStr	显示文字 "476"
		 * 
		 */
		private function setSpecialLabelText(index:int, perStr:String, valueStr:int):void
		{
			if ( index >= _vecSpecialLabel.length||
			index >= _vecSpecialValueLabel.length)
				return;
			
			var perlabel:Label = _vecSpecialLabel[index];
			var valuelabel:Label = _vecSpecialValueLabel[index];
			if (null == perlabel || null == valuelabel)
				return;
			
			perlabel.text = perStr+":";
			valuelabel.text = String(valueStr);
		}
	}
}