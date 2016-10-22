package SJ.Game.data
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.PushService;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBaseRemoteData;
	
	import lib.engine.utils.CTimerUtils;
	
	import starling.events.Event;
	
	
	/**
	 * 玩家角色信息
	 * @author longtao
	 * 
	 */
	public class CJDataOfRole extends SDataBaseRemoteData
	{
		public function CJDataOfRole()
		{
			super("CJDataOfRole");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadroleInfo);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onUplevel);
		}
		
		/**
		 * 添加程序被切换至后台的监听
		 * 主要应用与添加本地Push
		 */
		public function addLocalNotification():void
		{
			// 添加未激活监听
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, _onDeActivate);
		}
		
		/**
		 * 程序被切到后台
		 * @param e
		 */
		private function _onDeActivate(e:*):void
		{
			var needVit:int = int(CJDataOfGlobalConfigProperty.o.getData("VIT_MAX")) - vit;
			if (needVit > 0)
			{
				var count:int = Math.ceil(Number(needVit) / int(CJDataOfGlobalConfigProperty.o.getData("VIT_ADD_COUNT")));
				var needSeconds:int = count * int(CJDataOfGlobalConfigProperty.o.getData("VIT_ADD_INTERVAL_SECOND"));
				
				PushService.o.sendLocalNotification(CJLang("LOCALNOTIFICATION_VIT_RECOVER"), needSeconds + CTimerUtils.getCurrentTime()/1000, CJLang("PUSH_TITLE"));
			}
		}
		
		private function _onUplevel(e:starling.events.Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SELF_UPLEVEL)
				return;
			var params:Array = message.retparams;
			var heroId:String = params[2];
			var uid:String = params[0];
			//是主角
			if(heroId == uid)
			{
				CJDataManager.o.DataOfHeroList.getMainHero().level = params[1];
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , false , {heroid:heroId , currentLevel:params[1] , "uid":uid});
			}
		}
		
		/**
		 * 角色名称
		 */
		public function get name():String
		{
			return getData("rolename");
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			setData("rolename",value);
		}
		/**
		 * 角色职业
		 */
		public function get job():int
		{
			return getData("job");
		}
		
		/**
		 * @private
		 */
		public function set job(value:int):void
		{
			setData("job",value);
		}
		
		/**
		 * 角色性别
		 */
		public function get sex():int
		{
			return getData("sex");
		}
		
		/**
		 * @private
		 */
		public function set sex(value:int):void
		{
			setData("sex",value);
		}
		/**
		 * 银两数量
		 */
		public function get silver():Number
		{
			return getData("silver");
		}
		

		/**
		 * @private
		 */
		public function set silver(value:Number):void
		{
			setData("silver",value);
		}
		
		/**
		 * 金币数量
		 */
		public function get gold():Number
		{
			return getData("gold");
		}
		
		/**
		 * @private
		 */
		public function set gold(value:Number):void
		{
			setData("gold",value);
		}
		
		/**
		 * 礼券数量
		 */
		public function get giftTicket():Number
		{
			return getData("ticket");
		}
		
		/**
		 * @private
		 */
		public function set giftTicket(value:Number):void
		{
			setData("ticket",value);
		}
		
		/**
		 * vip等级
		 */
		public function get vipLevel():Number
		{
			return getData("viplevel");
		}
		
		/**
		 * @private
		 */
		public function set vipLevel(value:Number):void
		{
			setData("viplevel",value);
		}
		
		/**
		 * 主角技能
		 */
		public function get skill():Number
		{
			return getData("skill");
		}
		
		/**
		 * @private
		 */
		public function set skill(value:Number):void
		{
			setData("skill",value);
		}
		
		/**
		 * 获得场景ID 
		 * @return 
		 * 
		 */
		public function get last_map():int
		{
			return getData("last_map");
		}
		
		/**
		 * 获得x位置 
		 * @return 
		 * 
		 */
		public function get pos_x():Number
		{
			return getData("pos_x");
		}
		
		/**
		 * 获得y位置 
		 * @return 
		 * 
		 */
		public function get pos_y():Number
		{
			return getData("pos_y");
		}
		/**
		 * 设置体力
		 * @param value
		 * @return 
		 * 
		 */		
		public function set vit(value:int):void
		{
			setData("vit",value);
		}
		/**
		 *  获取体力
		 * @return 
		 * 
		 */
		public function get vit():int
		{
			return getData("vit");
		}
		
		/**
		 * 阵营
		 */		
		public function set camp(value:int):void
		{
			setData("camp",value);
		}
		
		/**
		 *  获取阵营
		 */
		public function get camp():int
		{
			return getData("camp");
		}
		
		/**
		 * 声望
		 */
		public function set credit(value:Number):void
		{
			setData("credit",value);
		}
		
		/**
		 *  获取声望
		 */
		public function get credit():Number
		{
			return getData("credit");
		}
		/**
		 * 声望
		 */
		public function set buyvitnums(value:Number):void
		{
			setData("buyvitnums",value);
		}
		
		/**
		 *  获取首充元宝数
		 * @return 
		 * 
		 */
		public function get firstrechargecount():int
		{
			return getData("firstrechargecount");
		}
		
		/**
		 *  获取评论状态
		 * @return 
		 * 
		 */
		public function get commentstatus():int
		{
			return getData("commentstatus");
		}
		/**
		 *  获取消耗元宝数
		 * @return 
		 * 
		 */
		public function get expensegold():Number
		{
			return getData("expensegold");
		}
		
		/**
		 *  获取声望
		 */
		public function get buyvitnums():Number
		{
			return getData("buyvitnums");
		}
		
		
		/**
		 * 是否有角色信息(没有创建角色的账户会没有角色信息)
		 */
		public function set hasRoleInfo(b:Boolean):void
		{
			return setData("hasRoleInfo", b);
		}
		/**
		 * @private
		 */
		public function get hasRoleInfo():Boolean
		{
			return getData("hasRoleInfo", false);
		}
		
		
		
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_role.get_role_info();
			super._onloadFromRemote(params);
		}
		
		/**
		 * 加载用户数据 
		 * @param e
		 * 
		 */
		protected function _onloadroleInfo(e:starling.events.Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_ROLE_GET_ROLE_INFO)
			{
				if(message.retcode == 0)
				{
					var rtnObject:Object = message.retparams;
					
					for (var k:String in rtnObject)
					{
						this.setData(k,rtnObject[k]);
					}
					
					this._onloadFromRemoteComplete();
				}
			}
			else if(message.getCommand() == ConstNetCommand.CS_JOINCAMP)
			{
				if(message.retcode == 1)
				{
					var camp:int = int(message.retparams);
					CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED 
						, false 
						, {"type":CJTaskEvent.TASK_EVENT_JOIN_CAMP , "camp":camp});
				}
			}
		}
	}
}