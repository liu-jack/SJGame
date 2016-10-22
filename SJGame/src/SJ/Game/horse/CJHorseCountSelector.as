package SJ.Game.horse
{
	/**
	 @author	Weichao
	 2013-5-16 个数选择器
	 */
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	
	import starling.events.Event;
	
	public class CJHorseCountSelector extends SLayer
	{
		private var _minValue:int = 0;
		private var _maxValue:int = 0;
		private var _params:Object = null;
		private var _currentValue:int = 0;
		
		private var _layerMain:SLayer;
		private var _image_countBack:ImageLoader;
		private var _textfield_count:Label;
		private var _button_decrease:Button;
		private var _button_plus:Button;
		private var _button_confirm:Button;
		private var _button_cancel:Button;		
		private var _button_close:Button;
		private var _button_max:Button
		private var _label_des:Label;
		private var _imageValueLabelBack:ImageLoader;
		private var _text_des:String;
		private var _type:int;//升级骑术的种类，银两或者元宝,为了达到数值改变后提示的字符串也变的效果。因为这里面有坐骑相关的逻辑，所以不再通用
		private var _cost:int;//单价
		private var _exp_get:int;//单次所得经验
		private var _beishu:int;//暴击的位数
		private static var _layerSelector:CJHorseCountSelector = null;
		
		public function CJHorseCountSelector(minValue:int = 0, maxValue:int = 0, params:Object = null)
		{
			super();
			this.minValue = minValue;
			this.maxValue = maxValue;
			this.params = params;
		}
		
		public function get currentValue():int
		{
			return _currentValue;
		}

		public function set currentValue(value:int):void
		{
			_currentValue = value;
			this.textfield_count.text = String(_currentValue);
			if (0 == _type)
			{
				this.label_des.text = CJLang("HORSE_UPGRADE_DES_NORMAL",
					{"cost":this.cost * value, "exp_normal":this.exp_get * value, "beishu":beishu});
			}
			else if (1 == _type)
			{
				this.label_des.text = CJLang("HORSE_UPGRADE_DES_SPECIAL",
					{"cost":this.cost * value, "exp_normal":this.exp_get * value, "beishu":beishu})
			}
		}
		
		/**
		 * 调用时用这个类方法就行
		 */
		public static function showWithParams(minValue:int, maxValue:int, params:Object, text:String = null, currentValue:int = 0, 
											  type:int = 0, cost:int = 0, exp_get:int = 0, beishu:int = 0):void
		{
			AssetManagerUtil.o.loadPrepareInQueue("CJHorseCountSelector", 
//				"resource_zuoqi.xml", 
				"horseCountSelector.sxml");
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				if (r == 1)
				{
					if (null == _layerSelector)
					{
						var xml:XML = AssetManagerUtil.o.getObject("horseCountSelector.sxml") as XML;
						_layerSelector = SFeatherControlUtils.o.genLayoutFromXML(xml, CJHorseCountSelector) as CJHorseCountSelector;
					}
					_layerSelector._type = type;
					_layerSelector.minValue = minValue;
					_layerSelector.maxValue = maxValue;
					_layerSelector.cost = cost;
					_layerSelector.exp_get = exp_get;
					_layerSelector.beishu = beishu;
					_layerSelector.currentValue = currentValue;
					_layerSelector.params = params;
					_layerSelector._text_des = text;
					CJLayerManager.o.addModuleLayer(_layerSelector);
				}
			});

		}

		protected override function initialize():void
		{
			super.initialize();
			this.button_close.addEventListener(starling.events.Event.TRIGGERED, _onExitButtonClicked);
			this.button_cancel.addEventListener(starling.events.Event.TRIGGERED, _onExitButtonClicked);
			this.button_max.addEventListener(starling.events.Event.TRIGGERED, _onMaxButtonClicked);
			this.button_decrease.addEventListener(starling.events.Event.TRIGGERED, _onDecreaseButtonClicked);
			this.button_plus.addEventListener(starling.events.Event.TRIGGERED, _onPlusButtonClicked);
			this.button_confirm.addEventListener(starling.events.Event.TRIGGERED, _onConfirmButtonClicked);
			
			this.button_close.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new"));
			this.button_close.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new"));
			this.button_max.defaultSkin = new SImage ( SApplication.assets.getTexture("zq_zuidahua"));
			this.button_plus.defaultSkin = new SImage ( SApplication.assets.getTexture("common_jiaanniu"));
			this.button_decrease.defaultSkin = new SImage ( SApplication.assets.getTexture("common_jiananniu"));
			this.button_confirm.defaultSkin = new SImage ( SApplication.assets.getTexture("common_anniu01new"));
			this.button_confirm.downSkin = new SImage ( SApplication.assets.getTexture("common_anniu02new"));
			this.button_cancel.defaultSkin = new SImage ( SApplication.assets.getTexture("common_anniu01new"));
			this.button_cancel.downSkin = new SImage ( SApplication.assets.getTexture("common_anniu02new"));
			
			var scale9Back:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tishikuang", 15, 14 , 1, 1);
			scale9Back.width = this.layerMain.width;
			scale9Back.height = this.layerMain.height;
			this.layerMain.addChildAt(scale9Back, 0);
			
			this.textfield_count.textRendererProperties.textFormat = new TextFormat(null, 12, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var tf:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI , 10 , 0xFFFFFF);
			tf.leading = 3;
			label_des.width = 155;
			label_des.height = 50;
			label_des.textRendererProperties.textFormat = tf;
			label_des.textRendererProperties.wordWrap = true;
			this.label_des.text = _text_des;
			
			
			var arr_buttons:Array = new Array(this.button_confirm, this.button_cancel);
			for (var i:int = 0; i < arr_buttons.length; i++)
			{
				var button_temp:Button = arr_buttons[i];
				button_temp.defaultLabelProperties.textFormat = CJHorseUtil.TextFormat_Orange;
				button_temp.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			}
			this.button_confirm.label = CJLang("HORSE_CONFIRM");
			this.button_cancel.label = CJLang("HORSE_EXIT");
		}
		
		private function _genRender():ITextRenderer
		{
			var tr:TextFieldTextRenderer = new TextFieldTextRenderer();
			tr.wordWrap = true;
			tr.width = 160;
			tr.maxWidth = 160;
			tr.isHTML = true;
			var tf:TextFormat = new TextFormat(); 
			tf.color = 0xFFFFFF;
			tr.textFormat = tf;
			return tr;
		}
		
		private function _onConfirmButtonClicked(e:Event):void
		{
			if (0 != this.currentValue)
			{
				var value:int = this.currentValue;
				var data:Object = new Object();
				data["count"] = value;
				if (null != this._params)
				{
					data["params"] = this._params;
				}
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_COUNTSELECTOR_SELECTCOUNT, false, data);
			}
			this.removeFromParent();
			this._removeEventListener();
		}
		
		private function _onExitButtonClicked(e:Event):void
		{
			this.removeFromParent();
			this._removeEventListener();
		}
		
		private function _onDecreaseButtonClicked(e:Event):void
		{
			this.currentValue = this.currentValue - 1<=0?1:this.currentValue - 1;
		}
		
		private function _onPlusButtonClicked(e:Event):void
		{
			this.currentValue = this.currentValue + 1>this.maxValue?this.maxValue:this.currentValue + 1;
		}
		
		private function _onMaxButtonClicked(e:Event):void
		{
			this.currentValue = this.maxValue;	
		}
		
		private function _removeEventListener():void
		{
			CJEventDispatcher.o.removeEventListeners(CJEvent.EVENT_COUNTSELECTOR_SELECTCOUNT);
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get cost():int
		{
			return _cost;
		}

		public function set cost(value:int):void
		{
			_cost = value;
		}

		public function get exp_get():int
		{
			return _exp_get;
		}

		public function set exp_get(value:int):void
		{
			_exp_get = value;
		}

		public function get beishu():int
		{
			return _beishu;
		}

		public function set beishu(value:int):void
		{
			_beishu = value;
		}

		public function get minValue():int
		{
			return _minValue;
		}
		
		public function set minValue(value:int):void
		{
			_minValue = value;
		}
		
		public function get maxValue():int
		{
			return _maxValue;
		}
		
		public function set maxValue(value:int):void
		{
			_maxValue = value;
		}
		
		public function get params():Object
		{
			return _params;
		}
		
		public function set params(value:Object):void
		{
			_params = value;
		}
		
		public function get layerMain():SLayer
		{
			return _layerMain;
		}
		
		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}
		
		public function get image_countBack():ImageLoader
		{
			return _image_countBack;
		}
		
		public function set image_countBack(value:ImageLoader):void
		{
			_image_countBack = value;
		}
		
		public function get textfield_count():Label
		{
			return _textfield_count;
		}
		
		public function set textfield_count(value:Label):void
		{
			_textfield_count = value;
		}
		
		public function get button_decrease():Button
		{
			return _button_decrease;
		}
		
		public function set button_decrease(value:Button):void
		{
			_button_decrease = value;
		}
		
		public function get button_plus():Button
		{
			return _button_plus;
		}
		
		public function set button_plus(value:Button):void
		{
			_button_plus = value;
		}
		
		public function get button_confirm():Button
		{
			return _button_confirm;
		}
		
		public function set button_confirm(value:Button):void
		{
			_button_confirm = value;
		}
		
		public function get button_cancel():Button
		{
			return _button_cancel;
		}
		
		public function set button_cancel(value:Button):void
		{
			_button_cancel = value;
		}
		
		public function get button_close():Button
		{
			return _button_close;
		}
		
		public function set button_close(value:Button):void
		{
			_button_close = value;
		}
		public function get imageValueLabelBack():ImageLoader
		{
			return _imageValueLabelBack;
		}
		
		public function set imageValueLabelBack(value:ImageLoader):void
		{
			_imageValueLabelBack = value;
		}
		
		
		public function get label_des():Label
		{
			return _label_des;
		}
		
		public function set label_des(value:Label):void
		{
			_label_des = value;
		}
		
		public function get button_max():Button
		{
			return _button_max;
		}
		
		public function set button_max(value:Button):void
		{
			_button_max = value;
		}
	}
}