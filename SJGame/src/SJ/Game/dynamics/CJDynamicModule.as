package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.SocketServer.SocketCommand_mail;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;

	/**
	 * 动态模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJDynamicModuleResource";
		private var _dynamicLayer:CJDynamicLayer;
		
		private var _mailInited:Boolean = false;
		private var _applyInited:Boolean = false;

		private var pageType:int;
		
		public function CJDynamicModule()
		{
			super("CJDynamicModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			_applyInited = false;
			_mailInited = false;
			
			//进入相应插页
			pageType = 0;
			if (params != null)
			{
				pageType = params.hasOwnProperty("pagetype") ? params["pagetype"] : 0;
			}
			CJLoadingLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress= r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					
					SocketManager.o.callwithRtn(ConstNetCommand.CS_DUOBAO_EMPLOYAPPLY , _initUi);
					SocketManager.o.callwithRtn(ConstNetCommand.CS_MAIL_GET_MAILS , _initUi);
				}
			}
				
			);
		}
		
		private function _initUi(e:SocketMessage):void
		{
			if (e.getCommand() == ConstNetCommand.CS_DUOBAO_EMPLOYAPPLY)
			{
				if (e.retcode == 1)
				{
					_applyInited = true;
				}
			}
			
			if (e.getCommand() == ConstNetCommand.CS_MAIL_GET_MAILS)
			{
				if (e.retcode == 0)
				{
					_mailInited = true;
				}
			}
			if(_applyInited && _mailInited)
			{
				//进入模块时添加动态层
				var dynamicXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlDynamic) as XML;
				_dynamicLayer = SFeatherControlUtils.o.genLayoutFromXML(dynamicXml, CJDynamicLayer) as CJDynamicLayer;
				_dynamicLayer.setPageType(pageType);
				CJLayerManager.o.addToModuleLayerFadein(_dynamicLayer);
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除动态层
			CJLayerManager.o.removeFromLayerFadeout(_dynamicLayer);
			//移除加载的动态层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			_dynamicLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}