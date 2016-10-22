package SJ.Game.data
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstJewel;
	
	import engine_starling.data.SDataBase;
	
	import flash.net.dns.AAAARecord;
	
	/**
	 * 单一装备位上宝石镶嵌数据
	 * 数据格式{position, jewelId}
	 * @author sangxu
	 * 
	 */
	public class CJDataOfInlayPosition extends SDataBase
	{
		public function CJDataOfInlayPosition()
		{
			super("CJDataOfInlayPosition");
		}
		
		/**
		 * 获取指定索引孔中道具id
		 * @param index	索引
		 * @return 
		 * 
		 */		
		public function getHoleItemId(index:String):String
		{
			return this.getData("holeitemid" + index);
		}
		
		/**
		 * 设置孔中宝石id
		 * @param index	孔索引
		 * @param jewelId	宝石id
		 * 
		 */		
		private function _setHoleItemId(index:String, jewelId:String):void
		{
			this.setData("holeitemid" + index, jewelId);
		}
		/**
		 * 孔索引最小值
		 * @return 
		 * 
		 */		
		public function get holeIndexMin():int
		{
			return 0;
		}
		/**
		 * 孔索引最大值
		 * @return 
		 * 
		 */		
		public function get holeIndexMax():int
		{
			return 5;
		}
		
		/**
		 * 获取第一个为空的孔的索引
		 * @return 存在则返回索引，没有空孔返回-1
		 * 
		 */		
		public function getFirstEmptyHoleIndex():int
		{
			var holeValue:String = "";
			for (var i:int = 0; i < 6; i++)
			{
				holeValue = this.getHoleItemId(String(i));
				if (holeValue == ConstBag.INLAY_HOLE_STATE_EMPTY)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 获取当前装备位所有宝石道具id（未解锁与空孔不返回）
		 * @return 
		 * 
		 */		
		public function getAllJewels():Array
		{
			var array:Array = new Array();
			var holeValue:String = "";
			for (var i:int = 0; i < 6; i++)
			{
				holeValue = this.getHoleItemId(String(i));
				if (holeValue != ConstBag.INLAY_HOLE_STATE_EMPTY && holeValue != ConstBag.INLAY_HOLE_STATE_LOCK)
				{
					array.push(holeValue);
				}
			}
			return array;
		}
		
		/**
		 * 获取当前开孔索引
		 * @return 
		 * 
		 */		
		public function getOpenIndex():int
		{
			var holeValue:String = "";
			var lockCount:int = 0;
			for (var i:int = 0; i < 6; i++)
			{
				holeValue = this.getHoleItemId(String(i));
				if (holeValue == ConstBag.INLAY_HOLE_STATE_LOCK)
				{
					lockCount += 1;
				}
			}
			return 6 - lockCount;
		}
		
		public static function getNewCJDataOfInlayPosition(heroid:String, userid:String, positiontype:int):CJDataOfInlayPosition
		{
			var positionData:CJDataOfInlayPosition = new CJDataOfInlayPosition();
			positionData.heroid = heroid;
			positionData.positiontype = positiontype;
			positionData.userid = userid;
			positionData.holeitemid0 = ConstJewel.JEWEL_HOLE_STATUS_EMPTY;
			positionData.holeitemid1 = ConstJewel.JEWEL_HOLE_STATUS_LOCK;
			positionData.holeitemid2 = ConstJewel.JEWEL_HOLE_STATUS_LOCK;
			positionData.holeitemid3 = ConstJewel.JEWEL_HOLE_STATUS_LOCK;
			positionData.holeitemid4 = ConstJewel.JEWEL_HOLE_STATUS_LOCK;
			positionData.holeitemid5 = ConstJewel.JEWEL_HOLE_STATUS_LOCK;
			return positionData;
		}
		
		/**
		 * 设置孔开启
		 * @param index
		 * 
		 */		
		public function setHoleOpen(index:int):void
		{
			if (index < this.holeIndexMin || index > this.holeIndexMax)
			{
				return;
			}
			var strIndex:String = String(index);
			if (getHoleItemId(strIndex) == ConstJewel.JEWEL_HOLE_STATUS_LOCK)
			{
				_setHoleItemId(strIndex, ConstJewel.JEWEL_HOLE_STATUS_EMPTY);
			}
		}
		
		/** getter */
		public function get heroid() : String
		{
			return this.getData("heroid");
		}
		public function get positiontype() : int
		{
			return this.getData("positiontype");
		}
		public function get userid() : String
		{
			return this.getData("userid");
		}
		public function get holeitemid0() : String
		{
			return this.getData("holeitemid0");
		}
		public function get holeitemid1() : String
		{
			return this.getData("holeitemid1");
		}
		public function get holeitemid2() : String
		{
			return this.getData("holeitemid2");
		}
		public function get holeitemid3() : String
		{
			return this.getData("holeitemid3");
		}
		public function get holeitemid4() : String
		{
			return this.getData("holeitemid4");
		}
		public function get holeitemid5() : String
		{
			return this.getData("holeitemid5");
		}
		
		
		
		/** setter */
		public function set heroid(value:String):void
		{
			this.setData("heroid", value);
		}
		public function set positiontype(value:int):void
		{
			this.setData("positiontype", value);
		}
		public function set userid(value:String):void
		{
			this.setData("userid", value);
		}
		public function set holeitemid0(value:String):void
		{
			this.setData("holeitemid0", value);
		}
		public function set holeitemid1(value:String):void
		{
			this.setData("holeitemid1", value);
		}
		public function set holeitemid2(value:String):void
		{
			this.setData("holeitemid2", value);
		}
		public function set holeitemid3(value:String):void
		{
			this.setData("holeitemid3", value);
		}
		public function set holeitemid4(value:String):void
		{
			this.setData("holeitemid4", value);
		}
		public function set holeitemid5(value:String):void
		{
			this.setData("holeitemid5", value);
		}
		
		
	}
}