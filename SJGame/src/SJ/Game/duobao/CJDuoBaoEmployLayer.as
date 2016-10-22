package SJ.Game.duobao
{
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFriendItem;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 夺宝雇佣主界面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-7 下午2:47:33  
	 +------------------------------------------------------------------------------
	 */
	public class CJDuoBaoEmployLayer extends SLayer
	{
		private var _btnClose:Button;
		private var _btnEmploy:Button;
		private var _friendList:CJDuoBaoEmployListLayer;
		private var _heroList:CJDuoBaoEmployListLayer;
		/*上次点击的武将，连续点击不重复取数据*/
		private var _lastRefreshdUid:String = "";
		
		private var _tip:Label;
		
		public function CJDuoBaoEmployLayer()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();
			
			_btnEmploy.labelFactory = textRender.standardTextRender;
			_btnEmploy.defaultLabelProperties.textFormat = new TextFormat('黑体' , 12 , 0xFEF1A0);
			_btnEmploy.label = CJLang('duobao_employ');
			_btnEmploy.isEnabled = false;
			
			
			_tip.text = CJLang('EMPLOY_TIP');
			
			this.addEventListeners();
		}
		
		private function _initFriends():void
		{
			var data:Object = {'key':'friend' , 'data':new ListCollection(CJDataManager.o.DataOfDuoBaoEmploy.canEmployFriendList)};
			_friendList.data = data;
		}
		
		private function addEventListeners():void
		{
			_btnEmploy.addEventListener(Event.TRIGGERED , this._tryEmploy);
			_btnClose.addEventListener(Event.TRIGGERED , this._close);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_DUOBAO_SELECTFRIEND , this._onSelectFriend);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_DUOBAO_SELECTHERO , this._onSelectHERO);
		}
		
		
		private function _onSelectHERO(e:Event):void
		{
			if(e.type != CJEvent.EVENT_DUOBAO_SELECTHERO)
			{
				return;
			}
			var data:Object = e.data;
			CJDataManager.o.DataOfDuoBaoEmploy.tempSelectHeroid = data['prop']['heroid'];
			
			if(CJDataManager.o.DataOfDuoBaoEmploy.tempSelectHeroid != "" && CJDataManager.o.DataOfDuoBaoEmploy.tempSelectFriendUid != "")
			{
				_btnEmploy.isEnabled = true;
			}
			else
			{
				_btnEmploy.isEnabled = false;
			}
		}
		
		private function _tryEmploy(e:Event):void
		{
			CJMessageBox(CJLang('duobao_sendemploy'));
			SocketCommand_duobao.tryEmploy(CJDataManager.o.DataOfDuoBaoEmploy.tempSelectFriendUid , CJDataManager.o.DataOfDuoBaoEmploy.tempSelectHeroid);
		}
		
		private function _onSelectFriend(e:Event):void
		{
			if(e.type != CJEvent.EVENT_DUOBAO_SELECTFRIEND)
			{
				return;
			}
			var data:CJDataOfFriendItem = e.data as CJDataOfFriendItem;
			if(_lastRefreshdUid == data.frienduid)
			{
				return;
			}
			_lastRefreshdUid = data.frienduid;
			CJDataManager.o.DataOfDuoBaoEmploy.tempSelectFriendUid = _lastRefreshdUid;
			SocketManager.o.callwithRtn(ConstNetCommand.CS_GET_EMPLOY_HERO_INFO , this._refreshHeros , false , data.frienduid); 
			if(CJDataManager.o.DataOfDuoBaoEmploy.tempSelectHeroid != "" && CJDataManager.o.DataOfDuoBaoEmploy.tempSelectFriendUid != "")
			{
				_btnEmploy.isEnabled = true;
			}
			else
			{
				_btnEmploy.isEnabled = false;
			}
		}
		
		private function _refreshHeros(e:SocketMessage):void
		{
			var herosData:Object = e.retparams[0];
			if(!herosData.hasOwnProperty('heroListInfo'))
			{
				return;
			}
			
			var heroList:Object = herosData.heroListInfo;
			var resultList:Array = [];
			
			//过滤主角
			for(var heroid:String in heroList)
			{
				var hero:Object = heroList[heroid];
				if(hero && hero.userid != heroid)
				{
					resultList.push(hero);
				}
			}
			
			resultList.sort(this._compare);
			
			_heroList.data =  {'key':'hero' , 'data':new ListCollection(resultList)};
		}
		
		/**
		 * 由大到小排序
		 */ 
		private function _compare(obj1:* , obj2:*):int
		{
			if(int(obj1.battleeffect) > int(obj2.battleeffect))
			{
				return -1;
			}
			else if(int(obj1.battleeffect) == int(obj2.battleeffect))
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		
		private function _close():void
		{
			this.removeFromParent(true);
		}
		
		override protected function draw():void
		{
			super.draw();
			this._initFriends();
		}

		override public function dispose():void
		{
			super.dispose();
			_btnClose.removeEventListener(Event.TRIGGERED , this._close);
			_btnEmploy.removeEventListener(Event.TRIGGERED , this._tryEmploy);
		}
		
		public function get btnClose():Button
		{
			return _btnClose;
		}

		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		public function get btnEmploy():Button
		{
			return _btnEmploy;
		}

		public function set btnEmploy(value:Button):void
		{
			_btnEmploy = value;
		}

		public function get friendList():CJDuoBaoEmployListLayer
		{
			return _friendList;
		}

		public function set friendList(value:CJDuoBaoEmployListLayer):void
		{
			_friendList = value;
		}

		public function get heroList():CJDuoBaoEmployListLayer
		{
			return _heroList;
		}

		public function set heroList(value:CJDuoBaoEmployListLayer):void
		{
			_heroList = value;
		}
		
		public function get tip():Label
		{
			return _tip;
		}
		
		public function set tip(value:Label):void
		{
			_tip = value;
		}
	}
}