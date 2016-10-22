package engine_starling.data
{
	import engine_starling.SApplicationConfig;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import lib.engine.utils.CTimerUtils;

	public class SDataSqliteCache
	{
		private var _conn:SQLConnection;
		private var _cacheName:String;
		public function SDataSqliteCache(cacheName:String)
		{
			_cacheName = cacheName;
			_init();
			
		}
		private function get _cacheDB():String
		{
			return File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceDataCachePath  + _cacheName +".txt";
		}
		private function get _newsqlstate():SQLStatement
		{
			var sqlstate:SQLStatement = new SQLStatement();
			sqlstate.sqlConnection = _conn;
			return sqlstate;
		}
		private function _init():void
		{
			var dbkey:ByteArray = new ByteArray();
			dbkey.writeUTFBytes("mysqliteoooooo00");
			dbkey = null;
			
			var dbfile:File = new File(_cacheDB);
			_conn = new SQLConnection();
			_conn.open(dbfile,SQLMode.CREATE,false,1024,dbkey);
			
			
			
			_buildtables();
			
			
		}
		
		private function _sqlconnOpenHandler(e:SQLEvent):void
		{
			_buildtables();
		}
		
		private function _sqlconnErrorHandler(e:SQLErrorEvent):void
		{
			
		}
		
		private function _buildtables():void
		{
			var sqlstate:SQLStatement = new SQLStatement();
			sqlstate.sqlConnection = _conn;
			var sql:String =  
				"CREATE TABLE IF NOT EXISTS cache (" +  
				"    `cachekey` varchar(250) NOT NULL DEFAULT '', " +  
				"    `value` longblob NOT NULL, " +  
				"    `createdate` int(11) NOT NULL DEFAULT '0'," +  
				"    PRIMARY KEY (`cachekey`)" +  
				")"; 
			sqlstate.text = sql;
			sqlstate.execute();
			

		}
		
		/**
		 *  
		 * @param key
		 * @param obj 可以装箱的对象
		 * 
		 */
		public function addObject(key:String,obj:*):void
		{
			var objbytes:ByteArray = new ByteArray();
			objbytes.writeObject(obj);
			var insertSql:String = "replace into cache (cachekey,value,createdate) values(@key,@value,@date)";
			var sqlstate:SQLStatement = _newsqlstate;
			sqlstate.text = insertSql;
			sqlstate.parameters["@key"] = key;
			sqlstate.parameters["@value"] = objbytes;
			sqlstate.parameters["@date"] = int(CTimerUtils.getCurrentMiSecondLocal() / 1000);
			sqlstate.execute();
			
		}
		public function delObject(key:String):void
		{
			var delSql:String = "delete from cache where cachekey=@key";
			var sqlstate:SQLStatement = _newsqlstate;
			sqlstate.text = delSql;
			sqlstate.parameters["@key"] = key;
			sqlstate.execute();
			
		}
		public function getObject(key:String,D:* = null):*
		{
			var selectSql:String = "select value,createdate from cache where cachekey=@key";
			var sqlstate:SQLStatement = _newsqlstate;
			sqlstate.text = selectSql;
			sqlstate.parameters["@key"] = key;
			sqlstate.execute();
			var sqlret:SQLResult = sqlstate.getResult();
			if(sqlret.data == null || sqlret.data.length == 0)
			{
				return D;
			}
			else
			{
				var objbytes:ByteArray = sqlret.data[0].value;
				return objbytes.readObject();
			}
			
		}
	}
}