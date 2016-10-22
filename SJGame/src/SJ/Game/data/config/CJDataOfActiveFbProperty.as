package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_activefuben;
	
	import engine_starling.utils.AssetManagerUtil;
	
	public class CJDataOfActiveFbProperty
	{
		private var _dataDict:Dictionary;
		private var _cacheDict:Dictionary;
		public function CJDataOfActiveFbProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfActiveFbProperty;
		public static function get o():CJDataOfActiveFbProperty
		{
			if(_o == null)
				_o = new CJDataOfActiveFbProperty();
			return _o;
		}
		
		private function _initData():void
		{
			_dataDict = new Dictionary;
			_cacheDict = new Dictionary;
				
			var fubenConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonActiveFbConfig) as Array;
			var jsonObj:Json_activefuben = new Json_activefuben;
			for(var i:String in fubenConf)
			{
				jsonObj.loadFromJsonObject(fubenConf[i])
				_dataDict[fubenConf[i].id] = fubenConf[i];
			}
		}
		public function getFidByGid(gid:int):int
		{
			var fid:int = 0
			for(var i:String in _dataDict)
			{
				var jsonObj:Object = _dataDict[i];
				if(jsonObj.gids.indexOf(String(gid))!=-1)
				{
					fid = jsonObj.id;
				}
			}
			return fid;
		}
		/**
		 * 根据ID获取配置数据 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPropertyById(id:int):Json_activefuben
		{
			if(_cacheDict.hasOwnProperty(id))
			{
				return _cacheDict[id];
			}
			var activeFbConfig:Json_activefuben = new Json_activefuben;
			activeFbConfig.loadFromJsonObject(_dataDict[id]);
			_cacheDict[id] = activeFbConfig;
			return activeFbConfig;
		}
		
		public function getList():Dictionary
		{
			return 	_dataDict
		}
	}
}