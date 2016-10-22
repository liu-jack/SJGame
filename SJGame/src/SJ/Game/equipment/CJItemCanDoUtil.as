package SJ.Game.equipment
{
	/**
	 * @author zhengzheng
	 * 创建时间：Apr 27, 2013 2:46:11 PM
	 * 计算能铸造装备个数的工具类
	 */
	public class CJItemCanDoUtil
	{
		/**拥有的材料个数*/		
		private var _itemOwn:int;
		/**需要的材料个数*/
		private var _itemNeed:int;
		/**需要的材料id*/
		private var _itemId:int;
		
		public function CJItemCanDoUtil()
		{
		}
		
		/**需要的材料模板id*/
		public function get itemId():int
		{
			return _itemId;
		}

		public function set itemId(value:int):void
		{
			_itemId = value;
		}

		public function get itemOwn():int
		{
			return _itemOwn;
		}

		public function set itemOwn(value:int):void
		{
			_itemOwn = value;
		}

		public function get itemNeed():int
		{
			return _itemNeed;
		}

		public function set itemNeed(value:int):void
		{
			_itemNeed = value;
		}
		/**
		 * 返回铸造某种装备所拥有材料个数与所需材料个数的比例
		 */		
		public function getItemCanDoNum():int
		{
			return _itemOwn / _itemNeed;
		}
		
	}
}