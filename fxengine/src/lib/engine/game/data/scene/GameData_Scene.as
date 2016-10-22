package lib.engine.game.data.scene
{
	import lib.engine.game.data.GameData;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 场景数据对象 
	 * @author caihua
	 * 
	 */
	public class GameData_Scene extends GameData
	{
		public function GameData_Scene()
		{
			super();
		}
		private var _name:String = new String();
		private var _width:int = 0;
		private var _height:int = 0;
		private var _tilesizewidth:int = 0;
		private var _tilesizeheight:int = 0;
		private var _sceneobjects:ArrayCollection = new ArrayCollection();
	

		/**
		 * 场景名称 
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
		 * 场景宽度 
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
		 * 场景高度 
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

//		/**
//		 * 地表贴图大小 
//		 */
//		public function get tilesize():Point
//		{
//			return _tilesize;
//		}
//
//		/**
//		 * @private
//		 */
//		public function set tilesize(value:Point):void
//		{
//			_tilesize = value;
//		}


		/**
		 * 添加场景对象 
		 * @param sceneobject
		 * 
		 */
		public function addsceneobject(sceneobject:GameData_SceneObject):void
		{
			_sceneobjects.addItem(sceneobject);
		}
		/**
		 * 获取场景对象 
		 * @return 
		 * 
		 */
		public function getsceneobjects():ArrayCollection
		{
			return _sceneobjects;
		}
		/**
		 * 删除场景对象 
		 * @param obj
		 * 
		 */
		public function remove(obj:GameData_SceneObject):void
		{
			if(_sceneobjects.contains(obj))
			{
				_sceneobjects.removeItemAt(_sceneobjects.getItemIndex(obj));
			}
		}
		/**
		 * 清除所有场景对象 
		 * 
		 */
		public function removeAll():void
		{
			_sceneobjects.removeAll();
		}
		
		
		override public function Pack():Object
		{
			var obj:Object = super.Pack();
			obj.sceneobjects = new Array();
			for each(var msceneobject:GameData_SceneObject in _sceneobjects)
			{
				obj.sceneobjects.push(msceneobject.Pack());
			}
			return obj;
		}
		
		override public function UnPack(obj:Object):void
		{
			
			super.UnPack(obj);
			//删除对象
			removeAll();
			
			var sceneobjects:Array = obj.sceneobjects;
			
			for each(var msceneobject:Object in sceneobjects)
			{
				var mscene:GameData_SceneObject = new GameData_SceneObject();
				mscene.UnPack(msceneobject);
				addsceneobject(mscene);
			}
		}

		public function get tilesizewidth():int
		{
			return _tilesizewidth;
		}

		public function set tilesizewidth(value:int):void
		{
			_tilesizewidth = value;
		}

		public function get tilesizeheight():int
		{
			return _tilesizeheight;
		}

		public function set tilesizeheight(value:int):void
		{
			_tilesizeheight = value;
		}

		
	}
}