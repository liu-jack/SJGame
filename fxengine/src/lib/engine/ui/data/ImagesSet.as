package lib.engine.ui.data
{
	import flash.utils.Dictionary;
	
	import lib.engine.game.bitmap.GBitmapData;
	import lib.engine.iface.IPackage;
	import lib.engine.iface.ISerialization;
	import lib.engine.utils.CPackUtils;

	/**
	 * imageset类 
	 * @author caihua
	 * 
	 */
	public class ImagesSet implements ISerialization,IPackage
	{
		
		/**
		 * ImageSet的版本号 
		 */
		public static const VER:int = 1;
		
		//防止名称重复的ID
		private var _unamedid:int = 0;
		
		
		private var _ver:int = VER;

		public function get ver():int
		{
			return _ver;
		}

		public function set ver(value:int):void
		{
			_ver = value;
		}
		
		
		private var _filename:String;
		/**
		 * 源文件名称 
		 * @return 
		 * 
		 */
		public function get filename():String
		{
			return _filename;
		}

		public function set filename(value:String):void
		{
			_filename = value;
		}
		
		private var _resfilename:String;

		/**
		 * 资源文件名 
		 * 相对文件路径
		 */
		public function get resfilename():String
		{
			return _resfilename;
		}

		/**
		 * @private
		 */
		public function set resfilename(value:String):void
		{
			_resfilename = value;
			_clearAllCached();
		}


		private var _name:String;

		/**
		 * 文件命名 
		 * @return 
		 * 
		 */
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		private var _classname:String;

		public function get classname():String
		{
			return _classname;
		}

		public function set classname(value:String):void
		{
			_classname = value;
		}

		public function ImagesSet()
		{
			
		}
		
		//private var _areas:Array = new Array();
		private var _areas:Dictionary = new Dictionary();
		
		
		/**
		 * 添加分割区域 
		 * @param picinfo
		 * 
		 */
		public function addArea(picinfo:ImageTileInfo):void
		{
			var tmpname:String = picinfo.name;
			while(_CheckNameRepeat(tmpname))
			{
				tmpname = picinfo.name + "_" + _unamedid;
				_unamedid ++;
			}
			picinfo.name = tmpname;
			_areas[picinfo.name] = picinfo;
		}
		/**
		 * 建立全区域 x=y =0 witdh=height = -1 
		 * @param ImageTileName
		 * @return 
		 * 
		 */
		public function buildfullArea(ImageTileName:String):Boolean
		{
			if(_CheckNameRepeat(ImageTileName))
				return false;
			var picinfo:ImageTileInfo = new ImageTileInfo();
			picinfo.name = ImageTileName;
			picinfo.x = picinfo.y = 0;
			picinfo.height = picinfo.width = -1;
			addArea(picinfo);
			return true;
		}
		public function getAreas():Array
		{
			var arr:Array = new Array();
			for(var key:String in _areas)
			{
				arr.push(_areas[key]);
			}
			return arr;
		}
		/**
		 * 获取指定名称区域 
		 * @param name
		 * @return 
		 * 
		 */
		public function getArea(name:String):ImageTileInfo
		{
			return _areas[name];
		}
		

		public function Serialization():String
		{
			
			
			var serializationString:String = JSON.stringify(Pack());
			return serializationString;
		}
		
		public function UnSerialization(object:String):void
		{
			var inputobj:Object = JSON.parse(object);
			UnPack(inputobj);			
		}
		/**
		 * 检查名称是否重复，
		 *  
		 * @param mname 要检查的名称
		 * @return T 重复，F 不重复
		 * 
		 */
		protected function _CheckNameRepeat(mname:String):Boolean
		{
			return _areas[mname] != null;
		}
		public function Reset():void
		{
			filename = "";
			classname = "";
			name ="";
			
			for( var key:String in _areas)
			{
				delete _areas[key];
			}
			//_areas = [];
		}
		
		public function Pack():Object
		{
			var output:Object = new Object();
			
			CPackUtils.PacktoObject(this,output);

			output.area = new Array();
			for each(var a: ImageTileInfo in  _areas)
			{
				output.area.push(a.Pack());
			}
			
			return output;
		}
		
		public function UnPack(obj:Object):void
		{

			CPackUtils.UnPackettoObject(obj,this,false);
			
			for each(var areainfo:Object in obj.area)
			{
				var picinfo : ImageTileInfo = new ImageTileInfo();

				picinfo.UnPack(areainfo);
				addArea(picinfo);
			}
			
		}
		
		private var _GBitmapCache:Dictionary = new Dictionary();
//		private var _GBitmapCacheBackBuffer:GBitmapData;
		
//		private static const Cached_OK:String = "Cached_OK";
//		private static const Cached_Ing:String = "Cached_Ing";
//		private static const Cached_None:String = "Cached_None";
//		private var _CachedState:String = Cached_None;
		/**
		 * 获取指定区域缓存 
		 * @param name
		 * @return 
		 * 
		 */
		public function getAreaGBitmap(name:String):GBitmapData
		{
			if(_GBitmapCache[name] != null)
			{
				return _GBitmapCache[name];
			}
			else
			{
//				_BuildCache(name);
				return null;
			}
		}
		public function Cached(name:String,data:GBitmapData):void
		{
			_GBitmapCache[name] = data;
		}
		
		protected function _clearAllCached():void
		{
			_GBitmapCache = new Dictionary();
		}
//		protected function _BuildCache(name:String):void
//		{
//			if(_GBitmapCacheBackBuffer == null)
//			{
//				ResourceManager.o.getResourceClass(resfilename,classname,_loadResourceClassComplete,{'areaname':name});
//			}
//			else
//			{
//				var info:ImageTileInfo = getArea(name);
//				_GBitmapCache[name] = new GBitmapData(DisplayObject(_GBitmapCacheBackBuffer.dataMix),info.x,info.y,info.width,info.height);
//			}
//		}
//		protected function _loadResourceClassComplete(cls:Class,params:Object):void
//		{
//			var superclassname:String = getQualifiedSuperclassName(cls);
//			if( superclassname == "flash.display::BitmapData")
//			{
//				_GBitmapCacheBackBuffer = new GBitmapData(new cls(0,0));
//			}
//			else
//			{
//				_GBitmapCacheBackBuffer = new GBitmapData(new cls());
//			}
//			
//			var _areaname:String = params.areaname;
//			_BuildCache(_areaname);
//		}
		
	}
}