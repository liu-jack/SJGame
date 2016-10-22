package engine_starling.utils
{
	public class SArrayUtil
	{
		public function SArrayUtil()
		{
		}
		
		/**
		 * 删除数组中的重复元素 
		 * @param inArr
		 * @return 新的数组
		 * 
		 */
		public static function deleteRepeat(inArr:Array):Array
		{
			function checkRepeat(obj:* , index:int, arr:Array):Boolean
			{
				return arr.indexOf(obj) == index;
			}
			return inArr.filter(checkRepeat);
		}
		
//		public static function deleteElements(inArr:Array,delArr:Array):Array
//		{
//			function checkRepeat(obj:* , index:int, arr:Array):Boolean
//			{
//				
//				if(delArr.indexOf(obj) == -1)
//				{
//					return true;
//				}
//				return false;
//			}
//			return inArr.filter(checkRepeat);
//		}
	}
}