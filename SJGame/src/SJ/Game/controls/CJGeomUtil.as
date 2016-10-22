package SJ.Game.controls
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *	坐标转换
	 */
	final public class CJGeomUtil
	{
		public static var GRID_WIDTH:int;
		public static var GRID_HEIGHT:int;
		public static var OFFSET:Point;

		public function CJGeomUtil()
		{
		}

		/**
		 * 初始化
		 */
		public static function init(gridWidth:int, gridHeight:int, offset:Point):void
		{
			GRID_WIDTH = gridWidth;
			GRID_HEIGHT = gridHeight;
			OFFSET = offset;
		}

		/**
		 * 逻辑坐标转CLayerRoom象素坐标
		 *	pos(head)
		 *	/\
		 *	\/
		 *	pos(tail)
		 * @param	logicPos	逻辑坐标
		 * @param	site		定位基准
		 * @return	flash坐标
		 */
		public static function logic2room(logicPos:Point, site:String = "head"):Point
		{
			var offsetx:int = logicPos.x - logicPos.y;
			var offsety:int = logicPos.x + logicPos.y;

			var topx:Number = offsetx * GRID_WIDTH / 2;
			var topy:Number = offsety * GRID_HEIGHT / 2;

			if ("tail" == site)
			{
				topy -= GRID_HEIGHT / 2;
			}

			var roomPos:Point = new Point(topx, topy);
			roomPos = roomPos.add(OFFSET);
			return roomPos;
		}

		/**
		 * CLayerRoom象素坐标转逻辑坐标
		 *	pos
		 *	/\
		 *	\/
		 *
		 * 由鼠标点击坐标算逻辑坐标不会出现精度丢失，精度丢失发生在。
		 * 由逻辑坐标转换成flash坐标，再由flash坐标转换成逻辑坐标是，如果出现取整，就会出现精度丢失。
		 * 详见代码注释
		 *
		 * @param	roomPos	flash坐标
		 * @param	method	精度控制，主要是为了处理二次转化问题。
		 * @return	逻辑坐标
		 */
		public static function room2logic(roomPos:Point, method:String = "floor"):Point
		{
			roomPos = roomPos.subtract(OFFSET);
			var rPos:Point = new Point(roomPos.x, roomPos.y);
			var logicPos:Point

			if (method == "floor") // 舍去小数点算逻辑坐标，发生在不是二次转化的情况下，例如，鼠标点击，算鼠标的逻辑坐标，按菱形顶点
			{
				logicPos = new Point(Math.floor(rPos.y / GRID_HEIGHT + rPos.x / GRID_WIDTH), Math.floor(rPos.y / GRID_HEIGHT - rPos.x / GRID_WIDTH));
			}
			else if (method == "ceil") //  	加一取整算逻辑坐标，发生在二次转化情况下，
			{ //		例如，按逻辑坐标，设置物体room坐标,菱形顶点，然后再按room坐标，算逻辑坐标，
				// 	如果这时有舍弃会出现逻辑坐标丢失
				logicPos = new Point(Math.ceil(rPos.y / GRID_HEIGHT + rPos.x / GRID_WIDTH), Math.ceil(rPos.y / GRID_HEIGHT - rPos.x / GRID_WIDTH));
			}

			return logicPos;
		}

		/**
		 * 计算addChild象素位置
		 * @param	logicPos	逻辑坐标
		 * @param	size		占位大小
		 * @return	add到flash的坐标
		 * 量大时效率有些问题
		 */
		public static function logic2add(logicPos:Point, size:Point):Point
		{
			var roomPos:Point = CJGeomUtil.logic2room(logicPos);
			var addPos:Point = roomPos.add(new Point(-size.y * GRID_WIDTH / 2, 0));
			//var addPos = roomPos;
			return addPos;
		}

		/**
		 * 将fromContainer中的startPos位置转换成相对于toContainer的位置
		 * @param	startPos
		 * @param	fromContainer
		 * @param	toContainer
		 * @return
		 */
		public static function translate(startPos:Point, fromContainer:DisplayObjectContainer, toContainer:DisplayObjectContainer):Point
		{
			if (startPos == null || fromContainer == null || toContainer == null)
			{
				return null;
			}
			var globalStart:Point = fromContainer.localToGlobal(startPos);
			var localTo:Point = toContainer.globalToLocal(globalStart);
			return localTo;
		}

		/**
		 * 由一个指定的定位容器，找到这个定位容器在指定的层上面
		 * @param	container
		 * @param	targetContainer
		 * @return
		 */
		public static function translate2nd(container:DisplayObject, targetContainer:DisplayObjectContainer):Point
		{
			var bounds:Rectangle = container.getBounds(targetContainer);
			return bounds.topLeft;
		}
	}
}
