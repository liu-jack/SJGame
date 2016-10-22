package SJ.Game.heroStar
{
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.text.TextField;
	
	public class CJHeroStarHeadItem extends CJItemTurnPageBase
	{
		/** 控件宽度 **/
		private const CONST_WIDTH:int = 66;
		/** 控件高度 **/
		private const CONST_HEIGHT:int = 70;
		/** 武将头像背景X坐标 **/
		private const CONST_HEAD_BG_X:int = 0;
		/** 武将头像背景Y坐标 **/
		private const CONST_HEAD_BG_Y:int = 10;
		/** 武将头像X坐标 **/
		private const CONST_HEAD_X:int = 35;
		/** 武将头像Y坐标 **/
		private const CONST_HEAD_Y:int = 62;
		/** 武将头像中心点X **/
		private const CONST_HEAD_PIVOT_X:int = 47;
		/** 武将头像中心点Y **/
		private const CONST_HEAD_PIVOT_Y:int = 73;

		private var _templateId:String;
		private var _heroId:String;
		
		// 武将头像底框
		private var _imgHeroIconBG:ImageLoader;
		// 武将头像
		private var _imgHeroIcon:ImageLoader;
		// 武将名称
		private var _heroName:TextField;
		
		public function CJHeroStarHeadItem()
		{
			super("CJHeroStarHeadItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = CONST_WIDTH;
			height = CONST_HEIGHT;
			
			
			// 武将头像底框
			_imgHeroIconBG = new ImageLoader();
			_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuang");
			_imgHeroIconBG.x = CONST_HEAD_BG_X;
			_imgHeroIconBG.y = CONST_HEAD_BG_Y;
			addChild(_imgHeroIconBG);
			// 武将头像
			_imgHeroIcon = new ImageLoader();
			_imgHeroIcon.x = CONST_HEAD_X;
			_imgHeroIcon.y = CONST_HEAD_Y;
			_imgHeroIcon.pivotX = CONST_HEAD_PIVOT_X;
			_imgHeroIcon.pivotY = CONST_HEAD_PIVOT_Y;
			addChild(_imgHeroIcon);
			
			// 武将名称
			_heroName = new TextField(15, 60, "");
			_heroName.fontName = ConstTextFormat.FONT_FAMILY_LISHU;
			_heroName.x = 46;
			_heroName.y = 10;
			_heroName.touchable = false;
			_textStroke(_heroName);
			addChild(_heroName);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)//&& _templateId != String(data['templeteid'])) // 判断是否应该刷新
			{
				_heroId = this.data['heroId'];
				_templateId = this.data['templeteid'];
				var tIsSelected:Boolean = data["isSelected"];

				var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(_templateId));
				Assert( heroProperty!=null, "CJHeroStarHeadItem.draw() heroProperty==null" );
				// 武将头像
				_imgHeroIcon.source = SApplication.assets.getTexture(heroProperty.headicon);
				// 武将名字
				_heroName.text = CJLang(heroProperty.name);
				_heroName.color = ConstHero.ConstHeroNameColor[int(heroProperty.quality)];
				
				if (tIsSelected)
				{
					_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuangxuanzhong");
					filter = null;
				}
				else
				{
					_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuang");
					filter = ConstFilter.genBlackFilter();
				}
			}
		}
		
		private function _textStroke(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
		override protected function onSelected():void
		{
		}
	}
}