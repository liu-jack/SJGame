package SJ.Game.data
{
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.data.json.Json_kfcontend_active_setting;
	import SJ.Game.data.json.Json_kfcontend_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * 开服争霸
	 * @author bianbo
	 * 
	 */	
	public class CJDataOfKFContend
	{
		
		private var kflist:Object;//开服争霸数据
		
		private var active_kflist:Object;//开服争霸活动数据
		
		public function CJDataOfKFContend()
		{
			
		}
		
		private static var _o:CJDataOfKFContend;
		public static function get o():CJDataOfKFContend
		{
			if(_o == null)
			{
				_o = new CJDataOfKFContend();
				_o._initData();
			}
			return _o;
		}
		
		/**
		 * 整理数据
		 */		
		private function _initData():void
		{
			//开服争霸数据
			var obj:Array = AssetManagerUtil.o.getObject("kfcontend_setting.json") as Array;
			if (obj == null)
				return;
			
			kflist = new Object();
			
			var i:int;
			for(i=0; i < obj.length; i++)
			{
				var js:Json_kfcontend_setting = new Json_kfcontend_setting();
				js.loadFromJsonObject(obj[i]);
				
				if(kflist[js.type] == undefined)
				{
					kflist[js.type] = new Array();
				}
				
				(kflist[js.type] as Array).push(js);
				
			}
			
			//开服争霸活动数据
			var obj2:Array = AssetManagerUtil.o.getObject("kfcontend_active_setting.json") as Array;
			if (obj2 == null)
				return;
			
			active_kflist = new Object();
			
			for(i=0; i < obj2.length; i++)
			{
				var js2:Json_kfcontend_active_setting = new Json_kfcontend_active_setting();
				js2.loadFromJsonObject(obj2[i]);
				
				active_kflist[js2.type] = js2;
			}
			
		}
		
		/**
		 * 获得指定活动的配置数据
		 * @param _type
		 * @return array
		 */		
		public function getActiveByType(_type:int):Json_kfcontend_active_setting
		{
			return active_kflist[_type] as Json_kfcontend_active_setting;
		}
		
		/**
		 * 获得配置数据
		 * @param _type
		 * @return array
		 */		
		public function getDataByType(_type:int):Array
		{
			var _arrData:Array = kflist[_type];
			if(_arrData == null)return [];
			
			_arrData.sortOn("index", Array.NUMERIC);
			
			return _arrData;
		}
		
		/**
		 * 获得开启状态
		 * @param _servertime 单位是秒 服务器当前时间
		 * @param _openservertime 单位是秒 服务器开服时间
		 */		
		public function getState(_servertime:int, _openservertime:int):Array
		{
			var myarr:Array = [];
			
			var i:int;
			for(i=0; i<4; i++)
			{
				var js:Json_kfcontend_active_setting = CJDataOfKFContend.o.getActiveByType(i+1);
				
				var arr:Array = String(js.kftime).split(":");
				var targetTime:int = int(js.kfday)*24*60*60 + int(arr[0])*60*60 + int(arr[1])*60 + int(arr[2]) + _openservertime;//活动开启时间 单位 S
				var obj:Object = new Object();
				obj.time = targetTime;
				obj.type = i+1;//活动类型1-4
				
				if(targetTime > _servertime)obj.state = 1;//未开启
				else if(targetTime + int(js.lasttime)*60 < _servertime)obj.state = 2;//已结束
				else obj.state = 3;//正在开启
				
				myarr.push(obj);
			}
			
			myarr.sortOn("time", Array.NUMERIC);
			
			return myarr;
		}
	
		private var opendata:Object;
		
		/**
		 * 获得11排行榜, 12竞技场开启等级
		 * @return  int
		 */		
		public function getModuleOpenLv(_funcid:int):int
		{
			var obj:Array = AssetManagerUtil.o.getObject("function_open_setting.json") as Array;
		
			if(opendata == null)
			{
				opendata = new Object();
				
				var i:int;
				for(i=0; i < obj.length; i++)
				{
					var js:Json_function_open_setting = new Json_function_open_setting();
					js.loadFromJsonObject(obj[i]);
					
					opendata[js.functionid] = js;
				}
			}
			
			return (opendata[_funcid] as Json_function_open_setting).level;
			
		}
		
	}
}