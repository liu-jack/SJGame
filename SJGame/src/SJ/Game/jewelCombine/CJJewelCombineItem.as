package SJ.Game.jewelCombine
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfItemJewelProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_jewel_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.textures.Texture;

	/**
	 * 宝石合成显示面板的显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJJewelCombineItem extends CJItemTurnPageBase
	{
		/**宝石对象*/
		private var _item:CJBagItem;
		/**宝石选中框*/
		private var _imgSelect:Scale9Image;
		/**上次点击的宝石选中框*/
		private var _oldItemId:String;
		/**宝石名称*/
		private var _name:Label;
//		/**宝石等级*/
//		private var _level:Label;
//		/**宝石类型*/
//		private var _type:Label;
		/**宝石属性加成*/
		private var _property:Label;
		/**背包数据*/
		private var _bagData:CJDataOfBag;
		public function CJJewelCombineItem()
		{
			super("CJJewelCombineItem", true);
		}
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
		}
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			_bagData = CJDataManager.o.getData("CJDataOfBag");
			this.width = 137;
			this.height = 60;
			
			_item = new CJBagItem();
			_item.x = 5;
			_item.y = 5;
			
			_imgSelect = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_daojutubiaomiaobian02", 8,8,1,1);
			_imgSelect.x = 5;
			_imgSelect.y = 4;
			_imgSelect.width = 51;
			_imgSelect.height = 52;
			_imgSelect.visible = false;
			
			_name = new Label();
			_name.x = 58;
			_name.y = 14;
			_name.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x89FE3A);
			
//			_level = new Label();
//			_level.x = 57;
//			_level.y = 11;
//			_level.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x89FE3A);
			
//			_type = new Label();
//			_type.x = 58;
//			_type.y = 30;
//			_type.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xFEE44B);
			
			_property = new Label();
			_property.x = 58;
			_property.y = 30;
			_property.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xFEE44B);
			
		}
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			var textureBg:Texture = SApplication.assets.getTexture("common_liaotian_wenzidi");
			var bgScaleRange:Rectangle = new Rectangle(10, 10, 5, 5);
			var imgBg:Scale9Image = new Scale9Image(new Scale9Textures(textureBg, bgScaleRange));
			imgBg.width = this.width;
			imgBg.height = this.height;
//			imgBg.x = 3;
//			imgBg.y = 3;
			addChild(imgBg);
			
			addChild(_item);
			addChild(_imgSelect);
			addChild(_name);
//			addChild(_level);
//			addChild(_type);
			addChild(_property);
		}
		
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				var templateId:int = this.data.templateid;
				var templateItemSetting:Json_item_setting = CJDataOfItemProperty.o.getTemplate(templateId);
				var templateItemJewelConfig:Json_item_jewel_config = CJDataOfItemJewelProperty.o.getItemJewelConfigById(templateId);
				var itemPictrueName:String = templateItemSetting.picture;
			    //设置宝石图标
				_item.setBagGoodsItem(itemPictrueName);
				var dataItem:CJDataOfItem = this.data as CJDataOfItem;
				//设置背包中宝石个数
				var jewelNum:int = dataItem.count;
				_item.setBagGoodsCount(String(jewelNum));
				var itemName:String = CJLang(templateItemSetting.itemname);
				//设置背包中宝石的名称
				_name.text = itemName;
//				var quality:int = parseInt(templateItemSetting.quality);
//				CJJewelCombineUtil.o.setItemQuality(quality, _name);
				var itemLevel:int = parseInt(templateItemSetting.level);
//				//设置背包中宝石的级别
//				_level.text = itemLevel + CJLang("JEWEL_COMBINE_RESULT_LEVEL");
				//设置背包中宝石的类型
//				_type.text = CJLang(templateItemJewelConfig.type);
				var propertyValue:int = CJJewelCombineUtil.o.getJewelPropertyBySubtype(templateItemSetting.subtype, templateItemJewelConfig);
				//设置背包中宝石的属性加成值
				_property.text = CJLang(templateItemJewelConfig.type) + "  +" + propertyValue;
			}
		}
		/**
		 * 处理选中事件
		 * @param selectedIndex 单元的索引
		 * 
		 */
		override protected function onSelected():void
		{
			var selectJewelTmpl:int = this.data.templateid;
			var jewelNum:int = this.data.count;
			var templateItemSetting:Json_item_setting = CJDataOfItemProperty.o.getTemplate(selectJewelTmpl);
			var jewelLevel:int = templateItemSetting.level;
			if (jewelNum >= 2)
			{
				if (jewelLevel >= 12)
				{
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_ALREADY_MAX_LEVEL"));
				}
//				else
//				{
//					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_JEWEL_COMBINE_SHOW_INFO_CHANGED, false, {"jewelId":selectJewelTmpl, "selectJewelNum":jewelNum});
//				}
			}
			else
			{
				CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_MATERIAL_LACK"));
			}
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_JEWEL_COMBINE_SHOW_INFO_CHANGED, false, {"jewelId":selectJewelTmpl, "selectJewelNum":jewelNum});
		}
		
		override public function set isSelected(value:Boolean):void
		{
			if (value)
			{
				_imgSelect.visible = true;
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_JEWEL_COMBINE_SHOW_INFO_CHANGED, false, {"jewelId":data.templateid, "selectJewelNum":data.count});
			}
			else
			{
				_imgSelect.visible = false;
			}
		}
	}
}