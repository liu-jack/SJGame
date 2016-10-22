package engine_starling.display
{
	import engine_starling.utils.SMuiscChannel;
	
	import starling.events.Event;

	/**
	 * 声音节点 
	 * @author caihua
	 * 
	 */
	public class SMuiscNode extends SNode
	{
		
		private var _muiscChannel:SMuiscChannel;

		public function get muiscChannel():SMuiscChannel
		{
			return _muiscChannel;
		}

		public function SMuiscNode(mMuiscChannel:SMuiscChannel)
		{
			super();
			_muiscChannel = mMuiscChannel;
			addEventListener(Event.ADDED_TO_STAGE,_onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,_onRemove);
		}
		
		private var _loop:Boolean = false;

		/**
		 * 是否循环播放 
		 */
		public function get loop():Boolean
		{
			return _loop;
		}

		/**
		 * @private
		 */
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}

		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			_muiscChannel.dispose();
			
			super.dispose();
		}
		
		protected function _onRemove(e:Event):void
		{
			_muiscChannel.fadeOutAndStop(0.5);
		}
		
		protected function _onAddToStage(e:Event):void
		{
			_muiscChannel.fadeIn(_loop,0.5,1);
		}
		
		
	}
	
	
}