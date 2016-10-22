package SJ.Game.horse
{
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	/**
	 +------------------------------------------------------------------------------
	 * 最高级的界面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-7-30 下午5:08:03  
	 +------------------------------------------------------------------------------
	 */
	public class CJHorsePropertyMax extends SLayer
	{
		private var _wrap:Scale9Image;
		private var _flower:Scale9Image;
		private var _bg:Scale9Image;
		private var _maxText:ImageLoader;
		
		public function CJHorsePropertyMax()
		{
			super();
		}
		
		protected override function initialize():void
		{
			
			var titleBg:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("zuoqi_shuxingbiaotoudi"),36,1));
			titleBg.x = 0;
			titleBg.y = 0;
			titleBg.width = 78;
			this.addChildAt(titleBg, 0);
			
			//下级属性
			var label:Label = new Label();
			label.x = 10;
			label.text = CJLang("HORSE_NEXTBONUS");
			var tf:TextFormat = new TextFormat();
			tf.color = 0xfff54d;
			label.textRendererProperties.textFormat = tf;
			this.addChild(label);
			
			//整个框设置背景
			var image9Back:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zuoqi_shuxingwenzidi"), new Rectangle(7,7 , 1,1)));
			image9Back.x = 0;
			image9Back.y = 24;
			image9Back.width = 76;
			image9Back.height = 112;
			this.addChildAt(image9Back , 0);
			
			_flower = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tanchuagnzhuangshi") , new Rectangle(8,8 , 1,1)));
			_flower.y = 24;
			_flower.width = 76;
			_flower.height = 112;
			this.addChild(_flower);
			
			_maxText = new ImageLoader();
			_maxText.x = 25;
			_maxText.y = 36;
			_maxText.source = SApplication.assets.getTexture("zuoqi_wenzi");
			this.addChild(_maxText);
		}
	}
}