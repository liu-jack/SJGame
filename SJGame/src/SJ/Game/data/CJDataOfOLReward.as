package SJ.Game.data
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_onlineReward;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.data.SDataBaseRemoteData;
	import engine_starling.utils.STween;
	
	import feathers.controls.Label;
	
	import starling.animation.IAnimatable;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class CJDataOfOLReward extends SDataBaseRemoteData implements IAnimatable
	{
		/** 保存数据 **/
		private var _obj:Object = new Object;
		private var _countdown:int = 0;
		// 防止程序切到后台时间不准
		private var _markTime:uint = 0;
		
		/** 时间间隔 **/
		private const TIME_GAP:uint = 1;
		// 时间 每个一秒调用一次逻辑
		private var _oldTime:Number = 0;
		private var _newTime:Number = 0;
		
		private var _sendActive:Boolean = false;
		private var _over:Boolean = false;
		
		/** 12点重新获取数据 **/
		private var _midnight:Date;
		
		public function CJDataOfOLReward()
		{
			super("CJDataOfOLReward");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _socketEventData);
			
			countdown = 0xFFFF;
			Starling.juggler.add(this);
			
			// 获取当前时间
			_midnight = new Date;
		}
		
		/** 判断是否需要0点重新获取服务器数据 **/
		public function isLoadFromRemote():Boolean
		{
			if (!_midnight)
			{
				_midnight = new Date;
				return true;
			}
			
			var d:Date = new Date();
			if ( _midnight.date != d.date) // 时间不同则返回需要更新
				return true;
			
			return false;
		}
		
		
		override protected function _onloadFromRemote(params:Object = null):void
		{
			super._onloadFromRemote(params);
			// TODO Auto Generated method stub
			SocketCommand_onlineReward.get_info()
		}
		
		/** 当前激活礼包id  0为没有激活任何礼包 **/
		public function set rewardid(value:String):void
		{
			_obj["rewardid"] = value
		}
		/** @private **/
		public function get rewardid():String
		{
			if (null == _obj["rewardid"])
				return "0";
			return _obj["rewardid"];
		}
		
		/** 领取的礼包列表 **/
		public function set receiverewardlist(value:Array):void
		{
			_obj["receiverewardlist"] = value
		}
		/** @private **/
		public function get receiverewardlist():Array
		{
			if (_obj["receiverewardlist"] == null)
				return [];
			
			return _obj["receiverewardlist"];
		}
		
		/** 数据 **/
		public function set curData(value:Object):void
		{
			_obj = value;
			setData("data", _obj);
		}
		/** @private **/
		public function get curData():Object
		{
			return getData("data");
		}
		
		/** 获取到信息 **/
		private function _socketEventData(e:Event):void
		{
			_onloadComplete(e);
			_onActivateComplete(e);
			_onGetRrewardComplete(e);
		}
		
		/**
		 * 加载在线奖励信息
		 * @param e
		 */
		protected function _onloadComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_OLREWARD_GET_INFO)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Array = message.retparams;
				
				rewardid = rtnObject[0];
				// 该字段已无用仅作兼容使用
				var starttime:String = rtnObject[1];
				receiverewardlist = rtnObject[2];
				countdown = int(rtnObject[3]);
				curData = _obj;
				
				
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_OLREWARD_GET_INFO);
				
				this._onloadFromRemoteComplete();
			}
		}
		
		/**
		 * 激活在线奖励
		 * @param e
		 */
		protected function _onActivateComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_OLREWARD_ACTIVATE)
				return;
			_sendActive = false;
			var rtnObject:Array = message.retparams;
			if(message.retcode == 101)
			{
				// 时间未到
				countdown = rtnObject[1];
			}
			else if(message.retcode == 0)
			{
				// 激活的索引  重新设置索引
				rewardid = rtnObject[0];
				// 倒计时时间重置
				countdown = rtnObject[1];
//				// 下一个礼包的倒计时
//				var nextid:String = String(int(rewardid)+1);
//				var js:Json_online_reward_setting = CJDataOfOLRewardProperty.o.getData(nextid);
//				if (null != js)
//					countdown = int(js.onlinetime);
				
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_OLREWARD_ACTIVATE);
			}
			else
			{
				_over = true;
			}
		}
		
		/**
		 * 获取奖励
		 * @param e
		 */
		protected function _onGetRrewardComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_OLREWARD_GET_REWARD)
				return;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 103:
					CJMessageBox(CJLang("ITEM_MAKE_RESULT_STATE_BAG_FULL"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN") + "CJDataOfOLReward._onGetRrewardComplete retcode="+message.retcode );
					return;
			}
			
			if(message.retcode == 0)
			{
				var rtnObject:Array = message.retparams;
				
				// 激活的索引  重新设置索引
				var receiveid:String = rtnObject[0];
				receiverewardlist =  rtnObject[1];
				var itemid:String = rtnObject[2];
				var templateid:String = rtnObject[3];
				
				// 派发事件	刷新界面
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_OLREWARD_GET_REWARD, false, {"receiveid":receiveid, "templateid":templateid});
				
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, __uesitemCallback);
				SocketCommand_item.useItem(ConstBag.CONTAINER_TYPE_BAG, itemid, 1);
				
				function __uesitemCallback(event:Event):void
				{
					var msg:SocketMessage = e.data as SocketMessage;
					if(msg.getCommand() == ConstNetCommand.CS_ITEM_USE_ITEM)
					{
						e.target.removeEventListener(event.type, __uesitemCallback);
						// 获取背包数据
						SocketCommand_item.getBag();
						// 获取角色信息, 使用道具若为礼包, 使用后其中的货币类道具将自动使用, 需要刷新角色信息
						SocketCommand_role.get_role_info();
					}
				}
			}
		}

		
		/**
		 * 每隔一段时间添加一次
		 * @param time
		 */
		public function advanceTime(time:Number):void
		{
			_newTime += time;
			if (_newTime-_oldTime < TIME_GAP)
				return;
			
			_oldTime = _newTime;
			
			// 为防止程序切入后台，进行的逻辑处理
			var date:Date = new Date();
			var nowTime:int = int(date.time/1000)
			if (_markTime == 0)
				_markTime = nowTime;
			
			var difference:int = nowTime - _markTime;
			if (difference > 0)
			{
				countdown -= difference;
				_markTime = nowTime;
			}
			// 派发事件
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_OLREWARD_TICK);
			
			// 判断记录时间
			if (!_sendActive && (countdown <= 0) && (!_over))
			{
				// 先设置为0xFFFF， 防止多次发送激活奖励
				countdown = 0;
				// 时间到发送激活奖励
				_sendActive = true;
				SocketCommand_onlineReward.activate();
			}
		}

		/** 当前礼包倒计时 **/
		public function get countdown():int
		{
			return _countdown;
		}
		/** @private **/
		public function set countdown(value:int):void
		{
			_countdown = value;
		}


	}
}