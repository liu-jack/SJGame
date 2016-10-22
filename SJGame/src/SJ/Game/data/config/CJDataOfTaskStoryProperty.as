package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_npc_talk_setting;
	import SJ.Game.data.json.Json_task_story_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 *  任务剧情配置
	 * @author yongjun
	 * 
	 */	
	public class CJDataOfTaskStoryProperty
	{
		
		private var _dataDict:Dictionary
		public function CJDataOfTaskStoryProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfTaskStoryProperty;
		public static function get o():CJDataOfTaskStoryProperty
		{
			if(_o == null)
				_o = new CJDataOfTaskStoryProperty();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonTaskStoryConfig) as Array;
			if(obj == null)
			{
				return;
			}
			_dataDict = new Dictionary;
			for(var i:String in obj)
			{
				var jsonObj:Json_task_story_setting = new Json_task_story_setting;
				jsonObj.loadFromJsonObject(obj[i])
				_dataDict[jsonObj.taskid] = jsonObj
			}
		}
		/**
		 * 根据ID获取对话数组 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getConfigById(id:int):Array
		{

			if(!_dataDict.hasOwnProperty(id))
			{
				return null;
			}
			return _dataDict[id];
		}
	}
}