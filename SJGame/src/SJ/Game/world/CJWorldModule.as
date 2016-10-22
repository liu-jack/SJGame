package SJ.Game.world
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketCommand_scene;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	import SJ.Game.task.CJTaskNavigation;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.events.Event;

	/**
	 * 
	 * @author yongjun
	 * 世界地图
	 */	
	public class CJWorldModule extends CJModuleSubSystem
	{
		
		private var _worldLayer:CJWorldLayer;
		private var _mapid:int;
		private var _cjTaskNavigation:CJTaskNavigation;
		
		public function CJWorldModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			// TODO Auto Generated method stub
			return [ConstResource.sResWorld,ConstResource.sResSxmlWorld,ConstResource.SResSxmlWorldIcon];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben)
			if(cjdataof.gotos == ConstFuben.FUBEN_SUPER)
			{
				cjdataof.gotos = "";
				cjdataof.from = ConstFuben.FUBEN_SUPER;
			}
			else
			{
				cjdataof.from = ConstFuben.FUBEN_COMMON;
			}
			_cjTaskNavigation = new CJTaskNavigation();
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJWorldModuleResource0",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				if(r == 1)
				{
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,getAllFubenInfoRet);
					SocketCommand_fuben.getAllFubenInfo();
					_worldLayer = new CJWorldLayer;
					_worldLayer.data = params;
					CJLayerManager.o.addToScreenLayer(_worldLayer);
					SocketCommand_scene.changeScene(CJDataOfScene.SCENE_WORLD_ID)
				}
			})
		}
		
		private function getAllFubenInfoRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_GETALL_FUBENINFO)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData, getAllFubenInfoRet)
				_worldLayer.updateFuben(message.retparams)
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_cjTaskNavigation.dispose();
			_worldLayer.removeFromParent(true);
			_worldLayer = null;
			//移除加载的主界面层的资源
			AssetManagerUtil.o.disposeAssetsByGroup("CJWorldModuleResource0");
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}