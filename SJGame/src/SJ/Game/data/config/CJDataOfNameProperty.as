package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_rolename_propertys;
	
	import engine_starling.utils.AssetManagerUtil;

	public class CJDataOfNameProperty
	{
		private static var _o:CJDataOfNameProperty;
		public static function get o():CJDataOfNameProperty
		{
			if(_o == null)
				_o = new CJDataOfNameProperty();
			return _o;
		}
		
		/** 姓氏 **/
		private var _lastNameArr:Array;
		/** 男子名称 **/
		private var _maleNameArr:Array;
		/** 女子名称 **/
		private var _femaleNameArr:Array;
		/** 中间名 **/
		private var _midNameArr:Array;
		
		public function CJDataOfNameProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonNameConfig) as Array;
			if(obj == null)
			{
				return;
			}
			
			_lastNameArr = new Array;
			_maleNameArr = new Array;
			_femaleNameArr = new Array;
			_midNameArr = new Array;
			
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_rolename_propertys = new Json_rolename_propertys();
				data.loadFromJsonObject(obj[i]);
				// 根据类型区分 姓氏、男子名称、女子名称
				if (int(data.type) == 0)
					_lastNameArr.push(data.value);
				else if (int(data.type) == 1)
					_maleNameArr.push(data.value);
				else if (int(data.type) == 2)
					_femaleNameArr.push(data.value);
				else if (int(data.type) == 3)
				{
					// 不限男女的名字
					_maleNameArr.push(data.value);
					_femaleNameArr.push(data.value);
				}
				else if (int(data.type) == 4)
				{
					// 中间名字
					_midNameArr.push(data.value);
				}
			}
		}
		
		/**
		 * 获取姓氏列表
		 * @return 
		 * 
		 */
		public function getLastNameList():Array
		{
			return _lastNameArr;
		}
		
		/**
		 * 获取男子名列表
		 * @return 
		 * 
		 */
		public function getMaleNameList():Array
		{
			return _maleNameArr;
		}
		
		/**
		 * 获取女子名列表
		 * @return 
		 * 
		 */
		public function getFemaleNamelist():Array
		{
			return _femaleNameArr;
		}
		
		/**
		 * 获取中间名列表
		 * @return 
		 */
		public function getMidNameArr():Array
		{
			return _midNameArr;
		}
	}
}