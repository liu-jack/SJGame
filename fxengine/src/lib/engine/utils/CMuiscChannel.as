package lib.engine.utils
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * 声道类 
	 * @author caihua
	 * 
	 */
	public class CMuiscChannel
	{
		private var _id:String;
		private var _name:String;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		private var _Sound:Sound;
		private var _loops:Boolean;
		private var _State:String = STATE_STOP;
		private static const STATE_STOP:String = "STATE_STOP";
		private static const STATE_PLAYING:String = "STATE_PLAYING";
		private var _lastPos:Number = 0;
		
		public function CMuiscChannel(SoundInstance:Sound,name:String)
		{
			this._name = name;
			this._Sound = SoundInstance;
			this._transform = new SoundTransform(0);
		}
		
		public function fadeIn(loops:Boolean = false):void
		{
			if(_channel != null)
			{
				_channel.stop();
			}
			_channel = _Sound.play(loops?0:_lastPos,loops?(int.MAX_VALUE):0,new SoundTransform(0));
			_channel.addEventListener(Event.SOUND_COMPLETE,_onSoundEnd);
			TweenLite.to(this,0.5,{volume:2,ease:Linear.easeOut});
			this._transform = _channel.soundTransform;
		}
		private function _onSoundEnd(e:Event):void
		{
			_lastPos = 0;
			var mSoundChannel:SoundChannel = SoundChannel(e.target);
			mSoundChannel.soundTransform.volume = 0;
		}
		public function fadeOutAndStop(time:Number = 2):void
		{
			_lastPos = _channel.position;
			TweenLite.to(this,time,{volume:0,ease:Linear.easeOut,
				onComplete:function():void
				{
					_lastPos = _channel.position;
					_channel.stop();
				}
			});
			
		}
		protected function getChannel():void
		{
			
		}
		
		public function set volume(vol:Number):void
		{
			this._transform.volume = vol;
			this._channel.soundTransform = this._transform;
		}
		
		public function get volume():Number
		{
			return this._transform.volume;
		}
		
	}
}