package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 被动技能配置数据
	 * @author sangxu
	 * 
	 */	
	public class CJDataOfPSkillProperty extends SDataBase
	{
		
		public function CJDataOfPSkillProperty()
		{
			super("CJDataOfPSkillProperty");
			
		}
		
		private static var _o:CJDataOfPSkillProperty;
		public static function get o():CJDataOfPSkillProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfPSkillProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResPSkillSetting) as Array;
			var length:int = obj.length;
			for(var i:int=0; i < length; i++)
			{
				var prop:Json_pskill_setting = new Json_pskill_setting();
				prop.loadFromJsonObject(obj[i]);
				_resetDesc(prop);
				//此处的id是策划配置的id
				this.setData(obj[i]['skillid'], prop);
			}
			
		}
		
		private function _resetDesc(skillConfig:Json_pskill_setting):void
		{
			var str:String = "";
//			var propArray:Array = ["hp",
//				"pattack",
//				"def",
//				"mattack",
//				"mdef",
//				"crit",
//				"toughness",
//				"dodge",
//				"hit",
//				"mimmuno",
//				"mpassthrough",
//				"blood",
//				"mcrit",
//				"mtoughness",
//				"cure",
//				"reducehurt",
//				"inchurt"];
			// 基础5属性 格式为:法术攻击+xxx
			var basePropArray:Array = [
				"hp",
				"pattack",
				"def",
				"mattack",
				"mdef"
				];
			
			// 基础属性填充
			for each (var propName:String in basePropArray)
			{
				if (int(skillConfig[propName]) > 0)
				{
					str += CJLang("PROP_NAME_" + propName.toUpperCase()) + "+" + _getPropValue(skillConfig[propName]) + "%,";
				}
			}
			
			// 特殊属性 格式为:吸血+xxx点
			var specialPropArray:Array = [
				"crit",
				"toughness",
				"dodge",
				"hit",
				"mimmuno",
				"mpassthrough",
				"blood",
				"mcrit",
				"mtoughness",
				"cure",
				"reducehurt",
				"inchurt"
				];
			// 基础属性填充
			for each (var propName:String in specialPropArray)
			{
				if (int(skillConfig[propName]) > 0)
				{
					str += CJLang("PROP_NAME_" + propName.toUpperCase()) + "+" + skillConfig[propName] + CJLang("PROP_SUFFIX") + ",";
				}
			}
			
			if (str.length > 0)
			{
				str = str.substr(0, str.length - 1);
			}
			skillConfig.skilldes = str;
		}
		
		private function _getPropValue(prop:String):String
		{
			return String(int(prop) / 100);
		}
		
		/**
		 * 获取容器配置
		 */
		public function getPSkill(id : String) : Json_pskill_setting
		{
			return this.getData(id);
		}
	}
}