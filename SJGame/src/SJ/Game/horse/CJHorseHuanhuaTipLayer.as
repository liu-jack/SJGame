package SJ.Game.horse
{
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_horse;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_horsebaseinfo;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	
	import starling.events.Event;

	/**
	 @author	Weichao 幻化界面坐骑的TIP
	 2013-5-21
	 */
	
	public class CJHorseHuanhuaTipLayer extends SLayer
	{
		private var _layerMain:SLayer;
		private var _label_horseName:Label;
		private var _label_horseDesTitle:Label;
		private var _label_horseDescription:Label;
		private var _label_levelRequired:Label;
		private var _label_attributeBonusTitle:Label;
		private var _label_jinAttributeBonus:Label;
		private var _label_muAttributeBonus:Label;
		private var _label_shuilAttributeBonus:Label;
		private var _label_huoAttributeBonus:Label;
		private var _label_tuAttributeBonus:Label;
		private var _image_horseIcon:ImageLoader;
		private var _button_close:Button;
		private var _button_huanhua:Button;
		private var _fenge1:ImageLoader;
		private var _fenge2:ImageLoader;
		private var _label_huodetujin:Label;
		private var _label_huodetujinDesc:Label;
		
		private var _horseid:int = -1;
		private var _status:int;
		
		protected override function initialize():void
		{
			super.initialize();
			
			var s9iamgeBack:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tishikuang", 16, 16, 1, 1);
			s9iamgeBack.x = s9iamgeBack.y = 0;
			s9iamgeBack.width = this.layerMain.width;
			s9iamgeBack.height = this.layerMain.height;
			this.layerMain.addChildAt(s9iamgeBack, 0);
			
			this.button_huanhua.addEventListener(starling.events.Event.TRIGGERED, _onHuanhuaButtonClicked);
			
			this.button_close.addEventListener(starling.events.Event.TRIGGERED, _onCloseButtonClicked);
			
			this.label_horseDesTitle.text = CJLang("HORSE_ITEMDES")+":";
			this.label_attributeBonusTitle.text = CJLang("HORSE_ATTRIBUTEBONUS")+":";
			this.label_huodetujin.text = CJLang("JEWEL_GET_ROUTE")+":";
			
			var arr_titleLabels:Array = new Array();
			arr_titleLabels.push(this.label_attributeBonusTitle, this.label_attributeBonusTitle, label_horseDesTitle , label_huodetujin , label_huodetujinDesc);
			for each(var label_temp:Label in arr_titleLabels)
			{
				label_temp.textRendererProperties.textFormat = new TextFormat(null, null, 0xFFFFFF);
			}
			
			var arr_bonusLabels:Array = new Array();
			arr_bonusLabels.push(this.label_jinAttributeBonus, this.label_muAttributeBonus, this.label_shuilAttributeBonus, 
				this.label_huoAttributeBonus, this.label_tuAttributeBonus, this.label_horseName);
			for each(var label_tempNew:Label in arr_bonusLabels)
			{
				label_tempNew.textRendererProperties.textFormat = new TextFormat(null, null, 0xD2FFB1);
			}
			
			CJDataManager.o.DataOfHorse.addEventListener(DataEvent.DataChange, _refresh);
			
			this.button_huanhua.defaultLabelProperties.textFormat = CJHorseUtil.TextFormat_Orange;
			this.button_huanhua.label = CJLang("HORSE_HUANHUA");
			
			this.label_horseName.textRendererFactory = textRender.htmlTextRender;
			var tf1:TextFormat = new TextFormat(); 
			tf1.color = 0xFFEF3A;
			label_horseName.textRendererProperties.textFormat = tf1;
			
			this.label_horseDescription.textRendererFactory  = _genRender;
		}
		
		private function _genRender():ITextRenderer
		{
			var tr:TextFieldTextRenderer = new TextFieldTextRenderer();
			tr.wordWrap = true;
			tr.width = 160;
			tr.maxWidth = 160;
			tr.isHTML = true;
			var tf:TextFormat = new TextFormat(); 
			tf.color = 0xFFEE8E;
			tr.textFormat = tf;
			return tr;
		}
		
		public function refreshWithHorseid(horseid:int , status:int):void
		{
			_horseid = horseid;
			_status = status;
			this._refresh();
		}
		
		public function _refresh():void
		{
			var dic_baseInfo:Json_horsebaseinfo = CJHorseUtil.getHorseBaseInfoWithHorseID(_horseid);
			this.label_horseName.text = CJLang(dic_baseInfo.name);
			
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var rideLevel:int = int(data.dic_baseInfo["rideskilllevel"]);
			var dic_attributeBonus:Object = CJHorseUtil.getAttributeBonusWithHorseParams(_horseid, rideLevel); 
			this.label_jinAttributeBonus.text = CJLang("HORSE_PROPERTYBONUS_JIN") + "+" + String(dic_attributeBonus["goldbonus"]);
			this.label_muAttributeBonus.text = CJLang("HORSE_PROPERTYBONUS_MU") + "+" + String(dic_attributeBonus["woodbonus"]);
			this.label_shuilAttributeBonus.text = CJLang("HORSE_PROPERTYBONUS_SHUI") + "+" + String(dic_attributeBonus["waterbonus"]);
			this.label_huoAttributeBonus.text = CJLang("HORSE_PROPERTYBONUS_HUO") + "+" + String(dic_attributeBonus["firebonus"]);
			this.label_tuAttributeBonus.text = CJLang("HORSE_PROPERTYBONUS_TU") + "+" + String(dic_attributeBonus["eartchbonus"]);
			this.label_huodetujinDesc.text = CJLang(dic_baseInfo['from']);
			
			
			image_horseIcon.source = SApplication.assets.getTexture("item_zuoqi_"+dic_baseInfo['resourcename']);
			
			var arr_horseConfiglist:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseBaseInfo) as Array;
			
			for (var i:int = 0; i < arr_horseConfiglist.length; i++)
			{
				var horseInfoTemp:Object = arr_horseConfiglist[i];
				if (parseInt(horseInfoTemp["horseid"]) == this._horseid)
				{
					this.label_horseDescription.text = CJLang(horseInfoTemp["desc"]);
				}
			}
			
			if(_status == CJHorseUtil.HORSE_REST)
			{
				this.button_huanhua.label = CJLang("HORSE_HUANHUA");
			}
			else if(_status == CJHorseUtil.HORSE_RIDING)
			{
				this.button_huanhua.label = CJLang("HORSE_XIEXIA");
			}
			else
			{
				this.button_huanhua.label = CJLang("HORSE_JIHUO");
			}
			
		}
		
		public function _onHuanhuaButtonClicked(e:Event):void
		{
//			换马
			if(_status == CJHorseUtil.HORSE_REST)
			{
				SocketCommand_horse.dismount();
				SocketCommand_horse.rideHorse(String(_horseid));
				CJDataManager.o.DataOfHorse.clickType = "huanhua";
			}
//			下马
			else if(_status == CJHorseUtil.HORSE_RIDING)
			{
				SocketCommand_horse.dismount();
			}
//			激活
			else
			{
				this._activateHorse(_horseid);
			}
			_onCloseButtonClicked(null);
		}
		
		private function _activateHorse(_horseid:int):void
		{
//			判断是道具马还是进阶马
			var json:Json_horsebaseinfo = CJHorseUtil.getHorseBaseInfoWithHorseID(_horseid);
//			进阶马
			if(int(json.itemopen) == 0)
			{
				CJMessageBox(CJLang("NOT_ENOUGH_JIEWEI" , {"ranknumber":json["rank"]}));
			}
//			道具马
			else
			{
				var itemTemplateid:int = int(json.itemopen);
				var count:int = CJDataManager.o.DataOfBag.getItemCountByTmplId(itemTemplateid);
//				数量是否足够
				var itemConfig:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemTemplateid);
				if(count <= 0 )
				{
					CJMessageBox(CJLang("NOT_ENOUGH_ITEM" , {"itemname":CJLang(itemConfig.itemname)}));
				}
				else
				{
					var itemid:String = CJDataManager.o.DataOfBag.getFirstItemByTemplateId(itemTemplateid).itemid;
					CJConfirmMessageBox(
						CJLang("HORSE_JIHUODAOJU" , {"itemname":CJLang(itemConfig.itemname) , "number":count}) , 
						function():void{
							SocketCommand_item.useItem(ConstBag.CONTAINER_TYPE_BAG , itemid , 1 );
							CJEventDispatcher.o.dispatchEventWith("horseactived" , false , {"horseid":_horseid});
						});
				}
			}
		}
		
		public function _onCloseButtonClicked(e:Event):void
		{
			CJDataManager.o.DataOfHorse.removeEventListener(DataEvent.DataChange, _refresh);
			this.removeFromParent();
		}
		
		public function CJHorseHuanhuaTipLayer()
		{
			super();
		}
		
		public function get layerMain():SLayer
		{
			return _layerMain;
		}
		
		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}
		
		public function get label_horseName():Label
		{
			return _label_horseName;
		}
		
		public function set label_horseName(value:Label):void
		{
			_label_horseName = value;
		}
		
		public function get label_horseDesTitle():Label
		{
			return _label_horseDesTitle;
		}
		
		public function set label_horseDesTitle(value:Label):void
		{
			_label_horseDesTitle = value;
		}
		
		public function get label_horseDescription():Label
		{
			return _label_horseDescription;
		}
		
		public function set label_horseDescription(value:Label):void
		{
			_label_horseDescription = value;
		}
		
		public function get label_levelRequired():Label
		{
			return _label_levelRequired;
		}
		
		public function set label_levelRequired(value:Label):void
		{
			_label_levelRequired = value;
		}
		
		public function get label_attributeBonusTitle():Label
		{
			return _label_attributeBonusTitle;
		}
		
		public function set label_attributeBonusTitle(value:Label):void
		{
			_label_attributeBonusTitle = value;
		}
		
		public function get label_jinAttributeBonus():Label
		{
			return _label_jinAttributeBonus;
		}
		
		public function set label_jinAttributeBonus(value:Label):void
		{
			_label_jinAttributeBonus = value;
		}
		
		public function get label_muAttributeBonus():Label
		{
			return _label_muAttributeBonus;
		}
		
		public function set label_muAttributeBonus(value:Label):void
		{
			_label_muAttributeBonus = value;
		}
		
		public function get label_shuilAttributeBonus():Label
		{
			return _label_shuilAttributeBonus;
		}
		
		public function set label_shuilAttributeBonus(value:Label):void
		{
			_label_shuilAttributeBonus = value;
		}
		
		public function get label_huoAttributeBonus():Label
		{
			return _label_huoAttributeBonus;
		}
		
		public function set label_huoAttributeBonus(value:Label):void
		{
			_label_huoAttributeBonus = value;
		}
		
		public function get label_tuAttributeBonus():Label
		{
			return _label_tuAttributeBonus;
		}
		
		public function set label_tuAttributeBonus(value:Label):void
		{
			_label_tuAttributeBonus = value;
		}
		
		public function get image_horseIcon():ImageLoader
		{
			return _image_horseIcon;
		}
		
		public function set image_horseIcon(value:ImageLoader):void
		{
			_image_horseIcon = value;
		}
		
		public function get button_close():Button
		{
			return _button_close;
		}
		
		public function set button_close(value:Button):void
		{
			_button_close = value;
		}
		
		public function get button_huanhua():Button
		{
			return _button_huanhua;
		}
		
		public function set button_huanhua(value:Button):void
		{
			_button_huanhua = value;
		}

		public function get fenge1():ImageLoader
		{
			return _fenge1;
		}

		public function set fenge1(value:ImageLoader):void
		{
			_fenge1 = value;
		}

		public function get fenge2():ImageLoader
		{
			return _fenge2;
		}

		public function set fenge2(value:ImageLoader):void
		{
			_fenge2 = value;
		}

		public function get label_huodetujin():Label
		{
			return _label_huodetujin;
		}

		public function set label_huodetujin(value:Label):void
		{
			_label_huodetujin = value;
		}

		public function get label_huodetujinDesc():Label
		{
			return _label_huodetujinDesc;
		}

		public function set label_huodetujinDesc(value:Label):void
		{
			_label_huodetujinDesc = value;
		}


	}
}