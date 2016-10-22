package SJ.Common.Constants
{
	public class ConstPlayerState
	{
		public function ConstPlayerState()
		{
		}
		/**
		 * 状态机空状态
		 */
		public static const SConstPlayerStateNone:String = "none";
		/**
		 * 待机前缀 
		 */
		public static const SConstPlayerStateIdle:String = "idle";
		/**
		 * 场景待机 
		 */
		public static const SConstPlayerStateSceneIdle:String = "sceneidle"
		/**
		 * 跑步 
		 */
		public static const SConstPlayerStateRun:String = "run";
		
		public static const SConstPlayerStateShanIn:String = "shanin";
		
		public static const SConstPlayerStateShanOut:String = "shanout";
		/**
		 * 受击 
		 */
		public static const SConstPlayerStateUnderAttack:String = "underattack";
		/**
		 *  普通攻击开始
		 */
		public static const SConstPlayerStateAttackBegin:String = "attackbegin";
		/**
		 * 普通攻击动画前缀 
		 */
		public static const SConstPlayerStateAttack:String = "attack";
		/**
		 * 技能攻击1 
		 */
		public static const SConstPlayerStateSkill1:String = "skill1";
		/**
		 * 技能攻击2 
		 */
		public static const SConstPlayerStateSkill2:String = "skill2";
		
		/**
		 * 开始释放技能 
		 */
		public static const SConstPlayerStateSkillBegin:String = "skillbegin";
		
		/**
		 * 死亡 
		 */
		public static const SConstPlayerStateDead:String = "dead";
		
		
		
		
		/**
		 * 获胜 
		 */
		public static const SConstPlayerStateWin:String = "win";
		/**
		 * 失败
		 */
		public static const SConstPlayerStateLose:String = "lose";
		
		
		/**
		 * 跳 
		 */
		public static const SConstPlayerStateJump:String = "jump";
		
		
		/**
		 * 晕菜 
		 */
		public static const SConstPlayerStatexuanyun:String = "xuanyun";
		
		
		/**
		 * 骑乘待机 
		 */
		public static const SConstPlayerStateRideIdle:String = "rideidle";
		
		/**
		 * 骑乘跑动 
		 */
		public static const SConstPlayerStateRideRun:String = "riderun";
		
		

	}
}