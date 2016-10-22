package SJ.Game.data
{
	import engine_starling.data.SDataBase;

	
	/**
	 * 装备强化配置单条数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfEnhanceEquipConfigSingle extends SDataBase
	{
		public function CJDataOfEnhanceEquipConfigSingle()
		{
			super("CJDataOfEnhanceEquipConfigSingle");
		}
		
		/**
		 * 对应json文件中数据的ID
		 */
		public function get id():uint
		{
			return getData( "id" );
		}

		/**
		 * @private
		 */
		public function set id(value:uint):void
		{
			setData("id", value);
		}
		
		/**
		 * 装备位
		 */
		public function get position():int
		{
			return getData( "position" );
		}

		/**
		 * 装备位
		 */
		public function set position(value:int):void
		{
			setData("position", value);
		}

		/**
		 * 等级
		 */
		public function get level():int
		{
			return getData( "level" );
		}

		/**
		 * 等级
		 */
		public function set level(value:int):void
		{
			setData("level", value);
		}
		
		/**
		 * 装备基础属性加成比率
		 */
		public function get addPropRate():int
		{
			return getData( "addproprate" );
		}

		/**
		 * 装备基础属性加成比率
		 */
		public function set addPropRate(value:int):void
		{
			setData("addproprate", value);
		}
		
		/**
		 * 消耗货币类型
		 */
		public function get costType():int
		{
			return getData( "costtype" );
		}

		/**
		 * 消耗货币类型
		 */
		public function set costType(value:int):void
		{
			setData("costtype", value);
		}
		
		/**
		 * 消耗货币数量
		 */
		public function get costPrice():int
		{
			return getData( "costprice" );
		}
		
		/**
		 * 消耗货币数量
		 */
		public function set costPrice(value:int):void
		{
			setData("costprice", value);
		}
		
		/**
		 * 成功基础概率
		 */
		public function get baseRate():int
		{
			return getData( "baserate" );
		}
		
		/**
		 * 成功基础概率
		 */
		public function set baseRate(value:int):void
		{
			setData("baserate", value);
		}

		
		/**
		 * 增加成功率货币类型
		 */
		public function get addCostType():int
		{
			return getData( "addcosttype" );
		}
		
		/**
		 * 增加成功率货币类型
		 */
		public function set addCostType(value:int):void
		{
			setData("addcosttype", value);
		}
		
		/**
		 * 增加成功率货币价格
		 */
		public function get addPrice():int
		{
			return getData( "addprice" );
		}
		
		/**
		 * 增加成功率货币价格
		 */
		public function set addPrice(value:int):void
		{
			setData("addprice", value);
		}
		
		
		
	}
}