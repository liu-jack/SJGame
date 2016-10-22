package engine_starling.commandSys.core
{
	import engine_starling.utils.SObjectUtils;
	
	import lib.engine.utils.functions.Assert;

	/**
	 * 命令数据基类
	 * !所有的属性,包括继承属性 都必须要包含get set方法 
	 * @author caihua
	 * 
	 */
	public class SCommandBaseData
	{
		public function SCommandBaseData(commandId:int)
		{
			_commandId = commandId;
		}
		
		public function convertFromJson(jsonObject:Object):void
		{
			SObjectUtils.JsonObject2Object(jsonObject,this);
		}
		
		private var _commandId:int = 0;

		/**
		 * 命令字 
		 */
		public final function get commandId():int
		{
			return _commandId;
		}

		/**
		 * @private
		 */
		public final function set commandId(value:int):void
		{
			//用一个假方法把commandId变为只读
		}
		
		
		private var _delaytime:Number = 0;

		/**
		 * 延时时间,秒,当前命令执行完毕到下一个命令开始执行的时间间隔 消息间隔
		 */
		public function get delaytime():Number
		{
			return _delaytime;
		}

		/**
		 * @private
		 */
		public function set delaytime(value:Number):void
		{
			_delaytime = value;
		}
		
		
		private var _commandQueueName:String = SCommandManager.DefalutCommandQueueName;

		/**
		 * 执行命令的队列名称,队列的唯一标识名称,默认为主队列 
		 */
		public function get commandQueueName():String
		{
			return _commandQueueName;
		}

		/**
		 * @private
		 */
		public function set commandQueueName(value:String):void
		{
			_commandQueueName = value;
		}
		
		
		private var _returnCode:int = 0;

		/**
		 * 返回值,只用于事件完成携带 
		 */
		public function get returnCode():int
		{
			return _returnCode;
		}

		/**
		 * @private
		 */
		public function set returnCode(value:int):void
		{
			_returnCode = value;
		}
		
		private var _during:Number = 0;

		/**
		 * 消息延时 秒
		 */
		public function get during():Number
		{
			return _during;
		}

		/**
		 * @private
		 */
		public function set during(value:Number):void
		{
			_during = value;
		}
		
		private var _params:Object = null

		/**
		 * 参数字段 
		 */
		public function get params():Object
		{
			return _params;
		}

		/**
		 * @private
		 */
		public function set params(value:Object):void
		{
			_params = value;
		}
		

		
	}
}