package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_zhandouli_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 战斗力系数配置数据
	 * @author sangxu
	 * 
	 */	
	public class CJDataOfBattleEffectProperty extends SDataBase
	{
		
		public function CJDataOfBattleEffectProperty()
		{
			super("CJDataOfBattleEffectProperty");
			
		}
		
		private static var _o:CJDataOfBattleEffectProperty;
		public static function get o():CJDataOfBattleEffectProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfBattleEffectProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResBattleEffectSetting) as Array;
//			_dataDict = new Dictionary();
			var length:int = obj.length;
			for (var i:int=0; i<length; i++)
			{
				var data:Json_zhandouli_setting = new Json_zhandouli_setting();
				data.loadFromJsonObject(obj[i]);
				this.setData(obj[i]['id'], data);
			}
			
		}
		
		/**
		 * 获取战斗力系数配置
		 */
		public function getBattleEffect(id : int) : Json_zhandouli_setting
		{
			return this.getData(String(id));
		}
	}
}