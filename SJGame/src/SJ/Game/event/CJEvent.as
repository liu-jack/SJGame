package SJ.Game.event
{
	public class CJEvent
	{
		public function CJEvent()
		{
		}
		
		/**
		 * 动画播放开始
		 */
		public static const Event_PlayerAnimStart:String = "Event_PlayerAnimStart";	
		
		/**
		 * 动画播放结束 
		 */
//		public static const Event_PlayerAnimEnd:String = "Event_PlayerAnimEnd";
		
		/**
		 * 玩家坐标改变 
		 */
		public static const Event_PlayerPosChange:String = "Event_PlayerPosChange"
		
		/**
		 * 激活QTE 
		 */
		public static const Event_QTE_Active:String = "Event_QTE_Active";
		
		/**
		 *  任务导航事件
		 */
		public static const Event_Task_GuideNpc:String = "Event_Task_GuideNpc";
		/**
		 * 任务数据改变事件
		 */		
		public static const EVENT_TASK_DATA_CHANGE:String = "EVENT_TASK_DATA_CHANGE";
		
		/**
		 * 任务操作执行
		 */		
		public static const EVENT_TASK_ACTION_EXECUTED:String = "EVENT_TASK_ACTION_EXECUTED";
		
		/**
		 * NPC对话框点击事件
		 */
		public static const EVENT_NPCDIALOG_ACTIONCLICKED:String = "EVENT_NPCDIALOG_ACTIONCLICKED";
		
		/**
		 * 次数选择器选择事件
		 */
		public static const EVENT_COUNTSELECTOR_SELECTCOUNT:String = "EVENT_COUNTSELECTOR_SELECTCOUNT";
		
		/**
		 * 升阶成功
		 */
		public static const EVENT_HORSE_UPGRADERANK_SUCCESS:String = "EVENT_HORSE_UPGRADERANK_SUCCESS";
		
		/**
		 * 骑乘坐骑
		 */
		public static const EVENT_CHANGE_HORSE:String = "EVENT_CHANGE_HORSE";
		/**
		 * 翻页滚动选中
		 */
		public static const EVENT_TURN_PAGE_SELECTED:String = "EVENT_TURN_PAGE_SELECTED";
		/**
		 *  场景切换完成
		 */
		public static const EVENT_SCENE_CHANGE_COMPLETE:String = "EVENT_SCENE_CHANGE_COMPLETE";
		/**
		 *  世界场景中移动
		 */
		public static const EVENT_SCENE_WORLD_MOVE:String = "EVENT_SCENE_WORLD_MOVE";
		/**
		 * 任务引导打卡副本界面 
		 */		
		public static const EVENT_SCENE_FUBEN_OPEN:String = "EVENT_FUBEN_OPEN";
		/**
		 * 主城场景中移动 
		 */		
		public static const EVENT_SCENE_CITY_MOVE:String = "EVENT_SCENE_CITY_MOVE";
		/**
		 * 移动到传送点 
		 */		
		public static const EVENT_SCENE_CITY_MOVETOENTER:String = "EVENT_SCENE_CITY_MOVETOENTER";
		/**
		 *任务导航结束 
		 */		
		public static const EVENT_SCENE_TASKGUID_COMPLETE:String = "EVENT_SCENE_TASKGUID_COMPLETE";
			
		/**
		 * 玩家主角升级
		 */
		public static const EVENT_PLYER_UPLEVEL:String = "EVENT_PLYER_UPLEVEL";
		
		/**
		 * 自己主角升级
		 */
		public static const EVENT_SELF_PLAYER_UPLEVEL:String = "EVENT_SELF_PLYER_UPLEVEL";
		
		/**
		 * 主角升阶 
		 */		
		public static const EVENT_PLAYER_ROLEUPDATE:String = "EVENT_PLAYER_ROLEUPDATE";
		
		/**宝石合成显示信息改变事件*/
		public static const EVENT_JEWEL_COMBINE_SHOW_INFO_CHANGED:String = "EVENT_JEWEL_COMBINE_SHOW_INFO_CHANGED";
		/**
		 *关卡战斗结束
		 */		
		public static const EVENT_GUANKABATTLE_COMPLETE:String = "EVENT_GUANKABATTLE_COMPLETE";
		/**
		 *关卡部队加载完成 
		 */		
		public static const EVENT_GUANKA_TROOPLOADCOMPLETE:String = "EVENT_TROOPLOADCOMPLETE";
		/*聚灵数据改变*/
		public static const EVENT_TREASURE_DATA_CHANGE:String = "EVENT_TREASURE_DATA_CHANGE";
		
		/*富文本点击事件*/
		public static const EVENT_RICH_TEXT_CLICK_EVENT:String = "EVENT_RICH_TEXT_CLICK_EVENT";
		/*聊天新消息*/
		public static const EVENT_CHAT_NEW_MESSAGE:String = "EVENT_CHAT_NEW_MESSAGE";
		/*聊天初始消息*/
		public static const EVENT_CHAT_INIT_MESSAGE:String = "EVENT_CHAT_INIT_MESSAGE";
		/*聊天新消息*/
		public static const EVENT_CHAT_PRIVATE:String = "EVENT_CHAT_PRIVATE";
		
		/** 武将训练倒计时，时间到，获取信息，并更新界面 add by longtao **/
		public static const EVENT_HERO_TRAIN_TIME_UP:String = "EVENT_HERO_TRAIN_TIME_UP";
		/** 主角升阶更新Panel add by longtao **/
		public static const EVENT_STAGE_LEVEL_UPDATE_PANEL:String = "EVENT_STAGE_LEVEL_UPDATE_PANEL";
		
		
		/*开启指引下一步*/
		public static const EVENT_INDICATE_NEXT_STEP:String = "EVENT_INDICATE_NEXT_STEP";
		
		/*开启指引上一步*/
		public static const EVENT_INDICATE_PRE_STEP:String = "EVENT_INDICATE_PRE_STEP";
		
		/*进入指引*/
		public static const EVENT_INDICATE_ENTER:String = "EVENT_INDICATE_ENTER";
		/*退出指引*/
		public static const EVENT_INDICATE_EXIT:String = "EVENT_INDICATE_EXIT";
		
		/** 获取在线奖励信息 **/
		public static const EVENT_OLREWARD_GET_INFO:String = "EVENT_OLREWARD_GET_INFO";
		/** 激活在线奖励 **/
		public static const EVENT_OLREWARD_ACTIVATE:String = "EVENT_OLREWARD_ACTIVATE";
		/** 领取在线奖励 **/
		public static const EVENT_OLREWARD_GET_REWARD:String = "EVENT_OLREWARD_GET_REWARD";
		/** 在线礼包每秒派发时间 **/
		public static const EVENT_OLREWARD_TICK:String = "EVENT_OLREWARD_TICK";
		
		
		/** 武将训练标签被选中 **/
		public static const EVENT_HERO_TRAIN_PICK_ITEM:String = "EVENT_HERO_TRAIN_PICK_ITEM";
		
		/** 穿戴装备，卸下装备，更换装备  发送同一事件 **/
		public static const EVENT_CHANGE_EQUIP_COMPLETE:String = "EVENT_CHANGE_EQUIP_COMPLETE";
		
		/*主界面菜单发生变化 - 展开或者收拢*/
		public static const MAIN_MENU_STATUS_CHANGE:String = "MAIN_MENU_STATUS_CHANGE";
		
		/*坐骑资源Load结束*/
		public static const EVENT_HORSE_LOAD_COMPLETE:String = "EVENT_HORSE_LOAD_COMPLETE";
		
		/** 升阶信息获取完成 **/
		public static const EVENT_STAGE_LEVEL_INFO_COMPLETE:String = "EVENT_STAGE_LEVEL_INFO_COMPLETE";
		/** 升阶形象变化完成 **/
		public static const EVENT_STAGE_LEVEL_IMAGE_COMPLETE:String = "EVENT_STAGE_LEVEL_IMAGE_COMPLETE";
		
		
		public static const EVENT_MAIN_BUTTON_MENU_OPENING:String = "EVENT_MAIN_BUTTON_MENU_OPENING";
		public static const EVENT_MAIN_BUTTON_MENU_OPENED:String = "EVENT_MAIN_BUTTON_MENU_OPENED";
		public static const EVENT_MAIN_BUTTON_MENU_CLOSEING:String = "EVENT_MAIN_BUTTON_MENU_CLOSEING";
		public static const EVENT_MAIN_BUTTON_MENU_CLOSED:String = "EVENT_MAIN_BUTTON_MENU_CLOSED";
		
		/** 武将穿脱装备 **/
		public static const EVENT_HERO_UI_CLOSE_EQUIP_TIP_LAYER:String = "EVENT_HERO_UI_CLOSE_EQUIP_TIP_LAYER";
		
		/** NPC对话框引导框显示 */
		public static const EVENT_NPCDIALOG_GUID_SHOW:String = "EVENT_NPCDIALOG_GUID_SHOW";
		/** NPC对话框引导框隐蔽 */
		public static const EVENT_NPCDIALOG_GUID_HIDE:String = "EVENT_NPCDIALOG_GUID_HIDE";
		/*最新的公告*/
		public static const EVENT_NEWEST_NOTICE:String = 'EVENT_NEWEST_NOTICE';
		
		/**
		 * 日常活动事件发生
		 */		
		public static const EVENT_ACTIVITY_HAPPEN:String = "EVENT_ACTIVITY_HAPPEN";
		
		/**
		 * 日常活动数据变化
		 */		
		public static const EVENT_ACTIVITY_DATA_CHANGE:String = "EVENT_ACTIVITY_DATA_CHANGE";
		
		
		/**
		 * 重置场景玩家管理器(清空现在的玩家列表) ,并暂停刷新
		 */
		public static const EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE:String = "EVENT_SCENEPLAYERMANAGER_RESET";
		/**
		 * 刷新场景玩家管理器,并清空暂停状态 
		 */		
		public static const EVENT_SCENEPLAYERMANAGER_FLASH:String = "EVENT_SCENEPLAYERMANAGER_PAUSE";
		
		
		/**
		 * 不显示场景玩家 (主要用户场景界面弹出吧)
		 */
		public static const EVENT_NOT_DISPLAY_SCENE_PLAYERS:String = "EVENT_NOT_DISPLAY_SCENE_PLAYERS";
		
		/**
		 * 显示场景玩家 (主要用户场景界面弹出)
		 */
		public static const EVENT_DISPLAY_SCENE_PLAYERS:String = "EVENT_DISPLAY_SCENE_PLAYERS"
			
			
		/*夺宝-雇佣好友-选择好友*/
		public static const EVENT_DUOBAO_SELECTFRIEND:String = "EVENT_DUOBAO_SELECTFRIEND";
		
		/*夺宝-雇佣好友-选择武将*/
		public static const EVENT_DUOBAO_SELECTHERO:String = "EVENT_DUOBAO_SELECTHERO";
		
		/*雇佣申请列表变化*/
		public static const EVENT_DUOBAO_APPLY_CHANGE:String = "EVENT_DUOBAO_APPLY_CHANGE";
		
		/*领奖列表变化*/
		public static const EVENT_REWARD_CHANGE:String = "EVENT_REWARD_CHANGE";
		
		/*雇佣申请被通过*/
		public static const EVENT_DUOBAO_APPLY_AGREED:String = "EVENT_DUOBAO_APPLY_AGREED";
		
		/*里程碑状态改变*/
		public static const EVENT_ACHIEVEMENT_STATE_CHANGE:String = "EVENT_ACHIEVEMENT_STATE_CHANGE";
		
		public static const EVENT_NINESPLAY_REG_SUCC:String = "EVENT_NINESPLAY_REG_SUCC";
		
		public static const EVENT_NINESPLAY_CLOSE_MODIFYPWD:String = "EVENT_NINESPLAY_CLOSE_MODPWD";
		
		public static const EVENT_NINESPLAY_CLOSE_REGQUICK:String = "EVENT_NINESPLAY_CLOSE_REGQUICK";
		
		public static const EVENT_NINESPLAY_CLOSE_REG:String = "EVENT_NINESPLAY_CLOSE_REG";
		
		public static const EVENT_NINESPLAY_OPEN_MODPWD:String = "EVENT_NINESPLAY_OPEN_MODPWD";
		
		public static const EVENT_NINESPLAY_MODYPWD_SUCC:String = "EVENT_NINESPLAY_MODYPWD_SUCC";

	}
}