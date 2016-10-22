package SJ.Game.rank
{
	import SJ.Common.Constants.ConstRank;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketCommand_rank;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;

	/**
	 * 排行榜模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJRankModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJRankModuleResource";
		private var _rankLayer:CJRankLayer;
		
		public function CJRankModule()
		{
			super("CJRankModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["resourceui_card_common.xml"];
		}
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);

			CJLoadingLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());

			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					//进入模块时添加排行榜层
					var rankXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlRankList) as XML;
					_rankLayer = SFeatherControlUtils.o.genLayoutFromXML(rankXml, CJRankLayer) as CJRankLayer;
					CJLayerManager.o.addToModuleLayerFadein(_rankLayer);
					SocketCommand_rank.getRankLevel();
					SocketCommand_rank.getRankBattleLevel();
					SocketCommand_rank.getRankRichLevel();
					
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除排行榜层
			CJLayerManager.o.removeFromLayerFadeout(_rankLayer);
			_rankLayer = null;
			//移除加载的排行榜层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			CJEventDispatcher.o.removeEventListeners(("rankItemMenuClicked" + ConstRank.RANK_TYPE_RANK_LEVEL));
			CJEventDispatcher.o.removeEventListeners(("rankItemMenuClicked" + ConstRank.RANK_TYPE_RANK_BATTLE_LEVEL));
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}