package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfEmployLimitList;
	import SJ.Game.data.json.Json_employ_level_limit;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 夺宝雇佣数据类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-11 下午5:04:16  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfDuoBaoEmploy extends SDataBaseRemoteData
	{
		/*每次点击雇佣选择的好友*/
		private var _tempSelectFriendUid:String = "";
		/*每次点击雇佣选择的好友武将*/
		private var _tempSelectHeroid:String = "";
		
		private var _employData:Object;
		
		private var _applyList:Array ;
		
		private var _formationIndex:int = -1;
		
		public function CJDataOfDuoBaoEmploy()
		{
			super("CJDataOfDuoBaoEmploy");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onSocketMessage);
		}

		public function get formationIndex():int
		{
			return _formationIndex;
		}

		public function set formationIndex(value:int):void
		{
			_formationIndex = value;
		}

		private function _onSocketMessage(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var command:String = message.getCommand();
			if(command == ConstNetCommand.CS_DUOBAO_GETMYEMPLOYDATA)
			{
				if(message.retcode == 1)
				{
					if(!message.retparams)
					{
						return;
					}
					this._setMyEmployData(message.retparams);
					this._onloadFromRemoteComplete();
					this.dispatchEventWith(CJEvent.EVENT_DUOBAO_APPLY_AGREED);
				}
			}
			else if(command == ConstNetCommand.CS_DUOBAO_AGREE)
			{
				var retcode:int = message.retcode;
				_applyList = new Array();
				if(!message.retparams)
				{
					return;
				}
				_applyList = message.retparams;
				if(_applyList && _applyList.length != 0)
				{
					_applyList.sort(_compare);
				}
				this.dispatchEventWith(CJEvent.EVENT_DUOBAO_APPLY_CHANGE);
				
				switch(retcode)
				{
					case 0:
					case 2: new CJTaskFlowString(CJLang('EMPLOY_FAIL_GUYONGSHIBAI')).addToLayer();break;
					case 3: new CJTaskFlowString(CJLang('EMPLOY_FAIL_NO_FRIEND')).addToLayer();break;
					case 4: new CJTaskFlowString(CJLang('EMPLOY_FAIL_NO_APPLY')).addToLayer();break;
					case 5: new CJTaskFlowString(CJLang('EMPLOY_FAIL_HERO_EMPLOYED')).addToLayer();break;
					case 6: new CJTaskFlowString(CJLang('EMPLOY_FAIL_FRIEND_APPLIED')).addToLayer();break;
				}
			}
			else if(command == ConstNetCommand.CS_DUOBAO_EMPLOYAPPLY || command == ConstNetCommand.CS_DUOBAO_REJECT)
			{
				if(message.retcode == 1)
				{
					_applyList = new Array();
					if(!message.retparams)
					{
						return;
					}
					_applyList = message.retparams;
					if(_applyList && _applyList.length != 0)
					{
						_applyList.sort(_compare);
					}
					this.dispatchEventWith(CJEvent.EVENT_DUOBAO_APPLY_CHANGE);
				}
			}
			else if(command == ConstNetCommand.SC_DUOBAO_APPLYAGREED)
			{
				this.loadFromRemote();
			}
		}
		
		private function _compare(ob1:Object, ob2:Object):Number
		{
			var num0:Number = Number(ob1.applytime);
			var num1:Number = Number(ob2.applytime);
			if (num0 > num1)
			{
				return -1;
			}
			else if (num0 < num1)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		private function _setMyEmployData(retparams:Object):void
		{
			_employData = retparams;
		}
		
		public function get tempSelectFriendUid():String
		{
			return _tempSelectFriendUid;
		}

		/**
		 * 每次新选择好友，则删除原来的选择武将信息
		 */ 
		public function set tempSelectFriendUid(value:String):void
		{
			_tempSelectFriendUid = value;
			_tempSelectHeroid = "";
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_duobao.getEmployData();
		}
		
		public function get canEmployFriendList():Array
		{
			var allFriend:Array = CJDataManager.o.DataOfFriends.myFriendData;
			var resultList:Array = new Array();
			var config:Json_employ_level_limit =  CJDataOfEmployLimitList.o.getLimitConfigByLevel(int(CJDataManager.o.DataOfHeroList.getMainHero().level));
			if(!config)
			{
				return allFriend;
			}
			else
			{
				var len:int = allFriend.length;
				for(var i:int; i < len ; i++)
				{
					if(int(allFriend[i].level) >= config.employminlevel && int(allFriend[i].level) <= config.employmaxlevel)
					{
						resultList.push(allFriend[i])
					}
				}
				
				resultList.sort(_cmp);
				
				return resultList;
			}
		}
		
		private function _cmp(objA:* , objB:*):int
		{
			if(int(objA.level) > int(objB.level))
			{
				return -1;
			}
			else if(int(objA.level) == int(objB.level))
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}

		public function get tempSelectHeroid():String
		{
			return _tempSelectHeroid;
		}

		public function set tempSelectHeroid(value:String):void
		{
			_tempSelectHeroid = value;
		}

		public function get applyList():Array
		{
			return _applyList;
		}

		public function get employData():Object
		{
			return _employData;
		}
		
		/**
		 * 雇佣武将的heroid
		 */ 
		public function get employHeroId():String
		{
			if(_employData && _employData.hasOwnProperty('heroid'))
			{
				return _employData['heroid'];
			}
			return '-1';
		}
		
		/**
		 * 雇佣武将的herodata
		 */ 
		public function get employheroinfo():Object
		{
			if(_employData && _employData.hasOwnProperty('employherodata'))
			{
				return JSON.parse(_employData['employherodata']);
			}
			return null;
		}
		
		/**
		 * 雇佣武将的hero templdateid
		 */ 
		public function get employheroTemplateId():Object
		{
			if(_employData && _employData.hasOwnProperty('employherodata'))
			{
				var herodata:Object = JSON.parse(_employData['employherodata']);
				return herodata['templateid'];
			}
			return null;
		}
		
		/**
		 * 雇佣武将的好友的id
		 */ 
		public function get employFriendUid():String
		{
			if(_employData.hasOwnProperty('frienduid'))
			{
				return _employData['frienduid'];
			}
			return null;
		}
	}
}