package SJ.Game.herotrain
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.core.PushService;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import lib.engine.utils.CTimerUtils;
	
	/**
	 * 武将训练
	 * @author longtao
	 * 
	 */
	public class CJHeroTrainModule extends CJModulePopupBase
	{
		private var _pickLayer:CJHeroTrainPickLayer;
		
		public function CJHeroTrainModule()
		{
			super("CJHeroTrainModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			//添加加载动画
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
//			CJLayerManager.o.addToModal(loading);
			
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("resouce_HeroTrainUI", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("heroTrainLayout.sxml") as XML;
					_pickLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJHeroTrainPickLayer) as CJHeroTrainPickLayer;
					_pickLayer.addAllListener(); // 添加监听
					CJLayerManager.o.addToModuleLayerFadein(_pickLayer);
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
					
					// 添加未激活监听
					NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE ,_onDeActivate);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			_pickLayer.removeAllListener(); // 移除监听
			
			CJLayerManager.o.removeFromLayerFadeout(_pickLayer);
			
			_pickLayer = null;
			// 释放资源
			AssetManagerUtil.o.disposeAssetsByGroup("resouce_HeroTrainUI");
			super._onExit(params);
			SocketCommand_role.get_role_info();
			SocketCommand_hero.get_heros();
		}
		
		/**
		 * 程序被切到后台
		 * @param e
		 */
		private function _onDeActivate(e:Event):void
		{
			var obj:Object = CJDataManager.o.DataOfHeroTrain.getHroTrain();
			var userid:int = int(CJDataManager.o.DataOfAccounts.userID);
			for (var heroid:String in obj)
			{
				if(int(heroid) == userid)
				{
					var time:int = int(obj[heroid]);
					PushService.o.sendLocalNotification(CJLang("LOCALNOTIFICATION_TRAIN"),time + CTimerUtils.getCurrentTime()/1000,CJLang("PUSH_TITLE"));
				}
			}
		}
		
	}
}