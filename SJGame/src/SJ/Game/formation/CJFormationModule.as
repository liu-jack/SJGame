package SJ.Game.formation
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketCommand_arena;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFormation;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.config.CJDataFormationPropertyList;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;

	/**
	 +------------------------------------------------------------------------------
	 * @name 战前布局模块
	 * @comment 1.选择阵型 2.选择武将位置 3.选择武将技能
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-3-29 下午1:39:29  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJFormationModuleResource";
		/*模块名*/
		private static const _MOUDLE_NAME:String = "CJFormationModule";
		/*资源描述文件名*/
//		private static const _resource_XML_Name:String = "resourceui_zhenxing.xml";
		/*武将头像资源文件名*/
		private static const _resource_hero_LOGO_Name:String = "resourceui_card_common.xml";
		/*技能资源*/
		private static const _resource_skill_LOGO_Name:String = "resource_skillicon.xml";
		/*阵型相关的layer*/
		private var _formationLayer:CJFormationLayer = null;
		/*管理模块相关的layer销毁*/
		private var _dataLoadTime:int = 0;
		
		private var _heroInited:Boolean = false;
		private var _formationInited:Boolean = false;
		
		public function CJFormationModule()
		{
			super(_MOUDLE_NAME);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
			//初始化主角的位置
			this.initRole();
		}
		
		override public function getPreloadResource():Array
		{
			return [_resource_hero_LOGO_Name];
		}
		
		//处理默认主角放置问题 -- 默认放在0号位置
		private function initRole():void
		{
			var roleInited:Boolean = false;
			
			var heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			var roldId:String = heroList.getRoleId();
			var formationData:CJDataOfFormation = CJDataManager.o.DataOfFormation;
			var dataList:Array = formationData.getData(CJDataOfFormation.DATA_KEY);
			for(var i:int = 0;i < CJDataOfFormation.HERO_NUM_IN_FORMATION ; i++ )
			{
				var heroId:String = dataList[i];
				if(int(heroId) != 0 && int(heroId) != -1)
				{
					var heroDao:CJDataOfHero = heroList.getHero(heroId);
					if(heroDao && heroDao.isRole)
					{
						roleInited = true;
					}
				}
			}
			if(!roleInited)
			{
				formationData.saveFormation(roldId,0 );
			}
		}
		
		/**
		 *进入模块，确定显示的layer 
		 * @param params
		 */
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			CJLoadingLayer.show();
			//进入阵型读技能
			CJDataManager.o.DataOfUserSkillList.loadFromRemote();
			this._loadResource(params);
			
			if(params && params.hasOwnProperty('userId') && params.hasOwnProperty('treasurePartId'))
			{
				CJDataManager.o.DataOfFormation.formationKey = CJDataOfFormation.ENTER_FROM_DUOBAO;
			}
		}
		
		/**
		 * 退出模块，销毁layer与资源数据
		 * @param params
		 */
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//移除模块相关layer
			CJLayerManager.o.removeFromLayerFadeout(_formationLayer);
			_formationLayer = null;
			
			CJDataManager.o.DataOfFormation.dispose();
			CJFormationSquareManager.o.dispose();
			//销毁资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			
			
			//还原阵型中助战武将数据
			var dataOfFormation:CJDataOfFormation = CJDataManager.o.DataOfFormation
			dataOfFormation.loadFromRemote();
			if (dataOfFormation.dataAssistant)
			{
				ConstDynamic.isAssistantAdd = false;
				dataOfFormation.dataAssistant = null;
				dataOfFormation.assistantHeroId = null;
			}
			//还原从副本进入阵型标志
			ConstDynamic.isEnterFromFuben = 0;
			CJEventDispatcher.o.removeEventListeners(CJEvent.EVENT_TURN_PAGE_SELECTED);
			//清除夺宝标记
			CJDataManager.o.DataOfFormation.formationKey = '';
		}
		
		/**
		 * 加载初始阵型资源
		 */
		private function _loadResource(params:Object):void
		{
			/*布局文件，资源配置，战阵配置，武将属性，武将头像*/
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(
				function f(progress:Number):void
				{
					CJLoadingLayer.loadingprogress = progress;
					if(progress == 1)
					{
						CJLoadingLayer.close();
						CJDataOfHeroPropertyList.o;
						CJDataOfSkillPropertyList.o;
						CJDataFormationPropertyList.o;
						_formationLayer = new CJFormationLayer();
						CJLayerManager.o.addToModuleLayerFadein(_formationLayer);
						//阵型默认没有选择助战和开战按钮
						_formationLayer.btnStartBattleVisible = false;
						
//						阵型打开，点击开始战斗回调 ->夺宝
						if(params && params.hasOwnProperty('userId') && params.hasOwnProperty('treasurePartId'))
						{
							var userid:String = params['userId'];
							var treasurePartId:String = params['treasurePartId'];
							_formationLayer.btnStartBattleVisible = true;
							_formationLayer.btnStartBattleCallback = function():void
							{
								//保存阵型数据
								SocketManager.o.callwithRtn(ConstNetCommand.CS_DUOBAO_SAVEEMPLOYFORMATION , function():void
								{
									SocketCommand_duobao.lootTreasurePart(userid, "" + treasurePartId);	
									SApplication.moduleManager.exitModule(CJFormationModule.MOUDLE_NAME);
								}, false , CJDataManager.o.DataOfDuoBaoEmploy.formationIndex);
							}
						}
						
						if(params && params.hasOwnProperty("arenauid"))
						{
							_formationLayer.btnStartBattleVisible = true;
							_formationLayer.btnStartBattleCallback = function():void
							{
								SocketCommand_arena.battle(params["arenauid"])
								SApplication.moduleManager.exitModule(CJFormationModule.MOUDLE_NAME);
							}
						}
						if(ConstDynamic.isEnterFromFuben)
						{
							_formationLayer.btnStartBattleVisible = true;
							if(ConstDynamic.isEnterFromFuben == ConstDynamic.ENTER_FROM_ACTFB)
							{
								_formationLayer.btnStartBattleCallback = function():void
								{
									CJEventDispatcher.o.dispatchEventWith(ConstDynamic.DYNAMIC_STARTFROMACTFB_FIGHT);
									SApplication.moduleManager.exitModule("CJWorldMapModule");
								}
								return;
							}
							_formationLayer.btnStartBattleCallback = function():void
							{
								CJEventDispatcher.o.dispatchEventWith(ConstDynamic.DYNAMIC_START_FIGHT);
								SApplication.moduleManager.exitModule("CJWorldMapModule");
							}
						}
					}
				});
		}

		public static function get RESOURCE_TYPE():String
		{
			return _RESOURCE_TYPE;
		}

		public static function get MOUDLE_NAME():String
		{
			return _MOUDLE_NAME;
		}
	}
}