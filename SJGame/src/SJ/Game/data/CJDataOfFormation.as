package SJ.Game.data
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_formation;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.data.SDataBaseRemoteData;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SStringUtils;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;

	/**
	 +------------------------------------------------------------------------------
	 * @name 当前阵型信息
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-9 下午6:45:12  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfFormation extends SDataBaseRemoteData
	{
		public static const ENTER_FROM_DUOBAO:String = 'duobao';
		
		public static const DATA_KEY:String = "currentFormationData";
		/*阵型能出征的武将数量*/
		public static const HERO_NUM_IN_FORMATION:int = 6;
		/*位置0 - 5 存储的武将heroid     位置0 默认为主角*/
		private var _pos0:String = "-1";
		private var _pos1:String = "-1";
		private var _pos2:String = "-1";
		private var _pos3:String = "-1";
		private var _pos4:String = "-1";
		private var _pos5:String = "-1";
		private var _heroList:CJDataOfHeroList;
		//助战好友的武将id
		private var _assistantHeroId:String = "-1";
		//助战好友的武将数据
		private var _dataAssistant:CJDataOfAssistantInFormation;
		
		private var _npcDictionary:Dictionary = new Dictionary();
		
		public static const FORMATION_DATA_CHANGED:String = "formation_data_change";
		/*所有的阵型数据*/
		private var _dataList:Array;
		/*阵型是否已经指引过*/
		private var _formationDirected:int = 0;
		/*标识主角是否升阶过,需要在技能部分显示新技能的火圈*/
		private var _roleUpdated:int = 0;
		
		private var _formationKey:String = '';
		
		
		public function CJDataOfFormation()
		{
			super("CJDataOfFormation");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onSocketEvent);
		}

		//读取上次阵型数据
		override protected function _onloadFromRemote(params:Object = null):void
		{
			SocketCommand_formation.getLastFormation();
		}
		
		/**
		 * 读取阵型数据返回
		 */		
		private function _onSocketEvent(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			var command:String = msg.getCommand();
			if(command == ConstNetCommand.CS_FORMATION_LAST)
			{
				var retCode:int = msg.params(0)
				if(retCode == 1)
				{
					Logger.log("------------------->" , "formation data inited");
					var data:Object = msg.retparams;
					_dataList = new Array();
					this.setData(DATA_KEY , _dataList);
					for(var i:int = 0;i < HERO_NUM_IN_FORMATION ; i++ )
					{
						this["pos"+i] = data['pos'+i];
					}
					this._onloadFromRemoteComplete();
				}
			}
			else if(command == ConstNetCommand.CS_FORMATION_CHANGE)
			{
//				SocketLockManager.KeyUnLock("SocketCommand_formation.changeFormation");
			}
		}
		
		/**
		 * 保存阵型数据 支持武将互相换位置
		 * @param posTo heroid 需要放过去的位置 -1 表示要移除
		 * @param posFrom heroid 从哪放过来的 -1 表示放过来的武将原来没有位置
		 * @param heroId 被拖拽的武将id
		 */		
		public function saveFormation(heroId:String , posTo:int , posFrom:int = -1 , isInvite:Boolean = false):void
		{
			//移除操作
			if(posTo == -1)
			{
				this._handleDeleteHero(heroId , posTo , posFrom);
			}
			//交换位置操作
			else if(posFrom != -1 && posTo != -1)
			{
				this._handleSwapHero(heroId , posTo , posFrom);
			}
			//武将面板拖拽替换武将操作
			else if(posFrom == -1 && posTo != -1)
			{
				this._handleChangeHero(heroId , posTo , posFrom);
			}
			else
			{
				Assert(false , "非法的阵型操作");
			}
		}
		/**
		 * 武将面板拖过来替换武将
		 */		
		private function _handleChangeHero(heroId:String, posTo:int, posFrom:int):void
		{
			var dataList:Array = this.getData(DATA_KEY);
			_heroList = CJDataManager.o.DataOfHeroList;
			//如果是主角，或者是助战武将不能替换
			
			var heroIdInPosto:String = this["pos"+posTo];
			
			var employHeroId:String = CJDataManager.o.DataOfDuoBaoEmploy.employHeroId;
			if( ( employHeroId!= "-1" && heroIdInPosto == employHeroId)
				|| (this.assistantHeroId != "-1" && heroIdInPosto == this.assistantHeroId) 
				|| _heroList.checkIsRole(this["pos"+posTo])
			)
			{
				return;
			}
			else
			{
				var onCallHeroNum:int = getOncallHeroNum();
				//检测是否已经大于5人
				if( onCallHeroNum > 5 )
				{
					return;
				}
				else
				{
					//换过去的位置上没有人，判断武将数量
					if((heroIdInPosto == "-1" || int(heroIdInPosto) == 0) && onCallHeroNum >=5)
					{
						new CJTaskFlowString(CJLang("FORMATION_HERO_ENOUGH") , 1 , 10).addToLayer();
						return;
					}
					this["pos"+posTo] = heroId;
				}
			}
			
			this.setData(DATA_KEY , dataList);
			this.dispatchEventWith(FORMATION_DATA_CHANGED , false , {"posTo":posTo, "posFrom":posFrom});
			
			SocketCommand_formation.changeFormation(heroId , posFrom , posTo);
			//刷新主界面战斗力
			SocketCommand_hero.get_heros();
		}
		
		/**
		 * 阵型上拖拽互换位置
		 */		
		private function _handleSwapHero(heroId:String, posTo:int, posFrom:int):void
		{
			var dataList:Array = this.getData(DATA_KEY);
			_heroList = CJDataManager.o.DataOfHeroList;
			var toHeroId:String = "";
			toHeroId = dataList[posTo];
			this["pos"+posTo] = heroId;
			this["pos"+posFrom] = toHeroId;
			this.setData(DATA_KEY , dataList);
			this.dispatchEventWith(FORMATION_DATA_CHANGED , false , {"posTo":posTo, "posFrom":posFrom});
			
			if(SStringUtils.isEmpty(heroId))
			{
				return;
			}
			
			//如果是邀请好友，则A -> B  = B ->A
			if(heroId && (heroId == CJDataManager.o.DataOfAssistantInFormation.assistantHeroId || heroId == CJDataManager.o.DataOfDuoBaoEmploy.employHeroId))
			{
				if(heroId == CJDataManager.o.DataOfDuoBaoEmploy.employHeroId)
				{
					CJDataManager.o.DataOfDuoBaoEmploy.formationIndex = posTo;
				}
				SocketCommand_formation.changeFormation(toHeroId , posTo , posFrom);
			}
			else
			{
				if(toHeroId == CJDataManager.o.DataOfDuoBaoEmploy.employHeroId)
				{
					CJDataManager.o.DataOfDuoBaoEmploy.formationIndex = posFrom;
				}
				SocketCommand_formation.changeFormation(heroId , posFrom , posTo);
			}
			//刷新主界面战斗力
			SocketCommand_hero.get_heros();
		}
		
		/**
		 * 删除武将
		 */		
		private function _handleDeleteHero(heroId:String , posTo:int , posFrom:int = -1):void
		{
			var dataList:Array = this.getData(DATA_KEY);
			_heroList = CJDataManager.o.DataOfHeroList;
			
			//如果是主角或者是助战武将，不能移除 夺宝雇佣武将不能删除
			if((heroId && heroId == CJDataManager.o.DataOfDuoBaoEmploy.employHeroId)
				|| (this.assistantHeroId != "-1" && heroId == this.assistantHeroId)
				|| (_heroList.herolist.hasOwnProperty(heroId) && _heroList.checkIsRole(heroId)))
			{
				//数据不变化
				this.dispatchEventWith(FORMATION_DATA_CHANGED , false , {"posTo":posTo, "posFrom":posFrom});
				return;
			}
			else
			{
				this["pos"+posFrom] = "";
				this.setData(DATA_KEY , dataList);
				this.dispatchEventWith(FORMATION_DATA_CHANGED , false , {"posTo":posTo, "posFrom":posFrom});
				SocketCommand_formation.changeFormation(heroId , posFrom , posTo);
				//刷新主界面战斗力
				SocketCommand_hero.get_heros();
			}
		}
		
		/**
		 * 获取自己出征的武将数目
		 */ 
		public function getOncallHeroNum():int
		{
			var num:int = 0;
			for(var i:int = 0 ; i< _dataList.length ; i++)
			{
				if(_dataList[i] == _assistantHeroId || _dataList[i] == CJDataManager.o.DataOfDuoBaoEmploy.employHeroId)
				{
					continue;
				}
				else if(_dataList[i] != "" && _dataList[i] != "-1")
				{
					num++;
				}
			}
			return num;
		}
		
		/**
		 *  当前出征武将列表
		 */		
		public function get currentFormationData():Array
		{
			return this.getData(DATA_KEY);
		}
		
		/**
		 * 判断英雄是否已经被放置 
		 * @param heroId
		 */		
		public function isHeroPlaced(heroId:String):Boolean
		{
			for (var i:int = 0; i < HERO_NUM_IN_FORMATION; i++) 
			{
				if(this["_pos"+i] == heroId)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 根据位置获取武将的heroid
		 * @param pos
		 */		
		public function getHeroIdByPos(pos:int):String
		{
			return this["_pos"+pos];
		}
		/**
		 * 根据武将id获取对应位置
		 * @param pos -1 没有对应的位置
		 */		
		public function getPosidByHeroId(heroId:String):int
		{
			for (var i:int = 0; i < HERO_NUM_IN_FORMATION; i++) 
			{
				if(int(heroId) != 0 && this["_pos"+i] == heroId)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 找到第一个空的位置
		 */ 
		public function getFirstEmptyPos():int
		{
			for (var i:int = 0; i < HERO_NUM_IN_FORMATION; i++) 
			{
				var heroid:int = int(this["_pos"+i])
				if(heroid == -1 || heroid == 0)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 添加npc
		 * @param heroid
		 * @param npc
		 */		
		public function addNpc(heroid:String , npc:CJPlayerNpc):void
		{
			if(this._npcDictionary.hasOwnProperty(heroid))
			{
				return;
			}
			npc.alpha = 1;
			this._npcDictionary[heroid] = npc;
		}
		
		/**
		 * 获取npc
		 * @param heroid
		 */		
		public function getNpc(heroid:String):CJPlayerNpc
		{
			if(int(heroid) != 0 && this._npcDictionary.hasOwnProperty(heroid))
			{
				return this._npcDictionary[heroid];
			}
			return null;
		}
		
		public function dispose():void
		{
			this._npcDictionary = new Dictionary();
		}
		
		public function get pos0():String
		{
			return _pos0;
		}
		
		public function set pos0(value:String):void
		{
			_pos0 = value;
			_dataList[0] = _pos0;
		}

		public function get pos1():String
		{
			return _pos1;
		}
		
		public function set pos1(value:String):void
		{
			_pos1 = value;
			_dataList[1] = _pos1;
		}

		public function get pos2():String
		{
			return _pos2;
		}
		
		public function set pos2(value:String):void
		{
			_pos2 = value;
			_dataList[2] = _pos2;
		}

		public function get pos3():String
		{
			return _pos3;
		}

		public function set pos3(value:String):void
		{
			_pos3 = value;
			_dataList[3] = _pos3;
		}
		
		public function get pos4():String
		{
			return _pos4;
		}
		
		public function set pos4(value:String):void
		{
			_pos4 = value;
			_dataList[4] = _pos4;
		}

		public function get pos5():String
		{
			return _pos5;
		}
		
		public function set pos5(value:String):void
		{
			_pos5 = value;
			_dataList[5] = _pos5;
		}

		public function get dataList():Array
		{
			return _dataList;
		}

		public function get assistantHeroId():String
		{
			return _assistantHeroId;
		}

		public function set assistantHeroId(value:String):void
		{
			_assistantHeroId = value;
		}

		public function get dataAssistant():CJDataOfAssistantInFormation
		{
			return _dataAssistant;
		}

		public function set dataAssistant(value:CJDataOfAssistantInFormation):void
		{
			_dataAssistant = value;
		}

		public function get formationDirected():int
		{
			return _formationDirected;
		}

		public function set formationDirected(value:int):void
		{
			_formationDirected = value;
		}

		public function setSkillNeedFire():void
		{
			_roleUpdated = 1;
		}
		
		public function isSkillNeedFire():Boolean
		{
			return _roleUpdated == 1;
		}
		
		public function wipeSkillNeedFire():void
		{
			_roleUpdated = 0;
		}

		public function get formationKey():String
		{
			return _formationKey;
		}

		public function set formationKey(value:String):void
		{
			_formationKey = value;
		}

	}
}