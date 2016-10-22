package SJ.Game.SocketServer
{
	import lib.engine.game.module.CJModuleSubSystem;
	
	public class SocketModule extends CJModuleSubSystem
	{
		public function SocketModule()
		{
			super("SocketModule");
			
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
		}
		
		override protected function _onExit(params:Object=null):void
		{

			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
		
			SocketManager.o;
			super._onInit(params);
		}
		
		
		
		
	}
}