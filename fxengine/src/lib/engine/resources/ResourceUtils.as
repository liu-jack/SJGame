package lib.engine.resources
{
	import flash.display.LoaderInfo;
	
	import lib.engine.data.CEngineData;
	
	public class ResourceUtils
	{
		public function ResourceUtils()
		{
		}
		/**
		 * 资源索引转换为路径 
		 * @param key
		 * @return null 转换失败
		 * 
		 */		
		public static function key2ResPath(key:String,resPath:String):String
		{
			var Path:String = resPath + "/" + key;
			//			var file:File = new File(Path);
			//			if(file.exists)
			//				return Path;
			return Path.replace(/\\/g , "/");
			
		}
		
		/**
		 * 资源路径转换为关键字 
		 * url:http://img1.kaixin008.com.cn/res/main/island-1.swf?r=abc
		 * key:main.island
		 * @param key
		 * @param resPath
		 * @return key的格式 第一个不是 "/"
		 * 
		 * 如果资源是另外的绝对路径,则直接返回绝对路径
		 * 例如 入http://img.kaixin001.com.cn/i/50_1_0.gif
		 * 返回 http://img.kaixin001.com.cn/i/50_1_0.gif
		 * 
		 */
		public static function ResPath2Key(Path:String):String
		{
			//统一 \为/
			
			var url:String = Path.replace(/\\/g , "/");
			
			//捕获val
			var validx:int = CEngineData.o.ResourcePath.indexOf("swf");
			var val:String = CEngineData.o.ResourcePath.substr(validx);
			
			
			
			
			var valpos:int = url.indexOf(val);
			if(-1 != valpos)
			{
				url = url.substr(valpos + val.length);
				val = "/";
				valpos = url.indexOf('/');
				if(valpos == -1)
				{
					return '';
				}
				url = url.substr(valpos + val.length);
				
				var pos:int = url.indexOf(".");
				if(-1 != pos)
				{
					url = url.substr(0 , pos);
				}
				pos = url.lastIndexOf("-");
				if(-1 != pos)
				{
					url = url.substr(0 , pos);
				}
				url = url.replace(/\//g , ".");
				return url;
			}
			return url;
		}
		
		
		/**
		 * 资源绝对路径转换相对路径 
		 * @param Path 绝对路径 
		 * 例如 ../swf/fish/data/InitLoader.Group
		 * 注意:如果 为 ..\swf\fish\data\InitLoader.Group 返回也是 /
		 * resPath 资源路径
		 * 例如 ../swf/fish
		 * @return 
		 * data/InitLoader.Group
		 * 
		 * 如果资源是另外的绝对路径,则直接返回绝对路径
		 * 例如 入http://img.kaixin001.com.cn/i/50_1_0.gif
		 * 返回 http://img.kaixin001.com.cn/i/50_1_0.gif
		 * 
		 */
		public static function ResAbsolutePath2RelativePath(Path:String):String
		{
			var nPath:String = Path.replace(/\\/g , "/");
			var nResPath:String = CEngineData.o.ResourcePath.replace(/\\/g , "/");
			var idx:int = nPath.indexOf(nResPath + "/");
			if(idx == -1)
				return Path;
			return nPath.replace(nResPath + "/","");
		}
		
		
		/**
		 * 资源相对路径转换绝对路径 
		 * @param Path 相对路径
		 * 例如 data/InitLoader.Group <br>
		 * CEngineData.o.ResourcePath 为 ../swf/fish
		 * @return ../swf/fish/data/InitLoader.Group\
		 * 
		 * 如果资源是另外的绝对路径,则直接返回绝对路径
		 * 例如 入http://img.kaixin001.com.cn/i/50_1_0.gif
		 * 返回 http://img.kaixin001.com.cn/i/50_1_0.gif
		 * 
		 */
		public static function ResRelativePath2AbsolutePath(Path:String):String
		{
			var nPath:String = Path.replace(/\\/g , "/");
			var nResPath:String = CEngineData.o.ResourcePath.replace(/\\/g , "/");
			
			var sPath:String = nPath.toLocaleLowerCase();
			if(sPath.indexOf("http://")!= -1)
			{
				return nPath;
			}
			else
			{
				return nResPath + "/" + nPath;
			}
		}
		/**
		 * 返回资源中的类声明 
		 * @param res 资源
		 * @param classname 类名称
		 * @return 类
		 * 如果返回空,则说明类不存在
		 * 
		 */
		public static function Res2Class(res:Resource,classname:String):Class
		{
			var classagent:LoaderInfo = res.value as LoaderInfo;	
			var cls:Class = null;
			if(classname == null || classname == "")
			{
				return null;
			}
			else
			{
				if(classagent.applicationDomain.hasDefinition(classname)){
					cls = classagent.applicationDomain.getDefinition(classname) as Class;
				}
			}
			return cls;
		}
	}
}