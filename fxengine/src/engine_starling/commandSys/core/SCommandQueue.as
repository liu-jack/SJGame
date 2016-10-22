package engine_starling.commandSys.core
{
	import starling.animation.IAnimatable;

	public class SCommandQueue implements IAnimatable
	{

		
		
		/**
		 * 队列名称 
		 */
		private var _name:String;
			
		private var _commandQueue:Vector.<SCommandBaseDataAgent>;
		
		private var _commandManager:SCommandManager;
		
		public function SCommandQueue(name:String,commandManager:SCommandManager)
		{
			_name = name;
			_commandQueue = new Vector.<SCommandBaseDataAgent>();
			_commandManager = commandManager;
			
		}
		
		public function advanceTime(time:Number):void
		{
			if(_commandQueue.length > 0)
			{
				_commandQueue[0].delaytime -= time;
				
				_execute();	
			}
		}
		
		protected function _execute():void
		{
			if(_commandQueue.length == 0)
			{
				return;
			}
			var currentCommand:SCommandBaseDataAgent = _commandQueue[0];
			if(currentCommand.delaytime <=0)
			{
				currentCommand = _commandQueue.shift()
			}
			else
			{
				currentCommand = null;
			}
			
			//可以有执行的命令
			if(currentCommand != null)
			{
				_commandManager.executeCommand(currentCommand.commandData);
				//继续执行下一个命令
				_execute();
			}
			
		}
		
		public function addCommand(mcommandData:SCommandBaseData,delaytime:Number):void
		{
			_commandQueue.push(new SCommandBaseDataAgent(mcommandData,delaytime));	
		}
		public function removeAllCommand():void
		{
			_commandQueue.splice(0,-1);
		}
		/**
		 * 延时执行命令 
		 * @param delaytime 秒
		 * 
		 */
		public function delayCommand(delaytime:Number):void
		{
			if(_commandQueue.length > 0)
			{
				_commandQueue[0].delaytime += delaytime;
			}
		}
	}
}