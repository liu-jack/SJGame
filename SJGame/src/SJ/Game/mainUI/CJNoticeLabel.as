package SJ.Game.mainUI
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import SJ.Common.Constants.ConstChat;
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstSpeaker;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 公告的label
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-8-17 下午5:36:08  
	 +------------------------------------------------------------------------------
	 */
	public class CJNoticeLabel extends SLayer
	{
		/*是否正在动画中*/
		private var _isAnimating:Boolean = false;
		/*实际的显示组件*/
		private var _label:Label;
		/*每次挪动的距离*/
		private var _moveX:Number = 2;
		/*已经移动的距离*/
		private var _passedWidth:Number = 0;
		/*公告的长度*/
		private var _textWidth:Number;
		/*公告序列*/
		private var _noticeList:Array = new Array();
		private var _noticeBg:ImageLoader;
		
		public function CJNoticeLabel()
		{
			super();
			this.width = SApplicationConfig.o.stageWidth - 20;
			this.height = 20;
			this.touchable = false;
			this.x = 10;
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._addListeners();
			super.initialize();
		}
		
		private function _addListeners():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onNoticeData);
		}
		
		private function _onNoticeData(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_CHAT)
			{
				return;
			}
			var params:Object = message.retparams;
			
			var type:int = int(params["chatType"]);
			var content:Object = params["content"];
			if(!content || !type)
			{
				return;
			}
			if(type == ConstChat.CHAT_TYPE_SPEAKER)
			{
				if(!content.hasOwnProperty('speakertype'))
				{
					this.text = String(content);
					return;
				}
				var speakertype:String = content.speakertype;
				var msg:String = "";
				if(speakertype == ConstSpeaker.SPEAKER_WINEBAR)
				{
					msg = this._getEmployHeroMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_HERO_UPSTAR)
				{
					msg = this._getHeroUpstarMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_ARENA)
				{
					msg = this._getArenaMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_COMBINE_JEWL)
				{
					msg = this._getCombineJwelMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_GOLD_2000)
				{
					msg = this._getOpenRandomBoxMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_HORSE_UPGRADE)
				{
					msg = this._getHorseUpgradeMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_KILL_BOSS)
				{
					msg = this._getKillBossMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_WEAPON)
				{
					msg = this._getWeaponMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_ROLE_UPSTAGELEVEL)
				{
					msg = this._getRoleStageLevelMsg(content);
				}
				else if(speakertype == ConstSpeaker.SPEAKER_VIP_UPLEVEL)
				{
					msg = this._getVipMsg(content);
				}
				
				if(msg != "")
				{
					this.text = msg + "   ";
				}
			}
		}
		
		private function _getVipMsg(content:Object):String
		{
			var msg:String = "";
			var rolename:String = content.rolename;
			var viplevel:String = "<font color='#ff0000'>"+content.viplevel+"</font>";
			msg = CJLang("SPEAKER_VIP_UPLEVEL", {"rolename":rolename, "viplevel":viplevel});
			return msg;
		}
		
		private function _getRoleStageLevelMsg(content:Object):String
		{
			var msg:String = "";
			var rolename:String = content.rolename;
			var roleqaulity:int = content.rolequality;
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			var stageLevel:String = "<font color='#ff0000'>"+content.labastageLevel+"</font>";
			msg = CJLang("SPEAKER_ROLE_UPGRADE", {"rolename":rolename, "level":stageLevel});
			return msg;
		}
		
		/**
		 * 合成40级橙色武器
		 */ 
		private function _getWeaponMsg(content:Object):String
		{
			var msg:String = "";
			var rolename:String = content.rolename;
			var templateid:int = int(content.templateid);
			var itemConfig:Json_item_setting = CJDataOfItemProperty.o.getTemplate(templateid);
			var itemlevel:String = String(itemConfig.level);
			var itemquality:int = int(itemConfig.quality);
			var itemname:String = CJLang(itemConfig.itemname);
			var roleqaulity:int = content.rolequality;
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			itemlevel = "<font color='#ff0000'>"+itemlevel+"</font>";
			itemname = "<font color='"+ConstItem.SCONST_ITEM_QUALITY_COLOR_STR[itemquality]+"'>"+itemname+"</font>";
			msg = CJLang("SPEAKER_ITEM_MAKE", {"rolename":rolename, "itemlevel":itemlevel,"itemname":itemname});
			return msg;
		}
		
		/**
		 * 击杀第二关以后的boss
		 */ 
		private function _getKillBossMsg(content:Object):String
		{
			var rolename:String = content.rolename;
			var bossname:String = CJLang(content.bossname);
			var roleqaulity:int = content.rolequality;
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			var msg:String = CJLang("FUBEN_SPEAKER_PASS" , {"rolename":rolename,"bossname":bossname});
			return msg;
		}
		
		/**
		 * 坐骑升阶到2阶以上
		 */ 
		private function _getHorseUpgradeMsg(content:Object):String
		{
			var rolename:String = content.rolename;
			var ranklevel:String = content.ranklevel;
			var msg:String = "";
			var colorText:String = "";
			var roleqaulity:int = content.rolequality;
			
			var horseConfig:Object = CJHorseUtil.getBaseConfigByRank(int(ranklevel));
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			var horsename:String = "<font color='#ff0000'>"+CJLang(horseConfig['name'])+"</font>";
			msg = CJLang("SPEAKER_HORSE_UPGRADE" , {"rolename":rolename , "horsename":horsename});
			return msg;
		}
		
		/**
		 * 随即宝箱开除2000元宝
		 */ 
		private function _getOpenRandomBoxMsg(content:Object):String
		{
			var msg:String = "";
			var rolename:String = content.rolename;
			var itemTmplId:int = content.itemtmplid;
			var number:int = content.number;
			var roleqaulity:int = content.rolequality;
			var itemTmpl:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemTmplId);
			
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			
			msg = CJLang("SPEAKER_BOX_MONEY" , {"rolename":rolename , "itemname":CJLang(itemTmpl.itemname), "numble":number});
			// 天降横财！大神【{rolename}】竟从【{itemname}】中开出【{numble}】元宝		
			return msg;
		}
		
		/**
		 * 合成宝石8级以上
		 */ 
		private function _getCombineJwelMsg(content:Object):String
		{
			var msg:String = "";
			var rolename:String;
			var itemname:String;
			var itemConfig:Json_item_setting;
			var roleqaulity:int;
			var itemquality:int
			//宝石合成
			if (content.hasOwnProperty("desjewelid"))
			{
				rolename = content.rolename;
				var desjewelid:int = int(content.desjewelid);
				itemConfig = CJDataOfItemProperty.o.getTemplate(desjewelid);
				itemname = CJLang(itemConfig.itemname);
				itemquality = int(itemConfig.quality);
				roleqaulity = content.rolequality;
				rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
				itemname = "<font color='"+ConstItem.SCONST_ITEM_QUALITY_COLOR_STR[itemquality]+"'>"+itemname+"</font>";
				msg = CJLang("SPEAKER_JEWEL_COMBINE", {"rolename":rolename});
				msg += "【" + itemname + "】";
			}
				//宝石一键合成
			else if (content.hasOwnProperty("retResult"))
			{
				rolename = content.rolename;
				roleqaulity = content.rolequality;
				rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
				msg = CJLang("SPEAKER_JEWEL_COMBINE", {"rolename":rolename});
				var retResult:Object = content.retResult;
				for (var key:String in retResult) 
				{
					itemConfig = CJDataOfItemProperty.o.getTemplate(int(key));
					itemquality = int(itemConfig.quality);
					itemname = CJLang(itemConfig.itemname);
					itemname = "<font color='"+ConstItem.SCONST_ITEM_QUALITY_COLOR_STR[itemquality]+"'>"+itemname+"</font>";
					msg += "【" + itemname + "】";
				}
				
			}
			return msg;
		}
		
		/**
		 * 竞技场第一
		 */ 
		private function _getArenaMsg(content:Object):String
		{
			var rolename:String = content.rolename;
			var roleqaulity:int = content.rolequality;
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			var msg:String = CJLang("ARENA_SPEAKER_NUMONE" , {"rolename":rolename});
			return msg;
		}
		
		/**
		 * 武将升星到5星
		 */ 
		private function _getHeroUpstarMsg(content:Object):String
		{
			var rolename:String = content.rolename;
			var heroname:String = content.heroname;
			var msg:String = "";
			var colorText:String = "";
			var heroquality:int = content.quality;
			var roleqaulity:int = content.rolequality;
			heroname = "<font color='"+ConstHero.ConstHeroNameColorString[heroquality]+"'>"+CJLang(heroname)+"</font>";
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			msg = CJLang("SPEAKER_HERO_MAX_LEVEL" , {"color":colorText , "rolename":rolename , "heroname":heroname});
			return msg;
		}
		
		/**
		 * 招募到橙色武将
		 */ 
		private function _getEmployHeroMsg(content:Object):String
		{
			var rolename:String = content.rolename;
			var heroname:String = content.heroname;
			var msg:String = "";
			var colorText:String = "";
			var heroquality:int = content.quality;
			var roleqaulity:int = content.rolequality;
			heroname = "<font color='"+ConstHero.ConstHeroNameColorString[heroquality]+"'>"+CJLang(heroname)+"</font>";
			rolename = "<font color='"+ConstHero.ConstHeroNameColorString[roleqaulity]+"'>"+rolename+"</font>";
			if(heroquality < 5)
			{
				return "";
			}
			msg = CJLang("SPEAKER_GET_HERO" , {"color":colorText , "rolename":rolename , "heroname":heroname});
			return msg;
		}
		
		private function _drawContent():void
		{
			var texture:Texture = SApplication.assets.getTexture("tonggaodi");
			_noticeBg = new ImageLoader(); 
			_noticeBg.source = texture;
			_noticeBg.width = SApplicationConfig.o.stageWidth;
			_noticeBg.y = - 130;
			_noticeBg.alpha = 0.8;
			this.addChild(_noticeBg);
			_noticeBg.visible = false;
			_noticeBg.touchable = false;
			
			_label = new Label();
			_label.x = this.width;
			_label.y = -130;
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xffffff;
			textFormat.size = 17;
			_label.textRendererProperties.textFormat = textFormat;
			_label.textRendererFactory = textRender.htmlTextRender;
			this.addChild(_label);
		}
		
		private function _getTextWidth(content:String):int
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 15;
			textFormat.color = 0xFF0000;
			var tf:TextField = new TextField();
			tf.defaultTextFormat = textFormat;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.wordWrap = false;
			tf.defaultTextFormat = textFormat;
			if(content == null)
			{
				tf.text = "";
			}
			else
			{
				tf.text = content;
			}
			return tf.textWidth;
		}
		
		override protected function draw():void
		{
			if(!_label.text || _label.text == "")
			{
				return;
			}
			super.draw();
			_noticeBg.visible = true;
			_textWidth = this._getTextWidth(_label.text);
			this._showAnimate();
		}
		
		private function _showAnimate():void
		{
			_isAnimating = true;
			setTimeout(function():void
			{
				var totalWidth:Number = _textWidth + width + 25;
				_passedWidth += _moveX;
				_label.x  -= _moveX;
				if(_textWidth > 0 && _passedWidth < totalWidth)
				{
					_showAnimate();
				}
				else
				{
					Starling.juggler.delayCall(_retryFlow , 1);
				}
			},
				25
			);
		}
		
		public function set text(content:String):void
		{
			if(content == "")
			{
				return;
			}
			if(this._isAnimating)
			{
				this._noticeList.push(content);
			}
			else
			{
				_label.text = content;
				this.invalidate();
			}
		}
		
		private function _retryFlow():void
		{
			_label.text = "";
			this._isAnimating = false;
			_label.x = this.width;
			_passedWidth = 0;
			if(this._noticeList.length > 0)
			{
				this.text = this._noticeList.shift();
			}
			else
			{
				_noticeBg.visible = false;
			}
		}
		
		public function get text():String
		{
			return _label.text;
		}
	}
}