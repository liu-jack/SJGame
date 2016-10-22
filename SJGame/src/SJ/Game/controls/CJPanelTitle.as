package SJ.Game.controls
{
	import SJ.Common.Constants.ConstTextFormat;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	
	import flash.filters.GlowFilter;
	
	import starling.textures.Texture;
	
	public class CJPanelTitle extends SLayer
	{
		private var _titleName:String

		private var titleLabel:Label;
		
		private var _fullScreen:int = 0;
		
		public function CJPanelTitle(titleName:String = "")
		{
			super();
			_titleName = titleName;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var bgtexture:Texture = SApplication.assets.getTexture("common_tounew")
			var bg:SImage = new SImage(bgtexture);
			
			this.width = bgtexture.width;
			this.height = bgtexture.height;
			
			this.addChild(bg);
			titleLabel = new Label;
			titleLabel.textRendererFactory = function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx();
				_htmltextRender.textFormat = ConstTextFormat.titleformat;
				_htmltextRender.nativeFilters = [new GlowFilter(0x000000,1.0,2.0,2.0,10,6)];
				return _htmltextRender;
			}
			
			this.addChild(titleLabel);
			this.touchable = false;
		}
		
		override protected function draw():void
		{
			super.draw();
			if(_titleName == null)
			{
				return;
			}
			//计算字数N 个字 一个字宽约18
			var words:int = _titleName.split("").length;
			var wordsLength:Number = words* 18;
			titleLabel.text = _titleName;
			titleLabel.x = (this.width - wordsLength) >> 1;
			titleLabel.y = -3;
			
			if(fullScreen)
			{
				this.x = SApplicationConfig.o.stageWidth - this.width >> 1;
			}
		}

		public function get titleName():String
		{
			return _titleName;
		}

		public function set titleName(value:String):void
		{
			_titleName = value;
			this.invalidate();
		}

		public function get fullScreen():int
		{
			return _fullScreen;
		}

		public function set fullScreen(value:int):void
		{
			_fullScreen = value;
		}
	}
}