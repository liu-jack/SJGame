package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingSceneLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.events.Event;
	
	/**
	 *   副本模块
	 * @author yongjun
	 * 
	 */
	public class CJActiveFbModule extends CJModuleSubSystem
	{
		public function CJActiveFbModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		
		override public function getPreloadResource():Array
		{
			// TODO Auto Generated method stub
			return [
				];
		}
		
		private var _fuLayer:CJActiveFbLayer
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
//			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadingSceneLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJFubenModuleResource0",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				loadingSceneLayer.loadingprogress =r;
				if(r == 1)
				{
					_fuLayer = new CJActiveFbLayer;
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, getfubenRet);
					SocketCommand_fuben.getActFbInfo()
					loadingSceneLayer.close();
					
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
				}
			})
		}
		
		private function getfubenRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_ACTFUBEN_GETALL_FUBENINFO)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData, getfubenRet)
				_fuLayer.data = message.retparams;
				CJLayerManager.o.addToModuleLayerFadein(_fuLayer);
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			if(_fuLayer.cjActGuankaLayer)
			{
				_fuLayer.cjActGuankaLayer.removeFromParent(true);
				_fuLayer.cjActGuankaLayer = null;
			}
			CJLayerManager.o.removeFromLayerFadeout(_fuLayer);
			_fuLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup("CJFubenModuleResource0");
		}
	}
}