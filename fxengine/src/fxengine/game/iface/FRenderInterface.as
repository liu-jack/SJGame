package fxengine.game.iface
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public interface FRenderInterface
	{
		/**
		 * 渲染接口 
		 * @param g 渲染对象
		 * 
		 */
		function render(g:BitmapData,offset:Rectangle):void;
	}
}