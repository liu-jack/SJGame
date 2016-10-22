package lib.engine.iface.game
{
	import flash.geom.Rectangle;
	
	import lib.engine.game.bitmap.GBitmap;

	/**
	 * 渲染接口 
	 * @author caihua
	 * 
	 */
	public interface IGameRenderable extends IGameUpdate
	{
		/**
		 * 渲染接口 
		 * @param g 渲染对象
		 * 
		 */
		function render(g:GBitmap,offset:Rectangle):void;
		
	}
}