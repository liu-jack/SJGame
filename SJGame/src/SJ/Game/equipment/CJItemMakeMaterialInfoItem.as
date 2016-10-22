package SJ.Game.equipment
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstItemMake;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.TouchEvent;

	/**
	 * 铸造显示层显示材料信息单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJItemMakeMaterialInfoItem extends SLayer
	{
		/**材料对象*/
		private var _item:CJBagItem;
		/**材料名称*/
		private var _name:Label;
		/**材料ID*/
		private var _materialId:int;
		
		public function CJItemMakeMaterialInfoItem()
		{
			super();
		}
		
		/**材料ID*/
		public function get materialId():int
		{
			return _materialId;
		}

		public function set materialId(value:int):void
		{
			_materialId = value;
			draw();
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
		 */		
		private function _initData():void
		{
			_item = new CJBagItem();
			_name = new Label();
			_name.width = ConstItemMake.ITEM_MAKE_SHOW_MATERIAL_NAME_WIDTH;
			_name.y = ConstItemMake.ITEM_MAKE_SHOW_MATERIAL_NAME_Y;
		}
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			addChild(_item);
			addChild(_name);
		}
		
		/**
		 * 添加事件监听 
		 * 
		 */		
		private function _addListeners():void
		{
			//监听触摸事件
			this.addEventListener(TouchEvent.TOUCH , _triggered);
		}	
		/**
		 * 触发监听函数
		 * @param e TouchEvent
		 * 
		 */		
		private function _triggered(e:TouchEvent):void
		{
			
		}
		override protected function draw():void
		{
			super.draw();
			if (_materialId > 0)
			{
				var template:Json_item_setting = CJDataOfItemProperty.o.getTemplate(_materialId);
				var itemPictrueName:String = template.picture;
				_item.setBagGoodsItem(itemPictrueName);
				var itemName:String = CJLang(template.itemname);
				var quality:int = parseInt(template.quality);
				_name.text = itemName;
				CJItemMakeUtil.o.setItemQuality(quality,_name);
			}
		}
	}
}