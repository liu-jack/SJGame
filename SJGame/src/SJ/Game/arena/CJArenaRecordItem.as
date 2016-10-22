package SJ.Game.arena
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_arena;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJArenaRecordItem extends SLayer
	{
		private var _contentlabel:Label
		private var _timelabel:Label
		private var _reporttxtlabel:Label
		private var _reportid:String
		public function CJArenaRecordItem()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			_timelabel = new Label
			_timelabel.textRendererProperties.textFormat = ConstTextFormat.arenarecordtime
			this.addChild(_timelabel)
				
			_contentlabel = new Label
			_contentlabel.textRendererFactory = function ():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.isHTML = true;
				return _htmltextRender
			}
			_contentlabel.x = 85
			this.addChild(_contentlabel)
				
			_reporttxtlabel = new Label
			_reporttxtlabel.textRendererProperties.textFormat = ConstTextFormat.arenareport
			_reporttxtlabel.addEventListener(TouchEvent.TOUCH,touchHandler);
			_reporttxtlabel.x = 360
			this.addChild(_reporttxtlabel)
				
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,dataRet);
		}
		
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN)
			if(touch)
			{
				SocketCommand_arena.report(this._reportid)
			}
		}
		
		private function dataRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_ARENA_REPORT)
			{
				if(parent.parent)
				{
					parent.removeFromParent(true);
				}
			}	
		}
		
		public function update(data:Object):void
		{
			var txt:String
			if(data.master == 1)
			{
				if(data.result == ConstBattle.BattleResultSuccess)
				{
					txt = CJLang("ARENA_REPORT_DETAIL")
					txt = txt.replace("{ranknum}",data.rankid)
				}
				else
				{
					txt = CJLang("AREAN_REPORT_FAIL_DETAIL")
				}
			}
			else
			{
				if(data.result == ConstBattle.BattleResultSuccess)
				{
					txt = CJLang("ARENA_SLAVEREPORT_FAIL_DETAIL")
					
				}
				else
				{
					txt = CJLang("ARENA_SLAVEREPORT_SUCC_DETAIL")
					txt = txt.replace("{ranknum}",data.rankid)
				}
			}
			txt = txt.replace("{rolename}",data.rolename);
			_reportid = data.reportid;
			var date:Date = new Date(int(data.ctime)*1000)
			this._timelabel.text ="【"+getRealTimeStr(int(date.monthUTC)+1)+"-"+getRealTimeStr(date.dateUTC)+" "+getRealTimeStr(date.hoursUTC)+":"+getRealTimeStr(date.minutesUTC)+"】";
			this._contentlabel.text = txt;
			_reporttxtlabel.text = CJLang("ARENA_REPORT_TEXT")
		}
		
		private function getRealTimeStr(t:int):String
		{
			if(t<10)
			{
				return "0"+String(t);
			}
			return String(t);
		}
	}
}