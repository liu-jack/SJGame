package SJ.Game.fuben
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJTextFormatUtil;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import starling.core.Starling;
	
	/**
	 * 通关宝箱item
	 * @author yongjun
	 * 
	 */
	public class CJGuankaBoxItem extends SLayer
	{
		private var _logo:SImage;
		private var _item:CJBagItem;
		private var _selectFrame:SImage;
		private var _itemName:Label;
		private var __fadeOut:STween;
		private var __fadeIn:STween;
		private var imgBackBG:ImageLoader;
		public function CJGuankaBoxItem()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			var bgimg:SImage = new SImage(SApplication.assets.getTexture("fuben_tongguan_pai"));
			bgimg.scaleX = 1.4;
			bgimg.scaleY = 1.5;
			this.addChild(bgimg);
			
			_selectFrame= new SImage(SApplication.assets.getTexture("tongguan_pai01"))
			_selectFrame.scaleX =  1.4;
			_selectFrame.scaleY  = 1.5
			_selectFrame.visible = false;
			this.addChild(_selectFrame);
			
			imgBackBG = new ImageLoader();
			imgBackBG.source = SApplication.assets.getTexture("jiuguan_dianjichouqu");
			imgBackBG.x = 35;
			imgBackBG.y = 15;
			this.addChild(imgBackBG);
			
			__fadeOut= new STween(imgBackBG, 1);
			__fadeOut.fadeTo(0.3);
			__fadeOut.onComplete = __onFadeOut;
			__fadeOut.loop = 2;
			Starling.juggler.add(__fadeOut);
			
			__fadeIn= new STween(imgBackBG, 1);
			__fadeIn.fadeTo(1.0);
			__fadeIn.onComplete = __onFadeIn;
			__fadeIn.loop = 2;
			
			function __onFadeOut():void
			{
				Starling.juggler.remove(__fadeOut);
				Starling.juggler.add(__fadeIn);
			}
			
			function __onFadeIn():void
			{
				Starling.juggler.remove(__fadeIn);
				Starling.juggler.add(__fadeOut);
			}
			_item = new CJBagItem()
			_item.x = 20;
			_item.y = 33;
			_itemName = new Label;
			_itemName.width = 60
			_itemName.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			_itemName.x = 16;
			_itemName.y = 94;
			this.addChild(_itemName)
		}
		
		public function set itemInfo(info:Object):void
		{
			if(!info.hasOwnProperty("0"))return;
			var tmplData:Json_item_setting = CJDataOfItemProperty.o.getTemplate(int(info[0]));
			if(!tmplData)return;
			_item.setBagGoodsItemByTmplId(tmplData.id);
			this.addChild(_item);
			_itemName.textRendererFactory = textRender.htmlTextRender;
			var tf:TextFormat = CJTextFormatUtil.getTextFormatByItemQuality(tmplData.quality , TextFormatAlign.CENTER);
			_itemName.textRendererProperties.textFormat = tf;
			_itemName.text = CJLang(tmplData.itemname)+"*"+info[1];
			_selectFrame.visible = true;
		}
		public function stopJuggler():void
		{
			Starling.juggler.remove(__fadeIn);
			Starling.juggler.remove(__fadeOut);
			this.removeChild(imgBackBG);
		}
		override public function dispose():void
		{
			
		}
	}
}