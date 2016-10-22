package lib.engine.game.state
{
	import flash.utils.Dictionary;
	
	import lib.engine.game.module.CModuleSubSystem;
	import lib.engine.iface.game.IGameState;

	public class GameStateManager extends CModuleSubSystem
	{
		private var _states:Dictionary;
		private var _currentState:String;
		public function GameStateManager()
		{
			super("GameStateManager");
		}
		
		override protected function _onInitBefore(params:Object = null):void
		{
			_states = new Dictionary();
			this.RegisterGameState(new GameStateNone());
			_currentState = new GameStateNone().getStateName();
		}
		
		
		/**
		 * 注册游戏状态 
		 * @param GameState
		 * 
		 */
		public function RegisterGameState(GameState:IGameState):void
		{
			_states[GameState.getStateName()] = GameState;
		}
		/**
		 * 切换状态 
		 * @param GameStateName
		 * 
		 */
		public function ChangeState(GameStateName:String,params:Object = null):Boolean
		{
			if(!_hasState(GameStateName))
			{
				return false;
			}
			//退出状态
			_exitState(_currentState,params);
			//进入新的状态
			_enterState(GameStateName,params);
			
			return true;
		}
		
		protected function _enterState(GameStateName:String,params:Object = null):void
		{
			_currentState = GameStateName;
			var GameState:IGameState = _states[GameStateName] as IGameState;
			GameState.onEnterState(params);
			
		}
		
		protected function _exitState(GameStateName:String,params:Object = null):void
		{
			_currentState = "";
			var GameState:IGameState = _states[GameStateName] as IGameState;
			GameState.onExitState(params);
		}
		
		protected function _hasState(GameStateName:String):Boolean
		{
			if(GameStateName == null || GameStateName == "")
			{
				return false;
			}
			return _states[GameStateName] != null;
		}
		
		/**
		 * 获取当前状态
		 * 
		 */
		public function getCurrentState():String
		{
			return _currentState;
		}
	}
}