package SJ.Game.equipment
{
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstHero;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.formation.CJTurnPage;
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
	
	/**
	 * 装备洗练武将头像
	 * @author zhengzheng
	 * 
	 */	
	public class CJItemRecastHeroHeadItem extends CJItemTurnPageBase
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
		private const CONST_HEAD_X:int = 35;//33
		/** 武将头像Y坐标 **/
		private const CONST_HEAD_Y:int = 62;//51
		/** 武将头像中心点X **/
		private const CONST_HEAD_PIVOT_X:int = 47;//38
		/** 武将头像中心点Y **/
		private const CONST_HEAD_PIVOT_Y:int = 73;//49
		

		private var _templateId:String;
		private var _heroId:String;
		
		// 武将头像底框
		private var _imgHeroIconBG:ImageLoader;
		// 武将头像
		private var _imgHeroIcon:ImageLoader;
		// 武将名称
		private var _heroName:TextField;
		
		private var _dataRole:CJDataOfRole;
		
		public function CJItemRecastHeroHeadItem()
		{
			super("CJItemRecastHeroHeadItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._initData();
			this._initControls();
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			this._dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
		}
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
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
			_heroName = new TextField(15, 75, "");
			_heroName.x = 46;
			_heroName.y = 5;
			_textStroke(_heroName);
			addChild(_heroName);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid) // 判断是否应该刷新
			{
				_heroId = this.data["heroid"];
				_templateId = this.data["templateid"];
				var tIsSelected:Boolean = this.data["isSelected"];
				
				var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(_templateId));
				Assert( heroProperty!=null, "CJItemRecastHeroHeadItem--> heroProperty==null" );
				// 武将头像
				_imgHeroIcon.source = SApplication.assets.getTexture(heroProperty.headicon);
				// 武将名字
				if (this.data.isRole)
				{
					_heroName.text = this._dataRole.name;
				}
				else
				{
					_heroName.text = CJLang(heroProperty.name);
				}
				_heroName.color = ConstHero.ConstHeroNameColor[int(heroProperty.quality)];
				
				if (tIsSelected)
				{
					_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuangxuanzhong");
					if(this.filter != null)
					{
						this.filter.dispose();
					}
					this.filter = null;
				}
				else
				{
					_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuang");
					this.filter = ConstFilter.genBlackFilter();
				}
			}
		}
		
		/**
		 * 点击事件
		 * @param selectedIndex
		 * @param item
		 * 
		 */		
		override protected function onSelected():void
		{
			var recastLayer:CJItemRecastLayer = this.owner.parent.parent.parent as CJItemRecastLayer;
			recastLayer.onSelectHero(this.data.heroid);
			// 将所有的设置为非选中状态
			var arr:Array = (this.owner as CJTurnPage).getAllItemDatas();
			for (var i:int; i<arr.length; ++i)
			{
				arr[i].isSelected = false;
				(this.owner as CJTurnPage).updateItemAt(arr[i].index);
			}
			
			// 将点中的设置为选中
			this.data.isSelected = true;
			(this.owner as CJTurnPage).updateItemAt(this.data.index);
		}
		
		
		private function _textStroke(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
		public function get templateId():String
		{
			return _templateId;
		}
		
		public function get heroId():String
		{
			return _heroId;
		}
		
		override public function set isSelected(value:Boolean):void
		{
		}
	}
}