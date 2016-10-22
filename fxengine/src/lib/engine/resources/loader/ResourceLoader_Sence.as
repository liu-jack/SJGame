package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.game.data.scene.GameData_Scene;
	import lib.engine.resources.ResourceType;

	public class ResourceLoader_Sence extends ResourceLoader
	{
		public function ResourceLoader_Sence()
		{
			super("scene", ResourceType.TYPE_SCENE);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			
			var obj:Object = JSON.parse(bytes.toString());
			var scene:GameData_Scene = new GameData_Scene();
			scene.UnPack(obj);
			return scene;
		}
		
	}
}