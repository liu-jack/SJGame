package SJ.Game.duobao
{
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataOfDuoBao;
	import SJ.Game.data.json.Json_treasure_effect_setting;
	import SJ.Game.data.json.Json_treasure_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;

	public class CJDuoBaoItemInfoLayer extends SLayer
	{
		private var _data:Object;
		private var _dataOfDuoBao:CJDataOfDuoBao = CJDataOfDuoBao.o;
		private var _progressBarExp:ProgressBar;
		private var _curProgress:uint;
		
		private var _oldExp:int;
		private var _oldLevel:int;
		private var _exp:int;
		private var _level:int;
		
		private var _expLabel:Label;
		private var _levelLabel:Label;
		
		public function CJDuoBaoItemInfoLayer()
		{
			super();	
		}
		
		public function setData(data:Object):void
		{
			_data = data;

			_exp = _data["exp"];
			_level = _data["level"];
			
			var json: Json_treasure_setting = _dataOfDuoBao.getTreasure(_data["treasureId"]);
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi") , new Rectangle(19,19,1,1)));
			bgWrap.width = 277;
			bgWrap.height = 256;
			this.addChildAt(bgWrap, 0);
			
			var bg1:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshidi") , new Rectangle(14.5, 13.5, 1, 1)));
			bg1.x = 8.5;
			bg1.y = 33;
			bg1.width = 260;
			bg1.height = 90;
			bg1.color = 0x666666;
			this.addChild(bg1);
			
			var bg2:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshidi") , new Rectangle(14.5, 13.5, 1, 1)));
			bg2.x = 8.5;
			bg2.y = 129;
			bg2.width = 260;
			bg2.height = 90;
			bg2.color = 0x666666;
			this.addChild(bg2);
			
			var iconbg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tubiaokuang1") , new Rectangle(15, 15, 1, 1)));
			iconbg.x = 206;
			iconbg.y = 51;
			iconbg.scaleX = 1.645;
			iconbg.scaleY = 1.645;
			this.addChild(iconbg);	
			
			var icon:SImage = new SImage(SApplication.assets.getTexture(json.picture));
			icon.x = iconbg.x + 3.5;
			icon.y = iconbg.y + 3.5;
			this.addChild(icon);
			
			var CloseBtn:Button = new Button();
			CloseBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			CloseBtn.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			CloseBtn.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new")); 	
			CloseBtn.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFFFFF);
			CloseBtn.addEventListener(starling.events.Event.TRIGGERED, _onClose);
			CloseBtn.x = 85;
			CloseBtn.y = 221;
			CloseBtn.label = CJLang("DUOBAO_ITEM_INFO_SURE");
			this.addChild(CloseBtn);
			
			var button:Button = new Button();
			button.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			button.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			button.addEventListener(Event.TRIGGERED, _onClose);
			button.x = 253;
			button.y = -16;
			this.addChild(button);
			
			var titleLabel:Label = new Label();
			titleLabel.text = CJLang("DUOBAO_ITEM_INFO");
			titleLabel.x = 89;
			titleLabel.y = 5;
			titleLabel.textRendererFactory = function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx();
				_htmltextRender.textFormat = ConstTextFormat.titleformat;
				_htmltextRender.nativeFilters = [new GlowFilter(0x000000,1.0,2.0,2.0,10,6)];
				return _htmltextRender;
			}		
			this.addChild(titleLabel);
			
			var line: SImage = new SImage(SApplication.assets.getTexture("zhuzhanhaoyou_fengexian"));
			line.x = 15;
			line.y = 29;
			line.scaleY = 5.3;
			line.rotation = Math.PI * 1.5;	
			this.addChild(line);
			
			var name:Label = new Label();
			name.text = CJLang(json.treasurename);
			name.x = 17;
			name.y = 43;
			name.textRendererFactory = textRender.glowTextRender;
			name.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0x00FFFF);
			this.addChild(name);
			
			var desctitle:Label = new Label();
			desctitle.text = CJLang("DUOBAO_ITEM_INFO_DESC");
			desctitle.x = 17;
			desctitle.y = 65;
			desctitle.textRendererFactory = textRender.glowTextRender;
			desctitle.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFF00);
			this.addChild(desctitle);
			
			var nextdesctitle:Label = new Label();
			nextdesctitle.text = CJLang("DUOBAO_ITEM_INFO_NEXT");
			nextdesctitle.x = 17;
			nextdesctitle.y = 90;
			nextdesctitle.textRendererFactory = textRender.glowTextRender;
			nextdesctitle.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFF00);
			this.addChild(nextdesctitle);
			
			var desc:Label = new Label();
			desc.text = _dataOfDuoBao.getTreasureDescByID(int(_data["treasureId"]), int(_data["level"]));
			desc.width = 126;
			desc.x = 71;
			desc.y = 65;
			desc.textRendererFactory = textRender.glowTextRender;
			desc.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFF8800);
			desc.textRendererProperties.wordWrap = true;
			this.addChild(desc);
			
			var nextdesc:Label = new Label();
			nextdesc.text = _dataOfDuoBao.getTreasureDescByID(int(_data["treasureId"]), int(_data["level"]) + 1);
			nextdesc.width = 126;
			nextdesc.x = 71;
			nextdesc.y = 90;
			nextdesc.textRendererFactory = textRender.glowTextRender;
			nextdesc.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFF8800);
			nextdesc.textRendererProperties.wordWrap = true;
			this.addChild(nextdesc);
			
			_levelLabel = new Label();
			_levelLabel.text = CJLang("DUOBAO_ITEM_INFO_LEVEL") + _level;
			_levelLabel.x = 16;
			_levelLabel.y = 139;
			_levelLabel.width = 173;
			_levelLabel.textRendererFactory = textRender.glowTextRender;
			_levelLabel.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFF00);
			this.addChild(_levelLabel);
			
			var label:Label = new Label();
			label.text = CJLang("DUOBAO_ITEM_INFO_LEVEL_DESC");
			label.x = 52;
			label.y = 184;
			label.width = 173;
			label.textRendererFactory = textRender.glowTextRender;
			label.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFDAA6, 
				null, null, null, null, null, TextFormatAlign.CENTER);
			this.addChild(label);
			
			var progressImg:ImageLoader = new ImageLoader;
			progressImg.source = SApplication.assets.getTexture("wujiang_jindutiaodi");
			progressImg.x = 17;
			progressImg.y = 162;
			this.addChild(progressImg);
			
			
			var max:int = parseInt(_dataOfDuoBao.getTreasureEffectByID(_data["treasureId"] + "_" + String(int(_data["level"]) + 1)).exp);
			// 经验条伸缩部分
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("wujiang_jingyantiao1"),2,1);
			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
			_progressBarExp = new ProgressBar;
			_progressBarExp.fillSkin = fillSkin;
			_progressBarExp.x = 19;
			_progressBarExp.y = 167;
			_progressBarExp.width = 238;
			_progressBarExp.height = 6;
			this.addChild(_progressBarExp);		
			_progressBarExp.minimum = 0;
			_progressBarExp.maximum = max;
			_progressBarExp.value = _exp;
			
			// 经验条上的显示百分比文字
			_expLabel = new Label;
			_expLabel.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_expLabel.textRendererFactory = textRender.glowTextRender;
			_expLabel.x = progressImg.x;
			_expLabel.y = progressImg.y;
			_expLabel.width = _progressBarExp.width;
			_expLabel.text = _exp + "/" + max;
			this.addChild(_expLabel);
				
			if(_data["addExp"])
			{
				_oldExp = _data["oldExp"];
				_oldLevel = _data["oldLevel"];
				
				if(int(data["oldLevel"]) != int(_data["level"]))
				{			
					var oldMax:int = parseInt(_dataOfDuoBao.getTreasureEffectByID(_data["treasureId"] + "_" + String(int(_data["level"]))).exp);
					
					_progressBarExp.maximum = oldMax;
					_levelLabel.text = CJLang("DUOBAO_ITEM_INFO_LEVEL") + _oldLevel;
					_progressBarExp.value = _oldExp;
					_expLabel.text = _oldExp + "/" + _progressBarExp.maximum;	
					
					progressTo(oldMax, _onAddExpAndLevelUp);
				}
				else
				{
					_progressBarExp.value = _oldExp;
					_expLabel.text = _oldExp + "/" + _progressBarExp.maximum;	
					
					progressTo(_exp, _onAddExp);
				}
			}	
		}
		
		private function _onAddExp():void
		{
			_expLabel.text = _exp + "/" + _progressBarExp.maximum;	
		}
		
		private function _onAddExpAndLevelUp():void
		{
			var max:int = parseInt(_dataOfDuoBao.getTreasureEffectByID(_data["treasureId"] + "_" + String(int(_data["level"] + 1))).exp);
			_progressBarExp.maximum = max;
			_progressBarExp.value = _exp;
			_levelLabel.text = CJLang("DUOBAO_ITEM_INFO_LEVEL") + _level;
			_expLabel.text = _exp + "/" + _progressBarExp.maximum;	
			
			//显示升级箭头 
			var up: SImage = new SImage(SApplication.assets.getTexture("shengjiziyang"));
			up.x = 84;
			up.y = 139;
			this.addChild(up);	
		}
		
		public function set progress(progress:Number):void
		{
			_progressBarExp.value = progress;
			_progressBarExp.validate();
		}
		
		public function get progress():Number
		{
			return _progressBarExp.value;
		}
		
		private function progressTo(value:Number, done:Function = null):void
		{
			var t:Tween = new Tween(this, 0.5);
			t.animate("progress",value);
			if(done != null)
			{
				t.onComplete = done;
			}
			Starling.juggler.add(t);
		}
		
		override protected function initialize():void
		{
		
		}
		
		private function _onClose(event:Event):void
		{
			this.removeChildren();
			this.removeFromParent();
		}
	}
}