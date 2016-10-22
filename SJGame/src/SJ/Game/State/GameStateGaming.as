package SJ.Game.State
{
	import flash.utils.Dictionary;
	
	import SJ.Game.ACocosLayerTest.ACocosLTest;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.map.CJBattleMapManager;
	import SJ.Game.task.CJTaskEventHandler;
	import SJ.Game.task.CJTaskUIHandler;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.data.SDataBaseRemoteData;
	import engine_starling.utils.Logger;
	
	import lib.engine.iface.game.IGameState;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class GameStateGaming implements IGameState
	{
		private var _dataneedInitDict:Dictionary = new Dictionary();
		private var _params:Object;
		public function GameStateGaming()
		{
		}
		
		public function getStateName():String
		{
			return "GameStateGaming";
		}
		
		public function onEnterState(params:Object = null):void
		{
			
			
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			CJBattleMapManager.o;
			CJDataOfHeroPropertyList.o;
			CJTaskEventHandler.o;
			CJTaskUIHandler.o;
			_params = params;
			//数据
			_beginloaddata();

		}
		
		/**
		 * 加载远程数据 
		 * @param remoteDate
		 * @param params
		 * 
		 */
		private function _loadremoteDate(remoteDate:SDataBaseRemoteData,params:Object = null):void
		{
			if(remoteDate.dataIsEmpty)
			{
				_dataneedInitDict[remoteDate.dataBasename] = false;
				remoteDate.addEventListener(DataEvent.DataLoadedFromRemote,_onDataLoaded);
				remoteDate.loadFromRemote(params);
			}
			else
			{
				delete _dataneedInitDict[remoteDate.dataBasename];
			}
		}
		private var _enterDelayCall:DelayedCall;
		private function _beginloaddata():void
		{
			_loadremoteDate(CJDataManager.o.DataOfRole);//加载主角基本数据
			_loadremoteDate(CJDataManager.o.DataOfPileRecharge);// 累计充值
			_loadremoteDate(CJDataManager.o.DataOfSingleRecharge);// 单笔充值
			_loadremoteDate(CJDataManager.o.DataOfHorse);//坐骑数据
			_loadremoteDate(CJDataManager.o.DataOfBag);//加载背包数据
			_loadremoteDate(CJDataManager.o.DataOfTaskList);//加载任务数据
			_loadremoteDate(CJDataManager.o.DataOfHeroList);//武将数据
//			_loadremoteDate(CJDataManager.o.DataOfFuncList);//指引数据
			_loadremoteDate(CJDataManager.o.DataOfOLReward);// 在线奖励		
			_loadremoteDate(CJDataManager.o.DataOfCamp);// 阵营数据	
			_loadremoteDate(CJDataManager.o.DataOfUserSkillList);// 技能数据	
			_loadremoteDate(CJDataManager.o.DataOfFormation);// 阵型数据	
			_loadremoteDate(CJDataManager.o.DataOfFuncList);// 开启的功能点数据
			_loadremoteDate(CJDataManager.o.DataOfFriends);// 好友数据
			_loadremoteDate(CJDataManager.o.DataOfMail);// 邮件数据
			_loadremoteDate(CJDataManager.o.DataOfChat);// 最后的30条聊天记录
			_loadremoteDate(CJDataManager.o.DataOfNotice);// 最新公告
			_loadremoteDate(CJDataManager.o.DataOfActivity);
			_loadremoteDate(CJDataManager.o.DataOfWorldBoss);
			_loadremoteDate(CJDataManager.o.DataOfVIP);
			_loadremoteDate(CJDataManager.o.DataOfDailyTask);
			_loadremoteDate(CJDataManager.o.DataOfReward);
			
			_finishloaddata();
			
			
			_enterDelayCall = Starling.juggler.delayCall(_fristbattlefinish,8);
			
		}
		
		private function _onDataLoaded(e:Event):void
		{
			e.target.removeEventListener(DataEvent.DataLoadedFromRemote , _onDataLoaded);
			var remoteDate:SDataBaseRemoteData = e.target as SDataBaseRemoteData;
			
			delete _dataneedInitDict[remoteDate.dataBasename];
			_finishloaddata();
		}
		

		/**
		 * 完成加载数据 
		 * 
		 */
		private function _finishloaddata():void
		{
			//还有没有加载完成的资源
			for (var key:* in _dataneedInitDict) {
				Logger.log("GameStateLogin","Left data Module:" + key);
				return;
			}
			
			
			if(CJDataManager.o.DataOfAccounts.fristbattleplayed == false && 
				int(CJDataOfGlobalConfigProperty.o.getData("FIRST_BATTLE_EXECUTE")) != 0)
			{
				if(parseInt(CJDataManager.o.DataOfHeroList.getMainHero().level) == 1)
				{
					SApplication.moduleManager.enterModule("CJFristBattleModule",{finish:_fristbattlefinish});
					
					return;
				}
				else
				{
					CJDataManager.o.DataOfAccounts.fristbattleplayed = true;
					CJDataManager.o.DataOfAccounts.saveToCache();
				}
			}
			
			_fristbattlefinish();
			
		}
		
		private function _fristbattlefinish():void
		{
			if(_enterDelayCall != null)
			{
				Starling.juggler.remove(_enterDelayCall);
				_enterDelayCall = null;
			}
			
//			CJLayerRandomBackGround.Close();
//			SApplication.moduleManager.enterModule("CJTestLuaModule");
			CJMapUtil.enterMainCity(this._params);
//			{ACocosLTest};
//			var gen:SFeatherControlGenCocosX = new SFeatherControlGenCocosX();
//			CJLayerManager.o.rootLayer.normalLayer.addChild(SFeatherControlUtils.o.genLayoutFromcocosJson(AssetManagerUtil.o.getObject("convertcocosx_1.json"),ACocosLTest));

		}
		

		
		public function onExitState(params:Object = null):void
		{
		}
	}
}