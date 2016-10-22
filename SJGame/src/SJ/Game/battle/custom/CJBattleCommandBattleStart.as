package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplication;
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SNode;
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class CJBattleCommandBattleStart extends SCommandBase
	{
		
		private var start:SAnimate;
		private var startback:SAnimate;
		public function CJBattleCommandBattleStart()
		{
			super(ConstBattle.CommandBattleStart, CJBattleCommandBattleStartData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			var mgr:CJBattleReplayManager = battleData.params["mgr"];
			if(mgr.isShowBattleStartAnims == false)
			{
				executeEndImmediately();
				return;
			}
			
			var animObject:Object = AssetManagerUtil.o.getObject("anim_battleStartBack");
			if(animObject == null)
				return;
			startback = SAnimate.SAnimateFromAnimJsonObject(animObject);
			cmdOwner.mJuggler.add(startback);
			startback.gotoAndPlay();
			CJBattleMapManager.o.topLayer.addChild(startback);
			
			
			animObject = AssetManagerUtil.o.getObject("anim_battleStart");
			if(animObject == null)
				return;
			start = SAnimate.SAnimateFromAnimJsonObject(animObject);
			cmdOwner.mJuggler.add(start);
			start.gotoAndPlay();
			CJBattleMapManager.o.topLayer.addChild(start);
			
			start.addEventListener(Event.COMPLETE,function _e(e:Event):void
			{
				start.removeEventListener(e.type,_e);
				executeEndImmediately();
			});
			super.execute(battleData);
		}
		
		override protected function executeEnd(battleData:SCommandBaseData):void
		{
			// TODO Auto Generated method stub
			
			if(startback != null)
			{
				cmdOwner.mJuggler.remove(startback);
				startback.removeFromParent();
			}
			
			if(start)
			{
				cmdOwner.mJuggler.remove(start);
				start.removeFromParent();
			}
			super.executeEnd(battleData);
		}
		
		
		
		
	}
}