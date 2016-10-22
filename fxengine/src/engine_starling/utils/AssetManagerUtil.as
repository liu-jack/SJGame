package engine_starling.utils
{
	import com.deng.fzip.FZip;
	import com.deng.fzip.FZipFile;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import engine_starling.SApplication;
	import engine_starling.Events.AssetEvent;
	import engine_starling.data.SDataBase;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	import starling.textures.AtfData;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	/**
	 * 本地资源管理器扩展 
	 * @author caihua
	 * 
	 */
	public class AssetManagerUtil extends EventDispatcher
	{
		public function AssetManagerUtil(singleton:SingletonEnforcer)
		{
			_init();
		}
		
		/**
		 * 资源缓存时间。毫秒 -1为不开启这个功能
		 */
		public static var resourcedelayCacheTime:int = -1;
		/**
		 * 自动释放延时缓存资源 
		 */		
		public static var autoDisposedelayCache:Boolean = false;
	
		private static var _ins:AssetManagerUtil = null;
		
		/**
		 * 资源缓存组 
		 */
		private static const RESGROUPNAME_CACHE:String = "resource_group_cache";
		
		/**
		 * 引用计数管理器 
		 */
		private var _ref_count_manager:AssetDataRefCountManager;
		
		/**
		 * 资源gc管理器 
		 */
		private var _res_gc:AssetDataGC;
		
		
		public static function get o():AssetManagerUtil
		{
			if(_ins == null)
				_ins = new AssetManagerUtil(new SingletonEnforcer());
			return _ins;
		}
		
		/** Removes assets of all types and empties the queue. */
		public function purge():void
		{
			_memCache.purge();
		}
		
		/**
		 * 删除没有用到并且超时的资源 
		 * 
		 */
		public function removeUnusedAndTimeOutResource():void
		{
			var needdeleteres:Array = _ref_count_manager.get_lru_delay_zero_ref_assets();
			var length:int = needdeleteres.length;
			if (length == 0)
			{
				_logger.info("remove unUsed and TimeOut not has delay resource");
				return;
			}
			var assetname:String;
			for (var i:int = 0;i<length;i++)
			{
				assetname = needdeleteres[i];
				_logger.info("remove unUsed and TimeOut Resource:{0}",assetname);
				//析构资源
				_res_gc.disposeAssetData(assetname);
				delete _LoadedAssetDic[assetname];
			}
			//清空0引用资源
			_ref_count_manager.clear_lru_delay_ref_asset(needdeleteres);
			_memCache.delUnusedObjects();
			
			System.pauseForGCIfCollectionImminent(0);
			System.gc();
		}
		/**
		 * 删除没有用到的资源 
		 * 
		 */
		public function removeUnusedResource():void
		{
			//需要删除的资源列表
			
			var needdeleteres:Array = _ref_count_manager.get_zero_ref_assets();
			var length:int = needdeleteres.length;
			var assetname:String;
			for (var i:int = 0;i<length;i++)
			{
				assetname = needdeleteres[i];
				_logger.info("remove unUsed Resource:{0}",assetname);
				//析构资源
				_res_gc.disposeAssetData(assetname);
				delete _LoadedAssetDic[assetname];
			}
			//清空0引用资源
			_ref_count_manager.clear_zero_ref_assets();
			_memCache.delUnusedObjects();
			
			System.pauseForGCIfCollectionImminent(0);
			System.gc();
		}
		
		/**
		 * 取消加载 
		 * @param groupName
		 * 
		 */
		private function _cancelLoaderByGroup(groupName:String):void
		{
			var length:uint = 0;
			var i:uint = 0;
			//删除当前压入组
			if(_currentwaitQuene!= null)
			{
				if(_currentwaitQuene.resourceQueue.length > 0)
				{
					if(_currentwaitQuene.resourceQueue[0].group == groupName)
					{
						_logger.info("_cancelLoaderByGroup in currentQueue:{0}",groupName);
						_currentwaitQuene.onProgress = null;
						_currentwaitQuene = null;
						return;
					}
				}
			}
			
			length = _waitingQueue.length;
			//在还没有加载的组中去寻找
			for (i=0;i<length;i++)
			{
				if(_waitingQueue[i].resourceQueue[0].group == groupName)
				{
					_logger.info("_cancelLoaderByGroup in _waitingQueue:{0}",groupName);
					_waitingQueue[i].onProgress = null;
					delete _waitingQueue[i];
					return;
				}
			}
			
			if(_state == STATE_BUSY)
			{
				if(mRawAssets.length > 0)
				{
					var assetInfo:Object = mRawAssets[mRawAssets.length - 1];
					if(assetInfo.group == groupName)
					{
						while(mRawAssets.pop()!= null)
						{
							
						}
						_logger.info("_cancelLoaderByGroup in _currentLoading:{0}",groupName);
						return;
					}
				}
			}
			
		}
		/**
		 * 卸载资源组 
		 * @param groupName 资源组名称
		 * @param bdispose 是否销毁资源 false 不销毁 true 如果资源引用为空 直接销毁了
		 * 
		 */
		public function disposeAssetsByGroup(groupName:String,bdispose:Boolean = false):void
		{
			_cancelLoaderByGroup(groupName);
			var _assetGroupData:AssetGroupData = _LoadedAssetGroupDic[groupName];
//			Assert(_assetGroupData != null,"释放资源没有找到资源组{0}",groupName);
			if(_assetGroupData == null)
			{
				return;
			}
			_logger.info("disposeAssetsByGroup:{0}",groupName);
			var length:int = _assetGroupData.relationAssetDataName.length;
			for (var i:uint = 0;i<length;i++)
			{
				var assetName:String = _assetGroupData.relationAssetDataName[i];
				var _asset:String = _LoadedAssetDic[assetName];
//				Assert(_asset != null,"释放资源没有找到对应资源{0}",assetName);
				if(_asset == null)
				{
					continue;
				}
				_ref_count_manager.dec_ref(_asset);
				
				if(bdispose)
				{
					if(_ref_count_manager.getref(_asset) == 0)
					{
						_res_gc.disposeAssetData(_asset);
						
						delete _LoadedAssetDic[assetName];
					}
				}
				
			}
			//删除资源组
			delete _LoadedAssetGroupDic[groupName];
			
			
			if(autoDisposedelayCache)
			{
				removeUnusedAndTimeOutResource();
			}
			
			
		}
		

		
		/**
		 * 子对象名称转换 
		 * @param key
		 * @return 
		 * 
		 */
		[inline]
		protected function _ConvertsubObjectName(key:String):String
		{
			return "A_".concat(key);
		}

		/**
		 * 添加对象 
		 * @param key 索引
		 * @param value 对象
		 * @param assetName 资源名称 例如 anims里面会分解出好多的对象 
		 * 
		 */
		[inline]
		protected function addObject(key:String,value:Object,assetName:String = null):void
		{
			if(assetName == null)
				assetName = key;
			
			
			_memCache.addObject(_ConvertsubObjectName(key),value);
			
		}
		
		
		/**
		 * 是否包含资源 
		 * @param key
		 * @return 
		 * 
		 */
		[inline]
		public function hasAsset(key:String):Boolean
		{
			return _LoadedAssetDic[key] != null;
		}
		
		/**
		 * 获取对象 
		 * @param key
		 * @return 
		 * 
		 */
		[inline]
		public function getObject(key:String):Object
		{
			var extension:String = (key.split(".").pop() as String).toLowerCase();
			var convertkey:String = _ConvertsubObjectName(key);
			if(extension == "mp3")
			{
				var rtnSound:Sound = _defaultStarlingAsset.getSound(key);
				if(rtnSound == null)
				{
					var soundObject:* = _memCache.getObject(convertkey);
					if(soundObject is ByteArray)
					{
						var mp3bytes:ByteArray = soundObject;
						mp3bytes.position = 0;
						var sound:Sound = new Sound();
						sound.loadCompressedDataFromByteArray(mp3bytes, mp3bytes.length);
						_defaultStarlingAsset.addSound(key,sound);
						mp3bytes.clear();
						rtnSound = sound;
						_memCache.delObject(convertkey);
					}
					
				}
				return rtnSound;
			}
			else if(extension == "json")
			{
				var jsonObject:* = _memCache.getObject(convertkey);
				if(jsonObject is String)
				{
					_memCache.addObject(convertkey,JSON.parse(jsonObject));
				}
			}
			return _memCache.getObject(convertkey)
		}
		/**
		 * 删除对象 
		 * @param key
		 * 
		 */
		public function removeObject(key:String):void
		{
			
			removeObjectByRealname(_ConvertsubObjectName(key));
		}
		
		/**
		 * 直接删除 真实名称对象 
		 * @param name
		 * 
		 */
		internal function removeObjectByRealname(name:String):void
		{
			_memCache.delObject(name);
		}
		
		/** Returns a texture with a certain name. The method first looks through the directly
		 *  added textures; if no texture with that name is found, it scans through all 
		 *  texture atlases. */
		public function getTexture(name:String):Texture
		{
			return _defaultStarlingAsset.getTexture(name);
		}
		
		/** Returns all textures that start with a certain string, sorted alphabetically
		 *  (especially useful for "MovieClip"). */
		public function getTextures(prefix:String="", result:Vector.<Texture>=null):Vector.<Texture>
		{
			return _defaultStarlingAsset.getTextures(prefix,result);
		}
		/** Returns a texture atlas with a certain name, or null if it's not found. */
		public function getTextureAtlas(name:String):TextureAtlas
		{
			return _defaultStarlingAsset.getTextureAtlas(name);
		}
		
		
		/**
		 * 空闲 
		 */
		private static const STATE_FREE:int = 0;
		/**
		 *忙碌 
		 */
		private static const STATE_BUSY:int = 1;
		
		/**
		 * 资源管理器状态 
		 */
		private var _state:int = STATE_FREE;
		
		/**
		 * 初始化 
		 * 
		 */
		private function _init():void
		{
			_memCache = new SAssetsCache;
			_res_gc = new AssetDataGC();
			_ref_count_manager = new AssetDataRefCountManager();
			
		}
		
		private var _defaultStarlingAsset:AssetManager = SApplication.assets;
		/**
		 * 初始化。完事后会调用  AssetEvent.INIT_COMPLETE 事件
		 * 
		 */
		public function init():void
		{
			_memCache.reloadCheckFile(
				function ():void{dispatchEventWith(AssetEvent.INIT_COMPLETE,false,{code:1});},
				function ():void{dispatchEventWith(AssetEvent.INIT_COMPLETE,false,{code:0});});
		}
		/**
		 * 默认的starling资源管理器 
		 */
		public function get defaultStarlingAsset():AssetManager
		{
			return _defaultStarlingAsset;
		}
		
		/**
		 * @private
		 */
		public function set defaultStarlingAsset(value:AssetManager):void
		{
			_defaultStarlingAsset = value;
		}
		
		
		/**
		 * 内存缓存 
		 */
		private var _memCache:SAssetsCache;
		
		/**
		 *是否包含在远程下载资源中 
		 * @param key
		 * @return 
		 * 
		 */
		public function hasObjectInRemoteResource(key:String):Boolean
		{
			return _memCache.hasObjectInRemoteResource(key);
		}
		
		/**
		 * 重新加载校验文件 
		 * @param finish
		 * @param errfunction
		 * 
		 */

		public function reloadCheckFile(_finish:Function = null,errfunction:Function = null):void
		{
			_memCache.reloadCheckFile(_finish,errfunction);
		}
		/**
		 * 获取文件短名称 
		 * @param rawAsset
		 * @return 
		 * 
		 */
		[inline]
		public function getName(rawAsset:Object):String
		{
			var matches:Array;
			var name:String;
			
			if (rawAsset is String || rawAsset is FileReference)
			{
				name = rawAsset is String ? rawAsset as String : (rawAsset as FileReference).name;
				name = name.replace(/%20/g, " "); // URLs use '%20' for spaces
				matches = /(.*[\\\/])?([\w\s\-]+)(\.[\w]{1,4})?/.exec(name);
				
				if (matches && matches.length == 4) return matches[2];
				else throw new ArgumentError("Could not extract name from String '" + rawAsset + "'");
			}
			else
			{
				name = getQualifiedClassName(rawAsset);
				throw new ArgumentError("Cannot extract names for objects of type '" + name + "'");
			}
		}
		
		/**
		 * 加载批量纹理图片 
		 * @param fileName xml 文件
		 * @param scale
		 * @param loadAsync
		 * 
		 */
		private function _loadXMLTexture(fileName:String,scale:Number=1, loadAsync:Function=null):void
		{
			//首先加载XML
			_memCache.loadDataFromCacheOrURL(fileName,function(e:SAssetsCacheLoadParams):void
			{
				var type:int,bytes:ByteArray;
				bytes = e.buffer;
				//解析。。。。
//				_logger.info("parser xml:{0}",fileName);
				var xml:XML = new XML(bytes);
				var rootNode:String = xml.localName();
				
				if (rootNode == "TextureAtlas")
				{
					//加载远程图片
					var remoteResouceFullName:String = xml.@imagePath.toString();
					// 获取图片文件对应的后缀的文件名, add by sangxu
					// TODO 正式使用导出的atf文件后, 开放以下一行
					remoteResouceFullName = _getAtfRealFileName(remoteResouceFullName);
					var remoteResouceShortName:String = getName(remoteResouceFullName);
					
					var atlasTexture:TextureAtlas = _defaultStarlingAsset.getTextureAtlas(remoteResouceShortName);
					if(atlasTexture == null )
					{
						_loadTexture(remoteResouceFullName,false,false,scale,function(texture:Texture):void{
							
							if(texture != null)
							{
								atlasTexture = new TextureAtlas(texture, xml);
								//添加到默认的资源管理器里面
								_defaultStarlingAsset.addTextureAtlas(remoteResouceShortName,atlasTexture);
							}
							System.disposeXML(xml);
							_callback();
						});
					}
					else
					{
						System.disposeXML(xml);
						_callback();
					}
				}
				else
				{
					System.disposeXML(xml);
					Assert(false,"XML  资源必须是 图片集合资源!");
				}
				
			});
			
			function _callback():void
			{
				if(loadAsync != null)
				{
					 loadAsync();
				}
				loadAsync = null;
			}
		}
		
	
		/**
		 * 加载单个纹理图片 
		 * @param fileName
		 * @param generateMipMaps
		 * @param optimizeForRenderToTexture
		 * @param scale
		 * @param loadAsync
		 * @return 
		 * 
		 */
		private function _loadTexture(fileName:String, generateMipMaps:Boolean=false,
									 optimizeForRenderToTexture:Boolean=false,
									 scale:Number=1, loadAsync:Function=null):void
		{
			
			var shortName:String = getName(fileName);
			var texture:Texture = _defaultStarlingAsset.getTexture(shortName);
			if(texture)
			{
				_callback(texture);
				return;
			}
			
			_memCache.loadDataFromCacheOrURL(fileName,function (e:SAssetsCacheLoadParams):void{
				
				//下载失败
				if(e.isSucc == false)
				{
					texture = _defaultStarlingAsset.getTexture("no_tex");
					_callback(texture);
					return;
				}
				var from:int,buffer:ByteArray;
				var extension:String = null;
				extension = (fileName.split(".").pop() as String).toLowerCase();
				buffer = e.buffer;
				_logger.info("add texture:{0}",fileName);
				
				switch (extension)
				{
					// add by sangxu, Android图片为atfa, iOS图片为atfi
					case "atf":
					case "atfa":
					case "atfi":
					{
						if(AtfData.isAtfData(buffer))
						{
							texture = starling.textures.Texture.fromAtfData(buffer,scale,generateMipMaps,function loaded(loadedtexture:Texture):void{
								_callback(texture);
							});
//							_callback(texture);
						}
						else
						{
							texture = _defaultStarlingAsset.getTexture("no_tex");
							_callback(texture);
						}
						
						
						break;
					}
					default:
					{
						//png
						var imageloader:Loader = new Loader();
						var context:LoaderContext = new LoaderContext();
						context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
						imageloader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,function loadComplete(e:*):void
						{
							var resourceLoaderInfo:LoaderInfo = e.target as LoaderInfo;
							texture = starling.textures.Texture.fromBitmap(resourceLoaderInfo.content as Bitmap,generateMipMaps,optimizeForRenderToTexture,scale);
							_defaultStarlingAsset.addTexture(shortName,texture);
							//通知外部加载完成
							_callback(texture);
						});
						imageloader.loadBytes(buffer,context);
						break;
					}
				}
				
			});
	
			
			function _callback(texture:Texture):void
			{
				if(loadAsync != null)
				{
					if (loadAsync.length == 1) loadAsync(texture);
					else loadAsync();
				}
			}
			
		}
		
		
		/**
		 *  加载通用的资源
		 * @param filefullPath
		 * @param complete
		 * @param writeToCache 默认写入缓存
		 * 
		 */
		private function _loadDefaultResource(filefullPath:String,complete:Function,writeToCache:Boolean = true):void
		{
			_memCache.loadDataFromCacheOrURL(filefullPath,_onUrlLoaderComplete,writeToCache);
			function _onUrlLoaderComplete(e:SAssetsCacheLoadParams):void
			{
				
				if(e.isSucc == false)//加载失败
				{
					complete();
					return;
				}
				
				//静态资源
				try
				{
//					_logger.debug("begin resolve:{0}",filefullPath);
					var resdict:Dictionary = null;
					var resdatabase:SDataBase = new SDataBase(e.sourcepath);
					resdatabase.ignoreDataEvent();
					resdatabase.encryptCache = false;
					resdatabase.loadFromCache(true);
					
//					_logger.debug("begin resolve1:{0}",filefullPath);
					//没有缓存. 或者 是从远程下载的
					if(!resdatabase.hasKey("res") ||
						e.loadfrom == SAssetsCacheLoadParams.LOADFROM_REMOTE)
					{
						resdict = new Dictionary();
						_resolveResourcefromRemote(resdict,e.sourcepath,e.buffer);
						e.buffer.clear();
						resdatabase.setData("res",resdict);
						Starling.juggler.delayCall(resdatabase.saveToCache,0.01,true,true);
//						resdatabase.saveToCache(true,true);
					}
					else
					{
					
						resdict = resdatabase.getData("res");
						_resolveResourceFromDictionay(resdict);
						resdatabase.clearAll();
						resdict = null;
					}
//					_logger.debug("end resolve:{0}",filefullPath);
					complete();
					
					
				}
				catch(e:Error)
				{
					SErrorUtil.reportError(e,"[no crash]");
					complete();
				}
			}
			
			/**
			 * 从远程解析资源,会首先写入本地缓存 
			 * @param resourceFilePath
			 * @param resourceBytes
			 * @return 
			 * 
			 */
			function _resolveResourcefromRemote(resdict:Dictionary,resourceFilePath:String,resourceBytes:ByteArray):Boolean
			{
				var bytes:ByteArray;
				var jsonArr:Array;
				var extension:String = null;
				var length:int = 0;
				var i:int = 0;
				extension = (resourceFilePath.split(".").pop() as String).toLowerCase();
				bytes = resourceBytes;
				bytes.position = 0;
				
				
				var isSucc:Boolean = true;
				switch (extension)
				{
					case "json":
					case "cmds":
						resdict[resourceFilePath] = JSON.parse(bytes.toString());
						
						break;
					case "jsonbin":
						resourceFilePath = resourceFilePath.substring(0,resourceFilePath.length - 3);
						resdict[resourceFilePath] = bytes.readObject();
						break;
					case "pex":
					case "sxml":
						resdict[resourceFilePath] = new XML(bytes.toString());
						break;
					case "scml":
						resdict[resourceFilePath] = new XML(bytes.toString());
						break;
					case "animsbin":
						resourceFilePath = resourceFilePath.substring(0,resourceFilePath.length - 3);
						jsonArr = bytes.readObject() as Array;
						length = jsonArr.length;
						for(var i:int = 0;i<length;i++)
						{
							resdict[jsonArr[i]["name"]] = jsonArr[i];
							addObject(jsonArr[i]["name"],jsonArr[i]);
							_addAssetsRelationGroup(_currentLoadedGroupName,jsonArr[i]["name"]);
						}
						resdict[resourceFilePath] = jsonArr;
						break;
					case "anims":
						jsonArr = JSON.parse(bytes.toString()) as Array;
						length = jsonArr.length;
						for(var i:int = 0;i<length;i++)
						{
							resdict[jsonArr[i]["name"]] = jsonArr[i];
							addObject(jsonArr[i]["name"],jsonArr[i]);
							_addAssetsRelationGroup(_currentLoadedGroupName,jsonArr[i]["name"]);
						}
						resdict[resourceFilePath] = jsonArr;
						
						break;
					case "mp3":
						var mp3byte:ByteArray = new ByteArray();
						mp3byte.writeBytes(bytes);
						mp3byte.position = 0;
						resdict[resourceFilePath] = mp3byte;						
						break;
					case "lua":
						var luabytes:ByteArray = new ByteArray();
						luabytes.writeBytes(bytes);
						bytes.position = 0;
						resdict[resourceFilePath] = luabytes;
						break;
					case "zipd":
						var fzip:FZip = new FZip();
						fzip.loadBytes(bytes);	
						var fileCount:int = fzip.getFileCount();
						var zipbytes:ByteArray = new ByteArray();
						for(i = 0;i< fileCount;i++)
						{
							var file:FZipFile = fzip.getFileAt(i);
							//file.sizeCompressed == 0 的时候,被压缩的内容大小为0,
							//一般情况下也就是文件夹
							//91M=>83M
							if(file.sizeCompressed != 0)
							{
								zipbytes.clear();
								zipbytes.writeBytes(file.content);
								//这里使用读入数据 释放 对 zipfile的引用...
								_resolveResourcefromRemote(resdict,file.filename,zipbytes);
								
							}
							file = null;
						}
						zipbytes.clear();
						fzip.close();
						fzip = null;
						
						break;
					
					default:
						isSucc = false;
						_logger.info("ignore res:{0}",resourceFilePath);
						break;
				}
				
				addObject(resourceFilePath,resdict[resourceFilePath]);
				_addAssetsRelationGroup(_currentLoadedGroupName,resourceFilePath);
				return true;
				
			}
			/**
			 * 解析资源 
			 * @param resourceFilePath 文件路径
			 * @param resourceBytes 文件内存
			 * @return 是否成功解析
			 */
			function _resolveResourceFromDictionay(dict:Dictionary):void
			{
				
				for(var key:String in dict)
				{
//					var extension:String = key;
//					extension = (extension.split(".").pop() as String).toLowerCase();
//					switch (extension)
//					{							
//						case "mp3":
//							
//							var mp3bytes:ByteArray = dict[key];
//							var sound:Sound = new Sound();
//							sound.loadCompressedDataFromByteArray(mp3bytes, mp3bytes.length);
//							_defaultStarlingAsset.addSound(key,sound);
//							mp3bytes.clear();
//
//							break;
//						default:
//							addObject(key,dict[key]);
//							break;
//					}
					addObject(key,dict[key]);
					//增加资源组的内部引用关联,成功增加引用
					_addAssetsRelationGroup(_currentLoadedGroupName,key);
					
					
				}
				
				
			}
			/**
			 * 解析资源 
			 * @param resourceFilePath 文件路径
			 * @param resourceBytes 文件内存
			 * @return 是否成功解析
			 */
//			function _resolveResource(resourceFilePath:String,resourceBytes:ByteArray):Boolean
//			{
//				var bytes:ByteArray;
//				var jsonArr:Array;
//				var length:int = 0;
//				var extension:String = null;
//				extension = (resourceFilePath.split(".").pop() as String).toLowerCase();
//				bytes = resourceBytes;
//				bytes.position = 0;
//				
//				var isSucc:Boolean = true;
//				switch (extension)
//				{
//					case "json":
//					case "cmds":
//						
//						addObject(resourceFilePath,JSON.parse(bytes.toString()));
//						break;
//					case "pex":
//					case "sxml":
//						addObject(resourceFilePath,new XML(bytes.toString()));
//						break;
//					case "scml":
//						addObject(resourceFilePath,new XML(bytes.toString()));
//						break;
//					
//					case "anims":
//						jsonArr = JSON.parse(bytes.toString()) as Array;
//						length = jsonArr.length;
//						for(var i:int = 0;i<length;i++)
//						{
//							//增加资源组的内部引用关联
//							_addAssetsRelationGroup(_currentLoadedGroupName,jsonArr[i]["name"]);
//							addObject(jsonArr[i]["name"],jsonArr[i]);
//						}
//						
//						addObject(resourceFilePath,jsonArr);
//						
//						break;
//					case "mp3":
//						var sound:Sound = new Sound();
//						sound.loadCompressedDataFromByteArray(bytes, bytes.length);
//						_defaultStarlingAsset.addSound(resourceFilePath,sound);
//						
//						
//						addObject(resourceFilePath,sound);
//						
//						break;
//					case "zipd":
//						
//						
//						
//						var fzip:FZip = new FZip();
//						fzip.loadBytes(bytes);	
//						var fileCount:int = fzip.getFileCount();
//						var zipbytes:ByteArray = new ByteArray();
//						for(i = 0;i< fileCount;i++)
//						{
//							var file:FZipFile = fzip.getFileAt(i);
//							//file.sizeCompressed == 0 的时候,被压缩的内容大小为0,
//							//一般情况下也就是文件夹
//							//91M=>83M
//							if(file.sizeCompressed != 0)
//							{
//								zipbytes.clear();
//								zipbytes.writeBytes(file.content);
//								//这里使用读入数据 释放 对 zipfile的引用...
//								_resolveResource(file.filename,zipbytes);
//								
//							}
//							file = null
//							
//						}
//						fzip.close();
//						fzip = null;
//						break;
//					
//					default:
//						isSucc = false;
//						_logger.info("ignore res:{0}",resourceFilePath);
//						break;
//				}
//				
//				if(isSucc)
//				{
//					//增加资源组的内部引用关联,成功增加引用
//					_addAssetsRelationGroup(_currentLoadedGroupName,resourceFilePath);
//				}
//				
//				return isSucc;
//			}
			
			
		}
		
		
		private var mRawAssets:Array =  new Array();
		
		private var _waitingQueue:Vector.<AssetQueue> = new Vector.<AssetQueue>();
		private var _currentwaitQuene:AssetQueue;
		
		/**
		 * 读取本次的队列内容需要加载的东西 
		 * @param onProgress
		 * 
		 */
		public function loadQueue(onProgress:Function):void
		{
			//正在加载资源中
			if(_state == STATE_BUSY)
			{
				Assert(_currentwaitQuene != null,"等待队列资源不存在");
				if(_currentwaitQuene == null)
					return;
				_currentwaitQuene.onProgress = onProgress;
				//把当前的资源压入
				_waitingQueue.push(_currentwaitQuene);
				_currentwaitQuene = null;
				
				return;
				
			}
			else
			{
				_state = STATE_BUSY
			}
			
			
			
			var xmls:Vector.<XML> = new <XML>[];
			var numElements:int = mRawAssets.length;
			var currentRatio:Number = 0.0;
			var timeoutID:uint;
			
			resume();
			
			var resumeTimeoutId:uint;
			
			function resume():void
			{
				clearTimeout(resumeTimeoutId);
				while(mRawAssets.length != 0)
				{
					var assetInfo:Object = mRawAssets[mRawAssets.length - 1];
					if(_hasAsset(assetInfo.asset))
					{
						_incAssetsRelationRef(assetInfo.group,assetInfo.asset);
						mRawAssets.pop();
//						_logger.info("resume loadQueue Exists group:{0} name:{1}",assetInfo.group, assetInfo.name);
						
						if(mRawAssets.length == 0)
						{
							//通过下一帧通知完成,这样可以异步起来.否则都在一次堆栈中
							resumeTimeoutId = setTimeout(resume,1);
							return;
						}
					}
					else
					{
						timeoutID = setTimeout(processNext, 1);
						break;
					}
				}
				
				currentRatio = 1.0 - (mRawAssets.length / numElements);
				if (isNaN(currentRatio))
					currentRatio = 1.0;
				if (onProgress != null)
					onProgress(currentRatio);
				//加载完成
				if(currentRatio == 1)
				{
					_processNextAssetQueue();
				}
			}
			
			
			
			
			function processNext():void
			{
				var assetInfo:Object = mRawAssets.pop();
				clearTimeout(timeoutID);
				if(assetInfo == null)
				{
					resume();
				}
				else if(_hasAsset(assetInfo.asset))//已经包含资源
				{
					Assert(false,"加载出现重复资源 {0}:{1}",assetInfo.group,assetInfo.asset);
					//增加资源和组的关联
					_incAssetsRelationRef(assetInfo.group,assetInfo.asset);
//					_logger.info("loadQueue Exists group:{0} name:{1}",assetInfo.group, assetInfo.name);
					resume();
				}
				else
				{	
					_loadRawAsset(assetInfo.name,assetInfo.group, assetInfo.asset, resume);
				}
				
				
			}
			
			

		}
		
		//处理下一个延时调用队列
		private function _processNextAssetQueue():void
		{
			_state = STATE_FREE;
			if(_waitingQueue.length == 0)
			{
				
			}
			else
			{
				var _nextQueue:AssetQueue = _waitingQueue.pop();
				//加载下一个
				while(_nextQueue.resourceQueue.length != 0)
				{
					var _nextAsset:AssetQueueStruct = _nextQueue.resourceQueue.pop();
					_loadPrepareInQueue(_nextAsset.group,_nextAsset.Assets);
				}
				
				//开始加载下一个资源
				loadQueue(_nextQueue.onProgress);
				
				_nextQueue.onProgress = null;
				_nextQueue.resourceQueue = null;
			}
		}

		/**
		 * 批量加载资源 
		 * @param group 虚拟组 这里是弱分组概念,也就是其它资源保持引用 并且资源名称不能重复的
		 * @param Assets 资源
		 */
		public function loadPrepareInQueue(group:String,...Assets):void
		{
//			Assert(_currentwaitQuene == null,"资源加载错误,上一个资源没调用loadQueue");
			
			//正在加载资源中
			loadPrepareInQueueWithArray(group,Assets);
		}
		
		public function loadPrepareInQueueWithArray(group:String,Assets:Array):void
		{
			Assets = SArrayUtil.deleteRepeat(Assets);
			if(_state == STATE_BUSY)
			{
				if(_currentwaitQuene == null)
				{
					_currentwaitQuene = new AssetQueue();
				}
				_currentwaitQuene.resourceQueue.push(new AssetQueueStruct(group,Assets));
				
				//返回
				return;
			}
			
			_loadPrepareInQueue(group,Assets);
		}
		
		/**
		 * 把资源载入队列 
		 * @param group
		 * @param Assets
		 * 
		 */
		private function _loadPrepareInQueue(group:String,Assets:Array):void
		{
			
			for each (var rawAsset:Object in Assets)
			{
				if (rawAsset is String)
				{
					push(rawAsset , group);
				}
			}
			
			function push(asset:Object, groupName:String,name:String=null):void
			{
				if (name == null) name = getName(asset);
//				_logger.info("Enqueuing group:{0} name:{1}",groupName, name);
				
				mRawAssets.push({ 
					name: name, 
					group: groupName,
					asset: asset 
				});
			}
		}
		/**
		 * 加载的资源索引,主键是assetname 
		 */
		private var _LoadedAssetDic:Dictionary = new Dictionary();
		
		/**
		 * 加载的资源组索引,主键是groupname 
		 */
		private var _LoadedAssetGroupDic:Dictionary = new Dictionary();
		
		/**
		 * 当前加载的资源组名称 
		 */
		private var _currentLoadedGroupName:String = "";
		
		/**
		 * 增加 已有资源的引用
		 * @return 
		 * 
		 */
		protected function _incAssetsRelationRef(groupname:String,assetname:String):void
		{
			var extension:String;
			var url:String = assetname as String;
			extension = (url.split(".").pop() as String).toLowerCase();
			var length:int = 0;
			switch (extension)
			{
				case "anims":
					
					//维护引用数量
					var jsonArr:Array = getObject(assetname) as Array;
					if(jsonArr != null)
					{
						length = jsonArr.length;
						for(var i:int = 0;i<length;i++)
						{
							//增加资源组的内部引用关联
							_addAssetsRelationGroup(groupname,jsonArr[i]["name"]);
						}
					}
					
					break;
				case "zipd":
					var fzip:FZip = getObject(assetname) as FZip;					
					var fileCount:int = fzip.getFileCount();
					for(var i:int = 0;i< fileCount;i++)
					{
						var file:FZipFile = fzip.getFileAt(i);
						if(file.sizeCompressed != 0)
						{
							_incAssetsRelationRef(groupname,file.filename);
						}	
					}
					break;
				default:
					
					break;
			}
			
			_addAssetsRelationGroup(groupname,assetname);
		}
	
		/**
		 * 增加资源和组的关联 ,如果资源不存在 ,会自动创建
		 * @param groupname
		 * @param name name为长.保留后缀啥的
		 * 
		 */
		[inline]
		protected function _addAssetsRelationGroup(groupname:String,assetname:String):void
		{
			if(_LoadedAssetDic[assetname] == null)
			{
				_LoadedAssetDic[assetname] = assetname;
			}
			
			
			
			var _loadAssetGroup:AssetGroupData;
			if(_LoadedAssetGroupDic[groupname] == null)
			{
				_LoadedAssetGroupDic[groupname] = new AssetGroupData(groupname);
			}
			
			
			_loadAssetGroup = _LoadedAssetGroupDic[groupname];
			
			if(_loadAssetGroup.addRelationAssetDataName(assetname))
			{
				_ref_count_manager.inc_ref(assetname);
				//增加引用
			}
			else
			{
				_logger.error("Add same group:{0} same Resource:{1}",groupname,assetname);
			}
			
			
			
		}

		/**
		 * 是否包含资源 
		 * @param name
		 * @return 
		 * 
		 */
		private function _hasAsset(assetname:String):Boolean
		{
			if(_LoadedAssetDic[assetname] == null)
			{
				return false;
			}
			return true;
		}
		
		
		
		/**
		 * 真实加载资源 
		 * @param name
		 * @param groupName
		 * @param rawAsset
		 * @param onComplete
		 * 
		 */
		private function _loadRawAsset(name:String,groupName:String, rawAsset:Object,
									   onComplete:Function):void
		{
			var extension:String = null;
			
			if (rawAsset is String)
			{
				//设置当前正在加载的资源组名称
				_currentLoadedGroupName = groupName;
				
				
				var url:String = rawAsset as String;
				extension = (url.split(".").pop() as String).toLowerCase();
				switch (extension)
				{
					case "xml":
						//增加默认关联,主要对象 和组资源的基础资源 例如 zip. anims 等等
						_addAssetsRelationGroup(groupName,url);
						_loadXMLTexture(url,_defaultStarlingAsset.scaleFactor,onComplete);
						break;
					case "png":
					case "jpg":
					case "jpeg":
						//增加默认关联,主要对象 和组资源的基础资源 例如 zip. anims 等等
						_addAssetsRelationGroup(groupName,url);
						_loadTexture(url,false,false,_defaultStarlingAsset.scaleFactor,onComplete);
						break;
					default:
						_loadDefaultResource(url,onComplete,true);
						break;
				}
				

			}
		}
		
		
		/**
		 * 将图片文件去掉后缀, 获取atf文件对应文件名
		 * add by sangxu
		 * @param name 文件名
		 * @return 对应的atf文件名
		 */
		private function _getAtfRealFileName(name:String):String
		{
			var fileNamePre:String = SPathUtils.getPathPre(name);
			// 获取对应设备文件名
			return _getAtfFileName(fileNamePre);
		}
		
		/**
		 * 获取atf文件, 根据设备类型获取对应图片文件名
		 * add by sangxu
		 * @param name 不带后缀文件名
		 * @return 对应图片文件名
		 * 
		 */
		private function _getAtfFileName(name:String):String
		{
			var manufacturerType:String = SManufacturerUtils.getManufacturerType();
			var ext:String = "";
			switch(manufacturerType)
			{
				case SManufacturerUtils.TYPE_ANDROID:
					// Android
					ext = "atfa";
					break;
				case SManufacturerUtils.TYPE_IOS:
					// iOS
					ext = "atfi";
					break;
				default :
					ext = "atf";
			}
//			ext = "atf";
	
			return name + "." + ext;
		}
		
		private var _logger:Logger = Logger.getInstance(AssetManagerUtil);
		
		
		
	}
	
}
import flash.utils.Dictionary;

