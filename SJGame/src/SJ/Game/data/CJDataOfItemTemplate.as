package SJ.Game.data
{
	import engine_starling.data.SDataBase;

//	/**
//	 * 全部道具模板数据
//	 * @author sangxu
//	 * 
//	 */
//	public class CJDataOfAllItemTemplate extends SDataBase
//	{
//		public function CJDataOfItemTemplate(dataBasename:String)
//		{
//			super(dataBasename);
//		}
//		
//		/**
//		 * 获取道具模板
//		 */
//		public function get template(templateId : int) : CJDataOfItemTemplate
//		{
//			return this.getData(templateId);
//		}
//		
//		/**
//		 * 设置道具模板
//		 */
//		public function set template(template : CJDataOfItemTemplate) : void
//		{
//			this.setData(template.templateID, template);
//		}
//
//	}
	
	/**
	 * 道具模板数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfItemTemplate extends SDataBase
	{
		public function CJDataOfItemTemplate()
		{
			super("CJDataOfItemTemplate");
		}
		
		/**
		 * 对应json文件中固有数据的ID
		 */
		public function get templateID():uint
		{
			return getData( "templateID" );
		}

		/**
		 * @private
		 */
		public function set templateID(value:uint):void
		{
			setData("templateID", value);
		}
		
		/**
		 * 道具类型
		 */
		public function get type():int
		{
			return getData( "type" );
		}

		/**
		 * 道具类型
		 */
		public function set type(type:int):void
		{
			setData("type", type);
		}

		/**
		 * 道具子类型
		 */
		public function get subType():int
		{
			return getData( "subtype" );
		}

		/**
		 * 道具子类型
		 */
		public function set subType(type:int):void
		{
			setData("subtype", type);
		}
		
		/**
		 * 道具名
		 */
		public function get itemName():String
		{
			return getData( "itemname" );
		}

		/**
		 * 道具名
		 */
		public function set itemName(itemName:String):void
		{
			setData("itemname", itemName);
		}
		
		/**
		 * 道具描述
		 */
		public function get description():String
		{
			return getData( "description" );
		}

		/**
		 * 道具描述
		 */
		public function set description(description:String):void
		{
			setData("description", description);
		}
		
		/**
		 * 道具等级
		 */
		public function get level():int
		{
			return getData( "level" );
		}
		
		/**
		 * 道具等级
		 */
		public function set level(value:int):void
		{
			setData("level", value);
		}
		
		/**
		 * 道具品质
		 */
		public function get quality():int
		{
			return getData( "quality" );
		}
		
		/**
		 * 道具品质
		 */
		public function set quality(value:int):void
		{
			setData("quality", value);
		}

		
		/**
		 * 道具需求性别
		 */
		public function get needgender():int
		{
			return getData( "needgender" );
		}
		
		/**
		 * 道具需求性别
		 */
		public function set needgender(value:int):void
		{
			setData("needgender", value);
		}
		
		/**
		 * 道具需求职业
		 */
		public function get needoccupation():int
		{
			return getData( "needoccupation" );
		}
		
		/**
		 * 道具需求职业
		 */
		public function set needoccupation(value:int):void
		{
			setData("needoccupation", value);
		}
		
		/**
		 * 道具叠加上限
		 */
		public function get maxcount():int
		{
			return getData( "maxcount" );
		}
		
		/**
		 * 道具叠加上限
		 */
		public function set maxcount(value:int):void
		{
			setData("maxcount", value);
		}
		
		/**
		 * 道具使用次数
		 */
		public function get usenumber():int
		{
			return getData( "usenumber" );
		}
		
		/**
		 * 道具使用次数
		 */
		public function set usenumber(value:int):void
		{
			setData("usenumber", value);
		}
		
		/**
		 * 道具是否可销毁
		 */
		public function get discardstate():int
		{
			return getData( "discardstate" );
		}
		
		/**
		 * 道具是否可销毁
		 */
		public function set discardstate(value:int):void
		{
			setData("discardstate", value);
		}
		
		/**
		 * 道具是否可出售
		 */
		public function get sellstate():int
		{
			return getData( "sellstate" );
		}
		
		/**
		 * 道具是否可出售
		 */
		public function set sellstate(value:int):void
		{
			setData("sellstate", value);
		}
		
		/**
		 * 道具出售货币类型
		 */
		public function get selltype():int
		{
			return getData( "selltype" );
		}
		
		/**
		 * 道具出售货币类型
		 */
		public function set selltype(value:int):void
		{
			setData("selltype", value);
		}
		
		/**
		 * 道具出售价格
		 */
		public function get sellprice():int
		{
			return getData( "sellprice" );
		}
		
		/**
		 * 道具出售价格
		 */
		public function set sellprice(value:int):void
		{
			setData("sellprice", value);
		}
		
		/**
		 * 道具图片
		 */
		public function get picture():String
		{
			return getData( "picture" );
		}
		
		/**
		 * 道具图片
		 */
		public function set picture(value:String):void
		{
			setData("picture", value);
		}
		/**
		 * 道具图标
		 */
		public function get icon():String
		{
			return getData( "icon" );
		}
		
		/**
		 * 道具图标
		 */
		public function set icon(value:String):void
		{
			setData("icon", value);
		}
		/**
		 * 是否可开孔
		 */
		public function set hashole(value:int):void
		{
			setData("hashole", value);
		}
		
		/**
		 * 是否可开孔
		 */
		public function get hashole():int
		{
			return getData( "hashole" );
		}
		
		/**
		 * 初始孔数
		 */
		public function get holeinit():int
		{
			return getData( "holeinit" );
		}
		
		/**
		 * 初始孔数
		 */
		public function set holeinit(value:int):void
		{
			setData("holeinit", value);
		}
		
		/**
		 * 显示可开孔上限
		 */
		public function get holeshowmax():int
		{
			return getData( "holeshowmax" );
		}
		
		/**
		 * 显示可开孔上限
		 */
		public function set holeshowmax(value:int):void
		{
			setData("holeshowmax", value);
		}
		
		/**
		 * 孔数量上限
		 */
		public function get holemax():int
		{
			return getData( "holemax" );
		}
		
		/**
		 * 孔数量上限
		 */
		public function set holemax(value:int):void
		{
			setData("holemax", value);
		}
		
		/**
		 * 套装id
		 */
		public function get suitid():int
		{
			return getData( "suitid" );
		}
		
		/**
		 * 套装id
		 */
		public function set suitid(value:int):void
		{
			setData("suitid", value);
		}
		/**
		 * 是否可使用
		 */
		public function get usestate():int
		{
			return getData( "usestate" );
		}
		
		/**
		 * 是否可使用
		 */
		public function set usestate(value:int):void
		{
			setData("usestate", value);
		}
		
		/**
		 * 使用逻辑id
		 */
		public function get uselogicid():int
		{
			return getData( "uselogicid" );
		}
		
		/**
		 * 使用逻辑id
		 */
		public function set uselogicid(value:int):void
		{
			setData("uselogicid", value);
		}
	}
}