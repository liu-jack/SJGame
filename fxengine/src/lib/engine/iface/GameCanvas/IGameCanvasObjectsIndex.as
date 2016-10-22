package lib.engine.iface.GameCanvas
{
	import flash.geom.Rectangle;
	
	import lib.engine.game.object.GameObject;
	
	/**
	 * Canvas游戏对象接口 
	 * @author caihua
	 * 
	 */
	public interface IGameCanvasObjectsIndex
	{
		/**
		 * 添加游戏对象 
		 * @param mGameObject
		 * 
		 */
		function add(mGameObject:GameObject):void;
		/**
		 * 删除游戏对象
		 * @param mGameObject
		 * 
		 */
		function remove(mGameObject:GameObject):void;
		/**
		 * 当索引发生变化的时候 
		 * @param mGameObject
		 * 
		 */
		function modify(mGameObject:GameObject):void;
		/**
		 * 获取渲染对象 
		 * @param viewport 视口
		 * @return 对象的Vec
		 * 
		 */
		function getRenderObjects(viewport:Rectangle,destVec:Vector.<GameObject>):void;
		/**
		 * 获取更新对象 
		 * @param viewport 视口
		 * @return 对象的Vec
		 * 
		 */
		function getUpdateObjects(viewport:Rectangle,destVec:Vector.<GameObject>,currenttime:Number, escapetime:Number):void;
		
		/**
		 * 获取点击对象 
		 * @param viewport 视口
		 * @return 对象的Vec
		 * 
		 */
		function getClickObjects(viewport:Rectangle,destVec:Vector.<GameObject>):void;
		
	}
}