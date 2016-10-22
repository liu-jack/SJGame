package SJ.Game.horse
{
	import flash.geom.Rectangle;
	
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * @author	Weichao
	 * @modified caihua 13/06/04
	 */
	public class CJHorseLayer extends SLayer
	{
		private const BWIDTH:int = 30;
		private const SWIDTH:int = 28;
		
		private const BHEIGHT:int = 45;
		private const SHEIGHT:int = 43;
		
		private var _buttonUpgrade:Button;
		private var _buttonChangeHorse:Button;
		private var _buttonClose:Button;
		
		private var _horseUpgradeLayer:CJHorseUpgradeLayer = null;
		private var _horseHuanhuaLayer:CJHorseHuanhuaLayer = null;
		
		private var _layerContent:SLayer;
		private var _imageTipBack:ImageLoader;
		private var _imageProgressBack:ImageLoader;

		private var imageBottomBack:SImage;

		private var title:CJPanelTitle;

		public function CJHorseLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawBackground();
			this._drawTab();
			this._addEventListeners();
			this._drawMiddleLayer();
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		private function _drawMiddleLayer():void
		{
			_horseUpgradeLayer = SFeatherControlUtils.o.genLayoutFromXML(AssetManagerUtil.o.getObject("horseUpgradeLayout.sxml") as XML,CJHorseUpgradeLayer) as CJHorseUpgradeLayer;
			_horseHuanhuaLayer = SFeatherControlUtils.o.genLayoutFromXML(AssetManagerUtil.o.getObject("horseHuanhua.sxml") as XML, CJHorseHuanhuaLayer) as CJHorseHuanhuaLayer;
			this.layerContent.addChild(_horseUpgradeLayer);
			this.layerContent.addChild(_horseHuanhuaLayer);
			_horseHuanhuaLayer.visible = false;
			_horseUpgradeLayer.x = -2;
		}
		
		private function _drawTab():void
		{
			_buttonUpgrade.labelFactory = function _genRender():TextFieldTextRenderer
			{
				var _htmltextRender:TextFieldTextRenderer;
				_htmltextRender = new TextFieldTextRenderer();
				_htmltextRender.isHTML = true;
				_htmltextRender.wordWrap = true;
				_htmltextRender.width = 15;
				_htmltextRender.height = 38;
				return _htmltextRender;
			};
			_buttonUpgrade.name = "upgrade";
			_buttonUpgrade.label = CJTaskHtmlUtil.buttonText(CJLang("TAB_TITLE_UPGRADE"));
			_buttonUpgrade.defaultSelectedSkin = new SImage( SApplication.assets.getTexture("zuoqi_xuanxianganniu01"));
			_buttonUpgrade.defaultSkin = new SImage( SApplication.assets.getTexture("zuoqi_xuanxianganniu02"));
			_buttonUpgrade.labelOffsetX = 5;
			_buttonUpgrade.labelOffsetY = 1;
			
			_buttonChangeHorse.labelFactory = function _genRender():TextFieldTextRenderer
			{
				var _htmltextRender:TextFieldTextRenderer;
				_htmltextRender = new TextFieldTextRenderer();
				_htmltextRender.isHTML = true;
				_htmltextRender.wordWrap = true;
				_htmltextRender.width = 15;
				_htmltextRender.height = 38;
				return _htmltextRender;
			};
			_buttonChangeHorse.name = "change";
			_buttonChangeHorse.label = CJTaskHtmlUtil.colorText(CJLang("TAB_TITLE_CHANGEHORSE") , "#FFFFFF");
			_buttonChangeHorse.defaultSelectedSkin = new SImage( SApplication.assets.getTexture("zuoqi_xuanxianganniu01"));
			_buttonChangeHorse.defaultSkin = new SImage( SApplication.assets.getTexture("zuoqi_xuanxianganniu02"));
			_buttonChangeHorse.labelOffsetX = 2;
			_buttonChangeHorse.labelOffsetY = 4;
			
			
			_setInitSeletedButton();
		}
		
		private function _genRender():TextFieldTextRenderer
		{
			var _htmltextRender:TextFieldTextRenderer;
			_htmltextRender = new TextFieldTextRenderer();
			_htmltextRender.isHTML = true;
			_htmltextRender.wordWrap = true;
			_htmltextRender.width = 15;
			_htmltextRender.height = 38;
			return _htmltextRender;
		}
		
		private function _setInitSeletedButton():void
		{
			_buttonUpgrade.isSelected = true;
			_buttonChangeHorse.isSelected = false;
			_resize(_buttonUpgrade);
			_resize(_buttonChangeHorse);
		}
		
		private function _handler(e:Event):void
		{
			if(e.target is Button)
			{
				var btn:Button = e.target as Button;
				if(btn.isSelected)
				{
					return;
				}
				
				this.activeLayer(btn.name);
			}
		}
		
		/**
		 * 激活面板
		 */		
		public function activeLayer(name:String):void
		{
			if(name == "upgrade")
			{
				_buttonUpgrade.label = CJTaskHtmlUtil.buttonText(CJLang("TAB_TITLE_UPGRADE"));
				_buttonUpgrade.labelOffsetX = 5;
				_buttonUpgrade.labelOffsetY = 1;
				_buttonChangeHorse.label = CJTaskHtmlUtil.colorText(CJLang("TAB_TITLE_CHANGEHORSE") , "#FFFFFF");
				_buttonChangeHorse.labelOffsetX = 2;
				_buttonChangeHorse.labelOffsetY = 4;
				_buttonUpgrade.isSelected = true;
				_buttonChangeHorse.isSelected = false;
				_horseUpgradeLayer.visible = true;
				_horseHuanhuaLayer.visible = false;
				title.titleName = CJLang("TITLE_ZUOQIPEIYANG");
				imageBottomBack.height = 68;
				imageBottomBack.y = 252;
			}
			else if(name == "change")
			{
				_buttonUpgrade.label = CJTaskHtmlUtil.colorText(CJLang("TAB_TITLE_UPGRADE") , "#FFFFFF");
				_buttonUpgrade.labelOffsetX = 2;
				_buttonUpgrade.labelOffsetY = 4;
				_buttonUpgrade.isSelected = false;
				_buttonChangeHorse.label = CJTaskHtmlUtil.buttonText(CJLang("TAB_TITLE_CHANGEHORSE"));
				_buttonChangeHorse.labelOffsetX = 5;
				_buttonChangeHorse.labelOffsetY = 1;
				_buttonChangeHorse.isSelected = true;
				_horseUpgradeLayer.visible = false;
				_horseHuanhuaLayer.visible = true;
				title.titleName = CJLang("TITLE_ZUOQIHUANHUA");
				imageBottomBack.height = 30;
				imageBottomBack.y = 290;
			}
			_resize(_buttonUpgrade);
			_resize(_buttonChangeHorse);
			
		}
		
		private function _resize(button:Button):void
		{
			if(button.isSelected)
			{
				button.x = 1;
				button.width = BWIDTH;
				button.height = BHEIGHT;
			}
			else
			{
				button.x = 4;
				button.width = SWIDTH;
				button.height = SHEIGHT;
			}
		}
		
		private function _drawBackground():void
		{
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(15 ,13 , 1, 1)));
			bgWrap.width = SApplicationConfig.o.stageWidth;
			bgWrap.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(bgWrap , 0);
			
			//头部绿条
			var bar:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			bar.width = SApplicationConfig.o.stageWidth;
			this.addChildAt(bar , 0);
			
			//底部的蓝色底
			imageBottomBack = new SImage(Texture.fromColor(10,10,0xFF06100b));
			imageBottomBack.y = 254;
			imageBottomBack.width = SApplicationConfig.o.stageWidth + 20;
			imageBottomBack.height = 66;
			this.addChildAt(imageBottomBack , 0);
			
			//关闭按钮
			_buttonClose = new Button();
			_buttonClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			_buttonClose.downSkin = new SImage( SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			_buttonClose.x = 438;
			this.addChild(_buttonClose);
			
			//标头
			title = new CJPanelTitle(CJLang('TITLE_ZUOQIPEIYANG'));
			this.addChild(title);
			title.x = SApplicationConfig.o.stageWidth - title.width >> 1;
		}
		
		private function _addEventListeners():void
		{
			_buttonClose.addEventListener(starling.events.Event.TRIGGERED,this._onCloseButtonClicked);
			_buttonUpgrade.addEventListener(Event.TRIGGERED , this._handler);
			_buttonChangeHorse.addEventListener(Event.TRIGGERED , this._handler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_buttonClose.removeEventListener(starling.events.Event.TRIGGERED,this._onCloseButtonClicked);
			_buttonUpgrade.removeEventListener(Event.TRIGGERED , this._handler);
			_buttonChangeHorse.removeEventListener(Event.TRIGGERED , this._handler);
			_horseUpgradeLayer.dispose();
			_horseHuanhuaLayer.dispose();
		}
		
		private function _onCloseButtonClicked(e:Event):void
		{
			SApplication.moduleManager.exitModule("CJHorseModule");
		}

		public function get imageTipBack():ImageLoader
		{
			return _imageTipBack;
		}
		
		public function set imageTipBack(value:ImageLoader):void
		{
			_imageTipBack = value;
		}
		
		public function get imageProgressBack():ImageLoader
		{
			return _imageProgressBack;
		}
		
		public function set imageProgressBack(value:ImageLoader):void
		{
			_imageProgressBack = value;
		}
		
		public function get layerContent():SLayer
		{
			return _layerContent;
		}
		
		public function set layerContent(value:SLayer):void
		{
			_layerContent = value;
		}
		
		public function get buttonUpgrade():Button
		{
			return _buttonUpgrade;
		}
		
		public function set buttonUpgrade(value:Button):void
		{
			_buttonUpgrade = value;
		}
		
		public function get buttonChangeHorse():Button
		{
			return _buttonChangeHorse;
		}
		
		public function set buttonChangeHorse(value:Button):void
		{
			_buttonChangeHorse = value;
		}
		
		public function get buttonClose():Button
		{
			return _buttonClose;
		}
		
		public function set buttonClose(value:Button):void
		{
			_buttonClose = value;
		}
	}
}