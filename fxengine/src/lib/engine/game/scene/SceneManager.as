package lib.engine.game.scene
{
	import lib.engine.game.Canvas.GameCanvas;
	import lib.engine.game.data.anim.GameData_AnimGroup;
	import lib.engine.game.data.scene.GameData_Scene;
	import lib.engine.game.data.scene.GameData_SceneObject;
	import lib.engine.game.module.CModuleSubSystem;
	import lib.engine.game.object.GameObjectAnim;
	import lib.engine.game.object.GameObjectType;
	import lib.engine.resources.Resource;
	import lib.engine.resources.ResourceManager;
	import lib.engine.utils.CTimerUtils;
	
	import mx.collections.ArrayCollection;

	/**
	 * 场景管理器 
	 * @author caihua
	 * 
	 */
	public class SceneManager extends CModuleSubSystem
	{
		private var _gamecanvas:GameCanvas;
		private var _scenedata:GameData_Scene;
		/**
		 * 场景对象容器 
		 */
		private var _sceneObjects:ArrayCollection;
		public function SceneManager(gamecanvas:GameCanvas)
		{
			super("SceneManager" + CTimerUtils.getCurrentTime());
			_gamecanvas = gamecanvas;
		}
		
		
		override protected function _onInit(params:Object = null):void
		{
			_sceneObjects = new ArrayCollection();
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			clear();
		}
		
		
		
		/**
		 * 加载配置文件,场景资源 
		 * @param res
		 * 
		 */
		public function Load(res:Resource):void
		{
			clear();
			_scenedata = res.value;
			var sceneobjects:ArrayCollection = _scenedata.getsceneobjects();
			for each(var msceneObject:GameData_SceneObject in sceneobjects)
			{
				AddSceneObject(msceneObject);
			}
		}
		
		public function AddSceneObject(SceneObject:GameData_SceneObject):void
		{
			var resourcekey:String = SceneObject.resource.split("::")[0];
			var animName:String = SceneObject.resource.split("::")[1];
			
			var res:Resource = ResourceManager.o.getResByPath(resourcekey);
			var animGroup:GameData_AnimGroup = res.value;
			var anim:GameObjectAnim = new GameObjectAnim();
			anim.load(animGroup,animName,Math.random() * 100);
			anim.x = SceneObject.x;
			anim.y = SceneObject.y;
			anim.gameojectType = GameObjectType.Type_SceneObject;
			anim.depth = SceneObject.depth;
			anim.loop = true;
			anim.Mouseable = false;
			anim.playspace = SceneObject.playspace;
			anim.register(_gamecanvas);
			_sceneObjects.addItem({'obj':SceneObject,'gameobject':anim});
		}
		
		public function clear():void
		{
			for each(var obj:Object in _sceneObjects)
			{
				_gamecanvas.removeGameObject(obj.gameobject);
			}
			_sceneObjects.removeAll();
		}
	}
}