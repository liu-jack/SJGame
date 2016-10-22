package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattleQTELayer;
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	import SJ.Game.map.CJBattleMapManager;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	
	public class CJBattleCommandQTE extends SCommandBase
	{
		private var qte:CJBattleQTELayer;
		public function CJBattleCommandQTE()
		{
			super(ConstBattle.CommandQTE, CJBattleCommandQTEData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			// TODO Auto Generated method stub
			
			qte = new CJBattleQTELayer(_onfinish,cmdOwner.mJuggler);
			qte.duringTime = battleData.during;
			
			CJBattleMapManager.o.qteLayer.addChild(qte);
			
//			var delayHandle:DelayedCall = cjbattleManager.mJuggler.delayCall(_onfinish,battleData.during);
			
			
			
			function _onfinish():void
			{
				executeEndImmediately();
			}

		}
		
		override protected function executeEnd(battleData:SCommandBaseData):void
		{
			qte.removeFromParent();
			super.executeEnd(battleData);
		}
		
		
		
	}
	
	
}