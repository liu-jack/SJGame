package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_hero_train_setting;
	
	import engine_starling.utils.AssetManagerUtil;

	public class CJDataOfHeroTrainProperty
	{
		private static var _o:CJDataOfHeroTrainProperty;
		public static function get o():CJDataOfHeroTrainProperty
		{
			if(_o == null)
				_o = new CJDataOfHeroTrainProperty();
			return _o;
		}
		
		private var _dataArr:Array;
		public function CJDataOfHeroTrainProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHeroTrain) as Array;
			if(obj == null)
			{
				return;
			}
			_dataArr = new Array();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_hero_train_setting = new Json_hero_train_setting();
				data.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_dataArr[parseInt(obj[i]['level'])] = data;
			}
		}
		
		/**
		 * 获取数据
		 * @param level 武将等级
		 * @return 
		 */
		public function getData( level:String ):Json_hero_train_setting
		{
			return _dataArr[level] as Json_hero_train_setting;
		}
	}
}