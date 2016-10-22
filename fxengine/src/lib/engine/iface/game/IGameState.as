package lib.engine.iface.game
{
	/**
	 * 游戏状态 
	 * @author caihua
	 * 
	 */
	public interface IGameState
	{
		
		/**
		 * 获取状态名称 
		 */
		function getStateName():String;
		/**
		 * 进入状态 
		 * 
		 */
		function onEnterState(params:Object = null):void;
		/**
		 * 退出状态 
		 * 
		 */
		function onExitState(params:Object = null):void;
	}
}