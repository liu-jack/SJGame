package SJ.Game.duobao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJTextFormatUtil;
	import SJ.Game.data.CJDataOfDuoBao;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class CJDuoBaoTooltip extends SLayer
	{
		private var _treasurePartId:int;
		private var _quad:Quad;
		private var _infoLayer:SLayer;
		private var _bgImage:Scale9Image;
		
		public function CJDuoBaoTooltip()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
		}
		
		public function setTreasurePartId(id:int):void
		{
			_treasurePartId = id;
			_initControls();
		}
		
		private function _initControls():void
		{
			_infoLayer = new SLayer();
			_infoLayer.width = 226;
			_infoLayer.height = 153;
			_infoLayer.x = (SApplicationConfig.o.stageWidth - this._infoLayer.width) / 2;
			_infoLayer.y = (SApplicationConfig.o.stageHeight - this._infoLayer.height) / 2;
			this.addChild(_infoLayer);
			
			var texture:Texture = SApplication.assets.getTexture("common_tankuangdi");
			var bgScaleRange:Rectangle = new Rectangle(19,19,1,1);
			var bgTexture:Scale9Textures = new Scale9Textures(texture, bgScaleRange);
			_bgImage = new Scale9Image(bgTexture);
			_bgImage.width = 226;
			_infoLayer.addChildAt(_bgImage, 0);
			_bgImage.height = _infoLayer.height;
			
			// 关闭按钮
			var btnClose:Button = new Button();
			btnClose.x = 203;
			btnClose.y = -18;
			btnClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new")); 
				
			_infoLayer.addChild(btnClose);
			btnClose.addEventListener(Event.TRIGGERED, _onBtnCloseClick);
			
			
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.addEventListener(starling.events.TouchEvent.TOUCH, onClickQuad);
			
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(_quad, 0);
			
			//icon底图		
			var iconBg:SImage = new SImage(SApplication.assets.getTexture("common_tubiaokuang1"));
			iconBg.x = 159;
			iconBg.y = 8;
			iconBg.scaleX = 1.645;
			iconBg.scaleY = 1.645;
			this._infoLayer.addChild(iconBg);
			
			var _data:CJDataOfDuoBao = CJDataOfDuoBao.o;
			
			var picture:String = _data.getTreasurePartByID(_treasurePartId).picture;
			var icon:SImage = new SImage(SApplication.assets.getTexture(picture));
			icon.x = iconBg.x + 3.5;
			icon.y = iconBg.y + 3.5;
			this._infoLayer.addChild(icon);
			
			// 文字 - 装备名
			var labTemp:Label = new Label();
			labTemp.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xCCB89B);
			labTemp.textRendererProperties.textFormat.color 
				= CJTextFormatUtil._getTextColor(parseInt(_data.getTreasurePartByID(_treasurePartId).color));
			labTemp.text = CJLang(_data.getTreasurePartByID(_treasurePartId).treasurepartname);
			labTemp.x = 10;
			labTemp.y = 5;
			labTemp.width = 155;
			labTemp.height = 12;
			this._infoLayer.addChild(labTemp);
			
			// 分割线
			var textureLine:Texture = SApplication.assets.getTexture("common_fengexian");
			var imgLineNew:SImage = new SImage(textureLine);
			imgLineNew.x = 18;
			imgLineNew.y = 62;
			imgLineNew.width = 138;
			imgLineNew.height = 2;
			this._infoLayer.addChild(imgLineNew);
			
			var desc:Label = new Label();
			desc.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 9, 0xFFFFCC);
			desc.text = CJLang("ITEM_TOOLTIP_DESC") + " " + CJLang(_data.getTreasurePartByID(_treasurePartId).treasurepartdesc);
			desc.x = 10;
			desc.y = 65;
			desc.height = 30;
			desc.width = 205;
			desc.textRendererProperties.wordWrap = true;
			this._infoLayer.addChild(desc);
			
			var btn:Button = new Button();
			btn.x = 87;
			btn.y = 118;
			btn.width = ConstBag.BUTTON_WIDTH_MIN;
			btn.height = ConstBag.BUTTON_HEIGHT_MIN;
			btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			btn.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			btn.defaultLabelProperties.textFormat =  new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE4C200,null,null,null,null,null, TextFormatAlign.CENTER);
			btn.label = CJLang("DUOBAO_TOOLTIP_OK");
			this._infoLayer.addChild(btn);
			btn.addEventListener(starling.events.Event.TRIGGERED, _onBtnCloseClick);
		}
		
		private function _onBtnCloseClick(e:Event):void
		{
			this.removeChildren();
			this.removeFromParent();
		}
		
		private function onClickQuad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this._quad, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
			}
			this.removeFromParent();
		}
	}
}