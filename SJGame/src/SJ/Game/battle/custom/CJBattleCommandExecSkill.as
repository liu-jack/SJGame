package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattleMananger;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	/**
	 * 释放技能命令 
	 * @author caihua
	 * 
	 */
	public class CJBattleCommandExecSkill extends SCommandBase
	{
		public function CJBattleCommandExecSkill()
		{
			super(ConstBattle.CommandExecSkill, CJBattleCommandExecSkillData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			var selfplayer:CJBattlePlayerData = CJBattleMananger.o.battleDataBySelfLocationIndex(ConstBattle.ConstMaxLocationNum);
			var skillId:int = selfplayer.selectedSkill;
			if(skillId == -1)
			{
				executeEndImmediately(0);
				return;
			}
			
//			CJBattleMapManager.o.skillmaskLayer.pushActive();
//			
//			var skillData:Object = CJDataOfSkillSettting.o.getProperty(skillId);
//			selfplayer.playerSprite.playerSkill(skillData,function():void{
//				//暂时对方释放想通技能
//				
//				var otherplayer:CJBattlePlayerData = CJBattleMananger.o.battleDataByOtherLoactionIndex(ConstBattle.ConstMaxLocationNum);
//				if(otherplayer != null)
//				{
//					otherplayer.playerSprite.playerSkill(skillData,function():void{
//						executeEndImmediately(0);
//						return;
//					});
//				}
//				else
//				{
//					executeEndImmediately(0);
//				}
//			});

			

			

			
		}
		
		override protected function executeEnd(battleData:SCommandBaseData):void
		{
			CJBattleMapManager.o.skillmaskLayer.reset();
			// TODO Auto Generated method stub
			super.executeEnd(battleData);
		}
		
		
		
	}
	
	
}