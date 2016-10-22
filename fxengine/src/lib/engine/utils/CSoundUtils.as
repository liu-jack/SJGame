package lib.engine.utils
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	import lib.engine.resources.ResourceManager;

	/**
	 * 声音控制模块 
	 * @author caihua
	 * 
	 */
	public class CSoundUtils
	{
		private static var _ins:CSoundUtils;
		private var _musicsList:Dictionary;
		public function CSoundUtils()
		{
			_musicsList = new Dictionary();
		}
		
		public static function get o():CSoundUtils
		{
			if(_ins == null)
				_ins = new CSoundUtils();
			return _ins;
		}
		public function playSound(SoundNameClass:String,
										 SoundResKey:String,loops:Boolean):void
		{
			_play(SoundNameClass,SoundResKey,loops,false);
		}
		private function _play(SoundNameClass:String,
									  SoundResKey:String,loops:Boolean,useSoundTransform:Boolean):void
		{
			var mSoundChannel:SoundChannel = null;
			
			
			var SoundKey:String = getMuiscKey(SoundNameClass,SoundResKey);
			if(_musicsList[SoundKey] == null)
			{
				ResourceManager.o.getResourceClass(SoundResKey,SoundNameClass,
					_playcallback,{'SoundNameClass':SoundNameClass,
						'SoundResKey':SoundResKey,
						'loops':loops,'useSoundTransform':useSoundTransform});
			}
			else
			{
				var music:CMuiscChannel = _musicsList[SoundKey];
				music.fadeIn(loops);
			}
			
		}
		
		private function _playcallback(cls:Class,params:Object):void
		{
			var SoundNameClass:String = params.SoundNameClass;
			var SoundResKey:String = params.SoundResKey;
			var loops:Boolean = params.loops;
			var useSoundTransform:Boolean = params.useSoundTransform;
			var mSound:Sound = new cls();
			var SoundKey:String = getMuiscKey(SoundNameClass,SoundResKey);
			var music:CMuiscChannel =  new CMuiscChannel(mSound,SoundKey);
			music.fadeIn(loops);
			_musicsList[SoundKey] = music;
			
		}
		
		private function getMuiscKey(SoundNameClass:String,SoundResKey:String):String
		{
			return SoundResKey  + "_" + SoundNameClass;
		}

		
		public function stopSound(SoundNameClass:String,SoundResKey:String):void
		{
			var musickey:String = getMuiscKey(SoundNameClass,SoundResKey);
			var music:CMuiscChannel = _musicsList[musickey];
			if(music != null)
			{
				music.fadeOutAndStop();
//				_musicsList[musickey] = null;
			}
		}
	}
}