package SJ.Game.duobao
{
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJFormationModule;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class CJDuoBaoSelectTargetLayer extends SLayer
	{	
		
		private var _pageLabel:Label;
		
		private var _leftBtn:Button;
		private var _rightBtn:Button;
		
		private var _nameLabels:Array = new Array();
		private var _lvLabels:Array = new Array();
		private var _lvbgs:Array = new Array();
		private var _rewardLabels:Array = new Array();
		private var _btns:Array = new Array();
		private var _players:Array = new Array();
		
		private var _data:Object;
		private var _treasurePartId:int;
		
		private var _count:int;
		private var _pageCount:int;
		private var _page:int;
		
		private var _curDuoBaoIndex:int = 0;
		
		public function CJDuoBaoSelectTargetLayer()
		{
			super();		
		}
		
		public function setData(data: Object):void
		{	
			_data = data;
			_treasurePartId = _data["treasurePartId"];
			_count = _data["list"].length;
			
			_data["list"].sortOn("reward", Array.DESCENDING|Array.NUMERIC);
			
			if(_count % 3 == 0)
			{
				_pageCount = _count / 3;
			}
			else 
			{
				_pageCount = _count / 3 + 1;
			}
			_page = 1;
			reflashPage();	
		}
		
		private function reflashPage():void
		{
			try
			{
				_pageLabel.text = _page + "/" + _pageCount;
				_leftBtn.isEnabled = _page != 1;
				_rightBtn.isEnabled = _page != _pageCount;
				
				for(var i:int = 0; i < 3; i++)
				{
					(_lvLabels[i] as Label).text = "";			
					(_nameLabels[i] as Label).text = "";
					(_rewardLabels[i] as Label).text = "";		
					(_btns[i] as Button).isEnabled = false;
					(_players[i] as SLayer).removeChildren(0,-1,true);
					(_lvbgs[i] as SImage).visible = false;
				}
				var beginIdx: int = (_page - 1) * 3;
				var endIdx: int = (beginIdx + 3) > _count ? _count : beginIdx + 3;
				for(var k:int = beginIdx; k < endIdx; k++)
				{
					(_lvLabels[k - beginIdx] as Label).text = "LV." + _data["list"][k]["level"];
					(_nameLabels[k - beginIdx] as Label).text = _data["list"][k]["rolename"];
					(_rewardLabels[k - beginIdx] as Label).text = CJLang("DUOBAO_SELECT_REWARD") + _data["list"][k]["reward"];
					(_btns[k - beginIdx] as Button).isEnabled = true;
					(_btns[k - beginIdx] as Button).name = _data["list"][k]["userid"];
					(_lvbgs[k - beginIdx] as SImage).visible = true;
					
					var playerDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
					var playerData:CJPlayerData = new CJPlayerData;
					playerData.isPlayer = true;
					playerData.templateId = parseInt(_data["list"][k]["templateid"]);
					playerDatas.push(playerData);
					var role:CJPlayerNpc= new CJPlayerNpc(playerData,Starling.juggler);
					role.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
					role.hidebattleInfo();
					role.onloadResourceCompleted = function loaded(npc:CJPlayerNpc):void{
						npc.idle();
					};
					role.x = 60
					role.y = 123;
					(_players[k - beginIdx] as SLayer).addChild(role);
				}
				
			}
			catch(e:Error)
			{
				CJMessageBox(e.message);			
			}
			
		}
		
		override protected function initialize():void
		{
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgWrap.width = 392;
			bgWrap.height = 274;
			this.addChildAt(bgWrap , 0);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(382 , 264);
			bgBall.width = 382;
			bgBall.height = 264;
			bgBall.x = 5;
			bgBall.y = 5;
			this.addChildAt(bgBall , 0 );
			
			//底
			var bg : Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1 ,1 , 1, 1)));
			bg.width = 392;
			bg.height = 274;
			this.addChildAt(bg , 0);
			
			var dec:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangzhuangshinew") , new Rectangle(66,30 , 1,1)));
			dec.width = 370;
			dec.height = 252;
			dec.x = 11;
			dec.y = 11;
			this.addChild(dec);
			
			var button:Button = new Button();
			button.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			button.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			button.addEventListener(Event.TRIGGERED, _onClose);
			button.x = 358;
			button.y = -19;
			this.addChild(button);
			
			var titleLabel:Label = new Label();
			titleLabel.text = CJLang("DUOBAO_SELECT_TITLE");
			titleLabel.x = 73;
			titleLabel.y = 15;
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
			line.x = 34;
			line.y = 41;
			line.scaleY = 7;
			line.rotation = Math.PI * 1.5;	
			this.addChild(line);
			
			for(var i:int = 0; i < 3; i++)
			{
				var playerbg: Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("baoshi_yijianhechengdi") , new Rectangle(4, 4, 11, 11)));
				playerbg.x = 15 + i * 121;
				playerbg.y = 42;
				playerbg.width = 120;
				playerbg.height = 148;
				this.addChild(playerbg);
				
				var pan:SImage = new SImage(SApplication.assets.getTexture("common_dizuo"));
				pan.scaleX = 0.8;
				pan.scaleY = 0.8;
				pan.x = 18 + i * 121;
				pan.y = 154;
				this.addChild(pan);
				
				var layer:SLayer = new SLayer();
				layer.x = 15 + i * 121;
				layer.y = 42;
				this.addChild(layer);
				_players.push(layer);
				
				
				var lvBg:SImage = new SImage(SApplication.assets.getTexture("jingjichang_mingchengdi"));
				lvBg.x = 16 + i * 121;
				lvBg.y = 49;
				lvBg.scaleX = 1.85;
				this.addChild(lvBg);
				_lvbgs.push(lvBg);
				
				var lvLabel:Label = new Label();
				lvLabel.text = "LV.55";
				lvLabel.x = 2 + i * 121;
				lvLabel.y = 50;
				lvLabel.width = 63;
				lvLabel.height = 15;
				lvLabel.textRendererFactory = textRender.glowTextRender;
				lvLabel.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFC800, null, null, null, null, null, TextFormatAlign.CENTER);
				this.addChild(lvLabel);
				_lvLabels.push(lvLabel);
				
				var nameLabel:Label = new Label();
				nameLabel.text = "";
				nameLabel.x = 65 - 19 + i * 121;
				nameLabel.y = 51;
				nameLabel.width = 80;
				nameLabel.height = 15;
				nameLabel.textRendererFactory = textRender.glowTextRender;
				nameLabel.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 8, 0xFFC800, null, null, null, null, null, TextFormatAlign.RIGHT);
				this.addChild(nameLabel);
				_nameLabels.push(nameLabel);					
				
				var rewardLabel:Label = new Label();
				rewardLabel.text = "";
				rewardLabel.x = 20 + i * 121;
				rewardLabel.y = 65;
				rewardLabel.textRendererFactory = textRender.glowTextRender;
				rewardLabel.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFC800);
				this.addChild(rewardLabel);
				_rewardLabels.push(rewardLabel);
				
				
				var btn:Button = new Button();
				btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
				btn.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
				btn.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new")); 	
				btn.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFFFFF);
				btn.addEventListener(starling.events.Event.TRIGGERED, _onDuoBao);
				btn.x = 19 + i * 121;
				btn.y = 195;
				btn.label = CJLang("DUOBAO_SELECT_DUOBAO");
				this.addChild(btn);
				_btns.push(btn);
			}
			
			_leftBtn = new Button();
			_leftBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			_leftBtn.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			_leftBtn.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02")); 	
			_leftBtn.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFFFFF);
			_leftBtn.addEventListener(starling.events.Event.TRIGGERED, _onLeft);
			_leftBtn.scaleX = -0.66;
			_leftBtn.scaleY = 0.66;
			_leftBtn.x = 163;
			_leftBtn.y = 230;
			this.addChild(_leftBtn);
			
			_rightBtn = new Button();
			_rightBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			_rightBtn.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			_rightBtn.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02")); 	
			_rightBtn.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFFFFF);
			_rightBtn.addEventListener(starling.events.Event.TRIGGERED, _onRight);
			_rightBtn.scaleX = 0.66;
			_rightBtn.scaleY = 0.66;
			_rightBtn.x = 227;
			_rightBtn.y = 230;
			this.addChild(_rightBtn);
			
			var textBg: SImage = new SImage(SApplication.assets.getTexture("common_liaotian_wenzidi"));
			textBg.x = 165;
			textBg.y = 234;
			textBg.color = 0x888888;
			textBg.scaleX = 3;
			this.addChild(textBg);
			
			_pageLabel = new Label();
			_pageLabel.text = "0/0";
			_pageLabel.x = 163;
			_pageLabel.y = 236;
			_pageLabel.width = 60;
			_pageLabel.height = 40;
			_pageLabel.textRendererFactory = textRender.glowTextRender;
			_pageLabel.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFFF00, null, null, null, null, null, TextFormatAlign.CENTER);
			this.addChild(_pageLabel);
		}
		
		override public function dispose():void
		{
			for(var i:String in _players)
			{
				(_players[i] as SLayer).removeFromParent(true);
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
			super.dispose();
		}
		
		private function _enterFormation(userId:String, treasurePartId:int):void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onRemoteCallBack);
			SApplication.moduleManager.enterModule(CJFormationModule.MOUDLE_NAME , {'userId':userId , 'treasurePartId':treasurePartId});
		}
		
		/**
		 * @private
		 * 接受协议
		 */
		private function _onRemoteCallBack(e:Event):void
		{
			//收协议
			var message:SocketMessage = e.data as SocketMessage;
			var retParams:Object = message.retparams;
			switch (message.getCommand())
			{
				
				case ConstNetCommand.CS_DUOBAO_LOOT_TREASURE_PART:
				{				
					switch (message.retcode)
					{
						case 0:
						{
							var _targetInfo:Object = new Object();
							_targetInfo["rolename"] = _data["list"][_curDuoBaoIndex]["rolename"];
							_targetInfo["templateId"] = _data["list"][_curDuoBaoIndex]["templateid"];
							_targetInfo["level"] = _data["list"][_curDuoBaoIndex]["level"];
							this.removeFromParent(false);
							SApplication.moduleManager.exitModule("CJDuoBaoModule");
							SApplication.moduleManager.enterModule("CJDuoBaoBattleModule",
								{"battleret":message.retparams["battleresult"], "targetinfo":_targetInfo, 
									"treasureId":_treasurePartId, "usereward":message.retparams["usereward"],
									"isVectory":message.retparams["isVectory"]});
							SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
							break;
						}
						case 1:
						{
							CJMessageBox(CJLang("DUOBAO_SELECT_TIP_1"));
							this.removeFromParent(false);
							break;
						}
						case 3:
						{
							CJMessageBox(CJLang("DUOBAO_SELECT_TIP_2"));
							this.removeFromParent(false);
							break;
						}
					}

					break;
				}
			}
		}
		
		private function _onClose(event:Event):void
		{
			this.removeFromParent(false);
		}
		
		private function _onDuoBao(event:Event):void
		{
			var uid:String = Button(event.currentTarget).name;
			for(var i:int = 0; i < _count; i++)
			{
				if(_data["list"][i]["userid"] == uid)
				{
					_curDuoBaoIndex = i;
					break;
				}
			}

			
			_enterFormation(uid, _treasurePartId)
		}
		
		private function _onLeft(event:Event):void
		{
			_page--;
			reflashPage();
		}
		
		private function _onRight(event:Event):void
		{
			_page++;
			reflashPage();
		}
	}
}