package engine_starling.core
{
	import lib.engine.utils.functions.Assert;

	/**
	 * 简易引用计数器 
	 * @author caihua
	 * 
	 */
	public class SRefCount
	{
		public function SRefCount()
		{
		}
		
		private var _ref_count:uint = 0;
		
		/**
		 * 增加引用 
		 * @param from
		 * 
		 */
		public function inc_ref():void
		{
			_ref_count ++;
		}
		/**
		 * 减少引用 
		 * 
		 */
		public function dec_ref():void
		{
			Assert(_ref_count != 0,"引用计数错误")
			_ref_count --;
		}
		
		/**
		 * 清空引用 
		 * 
		 */
		public function clear_ref():void
		{
			_ref_count = 0;
		}

		/**
		 * 引用计数 
		 */
		public function get ref_count():uint
		{
			return _ref_count;
		}

		
	}
}