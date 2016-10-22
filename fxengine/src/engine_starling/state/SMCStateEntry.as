package engine_starling.state
{
	public class SMCStateEntry
	{
		public function SMCStateEntry(state:SMCState,next:SMCStateEntry)
		{
			_next = next;
			_state = state;
		}
		
		private var _state:SMCState;

		public function get state():SMCState
		{
			return _state;
		}

		public function set state(value:SMCState):void
		{
			_state = value;
		}

		private var _next:SMCStateEntry;

		public function get next():SMCStateEntry
		{
			return _next;
		}

		public function set next(value:SMCStateEntry):void
		{
			_next = value;
		}

	}
}