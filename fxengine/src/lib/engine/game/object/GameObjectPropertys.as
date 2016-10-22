package lib.engine.game.object
{
	import flash.geom.Point;
	
	import lib.engine.game.Impact.GameObjectImpactManager;
	import lib.engine.platform.ConstVar;

	/**
	 * 游戏对象基类
	 * @author caihua
	 * 
	 */
	internal class GameObjectPropertys extends GameObjectRenderable
	{
		private var _name:String;
		private var _degree:Number = 0;
		private var _depth:Number = ConstVar.FRONT_DEPTH_MAX;
		private var _width:int;
		private var _height:int;
		private var _pos:Point = new Point();
		private var _alpha:Number = 1.0;		
		private var _visable:Boolean = true;
		private var _gameojectType:String = GameObjectType.Type_NormalObject;
		private var _Mouseable:Boolean = false;
		private var _lastUpdateTime:Number = 0;
		
		
		public function GameObjectPropertys()
		{
			
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		/**
		 * 宽度 
		 */
		public function get width():int
		{
			return _width;
		}

		/**
		 * @private
		 */
		public function set width(value:int):void
		{
			_width = value;
		}



		/**
		 * 高度 
		 */
		public function get height():int
		{
			return _height;
		}

		/**
		 * @private
		 */
		public function set height(value:int):void
		{
			_height = value;
		}




		/**
		 * x 
		 */
		public function get x():Number
		{
			return _pos.x;
		}

		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			_pos.x = value;
		}

		


		/**
		 * y 
		 */
		public function get y():Number
		{
			return _pos.y;
		}

		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			_pos.y = value;
		}


		
		protected var _Impact:GameObjectImpactManager;

		public function get Impact():GameObjectImpactManager
		{
			return _Impact;
		}

		public function get degree():Number
		{
			return _degree;
		}

		public function set degree(value:Number):void
		{
			_degree = value;
		}

		/**
		 * 对象深度 0为最上层
		 * 值越大越靠下
		 * 
		 * 
		 */
		public function get depth():Number
		{
			return _depth;
		}

		/**
		 * @private
		 */
		public function set depth(value:Number):void
		{
			_depth = value;
		}

		/**
		 * 是否可见 
		 */
		public function get visable():Boolean
		{
			return _visable;
		}

		/**
		 * @private
		 */
		public function set visable(value:Boolean):void
		{
			_visable = value;
		}

		public function get pos():Point
		{
			return _pos;
		}

		public function set pos(value:Point):void
		{
			_pos = value;
		}

		/**
		 * 对象Alpha值 
		 */
		public function get alpha():Number
		{
			return _alpha;
		}

		/**
		 * @private
		 */
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}

		/**
		 * 游戏对象类型
		 * GameObjectType
		 */
		public function get gameojectType():String
		{
			return _gameojectType;
		}

		/**
		 * @private
		 */
		public function set gameojectType(value:String):void
		{
			_gameojectType = value;
		}

		/**
		 * 是否相应鼠标事件 
		 */
		public function get Mouseable():Boolean
		{
			return _Mouseable;
		}

		/**
		 * @private
		 */
		public function set Mouseable(value:Boolean):void
		{
			_Mouseable = value;
		}

		public function get lastUpdateTime():Number
		{
			return _lastUpdateTime;
		}

		public function set lastUpdateTime(value:Number):void
		{
			_lastUpdateTime = value;
		}


	}
}