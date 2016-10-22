package SJ.Game.data
{
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	
	import engine_starling.data.SDataBase;
	import SJ.Game.data.json.Json_function_open_setting;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能点数据 
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-25 上午11:45:37  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfFunctionPoint extends SDataBase
	{
		private var _userid:String;
		private var _functionid:String;
		private var _completed:int = 0;
		private var _config:Json_function_open_setting;
		
		public function CJDataOfFunctionPoint()
		{
			super("CJDataOfFunctionPoint");
		}
		
		public function initData(data:Object):void
		{
			this._userid = data.userid;	
			this._functionid = data.functionid;	
			this._completed = data.completed;	
			this._config = CJDataOfFuncPropertyList.o.getProperty(int(this._functionid));
		}

		public function get userid():String
		{
			return _userid;
		}

		public function set userid(value:String):void
		{
			_userid = value;
		}

		public function get functionid():String
		{
			return _functionid;
		}

		public function set functionid(value:String):void
		{
			_functionid = value;
		}

		public function get completed():int
		{
			return _completed;
		}

		public function set completed(value:int):void
		{
			_completed = value;
		}

		public function get config():Json_function_open_setting
		{
			return _config;
		}

		public function set config(value:Json_function_open_setting):void
		{
			_config = value;
		}

	}
}