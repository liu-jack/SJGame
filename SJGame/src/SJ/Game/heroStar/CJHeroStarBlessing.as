package SJ.Game.heroStar
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	/**
	 * 获取XXX点祝福值显示
	 * @author longtao
	 * 
	 */
	public class CJHeroStarBlessing extends SLayer
	{
		// 特效数字前缀
		private static const _CONST_PREFIX_:String = "texiaozi_zhandouli";
		
		// 单个数字宽度
		private static const _CONST_NUMBER_WIDTH_:int = 20;
		
		// 单个数字宽度
		private static const _CONST_IMAGE_SCALE_:Number = 0.6;
		
		/** 数字vector **/
		private var _vecNum:Vector.<SImage> = new Vector.<SImage>;
		
		
		private var _numberGap:Number = -10;
		
		/**
		 * 获取XXX点祝福值显示
		 * @param blessing 祝福值
		 * 
		 */
		public function CJHeroStarBlessing(blessing:String)
		{
			super();
			
			if (blessing == null)
				return;
			
			// 获得祝福值图片
			var img:SImage = new SImage( SApplication.assets.getTexture("texiaozi_huode") );
			img.scaleX = _CONST_IMAGE_SCALE_;
			img.scaleY = _CONST_IMAGE_SCALE_;
			addChild(img);
			
			var offsetX:int = 0;
			// 祝福值数字
			for ( var i:int=0; i<blessing.length; i++ )
			{
				var num:int = int(blessing.charAt(i));
				img = new SImage( SApplication.assets.getTexture(_CONST_PREFIX_+num) );
				img.x = 70 + i*_numberGap + i*_CONST_NUMBER_WIDTH_;
				img.y = 3;
				addChild(img);
				
				offsetX = img.x + _CONST_NUMBER_WIDTH_;
			}
			
			// “点祝福值”图片
			img = new SImage( SApplication.assets.getTexture("texiaozi_zhufuzhi") );
			img.x = offsetX - 30;
			img.scaleX = _CONST_IMAGE_SCALE_;
			img.scaleY = _CONST_IMAGE_SCALE_;
			addChild(img);
		}
	}
}