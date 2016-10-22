
package SJ.Game.NPCDialog
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 * NPC对话框 
	 * @author Weichao
	 */
	public class CJNPCDialogModule extends CJModulePopupBase
	{	
		private var _dialogLayer:CJNPCDialogLayer = null;
		public function get dialogLayer():CJNPCDialogLayer
		{
			return _dialogLayer;
		}
		public function set dialogLayer(value:CJNPCDialogLayer):void
		{
			_dialogLayer = value;
		}
		
		private var _isShown:Boolean = false;
		private var _isLoading:Boolean = false;
		private var _paramsShown:CJNPCDialogContentObject = null;
		
		public function CJNPCDialogModule()
		{
			super("CJNPCDialogModule");
			_onEnterOnce = false;
		}
		
		override public function getPreloadResource():Array
		{
			return [ConstResource.sResXmlItem_1];
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			_showNPCDialogWithParams(params);
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_hide();
		}
		
		private function _showNPCDialogWithParams(params:Object):void
		{
			var _contentObject:CJNPCDialogContentObject = new CJNPCDialogContentObject();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJNPCDialogModule" , getPreloadResource());
			
			_paramsShown = params as CJNPCDialogContentObject;
			//如果当前没有在显示，则初始化资源
			if (!_isShown && !_isLoading)
			{
				_isLoading = true;
				AssetManagerUtil.o.loadQueue(function(r:Number):void
				{
					if (r == 1)
					{
						var xml_dialog:XML = AssetManagerUtil.o.getObject("npc_dialog.sxml") as XML;
						dialogLayer = SFeatherControlUtils.o.genLayoutFromXML(xml_dialog,CJNPCDialogLayer) as CJNPCDialogLayer;
						CJLayerManager.o.addToModuleLayerFadein(dialogLayer);
						_isShown = true;
						dialogLayer.refreshWithParams(_paramsShown);
						_isLoading = false;
					}
				});
			}
			
			if (_isShown)
			{
				dialogLayer.refreshWithParams(_paramsShown);
			}
		}
		
		private function _hide():void
		{
			AssetManagerUtil.o.disposeAssetsByGroup("CJNPCDialogModule");
			CJLayerManager.o.removeFromLayerFadeout(_dialogLayer);
			_dialogLayer = null;
			_isShown = false;
			_isLoading = false;
		}
	}
}