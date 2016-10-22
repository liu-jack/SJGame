package SJ.Game.utils
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SPathUtils;

	public class LuaResource
	{
		public function LuaResource()
		{
		}
		
		/**
		 * 从文件系统加载，主要用于开发阶段 
		 */
		CONFIG::localver public static const loadFromFileSystem:Boolean = true;
		CONFIG::onlinever public static const loadFromFileSystem:Boolean = false;
		/**
		 * 
		 * 获取lua资源 代理
		 * @param name
		 * @return 
		 * 
		 */
		public static function getLua(name:String):ByteArray
		{
			if(loadFromFileSystem)
			{
				var b:ByteArray = new ByteArray();
				var filepath:String = File.applicationDirectory.nativePath + "\\" + name;
				SPathUtils.o.readFileToByteArray(filepath,b);
				return b;
			}
			else
			{
				return AssetManagerUtil.o.getObject(name) as ByteArray;
			}
			return null;
		}
	}
}