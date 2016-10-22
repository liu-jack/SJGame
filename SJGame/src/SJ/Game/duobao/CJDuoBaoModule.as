package SJ.Game.duobao
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.events.Event;
	
	/**
	 * 夺宝奇兵模块
	 * @author bb
	 */	
	public class CJDuoBaoModule extends CJModuleSubSystem
	{
		private var _duobaoLayer:CJDuoBaoLayer;
		
		/** 资源分组名 */
		private static const _RES_DUOBAO_GROUP_NAME:String = "CJDuobaoResource";
		
		public function CJDuoBaoModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			return [//ConstResource.sResXmlDuobao,
				ConstResource.sResJsonGlobalConfig];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onSocketMessage);
			
			//添加加载动画
			CJLoadingLayer.show();
			
			//加载强化层的布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_DUOBAO_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					CJLoadingLayer.close();
					//进入模块时添加
					SocketCommand_duobao.getEmployData();
//					SocketManager.o.callwithRtn(ConstNetCommand.CS_DUOBAO_GETMYEMPLOYDATA , _initUi);
				}
			});
		}
		
		
		private function _onSocketMessage(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var command:String = message.getCommand();
			if(command == ConstNetCommand.CS_DUOBAO_GETMYEMPLOYDATA)
			{
				if(message.retcode == 1)
				{
					if(!_duobaoLayer)
					{
						_initUi();
					}
				}
			}
		}
		
		private function _initUi():void
		{
			_duobaoLayer = new CJDuoBaoLayer();
			CJLayerManager.o.addToModuleLayerFadein(_duobaoLayer);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeFromLayerFadeout(_duobaoLayer);
			
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData , _onSocketMessage);
			
			// 移除加载的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_DUOBAO_GROUP_NAME);
			this._duobaoLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}