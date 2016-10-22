package SJ.Game.map
{
	import SJ.Game.player.CJPlayerBase;
	
	import starling.display.DisplayObject;
	
	/**
	 * 玩家场景控制类,主要针对玩家排序 
	 * @author caihua
	 * 
	 */
	public class CJPlayerSceneLayer extends MapLayer
	{
		public static const INVALIDATION_FLAG_ZORDER:String = "zorder";
		public function CJPlayerSceneLayer()
		{
			super();
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			if(isInvalid(INVALIDATION_FLAG_ZORDER))
			{
				//			若返回值为负，则表示 A 在排序后的序列中出现在 B 之前。
				//			若返回值为 0，则表示 A 和 B 具有相同的排序顺序。
				//			若返回值为正，则表示 A 在排序后的序列中出现在 B 之后。
				
				sortChildren(function(a:DisplayObject,b:DisplayObject):int
				{
					if(a is CJPlayerBase && b is CJPlayerBase)
					{
						if(a.y< b.y)
						{
							return -1;
						}
						else if(a.y == b.y)
						{
							return 0;
						}
						else
						{
							return 1;
						}
					}
					else
					{
						return 0;
					}
					
					
				});
			}
			super.draw();
		}
		
		override protected function initialize():void
		{
			// TODO Auto Generated method stub
			super.initialize();
		}
		
		public function sortPlayer():void
		{
			this.invalidate(INVALIDATION_FLAG_ZORDER);
		}
	}
}