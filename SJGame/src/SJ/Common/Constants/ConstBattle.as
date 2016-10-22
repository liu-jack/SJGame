package SJ.Common.Constants
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public final class ConstBattle
	{
		public function ConstBattle()
		{
		}
		
		public static var CommandMin:int = 0;
		/**
		 * 预备 
		 */
		public static var CommandStandBy:int = CommandMin ++;
		/**
		 * 决定战斗次序
		 */
		public static var CommandBattleOrder:int = CommandMin ++;
		/**
		 * 创建角色 
		 */
		public static var CommandCreatePlayer:int = CommandMin ++;
		/**
		 * 时钟片 
		 */
		public static var CommandTimeLine:int = CommandMin ++;
		
		/**
		 * 战斗开始 
		 */
		public static var CommandBattleStart:int = CommandMin++;
		
		/**
		 * 战斗结束 
		 */
		public static var CommandBattleEnd:int = CommandMin++;
		
		/**
		 * 回合开始 
		 */
		public static var CommandStartRound:int = CommandMin ++;
		
		/**
		 * 回合结束 
		 */
		public static var CommandEndRound:int = CommandMin++;
		
		/**
		 * 开始选择技能 
		 */
		public static var CommandSelectSkill:int = CommandMin++;
		
		/**
		 * 选择QTE
		 */
		public static var CommandQTE:int = CommandMin++;
		
		/**
		 * 执行技能
		 */
		public static var CommandExecSkill:int = CommandMin++;
		
		/**
		 * NPC开始战斗 
		 */
		public static var CommandNpcBattleStart:int = CommandMin++;
		
		/**
		 * NPC战斗结束 
		 */
		public static var CommandNpcBattleEnd:int = CommandMin++;
		
		
		/**
		 * NPC战斗 
		 */
		public static var CommandNpcBattle:int = CommandMin++;
		
	
		
		
		/**
		 * 最大站位数量 6
		 */
		public static const  ConstMaxLocationNum:int = 6;
		
		
		/**
		 * 敌方位置便宜
		 */
		public static const  ConstLocationOffSet:int = 10;
		
		/**
		 * 战斗结果界面显示的道具条目的数目 
		 */
		public static const  ConstBattleResultPropItems:int = 4;
		
//		/**
//		 * 我方位置索引0 
//		 */
//		public static var ConstSelfPlayerLocation:Point = new Point(162/2,270/2);
//		/**
//		 * 我方位置索引0 
//		 */
//		public static var ConstSelfLocationArr:Array = new Array(new Point(411/2,338/2),
//			new Point(376/2,445/2),new Point(333/2,555/2),new Point(257/2,367/2),
//			new Point(222/2,473/2),new Point(222/2,473/2));
//		
//		
//		
//		/**
//		 * 敌方位置索引 
//		 */
//		public static var ConstOtherLocationArr:Array = new Array(new Point(480- 411/2,338/2),
//			new Point(480- 376/2,445/2),new Point(480- 333/2,555/2),new Point(480- 257/2,367/2),
//			new Point(480- 222/2,473/2),new Point(480- 222/2,473/2));
//		
//		public static var ConstOtherPlayerLocation:Point = new Point(480- 162/2,270/2);
		
		
		/**
		 * 阵型数据 里面是 CJBattleFormation 
		 */
		public static var sBattleFormationData:Array = new Array();
		
		
		/**
		 *  QTE阵型 
		 */
		public static var sBattleQTEFormationData:Dictionary;
		/**
		 * 战斗胜利
		 */
		public static var BattleResultSuccess:int = 0;
		/**
		 * 战斗失败
		 */
		public static var BattleResultFailed:int = 1;
	}
}