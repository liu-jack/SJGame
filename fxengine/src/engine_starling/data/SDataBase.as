package engine_starling.data
{
	

	/**
	 * 数据积累 
	 * @author pengzhi
	 * 
	 */
	public class SDataBase extends SDataOperate
	{
		public function SDataBase(dataBasename:String)
		{
			super(dataBasename);
		}
		
		/**
		 * 忽略数据变化事件 
		 * 
		 */
		public function ignoreDataEvent():void
		{
			_ignoreSetDataEvent = true;
		}
		
		
	}
}