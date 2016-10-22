package SJ.Game.data
{
	import engine_starling.data.SDataBase;

	/**
	 +------------------------------------------------------------------------------
	 * @name 用户主角的单个技能DAO
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-11 下午5:55:50  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfUserSkill extends SDataBase
	{
		/*武将的id*/
		private var _heroid:String;
		/*技能配置id*/
		private var _skillid1:int
		private var _skillid2:int
		private var _skillid3:int
		private var _skillid4:int
		private var _skillid5:int
		private var _selecteskill:int = 0;
		public function CJDataOfUserSkill()
		{
			super("CJDataOfUserSkill");
		}
		
		public function isSkillSelected(skillid:int):int
		{
			if( this.selecteskill != 0 && this.selecteskill == skillid)
			{
				return 1;
			}
			return  0;
		}

		public function get heroid():String
		{
			return _heroid;
		}

		public function set heroid(value:String):void
		{
			_heroid = value;
		}

		public function get skillid1():int
		{
			return _skillid1;
		}

		public function set skillid1(value:int):void
		{
			_skillid1 = value;
		}

		public function get skillid2():int
		{
			return _skillid2;
		}

		public function set skillid2(value:int):void
		{
			_skillid2 = value;
		}

		public function get skillid3():int
		{
			return _skillid3;
		}

		public function set skillid3(value:int):void
		{
			_skillid3 = value;
		}

		public function get skillid4():int
		{
			return _skillid4;
		}

		public function set skillid4(value:int):void
		{
			_skillid4 = value;
		}

		public function get skillid5():int
		{
			return _skillid5;
		}

		public function set skillid5(value:int):void
		{
			_skillid5 = value;
		}

		public function get selecteskill():int
		{
			return _selecteskill;
		}

		public function set selecteskill(value:int):void
		{
			_selecteskill = value;
		}
	}
}