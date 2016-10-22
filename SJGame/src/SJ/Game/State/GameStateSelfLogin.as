package SJ.Game.State
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import SJ.MainApplication;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.SocketServer.SocketCommand_account;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.PushService;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.loader.CJLoaderMoudle;
	import SJ.Game.mainUI.CJNoticeLabel;
	
	import engine_starling.SApplication;
	import engine_starling.socket.SSocketEvent;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SManufacturerUtils;
	
	import lib.engine.iface.game.IGameState;
	import lib.engine.utils.CTimerUtils;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	
	/**
	 * 本身登录系统 
	 * @author caihua
	 * 
	 */
	public class GameStateSelfLogin implements IGameState
	{
		public function GameStateSelfLogin()
		{
		}
		
		public function getStateName():String
		{
			return "GameStateSelfLogin";
		}
	
		public function onEnterState(params:Object=null):void
		{
			CJLoaderMoudle.loadModuleWithResource(["CJClientUpgradeModule"],
				["CJLoginModule","CJClientUpgradeModule","CJCreateModule","CJRegisterModule"]);
			
			_startupsystem();
		}
		
		private function _startupsystem():void
		{
			var noticeLabel:CJNoticeLabel = new CJNoticeLabel();
			CJLayerManager.o.addToTop(noticeLabel);
			
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { 
					var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform; 
					iPlatform.enterpause();
				});
			
			var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform; 
			iPlatform.entertoolbar();
			
			
			
			if(SManufacturerUtils.getManufacturerType() != SManufacturerUtils.TYPE_WINDOWS)
			{
				//切到后台断开网络
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE,function(e:*):void
				{
					SocketManager.o.disconnect();
					//竞技场push
					var currentlocaltimeInday:Number = (CTimerUtils.getCurrentMiSecondLocal() / 1000) % CTimerUtils.TotalSecDay;
					var difftime:Number = (21 * CTimerUtils.TotalSecHour - currentlocaltimeInday);
					var currentsecond:Number = difftime + CTimerUtils.TotalSecDay;
					//每天10点发送
					currentsecond = currentsecond + CTimerUtils.getCurrentTime() / 1000;
					PushService.o.sendLocalNotification(CJLang("ARENA_AWARD_BEFOREPUSH"),currentsecond,CJLang("PUSH_TITLE"),PushService.RECURRENCE_DAY);
				});
			}
			else
			{
				//切到后台断开网络
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE,function(e:*):void
				{
					SocketManager.o.disconnect();
				});
			}
			
			
			//断线重连后的登陆消息
			SocketManager.o.auto_reconnectCallback = function():void
			{
					SocketCommand_account.login(CJDataManager.o.DataOfAccounts.accounts,CJDataManager.o.DataOfAccounts.password);
			};
			//服务器错误消息
			SocketManager.o.addEventListener(SSocketEvent.SocketEventDataError,function(e:*):void
			{
				var message:SocketMessage = e.data as SocketMessage;
				var msg:String = message.retparams.sererr.toString();
				msg = msg.replace(/</g,"$");
				CJMessageBox(CJLang("LOGIN_SERVER_ERROR") + msg);
			});
			
			//增加手动GC
			var delaydc:DelayedCall = new DelayedCall(AssetManagerUtil.o.removeUnusedResource,1 * 60);
			delaydc.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(delaydc);
				
			
		}
		
		public function onExitState(params:Object=null):void
		{
		}
	}
}