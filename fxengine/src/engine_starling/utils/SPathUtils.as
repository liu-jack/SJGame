package engine_starling.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import lib.engine.utils.functions.Assert;

	public class SPathUtils
	{
		
		private static var _o:SPathUtils = null;
		
		public static function get o():SPathUtils
		{
			if(_o == null)
			{
				_o = new SPathUtils();
			}
			return _o;
		}
		
		public function SPathUtils()
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
		 * 取得路径中去掉后缀的部分
		 * @param path 路径
		 * @return 无后缀:返回path, 有后缀:去掉后缀的path
		 * 
		 */
		public static function getPathPre(path:String):String
		{
			var extidx:int = path.lastIndexOf(".");
			if (extidx == -1)
			{
				return path;
			}
			
			var rtn:String = path.substr(0, extidx);
			return rtn;
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
				fs.addEventListener(IOErrorEvent.IO_ERROR,function (e:Event):void
				{
					LoadComplete(null);
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
		public function readFileToByteArrayAsyncUrl(filePath:String,LoadComplete:Function):Boolean
		{
			var file:File = null;
			try{
				file = new File(filePath);
				if(!file.exists)
				{
					return false;
				}
				
				
				var resourceLoader:URLLoader = new URLLoader();
				resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
				resourceLoader.addEventListener(Event.COMPLETE,_onComplete);
				resourceLoader.addEventListener(IOErrorEvent.IO_ERROR,_onIOError);
				resourceLoader.load(new URLRequest(file.url));
				
				
				function _onComplete(e:Event):void
				{
					resourceLoader.removeEventListener(Event.COMPLETE,_onComplete);
					resourceLoader.removeEventListener(IOErrorEvent.IO_ERROR,_onIOError);
					file = null;
					var loader:URLLoader = e.target as URLLoader;
					
					//加载数据详情
					LoadComplete(loader.data);
					//loader.data.clear();
					
				}
				function _onIOError(e:Event):void
				{
					Assert(false,"readFileToByteArrayAsyncUrl资源读取失败!{0}",filePath);
					//加载数据详情
					LoadComplete(null);
				}
				

				
				
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
		 * 追加字节到文本末尾 
		 * @param bytes
		 * @param filePath
		 * @return 
		 * 
		 */
		public function AppendByteArrayToFile(bytes:ByteArray,filePath:String):Boolean
		{
			var file:File = null;
			try{
				file = new File(filePath);
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.APPEND);
				fs.writeBytes(bytes);
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
		
		public function WriteByteArrayToFileAsync(bytes:ByteArray,filePath:String):void
		{
			var file:File = null;
			try{
				var wbyte:ByteArray = new ByteArray();
				wbyte.writeBytes(bytes);
				file = new File(filePath);
				var fs:FileStream = new FileStream();
				fs.addEventListener(Event.COMPLETE,function complate(e:Event):void
				{
					fs.writeBytes(wbyte);
					fs.close();
					
				});
				
				
				fs.openAsync(file,FileMode.WRITE);
				
				
			}
			catch(e:ArgumentError)
			{
				return ;
			}
			catch(e:Error)
			{
				return ;
			}
			return ;
		}
		public function WriteByteArrayToFile(bytes:ByteArray,filePath:String):Boolean
		{
			var file:File = null;
			try{
				file = new File(filePath);
				var fs:FileStream = new FileStream();
				
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(bytes);
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
		 * 获取文件列表 
		 * @param path 文件后缀名称 包括“.",不区分大小写,文件后缀数组
		 * 
		 * @return 
		 * 
		 */
		public function getFileList(path:File,filter:Array):Array
		{
			var ret:Array = new Array();
			var mfilterArray:Array = new Array();
			for each(var mfilter:String in filter)
			{
				mfilterArray.push(mfilter.toLowerCase());
			}
			_getfilepop(path,ret,mfilterArray);
			path.nativePath.lastIndexOf();
			return ret;
		}
		
		private  function _getfilepop(path:File,ret:Array,filter:Array):void
		{
			if(!path.isDirectory)/*是文件*/
			{
				var extidx:int = path.nativePath.lastIndexOf(".");
				if(extidx == -1)
					return;
				var ext:String = path.nativePath.substr(extidx).toLowerCase();
				for each(var mfilter:String in filter)
				{
					if(ext == mfilter)
					{
						ret.push(path);
					}
				}
			}
			else
			{
				for each(var f:File in path.getDirectoryListing())
				{
					_getfilepop(f,ret,filter);
				}
			}
		}
		
		
		/**
		 * 搜索文件 
		 * @param searchpath 需要查找的路径
		 * @param searchfilename 查找全称
		 * @param includeChild 是否包含子目录
		 * @return 
		 * 
		 */
		public function searchfile(searchpath:String,searchfilename:String,includeChild:Boolean = true):File
		{
			return _searchfile(new File(	searchpath),searchfilename,includeChild);
		}
		
		private function _searchfile(searchpath:File,searchfilename:String,includeChild:Boolean):File
		{
			if(!searchpath.isDirectory)//是文件
			{
				if(searchpath.name == searchfilename)
				{
					return searchpath;
				}
				else
				{
					return null;
				}
			}
			else
			{
				var filearr:Array = searchpath.getDirectoryListing();
				var length:int = filearr.length;
				for(var i:int=0;i<length;i++)
				{
					if(_searchfile(filearr[i] as File,searchfilename,includeChild) != null)
					{
						return searchpath;
					}
				}

			}
			return null;
		}

	}
}