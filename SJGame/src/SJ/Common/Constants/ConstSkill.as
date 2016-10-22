package SJ.Common.Constants
{
	public final class ConstSkill
	{
		public function ConstSkill()
		{
		}
		

		/**
		 * 普通单个 
		 */
		public static const skillTypeNormalSingle:int = 0;
		/**
		 * 随机 
		 */
		public static const skillTypeRandom:int = 1;
		/**
		 * AOE技能 
		 */
		public static const skillTypeAOE:int = 2;
		/**
		 * 行攻击 0 3为一行 
		 */
		public static const skillTypeRow:int = 3;
		
		/**
		 * 前排攻击 为 0,1,2 
		 */
		public static const skillTypeFrontCol:int = 4;
		
		/**
		 * 后排攻击 
		 */
		public static const skillTypeBackCol:int = 5;
		
		/**
		 * 指向自己 
		 */
		public static const skillTargetTypeSelf:int = 0;
		
		
		/**
		 * 指向对方
		 */
		public static const skillTargetTypeOther:int = 1;
	}
}