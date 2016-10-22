package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.game.data.anim.GameData_AnimGroup;
	import lib.engine.resources.ResourceType;

	public class ResourceLoader_AnimGroup extends ResourceLoader
	{
		public function ResourceLoader_AnimGroup()
		{
			super("anim", ResourceType.TYPE_ANIMGROUP);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			var obj:Object = JSON.parse(bytes.toString());
			var group:GameData_AnimGroup = new GameData_AnimGroup();
			group.UnPack(obj);
			return group;
		}
		
		
	}
}