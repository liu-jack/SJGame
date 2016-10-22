package lib.engine.game.data.anim
{
	import flash.display.MovieClip;
	
	import lib.engine.game.bitmap.GBitmapDataAnim;
	import lib.engine.game.data.GameData;
	import lib.engine.resources.ResourceManager;
	
	/**
	 * 单个动画描述 
	 * @author caihua
	 * 
	 */
	public class GameData_Anim extends GameData
	{
		public function GameData_Anim()
		{
			super();
		}
		private var _name:String;
		
		/**
		 * 动画名称 
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}
		
		private var _loop:Boolean;
		
		/**
		 * 是否为循环动画 
		 */
		public function get loop():Boolean
		{
			return _loop;
		}
		
		/**
		 * @private
		 */
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		private var _fps:int;
		
		/**
		 * 帧数 
		 */
		public function get fps():int
		{
			return _fps;
		}
		
		/**
		 * @private
		 */
		public function set fps(value:int):void
		{
			_fps = value;
		}
		
		private var _startframe:int;
		
		/**
		 * 开始关键帧 
		 */
		public function get startframe():int
		{
			return _startframe;
		}
		
		/**
		 * @private
		 */
		public function set startframe(value:int):void
		{
			_startframe = value;
		}
		
		private var _endframe:int;
		
		/**
		 * 结束关键帧 
		 */
		public function get endframe():int
		{
			return _endframe;
		}
		
		/**
		 * @private
		 */
		public function set endframe(value:int):void
		{
			_endframe = value;
		}
		
		
		private var _classname:String;
		
		/**
		 * 导出类名称 
		 */
		public function get classname():String
		{
			return _classname;
		}
		
		/**
		 * @private
		 */
		public function set classname(value:String):void
		{
			_classname = value;
		}
		
		
		private var _Cache:Vector.<GBitmapDataAnim>;
		private var _CacheState:String = GameData_AnimCacheState.Cached_None;
		private var _CachedCallBackList:Array = new Array();
		

		/**
		 * 建立缓存 
		 * @param AnimGroupData
		 * @param callback function(Groupdata:GameData_AnimGroup,animData:GameData_Anim):void
		 * @return 
		 * 
		 */
		public function BuildCache(AnimGroupData:GameData_AnimGroup,callback:Function = null):Boolean
		{
			if(_CacheState == GameData_AnimCacheState.Cached_OK)
			{
				return true;
			}
			if(_CacheState == GameData_AnimCacheState.Cached_Ing)
			{
				if(callback != null)
					_CachedCallBackList.push(callback);
				return false;
			}
			_CacheState = GameData_AnimCacheState.Cached_Ing;
			if(callback != null)
				_CachedCallBackList.push(callback);
			
			ResourceManager.o.getResourceClass(AnimGroupData.resPath,classname,_loadClassComplete,{'AnimGroupData':AnimGroupData});
			return false;
		}
		
		private function _loadClassComplete(cls:Class,params:Object):void
		{
			var animData:GameData_AnimGroup = params.AnimGroupData;
			var movie:MovieClip = new cls();
			movie.stop();
			var vec:Vector.<GBitmapDataAnim> = new Vector.<GBitmapDataAnim>();
			for(var i:int = this.startframe;i<=this.endframe;i++)
			{
				movie.gotoAndStop(i);
				vec.push(new GBitmapDataAnim(movie));
			}
			
			Cache(vec);
			
			_CacheState = GameData_AnimCacheState.Cached_OK;
			var func:Function;
			
			while(null != (func = _CachedCallBackList.shift()))
			{
				func(animData,this);
			}
			
		}
		public function Cache(mCache:Vector.<GBitmapDataAnim>):void
		{
			_Cache = mCache;
		}
		public function getCache():Vector.<GBitmapDataAnim>
		{
			return _Cache;
		}
		
		
	}
}