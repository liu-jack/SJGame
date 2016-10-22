package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_task_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 +------------------------------------------------------------------------------
	 * 任务静态配置列表类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-25 上午10:03:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfTaskPropertyList extends SDataBase
	{
		private static var _o:CJDataOfTaskPropertyList;
		
		public function CJDataOfTaskPropertyList()
		{
			super("CJTaskTemplateList");
			_initData();
		}
		
		public static function get o():CJDataOfTaskPropertyList
		{
			if(_o == null)
				_o = new CJDataOfTaskPropertyList();
			return _o;
		}
		
		/**
		 * 组织形式  taskid =>  Json_task_setting
		 */		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonTask) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var taskConfig:Json_task_setting = new Json_task_setting();
				taskConfig.loadFromJsonObject(obj[i]);
				this.setData(taskConfig.taskid , taskConfig);
			}
		}
		
		/**
		 * 获取所有的配置列表
		 */		
		public function getAllTaskTempateList():Dictionary
		{
			return this._dataContains;
		}
		
		/**
		 * 获取taskid的配置 
		 * @param taskid
		 */		
		public function getTaskConfigById(taskid:int):Json_task_setting
		{
			return this.getData(String(taskid));
		}
	}
}