import engine_starling.utils.AssetManagerUtil;
import engine_starling.utils.Logger;
import engine_starling.utils.SLRUCache;

/**
 * 资源释放器 
 * @author caihua
 * 
 */
class AssetDataGC
{
	/**
	 * 析构资源 
	 * @param assetname
	 * 
	 */
	public function disposeAssetData(assetname:String):void
	{
		Logger.log("AssetManagerUtil","dispose:" + assetname);
		var objectName:String = assetname;
		
		var extension:String = null;
		var length:int,i:int;
		
		extension = (objectName.split(".").pop() as String).toLowerCase();
		switch (extension)
		{
			case "xml":
				_disposexml(objectName);
				break;
			case "png":
			case "jpg":
			case "jpeg":
				//增加资源关联
				_disposetexture(objectName);
				break;
			case "mp3":
				_disposemp3(objectName);
				break;				
			default:
				_disposenormal(objectName);
				break;
		}
	}
	
	private function _disposexml(objectName:String):void
	{
		objectName = AssetManagerUtil.o.getName(objectName);
		AssetManagerUtil.o.defaultStarlingAsset.removeTextureAtlas(objectName);
	}
	private function _disposetexture(objectName:String):void
	{
		objectName = AssetManagerUtil.o.getName(objectName);
		AssetManagerUtil.o.defaultStarlingAsset.removeTexture(objectName);
		
	}
	private function _disposemp3(objectName:String):void
	{
		AssetManagerUtil.o.removeObject(objectName);
		AssetManagerUtil.o.defaultStarlingAsset.removeSound(objectName);
		
	}
	private function _disposenormal(objectName:String):void
	{
		AssetManagerUtil.o.removeObject(objectName);
		
	}

}
class AssetDataRefCountManager
{
	private var _ref_dict:Dictionary = new Dictionary();
	/**
	 * 空引用字典 
	 */
	private var _zero_ref_dict:Dictionary = new Dictionary();
	
