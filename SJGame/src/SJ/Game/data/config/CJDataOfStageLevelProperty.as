package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_role_stage_change;
	import SJ.Game.data.json.Json_role_stage_force_star;
	import SJ.Game.data.json.Json_role_stage_level;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 酒馆静态数据管理
	 * @author longtao
	 * 
	 */
	public class CJDataOfStageLevelProperty
	{
		
		private static var _o:CJDataOfStageLevelProperty;
		
		public static function get o():CJDataOfStageLevelProperty
		{
			if(_o == null)
				_o = new CJDataOfStageLevelProperty();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		private var _forceStarDict:Dictionary;
		private var _changeDict:Dictionary; // 升阶主角形象变化对照
		
		public function CJDataOfStageLevelProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonStageLevel) as Array;
			var fsObj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonForceStar) as Array;
			var icObj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonStageChange) as Array;
			if(obj == null || fsObj == null || icObj == null)
			{
				return;
			}
			_dataDict = new Dictionary();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_role_stage_level = new Json_role_stage_level();
				data.loadFromJsonObject(obj[i]);
				//
				_dataDict[obj[i]['id']] = data;
			}
			
			_forceStarDict = new Dictionary;
			length = fsObj.length;
			for(i=0 ; i < length ; i++)
			{
				var tData:Json_role_stage_force_star = new Json_role_stage_force_star();
				tData.loadFromJsonObject(fsObj[i]);
				//
				var key:String = _getKey( fsObj[i]['forcestarid'], fsObj[i]['job'], fsObj[i]['sex'] );
				_forceStarDict[key] = tData;
			}
			
			_changeDict = new Dictionary;
			length = icObj.length;
			for(i=0 ; i < length ; i++)
			{
				var cData:Json_role_stage_change = new Json_role_stage_change();
				cData.loadFromJsonObject(icObj[i]);
				//
				var tkey:String = _getKey( icObj[i]['stagelevel'], icObj[i]['job'], icObj[i]['sex'] );
				_changeDict[tkey] = cData;
			}
		}
		
		/**
		 * 获取武星key
		 * @param forcestarid	武星id
		 * @param job			主角职业
		 * @param sex			主角性别
		 * @return 				唯一id
		 */
		private function _getKey(forcestarid:String, job:String, sex:String):String
		{
			var key:String = forcestarid + "|" + job + "|" + sex;
			return key;
		}
		
		/**
		 * 获取升阶信息
		 * @param forceStar
		 * @return 
		 * 
		 */
		public function getData(forceStar:String):Json_role_stage_level
		{
			var tData:Json_role_stage_level = _dataDict[forceStar] as Json_role_stage_level;
			return CObjectUtils.clone(tData) as Json_role_stage_level;
		}
		
		/**
		 * 获取武星信息
		 * @param forcestarid	武星id
		 * @param job			主角职业
		 * @param sex			主角性别
		 * @return 武星信息
		 */
		public function getForceStarData(forcestarid:String, job:String, sex:String):Json_role_stage_force_star
		{
			var key:String = _getKey( forcestarid, job, sex );
			var tData:Json_role_stage_force_star = _forceStarDict[key] as Json_role_stage_force_star;
			return CObjectUtils.clone(tData) as Json_role_stage_force_star;
		}
		
		/**
		 * 获取武将升阶主角形象变化对照
		 * @param stagelevel	升阶等级  如传入1阶，则oldtid为0阶形象-newtid为1阶形象
		 * @param job			职业
		 * @param sex			性别
		 * @return 形象变化信息
		 */
		public function getStageChange( stagelevel:String, job:String, sex:String ):Json_role_stage_change
		{
			var key:String = _getKey(stagelevel, job, sex);
			var tdata:Json_role_stage_change = _changeDict[key] as Json_role_stage_change;
			return CObjectUtils.clone(tdata) as Json_role_stage_change;
		}
	}
}