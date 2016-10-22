package SJ.Game.strategy
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstStrategy;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.enhanceequip.CJEnhanceLayerStar;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;

	/**
	 * 攻略显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJStrategyItem extends CJItemTurnPageBase
	{
		/**背景图*/
		private var _bg:Scale9Image
		/**当前攻略描述*/
		private var _description:Label;
		/** 当前攻略的星级 **/
		protected var _strategyStarPanel:CJEnhanceLayerStar;
		/**进入按钮*/
		private var _btnEnter:Button;
		/**未开启说明*/
		private var _labNotOpen:Label;
		/**主角等级*/
		private var _roleLevel:int;
		
		public function CJStrategyItem()
		{
			super("CJStrategyItem");
		}
		override protected function initialize():void
		{
			_initData();
			_drawContent();
			_addListener();
		}
		/**
		 * 添加按钮监听
		 * 
		 */		
		private function _addListener():void
		{
			this._btnEnter.addEventListener(Event.TRIGGERED , this._btnEntertTriggered);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			this.width = 348;
			this.height = 35;
			
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("huodong_dikuang01"),new Rectangle(5 , 25 , 1 , 1)));
			_bg.width = 348;
			_bg.height = 35;
			
			_description = new Label();
			_description.x = 12;
			_description.y = 9;
			_description.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xF0D67F);
			
			_strategyStarPanel = new CJEnhanceLayerStar();
			_strategyStarPanel.count = ConstStrategy.STRATEGY_MAX_STAR_LEVEL;
			_strategyStarPanel.initLayer();
			_strategyStarPanel.x = 140;
			_strategyStarPanel.y = 8;
			_strategyStarPanel.width = 80;
			_strategyStarPanel.height = 15;
			_strategyStarPanel.visible = false;
			
			_btnEnter = new Button();
			_btnEnter.x = 265;
			_btnEnter.y = 3;
			_btnEnter.width = 70;
			_btnEnter.height = 28;
			_btnEnter.defaultLabelProperties.textFormat = new TextFormat( "黑体", 12, 0xF9FBED);
			_btnEnter.label = CJLang("STRATEGY_GOTO");
			
			
			_labNotOpen = new Label();
			_labNotOpen.x = 265;
			_labNotOpen.y = 9;
			_labNotOpen.width = 70;
			_labNotOpen.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0x383632,null,null,null,null,null,TextFormatAlign.CENTER);
			_labNotOpen.text = CJLang("STRATEGY_NOT_OPEN");
			_labNotOpen.visible = false;
			
			_roleLevel = int(CJDataManager.o.DataOfHeroList.getMainHero().level);
		}
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			addChild(_bg);
			addChild(_description);
			addChild(_strategyStarPanel);
			_btnEnter.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnEnter.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			addChild(_btnEnter);
			addChild(_labNotOpen);
			
			//分割线
			var imgLine:Scale3Image = ConstNPCDialog.genS3ImageWithTextureNameAndRegion("haoyouxitong_xian", 0.5, 1);
			imgLine.x = 10;
			imgLine.y = 33;
			imgLine.width = 290;
			imgLine.height = 1;
			addChild(imgLine);
		}
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				_description.text = CJLang(String(data.description));
				_strategyStarPanel.level = data.star;
				_strategyStarPanel.redrawLayer();
				_strategyStarPanel.visible = true;
				
				var btnNeedOpenLevel:int;
				if (data.modulename == "CJEnhanceModule")
				{
					btnNeedOpenLevel = CJDataOfFuncPropertyList.o.getPropertyByModulename(data.modulename + "_" + data.index).level;
				}
				else
				{
					btnNeedOpenLevel = CJDataOfFuncPropertyList.o.getPropertyByModulename(data.modulename).level;
				}
				_btnEnter.visible = _roleLevel < btnNeedOpenLevel ? false : true;
				_labNotOpen.visible = _roleLevel < btnNeedOpenLevel ? true : false;
			}
		}
		
		/**
		 * 触发进入事件
		 * @param e Event
		 * 
		 */		
		private function _btnEntertTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			if (data && data.hasOwnProperty("modulename") && data.hasOwnProperty("index"))
			{
				SApplication.moduleManager.exitModule("CJStrategyModule");
				SApplication.moduleManager.enterModule(data.modulename, {"pagetype":data.index});
			}
		}
	}
}