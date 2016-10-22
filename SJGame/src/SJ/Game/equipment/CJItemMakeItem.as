package SJ.Game.equipment
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstItemMake;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import feathers.controls.Label;
	
	/**
	 * @author zhengzheng
	 * 创建时间：Apr 24, 2013 9:22:34 PM
	 * 可铸造装备子类型单元层
	 */
	public class CJItemMakeItem extends CJItemTurnPageBase
	{
		/**装备对象*/
		private var _item:CJBagItem;
		/**装备名称*/
		private var _name:Label;
		/**装备等级*/
		private var _level:Label;
		
		public function CJItemMakeItem()
		{
			super("CJItemMakeItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
		}
		
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			addChild(_item);
			addChild(_name);
			addChild(_level);
		}
		
		override protected function draw():void
		{
			super.draw();
			this.setSize(ConstItemMake.ITEM_MAKE_ITEM_MAKE_WIDTH,ConstItemMake.ITEM_MAKE_ITEM_MAKE_HEIGHT);
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				var _templateId:int = this.data.id;
				var template:Json_item_setting = CJDataOfItemProperty.o.getTemplate(_templateId);
				var itemPictrueName:String = template.picture;
				_item.setBagGoodsItem(itemPictrueName);
				var canDoCount:int = CJItemMakeUtil.o.getItemCanDoCount(parseInt(template.id));
				_item.setBagGoodsCount(canDoCount.toString());
				
				var itemName:String = CJLang(template.itemname);
				var itemLevel:int = parseInt(template.level);
				var quality:int = parseInt(template.quality);
				_name.text = itemName;
				CJItemMakeUtil.o.setItemQuality(quality,_name);
				_level.text = CJLang("ITEM_LEVEL") + itemLevel;
			}
		}
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			_item = new CJBagItem();
			_name = new Label();
			_name.x = ConstItemMake.ITEM_MAKE_ITEM_NAME_X;
			_name.y = ConstItemMake.ITEM_MAKE_ITEM_NAME_Y;
			_level = new Label();
			_level.x = ConstItemMake.ITEM_MAKE_ITEM_LEVEL_X;
			_level.y = ConstItemMake.ITEM_MAKE_ITEM_LEVEL_Y;
			_level.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xFFCF3B,null,null,null,null,null,TextFormatAlign.CENTER);
		}
		/**
		 * 处理选中事件
		 * @param selectedIndex 单元的索引
		 * 
		 */
		override protected function onSelected():void
		{
			this.owner.parent.dispatchEventWith(ConstItemMake.ITEM_MAKE_CHANGED, false, {"templateId":this.data.id});
		}
	}
}