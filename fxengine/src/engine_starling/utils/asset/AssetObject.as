package engine_starling.utils.asset
{
	import com.deng.fzip.FZip;
	import com.deng.fzip.FZipFile;
	
	import engine_starling.utils.SAssetsCache;
	import engine_starling.utils.SAssetsCacheLoadParams;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SPathUtils;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import starling.core.Starling;
	import starling.textures.AtfData;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	/**
	 * 资源对象 
	 * @author caihua
	 * 
	 */
	internal class AssetObject extends AssetObjectRefCount
	{
		public function AssetObject(assetName:String,mem:SAssetsCache,StarlingAsset:AssetManager)
		{
			super();
			
			_memCache = mem;
			_defaultStarlingAsset = StarlingAsset;
			_assetName = assetName;
			
		}
		private var _assetName:String = "";
		/**
		 * 内存缓冲 
		 */
		private var _memCache:SAssetsCache;
		/**
		 * 资源路径 
		 */
		private var _respath:String = "";
		/**
		 * 子资源 
		 */
		private var _subAssetsArray:Array = new Array();
		
		private var _resshortname:String = "";
		/**
		 * 加载文件后缀 
		 */
		private var _extension:String = "";
		
		/**
		 * 资源名称 
		 */
		public function get assetName():String
		{
			return _assetName;
		}

//		private var _onSucc:Function = null;
//		
//		private var _onFailed:Function = null;
		private var _defaultStarlingAsset:AssetManager = null;
		
		
		private static const STATE_UNLOAD:String = "STATE_UNLOAD";
		private static const STATE_LOADING:String = "STATE_LOADING";
		private static const STATE_LOADED:String = "STATE_LOADED";
		
		
		private var _state:String = STATE_UNLOAD;
		
		
		public static const EVENT_LOADING:String = "EVENT_LOADING";
		public static const EVENT_COMLPETE:String = "EVENT_COMLPETE";
		public static const EVENT_LOADERROR:String = "EVENT_LOADERROR";
		
		
		/**
		 * 加载资源 
		 * @param path 资源加载路径
		 * @param onSucc 加载成功函数
		 * @param onFailed 加载失败函数
		 * 
		 */
		public function loadAsset(path:String):void
		{
			
			inc_ref();
			if(_state == STATE_LOADED)
			{
				_complete(true);
				return;
			}
			else if(_state == STATE_LOADING)
			{
				return;
			}
			
			
			_state = STATE_LOADING;
			
			
			_respath = path;
			_resshortname = _getResShortName(_respath);
			_extension = (_respath.split(".").pop() as String).toLowerCase();
			
			switch(_extension)
			{
				case "xml":
					_loadXMLTextureAsset();
					break;
				case "zipd":
					_loadZipdAsset();
					break;
				case "jpg":
				case "jpeg":
				case "png":
				case "gif":
					_loadNormalPicsAsset();
					break;
				case "mp3":
				case "sxml":
				case "anims":
				case "json":
				case "cmds":
					_loadNormalAsset();
					break;
				default:
					//默认加载字节序
					_loadBytesAsset()
					break;
			}
		}
		/**
		 * 销毁资源 
		 * 
		 */
		public function dispose():void
		{
			
			this.dec_ref();
			if(zero_ref() == false)
			{
				return;
			}
			
			
			switch(_extension)
			{
				case "xml":
					_disposeXMLTextureAsset();
					break;
				case "zipd":
					_disposeZipdAsset();
					break;
				case "jpg":
				case "jpeg":
				case "png":
				case "gif":
					_disposeNormalPicsAsset();
					break;
				case "mp3":
				case "sxml":
				case "anims":
				case "json":
				case "cmds":
					_disposeNormalAsset();
					break;
				default:
					//默认加载字节序
					_disposeBytesAsset()
					break;
			}
			
			
			_state = STATE_UNLOAD;
		}
		
		private function _disposeXMLTextureAsset():void
		{
			_defaultStarlingAsset.removeTextureAtlas(_resshortname);
		}
		
		private function _disposeZipdAsset():void
		{
			var length:int = _subAssetsArray.length;
			var assetfilename:String = "";
			var extension:String = ""
			for (var i:int = 0;i<length;i++)
			{
				assetfilename = _subAssetsArray[i];
				extension = (assetfilename.split(".").pop() as String).toLowerCase();
				
				switch(extension)
				{
					case "pex":
					case "sxml":
						_defaultStarlingAsset.removeXml(assetfilename);
						break;
					
					case "mp3":
						_defaultStarlingAsset.removeSound(assetfilename);
						break;
					case "json":
					case "cmds":
						_defaultStarlingAsset.removeObject(assetfilename);
						break;
					default:
						_defaultStarlingAsset.removeObject(assetfilename);
						break;
				}
			}
			_subAssetsArray = [];
		}
		
		private function _disposeNormalPicsAsset():void
		{
			_defaultStarlingAsset.removeTexture(_resshortname);
		}
		
		private function _disposeNormalAsset():void
		{
//			switch(_extension)
//			{
//				case "pex":
//				case "sxml":
//					_defaultStarlingAsset.removeXml(_respath);
//					break;
//				
//				case "anims":
//					var length:int = _subAssetsArray.length;
//					var assetfilename:String = "";
//					for (var i:int = 0;i<length;i++)
//					{
//						assetfilename = _subAssetsArray[i];
//						_defaultStarlingAsset.removeObject(assetfilename);
//					}
//					break;
//				case "mp3":
//					_defaultStarlingAsset.removeSound(_respath);
//					break;
//				case "json":
//				case "cmds":
//					_defaultStarlingAsset.removeSound(_respath);
//					break;
//			}
		}
		/**
		 * 删除二进制资源 
		 * 
		 */
		private function _disposeBytesAsset():void
		{
			_defaultStarlingAsset.removeByteArray(_respath);
		}
		
		/**
		 * 通知外部是否完成 
		 * @param succ
		 * 
		 */
		private function _complete(succ:Boolean):void
		{
			if(succ)
			{
				_state = STATE_LOADED;
				dispatchEventWith(EVENT_COMLPETE);
			}
			else
			{
				_state = STATE_UNLOAD;
				dispatchEventWith(EVENT_LOADERROR);
			}
		}
		
		/**
		 * 加载XML资源 
		 * 
		 */
		private function _loadXMLTextureAsset():void
		{
			_memCache.loadDataFromCacheOrURL(_respath,_onComplate);
			
			function _onComplate(e:SAssetsCacheLoadParams):void
			{
				if(e.isSucc == false)
				{
					_complete(false);
					return;
				}
				var bytes:ByteArray = e.buffer;
				
				var resxml:XML = new XML(bytes);
				
				bytes.clear();
				
				var rootNode:String = resxml.localName();
				if(rootNode == "TextureAtlas")
				{
					//加载远程图片
					var remoteResouceFullName:String = resxml.@imagePath.toString();
					remoteResouceFullName = SPathUtils.getPathPre(remoteResouceFullName);
					remoteResouceFullName = _convertAtfName(remoteResouceFullName);
					var remoteResouceShortName:String = _resshortname;
					var atlasTexture:TextureAtlas = _defaultStarlingAsset.getTextureAtlas(remoteResouceShortName);
					
					if(atlasTexture == null)
					{
						_memCache.loadDataFromCacheOrURL(remoteResouceFullName,
							function finish(e:SAssetsCacheLoadParams):void
							{
								if(e.isSucc == false)
								{
									_complete(false);
								}
								else
								{
									bytes = e.buffer;
									if(AtfData.isAtfData(bytes))
									{
										starling.textures.Texture.fromAtfData(bytes,
											Starling.contentScaleFactor,
											false,
											function loaded(loadedtexture:Texture):void{
											
												//添加到默认资源管理器
												_defaultStarlingAsset.addTextureAtlas(remoteResouceShortName,new TextureAtlas(loadedtexture, resxml));
												bytes.clear();
												_complete(true);
												
										});
									}
									else
									{
										_complete(false);
									}
									
								}
								
								System.disposeXML(resxml);
							});
					}
					else
					{
						_complete(true);
						System.disposeXML(resxml);
					}
					
				}
				else
				{
					_complete(false);
					System.disposeXML(resxml);
				}
				
			}
			
			/**
			 * 转换贴图名称 
			 * @param name 不带后缀名称
			 * @return 
			 * 
			 */
			function _convertAtfName(name:String):String
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
				return name + "." + ext;
			}
		}
		
		/**
		 * 获取资源短名称 
		 * @param resFullName
		 * 
		 */
		private function _getResShortName(resFullName:String):String
		{
			var matches:Array;
			var name:String;
			
			name = resFullName.replace(/%20/g, " "); // URLs use '%20' for spaces
			matches = /(.*[\\\/])?([\w\s\-]+)(\.[\w]{1,4})?/.exec(name);
			
			if (matches && matches.length == 4) return matches[2];
			else throw new ArgumentError("Could not extract name from String '" + resFullName + "'");
		}
		
		/**
		 * 加载内存资源 
		 * 
		 */
		private function _loadBytesAsset():void
		{
			_memCache.loadDataFromCacheOrURL(_respath,_onComplate);
			function _onComplate(e:SAssetsCacheLoadParams):void
			{
				if(e.isSucc == false)
				{
					_complete(false)
				}
				else
				{
					var bytes:ByteArray = e.buffer;
					_defaultStarlingAsset.addByteArray(_respath,bytes);
					_complete(true);
				}
			}
		}
		
		/**
		 * 加载通用图片资源 
		 * 
		 */
		private function _loadNormalPicsAsset():void
		{
			_memCache.loadDataFromCacheOrURL(_respath,_onComplate);
			function _onComplate(e:SAssetsCacheLoadParams):void
			{
				if(e.isSucc == false)
				{
					_complete(false)
				}
				else
				{
					var bytes:ByteArray = e.buffer;
					var shortName:String = _resshortname;
					
					var imageloader:Loader = new Loader();
					var context:LoaderContext = new LoaderContext();
					context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
					imageloader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,function loadComplete(e:*):void
					{
						var resourceLoaderInfo:LoaderInfo = e.target as LoaderInfo;
						var texture:Texture = starling.textures.Texture.fromBitmap(resourceLoaderInfo.content as Bitmap,false,false,Starling.contentScaleFactor);
						_defaultStarlingAsset.addTexture(shortName,texture);
						bytes.clear();
						//通知外部加载完成
						_complete(true);
						
					});
					imageloader.loadBytes(bytes,context);
				}
			}
		}
		private function _loadNormalAsset():void
		{
			
			_complete(true);
			
//			var bHasAsset:Boolean = false;
//			//内存中查找是否有对象。
//			switch(_extension)
//			{
//				case "json":
//				case "cmds":
//					bHasAsset = _defaultStarlingAsset.getObject(_respath)== null?false:true;
//					break;
//				case "pex":
//				case "sxml":
//					bHasAsset = _defaultStarlingAsset.getXml(_respath)== null?false:true;
//					break;
//				
//				case "anims":
//					var jsonArr:Array;
//					jsonArr = JSON.parse(bytes.toString()) as Array;
//					length = jsonArr.length;
//					for(var i:int = 0;i<length;i++)
//					{
//						_subAssetsArray.push(jsonArr[i]["name"]);
//						
//						_defaultStarlingAsset.addObject(jsonArr[i]["name"],jsonArr[i]);
//					}
//					break;
//				case "mp3":
//					var sound:Sound = new Sound();
//					bHasAsset = _defaultStarlingAsset.getObject(_respath)== null?false:true;
//					break;
//				default:
//					bHasAsset = _defaultStarlingAsset.getObject(_respath)== null?false:true;
//					break;
//			}
//			
//			//加载普通资源。
//			_memCache.loadDataFromCacheOrURL(_respath,_onComplate);
//			function _onComplate(e:SAssetsCacheLoadParams):void
//			{
//				if(e.isSucc == false)
//				{
//					_complete(false)
//				}
//				else
//				{
//					var bytes:ByteArray = e.buffer;
//					_addZipdRawAsset(_respath,bytes);
//					bytes.clear();
//					_complete(true);
//				}
//			}
		}
		private function _addZipdRawAsset(filename:String,buffer:ByteArray):void
		{
			var bytes:ByteArray = buffer;
			bytes.position = 0;
			var length:int = 0;
			var extension:String = (filename.split(".").pop() as String).toLowerCase();
			switch(extension)
			{
				case "json":
				case "cmds":
					_subAssetsArray.push(filename);
					_defaultStarlingAsset.addObject(filename,JSON.parse(bytes.toString()));
					break;
				case "pex":
				case "sxml":
//					_subAssetsArray.push(filename);
					_defaultStarlingAsset.addXml(filename,new XML(bytes.toString()));
					break;
				
				case "anims":
					var jsonArr:Array;
					jsonArr = JSON.parse(bytes.toString()) as Array;
					length = jsonArr.length;
					for(var i:int = 0;i<length;i++)
					{
//						_subAssetsArray.push(jsonArr[i]["name"]);
						
						_defaultStarlingAsset.addObject(jsonArr[i]["name"],jsonArr[i]);
					}
					jsonArr = null;
					break;
				case "mp3":
					var sound:Sound = new Sound();
					sound.loadCompressedDataFromByteArray(bytes, bytes.length);
					_defaultStarlingAsset.addSound(filename,sound);
//					_subAssetsArray.push(filename);
					break;
			}
		}
		/**
		 * 加载zipd资源 
		 * 
		 */
		private function _loadZipdAsset():void
		{
			_memCache.loadDataFromCacheOrURL(_respath,_onComplate);
			function _onComplate(e:SAssetsCacheLoadParams):void
			{
				if(e.isSucc == false)
				{
					_complete(false)
				}
				else
				{
					var bytes:ByteArray = e.buffer;
					
					var fzip:FZip = new FZip();
					fzip.loadBytes(bytes);
					var fileCount:int = fzip.getFileCount();
					var zipbytes:ByteArray = new ByteArray();
					for(var i:int = 0;i< fileCount;i++)
					{
						var file:FZipFile = fzip.getFileAt(i);
						if(file.sizeCompressed != 0)
						{
							zipbytes.clear();
							zipbytes.writeBytes(file.content);
							//这里使用读入数据 释放 对 zipfile的引用...
							_addZipdRawAsset(file.filename,zipbytes);	
							file.content.clear();
								
						}
						
						file = null;
					}
					zipbytes.clear();
					bytes.clear();
					fzip.close();
					fzip = null;
					
					_complete(true);
					
				}
			}
		}
		
		
		
		
		
	}
}