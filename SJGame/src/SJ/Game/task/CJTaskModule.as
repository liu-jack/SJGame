package SJ.Game.task
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.config.CJDataOfTaskPropertyList;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 +------------------------------------------------------------------------------
	 * 任务模块入口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-24 下午9:06:31  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskModule extends CJModulePopupBase
	{
		private static const _layoutXML:String = "tasklayout.sxml";
		private var loading:CJLoadingLayer;
		private var _taskInited:Boolean = false;
		private var _heroListInited:Boolean = false;

		private var layer:CJTaskLayer;
		
		public function CJTaskModule()
		{
			super("CJTaskModule");
		}
		
		override protected function _onInit(params:Object = null):void
		{
			super._onInit(params);
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//加载数据
			this.initUi();
			CJTaskManager.o;
			CJDataOfTaskPropertyList.o;
		}
		
		private function initUi():void
		{
			//UI界面生成
			var sxml:XML = AssetManagerUtil.o.getObject(_layoutXML) as XML;
			layer = SFeatherControlUtils.o.genLayoutFromXML(sxml , CJTaskLayer) as CJTaskLayer;
			CJLayerManager.o.addToModuleLayerFadein(layer);
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeFromLayerFadeout(layer);
			layer = null;
		}
		
		override protected function _onDestroy(params:Object=null):void
		{
			super._onEnter(params);
		}
	}
}