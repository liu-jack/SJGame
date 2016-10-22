package SJ.Game.data
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_item_package_config;
	import SJ.Game.data.json.Json_qiandao_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 * 每日签到
	 * @author bianbo
	 * 
	 */	
	public class CJDataOfQianDao
	{
		
		private var libaoItems:Object;//礼包表的整理数据， key是礼包id
		private var qiandaoObj:Object;//签到数据表的整理数据，key是day
		
		public function CJDataOfQianDao()
		{
			
		}
		
		private static var _o:CJDataOfQianDao;
		public static function get o():CJDataOfQianDao
		{
			if(_o == null)
			{
				_o = new CJDataOfQianDao();
				_o._initData();
				_o._initLiBaoItems();
			}
			return _o;
		}
		
		/**
		 * 整理签到表数据
		 */		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject("qiandao_setting.json") as Array;
			if (obj == null)
				return;
			
			qiandaoObj = new Object();
			for(var i:int=0; i < obj.length; i++)
			{
				var js:Json_qiandao_setting = new Json_qiandao_setting();
				js.loadFromJsonObject(obj[i]);
				
				qiandaoObj[js.days] = js;
			}
		}
		
		/**
		 * 获得指定天的额外得到元宝
		 * @param _key
		 * @return 
		 */		
		public function getMoney(_key:*):int
		{
			return int(qiandaoObj[_key].money);
		}
		
		/**
		 * 得到有奖励的连续天数的列表
		 * @return 
		 */		
		public function getGiftNum():Array
		{
			var arr:Array = [];
			for (var key:* in qiandaoObj)
			{
				if(qiandaoObj[key].boxid != 0)arr.push(qiandaoObj[key].days);
			}
			
			arr.sort(Array.NUMERIC);
			
			return arr;
		}
		
		/**
		 * 获得指定tab的礼包id
		 * @param _index 0开始
		 * @return 
		 */		
		public function getBoxID(_index:int):int
		{
			var arr:Array = [];
			for (var key:* in qiandaoObj)
			{
				if(qiandaoObj[key].boxid != 0)arr.push(qiandaoObj[key].days);
			}
			
			arr.sort(Array.NUMERIC);
			
			var mykey:* = arr[_index];
			var id:int = qiandaoObj[mykey].boxid;
			
			return id;
		}
		
		/**
		 * 获得指定tab的days值
		 * @param _index 0开始
		 * @return 
		 */		
		public function getDays(_index:int):int
		{
			var arr:Array = [];
			for (var key:* in qiandaoObj)
			{
				if(qiandaoObj[key].boxid != 0)arr.push(qiandaoObj[key].days);
			}
			
			arr.sort(Array.NUMERIC);
			
			return arr[_index];
		}
		
		/**
		 * 整理礼包表数据
		 */		
		private function _initLiBaoItems():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonItemPackageConfig) as Array;
			if (obj == null)
			{
				return;
			}
			
			libaoItems = new Object();
			
			var arrayPackageItems:Array;
			for (var i:int = 0 ; i < obj.length ; i++)
			{
				var data:Json_item_package_config = new Json_item_package_config();
				data.loadFromJsonObject(obj[i]);
				
				if(libaoItems[data.packageitemid] == null || libaoItems[data.packageitemid] == undefined)
				{
					libaoItems[data.packageitemid] = new Array();
				}
				
				(libaoItems[data.packageitemid] as Array).push(data);
				
			}
		}
		
		/**
		 * 根据礼包id获得一个礼包配置json数组
		 * @param _id
		 * @return 
		 * 
		 */		
		public function getLibaoItemsList(_id:int):Array
		{
			var arr:Array = libaoItems[_id] as Array;
			
			return arr;
		}
		
	}
}