	private var _lru:SLRUCache = new SLRUCache(10000);
	
	public function AssetDataRefCountManager()
	{
		
	}
	public function getref(assetName:String):int
	{
		if(_ref_dict.hasOwnProperty(assetName))
		{
			return _ref_dict[assetName];
		}
		else if(_zero_ref_dict.hasOwnProperty(assetName))
		{
			return 0;
		}
		return -1;
	}
	/**
	 * 增加引用 
	 * @param assetName
	 * 
	 */
	public function inc_ref(assetName:String):void
	{
		if(_ref_dict[assetName] == null)
		{
			_ref_dict[assetName] = 0;
		}
		_ref_dict[assetName] += 1;
		delete _zero_ref_dict[assetName];
		_lru.delObject(assetName);
	}
	/**
	 * 删除引用 
	 * @param assetName
	 * 
	 */
	public function dec_ref(assetName:String):void
	{
		if(_ref_dict[assetName] == null)
		{
			return;
		}
		if(_ref_dict[assetName] > 0)
		{
			_ref_dict[assetName] -= 1;
			//最后一次释放，才填入缓冲
			if(_ref_dict[assetName] == 0){
				if(AssetManagerUtil.resourcedelayCacheTime != -1)
				{
					_lru.addObject(assetName, 1,AssetManagerUtil.resourcedelayCacheTime);
				}
				_zero_ref_dict[assetName] = 0;
			}
		}
	}
	
