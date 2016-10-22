package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_activity;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJTextFormatUtil;
	import SJ.Game.data.config.CJDataOfActivityPropertyList;
	import SJ.Game.data.config.CJDataOfActivityRewardPropertyList;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_activity_progress_setting;
	import SJ.Game.data.json.Json_activity_reward_setting;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskFlowString;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度数据类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-5 下午12:42:11  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfActivity extends SDataBaseRemoteData
	{
		public static const ACTIVITY_DATA_CHANGE:String = "ACTIVITY_DATA_CHANGE";
		private var _progressDic:Array = new Array();
		private var _rewardDic:Array = new Array();
		private var _userScore:int = 0;
		
		public function CJDataOfActivity()
		{
			super("CJDataOfActivity");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onSocketMessage);
		}
		
		private function _onSocketMessage(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_GET_ACTIVITY_DATA)
			{
				var params1:Object = message.retparams;
				this._initData(params1);
				this._onloadFromRemoteComplete();
			}
			else if(message.getCommand() == ConstNetCommand.CS_GET_ACTIVITY_REWARD)
			{
				if (message.retcode != 1)
				{
					new CJTaskFlowString(CJLang('activity_fail1')).addToLayer();
				}
				else
				{
					var params2:Object = message.retparams;
					this._initData(params2['activityData']);
					
					//奖励飘字
					var rewardConfig:Json_activity_reward_setting = CJDataOfActivityRewardPropertyList.o.getConfigById(params2['index']);
					var setting:CJDataOfItemProperty = CJDataOfItemProperty.o;
					var template: Json_item_setting = setting.getTemplate(rewardConfig.rewardid);
					var itemColor:Object = CJTextFormatUtil.getQualityColorString(template.quality)
					var tempText:String =  CJTaskHtmlUtil.colorText(CJLang(template.itemname) , String(itemColor)) + CJTaskHtmlUtil.space+CJTaskHtmlUtil.colorText("+1", "#4AFD2C")
					new CJTaskFlowString(CJLang('activity_receive' , {'itemname':tempText})).addToLayer();
					//刷新背包数据
					CJDataManager.o.DataOfBag.loadFromRemote();
					//加钱的口
					SocketCommand_hero.get_heros();
					SocketCommand_role.get_role_info();
				}
			}
		}
		
		private function _initData(activityData:Object):void
		{
			_progressDic = new Array();
			_rewardDic = new Array();
			_userScore = 0;
			var progressData:Object = activityData.progressdata;
			var allProgressConfigList:Object = CJDataOfActivityPropertyList.o.getAllTempateList();
			for(var key:String in allProgressConfigList)
			{
				var json:Json_activity_progress_setting = allProgressConfigList[key];
				var progress:Object = new Object();
				if(json)
				{
					progress['key'] = key;
					progress['value'] = 0;
					//排序字段
					progress['index'] = json.index;
					if(progressData.hasOwnProperty(key))
					{
						progress['value'] = progressData[key];
						_userScore += int(progressData[key]) * int(json.addscore);
					}
				}
				_progressDic.push(progress);
			}
			//排序
			_progressDic.sortOn("index" , Array.NUMERIC);
			
			var rewardData:Object = activityData.rewarddata;
			var allRewardConfigList:Object = CJDataOfActivityRewardPropertyList.o.getAllTempateList();
			for(var id:String in allRewardConfigList)
			{
				var reward:Object = new Object();
				reward['id'] = id;
				reward['value'] = 0;
				if(rewardData.hasOwnProperty(id))
				{
					reward['value'] = rewardData[id];
				}
				_rewardDic.push(reward);
			}
			
			this.dispatchEventWith(ACTIVITY_DATA_CHANGE);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_activity.getActivityData();
		}
		
		/**
		 * 获取对应的奖励的状态
		 */ 
		public function getRewardStatus(id:int):int
		{
			for(var i:String in this._rewardDic)
			{
				var data:Object = _rewardDic[i];
				if(int(data["id"]) == id)
				{
					//已经领取
					if(int(data["value"]) == 1)
					{
						return CJActivityEventKey.ACTIVITY_REWARDED;	
					}
					else
					{
						//判断分数是否足够
						var needScore:int = CJDataOfActivityRewardPropertyList.o.getConfigById(id).needscore;
						if(this._userScore >= needScore)
						{
							return CJActivityEventKey.ACTIVITY_CAN_GET_REWARD;
						}
					}
					
				}
			}
			return CJActivityEventKey.ACTIVITY_CAN_NOT_REWARD;
		}
		
		/**
		 * 活跃度操作是否已经完成 
		 */
		public function isActionCompleted(actionKey:String):Boolean
		{
			var allProgressConfigList:Object = CJDataOfActivityPropertyList.o.getAllTempateList();
			//不存在的key，直接完成
			if(!allProgressConfigList.hasOwnProperty(actionKey))
			{
				return true;
			}
			var json:Json_activity_progress_setting = allProgressConfigList[actionKey];
			var count:int = json.count;
			for(var i:String in _progressDic)
			{
				var progressData:Object = _progressDic[i];
				if(progressData['key'] == actionKey && int(progressData['value']) >= count)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * 当前用户活跃度积分
		 */ 
		public function get userScore():int
		{
			return _userScore;
		}

		public function get progressDic():Object
		{
			return _progressDic;
		}

		public function get rewardDic():Object
		{
			return _rewardDic;
		}
	}
}