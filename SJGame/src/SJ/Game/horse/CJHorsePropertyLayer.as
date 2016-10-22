package SJ.Game.horse
{
	import SJ.Common.global.textRender;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author	Weichao 培养界面里面坐骑属性的小界面
	 * 2013-5-8
	 */
	public class CJHorsePropertyLayer extends SLayer
	{
		private var _labelTitle:Label;
		private var _labelJin:Label;
		private var _labelMu:Label;
		private var _labelShui:Label;
		private var _labelHuo:Label;
		private var _labelTu:Label;
		private var _labelJinBonus:Label;
		private var _labelMuBonus:Label;
		private var _labelShuiBonus:Label;
		private var _labelHuoBonus:Label;
		private var _labelTuBonus:Label;
		
		public function CJHorsePropertyLayer()
		{
			super();
		}

		protected override function initialize():void
		{
			super.initialize();
			
			var titleBg:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("zuoqi_shuxingbiaotoudi"),36,1));
			titleBg.x = 0;
			titleBg.y = 0;
			titleBg.width = 78;
			this.addChildAt(titleBg, 0);
			
			//整个框设置背景
			var image9Back:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zuoqi_shuxingwenzidi"), new Rectangle(7,7 , 1,1)));
			image9Back.x = 0;
			image9Back.y = 24;
			image9Back.width = 76;
			image9Back.height = 112;
			this.addChildAt(image9Back , 0);
			
			this._labelTitle.textRendererProperties.textFormat = new TextFormat("Arial", null, 0xfff54d, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labelJin.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labelMu.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labelShui.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labelHuo.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labelTu.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labelJinBonus.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.LEFT);
			this._labelMuBonus.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.LEFT);
			this._labelShuiBonus.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.LEFT);
			this._labelHuoBonus.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.LEFT);
			this._labelTuBonus.textRendererProperties.textFormat = new TextFormat("Arial", 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.LEFT);
			
			this._labelTitle.textRendererProperties.wordWrap = true;
			
			var arr_labels:Array = new Array();
			arr_labels.push(_labelTitle, _labelJin, _labelMu, _labelShui, _labelHuo, _labelTu, _labelJinBonus, _labelMuBonus, _labelShuiBonus, _labelHuoBonus, _labelTuBonus);
			for each (var label_temp:Label in arr_labels)
			{
				label_temp.textRendererFactory = textRender.glowTextRender;
			}
		}
		
		public function refreshWithParams(params:Object):void
		{
			this._labelJin.text = CJLang("HORSE_PROPERTYBONUS_JIN");
			this._labelMu.text = CJLang("HORSE_PROPERTYBONUS_MU");
			this._labelShui.text = CJLang("HORSE_PROPERTYBONUS_SHUI");
			this._labelHuo.text = CJLang("HORSE_PROPERTYBONUS_HUO");
			this._labelTu.text = CJLang("HORSE_PROPERTYBONUS_TU");
			this._labelJinBonus.text = String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + params["goldbonus"]}));
			this._labelMuBonus.text = String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + params["woodbonus"]}));
			this._labelShuiBonus.text = String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + params["waterbonus"]}));
			this._labelHuoBonus.text = String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + params["firebonus"]}));
			this._labelTuBonus.text = String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + params["eartchbonus"]}));
		}
		
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
		}
		
		public function get labelJin():Label
		{
			return _labelJin;
		}
		
		public function set labelJin(value:Label):void
		{
			_labelJin = value;
		}
		
		public function get labelMu():Label
		{
			return _labelMu;
		}
		
		public function set labelMu(value:Label):void
		{
			_labelMu = value;
		}
		
		public function get labelShui():Label
		{
			return _labelShui;
		}
		
		public function set labelShui(value:Label):void
		{
			_labelShui = value;
		}
		
		public function get labelHuo():Label
		{
			return _labelHuo;
		}
		
		public function set labelHuo(value:Label):void
		{
			_labelHuo = value;
		}
		
		public function get labelTu():Label
		{
			return _labelTu;
		}
		
		public function set labelTu(value:Label):void
		{
			_labelTu = value;
		}
		
		public function get labelJinBonus():Label
		{
			return _labelJinBonus;
		}
		
		public function set labelJinBonus(value:Label):void
		{
			_labelJinBonus = value;
		}
		
		public function get labelMuBonus():Label
		{
			return _labelMuBonus;
		}
		
		public function set labelMuBonus(value:Label):void
		{
			_labelMuBonus = value;
		}
		
		public function get labelShuiBonus():Label
		{
			return _labelShuiBonus;
		}
		
		public function set labelShuiBonus(value:Label):void
		{
			_labelShuiBonus = value;
		}
		
		public function get labelHuoBonus():Label
		{
			return _labelHuoBonus;
		}
		
		public function set labelHuoBonus(value:Label):void
		{
			_labelHuoBonus = value;
		}
		
		public function get labelTuBonus():Label
		{
			return _labelTuBonus;
		}
		
		public function set labelTuBonus(value:Label):void
		{
			_labelTuBonus = value;
		}
	}
}