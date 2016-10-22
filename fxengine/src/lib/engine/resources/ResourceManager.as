package lib.engine.resources
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventSubject;
	import lib.engine.event.CEventVar;
	import lib.engine.iface.IResource;
	import lib.engine.resources.loader.ResourceLoader;
	import lib.engine.utils.CPathUtils;
	import lib.engine.utils.CTickUtils;
	import lib.engine.utils.CTimerUtils;
	import lib.engine.utils.functions.Assert;
	
	
	/**
	 * 资源管理器 
	 * @author caihua
	 * 
	 */
	public class ResourceManager extends CEventSubject implements IResource
	{
		private var _res:Dictionary = new Dictionary();
		private var _loadlist:Vector.<Resource> = new Vector.<Resource>();
		//当前加载资源
		private var _currentloadRes:Resource;
		private var _isloading:Boolean = false;
		private var _Resourceloaders:Dictionary = new Dictionary();
		private static var _ins:ResourceManager;
		private var _ResourceEx:ResourceEx;
		
		/**
		 * 一次最多加载文件数量
		 * 为了保障不让堆栈溢出 
		 */
		private static const _onceLoadMaxCount:int = 50;
		/**
		 * 一次加载文件数量 
		 */
		private var _OnceLoadCount:int = 0;
		
		
		
		
		public function ResourceManager()
		{
			_ResourceEx = new ResourceEx(this);
			
		}
		
		public static function get o():ResourceManager
		{
			if(_ins == null)
				_ins = new ResourceManager();
			return _ins;
		}

		protected function getResbyfullPath(AbsolutePath:String,callback:Function = null,sourcebytes:ByteArray = null):Resource
		{
			var key:String = ResourceUtils.ResPath2Key(AbsolutePath);
			if(key == "")//key 不是路径
			{
				throw Error("资源key无效" + key + "资源地址:" + AbsolutePath);
				return;
			}
			
			if(_res[key] == null)
			{
				_res[key] = new Resource(key);
			}
			
			var res:Resource = _res[key];
			
			switch(res.LoadState)
			{
				//如果已经加载完成，则直接返回资源
				case ResourceLoadState.LOADSTATE_LOADED:
				{
					if(callback != null)
						callback(res);
					return res;
				}
					//没有开始加载，直接进入加载
				case ResourceLoadState.LOADSTATE_NOLOAD:
				{
					//添加进入加载列表
					res.LoadState = ResourceLoadState.LOADSTATE_LOADING;
					res.fullpath = AbsolutePath;
					res.Relativepath = ResourceUtils.ResAbsolutePath2RelativePath(AbsolutePath);
					
					if(sourcebytes!= null)
					{
						sourcebytes.position = 0;
						res.bytes.writeBytes(sourcebytes);
						res.bytes.position = 0;
					}
					
					if(callback != null)
						res.callbacks.push(callback);
					//加载资源
					_addLoadlist(res);

					break;
				}
					//资源正在加载中，主要是快速访问同一个资源，则直接加入回调列表就可以了
				case ResourceLoadState.LOADSTATE_LOADING:
				{
					if(callback != null)
						res.callbacks.push(callback);
					break;
				}
			}
			
			return null;
		}
		/**
		 * 获取资源通过ID 
		 * @param key 如果资源根目录为 swf/fish 
		 * 例如访问 swf/fish/data/InitLoaderList.Group
		 * key 为 data.InitLoaderList
		 * 注意无后缀.无修饰
		 * 
		 * @return 如果返回null 不进行加载
		 * 
		 */
		protected function getResbyKey(key:String):Resource
		{
			return _res[key];
//			return null;
		}
		
		public function ResIsLoadedByPath(RelativePath:String):Boolean
		{
			var AbsolutePath:String = ResourceUtils.ResRelativePath2AbsolutePath(RelativePath);
			var key:String = ResourceUtils.ResPath2Key(AbsolutePath);
			if(key == "")//key 不是路径
			{
				throw Error("ResIsLoadedByPath 资源key无效" + key + "资源地址:" + AbsolutePath);
				return false;
			}
			
			if(_res[key] != null && _res[key].LoadState == ResourceLoadState.LOADSTATE_LOADED)
			{
				return true;
			}
			
			return false;
		}
		
		
		public function getResByPath(RelativePath:String,callback:Function = null,sourcebytes:ByteArray = null):Resource
		{
			var AbsolutePath:String = ResourceUtils.ResRelativePath2AbsolutePath(RelativePath);
			return getResbyfullPath(AbsolutePath,callback,sourcebytes);
		}
		protected function _loadResTick(e:TimerEvent,params:Object):void
		{
			_loadRes();
		}
		/**
		 * 添加进加载队列
		 * @param loaderRes 需要加载的资源
		 * 
		 */
		protected function _addLoadlist(loaderRes:Resource):void
		{
			//唯一性，在getRes 中已经保证，
			_loadlist.push(loaderRes);
			//开始加载
			_loadRes();
			
		}
		protected function _loadRes():void
		{
			//保证单线程加载
			if(_isloading || _loadlist.length == 0)
			{
				return;
			}
			
			_currentloadRes = _loadlist.pop();
			if(_currentloadRes == null)
			{
				return;
			}
			_isloading = true;
			
			//不是通过现成的字节流加载
			if(_currentloadRes.bytes.length == 0)
			{
				var bytesloader:URLLoader = new URLLoader();
				bytesloader.dataFormat = URLLoaderDataFormat.BINARY;
				bytesloader.load(new URLRequest(_makeRandomFileName(_currentloadRes.fullpath)));
				bytesloader.addEventListener(Event.COMPLETE,function (e:Event):void
				{
					var loader:URLLoader = e.target as URLLoader;
					_LoadBytesComplete(_currentloadRes,loader.data);
				});
			}
			else
			{
				
				_LoadBytesComplete(_currentloadRes,_currentloadRes.bytes);
			}
		}
		/**
		 * 读取二进制完成 
		 * @param e
		 * 
		 */
		private function _LoadBytesComplete(res:Resource,bytes:ByteArray):void
		{
			bytes.position = 0;
			res.bytes.writeBytes(bytes);
			res.bytes.position = 0;
			var ext:String = CPathUtils.getPathExt(res.fullpath).toLowerCase();
			if(_Resourceloaders[ext] != null)
			{
				ResourceLoader(_Resourceloaders[ext]).loader(res,_LoadResComplete);
			}
			else //没有找到后续的解释器,所以就把原始字节流作为解释后的对象
			{
				_LoadResComplete(res,bytes);
			}
		}
		/**
		 * 资源加载完成 
		 * @param value
		 * 
		 */
		protected function _LoadResComplete(res:Resource,value:*):void
		{
			var mres:Resource = _res[res.key];
			mres.value = value;
			_ResourceEx.BuildIdx(mres);
			mres.LoadState = ResourceLoadState.LOADSTATE_LOADED;
			//执行callback
			var _func:Function = null;
			while(null != (_func = mres.callbacks.shift()))
			{
				_func(mres);
			}
			
			
			//加载状态复位为空闲
			_isloading = false;
//			_loadRes();
			
			if(_loadlist.length == 0)
			{
				//加载完成本次所有资源,不是太准确
				_OnceLoadCount = 0;
				dispatchEvent(new CEvent(CEventVar.E_RESOURCELOADCOMPLETE));
			}
			else
			{
				_OnceLoadCount ++;
				if(_OnceLoadCount < _onceLoadMaxCount)
				{
					_loadRes();
				}
				else
				{
					_OnceLoadCount = 0;
					CTickUtils.o.addTick("ResourceManagerTick",1,1,_loadResTick);
				}
			}
		}
		
		public function ReleaseAll():void
		{
			
		}
		
		/**
		 * 获取指定类型的资源
		 * @param ResourceType Resource.TYPE
		 * @return resouce的数组
		 * 
		 */		
		public function getResources(ResourceType:String):Array
		{
			var arr:Array = new Array();
			for each(var res:Resource in  _res)
			{
				if(res.type == ResourceType)
				{
					arr.push(res);
				}
			}
			return arr;
		}
		
		/**
		 * 注册资源加载器 
		 * @param loader
		 * 
		 */
		public function RegisterResourceLoader(loader:ResourceLoader):void
		{
			_Resourceloaders[loader.resource_ext.toLowerCase()] = loader;
		}
		
		public function getResourceClass(key:String, classname:String, callback:Function, params:Object=null):void
		{
			var mRes:Resource = getResByPath(key);
			if(mRes != null)
			{
				var cls:Class = ResourceUtils.Res2Class(mRes,classname);
				callback(cls,params);
			}
			else
			{
				var clsloader:ResourceClassLoader = new ResourceClassLoader(classname,callback,params);
				getResByPath(key,clsloader.ResourceLoadered);
			}

			
		}
		
		
		public function getImageset(name:String):Resource
		{
			return _ResourceEx.getImageset(name);
		}
		
		public function getLayout(name:String):Resource
		{
			// TODO Auto Generated method stub
			return _ResourceEx.getLayout(name);
		}
		
		/**
		 * 生成随机资源名称 
		 * @param filename
		 * 
		 */
		private function _makeRandomFileName(filename:String):String
		{
//			http://swf.game.com/swf/fish/CApplicationFishSns-999.swf
			var ext:String = CPathUtils.getPathExt(filename);
			var extlowercase:String = ext.toLowerCase();
			if(_Resourceloaders[extlowercase] == null || 
				ResourceLoader(_Resourceloaders[extlowercase]).allowRandomName == false)
			{
				return filename;
			}
			var rtn:String = filename;
			//文件后缀
			var fileext:String = "-" + CTimerUtils.getCurrentTime().toString();
			if(extlowercase == "")
			{
				rtn = rtn + fileext;
			}
			else
			{
				rtn = rtn.substr(0,rtn.length - (extlowercase.length + 1));
				rtn = rtn + fileext + "."+ ext;
			}
			return rtn;
		}
		
		/**
		 * 允许进行资源随机访问的 
		 * @param filter 资源后缀数组,["Group","zipd"]
		 * 
		 */
		public function allowRandomResourceList(filter:Array):void
		{
			for each(var ext:String in filter)
			{
				if(_Resourceloaders[ext.toLowerCase()] != null)
				{
					ResourceLoader(_Resourceloaders[ext.toLowerCase()]).allowRandomName = true;
				}
				else
				{
					Assert(false,"设置随机资源名称时,没有找到资源加载器:{0}",ext);
				}
			}
		}
		
	}
}