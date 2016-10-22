package engine_starling.Events
{
	public class AssetEvent
	{
		public function AssetEvent()
		{
		}
		
		/**
		 *  初始化完成
		 *  data{code:0 失败,code:1 成功}
		 */
		public static const INIT_COMPLETE:String = "INIT_COMPLETE";
	}
}