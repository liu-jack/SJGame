package engine_starling.data
{
	import com.hurlant.crypto.symmetric.AESKey;
	import com.hurlant.crypto.symmetric.CBCMode;
	import com.hurlant.crypto.symmetric.NullPad;
	import com.hurlant.util.Hex;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import engine_starling.SApplicationConfig;
	import engine_starling.utils.SPathUtils;

	internal class SDataOperate extends SDataAbstract
	{
		private var _autoSaveCache:Boolean = false;
		private var _encryptCache:Boolean = true;
		//暂时不缓存的DB了 因为有大数据存在..读取和写入都比较慢
//		private var _cachetoDB:Boolean = false;
//		private static var _sqliteCache:SDataSqliteCache = null;
		

		/**
		 * 自动保存到缓存 
		 */
		public function get autoSaveCache():Boolean
		{
			return _autoSaveCache;
		}

		/**
		 * @private
		 */
		public function set autoSaveCache(value:Boolean):void
		{
			_autoSaveCache = value;
		}

		
		public function SDataOperate(dataBasename:String)
		{
			super(dataBasename);
			

			
		}
		
		/**
		 * 临时文件 
		 * @return 
		 * 
		 */
		private function get _tmpFile():String
		{
			return File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceDataCachePath + dataBasename + ".txt";
		}
		/**
		 * 缓存文件名称 
		 * @return 
		 * 
		 */
		private function get _cacheFile():String
		{
			return File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceDataCachePath + dataBasename + ".txt";
		}
		
		private function get _cacheDB():String
		{
			return File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceDataCachePath + dataBasename + ".db";
		}
		/**
		 * 保持到缓存 
		 * @param async:
		 * @param tmp: 是否存储到临时文件
		 */
		public function saveToCache(async:Boolean = false,tmp:Boolean = false):void
		{
			if (tmp)
			{
				saveTo(_tmpFile,async);
			}
			else
			{
				saveTo(_cacheFile,async);
			}
		}
		
		public function saveTo(path:String,async:Boolean = false):void
		{
			
//			var starttime:Number = CTimerUtils.getCurrentTime();
			var saveArray:ByteArray = new ByteArray();
			saveArray.writeObject(_dataContains);
			if(_encryptCache)
			{
				const _encryptVI:ByteArray = Hex.toArray("000102030405060708090a0b0c0d0e0f");
				var _cbc:CBCMode;
				var keyArray:ByteArray = Hex.toArray("040506" + dataBasename);
				var Key:AESKey = new AESKey(keyArray);
				_cbc = new CBCMode(Key, new NullPad);
				_cbc.IV = _encryptVI;
				_cbc.encrypt(saveArray);
				_cbc = null;
				
				keyArray.clear();
				Key.dispose();
			}
			
			if (async)
			{
				SPathUtils.o.WriteByteArrayToFile(saveArray,path);
			}
			else
			{
				SPathUtils.o.WriteByteArrayToFile(saveArray,path);
			}
			saveArray.clear();
			saveArray = null;
//			var endtime:Number = CTimerUtils.getCurrentTime() - starttime;
//			
//			Logger.log("SDataOperate","exec time:"  +endtime + " " + path);

			
		}
		/**
		 * 从缓存读取文件 
		 * 
		 */
		public function loadFromCache(tmp:Boolean = false):void
		{
			load(tmp?_tmpFile:_cacheFile);
		}
		[inline]
		public function load(path:String):void
		{
//			var starttime:Number = CTimerUtils.getCurrentTime();
			var saveArray:ByteArray = new ByteArray();
			if(SPathUtils.o.readFileToByteArray(path,saveArray))
			{
				try
				{
					if(_encryptCache)
					{
						const _encryptVI:ByteArray = Hex.toArray("000102030405060708090a0b0c0d0e0f");
						var _cbc:CBCMode;
						var keyArray:ByteArray = Hex.toArray("040506" + dataBasename);
						var Key:AESKey = new AESKey(keyArray);
						_cbc = new CBCMode(Key, new NullPad);
						_cbc.IV = _encryptVI;
						_cbc.decrypt(saveArray);
						
						keyArray.clear();
						saveArray.position = 0;
						Key.dispose();
						_cbc = null;
					}
					
					_dataContains = saveArray.readObject();
					
				}
				catch(e:Error)
				{
					//解析或者读取错误	
				}
				finally{
					saveArray.clear();
					saveArray = null;
				}
			}
//			var endtime:Number = CTimerUtils.getCurrentTime() - starttime;
//			
//			Logger.log("SDataOperate","load exec time:"  +endtime + " " + path);
		}
		[inline]
		override public function delData(key:String):void
		{
			super.delData(key);
			if(_autoSaveCache)
			{
				saveToCache();
			}
		}
		[inline]
		override public function setData(key:String, value:*):void
		{
			super.setData(key, value);
			if(_autoSaveCache)
			{
				saveToCache();
			}
		}

		/**
		 * 是否加密缓存 
		 */
		public function get encryptCache():Boolean
		{
			return _encryptCache;
		}

		/**
		 * @private
		 */
		public function set encryptCache(value:Boolean):void
		{
			_encryptCache = value;
		}
		
		
		
	}
}