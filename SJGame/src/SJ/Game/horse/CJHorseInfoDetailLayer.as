package SJ.Game.horse
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.data.json.Json_horsebaseinfo;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	/**
	 @author	Weichao 进阶界面每一个坐骑的小界面
	 2013-5-17
	 */
	
	public class CJHorseInfoDetailLayer extends SLayer
	{
		private var _layerMain:SLayer;
		private var _labelHorseName:Label;
		private var _imageHorse:ImageLoader;
		private var _labelRank:Label;
		private var _layerBonus:SLayer;
		private var _labelBonus0:Label;
		private var _labelBonus1:Label;
		private var _labelBonus2:Label;
		private var _labelBonus3:Label;
		private var _labelBonus4:Label;
		private var _labelBonus5:Label;
		
		public function CJHorseInfoDetailLayer()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			
			this._drawContent();
			
			var arr_labels:Array = new Array(this.labelBonus0, this.labelBonus1, this.labelBonus2, this.labelBonus3, this.labelBonus4);
			for each (var label_temp:Label in arr_labels)
			{
				label_temp.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xd2ffb1, null, null, null, null, null, TextFormatAlign.CENTER);
			}
			this.labelRank.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFF54D, null, null, null, null, null, TextFormatAlign.CENTER);
			this.labelHorseName.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 17, 0xFFF54D, null, null, null, null, null, TextFormatAlign.CENTER);
			this.labelHorseName.textRendererFactory = textRender.htmlTextRender;
		}
		
		private function _drawContent():void
		{
			//整个框设置背景
			var image9Back:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew"), new Rectangle(1 ,1 , 1, 1)));
			image9Back.width = 181;
			image9Back.height = 238;
			this.addChildAt(image9Back , 0);
			
			//装饰
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(15 ,13 , 1, 1)));
			bgWrap.width = 181;
			bgWrap.height = 238;
			bgWrap.x = 0;
			bgWrap.y = 2;
			this.layerMain.addChildAt(bgWrap , 0);
			
			//坐骑的背景
			var bgYuanquan:SImage = new SImage(SApplication.assets.getTexture("zuoqi_dibuyuanquan"));
			bgYuanquan.width = 160;
			bgYuanquan.height = 160;
			bgYuanquan.x = 12;
			bgYuanquan.y = 19;
			this.layerMain.addChildAt(bgYuanquan , 1);
			
			//坐骑
			_imageHorse = new ImageLoader();
			this.layerMain.addChildAt(_imageHorse , 2);
			_imageHorse.scaleX = _imageHorse.scaleY = 1.5
			this._imageHorse.x = - 10;
			this._imageHorse.y = 20;
		}
		
		public function refreshWithParams(rideSkillLevel:int = 0):void
		{
			var rank:int = CJHorseUtil.getRank(rideSkillLevel);
			var currentRankConfig:Object = CJHorseUtil.getBaseConfigByRank(rank);
			var horseid:int = currentRankConfig["horseid"];
			var horseBaseInfo:Json_horsebaseinfo = CJHorseUtil.getHorseBaseInfoWithHorseID(horseid);
			var attributeBonus:Object = CJHorseUtil.getAttributeBonusWithHorseParams(horseid, rideSkillLevel);
			this.labelHorseName.text = CJLang(horseBaseInfo.name);
			this._imageHorse.source = SApplication.assets.getTexture("zuoqi_"+horseBaseInfo.resourcename);
			
			this.labelRank.text = String(rank) +"  "+ CJLang("HORSE_JIE");
			
			this.labelBonus0.text = CJLang("HORSE_PROPERTYBONUS_JIN") + String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + attributeBonus["goldbonus"]}));
			this.labelBonus1.text = CJLang("HORSE_PROPERTYBONUS_MU") + String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + attributeBonus["woodbonus"]}));
			this.labelBonus2.text = CJLang("HORSE_PROPERTYBONUS_SHUI") + String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + attributeBonus["waterbonus"]}));
			this.labelBonus3.text = CJLang("HORSE_PROPERTYBONUS_HUO") + String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + attributeBonus["firebonus"]}));
			this.labelBonus4.text = CJLang("HORSE_PROPERTYBONUS_TU") + String(CJLang("HORSE_PROPERTYBONUS_DATA",{"bonusdata":"+" + attributeBonus["eartchbonus"]}));
			
		}

		public function get layerMain():SLayer
		{
			return _layerMain;
		}

		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}

		public function get labelHorseName():Label
		{
			return _labelHorseName;
		}

		public function set labelHorseName(value:Label):void
		{
			_labelHorseName = value;
		}

		public function get labelRank():Label
		{
			return _labelRank;
		}

		public function set labelRank(value:Label):void
		{
			_labelRank = value;
		}

		public function get layerBonus():SLayer
		{
			return _layerBonus;
		}

		public function set layerBonus(value:SLayer):void
		{
			_layerBonus = value;
		}

		public function get labelBonus0():Label
		{
			return _labelBonus0;
		}

		public function set labelBonus0(value:Label):void
		{
			_labelBonus0 = value;
		}

		public function get labelBonus1():Label
		{
			return _labelBonus1;
		}

		public function set labelBonus1(value:Label):void
		{
			_labelBonus1 = value;
		}

		public function get labelBonus2():Label
		{
			return _labelBonus2;
		}

		public function set labelBonus2(value:Label):void
		{
			_labelBonus2 = value;
		}

		public function get labelBonus3():Label
		{
			return _labelBonus3;
		}

		public function set labelBonus3(value:Label):void
		{
			_labelBonus3 = value;
		}

		public function get labelBonus4():Label
		{
			return _labelBonus4;
		}

		public function set labelBonus4(value:Label):void
		{
			_labelBonus4 = value;
		}

		public function get labelBonus5():Label
		{
			return _labelBonus5;
		}

		public function set labelBonus5(value:Label):void
		{
			_labelBonus5 = value;
		}
	}
}