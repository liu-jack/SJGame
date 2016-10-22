package lib.engine.utils
{
	public class CPathUtils
	{
		public function CPathUtils()
		{
		}
		
		/**
		 *  
		 * @param Path
		 * @return 
		 * 
		 */
		public static function Path2URL(Path:String):String
		{
			return null;
		}
		
		/**
		 * 取得路径中的后缀
		 * 
		 * @param	路径
		 * @return  null：路径无效，or 后缀，不包含"."
		 */
		public static function getPathExt(path:String):String
		{
			var extidx:int = path.lastIndexOf(".");
			if (extidx == -1)
			{
				return "";
			}
			
			var rtn:String = path.substr(extidx + 1);
			return rtn;
		}
	}
}