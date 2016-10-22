package engine_starling.commandSys.core
{
	import engine_starling.Events.CommandEvent;
	
	import starling.animation.DelayedCall;
	import starling.events.EventDispatcher;

	/**
	 * 命令基类 
	 * @author caihua
	 * 
	 */
	public class SCommandBase extends EventDispatcher
	{
		private var _commandId:int;
		private var _dataClass:Class;
		protected var _battleData:SCommandBaseData;
		private var _delayHandle:DelayedCall;
		/**
		 * 构造 
		 * @param commandId 命令关键字
		 * @param dataClass 命令对应的数据类
		 * 
		 */
		public function SCommandBase(commandId:int,dataClass:Class)
		{
			_commandId = commandId;
			_dataClass = dataClass;
			
//			if((_dataClass is CJBattleCommandBaseData) == false)
//			{
//				Assert(false,"Command Data Type Error!");
//			}
		}
		
		private var _cmdOwner:SCommandManager;
		
		/**
		 * 命令所属的命令管理器 
		 * @return 
		 * 
		 */
		public function get cmdOwner():SCommandManager
		{
			return _cmdOwner;
		}

		public function set cmdOwner(value:SCommandManager):void
		{
			_cmdOwner = value;
		}

		/**
		 * 执行函数 
		 * @param battleData
		 * 
		 */
		protected function execute(battleData:SCommandBaseData):void{
			
		}
		
		/**
		 * 执行结束 
		 * @param battleData
		 * 
		 */
		protected function executeEnd(battleData:SCommandBaseData):void
		{
		}

		
		/**
		 * 携带返回值的返回 
		 * @param returnCode
		 * 
		 */
		private function _executeFinishWithReturnCode(returnCode:int):void
		{
			_battleData.returnCode = returnCode;
			this.dispatchEventWith(CommandEvent.Event_Finshed,false,_battleData);
			_battleData = null;
		}
		/**
		 * 系统调用执行命令 
		 * @param battleData
		 * 
		 */
		public final function executeCommand(commandData:SCommandBaseData):void{
			_battleData = commandData;
			_delayHandle = new DelayedCall (executeEndImmediately,commandData.during);
			execute(commandData);
			
			
			
		}
		
		/**
		 * 立刻执行完毕当前命令 
		 * 
		 */
		public final function executeEndImmediately(returnCode:int = 0):void
		{
			cmdOwner.mJuggler.remove(_delayHandle);
			_delayHandle = null;
			executeEnd(_battleData);
			_executeFinishWithReturnCode(returnCode);
		}
		
		/**
		 * 数据的类型 
		 * @return 
		 * 
		 */
		public final function get dataClass():Class
		{
			return _dataClass;
		}
		
		/**
		 * 命令关键字 
		 * @return 
		 * 
		 */
		public final function get commandId():int
		{
//			Assert(false,"override me!");
			return _commandId;
		}
	}
}