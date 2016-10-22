package SJ.Game.data
{
	import flash.events.Event;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_dailyTask;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfDailyTaskPropertyList;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.json.Json_daily_task_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskFlowString;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 每日任务 - 数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-2 上午10:03:40 
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfDailyTask extends SDataBaseRemoteData implements IAnimatable
	{
		public static const DAILYTASK_DATA_CHANGE:String = "DAILYTASK_DATA_CHANGE";
		private var _progressDic:Object = {};
		private var _statusDic:Object = {};
		private var _taskDic:Array;
		/*今天已经刷新次数*/
		private var _refreshcount:int = 0;
		/*最后刷新时间*/
		private var _lastrefreshtime:Number = 0;
		/*下次刷新剩余时间*/
		private var _remainTime:Number = 0;
		/*刷新间隔*/
		private static var _refreshGap:int = 2 * 60 * 60;
		
		public function CJDataOfDailyTask()
		{
			super("CJDataOfDailyTask");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onSocketMessage);
			/*重新激活需要刷新数据*/
//			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE,_onActive);
			
			Starling.juggler.add(this);
		}
		
		protected function _onActive(event:flash.events.Event):void
		{
			if(SApplication.stateManager.getCurrentState() != "GameStateGaming")
			{
				return;
			}
			var hasRoleInfo:Boolean = (CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole).hasRoleInfo;
			if(!hasRoleInfo)
				return;
			this.loadFromRemote();
		}
		
		private function _onSocketMessage(e:starling.events.Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			
			// add by longtao
			if (message.getCommand().indexOf("r_dailytask") == -1)
				return;
			// add by longtao end
			
			if (message && message.retcode != 1)
			{
				new CJTaskFlowString(CJLang('dailyTask_fail1')).addToLayer();
			}
			else
			{
				var command:String = message.getCommand();
				var params1:Object = message.retparams;
				if(command == ConstNetCommand.CS_DAILYTASK_GETALL || command == ConstNetCommand.CS_DAILYTASK_REFRESH || command == ConstNetCommand.CS_DAILYTASK_ACCEPT)
				{
					this._initData(params1.allData);
					this._onloadFromRemoteComplete();
				}
				else if(command == ConstNetCommand.CS_DAILYTASK_REWARD)
				{
					this._initData(params1.allData);
					//刷背包,钱币
//					SocketCommand_item.getBag();
					SocketCommand_role.get_role_info();
					SocketCommand_hero.get_heros();
					var config:Json_daily_task_setting = CJDataOfDailyTaskPropertyList.o.getConfigById(params1.dailytaskid);
					//飘字提示获得
					new CJTaskFlowString(rewardString(config)).addToLayer();
				}
				else if(command == ConstNetCommand.CS_DAILYTASK_IMDCOMPLETE ||　command == ConstNetCommand.CS_DAILYTASK_IMDREFRESH)
				{
					this._initData(params1.allData);
					SocketCommand_role.get_role_info();
				}
				else if(command == ConstNetCommand.SC_DAILYTASK_PROGRESSCHANGE)
				{
					this._initData(params1.allData);
				}
			}
		}
		
		private static function rewardString(config:Json_daily_task_setting):String
		{
			var text:String = "";
			
			var exprText:String =  CJTaskHtmlUtil.colorText(CJLang("COMMON_EXP") , "#c1910e") + CJTaskHtmlUtil.tab+CJTaskHtmlUtil.colorText("+"+config.addexp , "#4AFD2C")
			var silverText:String =  CJLang("COMMON_SILVER") + CJTaskHtmlUtil.tab+CJTaskHtmlUtil.colorText("+"+config.addsilver , "#4AFD2C");
			
			var itemText:String = "";
//			var setting:CJDataOfItemProperty = CJDataOfItemProperty.o;
//			var template: Json_item_setting = setting.getTemplate(config.additem);
//			var itemColor:Object = CJTextFormatUtil.getQualityColorString(template.quality)
//			var tempText:String =  CJTaskHtmlUtil.colorText(CJLang(template.itemname) , String(itemColor)) + CJTaskHtmlUtil.tab+CJTaskHtmlUtil.colorText("+1" , "#4AFD2C")
//			itemText += tempText+CJTaskHtmlUtil.br;
			
			return exprText + CJTaskHtmlUtil.br + silverText + CJTaskHtmlUtil.br + itemText;
		}
		
		private function _initData(dailyTaskData:Object):void
		{
			_progressDic = {};
			_statusDic = {};
			_taskDic = new Array();
			
			_remainTime = dailyTaskData.remaintime;
			_refreshcount = dailyTaskData.refreshcount;
			_lastrefreshtime = dailyTaskData.lastrefreshtime;
			
			var statusData:Object = dailyTaskData.statusdata;
			_statusDic = statusData;
			var progressData:Object = dailyTaskData.progressdata;
			_progressDic = progressData;
			for(var dailytaskid:String in statusData)
			{
				var taskdata:Object = new Object();
				taskdata['dailytaskid'] = dailytaskid;
				taskdata['progress'] = progressData[dailytaskid];
				taskdata['status'] = statusData[dailytaskid];
				_taskDic.push(taskdata);
			}
			//排序
			_taskDic.sortOn("dailytaskid" , Array.NUMERIC);
			this.dispatchEventWith(DAILYTASK_DATA_CHANGE);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			super._onloadFromRemote(params);
			
			SocketCommand_dailyTask.getAll();
		}
		
		/**
		 * 任务是否已经完成
		 */
		public function isDailyTaskCompleted(dailyTaskid:int):Boolean
		{
			var configList:Object = CJDataOfDailyTaskPropertyList.o.getAllTempateList();
			var json:Json_daily_task_setting = CJDataOfDailyTaskPropertyList.o.getConfigById(dailyTaskid);
			var count:int = json.conditionvalue;
			if(_progressDic.hasOwnProperty(String(dailyTaskid)))
			{
				var progress:int = int(_progressDic[String(dailyTaskid)]);
				if(progress >= count)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 是否还有机会完成任务
		 */ 
		public function isDailyTaskHasMoreChance():Boolean
		{
			var totalCount:int = int(CJDataOfGlobalConfigProperty.o.getData('dailytask_refresh_count'));
			return totalCount > this._refreshcount;
		}
	
		
		public function advanceTime(time:Number):void
		{
			_remainTime = _remainTime - time;
			if(_remainTime < 0 )
			{
				_remainTime = 0;
			}
		}
		
		public function get progressDic():Object
		{
			return _progressDic;
		}
		
		public function get rewardDic():Object
		{
			return _statusDic;
		}

		public function get refreshcount():int
		{
			return _refreshcount;
		}

		public function get lastrefreshtime():Number
		{
			return _lastrefreshtime;
		}

		public function get taskDic():Array
		{
			return _taskDic;
		}

		public function get remainTime():Number
		{
			return _remainTime;
		}
	}
}