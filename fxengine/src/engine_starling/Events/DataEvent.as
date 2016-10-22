package engine_starling.Events
{
	public class DataEvent
	{
		public function DataEvent()
		{
		}
		
		/**
		 * 数据改变事件 
		 */
		public static const DataChange:String = "SEventDataChange";
		
		/**
		 * 从远程加载完毕数据 
		 */
		public static const DataLoadedFromRemote:String = "SDataLoadedFromRemote";
	}
}