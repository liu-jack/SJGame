package lib.engine.game.state
{
	import lib.engine.iface.game.IGameState;
	import lib.engine.utils.CObjectUtils;

	public class GameStateNone implements IGameState
	{
		public function GameStateNone()
		{
		}
		
		public function getStateName():String
		{
//			return CObjectUtils.getClassFullName(this);
			return "GameStateNone";
		}
		
		public function onEnterState(params:Object = null):void
		{
			
		}
		
		public function onExitState(params:Object = null):void
		{
				
		}
		
	}
}