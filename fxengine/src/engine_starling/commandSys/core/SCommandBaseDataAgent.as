package engine_starling.commandSys.core
{
	/**
	 * 命令代理类 
	 * @author caihua
	 * 
	 */
	public class SCommandBaseDataAgent
	{
		/**
		 * 命令数据代理 
		 * @param data 命令数据
		 * @param delaytime 延时时间
		 * 
		 */
		public function SCommandBaseDataAgent(data:SCommandBaseData,delaytime:Number)
		{
			_delaytime = delaytime;
			_commandData = data;
		}
		
		private var _commandData:SCommandBaseData;

		/**
		 * 命令数据 
		 */
		public function get commandData():SCommandBaseData
		{
			return _commandData;
		}

		private var _delaytime:Number;

		/**
		 * 数据延时时间 秒
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

	}
}