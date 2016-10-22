package engine_starling.commandSys.core
{
	import engine_starling.SApplication;
	
	import flash.utils.Dictionary;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;

	/**
	 * 战斗命令管理器 ,主要实现命令执行
	 * @author caihua
	 * 
	 */
	public class SCommandManager implements IAnimatable
	{
		/**
		 * 默认命令队列名称 
		 */
		public static const DefalutCommandQueueName:String = "battleDefalutQueue";
		private var _commandRegister:Dictionary = null;
		
		
		private var _mJuggler:Juggler;

		
		/**
		 * 命令队列 顺序索引
		 */
		private var _commandQueues:Vector.<SCommandQueue>;
		/**
		 * 命令队列名称索引 
		 */
		private var _commandQueuesNameIndex:Dictionary;
		
		private var _running:Boolean;

		/**
		 * 命令定时器，涉及到战斗的延时部分都用这个东西 
		 */
		public function get mJuggler():Juggler
		{
			return _mJuggler;
		}

		/**
		 * 是否在运行 
		 */
		public function get running():Boolean
		{
			return _running;
		}
		
		
		public function SCommandManager()
		{
			_init();
		}
		
		private static var _ins:SCommandManager = null;
		
		private static function get o():SCommandManager
		{
			if(_ins == null)
				_ins = new SCommandManager();
			return _ins;
		}
		private function _init():void
		{
			_commandRegister = new Dictionary();
			_commandQueuesNameIndex = new Dictionary();
			_commandQueues = new Vector.<SCommandQueue>();
			//创建默认的命令队列
			_mJuggler = new Juggler();
			
			
			
		}
		/**
		 * 父类计时器 
		 */
		private var _ownerJugger:Juggler;

		/**
		 * 开始命令管理器 
		 * @param ownerJugger 依赖的计时器
		 * 
		 */
		public function start(ownerJugger:Juggler = null):void
		{
			if(running)
				return;
			_running = true;
			_ownerJugger = ownerJugger == null?SApplication.juggler:ownerJugger;
			_ownerJugger.add(this);
		}
		/**
		 * 停止命令管理器 
		 * 
		 */
		public function stop():void
		{
			if(!running)
				return;
			_running = false;
			_ownerJugger.remove(this);
			_ownerJugger = null;
			_mJuggler.purge();
			
			removeAllCommandQueue();
		}

		/**
		 * 获取命令 
		 * @param commandid
		 * @return 
		 * 
		 */
		public function getCommand(commandid:int):SCommandBase
		{
			return _commandRegister[commandid + ""] as SCommandBase;
		}
		private function _makeCommandData(CommandData:Object):SCommandBaseData
		{
			var commandId:String = CommandData["commandId"];
			
			var command:SCommandBase = _commandRegister[commandId];
			if(command == null)
				return null;
			var data:SCommandBaseData = new command.dataClass() as SCommandBaseData;
			data.convertFromJson(CommandData);
			return data;
		}
		/**
		 * 注册命令 
		 * @param command
		 * 
		 */
		public function registerCommand(command:SCommandBase):SCommandBase
		{
			_commandRegister[command.commandId + ""] = command;
			command.cmdOwner = this;
			return command;
		}
		
		/**
		 * 添加对应命令的消息 
		 * @param commandId
		 * @param EventId
		 * @param listener
		 * 
		 */
		public function addCommandEventListener(commandId:int,EventId:String,listener:Function):void
		{
			getCommand(commandId).addEventListener(EventId,listener);
		}
		/**
		 * 移除对应命令的消息 
		 * @param commandId
		 * @param EventId
		 * @param listener
		 * 
		 */
		public function removeCommandEventListener(commandId:int,EventId:String,listener:Function):void
		{
			getCommand(commandId).removeEventListener(EventId,listener);
		}
		private function _executeAllFinish():void
		{
			Starling.juggler.remove(this);
		}
		/**
		 * 执行命令 
		 * @param commandData
		 * 
		 */
		public function executeCommand(commandData:SCommandBaseData):void
		{
			var currentcommand:SCommandBase = this.getCommand(commandData.commandId);
			currentcommand.executeCommand(commandData);
		}
		/**
		 * 添加命令 
		 * @param commandData 命令数据
		 * 
		 * 
		 */
		public function addCommand(commandData:SCommandBaseData):void
		{
			var commandQueue:SCommandQueue = null;
			if(_commandQueuesNameIndex.hasOwnProperty(commandData.commandQueueName))
			{
				commandQueue = _commandQueuesNameIndex[commandData.commandQueueName];
			}
			else//自动创建命令队列
			{
				commandQueue = createCommandQueue(commandData.commandQueueName);	
			}
			commandQueue.addCommand(commandData,commandData.delaytime);
		}
		
		/**
		 * 生成命令数据 
		 * @param commandId
		 * @return 
		 * 
		 */
		public function genCommandData(commandId:int):SCommandBaseData
		{
			var command:SCommandBase = getCommand(commandId);
			if(command == null)
				return null;
			return new command.dataClass();
		}

		
		/**
		 * 通过Json批量添加命令 
		 * @param commandsJson
		 * 
		 */
		public function addCommandsByJson(commandsJson:String):void
		{
			
			var commandDatas:Array = JSON.parse(commandsJson) as Array;
			var length:int = commandDatas.length;
			for(var i:int=0;i<length;i++)
			{
				addCommand(_makeCommandData(commandDatas[i]));	
			}
		}
		
		
		
		/**
		 *  
		 * @param time 秒
		 * 
		 */
		public function advanceTime(time:Number):void
		{
			var length:int = _commandQueues.length;
			for(var i:int;i<length;++i)
			{
				_commandQueues[i].advanceTime(time);
			}
			_mJuggler.advanceTime(time);
			
		}
		
		/**
		 * 创建命令队列,并行与主命令队列的 
		 * @param name
		 * @return 命令队列的索引值
		 * 
		 */
		public function createCommandQueue(name:String):SCommandQueue
		{
			removeCommandQueue(name);
			var ret:SCommandQueue = new SCommandQueue(name,this);
			_commandQueuesNameIndex[name] = ret;
			_commandQueues.push(ret);
			return ret;
		}
		/**
		 * 删除命令队列 
		 * @param name
		 * @return 
		 * 
		 */
		public function removeCommandQueue(name:String):SCommandQueue
		{
			if(_commandQueuesNameIndex.hasOwnProperty(name))
			{
				var ret:SCommandQueue = _commandQueuesNameIndex[name];
				delete _commandQueuesNameIndex[name];
				
				//从队列中删除
				var length:int = _commandQueues.length;
				for(var i:int;i<length;i++)
				{
					if(_commandQueues[i] == ret)
					{
						_commandQueues.splice(i,1);
						break;
					}
				}
				return ret;
			}
			return null;
		}
		
		/**
		 * 删除所有的命令队列 ,值保留主队列
		 * 
		 */
		public function removeAllCommandQueue():void
		{
			_commandQueuesNameIndex = new Dictionary();
			_commandQueues.splice(0,_commandQueues.length);
			
			createCommandQueue(DefalutCommandQueueName);
		}
		

	}
}