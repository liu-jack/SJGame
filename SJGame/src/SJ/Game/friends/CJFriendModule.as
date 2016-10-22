package SJ.Game.friends
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;

	/**
	 * 好友模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJFriendModuleResource";
		private var _friendLayer:CJFriendLayer;
		
		public function CJFriendModule()
		{
			super("CJFriendModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["resourceui_card_common.xml"];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//进入相应插页
			var pageType:int = 0;
			if (params != null)
			{
				pageType = params.hasOwnProperty("pagetype") ? params["pagetype"] : 0;
			}
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
			//添加加载动画
//			CJLayerManager.o.addToModal(loading);
//			加载好友的资源
			CJLoadingLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
//			AssetManagerUtil.o.loadPrepareInQueue("CJFriendModuleResource0", 
//				ConstResource.sResSxmlFriend,
//				ConstResource.sResSxmlFriendInfoTips,
//				ConstResource.sResSxmlAddFriendDialog
//			);
//			AssetManagerUtil.o.loadPrepareInQueue("CJFriendModuleResource1",
//				ConstResource.sResHeroPropertys,
//				ConstResource.sResJsonGlobalConfig,
//				"resourceui_touxiang.xml",
//				"resourceui_haoyou.xml"
//			);
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					//进入模块时添加我的好友层
					var friendXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlFriend) as XML;
					_friendLayer = SFeatherControlUtils.o.genLayoutFromXML(friendXml, CJFriendLayer) as CJFriendLayer;
					_friendLayer.setPageType(pageType);
					CJLayerManager.o.addToModuleLayerFadein(_friendLayer);
					SocketCommand_friend.getAllFriendInfo();
					SocketCommand_friend.getAllFriendTempInfo();
					SocketCommand_friend.getAllRequestsInfo();
					SocketCommand_friend.getBlacklist();
				}
			});
		}
			
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除好友层
			CJLayerManager.o.removeFromLayerFadeout(_friendLayer);
			//移除加载的好友层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			_friendLayer = null;
			
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}