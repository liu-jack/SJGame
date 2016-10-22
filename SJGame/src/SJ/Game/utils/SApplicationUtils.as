package SJ.Game.utils
{
	import SJ.MainApplication;
	
	import engine_starling.SApplication;
	import engine_starling.utils.SPlatformUtils;

	public class SApplicationUtils
	{
		public function SApplicationUtils()
		{
		}
		
		/**
		 * 退出 
		 * 
		 */
		public static function exit():void
		{
			(SApplication.appInstance as MainApplication).platform.gameexit(0);
//			HelloAne.o.exitApplication(0);
			SPlatformUtils.exit();
		}
	}
}