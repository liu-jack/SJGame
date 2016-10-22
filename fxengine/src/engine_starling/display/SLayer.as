package engine_starling.display
{
	import starling.display.DisplayObject;

	/**
	 * 界面布局 
	 * @author caihua
	 * 
	 */
	public class SLayer extends SNodeLuaWrapper
	{
		public function SLayer()
		{
			super();
		}
		
		/**
		 * 把组件加到某个特定的位置
		 * @param child
		 * @param x
		 * @param y
		 */		
		public function addChildTo(child:DisplayObject , x:Number , y:Number):void
		{
			child.x = x ;
			child.y = y ;
			this.addChild(child);
		}
		
		
		

	}
}