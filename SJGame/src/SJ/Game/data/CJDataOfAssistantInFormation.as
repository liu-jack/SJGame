package SJ.Game.data
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJFormationModule;
	import SJ.Game.lang.CJLang;
	import SJ.Game.loader.CJLoaderMoudle;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBase;
	
	import starling.events.Event;

	/**
	 * 助战武将在阵型中的数据
	 * @author zhengzheng
	 * 
	 */	
	public class CJDataOfAssistantInFormation extends SDataBase
	{
		/**
		 * 助战武将的id
		 */		
		private var _assistantHeroId:String;
		/**
		 * 助战武将的模板id
		 */	
		private var _assistantHeroTemplateId:String;
		/**
		 * 助战武将在阵型中的位置
		 */		
		private var _assistantHeroPos:int;
		//进入的关卡数据
		private var _dataEnterGuanqia:CJDataOfEnterGuanqia;
		
		public function CJDataOfAssistantInFormation()
		{
			super("CJDataOfAssistantInFormation");
			this.loadFromCache();
			_dataEnterGuanqia = CJDataOfEnterGuanqia.o;
			//添加开始战斗数据监听
			CJEventDispatcher.o.addEventListener(ConstDynamic.DYNAMIC_START_FIGHT, _startFight);
			CJEventDispatcher.o.addEventListener(ConstDynamic.DYNAMIC_STARTFROMACTFB_FIGHT, _startActFbFight);
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadSaveInviteHeroFormation);
		}
		
		override public function clearAll():void
		{
			super.clearAll();
			saveToCache();
		}
		
		
		/**
		 * 进入活动副本
		 * 
		 */		
		private function _startActFbFight():void
		{			
			var dataAssistant:CJDataOfAssistantInFormation = CJDataManager.o.DataOfFormation.dataAssistant;
			if (!dataAssistant)
			{
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _enterGuankaHandler);
				SocketCommand_fuben.enterActGuanKa(_dataEnterGuanqia.fubenId,_dataEnterGuanqia.guanqiaId);
			}
			else
			{
				var assistantHeroPos:int = dataAssistant.assistantHeroPos;
				SocketCommand_fuben.saveInviteHeroFormation(assistantHeroPos);
			}
		}
		
		/**
		 * 副本开始战斗
		 * 
		 */		
		private function _startFight():void
		{
			var dataAssistant:CJDataOfAssistantInFormation = CJDataManager.o.DataOfFormation.dataAssistant;
			if (!dataAssistant)
			{
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _enterGuankaHandler);
				SocketCommand_fuben.enterGuanKa(_dataEnterGuanqia.fubenId,_dataEnterGuanqia.guanqiaId);
			}
			else
			{
				var assistantHeroPos:int = dataAssistant.assistantHeroPos;
				SocketCommand_fuben.saveInviteHeroFormation(assistantHeroPos);
			}
		}
		/**
		 * 加载服务器保存助战阵型数据
		 * @param e Event
		 * 
		 */		
		private function _onloadSaveInviteHeroFormation(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_SAVE_INVITE_HERO_FORMATION)
			{
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FUBEN_SAVE_INVITE_HERO_FORMATION);
				if (message.retcode == 0)
				{
					var heroInfo:Object = message.retparams;
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _enterGuankaHandler);
					// 添加网络锁
//					SocketLockManager.KeyLock(ConstNetCommand.CS_FUBEN_ENTERGUANKA);
					if(_dataEnterGuanqia.fubenId == 0 || _dataEnterGuanqia.guanqiaId ==0)
					{
						
						CJFlyWordsUtil(CJLang("FUBEN_PARAMS_ERROR"));
						return;
					}
					if(ConstDynamic.isEnterFromFuben == ConstDynamic.ENTER_FROM_ACTFB)
					{
						SocketCommand_fuben.enterActGuanKa(_dataEnterGuanqia.fubenId,_dataEnterGuanqia.guanqiaId);
					}
					else
					{
						SocketCommand_fuben.enterGuanKa(_dataEnterGuanqia.fubenId,_dataEnterGuanqia.guanqiaId);
					}
					
					//邀请助战活跃度
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_EMPLOYFRIEND});
					//被邀请助战活跃度
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_BEEMPLOYED});
				}
			}
		}
		
		/**
		 * 进入关卡服务器返回 
		 * @param e
		 * 
		 */		
		private function _enterGuankaHandler(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_ENTERGUANKA ||message.getCommand() == ConstNetCommand.CS_FUBEN_ENTERACTFBGUANKA)
			{
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FUBEN_ENTERGUANKA);
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _enterGuankaHandler);
				switch(message.retcode)
				{
					case 0:
						var rtnObject:Object = message.retparams;

						SApplication.moduleManager.exitModule(CJFormationModule.MOUDLE_NAME);
//						SApplication.moduleManager.exitModule("CJWorldModule");
//						SApplication.moduleManager.exitModule("CJFubenModule");
						CJLoaderMoudle.helper_enterFubenBattle({"battletype":1,"battleid":_dataEnterGuanqia.firstFightId,"gid":rtnObject.gid,"fid":rtnObject.fid,"from":rtnObject.from});
//						SApplication.moduleManager.enterModule("CJFubenBattleBaseModule",{"battletype":1,"battleid":_dataEnterGuanqia.firstFightId,"gid":rtnObject.gid,"fid":rtnObject.fid});
						ConstDynamic.isEnterFromFuben = 0;
						break;
					case 1:
						CJFlyWordsUtil(CJLang("FUBEN_ENTER_UNLEVEL"));
						break;
					case 2:
						CJFlyWordsUtil(CJLang("FUBEN_ENTER_UNTASK"));
						break;
					case 3:
						CJFlyWordsUtil(CJLang("FUBEN_ENTER_UNGUANKAID"));
						break;
					case 4:
						CJFlyWordsUtil(CJLang("FUBEN_ENTER_NOVIT"));
						break;
					case 5:
						CJFlyWordsUtil(CJLang("FUBEN_PARAMS_ERROR"));
						break;
				}
			}
		}
		/**
		 * 助战武将的id
		 */
		public function get assistantHeroId():String
		{
			return getData("assistantHeroId");
		}

		/**
		 * @private
		 */
		public function set assistantHeroId(value:String):void
		{
			setData("assistantHeroId", value);
		}

		/**
		 * 助战武将的模板id
		 */
		public function get assistantHeroTemplateId():String
		{
			return getData("assistantHeroTemplateId");
		}

		/**
		 * @private
		 */
		public function set assistantHeroTemplateId(value:String):void
		{
			setData("assistantHeroTemplateId", value);
		}

		/**
		 * 助战武将在阵型中的位置
		 */
		public function get assistantHeroPos():int
		{
			return getData("assistantHeroPos");
		}

		/**
		 * @private
		 */
		public function set assistantHeroPos(value:int):void
		{
			setData("assistantHeroPos", value);
		}
	}
}