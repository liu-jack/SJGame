package SJ.Game.funcopen
{
	import SJ.Common.global.textRender;
	import SJ.Game.data.json.Json_function_indicate_setting;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollText;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 开启描述面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-26 下午18:51:17  
	 +------------------------------------------------------------------------------
	 */
	public class CJFuncDescPanel extends SLayer
	{
		private var _config:Json_function_open_setting;
		private var _indicateConfig:Json_function_indicate_setting;
		
		public function CJFuncDescPanel(config:Json_function_open_setting , indicateConfig:Json_function_indicate_setting)
		{
			super();
			this._config = config;
			this._indicateConfig = indicateConfig;
		}
		
		override protected function initialize():void
		{
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			this._drawBg();
			this._drawTitle();
			this._drawDesc();
			this._drawFunctionIcon();
			this._drawConfirm();
		}
		
		private function _drawConfirm():void
		{
			var button:Button = new Button();
			button.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			button.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			button.addEventListener(Event.TRIGGERED , function ():void
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			});
			button.name = "FUNCOPEN_ACCEPT_FUNCTION";
			button.x = 50;
			button.y = 80;
			button.width = button.defaultSkin.width;
			button.height = button.defaultSkin.height;
			button.label = CJTaskHtmlUtil.buttonText(CJLang("COMMON_TRUE"));
			button.labelFactory = textRender.htmlTextRender;
			this.addChild(button);
		}
		
		private function _drawFunctionIcon():void
		{
			var functionIcon:SImage = new SImage(SApplication.assets.getTexture(_config.icon));
			functionIcon.x = 5;
			functionIcon.y = 30;
			this.addChild(functionIcon);
		}
		
		private function _drawDesc():void
		{
			var text:ScrollText = new ScrollText();
			text.width = 126;
			text.height = 50;
			text.x = 50;
			text.y = 28;
			text.textFormat = new TextFormat(null , 12 , 0xffffff);
			text.isEnabled = false;
			text.text = CJLang(_config.desc);
			this.addChild(text);
		}
		
		private function _drawTitle():void
		{
			var label:CJTaskLabel = new CJTaskLabel();
			label.fontSize = 16;
			label.fontColor = 0xF6AE0C;
			label.textRendererFactory = textRender.htmlTextRender;
			label.width = 90;
			label.height = 50;
			label.text = CJLang("FUNCTION_OPEN_TITLE");
			label.x = (this._indicateConfig.maskwidth - label.width) >> 1;
			label.y = 3;
			this.addChild(label);
		}
		
		private function _drawBg():void
		{
			var quad:Quad = new Quad(SApplicationConfig.o.stageWidth , SApplicationConfig.o.stageHeight);
			quad.x = -quad.width/2 + 100;
			quad.y = -quad.height/2 + 60;
			quad.alpha = 0;
			this.addChild(quad);
			
			//设置背景
			var image9Back:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_erjitanchuang"), new Rectangle(15, 15, 1, 1)));
			image9Back.width = int(this._indicateConfig.maskwidth) + 4;
			image9Back.height = int(this._indicateConfig.maskheight) + 4;
			this.addChild(image9Back);
			
			//花边
			var wrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangwenzidi"), new Rectangle(10, 11, 1, 1)));
			wrap.y = 23;
			wrap.x = 6;
			wrap.width = int(this._indicateConfig.maskwidth) - 8;
			wrap.height = int(this._indicateConfig.maskheight) - 26;
			this.addChild(wrap);
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeChildren(0 , -1 ,true);
		}
	}
}