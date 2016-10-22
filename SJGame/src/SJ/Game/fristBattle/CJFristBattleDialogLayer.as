package SJ.Game.fristBattle
{
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.json.Json_frist_battle_dailog_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.animation.DelayedCall;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJFristBattleDialogLayer extends SLayer
	{
		private var _contentLayer:SLayer;
		private var _npcpos_0:CJFristBattleDialogNpcHeadLayer;
		private var _npcpos_1:CJFristBattleDialogNpcHeadLayer;
		private var _talkLabel:Label;
		private var _passLabel:Label;
		
		private var _dialoggroupid:int = 0;
		private var _dialogarr:Array = new Array();
		private var _currentdialogindex:uint = 0;
		private var _currentdialog:Json_frist_battle_dailog_setting;
		private var _currentcontentarray:Array;
		
		
		public static const  INVALIDATION_FLAG_DIALOG:String = "INVALIDATION_FLAG_DIALOG";
		
		public function CJFristBattleDialogLayer()
		{
			super();
		}
		
		override protected function draw():void
		{
			if(isInvalid(INVALIDATION_FLAG_DIALOG))
			{
				_playdialog(_currentdialog);
			}
			super.draw();
		}
		
		override protected function initialize():void
		{
			setSize(SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight)
			var quad:Quad = new Quad(SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight,0x000000);
			quad.alpha = 0.1;
			addChild(quad);
			
			_contentLayer = new SLayer;
			_contentLayer.y = SApplicationConfig.o.stageHeight - 66;
			addChild(_contentLayer);
			
			_initNpcImg();
			_initializebg();
			_initializebgActionLabel();
			
			
			addEventListener(TouchEvent.TOUCH,_onTouch);
			
			super.initialize();
		}
		
		private function _initNpcImg():void
		{
			
			_npcpos_0 = new CJFristBattleDialogNpcHeadLayer;
			_npcpos_0.x = 0;
			_contentLayer.addChild(_npcpos_0);
			
			//加载主角的资源
			var heroList:CJDataOfHeroList = CJDataManager.o.getData("CJDataOfHeroList") as CJDataOfHeroList;
			var playerdata:CJPlayerData = new CJPlayerData();
			_npcpos_1 = new CJFristBattleDialogNpcHeadLayer;
			_npcpos_1.x = SApplicationConfig.o.stageWidth;
			_npcpos_1.left = false;
			_contentLayer.addChild(_npcpos_1);
			

		}
		
		private function _initializebg():void
		{
			var bgFrame:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgFrame.width = SApplicationConfig.o.stageWidth;
			bgFrame.height = 66;
			_contentLayer.addChild(bgFrame);
			
			var bgFramebg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi") , new Rectangle(19,19,1,1)));
			bgFramebg.width = SApplicationConfig.o.stageWidth-5;
			bgFramebg.height = 61;
			bgFramebg.x = 2;
			bgFramebg.y = 2;
			_contentLayer.addChild(bgFramebg);
			
			
			_talkLabel = new Label;
			_talkLabel.textRendererProperties.textFormat = ConstTextFormat.taskdialogtextformatwhite
			_talkLabel.textRendererProperties.wordWrap = true;
			_talkLabel.width = 450
			_talkLabel.x = 25;
			_talkLabel.y = 8;
			_contentLayer.addChild(_talkLabel);
		}
		private function _initializebgActionLabel():void
		{
			_passLabel = new Label;
			_passLabel.textRendererProperties.textFormat = ConstTextFormat.textformat;
			_passLabel.text = CJLang("NPCDIALOG_PASS");
			_passLabel.x = 20;
			_passLabel.y = 44;
			_passLabel.name = "pass"
			_passLabel.addEventListener(TouchEvent.TOUCH,_onTouchSkip);
			_contentLayer.addChild(_passLabel);
			
			var continueLable:Label = new Label;
			continueLable.textRendererProperties.textFormat = ConstTextFormat.textformat;
			continueLable.text = CJLang("NPCDIALOG_CONTINUE");
			continueLable.x = 420;
			continueLable.y = 44;
			continueLable.name = "continue"
			_contentLayer.addChild(continueLable)
		}
		private function play():void
		{
			_currentdialogindex = 0;
			_schedulenextdialog();
		}
		/**
		 * 跳过 
		 * 
		 */
		private function skip():void
		{
			_currentdialogindex = _dialogarr.length;
			Starling.juggler.removeTweens(this);
			_schedulenextdialog();
			
			
		}
		/**
		 * 下一句对话 
		 * @return 
		 * 
		 */
		private function _nextdialog():Boolean
		{
			if(_currentdialogindex >= _dialogarr.length)
			{
				dispatchEventWith(Event.COMPLETE);
				return false;
			}
				
			_currentdialog = _dialogarr[_currentdialogindex];
			_currentdialogindex ++;
			invalidate(INVALIDATION_FLAG_DIALOG);
			return true;
		}
		
		private function _playdialog(mdialog:Json_frist_battle_dailog_setting):void
		{
			_npcpos_0.visible = false;
			_npcpos_1.visible = false;
			var heroList:CJDataOfHeroList = CJDataManager.o.getData("CJDataOfHeroList") as CJDataOfHeroList;
			if(parseInt(mdialog.talkpos) == 0)
			{
				_npcpos_0.visible = true;
				_npcpos_0.npcname = String(mdialog.takenpcname);
				_npcpos_0.npcid = parseInt(mdialog.talktype) == 0?heroList.getMainHero().templateid:parseInt(mdialog.talknpcid);
			}
			else
			{
				_npcpos_1.visible = true;
				_npcpos_1.npcname = String(mdialog.takenpcname);
				_npcpos_1.npcid = parseInt(mdialog.talktype) == 0?heroList.getMainHero().templateid:parseInt(mdialog.talknpcid);
			}
			
			
			_currentcontentarray = String(mdialog.content).split("");
			_showtalkcontent(parseInt(mdialog.talkspeed));
			
			
		}
		
		private function _showtalkcontent(speed:int):void
		{
			var time:Number = 0;
			switch(speed)
			{
				case 0:
				{
					time = 0.2;
					break;
				}
				case 2:
				{
					time = 0.05;
					break;
				}
				default:
				{
					time = 0.1;
					break;
				}
			}
			_talkLabel.text = "";
			_talkLabel.invalidate();
			
			_textshowing = true;
			var t:Tween = new Tween(this,time);
			t.repeatCount = _currentcontentarray.length + 1;
			t.onRepeat = function():void
			{
				_talkLabel.text += _currentcontentarray.shift();
			};
			t.onComplete = function():void
			{
				_textshowing = false;
				_delayCallnextdialog();
			};
				
			Starling.juggler.add(t);
		
		}
		private var _delaycall:DelayedCall;
		private var _textshowing:Boolean = false;
		private function _delayCallnextdialog():void
		{
			if(parseInt(_currentdialog.talkspace) != - 1)
			{
				_delaycall = Starling.juggler.delayCall(_schedulenextdialog,parseInt(_currentdialog.talkspace));
			}
		}
		private function _schedulenextdialog():void
		{
			if(_delaycall != null)
			{
				Starling.juggler.remove(_delaycall);
				_delaycall = null;
			}
			_nextdialog();
		}
		
		/**
		 * 加速显示对话 
		 * 
		 */
		private function _speedupShowDialog():void
		{
			if(_textshowing)
			{
				Starling.juggler.removeTweens(this);
				_talkLabel.text = String(_currentdialog.content);
				_talkLabel.invalidate();
				//延时播放下一条
				_delayCallnextdialog();
//				_delaycall = Starling.juggler.delayCall(_schedulenextdialog,parseInt(_currentdialog.talkspace));
			}
			else
			{
				//直接播放下一条
				_schedulenextdialog();
			}
			
			_textshowing = false;
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			if(e.getTouch(this,TouchPhase.BEGAN))
			{
				_speedupShowDialog();
			}
		}
		
		private function _onTouchSkip(e:TouchEvent):void
		{
			if(e.getTouch(this,TouchPhase.BEGAN))
			{
				skip();
			}
		}

		/**
		 * npc 对话组ID 
		 */
		public function get dialoggroupid():int
		{
			return _dialoggroupid;
		}

		/**
		 * @private
		 */
		public function set dialoggroupid(value:int):void
		{
			_dialoggroupid = value;
			_dialogarr = new Array();
			
			
			var dialog:Json_frist_battle_dailog_setting = null;
			var jsonObject:Object = AssetManagerUtil.o.getObject(ConstResource.sResJsonFristBattleDailogSetting);
			for (var i:int=0;i<jsonObject.length;i++)
			{
				dialog = new Json_frist_battle_dailog_setting();
				dialog.loadFromJsonObject(jsonObject[i]);
				if(parseInt(dialog.talkgroupid) == _dialoggroupid)
				{
					_dialogarr.push(dialog);
					
				}
			}
			
			
			
			play();
			invalidate();
		}
		
		/**
		 * 获取对话资源 
		 * @param mdialoggroupid
		 * @return 
		 * 
		 */
		public static function getdailogResource(mdailoggroupid:int):Array
		{
			
			
			var dailog:Json_frist_battle_dailog_setting = null;
			var jsonObject:Object = AssetManagerUtil.o.getObject(ConstResource.sResJsonFristBattleDailogSetting);
			//获取dailog的res
			var res:Array = new Array();
			for (var i:int=0;i<jsonObject.length;i++)
			{
				dailog = new Json_frist_battle_dailog_setting();
				dailog.loadFromJsonObject(jsonObject[i]);
				if(parseInt(dailog.talkgroupid) == mdailoggroupid)
				{
					
					var playerdata:CJPlayerData = new CJPlayerData();
					playerdata.templateId = dailog.talknpcid == null?10001:parseInt(dailog.talknpcid);
					res = res.concat(CJPlayerNpc.getLoadResourceList(playerdata,CJPlayerNpc.LEVEL_LOD_0));
				}
			}
			return res;
		}
		
		override public function dispose():void
		{
			if(!isDispose)
			{
				if(_delaycall != null)
				{
					Starling.juggler.remove(_delaycall);
					_delaycall = null;
				}
				Starling.juggler.removeTweens(this);
			}
			super.dispose();
		}
		
		
	}
}