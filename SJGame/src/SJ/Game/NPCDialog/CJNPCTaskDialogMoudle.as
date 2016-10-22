package SJ.Game.NPCDialog
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	
	public class CJNPCTaskDialogMoudle extends CJModuleSubSystem
	{
		private var _cjlayer:CJNPCTaskDialogLayer;
		
		public function CJNPCTaskDialogMoudle()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			var preoladResoure:Array = getPreloadResource();
			
			//动态加载武将资源，
			var resourceString:String = null;
			var heroConf:Json_hero_battle_propertys = CJDataOfHeroPropertyList.o.getBattlePropertyWithTemplateId(int(params.npcid));
			resourceString = SStringUtils.format("resource_{0}_lod0.xml",heroConf.texturename);
			if (AssetManagerUtil.o.hasObjectInRemoteResource(resourceString))
			{
			preoladResoure.push(resourceString)
			}
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJNPCTaskDialogMoudleResource", preoladResoure);
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				if (r == 1)
				{
					_cjlayer = new CJNPCTaskDialogLayer
					_cjlayer.callBack = params.callback;
					_cjlayer.setTalkContent(params.content)
					_cjlayer.npcId  = params.npcid
					CJLayerManager.o.addModuleLayer(_cjlayer);
				}
			})
		}
		
		override protected function _onExit(params:Object=null):void
		{
			_cjlayer.removeFromParent(true);
			_cjlayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup("CJNPCTaskDialogMoudleResource");
			super._onExit(params);
		}
	}
}