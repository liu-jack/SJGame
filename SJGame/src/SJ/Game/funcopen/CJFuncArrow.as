package SJ.Game.funcopen
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Game.data.json.Json_function_indicate_setting;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	
	import starling.animation.IAnimatable;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 箭头 - 动画
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-27 上午9:39:13  
	 +------------------------------------------------------------------------------
	 */
	public class CJFuncArrow extends SLayer implements IAnimatable
	{
		private var _scale:Number = 1;
		private var _factor:Number = 0.005;
		private var _dis:Number = 0;
		private var _indicateConfig:Json_function_indicate_setting;
		private var _functionConfig:Json_function_open_setting;

		private var image:SImage;
		private var label:Label;
		
		public function CJFuncArrow(functionConfig:Json_function_open_setting , indicateConfig:Json_function_indicate_setting)
		{
			super();
			this._functionConfig = functionConfig;
			this._indicateConfig = indicateConfig;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var texture:Texture = SApplication.assets.getTexture("zhiyin_jiantou00"+this._indicateConfig.icontype);
			image = new SImage(texture);
			image.width = texture.frame.width;	
			image.height = texture.frame.height;
			image.pivotX = texture.frame.width >> 1;
			image.pivotY = texture.frame.height >> 1;
			
//			1-左 2 - 上 3-右 4-下
			switch(parseInt(this._indicateConfig.icontype))
			{
				case 1:
					pivotX = - texture.width/2;
					pivotY = 0;

					break;
				case 2:
					pivotX = 0;
					pivotY = -texture.height/2;
					break;
				case 3:
					pivotX = texture.width/2;
					pivotY = 0;
					break;
				case 4:
					pivotX = 0;
					pivotY = texture.height/2;

					break;
			}

			this.addChild(image);
			
			label = new Label();
			label.text = CJLang(_indicateConfig.iconname , {"name":CJLang(this._functionConfig.name)});
			label.textRendererFactory = function():ITextRenderer
			{
				var textRender:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRender.wordWrap = true;
				textRender.isHTML = true;
				textRender.textFormat = new TextFormat();
				textRender.textFormat.align = TextFormatAlign.CENTER;
				return textRender;
			}
				
			var linecont:int = 1;
			var labettext:String = label.text.toLowerCase();
			var lastfindindex:int = 0;
			while((lastfindindex = labettext.indexOf("<br/>",lastfindindex + 1)) != -1)
			{
				linecont ++;
			}
//			label.
			label.width = image.width;
//			label.height = texture.height
			label.pivotX = label.width /2;
			label.pivotY = (14 * linecont)/2;
//			label.x += int(_indicateConfig.labeloffsetx);
//			label.y += int(_indicateConfig.labeloffsety);
//			label.y += int(label.height / 2);
			this.addChild(label);
		}
		
		public function advanceTime(time:Number):void
		{
//			_dis+= time;
//			if(_dis < 0.05)
//			{
//				return;
//			}
//			_dis = 0;
			_scale += _factor;
			if(_scale >= 1.05 || _scale <= 0.95)
			{
				_factor =- _factor;
			}
			this.image.scaleX = this.image.scaleY = this._scale;
		}
	}
}