package SJ.Game.horse
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.events.Event;
	
	public class CJHorseModule extends CJModulePopupBase
	{
		private var _horseLayer:CJHorseLayer;
		private var loading:CJLoadingLayer;
		private var _RESOURCE_TYPE:String = "CJHorseModuleResource";
		
		public function CJHorseModule()
		{
			super("CJHorseModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
//					"resource_zuoqi.xml",
					"resource_item1.xml"];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(this._loadingHandler);
		}
		
		private function _loadingHandler(progress:Number):void
		{
			if(progress == 1)
			{
				CJLoadingLayer.close();
				SocketManager.o.callwithRtn(ConstNetCommand.CS_HORSE_GETHORSEINFO , this.initUi);
			}
		}
		
		private function initUi(message:SocketMessage):void
		{
			var horseData:CJDataOfHorse = CJDataManager.o.DataOfHorse;
			horseData.sortHorse();
			
			var xml_horseBase:XML = AssetManagerUtil.o.getObject("horseLayout.sxml") as XML;
			_horseLayer = SFeatherControlUtils.o.genLayoutFromXML(xml_horseBase,CJHorseLayer) as CJHorseLayer;
			CJLayerManager.o.addToModuleLayerFadein(_horseLayer);
		}
		
		override protected function _onExit(params:Object=null):void
		{	
			CJLayerManager.o.removeFromLayerFadeout(_horseLayer);
			_horseLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			
			CJEventDispatcher.o.removeEventListeners(CJEvent.EVENT_HORSE_UPGRADERANK_SUCCESS);
			
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params)
		}
	}
}