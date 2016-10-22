package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_news_notice;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 * 有新消息通知配置
	 * @author    zhengzheng   
	 */
	public class CJDataOfNoticeProperty
	{
		private var _dataDict:Dictionary;
		private static var _o:CJDataOfNoticeProperty;
		
		public function CJDataOfNoticeProperty()
		{
			_initData();
		}
		
		public static function get o():CJDataOfNoticeProperty
		{
			if(_o == null)
				_o = new CJDataOfNoticeProperty();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonNewsNotice) as Array;
			_dataDict = new Dictionary();
			for(var i:int=0;i< obj.length;i++)
			{
				var noticeConfig:Json_news_notice = new Json_news_notice();
				noticeConfig.loadFromJsonObject(obj[i]);
				_dataDict[parseInt(obj[i]['noticeid'])] = noticeConfig;
			}
		}
		/**
		 * 通过id获得单条有新消息通知数据
		 * @param id
		 * @return 
		 * 
		 */		
		public function getProperty(id:int):Json_news_notice
		{
			return _dataDict[id];
		}
		/**
		 * 通过id获得单条有新消息通知数据
		 * @param id
		 * @return 
		 * 
		 */		
		public function getAllPropertys():Array
		{
			var propertys:Array = new Array();
			for (var i:String in _dataDict) 
			{
				if (_dataDict[i])
				{
					propertys.push(int(i));
				}
			}
			return propertys;
		}
	}
}