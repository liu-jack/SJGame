package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 单一装备位上洗练数据
	 * @author zhengzheng
	 * 
	 */
	public class CJDataOfRecastPosition extends SDataBase
	{
		public function CJDataOfRecastPosition()
		{
			super("CJDataOfRecastPosition");
		}
		
		
		public static function getNewCJDataOfRecastPosition(heroid:String, userid:String, positiontype:int):CJDataOfRecastPosition
		{
			var positionData:CJDataOfRecastPosition = new CJDataOfRecastPosition();
			positionData.heroid = heroid;
			positionData.positiontype = positiontype;
			positionData.userid = userid;
			positionData.addattrjin = "0";
			positionData.addattrmu = "0";
			positionData.addattrshui = "0";
			positionData.addattrhuo = "0";
			positionData.addattrtu = "0";
			positionData.addattrbaoji = "0";
			positionData.addattrrenxing = "0";
			positionData.addattrshanbi = "0";
			positionData.addattrmingzhong = "0";
			positionData.addattrzhiliao = "0";
			positionData.addattrjianshang = "0";
			positionData.addattrxixue = "0";
			positionData.addattrshanghai = "0";
			return positionData;
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
		public function get addattrjin() : String
		{
			return this.getData("addattrjin");
		}
		public function get addattrmu() : String
		{
			return this.getData("addattrmu");
		}
		public function get addattrshui() : String
		{
			return this.getData("addattrshui");
		}
		public function get addattrhuo() : String
		{
			return this.getData("addattrhuo");
		}
		public function get addattrtu() : String
		{
			return this.getData("addattrtu");
		}
		public function get addattrbaoji() : String
		{
			return this.getData("addattrbaoji");
		}
		public function get addattrrenxing() : String
		{
			return this.getData("addattrrenxing");
		}
		public function get addattrshanbi() : String
		{
			return this.getData("addattrshanbi");
		}
		public function get addattrmingzhong() : String
		{
			return this.getData("addattrmingzhong");
		}
		public function get addattrzhiliao() : String
		{
			return this.getData("addattrzhiliao");
		}
		public function get addattrjianshang() : String
		{
			return this.getData("addattrjianshang");
		}
		public function get addattrxixue() : String
		{
			return this.getData("addattrxixue");
		}
		public function get addattrshanghai() : String
		{
			return this.getData("addattrshanghai");
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
		public function set addattrjin(value:String):void
		{
			this.setData("addattrjin", value);
		}
		public function set addattrmu(value:String):void
		{
			this.setData("addattrmu", value);
		}
		public function set addattrshui(value:String):void
		{
			this.setData("addattrshui", value);
		}
		public function set addattrhuo(value:String):void
		{
			this.setData("addattrhuo", value);
		}
		public function set addattrtu(value:String):void
		{
			this.setData("addattrtu", value);
		}
		public function set addattrbaoji(value:String):void
		{
			this.setData("addattrbaoji", value);
		}
		public function set addattrrenxing(value:String):void
		{
			this.setData("addattrrenxing", value);
		}
		public function set addattrshanbi(value:String):void
		{
			this.setData("addattrshanbi", value);
		}
		public function set addattrmingzhong(value:String):void
		{
			this.setData("addattrmingzhong", value);
		}
		public function set addattrzhiliao(value:String):void
		{
			this.setData("addattrzhiliao", value);
		}
		public function set addattrjianshang(value:String):void
		{
			this.setData("addattrjianshang", value);
		}
		public function set addattrxixue(value:String):void
		{
			this.setData("addattrxixue", value);
		}
		public function set addattrshanghai(value:String):void
		{
			this.setData("addattrshanghai", value);
		}
	}
}