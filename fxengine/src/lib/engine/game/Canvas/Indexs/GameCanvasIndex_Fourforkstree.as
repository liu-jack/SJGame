package lib.engine.game.Canvas.Indexs
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lib.engine.game.object.GameObject;
	import lib.engine.iface.GameCanvas.IGameCanvasObjectsIndex;
	
	/**
	 * 四叉树索引 
	 * @author caihua
	 * 
	 */
	public class GameCanvasIndex_Fourforkstree implements IGameCanvasObjectsIndex
	{
		/**
		 * 宽度最大索引值 
		 */
		private static const X_Count_Max:int = 1000;
		/**
		 *  索引范围
		 */
		private var _indexextends:Point = new Point(1024,768);
		private var _objectsContains:Array = new Array();
		private var _lastupdatetime:Number = 0;
		public function GameCanvasIndex_Fourforkstree()
		{
			//			_objectsContains = new Vector.<GameObject>();
		}
		
		public function add(mGameObject:GameObject):void
		{
			var Containsidx:int  =_computeGameObjectIndex(mGameObject.pos);
			if(_objectsContains[Containsidx] == null)
			{
				_objectsContains[Containsidx] = new Vector.<GameObject>();
				
			}
			_objectsContains[Containsidx].push(mGameObject);
			
		}
		
		public function remove(mGameObject:GameObject):void
		{
			var Containsidx:int  =_computeGameObjectIndex(mGameObject.pos);
			var _objects:Vector.<GameObject> = _objectsContains[Containsidx];
			if( _objects != null)
			{
				var idx:int = _objects.lastIndexOf(mGameObject);
				if(idx != -1)
				{
					_objects.splice(idx,1);
				}
			}
		}
		
		public function modify(mGameObject:GameObject):void
		{
		}
		
		public function getRenderObjects(viewport:Rectangle, destVec:Vector.<GameObject>):void
		{
			
			for(var i:int = 0;i<2;i++)
			{
				for(var j:int = 0;j<2;j++)
				{
					var container:Vector.<GameObject> = _objectsContains[this.getContainer(viewport,j,i)];
					if(container==null)
						continue;
					
					for each(var mGameObject:GameObject in container)
					{
						if(viewport.containsPoint(mGameObject.pos) && mGameObject.visable)
						{
							for(var k:int = 0;k<destVec.length;k++)
							{
								if(destVec[k].depth > mGameObject.depth)
								{
									break;
								}
							}
							//全局缓存
							destVec.splice(k,0,mGameObject);
							
						}
					}
					
					
				}
				
			}
		}
		private function _getUpdateObjects_lv0(viewport:Rectangle, destVec:Vector.<GameObject>):void
		{
			for(var i:int = 0;i<2;i++)
			{
				for(var j:int = 0;j<2;j++)
				{
					var containeridx:int = this.getContainer(viewport,j,i);
					var vec:Vector.<GameObject> = _objectsContains[containeridx];
					if(vec==null)
						continue;
					
					
					var mChangevec:Vector.<GameObject> = new Vector.<GameObject>();
					
					for each(var mGameObject:GameObject in vec)
					{
						if(_computeGameObjectIndex(mGameObject.pos) != containeridx)
						{
							mChangevec.push(mGameObject);
						}
						destVec.push(mGameObject);
					}
					
					for each( mGameObject in mChangevec)
					{
						var idx:int = vec.indexOf(mGameObject);
						vec.splice(idx,1);
						add(mGameObject);
					}
				}
			}
		}
		private function _getUpdateObjects_lv1(viewport:Rectangle, destVec:Vector.<GameObject>):void
		{
			for(var i:int = 0;i<2;i++)
			{
				for(var j:int = 0;j<2;j++)
				{
					var containeridx:int = this.getContainer(viewport,j,i);
					var vec:Vector.<GameObject> = _objectsContains[containeridx];
					if(vec==null)
						continue;
					
					
					var mChangevec:Vector.<GameObject> = new Vector.<GameObject>();
					
					for each(var mGameObject:GameObject in vec)
					{
						if(_computeGameObjectIndex(mGameObject.pos) != containeridx)
						{
							mChangevec.push(mGameObject);
						}
						destVec.push(mGameObject);
					}
					
					for each( mGameObject in mChangevec)
					{
						var idx:int = vec.indexOf(mGameObject);
						vec.splice(idx,1);
						add(mGameObject);
					}
				}
			}
		}
		private function _getUpdateObjects_lv2(viewport:Rectangle, destVec:Vector.<GameObject>):void
		{
			for (var key:String in _objectsContains)
			{
				
				var mChangevec:Vector.<GameObject> = new Vector.<GameObject>();
				var vec:Vector.<GameObject> = _objectsContains[key];
				
				for each(var mGameObject:GameObject in vec)
				{
					if(_computeGameObjectIndex(mGameObject.pos) != int(key))
					{
						mChangevec.push(mGameObject);
					}
					destVec.push(mGameObject);
				}
				
				for each( mGameObject in mChangevec)
				{
					var idx:int = vec.indexOf(mGameObject);
					vec.splice(idx,1);
					add(mGameObject);
				}
			}
		}
		public function getUpdateObjects(viewport:Rectangle, destVec:Vector.<GameObject>,currenttime:Number, escapetime:Number):void
		{
			_lastupdatetime += escapetime;
			if(_lastupdatetime > 1000)
			{
				_lastupdatetime = 0;
				_getUpdateObjects_lv2(viewport,destVec);
			}
			else
			{
				_getUpdateObjects_lv0(viewport,destVec);
			}
		}
		
		public function getClickObjects(viewport:Rectangle, destVec:Vector.<GameObject>):void
		{
			getRenderObjects(viewport,destVec);
		}
		
		/**
		 * 计算对象的索引指 
		 * @param gObject
		 * @return 
		 * 
		 */
		private function _computeGameObjectIndex(pos:Point):int
		{
			return int(pos.x / _indexextends.x) + int(pos.y / _indexextends.y) * X_Count_Max;
		}
		
		
		/**
		 * 获取容器索引 
		 * @param offsetx 偏移位置x
		 * @param offsety 偏移位置y
		 * @return 
		 * 
		 */
		private function getContainer(viewport:Rectangle,offsetx:int = 0,offsety:int = 0):int
		{
			var basex:int = viewport.x / viewport.width < 0 ? 0 :viewport.x / viewport.width;
			var basey:int = viewport.y / viewport.height < 0 ? 0 :viewport.y / viewport.height;
			return (basey + offsety) * X_Count_Max + basex + offsetx;
		}
	}
}