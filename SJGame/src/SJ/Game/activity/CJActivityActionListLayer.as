package SJ.Game.activity
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.IScrollBar;
	import feathers.controls.ScrollBar;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale3Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale3Textures;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度滑动面板，设置dataprovider刷新
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-5 下午2:21:59  
	 +------------------------------------------------------------------------------
	 */
	public class CJActivityActionListLayer extends CJTurnPage
	{
		public function CJActivityActionListLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.setRect(292 , 106);
			this.itemPerPage = 4;
			
			const listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.paddingTop = -2;
			listLayout.gap = 1;
			this.layout = listLayout;
			
			var layer:CJActivityActionListLayer = this;
			this.itemRendererFactory = function ():IListItemRenderer
			{
				var sxml:XML = AssetManagerUtil.o.getObject("activityaction.sxml") as XML;
				const render:CJActivityActionItem = SFeatherControlUtils.o.genLayoutFromXML(sxml , CJActivityActionItem) as CJActivityActionItem;
				render.owner = layer;
				return render;
			}
			this.interactionMode = Scroller.INTERACTION_MODE_TOUCH;
			this.verticalScrollBarFactory = function():IScrollBar
			{
				var bar:ScrollBar = new ScrollBar();
				bar.direction = ScrollBar.DIRECTION_VERTICAL;
				var sc:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("huoyuedu_gundonghuakuai"),2,1, Scale3Textures.DIRECTION_VERTICAL);
				var barImage:Scale3Image = new Scale3Image(sc);
				barImage.height = 5;
				bar.thumbProperties.defaultSkin = barImage;
				return bar;
			}
			this.paddingRight = -4;
			this.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
				
				
			this.dataProvider = new ListCollection(CJDataManager.o.DataOfActivity.progressDic);
		}
	}
}