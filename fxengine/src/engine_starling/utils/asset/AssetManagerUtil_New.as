package engine_starling.utils.asset
{
	import engine_starling.Events.AssetEvent;
	import engine_starling.SApplication;
	import engine_starling.utils.SAssetsCache;
	
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class AssetManagerUtil_New extends EventDispatcher
	{
		public function AssetManagerUtil_New()
		{
			_memCache = new SAssetsCache;
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
		 * 内存缓存 
		 */
		private var _memCache:SAssetsCache;
		private var _defaultStarlingAsset:AssetManager = SApplication.assets;
		private var _loadedAssets:Dictionary = new Dictionary();
		private var _loadedGroupAsset:Dictionary = new Dictionary();
		
		
		private static var _o:AssetManagerUtil_New = null;
		
		public static function get o():AssetManagerUtil_New
		{
			if(_o == null)
				_o = new AssetManagerUtil_New();
			return _o;
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
		
		public function init():void
		{
			_memCache.reloadCheckFile(function ():void{
				dispatchEventWith(AssetEvent.INIT_COMPLETE,false,{code:1});
			},function ():void
			{
				dispatchEventWith(AssetEvent.INIT_COMPLETE,false,{code:0});
			});
		}
		
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
		
		private var _waitingQueue:Vector.<AssetQueue> = new Vector.<AssetQueue>();
		private var _currentwaitQuene:AssetQueue;
		private var _currentloadQueue:AssetQueue;
		
		/**
		 * 批量加载资源 
		 * @param group 虚拟组 这里是弱分组概念,也就是其它资源保持引用 并且资源名称不能重复的
		 * @param Assets 资源
		 */
		public function loadPrepareInQueue(group:String,...Assets):void
		{
			loadPrepareInQueueWithArray(group,Assets);
		}
		public function loadPrepareInQueueWithArray(group:String,Assets:Array):void
		{
			if(_currentwaitQuene == null)
			{
				_currentwaitQuene = new AssetQueue(group);
				_waitingQueue.push(_currentwaitQuene);
			}
			_currentwaitQuene.pushAssets(Assets);
		}
		
		private function _hasAsset(assetname:String):Boolean
		{
			return _loadedAssets.hasOwnProperty(assetname);
		}
		/**
		 * 把资源载入队列 
		 * @param group
		 * @param Assets
		 * 
		 */
		private function _loadPrepareInQueue(assetQueue:AssetQueue):void
		{
			_currentloadQueue = assetQueue;
		}
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
				_currentwaitQuene = null;
				_state = STATE_BUSY;
			}
			
			//有资源就继续加载
			if(_waitingQueue.length != 0)
			{
				_currentloadQueue = _waitingQueue.shift();
				if(onProgress != null)
				{
					_currentloadQueue.onProgress = onProgress;	
				}
			}
			else
			{
				_state = STATE_FREE;
				return;
			}
			
			var mRawAssets:Array = [].concat(_currentloadQueue.assets);
			var numElements:int = mRawAssets.length;
			var currentRatio:Number = 0.0;
			var timeoutID:uint;
			
			resume();
			
			function resume():void
			{
				if(mRawAssets.length != 0)
				{
					timeoutID = setTimeout(_processNext, 1);
				}
				currentRatio = mRawAssets.length ? 1.0 - (mRawAssets.length / numElements) : 1.0;
				//加载完成
				if(currentRatio == 1)
				{
					//当前资源加入列表
					_loadedGroupAsset[_currentloadQueue.groupName] = _currentloadQueue;
					timeoutID = setTimeout(_processNextAssetQueue, 1);
				}
				if (_currentloadQueue.onProgress != null)
					_currentloadQueue.onProgress(currentRatio);
			}
			
			function _processNext():void
			{
				var assetInfo:String = mRawAssets.pop();
				var loadedAsset:AssetObject;
				if(_hasAsset(assetInfo))
				{
					loadedAsset = _loadedAssets[assetInfo];
				}
				else
				{
					loadedAsset = new AssetObject(assetInfo,_memCache,_defaultStarlingAsset);
				}
				loadedAsset.addEventListener(AssetObject.EVENT_COMLPETE,_onloadedSucc);
				loadedAsset.addEventListener(AssetObject.EVENT_LOADERROR,_onloadedFailed);
				loadedAsset.loadAsset(assetInfo);
				
				function _onloadedSucc(e:Event):void
				{
					var asset:AssetObject = e.target as AssetObject;
					asset.removeEventListener(AssetObject.EVENT_COMLPETE,_onloadedSucc);
					asset.removeEventListener(AssetObject.EVENT_LOADERROR,_onloadedFailed);
					
					_loadedAssets[asset.assetName] = asset;
					resume();
				}
				
				function _onloadedFailed(e:Event):void
				{
					var asset:AssetObject = e.target as AssetObject;
				}
			}
			
			/**
			 * 处理下一组资源 
			 * 
			 */
			function _processNextAssetQueue():void
			{
				_state = STATE_FREE;
				_currentloadQueue.loadfinish();
				_currentloadQueue = null;
				loadQueue(null);
			}
			
		}
		
		/**
		 * 卸载资源组 
		 * @param groupName 资源组名称
		 * @param bdispose 是否销毁资源 false 不销毁 true 如果资源引用为空 直接销毁了
		 * 
		 */
		public function disposeAssetsByGroup(groupName:String,bdispose:Boolean = true):void
		{
			var disposegroup:AssetQueue = _loadedGroupAsset[groupName];
			if(disposegroup == null)
			{
				return;
			}
			var length:int = disposegroup.assets.length;
			for (var i:int = 0;i<length;i++)
			{
				var asset:AssetObject = _loadedAssets[disposegroup.assets[i]];
				if(asset != null)
				{
					asset.dispose();
					if(asset.zero_ref())
					{
						delete _loadedAssets[disposegroup.assets[i]]
					}
					
				}
			}
			disposegroup.dispose();
			
			delete _loadedGroupAsset[groupName];
			
		}
		
		/**
		 * 获取对象 
		 * @param key
		 * @return 
		 * 
		 */
		public function getObject(key:String):Object
		{
			var extension:String = null;
			
			extension = (key.split(".").pop() as String).toLowerCase();
			if(extension == "mp3")
			{
				return _defaultStarlingAsset.getSound(key);
			}
			else if(extension == "sxml")
			{
				return _defaultStarlingAsset.getXml(key);
			}
			return _defaultStarlingAsset.getObject(key);
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
		public function removeUnusedResource():void
		{
			System.pauseForGCIfCollectionImminent(0);
			System.gc();
		}
		
		/**
		 * 是否包含资源 
		 * @param key
		 * @return 
		 * 
		 */
		public function hasAsset(key:String):Boolean
		{
			return _loadedAssets[key] != null;
		}
		
		
		
	}
	
}
