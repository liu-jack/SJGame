package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 平台充值单个商品数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfPlatformProduct extends SDataBase
	{
		public function CJDataOfPlatformProduct()
		{
			super("CJDataOfPlatformProduct");
		}
		
		/** 元宝数量 */
		public function get goldName():String
		{
			return getData( "goldName" );
		}
		public function set goldName(value:String):void
		{
			setData("goldName", value);
		}
		
		/** 人民币数量 */
		public function get rmbName():String
		{
			return getData( "rmbName" );
		}
		public function set rmbName(value:String):void
		{
			setData("rmbName", value);
		}
		
		/** 产品id */
		public function get productId():String
		{
			return getData( "productId" );
		}
		public function set productId(value:String):void
		{
			setData("productId", value);
		}
		
		/** 配置id */
		public function get cfgId():String
		{
			return getData( "cfgId" );
		}
		public function set cfgId(value:String):void
		{
			setData("cfgId", value);
		}
	}
}