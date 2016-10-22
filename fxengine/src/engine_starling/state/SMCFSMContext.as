package engine_starling.state
{
	public class SMCFSMContext
	{
		public function SMCFSMContext(state:SMCState)
		{
			_state = state;
		}
		
		// The current state of the finite state machine.
		private var _state:SMCState;

		public function get state():SMCState
		{
			return _state;
		}

		public function set state(value:SMCState):void
		{
			if(_state != value)
			{
				_state = value;
				if(debugFlag)
				{
					trace("ENTER STATE     : " + _state.name);
				}
			}
		}

		
		// Remember which state a transition left.
		private var _previousState:SMCState;

		public function get previousState():SMCState
		{
			return _previousState;
		}

		
		// The stack of pushed states.
		private var _stateStack:SMCStateEntry;
		
		private var _transition:String;

		public function set transition(value:String):void
		{
			_transition = value;
		}


		public function get transition():String
		{
			return _transition;
		}

		
		private var _debugFlag:Boolean;

		public function get debugFlag():Boolean
		{
			return _debugFlag;
		}

		public function set debugFlag(value:Boolean):void
		{
			_debugFlag = value;
		}

		
		public function get isInTransition():Boolean
		{
			return (_state == null ? true : false);
		}
		
		public function clearState():void
		{
			_previousState = _state;
			_state = null;
		}
		
		public function get isStateStackEmpty():Boolean
		{
			return (_stateStack == null);
		}
		
		// Returns the state stack's depth.
		public function stateStackDepth():int
		{
			var state_ptr:SMCStateEntry;
			var retval:int;
			
			for (state_ptr = _stateStack, retval = 0;
				state_ptr != null;
				state_ptr = state_ptr.next, ++retval)
			{
				
			}
			
			return (retval);
		}
		
		
		// Push the current state on top of the state stack
		// and make the specified state the current state.
		public function pushState(state:SMCState):void
		{
			var new_entry:SMCStateEntry;
			
			// Do the push only if there is a state to be pushed
			// on the stack.
			if (_state != null)
			{
//				new_entry = [[SMCStateEntry stateEntryWithState:_state next:_stateStack] retain];
				new_entry = new SMCStateEntry(_state,_stateStack);
				_stateStack = new_entry;
			}
			
			_state = state;
			
			if (debugFlag) {
				trace("PUSH TO STATE     : " + _state.name);
			}
		}
		
		// Make the state on top of the state stack the
		// current state.
		public function popState():void
		{
			var entry:SMCStateEntry;
			
			// Popping when there was no previous push is an error.
//			NSAssert(_stateStack != NULL, @"Popping empty state stack");
			
//			[_state release]; _state = [[_stateStack state] retain];
			_state = _stateStack.state;
			
			entry = _stateStack;
			_stateStack = _stateStack.next;
			
			if (debugFlag) {
				trace("POP TO STATE     : " + _state.name);
			}
		}
		
		public function emptyStateStack():void
		{
			var state_ptr:SMCStateEntry,next_ptr:SMCStateEntry;
			
			for (state_ptr = _stateStack;
				state_ptr != null;
				state_ptr = next_ptr)
			{
				next_ptr = state_ptr.next;
				state_ptr = null;
			}
			
			_stateStack = null;
		}

	}
}