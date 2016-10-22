package fxengine.utils
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import fxengine.FXEngineConfig;

	public class FPathUtils
	{
		
		private static var _o:FPathUtils = null;
		
		public static function get o():FPathUtils
		{
			if(_o == null)
			{
				_o = new FPathUtils();
			}
			return _o;
		}
		
		public function FPathUtils()
		{
		}
		
		public static function Path2URL(Path:String):String
		{
			return null;
		}
		
		/**
		 * 取得路径中的后缀
		 * 
		 * @param	路径
		 * @return  null：路径无效，or 后缀，不包含"."
		 */
		public function getPathExt(path:String):String
		{
			var extidx:int = path.lastIndexOf(".");
			if (extidx == -1)
			{
				return "";
			}
			
			var rtn:String = path.substr(extidx + 1);
			return rtn;
		}
		
		/**
		 * Air 库 转换资源路径
		 * @param filename
		 * @return 
		 * 
		 */
		public function convertResourcePath(filename:String):String
		{
			//检测本地是缓存否存在这个文件
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + FXEngineConfig.o.resourceCachePath + filename;
			var file:File = new File(filePath);
			if(file.exists)
			{
				return filePath;
			}
			
			//检测程序包里面是否有这个文件
			filePath = "app:/"+ FXEngineConfig.o.resourceCachePath + filename;
			file = new File(filePath);
			if(file.exists)
			{
				return filePath;
			}
			
			return FXEngineConfig.o.resourceRemoteBasePath + filename;
		}
		
		
		/**
		 * 同步读取文件内容到 内存中 Air方法 
		 * @param filePath
		 * @param outBuffer
		 * @return 
		 * 
		 */
		public function readFileToByteArray(filePath:String,outBuffer:ByteArray):Boolean
		{
			var file:File = null;
			try{
				file = new File(filePath);
				if(!file.exists)
				{
					return false;
				}
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				fs.readBytes(outBuffer);
				fs.close();
			
			}
			catch(e:ArgumentError)
			{
				return false;
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		
		/**
		 * 异步文件类 Air
		 * @param filePath
		 * @param LoadComplete 完成回调行数 (buffer:byteArray):void
		 * @return 
		 * 
		 */
		public function readFileToByteArrayAsync(filePath:String,LoadComplete:Function):Boolean
		{
			var file:File = null;
			try{
				file = new File(filePath);
				if(!file.exists)
				{
					return false;
				}
				var fs:FileStream = new FileStream();
				fs.addEventListener(Event.COMPLETE,function complate(e:Event):void
				{
					var outBuffer:ByteArray = new ByteArray();
					fs.readBytes(outBuffer);
					fs.close();
					
					LoadComplete(outBuffer);
				});
				fs.openAsync(file,FileMode.READ);
			
				
			}
			catch(e:ArgumentError)
			{
				return false;
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		

	}
}