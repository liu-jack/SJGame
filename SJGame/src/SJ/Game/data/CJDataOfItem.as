package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 物品数据
	 * @author longtao
	 * 
	 */
	public class CJDataOfItem extends SDataBase
	{
		public function CJDataOfItem()
		{
			super("CJDataOfItem");
		}
		
		/**
		 * 道具模板id
		 * 对应json文件中固有数据的ID
		 */
		public function get templateid():uint
		{
			return getData( "templateid" );
		}

		/**
		 * 道具模板id
		 * @param value
		 */
		public function set templateid(value:uint):void
		{
			setData("templateid", value);
		}
		
		/**
		 * 道具唯一ID
		 */
		public function get itemid():String
		{
			return getData( "itemId" );
		}

		/**
		 * 道具唯一ID
		 * @param value
		 */
		public function set itemid(value:String):void
		{
			setData("itemId", value);
		}
		
		/**
		 * 道具叠加数量
		 */
		public function get count():int
		{
			return getData( "count" );
		}
		
		
		/**
		 * 道具叠加数量
		 * @param value
		 * 
		 */		
		public function set count(value:int):void
		{
			setData("count", value);
		}
		/**
		 * 容器类型
		 */
		public function get containertype():int
		{
			return getData( "containertype" );
		}
		
		
		/**
		 * 容器类型
		 * @param value
		 * 
		 */		
		public function set containertype(value:int):void
		{
			setData("containertype", value);
		}
		/**
		 * 附加属性 - 金
		 * @return 
		 * 
		 */		
		public function get addattrjin():int
		{
			return getData("addattrjin");
		}
		/**
		 * 附加属性 - 金
		 * @param value
		 * 
		 */		
		public function set addattrjin(value:int):void
		{
			setData("addattrjin", value);
		}
		
		/**
		 * 附加属性 - 木
		 * @return 
		 * 
		 */		
		public function get addattrmu():int
		{
			return getData("addattrmu");
		}
		/**
		 * 附加属性 - 木
		 * @param value
		 * 
		 */		
		public function set addattrmu(value:int):void
		{
			setData("addattrmu", value);
		}
		
		/**
		 * 附加属性 - 水
		 * @return 
		 * 
		 */		
		public function get addattrshui():int
		{
			return getData("addattrshui");
		}
		/**
		 * 附加属性 - 水
		 * @param value
		 * 
		 */		
		public function set addattrshui(value:int):void
		{
			setData("addattrshui", value);
		}
		
		/**
		 * 附加属性 - 火
		 * @return 
		 * 
		 */		
		public function get addattrhuo():int
		{
			return getData("addattrhuo");
		}
		/**
		 * 附加属性 - 火
		 * @param value
		 * 
		 */		
		public function set addattrhuo(value:int):void
		{
			setData("addattrhuo", value);
		}
		
		/**
		 * 附加属性 - 土
		 * @return 
		 * 
		 */		
		public function get addattrtu():int
		{
			return getData("addattrtu");
		}
		/**
		 * 附加属性 - 土
		 * @param value
		 * 
		 */		
		public function set addattrtu(value:int):void
		{
			setData("addattrtu", value);
		}
		
		/**
		 * 附加属性 - 暴击
		 * @return 
		 * 
		 */		
		public function get addattrbaoji():int
		{
			return getData("addattrbaoji");
		}
		public function set addattrbaoji(value:int):void
		{
			setData("addattrbaoji", value);
		}
		
		/**
		 * 附加属性 - 韧性
		 * @return 
		 * 
		 */		
		public function get addattrrenxing():int
		{
			return getData("addattrrenxing");
		}
		public function set addattrrenxing(value:int):void
		{
			setData("addattrrenxing", value);
		}
		
		/**
		 * 附加属性 - 闪避
		 * @return 
		 * 
		 */		
		public function get addattrshanbi():int
		{
			return getData("addattrshanbi");
		}
		public function set addattrshanbi(value:int):void
		{
			setData("addattrshanbi", value);
		}
		
		/**
		 * 附加属性 - 命中
		 * @return 
		 * 
		 */		
		public function get addattrmingzhong():int
		{
			return getData("addattrmingzhong");
		}
		public function set addattrmingzhong(value:int):void
		{
			setData("addattrmingzhong", value);
		}
		
		/**
		 * 附加属性 - 治疗
		 * @return 
		 * 
		 */		
		public function get addattrzhiliao():int
		{
			return getData("addattrzhiliao");
		}
		public function set addattrzhiliao(value:int):void
		{
			setData("addattrzhiliao", value);
		}
		
		/**
		 * 附加属性 - 减伤
		 * @return 
		 * 
		 */		
		public function get addattrjianshang():int
		{
			return getData("addattrjianshang");
		}
		public function set addattrjianshang(value:int):void
		{
			setData("addattrjianshang", value);
		}
		
		/**
		 * 附加属性 - 吸血
		 * @return 
		 * 
		 */		
		public function get addattrxixue():int
		{
			return getData("addattrxixue");
		}
		public function set addattrxixue(value:int):void
		{
			setData("addattrxixue", value);
		}
		
		/**
		 * 附加属性 - 伤害加深
		 * @return 
		 * 
		 */		
		public function get addattrshanghai():int
		{
			return getData("addattrshanghai");
		}
		public function set addattrshanghai(value:int):void
		{
			setData("addattrshanghai", value);
		}
		/**
		 * 装备孔0 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid0():String
		{
			return getData("holeitemid0");
		}
		/**
		 * 装备孔0 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid0(value:String):void
		{
			setData("holeitemid0", value);
		}
		
		/**
		 * 装备孔1 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid1():String
		{
			return getData("holeitemid1");
		}
		/**
		 * 装备孔1 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid1(value:String):void
		{
			setData("holeitemid1", value);
		}
		
		/**
		 * 装备孔2 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid2():String
		{
			return getData("holeitemid2");
		}
		/**
		 * 装备孔2 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid2(value:String):void
		{
			setData("holeitemid2", value);
		}
		
		/**
		 * 装备孔3 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid3():String
		{
			return getData("holeitemid3");
		}
		/**
		 * 装备孔3 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid3(value:String):void
		{
			setData("holeitemid3", value);
		}
		
		/**
		 * 装备孔4 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid4():String
		{
			return getData("holeitemid4");
		}
		/**
		 * 装备孔1 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid4(value:String):void
		{
			setData("holeitemid4", value);
		}
		
		/**
		 * 装备孔5 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid5():String
		{
			return getData("holeitemid5");
		}
		/**
		 * 装备孔5 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid5(value:String):void
		{
			setData("holeitemid5", value);
		}
		
		/**
		 * 装备孔6 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid6():String
		{
			return getData("holeitemid6");
		}
		/**
		 * 装备孔6 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid6(value:String):void
		{
			setData("holeitemid6", value);
		}
		
		/**
		 * 装备孔7 -宝石id 
		 * @return 
		 * 
		 */		
		public function get holeitemid7():String
		{
			return getData("holeitemid7");
		}
		/**
		 * 装备孔7 -宝石id 
		 * @param value
		 * 
		 */		
		public function set holeitemid7(value:String):void
		{
			setData("holeitemid7", value);
		}
		
		/**
		 * 获取孔宝石道具id数组
		 * @return int Array, 没有镶嵌宝石返回长度为0的数组
		 * 
		 */		
		public function get holeItemArray():Array
		{
			var itemId:int = 0;
			var holeItemArray:Array = new Array();
			for (var i:int = 0; i < 8; i++)
			{
				itemId = parseInt(getData("holeitemid" + i, 0));
				if (itemId != 0)
				{
					holeItemArray.push(itemId);
				}
			}
			return holeItemArray;
		}
	}
}