	public function get_zero_ref_assets():Array
	{
		var retArr:Array = new Array();
		for(var assetName:String in _zero_ref_dict)
		{
			retArr.push(assetName);
		}
		return retArr;
	}
	
	/**
	 * 清空0引用的资源 
	 * 
	 */
	public function clear_zero_ref_assets():void
	{
		_zero_ref_dict = new Dictionary();
		_lru.clear();
	
//		for(var assetName:String in _ref_dict)
//		{
//			if(_ref_dict[assetName] == 0)
//			{
//				delete _ref_dict[assetName];
//				_lru.delObject(assetName);
//			}
//		}
	}
	
	/**
	 * 获取LRU超时的图片资源 
	 * @return 
	 * 
	 */
	public function get_lru_delay_zero_ref_assets():Array
	{
		get_zero_ref_assets();
		var retArr:Array = new Array();
		for(var assetName:String in _zero_ref_dict)
		{
			//获取超时资源
			if(_zero_ref_dict[assetName] == 0 && _lru.getObject(assetName) == null)
			{
				retArr.push(assetName);
			}
		}
		
		var zeroRefAssets:Array = get_zero_ref_assets();
		trace("zero ref clear total:",zeroRefAssets.length,"clearcount:",retArr.length);
		return retArr;
	}
	
