package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_heroTrain;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import lib.engine.utils.CObjectUtils;
	
	import starling.events.Event;
	
	public class CJDataOfHeroTrain extends SDataBaseRemoteData
	{
		/** 默认时间 **/
		private const DEFAULT_TIME:String = "default";
		
		/** 武将训练信息{heroid:cd} **/
		private var _data:Object;
		
		
		/** 主角训练当日次数 **/
		private var _trainCount:int;
		/** 主角训练当日次数 **/
		public function set trainCount(value:int):void
		{
			_trainCount = value;
		}
		/** @private **/
		public function get trainCount():int
		{
			return _trainCount;
		}
		
		public function CJDataOfHeroTrain()
		{
			super("CJDataOfHeroTrain");
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadcomplete);
			SocketCommand_heroTrain.get_train_info();
			super._onloadFromRemote(params);
		}
		
		public function getHroTrain():Object
		{
			return CObjectUtils.clone(_data);
		}
		
		/**
		 * 添加武将训练数据
		 * @param heroid	武将id
		 * @param time		开始时间
		 */
		public function addHeroTrain( heroid:String, time:String=DEFAULT_TIME):void
		{
			// 判断是否是默认时间
			if (time == DEFAULT_TIME)
				time = CJDataOfGlobalConfigProperty.o.getData("HERO_TRAIN_TIME");
			// 设置时间
			_data[heroid] = time;
		}
		
		/**
		 * 删除武将训练数据
		 * @param heroid
		 */
		public function delHeroTrain( heroid:String ):void
		{
			delete _data[heroid];
		}
		
		/**
		 * 清空所有信息
		 */
		override public function clearAll():void
		{
			_data = new Object;
		}
		
		/**
		 * 派发事件
		 */
		public function dispatch():void
		{
			setData("data", _data);
		}
		
		/**
		 * 初始化数据
		 * @param obj
		 * 
		 */
		public function initData(obj:Object):void
		{
			clearAll();
			for (var heroid:String in obj)
			{
				addHeroTrain(heroid, obj[heroid]);
			}
			
			this._onloadFromRemoteComplete();
		}
		
		/**
		 * 加载武将数据
		 * @param e
		 * 
		 */
		protected function _onloadcomplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TRAIN_GET_INFO)
				return;
			if(message.retcode == 0)
			{
				trainCount = message.retparams[0]
				initData(message.retparams[1]);
			}
		}
	}
}