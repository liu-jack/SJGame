package SJ.Game.treasure
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHeroTreasureList;
	import SJ.Game.data.CJDataOfTreasureList;
	import SJ.Game.data.CJDataOfTreasureUserInfo;
	import SJ.Game.data.config.CJDataOfTreasurePropertyList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 灵丸模块入口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午3:24:12  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasureModule extends CJModulePopupBase
	{
		private var loading:CJLoadingLayer;
		private var _treasuerInited:Boolean = false;
		private var _treasureUserInfoInited:Boolean = false;
		private var _heroTreasuerInited:Boolean = false;
		private var _layer:CJTreasureLayer;
		
		public function CJTreasureModule()
		{
			super("CJTreasureModule");
		}
		
		override protected function _onInit(params:Object = null):void
		{
			super._onInit(params);
		}
		
		override public function getPreloadResource():Array
		{
			return [
//				ConstResource.sResXmlTreasure
			];
		}
		
		private function _loadData():void
		{
			var treasuerList:CJDataOfTreasureList = CJDataManager.o.DataOfTreasureList;
			var treasuerUserInfoList:CJDataOfTreasureUserInfo = CJDataManager.o.DataOfTreasureUserInfo;
			var heroTreasuerList:CJDataOfHeroTreasureList = CJDataManager.o.DataOfHeroTreasureList;
			if(treasuerList.dataIsEmpty)
			{
				treasuerList.loadFromRemote();
				treasuerList.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			}
			else
			{
				this._treasuerInited = true;
			}
			if(treasuerUserInfoList.dataIsEmpty)
			{
				treasuerUserInfoList.loadFromRemote();
				treasuerUserInfoList.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			}
			else
			{
				this._treasureUserInfoInited = true;
			}
			if(heroTreasuerList.dataIsEmpty)
			{
				heroTreasuerList.loadFromRemote();
				heroTreasuerList.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoaded);
			}
			else
			{
				this._heroTreasuerInited = true;
			}
			this.initUi();
		}
		
		private function _onDataLoaded(e:Event):void
		{
			if(e.target is CJDataOfTreasureList)
			{
				this._treasuerInited = true;
			}
			else if(e.target is CJDataOfTreasureUserInfo)
			{
				this._treasureUserInfoInited = true;
			}
			else if(e.target is CJDataOfHeroTreasureList)
			{
				this._heroTreasuerInited = true;
			}
			this.initUi();
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			this._loadResource();
		}
		
		private function _loadResource():void
		{
			loading = new CJLoadingLayer();
			CJLayerManager.o.addModuleLayer(loading);
			//NPC对话框内容
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJTreasureModuleResource" , getPreloadResource());
			AssetManagerUtil.o.loadQueue(this._loadingHandler)
		}
		
		private function _loadingHandler(progress:Number):void
		{
			loading.progress = progress;
			if(progress == 1)
			{
				loading.removeFromParent(true);
				//加载数据
				this._loadData();
				CJTreasureActionHandler.o
				CJDataOfTreasurePropertyList.o;
			}
		}
		
		private function initUi():void
		{
			if(!this._treasuerInited || !this._treasureUserInfoInited || !this._heroTreasuerInited)
			{
				return;
			}
			//UI界面生成
			_layer = new CJTreasureLayer();
			CJLayerManager.o.addModuleLayer(_layer);
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			AssetManagerUtil.o.disposeAssetsByGroup("CJTreasureModuleResource");
			CJLayerManager.o.removeModuleLayer(_layer);
			CJEventDispatcher.o.removeEventListeners(CJEvent.EVENT_TREASURE_DATA_CHANGE);
		}
		
		override protected function _onDestroy(params:Object=null):void
		{
			super._onDestroy(params);
			AssetManagerUtil.o.disposeAssetsByGroup("CJTreasureModuleResource");
		}
	}
}