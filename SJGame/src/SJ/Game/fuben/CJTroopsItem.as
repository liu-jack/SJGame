package SJ.Game.fuben
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.battle.data.CJBattleFormationData;
	import SJ.Game.controls.CJGeomUtil;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.map.CJPlayerSceneLayer;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import lib.engine.math.Vector2D;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 *  副本战场中的部队
	 * @author yongjun
	 * 
	 */
	public class CJTroopsItem extends CJPlayerSceneLayer
	{
		public function CJTroopsItem(battleheros:Object,isSelf:Boolean)
		{
			super();
			_init(battleheros,isSelf);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _reliveRet);
		}
		
		private var _id:int
		public function set id(id:int):void
		{
			this._id = id;
		}
		public function get id():int
		{
			return this._id;
		}
		private var _speed:Number = 0;
		private var _npccount:int = 0
		private var _npcList:Vector.<CJFubenPlayerNpc> = new Vector.<CJFubenPlayerNpc>
		private function _init(battleheros:Object,isSelf:Boolean):void
		{
			for each(var heroinfo:Object in battleheros)
			{
				var playerData:CJPlayerData = new CJPlayerData();
				playerData.isSelf = isSelf;
				playerData.name = heroinfo.heroid;
				playerData.templateId = parseInt(heroinfo["templateid"]);
				playerData.formationindex = parseInt(heroinfo["formationindex"]);
				playerData.hp_max = parseInt(heroinfo.hp);
				playerData.hp = parseInt(heroinfo.hp);
				_addPlayerToMap(new CJBattlePlayerData(playerData));
			}
		}
		/**
		 * 阵型1的位置，随部队移动改变 
		 */		
//		private var tmpPoint:Point = new Point
		/**
		 * 初始化每个武将距离阵型1位置差 
		 */			
//		private var initPos:Dictionary = new Dictionary
//		private var initZeroPos:Dictionary = new Dictionary;
		private function _addPlayerToMap(player:CJBattlePlayerData):void
		{
			var pos:Point = null;
			var posIndex:int = 0;
			var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[player.playerBaseData.formationId];
			var scaleX:Number = 1.0;
			var playerSprite:CJPlayerNpc;
			var npos:Point;
			var basepos:Point;
			if(player.playerBaseData.isSelf)
			{
				basepos = formationData.getSelfNpcPos(0);
				pos = formationData.getSelfNpcPos(player.playerBaseData.formationindex);
				npos = new Point(pos.x-basepos.x,pos.y);
				playerSprite = new CJFubenPlayerNpc(player.playerBaseData,SApplication.juggler);
				_npcList.push(playerSprite);
			}
			else
			{
				scaleX = -1;
				basepos = formationData.getOtherNpcPos(0);
				pos = formationData.getOtherNpcPos(player.playerBaseData.formationindex);
				npos = new Point(pos.x-basepos.x,pos.y);
				playerSprite = new CJPlayerNpc(player.playerBaseData,SApplication.juggler);
				playerSprite.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
			}
			player.playerSprite = playerSprite;
			
			playerSprite.x = npos.x;
			playerSprite.y = npos.y;
			playerSprite.scaleX = scaleX;
			//添加npc索引
			playerSprite.npcId = player.playerBaseData.name;
			_npccount ++;
			
			this.addChild(playerSprite);
			
			var index:int = player.playerBaseData.formationindex
			playerSprite.onloadResourceCompleted = function(npc:CJPlayerNpc):void{
				npc.sort();
				npc.idle();
				_npccount --;
				
				if(_npccount == 0)
				{
					//延时1秒执行
//					Starling.juggler.delayCall(_initComplete,1);
				}
			}
		}
		
		private var _currentTouchNpc:CJFubenPlayerNpc
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if(touch)
			{
				_currentTouchNpc = e.currentTarget as CJFubenPlayerNpc
				var liveCost:String = CJDataOfGlobalConfigProperty.o.getData("FUBEN_RELIVE");
				var sureText:String = CJLang("FUBEN_RELIVE");
				sureText = sureText.replace("{relivecost}",liveCost)
				CJConfirmMessageBox(sureText,sureRelive)
			}
		}
		
		private function sureRelive():void
		{
			SocketCommand_fuben.relive(_currentTouchNpc.npcId)
		}
		
		private function _reliveRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_RELIVE)
			{
				if(this._npcList.length == 0)return;
				switch(message.retcode)
				{
					case 0:
						var player:CJFubenPlayerNpc = this.getNPCById(message.retparams)
						player.relive();
						player.removeEventListener(TouchEvent.TOUCH,_touchHandler)
						break;
					case 1:
						CJMessageBox(CJLang("FUBEN_RELIVE_NOSILVER"))
						break;
				}
			}
		}
		
		private function getNPCById(hid:String):CJFubenPlayerNpc
		{
			var playerNpc:CJFubenPlayerNpc
			for(var i:String in this._npcList)
			{
				if(this._npcList[i].npcId == hid)
				{
					playerNpc = this._npcList[i]
					break;
				}
			}
			return playerNpc
		}
			
		/**
		 * 更新为死亡 
		 * 
		 */
		public function updateToDead(heroids:Object):void
		{
			for(var i:String in _npcList)
			{
				var index:int = _npcList[i].playerData.formationindex
				var key:String = "pos"+String(index);
				if(parseInt(heroids[key]) < 0)
				{
					_npcList[i].toDead();
					_npcList[i].addEventListener(TouchEvent.TOUCH,_touchHandler);
				}
			}
		}
		
		private function _initComplete():void
		{
			var evt:Event = new Event(CJEvent.EVENT_GUANKA_TROOPLOADCOMPLETE);
			this.dispatchEvent(evt);
		}
		
		/**
		 * 移动到指定的位置 
		 * @param destPoint
		 * @param finish
		 * 
		 */
		public function runTo(destPoint:Point,finish:Function):void
		{
			
			function checklive(obj:CJFubenPlayerNpc , index:int, arr:*):Boolean
			{
				if(obj.isLive)
				{
					return true;
				}
				else
				{
					obj.removeEventListener(TouchEvent.TOUCH,_touchHandler)
					obj.removeFromParent(true);
					return false;
				}
			}
			
			_npcList = _npcList.filter(checklive);
			//剩余的活的
			
			var intdestPoint:Point = new Point(int(destPoint.x),int(destPoint.y));
			
			var vecsrc:Vector2D = new Vector2D(x,y);
			var vecdest:Vector2D = new Vector2D(intdestPoint.x,intdestPoint.y);
			var distance:Number =  vecdest.dist(vecsrc);
			var time:Number = distance / (_speed);
			
			
			var m:Tween = new Tween(this,time);
			m.moveTo(destPoint.x,destPoint.y);
			var pthis:CJTroopsItem = this;
			m.onComplete = function():void
			{
				_changeStateToIdle();
				if(finish != null)
				{
					finish(pthis);
				}
			};
			Starling.juggler.add(m);
			_changeStateToRun();
			return;
		}
		private function _changeStateToRun():void
		{
			for(var i:String in _npcList)
			{
				_npcList[i].run();
			}
		}
		private function _changeStateToIdle():void	
		{
			for(var i:String in _npcList)
			{
				_npcList[i].idle();
			}
		}
		public function get speed():Number
		{
			return _speed;
		}
		public function set speed(value:Number):void
		{
			_speed = value/ 10;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			dispatchEventWith(CJEvent.Event_PlayerPosChange,false,new Point(value,y));
		}
		
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _reliveRet);
			super.dispose();
		}
	}
}