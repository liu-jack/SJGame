package SJ.Game.funcopen
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfFuncIndicatePropertyList;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能点开启
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-20 下午15:04:13  
	 * @comment 
	 * 不同的功能的开启根据实际的操作处理，发事件 自动进入下一步
	 * CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP)
	 * 如果有失败处理，可发回溯指引事件
	 * CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_PRE_STEP)
	 * 
	 * 基本的流程:
	 * 1.策划配置功能点指引配置 和功能点开启配置
	 * 2.程序根据文档或者截图，看看自己有几步指引，在的模块中添加处理逻辑
	 * 主要的处理逻辑可能是
	 * A.判断是否在指引流程中
	 * CJDataManager.o.DataOfFuncList.isIndicating
	 * B.完成指引发事件
	 * 下一步事件 ： CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP)
	 * 回溯事件 ： CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_PRE_STEP)
	 +------------------------------------------------------------------------------
	 */
	public class CJFunctionOpenModule extends CJModuleSubSystem
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJFunctionOpenModuleResource";
		/*模块名*/
		private static const _MOUDLE_NAME:String = "CJFunctionOpenModule";
		private var _mainLayer:CJFuncOpenLayer = null;
		private var loading:CJLoadingLayer;
		/*开启功能点*/
		private var _functionId:int = -1;
		
		public function CJFunctionOpenModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
			CJDataManager.o.DataOfFuncList.addEventListener(DataEvent.DataLoadedFromRemote , this._initUi);
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		/**
		 *进入模块，确定显示的layer 
		 * @param params
		 */
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			if(params != null && int(params))
			{
				_functionId = int(params);
			}
			else
			{
				_functionId = -1;
			}
			CJLoadingLayer.show();
			//设置进入指引状态
			CJDataManager.o.DataOfFuncList.isIndicating = 1;
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_ENTER, false , {"step":0});
			this._loadResource();
			//退出武将训练模块
			if(CJDataManager.o.DataOfFuncList.currentIndicatingModule.indexOf("CJHeroTrainModule") == -1)
			{
				SApplication.moduleManager.exitModule("CJHeroTrainModule");
			}
		}
		
		/**
		 * 退出模块，销毁layer与资源数据
		 * @param params
		 */
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeModuleLayer(_mainLayer);
			_mainLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			CJEventDispatcher.o.removeEventListeners("get_recommend_succ");
			//清除指引状态
			CJDataManager.o.DataOfFuncList.isIndicating = 0;
			//清除存储开启点
			CJDataManager.o.DataOfFuncList.needOpenFunctionAfterReturnToTown = -1;
			CJDataManager.o.DataOfFuncList.currentIndicatingModule = "";
			
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_EXIT);
		}
		
		private function _loadResource():void
		{
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
			AssetManagerUtil.o.loadQueue(_loadingHandler);
		}
		
		private function _loadingHandler(progress:Number):void
		{
			CJLoadingLayer.loadingprogress = progress;
			if(progress == 1)
			{
				CJLoadingLayer.close();
				
				CJDataOfFuncPropertyList.o;
				CJDataOfFuncIndicatePropertyList.o;
				
				this._initUi();
			}
		}
		
		private function _initUi():void
		{
			//如果没有传入的开启id
			if(_functionId == -1)
			{
				var currentLevel:int = int(CJDataManager.o.DataOfHeroList.getMainHero().level);
				_functionId = CJDataManager.o.DataOfFuncList.getNextUnOpenFunctionId(currentLevel);
			}
			Logger.log("open function in current level" , "functionid : " + _functionId);
			_mainLayer = new CJFuncOpenLayer(_functionId);
			//镂空区域需要能点击.....
			CJLayerManager.o.tipsLayer.addChild(this._mainLayer);
		}
		
		public static function get RESOURCE_TYPE():String
		{
			return _RESOURCE_TYPE;
		}
		
		public static function get MOUDLE_NAME():String
		{
			return _MOUDLE_NAME;
		}
	}
}