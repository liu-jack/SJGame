package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattleLayer;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	/**
	 * 选择技能 
	 * @author pengzhi
	 * 
	 */
	public class CJBattleCommandSelectSkill extends SCommandBase
	{
		private var layer:CJBattleLayer;
		public function CJBattleCommandSelectSkill()
		{
			super(ConstBattle.CommandSelectSkill, CJBattleCommandSelectSkillData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			
//			CJDataOfSkillSettting.o;
			//弹出技能解决 
			layer =  CJBattleMapManager.o.topLayer.getChildByName("CJBattleLayer") as CJBattleLayer;
			layer.showBottomBar(function ():void{
				executeEndImmediately();
			});

		}
		
		override protected function executeEnd(battleData:SCommandBaseData):void
		{
			layer.hideBottomBar();
			super.executeEnd(battleData);
		}
		
		
		
		
		
	}
}