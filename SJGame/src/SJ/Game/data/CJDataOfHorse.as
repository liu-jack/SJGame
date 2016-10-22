package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_horse;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	
	/**
	 * 坐骑数据
	 * @author Weichao
	 * 
	 */
	
	public class CJDataOfHorse extends SDataBaseRemoteData
	{
		private static var _o:CJDataOfHorse;
		
		/*标志是骑乘，还是幻化*/
		private var _clickType:String = "ride";
		
		public function CJDataOfHorse()
		{
			super("CJDataOfHorse");
			_init();
		}
		
		private function _init():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onGetHorseInfo);
		}
		
		
		private function _onGetHorseInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			
			if (message.getCommand() == ConstNetCommand.CS_HORSE_GETHORSEINFO)
			{
				if (message.retcode == 0)
				{
					this.__onSocketReturn_getHorseInfo(e)
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_HORSE_RIDEHORSE)
			{
				if (message.retcode == 0)
				{
					this.__onSocketReturn_rideHorse(e);
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_HORSE_DISMOUNT)
			{
				if (message.retcode == 0)
				{
					this.__onSocketReturn_dismount(e);
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_HORSE_UPGRADERIDESKILL)
			{
				if (message.retcode == 0)
				{
					this.__onSocketReturn_upgradeRideSkill(e);
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_HORSE_UPGRADERIDESKILLRANK)
			{
				if (message.retcode == 0)
				{
					this.__onSocketReturn_upgradeRideSkillRank(e);
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_HORSE_EXTENDHORSE)
			{
				if (message.retcode == 0)
				{
					this.__onSocketReturn_extendHorse(e);
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_HORSE_ACTIVERIDESKILL)
			{
				if (message.retcode == 0)
				{
					this.__onSocketReturn_activeHorse(e);
				}
			}	
			else
			{
				return;
			}
		}
		
		private function __onSocketReturn_activeHorse(e:Event):void
		{
			SocketCommand_horse.getHorseInfo();
			this.dispatchEventWith("horsedatachange" , false ,{"type":"activeHorse"});
			SocketCommand_hero.get_heros();
		}
		
		protected override function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_horse.getHorseInfo();
			super._onloadFromRemoteComplete();
		}
		
		private function __onSocketReturn_getHorseInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var rtnObject:Object = message.retparams;
			var dic_baseInfoGet:Object = rtnObject["horseBaseInfo"];
			var arr_horseListGet:Array = rtnObject["horseAllList"];
			
			this.dic_baseInfo = dic_baseInfoGet;
			this.arr_horseList = arr_horseListGet;
			this.sortHorse();
			this.dispatchEventWith("horsedatachange" , false ,{"type":"refreshHorse"});
		}
		
		private function __onSocketReturn_rideHorse(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var rtnObject:Object = message.retparams;
			var horseid:String = rtnObject["activehorseid"];
			
			var dic_baseInfoTemp:Object = this.dic_baseInfo;
			dic_baseInfoTemp["activehorseid"] = horseid;
			dic_baseInfoTemp["currenthorseid"] = horseid;
			dic_baseInfoTemp["isriding"] = 1;
			this.dic_baseInfo = dic_baseInfoTemp;
			sortHorse();
			this.dispatchEventWith("horsedatachange" , false ,{"type":"ridehorse"});
			SocketCommand_hero.get_heros();
		}
		
		public function sortHorse():void
		{
			if(int(this.dic_baseInfo.isriding) != 1)
			{
				return;
			}
			
			var tempList:Array = new Array();
			for(var i:String in this.arr_horseList)
			{
				if(int(this.dic_baseInfo.currenthorseid) != int(arr_horseList[i].horseid))
				{
					tempList.push(arr_horseList[i]);
				}
				else
				{
					tempList.unshift(arr_horseList[i]);
				}
			}
			this.arr_horseList = tempList;
		}
		
		private function __onSocketReturn_dismount(e:Event):void
		{
			var dic_baseInfoTemp:Object = this.dic_baseInfo;
			dic_baseInfoTemp["isriding"] = 0;
			dic_baseInfoTemp["activehorseid"] = 0;
			dic_baseInfoTemp["currenthorseid"] = 0;
			this.dic_baseInfo = dic_baseInfoTemp;
		}
		
		private function __onSocketReturn_upgradeRideSkill(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var rtnObject:Object = message.retparams;
			var dic_baseInfoTemp:Object = this.dic_baseInfo;
			dic_baseInfoTemp["leftexp"] = int(rtnObject["leftexp"]);
			dic_baseInfoTemp["rideskilllevel"] = int(rtnObject["skilllevel"]);
			dic_baseInfoTemp["upgradetotalexp"] = int(rtnObject["upgradetotalexp"]);
			dic_baseInfoTemp["silverupgradecount"] = rtnObject['silverupgradecount'];
			dic_baseInfoTemp["goldupgradecount"] = rtnObject['goldupgradecount'];
			
			this.dic_baseInfo = dic_baseInfoTemp;
			this._updateUserInfo();
			this.dispatchEventWith("horsedatachange" , false ,
				{"type":"upgraderideskill",
				 "upgradetype":int(rtnObject["userUpgradeType"]),
				 "normalCount":rtnObject.normalCount,
				 "criticalCount":rtnObject.count_critical,
				 "totalCount":rtnObject.count_total,
				 "upgradetotalexp":rtnObject.upgradetotalexp});
			//活跃度
			
			if(int(dic_baseInfoTemp["goldupgradecount"]) > 0)
			{
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_HORSEGOLDUPGRADE});
			}
			else
			{
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_HORSEUPGRADE});
			}
			
			SocketCommand_hero.get_heros();
		}
		
		private function __onSocketReturn_upgradeRideSkillRank(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var rtnObject:Object = message.retparams;
			var exp_left:int = int(rtnObject["leftexp"]);
			var skillLevel:int = int(rtnObject["rideskilllevel"]);
			var nextHorseId:int = int(rtnObject["nextHorseid"])
			
			var dic_baseInfoTemp:Object = this.dic_baseInfo;
			dic_baseInfoTemp["leftexp"] = exp_left;
			dic_baseInfoTemp["rideskilllevel"] = skillLevel;
			
			dic_baseInfoTemp["activehorseid"] = nextHorseId;
			dic_baseInfoTemp["currenthorseid"] = nextHorseId;
			
			this.dic_baseInfo = dic_baseInfoTemp;
			this._updateUserInfo();
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_HORSE_UPGRADERANK_SUCCESS);
			//获取坐骑信息
			SocketCommand_horse.getHorseInfo();
			SocketCommand_hero.get_heros();
		}
		
		private function __onSocketReturn_changeHorse(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var rtnObject:Object = message.retparams;
			var horseid:String = rtnObject["activehorseid"];
			
			var dic_baseInfoTemp:Object = this.dic_baseInfo;
			dic_baseInfoTemp["activehorseid"] = horseid;
			dic_baseInfoTemp["currenthorseid"] = horseid;
			this.dic_baseInfo = dic_baseInfoTemp;
			
			SocketCommand_hero.get_heros();
		}
		
		private function __onSocketReturn_extendHorse(e:Event):void
		{
			Assert(false, "没完成,用来更新激活的坐骑的展示");
		}
		
		/**
		 * 得到当前的坐骑id
		 */		
		public function getCurrentHorse():int
		{
			var dic_baseInfoTemp:Object = this.dic_baseInfo;
			if (dic_baseInfo == null)
				return 0;
			return dic_baseInfoTemp["currenthorseid"];
		}
		
		/**
		 * 得到当前的骑术等级
		 */		
		public function getCurrentRideSkillLevel():int
		{
			var dic_baseInfoTemp:Object = this.dic_baseInfo;
			return dic_baseInfoTemp["rideskilllevel"];
		}
		
		/**
		 * 更新用户的信息，主要是货币信息
		 */
		private function _updateUserInfo():void
		{
			SocketCommand_role.get_role_info();
		}
		
		public function get dic_baseInfo():Object
		{
			return this.getData("dic_baseInfo");
		}
		public function set dic_baseInfo(value:Object):void
		{
			return this.setData("dic_baseInfo", value);
		}
		public function get arr_horseList():Array
		{
			return this.getData("arr_horseList");
		}
		public function set arr_horseList(value:Array):void
		{
			return this.setData("arr_horseList", value);
		}

		public function get clickType():String
		{
			return _clickType;
		}

		public function set clickType(value:String):void
		{
			_clickType = value;
		}

	}
}