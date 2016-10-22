package engine_starling.state
{
	public class SMCState
	{
		public function SMCState(name:String,stateId:int)
		{
			_name = name;
			stateId = _stateId;
		}
		
		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		private var _stateId:int;

		/**
		 * 状态ID 
		 */
		public function get stateId():int
		{
			return _stateId;
		}

		/**
		 * @private
		 */
		public function set stateId(value:int):void
		{
			_stateId = value;
		}

	}
}