package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 道具容器扩充配置数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfBagExpand extends SDataBase
	{
		public function CJDataOfBagExpand()
		{
			super("CJDataOfBagExpand");
		}
		
		/** getter */
		/**
		 * 对应json文件中固有数据的ID
		 */
		public function get id():uint
		{
			return getData("id");
		}
		/**
		 * 容器类型
		 */
		public function get containerType():uint
		{
			return getData("containerType");
		}
		/**
		 * 扩容格索引数
		 */
		public function get number():uint
		{
			return getData("number");
		}
		/**
		 * 花费货币类型
		 */
		public function get costType():uint
		{
			return getData("costType");
		}
		/**
		 * 话费货币数量
		 */
		public function get costPrice():uint
		{
			return getData("costPrice");
		}
		
		

		/** setter */
		/**
		 * @private
		 */
		public function set id(value:uint):void
		{
			setData("id", value);
		}
		/**
		 * @private
		 */
		public function set containerType(value:uint):void
		{
			setData("containerType", value);
		}
		/**
		 * @private
		 */
		public function set number(value:uint):void
		{
			setData("number", value);
		}
		/**
		 * @private
		 */
		public function set costType(value:uint):void
		{
			setData("costType", value);
		}
		/**
		 * @private
		 */
		public function set costPrice(value:uint):void
		{
			setData("costPrice", value);
		}
	}
}