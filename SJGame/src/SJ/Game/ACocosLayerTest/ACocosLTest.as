package SJ.Game.ACocosLayerTest
{
	import flash.utils.ByteArray;
	
	import SJ.Game.utils.LuaResource;
	
	import engine_starling.display.SLayer;

	public class ACocosLTest extends SLayer
	{
		public function ACocosLTest()
		{
			super();
			this.luaconsolefactory = function():ByteArray
			{
				return LuaResource.getLua("ACocosLTestLua.lua");
			}
			
			
		}
		
//		override protected function initialize():void
//		{
//			// TODO Auto Generated method stub
//			super.initialize();
//			var c:FeathersControl = this.getChildByNameDeep("mybutton") as FeathersControl;
//			var t:Tween = new Tween(c,10);
//			t.moveTo(0,c.y);
//			Starling.juggler.add(t);
//		}
		
		
	}
}