package SJ.Game.utils
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstSoundEffect;
	import SJ.Game.data.json.Json_sound_effect_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SMuiscChannel;
	
	import flash.media.Sound;
	import flash.utils.Dictionary;

	/**
	 * 音效简单类,只做单次简单播发声音使用 
	 * @author caihua
	 * 
	 */
	public class SSoundEffectUtil
	{
		public function SSoundEffectUtil()
		{
		}
		
		private static var _sounddict:Dictionary = null;
		
		private static function _buildsounddict():void
		{
			if(_sounddict != null)
			{
				return;
			}
			_sounddict = new Dictionary();
			
			var jsonobj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonSoundEffect) as Array;
			if(jsonobj == null)
				return;
			var length:int = jsonobj.length;
			for(var i:int=0;i<length;i++)
			{
				var soundeffect:Json_sound_effect_setting = new Json_sound_effect_setting();
				soundeffect.loadFromJsonObject(jsonobj[i]);
				_sounddict[String(soundeffect.soundid)] = String(soundeffect.res);
				
			}
		}
		
		/**
		 * 普通按钮声音 
		 * 
		 */
		public static function playButtonNormalSound():void
		{
			play(ConstSoundEffect.KEY_BUTTON_NORMAL);
		}
		
		/**
		 * 弹出框声音 
		 * 
		 */
		public static function playTipSound():void
		{
			play(ConstSoundEffect.KEY_BUTTON_TIP);	
		}
		
		/**
		 * 播放音效 
		 * @param SoundKey 在 音效配置.csv中配置
		 * 
		 */
		public static function play(SoundKey:String):void
		{
			_buildsounddict();
			if(_sounddict.hasOwnProperty(SoundKey))
			{
				var  music:SMuiscChannel =  SMuiscChannel.SMuiscChannelCreate(AssetManagerUtil.o.getObject(_sounddict[SoundKey]) as Sound);
				music.fadeIn(false,0.1,1);
			}
		}
		
		/**
		 * 直接播放音效 
		 * @param msound
		 * 
		 */
		public static function playSoundEffect(msound:Sound):void
		{
			var  music:SMuiscChannel =  SMuiscChannel.SMuiscChannelCreate(msound);
			music.fadeIn(false,0.1,1);
		}
	}
}