package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_scenesetting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 *  场景配置
	 * @author yongjun
	 * 
	 */
	public class CJDataOfMainSceneProperty
	{
		public function CJDataOfMainSceneProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfMainSceneProperty;
		public static function get o():CJDataOfMainSceneProperty
		{
			if(_o == null)
				_o = new CJDataOfMainSceneProperty();
			return _o;
		}
		
		private var _dataDict:Array;
		private function _initData():void
		{
			_dataDict = new Array;
			var mainConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonSceneSetting) as Array;
			for(var i:String in mainConf)
			{
				_dataDict.push(mainConf[i]);
			}
		}
		
		public function getPropertyById(id:int):Object
		{
			var info:Object;
			for(var i:String in this._dataDict)
			{
				if(id ==int(this._dataDict[i].id))
				{
					info = this._dataDict[i];
					break;
				}
			}
			if (info)
				info.texturename = _getTextureName(info.path);
			
			if(info==null)info = _dataDict[0];
			return info;
		}
		
		public function getList(level:String):Vector.<Object>
		{
			var cityList:Vector.<Object> = new Vector.<Object>
			for(var i:String in this._dataDict)
			{
				if(this._dataDict[i].istown == 1 && int(level)>=int(this._dataDict[i].openlevel))
				{
					cityList.push(this._dataDict[i]);
				}
			}
			return cityList;
		}
		
		public function getIdsByList(list:Vector.<Object>):Vector.<int>
		{
			var ids:Vector.<int> = new Vector.<int>;
			for(var i:String in list)
			{
				ids.push(list[i].id);
			}
			return ids;
		}
		
		/**
		 *  根据当前级别获取配置数据
		 * @param id
		 * @return 
		 * 
		 */
		public function getPropertyByLevel(level:int):Object
		{
			var info:Object;
			for(var i:String in this._dataDict)
			{
				if(this._dataDict[i].istown == 1 && level>=int(this._dataDict[i].openlevel))
				{
					info = this._dataDict[i];
				}
			}
			info.texturename = _getTextureName(info.path);
			return info;
		}
		
		private function _getTextureName(path:String):String
		{
			var nameArr:Array = path.split(".")[0].split("_");
			return nameArr[1]+"_"+nameArr[2];
		}
		
		/**
		 * 根据级别返回开启的主城ID及副本ID 
		 * @param level
		 * @return 
		 * 
		 */
		public function getOpenedIdByLevel(level:int):Array
		{
			var ids:Array = new Array
			for(var i:String in this._dataDict)
			{
				if(level >= int(this._dataDict[i].openlevel))
				{
					ids.push(this._dataDict[i].id);
					if(this._dataDict[i].hasOwnProperty("fids"))
					{
						ids = ids.concat(this._dataDict[i].fids.split("&"))
					}
				}
			}
			return ids;
		}
	}
}