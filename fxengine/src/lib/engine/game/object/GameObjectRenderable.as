package lib.engine.game.object
{
	import flash.geom.Rectangle;
	
	import lib.engine.game.bitmap.GBitmap;
	import lib.engine.iface.game.IGameRenderable;

	/**
	 * 游戏渲染基类 
	 * @author caihua
	 * 
	 */
	public class GameObjectRenderable extends GameObjectBase implements IGameRenderable
	{
		private var _isInit:Boolean = false;
		public function GameObjectRenderable()
		{
			super();
		}
		

		
		public function update(currenttime:Number, escapetime:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		public function render(g:GBitmap, offset:Rectangle):void
		{
			// TODO Auto Generated method stub
			
		}
		/**
		 * 初始化 
		 * 
		 */
		public final function Init():void
		{
			if(!_isInit)
			{
				onInit();
				_isInit = true;
			}
		}
		
		protected function onInit():void
		{
			
		}
		
//		public function _onMouseMove(e:MouseEvent):void{};
		

		
	}
}