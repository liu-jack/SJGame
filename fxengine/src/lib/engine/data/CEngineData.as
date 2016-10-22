package lib.engine.data
{
	

	/**
	 * 引擎通用数据 
	 * @author caihua
	 * 
	 */
	public class CEngineData extends CDataAbstract
	{
		private static var _ins:CEngineData;
		public static function get o():CEngineData
		{
			if(_ins == null)
			{
				_ins = new CEngineData();
			}
			return _ins;
		}
		public function CEngineData()
		{
			super("CEngineData");
			ResourcePath = "";
		}
		
		
		/**
		 * 资源路径 
		 * @return 
		 * 
		 */
		public function get ResourcePath():String
		{
			if(this.hasKey("ResourcePath"))
				return String(this.getData("ResourcePath"));
			return "";
		}
		/**
		 * 设置资源路径 
		 * @param path
		 * 
		 */
		public function set ResourcePath(path:String):void
		{
			this.setData("ResourcePath",path.replace(/\\/g , "/"));
		}
		


									
	}
}