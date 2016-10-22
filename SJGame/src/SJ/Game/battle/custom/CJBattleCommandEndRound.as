package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattleMananger;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.battle.CJBattleReplayManager;
	
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	import flash.html.script.Package;
	
	public class CJBattleCommandEndRound extends SCommandBase
	{
		public function CJBattleCommandEndRound()
		{
			super(ConstBattle.CommandEndRound, CJBattleCommandEndRoundData);
		}
		private var _vectorOfPlayerData:Vector.<CJBattlePlayerData>;
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			// TODO Auto Generated method stub
//			super.execute(battleData);
			
			//查询所有NPC,并按照速度排序
//			_vectorOfPlayerData = CJBattleMananger.o.getAllPlayerbattleData();
//			_vectorOfPlayerData.every(function (item:CJBattlePlayerData,index:int, array:Vector.<CJBattlePlayerData>):Boolean
//			{
//				item.nextRound();
//				return true;
//			});
//			var length:int = 0;
//			length = _vectorOfPlayerData.length;
//			var i:int = 1;
//			
//			var playersideData:CJBattlePlayerData;
//			for(i=0;i<length;i++)
//			{
//				//不是死人
//				if(!_vectorOfPlayerData[i].playerBaseData.isDead())
//				{
//					if(playersideData == null)
//					{
//						//第一个不是玩家的NPC,并且不是死人
//						
//						playersideData = _vectorOfPlayerData[i];
//						
//					}
//					else
//					{
//						//不是玩家,并且不是同一方的人
//						if(playersideData.playerBaseData.isSelf != _vectorOfPlayerData[i].playerBaseData.isSelf)
//						{
//							//0继续下一轮
//							executeEndImmediately();
//							return;
//						}
//					}
//				}
//				
//			}
//			
//			//1执行完成
////			cmdOwner.mJuggler.delayCall(1);
			
			
//			
			
			var mgr:CJBattleReplayManager = battleData.params["mgr"];
			var params:Object = battleData.params["params"];
//			"params"	Object (@19a89569)	
//			end	0	
//			round	0	
			var finish:Boolean = Boolean(parseInt(params.end));
			if(finish)
			{
				//延时执行
				cmdOwner.mJuggler.delayCall(executeEndImmediately,1,0);
			}
			else
			{
				executeEndImmediately(1);
			}
			
		}
		
		
		
	}
}