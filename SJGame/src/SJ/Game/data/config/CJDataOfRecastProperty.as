package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_recastpropertyvalueconfig;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;

	/**
	 @author	Weichao
	 2013-5-28
	 */
	
	public class CJDataOfRecastProperty extends SDataBase
	{
		
		public function CJDataOfRecastProperty(dataBasename:String = "")
		{
			super("CJDataOfRecastProperty");
		}
		
		private static var _o:CJDataOfRecastProperty;
		public static function get o():CJDataOfRecastProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfRecastProperty();
				_o._initData();
			}
			return _o;
		}
		
		private var _dataDict:Dictionary;
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonItemRecastValueConfig) as Array;
			var length:int = obj.length;
			var json_temp:Json_recastpropertyvalueconfig = new Json_recastpropertyvalueconfig();
			_dataDict = new Dictionary();
			for(var i:int=0; i < length; i++)
			{
				json_temp.loadFromJsonObject(obj[i]);
				_dataDict[parseInt(obj[i]['id'])] = obj[i];
			}
			
		}
		/**
		 * 通过等级和品质获得洗练配置
		 * @param level
		 * @param quality
		 * @return 
		 * 
		 */		
		public function getRecastConfigWithParams(level:int, quality:int):Json_recastpropertyvalueconfig
		{
			for (var i:String in _dataDict) 
			{
				var json_temp:Json_recastpropertyvalueconfig = new Json_recastpropertyvalueconfig();
				json_temp.loadFromJsonObject(_dataDict[i]);
				if (int(json_temp.bottomherolevel) <= level && level < int(json_temp.topherolevel) && int(json_temp.heroquality) == quality)
				{
					return json_temp;
				}
			}
			return null;
		}
		
		/**
		 * 通过品质获得洗练配置
		 * @param quality
		 * @return 
		 * 
		 */		
		public function getRecastConfigWithQuality(quality:int):Json_recastpropertyvalueconfig
		{
			for (var i:String in _dataDict) 
			{
				var json_temp:Json_recastpropertyvalueconfig = new Json_recastpropertyvalueconfig();
				json_temp.loadFromJsonObject(_dataDict[i]);
				if (int(json_temp.heroquality) == quality)
				{
					return json_temp;
				}
			}
			return null;
		}
		/**
		 * 通过等级获得对应的不同属性上限配置数据
		 * 
		 */		
		public function getTopLimitArrayByLevel(level:int):Array
		{
			var tempArray:Array = new Array();
			var retArray:Array = new Array();
			for (var i:String in _dataDict) 
			{
				var json_temp:Json_recastpropertyvalueconfig = new Json_recastpropertyvalueconfig();
				json_temp.loadFromJsonObject(_dataDict[i]);
				if (int(json_temp.bottomherolevel) <= level && level < int(json_temp.topherolevel))
				{
					if (!_isContainJsonTemp(json_temp, tempArray))
					{
						tempArray.push(json_temp);
					}
				}
			}
			//先按金木水火土的顺序排好序后，再添加每种属性的上限值到返回数组
			tempArray.sort(_propertyTypeSort, Array.NUMERIC);
			for (var j:int = 0; j < tempArray.length; j++) 
			{
				json_temp = tempArray[j] as Json_recastpropertyvalueconfig;
				retArray.push(int(json_temp.equiptoplimit));
			}
			return retArray;
		}
		
		/**
		 * 按照装备属性类型排序
		 * 金->木->水->火->土
		 */		
		private function _propertyTypeSort(json_temp0:Json_recastpropertyvalueconfig, json_temp1:Json_recastpropertyvalueconfig):Number
		{
			var num0:Number = Number(json_temp0.propertytype);
			var num1:Number = Number(json_temp1.propertytype);
			if (num0 > num1)
			{
				return 1;
			}
			else if (num0 < num1)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 判断该数组中是否已经有该配置元素
		 */		
		private function _isContainJsonTemp(json_temp:Json_recastpropertyvalueconfig, array:Array):Boolean
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				var json_config:Json_recastpropertyvalueconfig = array[i] as Json_recastpropertyvalueconfig;
				if (int(json_config.propertytype) == int(json_temp.propertytype))
				{
					return true;
				}
			}
			return false;
		}
	}
}