package engine_starling.utils
{
	import com.hurlant.crypto.symmetric.AESKey;
	import com.hurlant.crypto.symmetric.CBCMode;
	import com.hurlant.crypto.symmetric.NullPad;
	import com.hurlant.util.Hex;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	
	import engine_starling.SApplicationConfig;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;

	/**
	 * 内存缓存/硬盘缓存 
	 * @author caihua
	 * 
	 */
	public class SAssetsCache implements SICache
	{
		/**
		 * 本地缓存文件Md5校验列表 shortname。md5string 
		 */
		private var _fileMd5CheckLocal:Object = null;
		
		private var _fileMd5CheckLocalVerify:Object = null;
		/**
		 * 远程版本控制文件 
		 */
		private var _fileMd5CheckRemote:Object = null;
		private var _fileMd5CheckRemoteVerify:Object = null;
		/**
		 * 应用程序内部资源索引 
		 */
		private var _fileMd5CheckLocalApp:Object = null;
		
		
		/**
		 * 版本控制文件名称 
		 */
		public static var fileMd5CheckName:String = "abcdecgcheckfile.json";
		public static var fileMd5CheckNameVerify:String = "abcdecgcheckfile_verify.json";
		public static var fileMd5CheckRemoteName:String = "remoteabcdecgcheckfile.json";
		public static var fileMd5CheckRemoteNameVerify:String = "remoteabcdecgcheckfile_verify.json";
		/**
		 * 本地App包中的MD5文件校验 
		 */
		public static var fileMd5CheckLocalAppName:String = "resmd5.json";
		
		
		/**
		 * 是否开启远程校验功能 也就是校验文件也需要校验码
		 */
		public static var enableRemoteFileVerify:Boolean = false;
		/**
		 * 是否加密监测文件 
		 */
		private var _isEncryptMd5CheckFile:Boolean = false;
		
		
		private var _baseCache:SICache = new SDictionaryCache(); 
		private var _logger:Logger = Logger.getInstance(SAssetsCache);
		
		
		/**
		 * 网络加载错误后,可以忽略的列表 
		 */
		public static const NetLoadErrorIgnoreList:Array = ["png","jpg","atf","atfi","atfa"];
		
		public function SAssetsCache()
		{
			
//			//修正文件校验
			_loadCheckFile();
			_loadCheckFileLocalApp();
			_loadLocalFileAsRemoteCheckFile();
		}
		
		
		/**
		 * 添加对象到内存缓存中 
		 * @param key
		 * @param value
		 * @return 
		 * 
		 */
		public function addObject(key:String,value:*):*
		{
			_baseCache.addObject(key,value);
			return value;
		}
		
		
		/**
		 * 获取制定Key的内存对象 
		 * @param key
		 * @return 
		 * 
		 */
		public function getObject(key:String, D:* = null):*
		{
			return _baseCache.getObject(key);
		}
		/**
		 * 删除所有内存对象 
		 * 
		 */
		public function delAllObject():void
		{
			purge();
		}
		
		public function delUnusedObjects():void
		{
			_baseCache.delUnusedObjects();
		}
		
		
		
		/**
		 * 删除指定的内存对象 
		 * @param key
		 * 
		 */
		public function delObject(key:String):*
		{
			return _baseCache.delObject(key);
		}

		
		
		/** Removes assets of all types and empties the queue. */
		public function purge():void
		{
			_baseCache.delAllObject();
		}
		
		
	
		/**
		 * 加载版本校验文件 
		 * 
		 */
		protected function _loadCheckFile():void
		{
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + fileMd5CheckName;
			var file:File = new File(filePath);
			_fileMd5CheckLocal = new Object();
			if(file.exists)
			{
				var bytes:ByteArray = new ByteArray();
				SPathUtils.o.readFileToByteArray(filePath,bytes);
				_fileMd5CheckLocal = _loadJsonObject(bytes,new Object());
				bytes.clear();
			}
			
			
			filePath = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + fileMd5CheckNameVerify;
			file = new File(filePath);
			_fileMd5CheckLocalVerify = new Object();
			if(file.exists)
			{
				bytes = new ByteArray();
				SPathUtils.o.readFileToByteArray(filePath,bytes);
				_fileMd5CheckLocalVerify = _loadJsonObject(bytes,new Object());
				bytes.clear();
			}
		}
		/**
		 * 加载版本校验文件 
		 * 
		 */
		protected function _loadCheckFileLocalApp():void
		{
			var filePath:String = "app:/"+ SApplicationConfig.o.resourceLocalBasePath + fileMd5CheckLocalAppName;
			var file:File = new File(filePath);
			_fileMd5CheckLocalApp = new Object();
			if(file.exists)
			{
				var bytes:ByteArray = new ByteArray();
				SPathUtils.o.readFileToByteArray(filePath,bytes);
				_fileMd5CheckLocalApp = _loadJsonObject(bytes,new Object());
			}
		}
		/**
		 * 在远程的资源中是否包含对应Key的资源 
		 * @param key
		 * return
		 */
		public function hasObjectInRemoteResource(key:String):Boolean
		{
			return _fileMd5CheckRemote.hasOwnProperty(key);
		}
		
		/**
		 * 获取远程文件列表
		 * @param suffix 文件后缀,不包含. 例如"atf"
		 * @return 
		 * 
		 */
		public function getRemoteResource(suffix:String):Array
		{
			var  arr:Array = new Array();
			suffix = suffix.toLowerCase();
			
			for(var filename:String in _fileMd5CheckRemote)
			{
				if(suffix == (filename.split(".").pop() as String).toLowerCase())
				{
					arr.push(filename);
				}
			}
			return arr;
		}
		/**
		 * 从新加载配置文件 
		 * @param _finish
		 * 
		 */
		public function reloadCheckFile(_finish:Function = null,errfunction:Function = null):void
		{
			
			if(enableRemoteFileVerify)
			{
			
				_loadRemoteCheckFileVerify(function ():void{
					if(_fileMd5CheckLocalVerify.hasOwnProperty("md5") == false || 
						_fileMd5CheckRemoteVerify["md5"] != _fileMd5CheckLocalVerify["md5"])
					{
						_logger.debug("checkfileverify not same! load from remote!");
						//加载远程
						_loadRemoteCheckFile( function():void{
							//加载成功 再写入
							var filePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + fileMd5CheckNameVerify;
							var bytes:ByteArray = new ByteArray();
							bytes.writeUTFBytes(JSON.stringify(_fileMd5CheckRemoteVerify));
							SPathUtils.o.WriteByteArrayToFile(bytes,filePath);
							bytes.clear();
							//不用下载
							if(_finish != null)
							{
								_finish();
							}
						},errfunction);
					}
					else
					{
						_logger.debug("checkfileverify same!! use local");
						//不用下载
						if(_finish != null)
						{
							_finish();
						}
					}
					
				},errfunction);
			}
			else
			{
				_loadRemoteCheckFile(_finish,errfunction);
			}
			
			
		}
		
		/**
		 * 下载远程校验文件 
		 * @param _finish
		 * @param errfunction
		 * 
		 */
		private function _loadRemoteCheckFileVerify(_finish:Function = null,_errfunction:Function = null):void
		{
			//基础远程资源 
			var filePath:String =  SApplicationConfig.o.resourceRemoteBasePath + fileMd5CheckRemoteNameVerify;
			trace("verify path:"+filePath);
			//首先下载二进制数据
			var resourceLoader:URLLoader = new URLLoader();
			var scriptRequest:URLRequest = new URLRequest(filePath);
			var header:URLRequestHeader = new URLRequestHeader("Referer", "wg.imghb.com");
			
			resourceLoader.addEventListener(Event.COMPLETE,function (e:Event):void
			{
				var loader:URLLoader = e.target as URLLoader;
				//这里不写入，当外部加载完成校验文件后，再写入
//				var filePath:String = File.cacheDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + fileMd5CheckNameVerify;
//				SPathUtils.o.WriteByteArrayToFile(loader.data,filePath);
				_fileMd5CheckRemoteVerify = _loadJsonObject(loader.data);
				loader.data.clear();
				
				if(_fileMd5CheckRemoteVerify == null)
				{
					_fileMd5CheckRemoteVerify = new Object();
					if(_errfunction != null)
					{
						_errfunction();
					}
				}
				else
				{
					if(_finish != null)
					{
						_finish();
					}
				}
			});
			resourceLoader.addEventListener(IOErrorEvent.IO_ERROR,function (e:Event):void
			{
				//加载文件错误
				//1秒后继续加载
				//				_logger.info("Load Check File Error,contine load next second");
				//				Starling.juggler.delayCall(resourceLoader.load,1,scriptRequest);
				if(_errfunction != null)
				{
					_errfunction();
				}
				
			});
			
			
			scriptRequest.requestHeaders.push(header);
			resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
			resourceLoader.load(scriptRequest);
		}
		
		
		/**
		 * 加载本地文件作为远程校验文件 
		 * 如果本地有远程文件.则读入远程文件
		 */
		protected function _loadLocalFileAsRemoteCheckFile():void
		{
			//默认先认为本地就是最新的
			_fileMd5CheckRemote = _fileMd5CheckLocal;
			
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + fileMd5CheckRemoteName;
			var file:File = new File(filePath);
			if(file.exists)
			{
				var bytes:ByteArray = new ByteArray();
				SPathUtils.o.readFileToByteArray(filePath,bytes);
				_fileMd5CheckRemote = _loadJsonObject(bytes,new Object());
			}
			
		}
		/**
		 * 加载远程的校验文件
		 * @param _finish 加载成功回调
		 * @param _errfunction 加载失败回调
		 * 
		 */
		protected function _loadRemoteCheckFile(_finish:Function = null,_errfunction:Function = null):void
		{
			
			//基础远程资源 
			var filePath:String =  SApplicationConfig.o.resourceRemoteBasePath + fileMd5CheckRemoteName;
			if (enableRemoteFileVerify)
			{
				filePath = filePath +"?" + _fileMd5CheckRemoteVerify["md5"];
			}
			//首先下载二进制数据
			var resourceLoader:URLLoader = new URLLoader();
			var scriptRequest:URLRequest = new URLRequest(filePath);
			var header:URLRequestHeader = new URLRequestHeader("Referer", "wg.imghb.com");
			
			resourceLoader.addEventListener(Event.COMPLETE,function (e:Event):void
			{
				var loader:URLLoader = e.target as URLLoader;
				var filePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + fileMd5CheckRemoteName;
				SPathUtils.o.WriteByteArrayToFile(loader.data,filePath);
				_fileMd5CheckRemote = _loadJsonObject(loader.data);
				loader.data.clear();
				
				if(_fileMd5CheckRemote == null)
				{
					_fileMd5CheckRemote = new Object();
					if(_errfunction != null)
					{
						_errfunction();
					}
				}
				else
				{
					if(_finish != null)
					{
						_finish();
					}
				}
			});
			resourceLoader.addEventListener(IOErrorEvent.IO_ERROR,function (e:Event):void
			{
				//加载文件错误
				//1秒后继续加载
//				_logger.info("Load Check File Error,contine load next second");
//				Starling.juggler.delayCall(resourceLoader.load,1,scriptRequest);
				if(_errfunction != null)
				{
					_errfunction();
				}
				
			});
			
			
			scriptRequest.requestHeaders.push(header);
			resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
			resourceLoader.load(scriptRequest);
			
		}
		
		/**
		 * 加载转换JSONOBJECT 
		 * @param inbytes 输入字节序
		 * @return 解析完成的对象,如果解析出错.必须是null
		 * 
		 */
		private function _loadJsonObject(inbytes:ByteArray,D:* = null):Object
		{
			var cpbyte:ByteArray = new ByteArray();
			cpbyte.writeBytes(inbytes);
			cpbyte.position = 0;
			var retObject:Object = new Object;
			if(_isEncryptMd5CheckFile)
			{
				var cbc:CBCMode = new CBCMode(new AESKey(Hex.toArray(fileMd5CheckName)), new NullPad);
				cbc.IV = Hex.toArray("000102030405060708090a0b0c0d0e0f");
				cbc.decrypt(cpbyte);
			}
			try
			{
				retObject = JSON.parse(cpbyte.toString()) ;
			}
			catch(e:Error)
			{
				retObject = D;
			}
			return retObject;
		}
		/**
		 *  增加文件的版本控制,如果在远程有此版本控制文件,则添加到本地
		 * @param shortname
		 * @param fileBytes
		 * 
		 */
		protected function _addFileMD5WithRemoteChecklistAndSave(shortname:String,fileBytes:ByteArray):void
		{
			if(_fileMd5CheckRemote.hasOwnProperty(shortname))
			{
				_fileMd5CheckLocal[shortname] = _fileMd5CheckRemote[shortname];
				_saveFileMd5();
			}
		}

		/**
		 * 延时保存 
		 */
		private var _delaycallSaveFileMd5:DelayedCall;
		/**
		 * 保存校验文件 
		 * 修改为延时5秒保存
		 */
		protected function _saveFileMd5():void
		{
			
			if(_delaycallSaveFileMd5 == null)
			{
				_delaycallSaveFileMd5 = new DelayedCall(_saveFileMd5Delay,5);
				Starling.juggler.add(_delaycallSaveFileMd5);
			}
			else if(_delaycallSaveFileMd5.isComplete)
			{
				_delaycallSaveFileMd5.reset(_saveFileMd5Delay,5);
				Starling.juggler.add(_delaycallSaveFileMd5);
			}
		}
		
		private function _saveFileMd5Delay():void
		{
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + fileMd5CheckName;
			var jsonString:String = JSON.stringify(_fileMd5CheckLocal);
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(JSON.stringify(_fileMd5CheckLocal));
			if(_isEncryptMd5CheckFile)
			{
				var cbc:CBCMode = new CBCMode(new AESKey(Hex.toArray(fileMd5CheckName)), new NullPad);
				cbc.IV = Hex.toArray("000102030405060708090a0b0c0d0e0f");
				cbc.encrypt(bytes);
			}
			SPathUtils.o.WriteByteArrayToFile( bytes,filePath);
		}
		/**
		 * 删除md5文件关联 
		 * @param shortname
		 * 
		 */
		protected function _removeFileMd5(shortname:String):void
		{
			delete _fileMd5CheckLocal[shortname];
		}
		
		/**
		 * 判断文件是否是最新的 
		 * @param shortname
		 * @return false 需要重新下载
		 * 
		 */
		[inline]
		protected function _compareFileMd5same(shortname:String):Boolean
		{
			if(SApplicationConfig.o.alwayloadFromRemoteOrApp)
			{
				return false;
			}
			//远程版本中 没有此属性 true
			if(!_fileMd5CheckRemote.hasOwnProperty(shortname))
			{
				return true;
			}
			//本地资源管理文件中没有此属性，false
			if(!_fileMd5CheckLocal.hasOwnProperty(shortname))
			{
				return false;
			}
			//都存在，但是不一致
			if(_fileMd5CheckLocal[shortname] != _fileMd5CheckRemote[shortname])
			{
				return false;
			}
			//一致
			return true;
		}
		
		
		/**
		 * 比较本地程序包中的MD5 
		 * @param shortname
		 * @return true MD5一致
		 * 
		 */
		[inline]
		protected function _compareLocalAppMd5(shortname:String):Boolean
		{
			if(SApplicationConfig.o.alwayloadFromRemoteOrApp)
			{
				return false;
			}
			//远程版本中 没有此属性 true
			if(!_fileMd5CheckRemote.hasOwnProperty(shortname))
			{
				return true;
			}
			//本地资源管理文件中没有此属性，false
			if(!_fileMd5CheckLocalApp.hasOwnProperty(shortname))
			{
				return false;
			}
			//都存在，但是不一致
			if(_fileMd5CheckLocalApp[shortname] != _fileMd5CheckRemote[shortname])
			{
				return false;
			}
			
			//一直
			return true;
			
		}
		/**
		 * 获取CND网络后缀 
		 * @param filename 文件名
		 * @return "?ver后缀",或者""
		 * 
		 */
		private function _getCNDFileExtVer(shortname:String):String
		{
			//远程版本中 没有此属性返回""
			if(!_fileMd5CheckRemote.hasOwnProperty(shortname))
			{
				return "";
			}
			return "?ver=1" + _fileMd5CheckRemote[shortname];
			
		}
		

		
		/**
		 * 从本地缓存中删除这个文件 ,包括内存
		 * @param filefullPath
		 * 
		 */
		protected function _deleteDataFromCache(filefullPath:String):void
		{
			//检测本地是缓存否存在这个文件
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + filefullPath;
			var file:File = new File(filePath);
			if(file.exists)
			{	
				file.deleteFile();
				_removeFileMd5(filefullPath);
				_saveFileMd5();
			}
			
			delObject(filefullPath);
		}
		
		
		
		/**
		 *  
		 * @param filefullPath
		 * @param complete(params:SAssetsCacheLoadParams):void 
		 * @param writeToCache 是否把下载内容写入本地缓存
		 * @param downloadOnly 是否只是下载,如果是 则不读入本地文件
		 */
		public function loadDataFromCacheOrURL(filefullPath:String,complete:Function,writeToCache:Boolean = true,downloadOnly:Boolean = false):void
		{
			//与远程的MD5不一样
			if(!_compareFileMd5same(filefullPath))
			{
				Logger.log("SAssetsCache","file md5 not same delete local:" + filefullPath);
				//删除缓存中的文件
				_deleteDataFromCache(filefullPath);
			}
			
			//从内存中先读取
			var bufferOfMem:ByteArray = getObject(filefullPath)
			if(bufferOfMem != null)
			{
				completefunc(SAssetsCacheLoadParams.LOADFROM_MEM,bufferOfMem);
				return;
			}
			//检测本地是缓存否存在这个文件
			const cacheFilePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath + filefullPath;
			const appFilePath:String = "app:/"+ SApplicationConfig.o.resourceLocalBasePath + filefullPath;
			const remoteFilePath:String = SApplicationConfig.o.resourceRemoteBasePath + filefullPath + _getCNDFileExtVer(filefullPath);
			
			var file:File = new File(cacheFilePath);
			if(file.exists)
			{
				if(downloadOnly)
				{
					completefunc(SAssetsCacheLoadParams.LOADFROM_APPCACHE,null);
				}
				else
				{
					SPathUtils.o.readFileToByteArrayAsyncUrl(cacheFilePath,function 
						loadComplete(buffer:ByteArray):void{
						completefunc(SAssetsCacheLoadParams.LOADFROM_APPCACHE,buffer);
					});
				}
				return;
			}
			
			//检测程序包里面是否有这个文件
			file = new File(appFilePath);
			if(file.exists)
			{			
				if(downloadOnly)
				{
					completefunc(SAssetsCacheLoadParams.LOADFROM_APP,null);
				}
				else
				{
					//本地资源,同步读取,并且计算MD5码..
					if(_compareLocalAppMd5(filefullPath))
					{
						SPathUtils.o.readFileToByteArrayAsyncUrl(appFilePath,function 
							loadComplete(buffer:ByteArray):void{
							if(buffer != null)
							{
								completefunc(SAssetsCacheLoadParams.LOADFROM_APP,buffer);
								
								//fix去除写入本地缓存
	//							SPathUtils.o.WriteByteArrayToFile(buffer,cacheFilePath);
								//添加文件版本控制
								_addFileMD5WithRemoteChecklistAndSave(filefullPath,buffer);
//								Logger.log("SAssetsCache","add resource by local app:" + filefullPath);
							}
							else
							{
								completefunc(SAssetsCacheLoadParams.LOADFROM_APP,null,false);
							}
							
						});
						return;
					}
				}
				
			}
			
			//首先下载二进制数据
			var resourceLoader:URLLoader = new URLLoader();
			//资源后缀
			var resourcesuffix:String = (remoteFilePath.split(".").pop() as String).toLowerCase();
			resourceLoader.addEventListener(Event.COMPLETE,function (e:Event):void
			{
				var loader:URLLoader = e.target as URLLoader;
				
				if(writeToCache)
				{
					SPathUtils.o.WriteByteArrayToFile(loader.data,cacheFilePath);
					//添加文件版本控制
					_addFileMD5WithRemoteChecklistAndSave(filefullPath,loader.data);
				}
				
				completefunc(SAssetsCacheLoadParams.LOADFROM_REMOTE,loader.data);
//				loader.data.clear();
			});
			resourceLoader.addEventListener(IOErrorEvent.IO_ERROR,function (e:Event):void
			{
				Assert(false,"资源下载失败!{0}",remoteFilePath);
				if(NetLoadErrorIgnoreList.indexOf(resourcesuffix) != -1)
				{
					completefunc(SAssetsCacheLoadParams.LOADFROM_REMOTE,null,false);
				}
				else
				{
					Logger.log("SAssetsCache","reload net resource:" + remoteFilePath);
					Starling.juggler.delayCall(retry,1,resourceLoader,scriptRequest);
				}
				
			});
			var scriptRequest:URLRequest = new URLRequest(remoteFilePath);
			var header:URLRequestHeader = new URLRequestHeader("Referer", "wg.imghb.com");
			scriptRequest.requestHeaders.push(header);
			resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
			resourceLoader.load(scriptRequest);
			
			//重新加载
			function retry(sloader:URLLoader,request:URLRequest):void
			{
				sloader.load(request);
			}
			
			//回调函数
			function completefunc(loadfrom:int,byte:ByteArray,isSucc:Boolean = true):void
			{
				var params:SAssetsCacheLoadParams = new SAssetsCacheLoadParams();
				if(byte != null)
				{
					byte.position = 0;
				}
				params.sourcepath = filefullPath;
				params.loadfrom = loadfrom;
				params.buffer = byte;
				params.isSucc = isSucc;
				
				complete(params);
			}
			
		}
	}
	

}