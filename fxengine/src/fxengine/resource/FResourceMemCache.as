package fxengine.resource
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import fxengine.FXEngineConfig;
	import fxengine.utils.FPathUtils;
	
	/**
	 * 资源管理器 
	 * @author caihua
	 * 
	 */
	public class FResourceMemCache
	{
		
		private static var _o:FResourceMemCache = null;
		
		public static function get o():FResourceMemCache
		{
			if(_o == null)
			{
				_o = new FResourceMemCache();
			}
			return _o;
		}
		
		
		
		private var _imagedict:Dictionary = new Dictionary();
		
		public function FResourceMemCache()
		{
		}
		
		
		/**
		 * 手动添加资源 
		 * @param key
		 * @param resource
		 * 
		 */
		public function AddResource(key:String,resource:FResource):void
		{
			_imagedict[key] = resource;
		}
		
		/**
		 * 选择性加载 
		 * @param key
		 * @param complete
		 * 
		 */
		protected function _loadResFromCache(key:String,complete:Function):void
		{
			//检测本地是缓存否存在这个文件
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + FXEngineConfig.o.resourceCachePath + key;
			var file:File = new File(filePath);
			if(file.exists)
			{
				FPathUtils.o.readFileToByteArrayAsync(filePath,function 
					loadComplete(buffer:ByteArray):void{
					complete(buffer);
				});
				return;
			}
			
			//检测程序包里面是否有这个文件
			filePath = "app:/"+ FXEngineConfig.o.resourceLocalBasePath + key;
			file = new File(filePath);
			if(file.exists)
			{				
				FPathUtils.o.readFileToByteArrayAsync(filePath,function 
					loadComplete(buffer:ByteArray):void{
					complete(buffer);
				});
				return;
			}
			
			//首先下载二进制数据
			var resourceLoader:URLLoader = new URLLoader();
			resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
			resourceLoader.addEventListener(Event.COMPLETE,function (e:Event):void
			{
				var loader:URLLoader = e.target as URLLoader;
				//加载数据详情
				complete(loader.data);
			});
			resourceLoader.addEventListener(IOErrorEvent.IO_ERROR,function (e:Event):void
			{
				//加载文件错误
			});
			resourceLoader.load(new URLRequest(key));
			
		}
		/**
		 * 获取图像资源 
		 * @param key 图像的关键字,一般为URL 绝度路径
		 * @param loadedCallBack 完成后的调用(key,resource:FResource);
		 * @return 如果在缓存中,则直接返回 not null 如果是null 则通过loaded返回
		 * 
		 */
		public function getResource(key:String,loadedCallBack:Function = null):FResource
		{
			if(_imagedict.hasOwnProperty(key))
			{
				if(loadedCallBack != null)
					loadedCallBack(key,_imagedict[key]);
				return _imagedict[key];
			}
			
			_loadResFromCache(key,function complete(data:ByteArray):void
			{
				//加载数据详情
				var resLoaderInfo: FResourceLoaderInfo = new FResourceLoaderInfo();
				resLoaderInfo.callBack = loadedCallBack;
				resLoaderInfo.data = data;
				resLoaderInfo.fullPath = key;
				
				//构造资源
				FResource.builder(resLoaderInfo,
					function loadComplete(loadInfo:FResourceLoaderInfo,resouce:FResource):void
					{
						_imagedict[key] = resouce;
						if(loadedCallBack != null)
						{
							loadedCallBack(key,resouce);
						}
					});
			});
//			//首先下载二进制数据
//			var resourceLoader:URLLoader = new URLLoader();
//			resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
//			resourceLoader.addEventListener(Event.COMPLETE,function (e:Event):void
//			{
//				
//				var loader:URLLoader = e.target as URLLoader;
//				
//				//加载数据详情
//				var resLoaderInfo: FResourceLoaderInfo = new FResourceLoaderInfo();
//				resLoaderInfo.callBack = loadedCallBack;
//				resLoaderInfo.data = loader.data;
//				resLoaderInfo.fullPath = key;
//				
//				//构造资源
//				FResource.builder(resLoaderInfo,
//					function loadComplete(loadInfo:FResourceLoaderInfo,resouce:FResource):void
//					{
//						_imagedict[key] = resouce;
//						if(loadedCallBack != null)
//						{
//							loadedCallBack(key,resouce);
//						}
//					});
//				
//				
//				
//				
//			});
//			resourceLoader.load(new URLRequest(key));
//			
			
			return null;
		}
		
		
		
		
	}
}