package SJ.Game.upgrade
{
	import engine_starling.data.SDataBase;
	
	/**
	 +------------------------------------------------------------------------------
	 * 记录用户使用习惯的数据类型
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-7-17 下午5:08:16  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfUserHabit extends SDataBase
	{
		/*是否选中升级*/
		private var _noUpgrade:int = 0;
		
		public function CJDataOfUserHabit()
		{
			super("CJDataOfUserHabit");
		}

		public function get noUpgrade():int
		{
			return _noUpgrade;
		}

		public function set noUpgrade(value:int):void
		{
			_noUpgrade = value;
		}

	}
}