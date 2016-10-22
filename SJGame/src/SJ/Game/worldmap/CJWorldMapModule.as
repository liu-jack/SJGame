package SJ.Game.worldmap
{
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.CJTaskNavigation;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.events.Event;

	/**
	 * 
	 * @author yongjun
	 * 世界地图
	 */	
	public class CJWorldMapModule extends CJModuleSubSystem
	{
		
		private var _worldLayer:CJWorldMapLayer;
		private var _mapid:int;
		private var _cjTaskNavigation:CJTaskNavigation;
		
		public function CJWorldMapModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			// TODO Auto Generated method stub
			return [];
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
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJWorldMapModuleResource0",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				if(r == 1)
				{
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,getAllFubenInfoRet);
//					SocketCommand_fuben.getAllFubenInfo();
					_worldLayer = new CJWorldMapLayer;
					_worldLayer.initData(params);
					CJLayerManager.o.addToModuleLayerFadein(_worldLayer);
//					SocketCommand_scene.changeScene(CJDataOfScene.SCENE_WORLD_ID)
					
					
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
				}
			})
		}
		
		private function getAllFubenInfoRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_GETALL_FUBENINFO)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData, getAllFubenInfoRet)
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_cjTaskNavigation.dispose();
			CJLayerManager.o.removeFromLayerFadeout(_worldLayer);
			_worldLayer = null;
			//移除加载的主界面层的资源
			AssetManagerUtil.o.disposeAssetsByGroup("CJWorldMapModuleResource0");
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}