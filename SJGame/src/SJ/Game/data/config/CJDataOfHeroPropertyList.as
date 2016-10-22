package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.data.json.Json_hero_propertys;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 武将静态配置集中管理器
	 */	
	public class CJDataOfHeroPropertyList
	{
		private static var _o:CJDataOfHeroPropertyList;
		public static function get o():CJDataOfHeroPropertyList
		{
			if(_o == null)
				_o = new CJDataOfHeroPropertyList();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		
		public function CJDataOfHeroPropertyList()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResHeroPropertys) as Array;
			if(obj == null)
			{
				return;
			}
			_dataDict = new Dictionary();
			var length:int = obj.length;
			var heroProperty:CJDataHeroProperty = new CJDataHeroProperty();
			for(var i:int=0 ; i < length ; i++)
			{
				
				heroProperty.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_dataDict[parseInt(obj[i]['id'])] = obj[i];
			}
			
			
			
			//peng.zhi ++
			//增加战斗模板数据解解析
			_dataOfBattleProperty = new Dictionary();
			obj = AssetManagerUtil.o.getObject(ConstResource.sResHeroBattlePropertys) as Array;
			if(obj == null)
			{
				return;
			}
			length = obj.length;
			var heroBattleProperty:Json_hero_battle_propertys = new Json_hero_battle_propertys();
			for( i=0 ; i < length ; i++)
			{
				
				heroBattleProperty.loadFromJsonObject(obj[i]);
			
				_dataOfBattleProperty[int(heroBattleProperty.resourceid)] = obj[i];
				
			}
		}
		
		/**
		 * addby caihua
		 * @param templateId 武将的静态配置id
		 * @return CJDataHeroProperty 返回静态DAO对象
		 */		
		public function getProperty(templateId:int):CJDataHeroProperty
		{
			var heroProperty:CJDataHeroProperty = new CJDataHeroProperty();
			heroProperty.loadFromJsonObject(_dataDict[templateId]);
//			var heroProperty:CJDataHeroProperty = _dataDict[templateId] as CJDataHeroProperty;
			return heroProperty;
		}
		
		
		private var _dataOfBattleProperty:Dictionary;
		/**
		 * 通过资源ID 返回战斗资源模板 
		 * @param tid
		 * @return 
		 * 
		 */
		public function getBattleProperty(resourceid:int):Json_hero_battle_propertys
		{
			var heroProperty:Json_hero_battle_propertys = new Json_hero_battle_propertys()
			heroProperty.loadFromJsonObject(_dataOfBattleProperty[resourceid]);
			return heroProperty;
		}
		
		/**
		 * 通过英雄ID 返回资源 
		 * @param tid
		 * @return 
		 * 
		 */
		public function getBattlePropertyWithTemplateId(tid:int):Json_hero_battle_propertys
		{
			var heroProperty:CJDataHeroProperty = new CJDataHeroProperty();
			heroProperty.loadFromJsonObject(_dataDict[tid]);
//			var heroProperty:CJDataHeroProperty = _dataDict[tid] as CJDataHeroProperty;
//			@modified caihua 获取武将的战斗配置,需要传入资源id.
			return getBattleProperty(heroProperty.resourceid);
		}
	}
}