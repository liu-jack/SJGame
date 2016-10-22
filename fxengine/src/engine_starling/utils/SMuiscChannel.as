
package engine_starling.utils
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import engine_starling.stateMachine.StateMachineEvent;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 声道类 
	 * @author caihua
	 * 
	 */
	public class SMuiscChannel extends starling.events.EventDispatcher
	{
		private var _id:String;
		private var _name:String;
		private var _channel:SoundChannel;
//		private var _transform:SoundTransform;
		private var _Sound:Sound;
		private var _loops:Boolean;
		private var _State:String = STATE_STOP;
		internal static const STATE_INIT:String = "STATE_INIT"
		internal static const STATE_STOPING:String = "STATE_STOPING";
		internal static const STATE_STOP:String = "STATE_STOP";
		internal static const STATE_PLAYING:String = "STATE_PLAYING";
		private var _lastPos:Number = 0;
		
		private var _params:Object;
		
		private var _smc:SMuiscChannelState;
		/**
		 * 创建声音实例 
		 * @param SoundInstance
		 * @param name
		 * @return 
		 * 
		 */
		public static function SMuiscChannelCreate(SoundInstance:Sound,name:String = "unnameed"):SMuiscChannel
		{
			return new SMuiscChannel(SoundInstance,name);
		}
		public static function SMuiscChannelCreateByName(SoundResourceName:String,name:String = "unnameed"):SMuiscChannel
		{
			var sound:Sound = AssetManagerUtil.o.getObject(SoundResourceName) as Sound;
			return SMuiscChannelCreate(sound,name);
		}
		public function SMuiscChannel(SoundInstance:Sound,name:String)
		{
			this._name = name;
			this._Sound = SoundInstance;
			_smc = new SMuiscChannelState(this);

		}
		
		internal function _onstate_onPlay(e:StateMachineEvent):void
		{
			var loops:Boolean = _params.loops;
			var beginVolume:Number = _params.beginVolume;
			var time:Number = _params.time;
			
			
			if(_channel != null)
			{
				_channel.stop();
			}
			if(_Sound == null)
			{
				_smc.changeState(STATE_STOP);
				return;
			}
			_channel = _Sound.play(loops?0.25:_lastPos,loops?(int.MAX_VALUE):0,new SoundTransform(beginVolume));
			if(_channel == null)
			{
				_smc.changeState(STATE_STOP);
				return;
			}
			_channel.addEventListener(flash.events.Event.SOUND_COMPLETE,_onSoundEnd);
			volume = beginVolume;
			TweenLite.to(this,time,{volume:1,ease:Linear.easeOut});

		}
		
		internal function _onstate_onStop(e:StateMachineEvent):void
		{
			
		}
		
		internal function _onstate_onStoping(e:StateMachineEvent):void
		{
			var time:Number = _params.time;
			_lastPos = _channel.position;
			if(time == 0)
			{
				_channel.stop();
			}
			else
			{
				TweenLite.to(this,time,{volume:0,ease:Linear.easeOut,
					onComplete:function():void
					{
						_lastPos = _channel.position;
						_channel.stop();
					}
				});
			}
		}
		
		public function fadeIn(loops:Boolean = false,time:Number = 0.5,beginVolume:Number = 0):void
		{
			_params = {"loops":loops,"time":time,"beginVolume":beginVolume};
			_smc.changeState(STATE_PLAYING);
			
		
		}
		private function _onSoundEnd(e:flash.events.Event):void
		{
			_lastPos = 0;
			volume = 0;
			
			if(hasEventListener(starling.events.Event.COMPLETE))
			{
				dispatchEventWith(starling.events.Event.COMPLETE);
			}
			_smc.changeState(STATE_STOP);
		}
		public function fadeOutAndStop(time:Number = 2):void
		{
			_params = {"time":time};
			_smc.changeState(STATE_STOPING);
			
		}
		protected function getChannel():void
		{
//			return _channel;
		}
		private static var _global_volume:Number = 1.0;
		/**
		 * 设置全局声音 
		 * @param value 0 -1
		 * 
		 */
		public static function set global_volume(value:Number):void
		{
//			return;
			_global_volume = Math.min(value,1.0);
			_global_volume = Math.max(_global_volume,0);
			var aa:SoundTransform=new SoundTransform();
			aa.volume=_global_volume;
			SoundMixer.soundTransform=aa;
			
		}
		public function set volume(vol:Number):void
		{
			if(_channel != null)
			{
				_channel.soundTransform = new SoundTransform( Math.min(vol,_global_volume)) ;
			}
		}
		
		public function get volume():Number
		{
			if(_channel != null)
			{
				return _channel.soundTransform.volume;
			}
			else
			{
				return 0;
			}
		}
		
		public function dispose():void
		{
			if(_channel != null)
			{
				_channel.stop();
			}
			_Sound = null;
			
		}

		/**
		 * 全局声音 0-1 
		 */
		public static function get global_volume():Number
		{
			return _global_volume;
		}

		
	}
}