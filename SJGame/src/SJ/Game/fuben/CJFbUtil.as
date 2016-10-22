package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfBuyVitProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.dynamics.CJDynamicFightAssistantLayer;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	
	import starling.events.Event;
	
	public class CJFbUtil
	{
		public function CJFbUtil()
		{
		}
		
		public static function enterFb(cb:Function = null):void
		{
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			if (role.vit<int(CJDataOfGlobalConfigProperty.o.getData("GUANKA_COSTVIT")))
			{
				ConstDynamic.isEnterFromFuben = 0;
				CJConfirmMessageBox(CJLang("FUBEN_ENTER_NOVIT"),function():void
				{
					
				},function():void
				{
					buyvitUtil();
				},CJLang("COMMON_TRUE"),CJLang("FUBEN_BUYVIT_BTN"));
				return;
			}
			var bag:CJDataOfBag = CJDataManager.o.getData("CJDataOfBag") as CJDataOfBag
			if(bag.isBagFull())
			{
				CJFlyWordsUtil(CJLang("FUBEN_BAG_ISFULL"));
				return;
			}
			// 全局配置
			var globalConfig:CJDataOfGlobalConfigProperty = CJDataOfGlobalConfigProperty.o;
			// 出现助战弹框需求等级
			var zhuzhanNeedLevel:int = int(globalConfig.getData("FUBEN_ZHUZHAN_NEED_LEVEL"));
			var heroLevel:int = int(CJDataManager.o.DataOfHeroList.getMainHero().level);
			if (heroLevel < zhuzhanNeedLevel)
			{
				SApplication.moduleManager.enterModule("CJFormationModule");
			}
			else
			{
				//添加数据到达监听 
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadAssistantInfo);
				SocketCommand_fuben.getInviteHeros();
			}
		}
		
		private static function _onloadAssistantInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_GET_INVITE_HEROS)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadAssistantInfo);
				if (message.retcode == 0)
				{
					var listData:Array = message.retparams as Array;
					if (listData.length == 0)
					{
						SApplication.moduleManager.enterModule("CJFormationModule");
					}
					else
					{
						var layerAssistant:CJDynamicFightAssistantLayer = new CJDynamicFightAssistantLayer();
						CJLayerManager.o.addModuleLayer(layerAssistant);
					}
				}
			}
		}
		
		public static function buyvitUtil():void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_FUBEN_GET_BUYVIT_NUMS,function(message:SocketMessage):void
			{
				if (message.retcode ==2)
				{
					CJMessageBox(CJLang("FUBEN_BUYVIT_HASMAXNUMS"))
					return;
				}
				var nums:int = message.retparams
				var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
				var goldnum:Number = CJDataOfBuyVitProperty.o.getNeedCost(nums)
				var buyvit:int = int(CJDataOfGlobalConfigProperty.o.getData("VIT_MAX")) - role.vit;
				var totalGold:int = int(buyvit*goldnum)
				var _confirmText:String = CJLang("FUBEN_BUYVIT_CONFIRM");
				_confirmText = _confirmText.replace("{gold}",totalGold);
				_confirmText = _confirmText.replace("{vit}",int(buyvit));
				if(role.vit >= int(CJDataOfGlobalConfigProperty.o.getData("VIT_MAX")))
				{
					CJMessageBox(CJLang("FUBEN_VIT_HASMAX"));
				}
				else
				{
					CJConfirmMessageBox(_confirmText,buyVit);
				}
			})

		}
		
		/**
		 * 购买体力 
		 * 
		 */
		private static function buyVit():void
		{
			(CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben).buyVit();
		}
	}
}