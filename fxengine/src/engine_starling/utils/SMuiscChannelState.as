package engine_starling.utils
{
	import engine_starling.stateMachine.StateMachine;
	
	public class SMuiscChannelState extends StateMachine
	{
		private var _owner:SMuiscChannel;
		public function SMuiscChannelState(owner:SMuiscChannel)
		{
			_owner = owner;
			super();
			
			_init();
		}
		
		private function _init():void
		{
			addState(SMuiscChannel.STATE_INIT,{from:"*"});
			
			addState(SMuiscChannel.STATE_PLAYING,{enter:_owner._onstate_onPlay, from:[SMuiscChannel.STATE_STOP,SMuiscChannel.STATE_INIT]});
			
			addState(SMuiscChannel.STATE_STOPING,{enter:_owner._onstate_onStoping,from:[SMuiscChannel.STATE_PLAYING]});
			
			addState(SMuiscChannel.STATE_STOP,{enter:_owner._onstate_onStop,from:[SMuiscChannel.STATE_PLAYING,SMuiscChannel.STATE_STOPING]});
			
			changeState(SMuiscChannel.STATE_INIT);
		}
	}
}