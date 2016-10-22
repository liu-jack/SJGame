package lib.engine.game.data.scene
{
	import lib.engine.game.data.GameData;
	
	/**
	 * 场景对象 
	 * @author caihua
	 * 
	 */
	public class GameData_SceneObject extends GameData
	{
		public function GameData_SceneObject()
		{
			super();
		}
		private var _name:String = new String();
		private var _depth:int = 0;
		private var _x:Number = 0.0;
		private var _y:Number = 0.0;
		private var _resource:String = new String();
		private var _collision:Boolean = false;
		private var _playspace:int = 1000;

		/**
		 * 深度 
		 */
		public function get depth():int
		{
			return _depth;
		}

		/**
		 * @private
		 */
		public function set depth(value:int):void
		{
			_depth = value;
		}

		/**
		 * 坐标 x
		 */
		public function get x():Number
		{
			return _x;
		}

		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			_x = value;
		}

		/**
		 * 坐标 y 
		 */
		public function get y():Number
		{
			return _y;
		}

		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			_y = value;
		}

		/**
		 * 名称 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 资源路径,文件标识::动画名称
		 */
		public function get resource():String
		{
			return _resource;
		}

		/**
		 * @private
		 */
		public function set resource(value:String):void
		{
			_resource = value;
		}

		/**
		 * 是否碰撞
		 */
		public function get collision():Boolean
		{
			return _collision;
		}

		/**
		 * @private
		 */
		public function set collision(value:Boolean):void
		{
			_collision = value;
		}

		/**
		 * 动画播放间隔 
		 */
		public function get playspace():int
		{
			return _playspace;
		}

		/**
		 * @private
		 */
		public function set playspace(value:int):void
		{
			_playspace = value;
		}


	}
}