package SJ.Game.achievement
{
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataOfAchievement;
	import SJ.Game.data.json.Json_achievement_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	public class CJAchievementLayer extends SLayer
	{
		// 字体 - 按钮选中
		private const fontBtnSel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xE5DB8E, null, null, null, null, null, TextFormatAlign.CENTER);
		// 字体 - 按钮未选中
		private const fontBtnUnsel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xAB9969, null, null, null, null, null, TextFormatAlign.CENTER);
		
		private var _tabBtn_1:Button;
		private var _tabBtn_2:Button;
		private var _scrollView:CJTurnPage;
		
		private var _curPageIndex:int = 1;
		
		private var _data:Object = new Object();
		
		
		public function CJAchievementLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_erjitanchuang") , new Rectangle(16, 16, 1, 1)));
			bgWrap.width = 428;
			bgWrap.height = 287;
			this.addChildAt(bgWrap , 0);
			
			var bg1:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshidi") , new Rectangle(14.5, 13.5, 1, 1)));
			bg1.x = 7;
			bg1.y = 7;
			bg1.width = 414;
			bg1.height = 273;
			this.addChild(bg1);
		
			var button:Button = new Button();
			button.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			button.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			button.addEventListener(Event.TRIGGERED, _onClose);
			button.x = 406;
			button.y = -19;
			this.addChild(button);
			
			var titleLabel:Label = new Label();
			titleLabel.text = CJLang("ACHI_NAME");

			titleLabel.textRendererFactory = function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx();
				_htmltextRender.textFormat = ConstTextFormat.titleformat;
				_htmltextRender.nativeFilters = [new GlowFilter(0x000000,1.0,2.0,2.0,10,6)];
				return _htmltextRender;
			}		
			titleLabel.x = 164;
			titleLabel.y = 6;
			this.addChild(titleLabel);
			
			
			var line: SImage = new SImage(SApplication.assets.getTexture("zhuzhanhaoyou_fengexian"));
			line.x = 38;
			line.y = 30;
			line.scaleY = 7.5;
			line.rotation = Math.PI * 1.5;	
			this.addChild(line);
			
			var line2: SImage = new SImage(SApplication.assets.getTexture("wujiang_fx01"));
			line2.x = 7;
			line2.y = 55;
			line2.scaleX = 2.55;
			this.addChild(line2);
			
			//页签
			_tabBtn_1 = new Button();
			_tabBtn_1.x = 6;
			_tabBtn_1.y = 31;
			_tabBtn_1.defaultSkin = new SImage(SApplication.assets.getTexture("qiandao_chayexiang"));
			_tabBtn_1.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("qiandao_chayexiangdianliang"));
			_tabBtn_1.width = 104;
			_tabBtn_1.height = 28;
			_tabBtn_1.defaultLabelProperties.textFormat = fontBtnUnsel;
			_tabBtn_1.selectedDownLabelProperties.textFormat = fontBtnSel;
			_tabBtn_1.selectedHoverLabelProperties.textFormat = fontBtnSel;
			_tabBtn_1.selectedUpLabelProperties.textFormat = fontBtnSel;
			_tabBtn_1.addEventListener(Event.TRIGGERED, _onChangePage);
			_tabBtn_1.label = CJLang("ACHI_TAB_1");
			_tabBtn_1.name = "1";
			_tabBtn_1.isSelected = true;
			addChild(_tabBtn_1);
			
			_tabBtn_2 = new Button();
			_tabBtn_2.x = 109;
			_tabBtn_2.y = 31;
			_tabBtn_2.defaultSkin = new SImage(SApplication.assets.getTexture("qiandao_chayexiang"));
			_tabBtn_2.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("qiandao_chayexiangdianliang"));
			_tabBtn_2.width = 104;
			_tabBtn_2.height = 28;
			_tabBtn_2.defaultLabelProperties.textFormat = fontBtnUnsel;
			_tabBtn_2.selectedDownLabelProperties.textFormat = fontBtnSel;
			_tabBtn_2.selectedHoverLabelProperties.textFormat = fontBtnSel;
			_tabBtn_2.selectedUpLabelProperties.textFormat = fontBtnSel;
			_tabBtn_2.addEventListener(Event.TRIGGERED, _onChangePage);
			_tabBtn_2.label = CJLang("ACHI_TAB_2");
			_tabBtn_2.name = "2";
			addChild(_tabBtn_2);
			
			_scrollView = new CJTurnPage(3);
			_scrollView.x = 10;
			_scrollView.y = 57;
			_scrollView.setRect(418, 201);
			this.addChild(_scrollView);	
			
			
			SocketManager.o.callwithRtn(ConstNetCommand.CS_ACHIEVEMENT_GETINFO , _onGetInfo);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_ACHIEVEMENT_STATE_CHANGE , this._onStateChange);
		}
		
		private function _onStateChange(e:Event):void
		{
			var achiid:int = e.data as int;
			_data[achiid]["getState"] = 1;
			_data[achiid]["completeState"] = 1;
			_reflashPage();
		}
		
		private function _onGetInfo(message:SocketMessage):void
		{
			var obj:Object = message.retparams;
			_curPageIndex = 1;
			
			for(var key:* in obj.info)
			{
				var json:Json_achievement_setting = CJDataOfAchievement.o.getAchievementById(key);
				_data[key] = obj.info[key];
				_data[key]["title"] = json.desc;
				_data[key]["type"] = json.type;
				_data[key]["giftId"] = json.reward;
			}
			_reflashPage(true);
		}
		
		private function _onChangePage(e:Event):void
		{
			_tabBtn_1.isSelected = (e.target as Button).name == "1";
			_tabBtn_2.isSelected = (e.target as Button).name == "2";
			_curPageIndex = parseInt((e.target as Button).name);
			_reflashPage(true);
		}
		
		private function _reflashPage(re:Boolean = false):void
		{
			//刷新左边列表
			var data:Array = new Array();
			var count:int = 0;
			for(var key:* in _data)
			{
				var state:int;
				if (_data[key]["getState"] == 1)
				{
					state = 2;
				}
				else
				{
					state = _data[key]["completeState"];
				}
				if(_data[key]["type"] != "" + _curPageIndex)
					continue;
				data.push({
					"achiid": key,
					"title": CJLang(_data[key]["title"]),
					"giftId": _data[key]["giftId"],
					"type" : parseInt(_data[key]["type"]),
					"state": state
				});
				if(!re)
				{
					_scrollView.updateItem(data.shift(), count);
				}
				count++;
			}
			if(re)
			{
				var groceryList:ListCollection = new ListCollection(data);
				_scrollView.dataProvider = groceryList;
				_scrollView.itemRendererFactory = function():IListItemRenderer
				{
					const render:CJAchievementItem = new CJAchievementItem();
					return render;
				};
				_scrollView.scrollToPosition(0, 0, 0);
			}

		}
		
		
		//关闭窗口
		private function _onClose(eve:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJAchievementModule");
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_ACHIEVEMENT_STATE_CHANGE, this._onStateChange);
			super.dispose();
		}
		
	}
}