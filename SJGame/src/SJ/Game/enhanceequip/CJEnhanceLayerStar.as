package SJ.Game.enhanceequip
{
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	/**
	 * 以星方式显示等级信息
	 * setter,getter:
	 *     starWidth	单个星图片宽度，初始值：15
	 *     starHeight	单个星图片高度，初始值：17
	 *     xSpace		星图片x坐标间距，初始值：16
	 *     count		行图片数量上限，初始值：10
	 *     level		当前星亮起个数，初始值：0
	 * function：
	 *     initLayer			初始化星图标层，根据数值创建控件
	 *     redrawLayer			重绘星图标层，不重新创建控件，根据level改变星亮起信息
	 *     setLevelAndRedraw	设置星亮起个数并重绘
	 * @author sangxu
	 * 
	 */	
	public class CJEnhanceLayerStar extends SLayer
	{
		
		/** 星星图片 - 亮 */
		private static const IMG_NAME_STAR_BRIGHT:String = "common_xingxing1";
		/** 星星图片 - 暗 */
		private static const IMG_NAME_STAR_DARK:String = "common_xingxing2";
		
		
		/** 默认值 - 星星图片宽高 */
		private static const STARIMG_DEFAULT_WIDTH:int = 15;
		private static const STARIMG_DEFAULT_HEIGTH:int = 17;
		
		/** 默认值 - 星星图片x方向间隔 */
		private static const STARIMG_DEFAULT_XSPACE:int = 16;
		/** 默认值 - 星星图片数量 */
		private static const STARIMG_DEFAULT_COUNT:int = 10;
		
		/** 星星图片宽高 */
		private var _imgWidth:int = STARIMG_DEFAULT_WIDTH;
		private var _imgHeigth:int = STARIMG_DEFAULT_HEIGTH;
		/** 星星图片x方向间隔 */
		private var _imgXSpace:int = STARIMG_DEFAULT_XSPACE;
		/** 星星图片数量 */
		private var _imgCount:int = STARIMG_DEFAULT_COUNT;
		/** 星星亮起个数 */
		private var _level:int = 0;
		/** 是否显示不亮的星星， true为显示 **/
		private var _isShowDarkStar:Boolean = true; // add by longtao
		
		
		public function CJEnhanceLayerStar()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
//			this.initLayer();
		}
		
		/**
		 * 初始layer，创建控件
		 * 
		 */		
		public function initLayer():void
		{
			if (this.count <= 0)
			{
				return;
			}
			var imgTemp:SImage;
			for (var i:uint = 0; i < this.count; i++)
			{
				if (i < this.level)
				{
					imgTemp = new SImage(SApplication.assets.getTexture(IMG_NAME_STAR_BRIGHT));
					imgTemp.visible = true;
				}
				else
				{
					imgTemp = new SImage(SApplication.assets.getTexture(IMG_NAME_STAR_DARK));
					// 是否显示暗星星
					imgTemp.visible = isShowDarkStar; // add by longtao
				}
				imgTemp.width = this.starWidth;
				imgTemp.height = this.starHeight;
				imgTemp.x = i * this.xSpace;
				imgTemp.y = 0;
				this.addChild(imgTemp);
			}
		}
		
		/**
		 * 重新绘制，不重新创建控件，只对现有数据更改星星亮起数量
		 * 
		 */		
		public function redrawLayer():void
		{
			var imgTemp:SImage;
			for(var i:uint = 0; i < this.numChildren; i++)
			{
				imgTemp = this.getChildAt(i) as SImage;
				if (i < this.level)
				{
					imgTemp.texture = SApplication.assets.getTexture(IMG_NAME_STAR_BRIGHT);
					imgTemp.visible = true;
				}
				else
				{
					imgTemp.texture = SApplication.assets.getTexture(IMG_NAME_STAR_DARK);
					// 是否显示暗星星
					imgTemp.visible = isShowDarkStar; // add by longtao
				}
			}
		}
		
		/**
		 * 设置当前星级并刷新layer, 不重新创建控件
		 * @param lv
		 * 
		 */		
		public function setLevelAndRedraw(lv:int):void
		{
			if (lv < 0)
			{
				lv = 0;
			}
			if (lv > this.count)
			{
				lv = this.count;
			}
			this.level = lv;
			this.redrawLayer();
		}
		
		
		/** setter */
		public function set starWidth(value:int):void
		{
			this._imgWidth = value;
		}
		public function set starHeight(value:int):void
		{
			this._imgHeigth = value;
		}
		public function set xSpace(value:int):void
		{
			this._imgXSpace = value;
		}
		public function set count(value:int):void
		{
			this._imgCount = value;
		}
		public function set level(value:int):void
		{
//			if (value > this.count)
//			{
//				value = this.count;
//			}
			this._level = value;
		} 
		
		/** getter */
		public function get starWidth():int
		{
			return this._imgWidth;
		}
		public function get starHeight():int
		{
			return this._imgHeigth;
		}
		public function get xSpace():int
		{
			return this._imgXSpace;
		}
		public function get count():int
		{
			return this._imgCount;
		}
		public function get level():int
		{
			return this._level;
		}
		/** 是否显示不亮的星星， true为显示 **/
		public function get isShowDarkStar():Boolean
		{
			return _isShowDarkStar;
		}
		/**
		 * @private
		 */
		public function set isShowDarkStar(value:Boolean):void
		{
			_isShowDarkStar = value;
		}
	}
}