	/**
	 * 删除延时资源 
	 * @param asset
	 * 
	 */
	public function clear_lru_delay_ref_asset(asset:Array):void
	{
		var assetslenght:int = asset.length;
		for(var i:int = 0;i<assetslenght;i++)
		{
			delete _zero_ref_dict[asset[i]];
		}
	}
}
///**
// * 资源对象 
// * @author caihua
// * 
// */
//class AssetData
//{
//	public function AssetData(assetname:String)
//	{
//		_assetname = assetname;
//	}
//	private var _assetname:String;
//
//	/**
//	 * 资源名称 
//	 */
//	public function get assetname():String
//	{
//		return _assetname;
//	}
//	
//	
//	/**
//	 * @private
//	 */
//	public function set assetname(value:String):void
//	{
//		_assetname = value;
//	}
//
//	
//		
//
//}

/**
 * 资源组数据 
 * @author caihua
 * 
 */
class AssetGroupData
{
	public function AssetGroupData(groupname:String)
	{
		_groupName = groupname;
	}
	
	private var _groupName:String;

	/**
	 * 组名称 
	 */
	public function get groupName():String
	{
		return _groupName;
	}
	
	/**
	 * 相关资源对象名称 
	 */
	public var relationAssetDataName:Array = new Array();
	private var relationAssetDataNameDict:Dictionary = new Dictionary(true);
	
	/**
	 * 增加关联对象 
	 * @param name
	 * 
	 */
	public function addRelationAssetDataName(assetname:String):Boolean
	{
		if(relationAssetDataNameDict[assetname] == null)
		{
			relationAssetDataNameDict[assetname] = assetname;
			relationAssetDataName.push(assetname);
			return true;
		}
		return false;
	}
	
	/**
	 * 是否包含资源名 
	 * @param assetname 资源名称
	 * @return 
	 * 
	 */
	public function hasAssetDataName(assetname:String):Boolean
	{
		return (relationAssetDataNameDict[assetname] == null);
	}
	


}




/**
 * 资源队列 
 * @author caihua
 * 
 */
class AssetQueue
{
	public function AssetQueue()
	{
		
	}

	
	public var resourceQueue:Vector.<AssetQueueStruct> = new Vector.<AssetQueueStruct>();
	public var onProgress:Function;
}
class AssetQueueStruct
{
	public function AssetQueueStruct(group:String,resourceName:Array)
	{
		this.group = group;
		this.Assets = resourceName;
	}
	public var group:String;
	public var Assets:Array;
}

class SingletonEnforcer {
	
}