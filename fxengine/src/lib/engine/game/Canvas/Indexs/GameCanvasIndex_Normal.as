package lib.engine.game.Canvas.Indexs
{
	import flash.geom.Rectangle;
	
	import lib.engine.game.object.GameObject;
	import lib.engine.iface.GameCanvas.IGameCanvasObjectsIndex;
	
	/**
	 * 普通索引 
	 * @author caihua
	 * 
	 */
	public class GameCanvasIndex_Normal implements IGameCanvasObjectsIndex
	{
		private var _objectsContains:Vector.<GameObject>;
		private var _lastupdatetime:Number = 0;
		public function GameCanvasIndex_Normal()
		{
			_objectsContains = new Vector.<GameObject>();
		}
		
		
		public function add(mGameObject:GameObject):void
		{
			var i:int = 0;
			for(i = 0;i<_objectsContains.length;i++)
			{
				if(_objectsContains[i].depth > mGameObject.depth)
				{
					break;
				}
			}
			//全局缓存
			_objectsContains.splice(i,0,mGameObject);
		}
		public function remove(mGameObject:GameObject):void
		{
			var idx:int = _objectsContains.lastIndexOf(mGameObject);
			if(idx != -1)
			{
				_objectsContains.splice(idx,1);
			}
		}
		
		public function modify(mGameObject:GameObject):void
		{
			var idx:int = _objectsContains.lastIndexOf(mGameObject);
			if(idx == -1)
				return;
			var obj:Object = _objectsContains.splice(idx,1);
			var i:int = 0;
			for(i = 0;i<_objectsContains.length;i++)
			{
				if(_objectsContains[i].depth > mGameObject.depth)
				{
					break;
				}
			}
			_objectsContains.splice(i,0,obj[0]);
		}
		
		public function getRenderObjects(viewport:Rectangle,destVec:Vector.<GameObject>):void
		{
			for each(var mGameObject:GameObject in _objectsContains)
			{
				if(viewport.containsPoint(mGameObject.pos) && mGameObject.visable)
				{
					destVec.push(mGameObject);
				}
				
			}
		}
		public function getUpdateObjects(viewport:Rectangle,destVec:Vector.<GameObject>,currenttime:Number, escapetime:Number):void
		{
			_lastupdatetime += escapetime;
			if(_lastupdatetime > 1000)
			{
				_lastupdatetime = 0;
				for each(var mGameObject:GameObject in _objectsContains)
				{
					destVec.push(mGameObject);	
				}
			}
			else
			{
				for each( mGameObject in _objectsContains)
				{
					if(viewport.containsPoint(mGameObject.pos))
					{
						destVec.push(mGameObject);
					}
					
				}
			}
			
		}
		
		public function getClickObjects(viewport:Rectangle,destVec:Vector.<GameObject>):void
		{
			for each(var mGameObject:GameObject in _objectsContains)
			{
				if(viewport.containsPoint(mGameObject.pos))
				{
					destVec.push(mGameObject);
				}
			}
		}
		
	}
}