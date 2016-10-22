package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 商城物品数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfMallItem extends SDataBase
	{
		public function CJDataOfMallItem()
		{
			super("CJDataOfMallItem");
		}
		
		/**
		 * 加载数据
		 * @param obj
		 * 
		 */		
		public function loadData(obj:Object):void
		{
			for(var prop:String in obj)
			{
				this.setData(prop, obj[prop]);
			}
		}
		
		/** getter */
		/**
		 * 商城道具唯一id
		 * @return 
		 * 
		 */		
		public function get id():int
		{
			return getData("id");
		}
		/**
		 * 道具模板id
		 * @return 
		 * 
		 */
		public function get itemid():uint
		{
			return getData("itemid");
		}
		/**
		 * 商城类型
		 * @return 
		 * 
		 */
		public function get type():uint
		{
			return getData("type");
		}
		/**
		 * 货币类型
		 * @return 
		 * 
		 */
		public function get pricetype():uint
		{
			return getData("pricetype");
		}
		/**
		 * 货币数量
		 * @return 
		 * 
		 */
		public function get price():uint
		{
			return getData("price");
		}
		/**
		 * 是否推荐
		 * @return 
		 * 
		 */
		public function get isrecommend():Boolean
		{
			return getData("isrecommend");
		}
		/**
		 * 是否限时
		 * @return 
		 * 
		 */
		public function get islimittime():Boolean
		{
			return getData("islimittime");
		}
		/**
		 * 限时起始时间
		 * @return 
		 * 
		 */
		public function get limittimstart():uint
		{
			return getData("limittimstart");
		}
		/**
		 * 限时截止时间
		 * @return 
		 * 
		 */
		public function get limittimeend():uint
		{
			return getData("limittimeend");
		}
		/**
		 * 是否全服限制数量
		 * @return 
		 * 
		 */
		public function get islimitcount():Boolean
		{
			return getData("islimitcount");
		}
		/**
		 * 是否全服限制数量
		 * @return 
		 * 
		 */
		public function get limintcount():uint
		{
			return getData("limintcount");
		}
		/**
		 * 是否打折
		 * @return 
		 * 
		 */
		public function get isdiscount():Boolean
		{
			return getData("isdiscount");
		}
		/**
		 * 折扣率，10000为全款100%'
		 * @return 
		 * 
		 */
		public function get discount():uint
		{
			return getData("discount");
		}

		/** setter */
		/**
		 * 商城道具唯一id
		 * @param value
		 */
		public function set id(value:int):void
		{
			setData("id", value);
		}
		/**
		 * 道具模板id
		 * @param value
		 */
		public function set itemid(value:uint):void
		{
			setData("itemid", value);
		}
		/**
		 * 商城类型
		 * @param value
		 */
		public function set type(value:uint):void
		{
			setData("type", value);
		}
		/**
		 * 货币类型
		 * @param value
		 */
		public function set pricetype(value:uint):void
		{
			setData("pricetype", value);
		}
		/**
		 * 货币数量
		 * @param value
		 */
		public function set price(value:uint):void
		{
			setData("price", value);
		}
		/**
		 * 是否推荐
		 * @param value
		 */
		public function set isrecommend(value:Boolean):void
		{
			setData("isrecommend", value);
		}
		/**
		 * 是否限时
		 * @param value
		 */
		public function set islimittime(value:Boolean):void
		{
			setData("islimittime", value);
		}
		/**
		 * 限时起始时间
		 * @param value
		 */
		public function set limittimstart(value:uint):void
		{
			setData("limittimstart", value);
		}
		/**
		 * 限时截止时间
		 * @param value
		 */
		public function set limittimeend(value:uint):void
		{
			setData("limittimeend", value);
		}
		/**
		 * 是否全服限制数量
		 * @param value
		 */
		public function set islimitcount(value:Boolean):void
		{
			setData("islimitcount", value);
		}
		/**
		 * 限制数量 - 当前数量
		 * @param value
		 */
		public function set limintcount(value:uint):void
		{
			setData("limintcount", value);
		}
		/**
		 * 是否打折
		 * @param value
		 */
		public function set isdiscount(value:Boolean):void
		{
			setData("isdiscount", value);
		}
		/**
		 * 折扣率，10000为全款100%
		 * @param value
		 */
		public function set discount(value:uint):void
		{
			setData("discount", value);
		}
	}
}