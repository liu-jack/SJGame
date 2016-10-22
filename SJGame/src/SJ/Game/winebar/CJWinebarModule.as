package SJ.Game.winebar
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfMainSceneProperty;
	import SJ.Game.data.config.CJDataOfWinebarProperty;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.core.Starling;
	
	/**
	 * 酒馆模块
	 * @author longtao
	 * 
	 */
	public class CJWinebarModule extends CJModulePopupBase
	{
		private var _winbarLayer:CJWinebarLayer;
		
		public function CJWinebarModule()
		{
			super("CJWinebarModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["winebarLayout.sxml",
				"resourceui_card_common.xml",
//				"resourceui_card_city"+ params +".xml", 
				ConstResource.sResSkillSetting,
				ConstResource.sResJsonWinebar, 
				ConstResource.sResJsonWinebarRefresh];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJWinebarModuleResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("winebarLayout.sxml") as XML;
					_winbarLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJWinebarLayer) as CJWinebarLayer;
					_winbarLayer.winebarid = __getSuitableWinebarID();
					
					CJLayerManager.o.addToModuleLayerFadein(_winbarLayer);
					Starling.juggler.add(_winbarLayer);
				}
			});
			
			// 获取该玩家最高等级的酒馆id
			function __getSuitableWinebarID():String
			{
				// 玩家等级
				var level:uint = uint(CJDataManager.o.DataOfHeroList.getMainHero().level);
				// 临时记录开启城镇id
				var cityid:String = "100";
				// 临时记录开启最大等级
				var citylevel:uint = 0;
				// 城镇信息
				var arr:Array = CJDataOfMainSceneProperty.o.getOpenedIdByLevel(level);
				for (var i:uint; i<arr.length; i++)
				{
					var obj:Object = CJDataOfMainSceneProperty.o.getPropertyById(int(arr[i]));
					if (null != obj && int(obj.istown)) // 是城镇 判断是否有对应酒馆
					{
						// 判断是否有该酒馆
						if ( null == CJDataOfWinebarProperty.o.getData(obj.id) )
							continue;
						
						if (citylevel < int(obj.openlevel))
						{
							cityid = obj.id;
							citylevel = obj.openlevel;
						}
					}
				}
				return cityid;
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
//			_winbarLayer.removeFromParent(true);
			
			Starling.juggler.remove(_winbarLayer);
			
			CJLayerManager.o.removeFromLayerFadeout(_winbarLayer);
			_winbarLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup("CJWinebarModuleResource");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
	}
}