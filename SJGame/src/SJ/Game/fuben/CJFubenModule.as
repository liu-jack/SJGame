package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingLayer;
	import SJ.Game.layer.CJLoadingSceneLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.events.Event;
	
	/**
	 *   副本模块
	 * @author yongjun
	 * 
	 */
	public class CJFubenModule extends CJModuleSubSystem
	{
		public function CJFubenModule()
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
				"resource_fuben.xml",
				"resourceui_card_common.xml",
				ConstResource.sResXmlItem_1,
				];
		}
		
		private var _fuLayer:CJFubenLayer
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJFubenModuleResource0",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				if(r == 1)
				{
					var fubenXml:XML = AssetManagerUtil.o.getObject("fubenLayout.sxml") as XML;
					_fuLayer = SFeatherControlUtils.o.genLayoutFromXML(fubenXml,CJFubenLayer) as CJFubenLayer;
					_fuLayer.data = params;
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, getfubenRet);
					SocketCommand_fuben.getFubenInfo(params.fid)
					CJLoadingLayer.isShowHorse = false;
				}
			})
		}
		
		private function getfubenRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_GETFUBENINFO)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData, getfubenRet)
				_fuLayer.updateVit(message.retparams["vit"])
				_fuLayer.fubenData = message.retparams["list"];
				_fuLayer.updateItemStats();
				CJLayerRandomBackGround.Close();
				CJLayerManager.o.addModuleLayer(_fuLayer);
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_NOT_DISPLAY_SCENE_PLAYERS);
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLoadingLayer.isShowHorse = true;
			
			
			if(_fuLayer.fubenEnterLayer)
			{
				_fuLayer.fubenEnterLayer.removeFromParent(true);
				_fuLayer.exit();
			}
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_DISPLAY_SCENE_PLAYERS);
			_fuLayer.removeFromParent(true);
			_fuLayer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJFubenModuleResource0");
		}
	}
}