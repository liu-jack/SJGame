package SJ.Common.Constants
{
	public final class ConstNetCommand
	{
		public function ConstNetCommand()
		{
		}
		
		/**
		 * 登录 
		 */
		public static const CS_LOGIN:String = "account.login";
		/**
		 * 退出登录 
		 */
		public static const CS_LOGOUT:String = "account.logout";
		
		public static const CS_LOGICTEST:String = "logictest.testlogic";
		
		/**
		 * 创建帐号
		 */
		public static const CS_ACCOUNT_CREATE:String = "account.create_account";
		/**
		 * 获取服务器的状态
		 */
		public static const CS_ACCOUNT_GET_SERVER_STATUS:String = "account.getserverstatus";
		/**
		 * 解绑快速登录帐号信息
		 */
		public static const CS_ACCOUNT_QUICK_ACCOUNT:String = "r_quicklogin.unbind_quick_account20";

			
		/**
		 * 是否拥有角色
		 */
		public static const CS_ROLE_IS_OWN:String = "r_roles.own_role";
		
		/**
		 * 获得角色信息
		 */
		public static const CS_ROLE_GET_ROLE_INFO:String = "r_roles.get_role_info";
		
		/**
		 * 获得其它角色信息
		 */
		public static const CS_ROLE_GET_OTHER_ROLE_INFO:String = "r_roles.role_getotherroleinfo";
		/**
		 * 通过角色名获取其它帐号信息
		 */
		public static const CS_ROLE_GET_OTHER_ROLE_INFO_BY_NAME:String = "r_roles.role_getotherroleinfobyname";
		
		/**
		 * 玩家提交游戏问题
		 */
		public static const CS_ROLE_COLLECT_PROBLEM:String = "r_roles.collect_problem";
		
		/**
		 * 角色移动 
		 */
		public static const CS_ROLE_MOVETO:String = "r_roles.role_moveto";
		
		
		/**
		 * 同步角色出现 
		 */
		public static const SC_SYNC_SYNCAPPEAR:String = "r_sync.syncappear";
		/**
		 * 同步角色消失 
		 */
		public static const SC_SYNC_SYNDISAPPEAR:String = "r_sync.syncdisappear";
		/**
		 * 同步角色移动 
		 */
		public static const SC_SYNC_SYNCMOVETO:String = "r_sync.syncmoveto";
		/**
		 * 同步角色升级 
		 */
		public static const SC_SYNC_UPLEVEL:String = "r_sync.syncuplevel";
		
		/**
		 * 更换坐骑
		 */
		public static const SC_SYNC_RIDE_CHANGE:String = "r_sync.syncridechange";
		/**
		 * 好友上线
		 */
		public static const SC_SYNC_FRIEND_ONLINE:String = "r_sync.syncfriendonline"
		/**
		 * 好友下线
		 */
		public static const SC_SYNC_FRIEND_OFFLINE:String = "r_sync.syncfriendoffline"
		

			

			
		
		/**
		 * 创建角色
		 */
		public static const CS_ROLE_CREATE:String = "r_roles.create_role";
		
		/**
		 * 更改阵型 
		 */		
		public static const CS_FORMATION_CHANGE:String = "r_formation.changeformation"
		/**
		 * 获取上次保存阵型 
		 */			
		public static const CS_FORMATION_LAST:String = "r_formation.getformation" 
		/**
		 * 获取用户布阵武将列表
		 */			
		public static const CS_FORMATION_GET_HERO_LIST:String = "r_formation.getformation"
			
		/**
		 * 获取主角的所有技能列表
		 */			
		public static const CS_GET_PLAYER_SKILL_LIST:String = "r_skill.getUserSkills"
		
		/**
		 * 增加主角技能
		 */			
		public static const CS_ADD_PLAYER_SKILL:String = "r_skill.addSkill"
			
		/**
		 * 设置主角出战技能
		 */			
		public static const CS_SET_PLAYER_SKILL:String = "r_skill.setPlayerSkill"
		
		/**
		 * 获取武将列表
		 */
		public static const CS_HERO_GET_HEROS:String = "r_heros.get_heros";
		/**
		 * 雇佣武将
		 */
		public static const CS_HERO_EMPLOY_HERO:String = "r_heros.employ_hero";
		
		/**
		 * 解雇武将
		 */
		public static const CS_HERO_FIRE_HERO:String = "r_heros.fire_hero";
		
		/**
		 * 获取所有武将穿着中的装备信息
		 */
		public static const CS_HERO_GET_PUTON_EQUIP:String = "r_heros.get_puton_equip";
		
		/**
		 * 武将穿戴装备
		 */
		public static const CS_HERO_PUTON_EQUIP:String = "r_heros.puton_equip";
		
		/**
		 * 武将脱下装备
		 */
		public static const CS_HERO_TAKEOFF_EQUIP:String = "r_heros.takeoff_equip";
		
		/**
		 * 获取武将展示信息(可查看其他玩家信息)
		 */
		public static const CS_HERO_GET_SHOW_INFO:String = "r_heros.getShowInfo";
		/**
		 * 获取武将展示需要的所有数据
		 */
		public static const CS_HERO_GET_HERO_PROP:String = "r_heros.getheroprop";
		/**
		 * 获取武将列表展示需要的所有数据
		 */
		public static const CS_HERO_GET_HERO_LIST_PROP:String = "r_heros.getHeroListProp";
		
		
		/**
		 * 获取全部道具
		 */
		public static const CS_ITEM_GET_BAG:String = "r_item.getbaginfo"
		
		/**
		 * 装备铸造
		 */
		public static const CS_ITEM_MAKE:String = "r_item_make.make_item";
		
		/**
		 * 道具容器扩容
		 */		
		public static const CS_OPEN_BAG_GRID:String = "r_item.openbaggrid";
		
		/**
		 * 使用道具
		 */		
		public static const CS_ITEM_USE_ITEM:String = "r_item.useitem";
		
		/**
		* 出售道具
		*/		
		public static const CS_ITEM_SELL_ITEM:String = "r_item.sellitem";
		
		/**
		 * 获取武将装备栏中的道具信息
		 * add by longtao 
		 */
		public static const CS_ITEM_EQUIPMENTBAR:String = "r_item.get_equipmentbar";
		
		/**
		 * 获取酒馆当前状态
		 */
		public static const CS_WINEBAR_GETINFO:String = "r_winbar.get_info";
		
		/**
		 * 刷新酒馆武将
		 */
		public static const CS_WINEBAR_REFRESH:String = "r_winbar.refresh";
		
		/**
		 * 开始抽取武将
		 */
		public static const CS_WINEBAR_STARTPICK:String = "r_winbar.startpick";
		
		/**
		 * 抽取武将
		 */
		public static const CS_WINEBAR_PICKING:String = "r_winbar.picking";
		
		/**
		 * 抽取武将
		 */
		public static const CS_WINEBAR_SERVERTIME:String = "r_winbar.getServertTime";
		
		/**
		 * 雇佣武将
		 */
		public static const CS_WINEBAR_EMPLOY_HERO:String = "r_winbar.employ_hero";
		
		
		/**
		 * 战斗 
		 */
		public static const CS_BATTLE:String = "r_battle.battle";
		/**
		 * Npc战斗 
		 */
		public static const CS_BATTLENPC:String = "r_battle.battlenpc";
		
		/**
		 * 第一场战斗 
		 */
		public static const CS_BATTLEFRIST_BATTLE:String = "r_battle.fristbattleplayer";
		
		/**
		 * 切磋
		 */
		public static const CS_BATTLEPLAYER:String = "r_battle.battleplayer";
		
			
		/**
		 * 接受任务
		 */
		public static const CS_TASK_ACCEPTTASK:String = "r_task.acceptTask";
		
		/**
		 * 完成任务
		 */
		public static const CS_TASK_COMPLETETASK:String = "r_task.completeTask";
		
		/**
		 * 奖励任务
		 */
		public static const CS_TASK_REWARDTASK:String = "r_task.rewardTask";
		
		/**
		 * 放弃任务
		 */
		public static const CS_TASK_ABORTTASK:String = "r_task.abortTask";
		
		/**
		 * 获取所有的任务列表
		 */
		public static const CS_TASK_GETALL:String = "r_task.getTaskList";
		
		/**
		 * 获取装备强化信息
		 */
		public static const CS_ENHANCE_GETEQUIPENHANCEINFO:String = "r_enhance.getequipenhanceinfo";
		
		/**
		 * 装备强化
		 */
		public static const CS_ENHANCE_ENHANCEEQUIP:String = "r_enhance.enhanceequip";
		
		/**
		 * 装备强化10次
		 */
		public static const CS_ENHANCE_ENHANCEEQUIPTEN:String = "r_enhance.enhanceequipten";
		
		/**
		 * 激活骑术
		 */
		public static const CS_HORSE_ACTIVERIDESKILL:String = "r_horse.initial";
		
		/**
		 * 获取坐骑信息
		 */
		public static const CS_HORSE_GETHORSEINFO:String = "r_horse.getUserHorseInfo";
		
		/**
		 * 上激活的马
		 */
		public static const CS_HORSE_RIDEHORSE:String = "r_horse.rideHorse";
		
		/**
		 * 下马
		 */
		public static const CS_HORSE_DISMOUNT:String = "r_horse.dismount";
		
		/**
		 * 提升骑术
		 */
		public static const CS_HORSE_UPGRADERIDESKILL:String = "r_horse.upgradeRideSkill";
		
		/**
		 * 升阶骑术
		 */
		public static const CS_HORSE_UPGRADERIDESKILLRANK:String = "r_horse.upgradeRideSkillRank";
		
		/**
		 * 改变坐骑
		 */
//		public static const CS_HORSE_CHANGEHORSE:String = "r_horse.changeHorse";

		/**
		 * 延长坐骑使用时间
		 */
		public static const CS_HORSE_EXTENDHORSE:String = "r_horse.extendHorse";
		
		
		/**
		 * 获取武将标签列表
		 */
		public static const CS_HERO_TAG_GET:String = "r_herotag.get_herotag";
		/**
		 * 添加武将标签列表
		 */
		public static const CS_HERO_TAG_ADD:String = "r_herotag.add_herotag";
		/**
		 *更改场景 
		 */
		public static const CS_SCENE_CHANGE:String = "r_scene.changescene";
		
		/**
		 *获取场景玩家 
		 */
		public static const CS_SCENE_GETSCENEUSERS:String = "r_scene.getsceneusers";
		/**
		 * 宝石合成
		 */
		public static const CS_JEWEL_COMBINE_COMBINE:String = "r_jewel_combine.combine";
		/**
		 * 宝石一键合成
		 */
		public static const CS_JEWEL_COMBINE_COMBINE_ONE_KEY:String = "r_jewel_combine.combine_one_key";
		/**
		 *进入关卡 
		 */		
		public static const CS_FUBEN_ENTERGUANKA:String = "r_fuben.enterguanka";
		
		/**
		 * 获取玩家所有武将装备位洗练信息
		 */
		public static const CS_ITEMRECAST_GETRECASTINFO:String = "r_item_recast.getequipRecastinfo";
		
		/**
		 * 洗炼装备附加属性种类
		 */
		public static const CS_ITEMRECAST_PROPERTYKIND:String = "r_item_recast.recastEquipPropertyKind";
		/**
		 * 洗炼装备附加属性属性值
		 */
		public static const CS_ITEMRECAST_PROPERTYVALUE:String = "r_item_recast.recastEquipPropertyValue";
		
		/**
		 *购买体力 
		 */
		public static const CS_FUBEN_BUYVIT:String = "r_fuben.buyVit";
		
		/**
		 * 获取武将星级信息
		 */
		public static const CS_HEROSTAR_INFO:String = "r_herostar.get_info";
		/**
		 * 武将升星操作
		 */
		public static const CS_HEROSTAR_UPGRADE:String = "r_herostar.upgrade";
		
		
		/*获取灵丸*/
		public static const CS_TREASURE_GETTREASURE:String = "r_treasure.getTreasure";
		/*单个灵丸转化灵气值*/
		public static const CS_TREASURE_TRANSFERSINGAL:String = "r_treasure.transferSingal";
		/*临时背包转化所有灵气值*/
		public static const CS_TREASURE_TRANSFERALL:String = "r_treasure.transferAll";
		/*灵丸升级*/
		public static const CS_TREASURE_TREASUREUPLEVEL:String = "r_treasure.treasureUplevel";
		/*积分兑换灵丸*/
		public static const CS_TREASURE_EXCHANGETREASURE:String = "r_treasure.exchangeTreasure";
		/*穿戴灵丸*/
		public static const CS_TREASURE_PUTONTREASURE:String = "r_treasure.putontreasure";
		/*取消穿戴灵丸*/
		public static const CS_TREASURE_TAKEOFFTREASURE:String = "r_treasure.takeofftreasure";
		/*获取武将所有培养信息*/
		public static const CS_TREASURE_GETALLHEROTREASURELIST:String = "r_treasure.getAllHeroTreasureList";
		/*获取所有灵丸信息*/
		public static const CS_TREASURE_GETALLTREASURELIST:String = "r_treasure.getAllTreasureList";
		/*获取聚灵用户信息*/
		public static const CS_TREASURE_GETUSERINFO:String = "r_treasure.getTreasureUserInfo";
		/*移动灵丸位置*/
		public static const CS_TREASURE_MOVETREASURETOUSERBAG:String = "r_treasure.moveTreasureToUserBag";
		/**
		 *获取副本信息 
		 */
		public static const CS_FUBEN_GETFUBENINFO:String = "r_fuben.getFubenInfo";
		/**
		 *副本战斗 
		 */
		public static const CS_FUBEN_BATTLESTART:String = "r_fuben.fbbattlestart";
		/**
		 *关卡战斗进入获取武将信息 
		 */		
		public static const CS_FUBEN_BATTLEHEROINFO:String = "r_fuben.getheroformation";
		/**
		 *关卡通关领取宝箱奖励 
		 */
		public static const CS_FUBEN_GUANKABOXAWARD:String = "r_fuben.fbRandomAward";
		/**
		 * 获取宝石镶嵌数据
		 */
		public static const CS_JEWEL_GETINLAYINFO:String = "r_jewel.getinlayinfo";
		/**
		 * 宝石镶嵌开启孔
		 */		
		public static const CS_JEWEL_OPENJEWELINLAY:String = "r_jewel.openjewelinlay";
		/**
		 * 宝石镶嵌
		 */		
		public static const CS_JEWEL_INLAYJEWEL:String = "r_jewel.inlayjewel";
		/**
		 * 宝石摘取
		 */		
		public static const CS_JEWEL_REMOVEJEWEL:String = "r_jewel.removejewel";
		
		/**
		 *获取所有申请加好友信息 
		 */
		public static const CS_FRIEND_GET_ALL_REQUESTS_INFO:String = "r_friends.getallrequestsinfo";
		/**
		 *申请添加好友
		 */
		public static const CS_FRIEND_REQUEST_ADD_FRIEND:String = "r_friends.requestaddfriend";
		/**
		 *删除添加好友请求 
		 */		
		public static const CS_FRIEND_RESPONSE_DEL_ADD_FRIEND:String = "r_friends.responsedeladdfriend";
		/**
		 *同意添加好友
		 */		
		public static const CS_FRIEND_RESPONSE_ADD_FRIEND:String = "r_friends.responseaddfriend";
		/**
		 *删除好友 
		 */
		public static const CS_FRIEND_DEL_FRIEND:String = "r_friends.delfriend";
		/**
		 *添加黑名单 
		 */
		public static const CS_FRIEND_ADD_BLACKLIST:String = "r_friends.addblacklist";
		/**
		 *获取黑名单 
		 */		
		public static const CS_FRIEND_GET_BLACKLIST:String = "r_friends.getblacklist";
		/**
		 *删除黑名单
		 */		
		public static const CS_FRIEND_DEL_BLACKLIST:String = "r_friends.delblacklist";
		/**
		 *获取所有好友的信息 
		 */
		public static const CS_FRIEND_GET_ALL_FRIEND_INFO:String = "r_friends.getallfriendsinfo";
		/**
		 *获取好友信息 
		 */
		public static const CS_FRIEND_GET_FRIEND_INFO:String = "r_friends.getfriendinfo";
		/**
		 *删除最近联系人
		 */		
		public static const CS_FRIEND_DEL_FRIEND_TEMP:String = "r_friends.delfriendtemp";
		/**
		 *获取所有最近联系人信息 
		 */		
		public static const CS_FRIEND_GET_ALL_FRIEND_TEMP_INFO:String = "r_friends.getallfriendtempinfo";
			
		/**
		 * 副本复活 
		 */		
		public static const CS_FUBEN_RELIVE:String = "r_fuben.relive";
		/**
		 * 副本扫荡
		 */		
		public static const CS_FUBEN_SAODANG:String = "r_fuben.mutifubenBattle";
		/**
		 * 退出副本
		 */
		public static const CS_FUBEN_EXIT:String = "r_fuben.exitFuben";
		/**
		 * 获取副本助战好友
		 */		
		public static const CS_FUBEN_GET_INVITE_HEROS:String = "r_fuben.getinviteheros";
		/**
		 * 获取副本助战好友
		 */		
		public static const CS_FUBEN_GET_BUYVIT_NUMS:String = "r_fuben.getbuyvitnums";
		/**
		 * 选择副本出战好友
		 */		
		public static const CS_FUBEN_SELECT_INVITE_HEROS:String = "r_fuben.selectinviteheros";
		/**
		 * 刷新副本出战好友列表
		 */		
		public static const CS_FUBEN_FLUSH_INVITE_HEROS:String = "r_fuben.flushinviteheros";
		/**
		 * 保存副本阵型
		 */		
		public static const CS_FUBEN_SAVE_INVITE_HERO_FORMATION:String = "r_fuben.saveinviteheroformation";
		/**
		 * 随机副本奖励
		 */		
		public static const CS_FUBEN_PASS_RAND_AWARD:String = "r_fuben.getrandomitemids";
		/**
		 * 随机副本奖励
		 */		
		public static const CS_FUBEN_PASS_GET_AWARD:String = "r_fuben.getrandomitemid";
		/**
		 * 获取所有副本信息
		 */		
		public static const CS_FUBEN_GETALL_FUBENINFO:String = "r_fuben.getAllFubenInfo";
		/**
		 * 进入活动副本
		 */	
		public static const CS_FUBEN_ENTERACTFBGUANKA:String = "r_activefb.enterguanka";
		/**
		 * 获取活动副本信息
		 */		
		public static const CS_ACTFUBEN_GETALL_FUBENINFO:String = "r_activefb.getAllInfo";
		/**
		 * 活动副本战斗
		 */		
		public static const CS_ACTFUBEN_BATTLE:String = "r_activefb.battle";
			
		/**
		 * 获取主角武星信息
		 */
		public static const CS_STAGELEVEL_GET_INFO:String = "r_stagelevel.get_stagelevel_info";
		/**
		 * 激活武星
		 */
		public static const CS_STAGELEVEL_ACTIVATE_FORCE_STAR:String = "r_stagelevel.activate_force_star";
		
		/**
		 * 聊天
		 */
		public static const CS_CHAT:String = "r_chat.chat";
		
		/**
		 * 聊天最后的消息
		 */
		public static const CS_GET_LAST_MSG:String = "r_chat.getLastMsg";
		
		/**
		 * 最新公告
		 */
		public static const CS_GET_NEWEST_NOTICE:String = "r_notice.getLatestNotice";
		
		
		/**
		 * 聊天服务器PUSH
		 */
		public static const SC_CHAT:String = "r_chat.server2client";
		
		/** 获取自己摇钱树信息 */
		public static const CS_MONEYTREE_GETSELFMONEYTREEINFO:String = "r_moneytree.getselfmoneytreeinfo";
		/** 给自己的摇钱树施肥 */
		public static const CS_MONEYTREE_FEEDSELFMONEYTREE:String = "r_moneytree.feedselfmoneytree";
		/** 给好友的摇钱树施肥 */
		public static const CS_MONEYTREE_FEEDFRIENDMONEYTREE:String = "r_moneytree.feedfriendmoneytree";
		/** 给所有好友的摇钱树施肥 */
		public static const CS_MONEYTREE_FEEDALLFRIENDMONEYTREE:String = "r_moneytree.feedallfriendmoneytree";
		/** 收获摇钱树银两 */
		public static const CS_MONEYTREE_HARVERSTMONEYTREESLIVER:String = "r_moneytree.harverstmoneytreesliver";
		/** 收获摇钱树等级 */
		public static const CS_MONEYTREE_HARVERSTMONEYTREELEVEL:String = "r_moneytree.harverstmoneytreelevel";
		/** 获取好友摇钱树信息 */
		public static const CS_MONEYTREE_GETFRIENDMONEYTREEINFO:String = "r_moneytree.getfriendmoneytreeinfo";
		
		/**
		 * 等级榜
		 */
		public static const CS_RANK_LEVEL:String = "r_rank.getranklevel";
		
		/**
		 * 战力榜
		 */
		public static const SC_RANK_BATTLE_LEVEL:String = "r_rank.getrankbattlelevel";
		/**
		 * 土豪榜
		 */
		public static const SC_RANK_RICH_LEVEL:String = "r_rank.getrankrichlevel";
		
		/**
		 * 加入阵营
		 */
		public static const CS_JOINCAMP:String = "r_roles.joinCamp";
		
		/**
		 * 获取推荐阵营
		 */
		public static const CS_GET_RECOMMENDEDCAMP:String = "r_roles.calcRecommendCampid";
		
		/**
		 * 获取当前加入的阵营
		 */
		public static const CS_GET_CURRENTCAMP:String = "r_roles.getCurrentCampid";
		
		/**
		 * 获取武将训练信息
		 */
		public static const CS_HERO_TRAIN_GET_INFO:String = "r_herotrain.get_train_info";
		/**
		 * 开始训练
		 */
		public static const CS_HERO_TRAIN_START_TRAIN:String = "r_herotrain.start_train";
		/**
		 * 清空训练冷却时间
		 */
		public static const CS_HERO_TRAIN_CLEAN_CD:String = "r_herotrain.clean_cd";
		/**
		 * 清空所有训练中武将的冷却时间
		 */
		public static const CS_HERO_TRAIN_CLEAN_CD_ALL:String = "r_herotrain.clean_cd_all";

		/**
		 * 功能点 - 获取所有开启功能
		 */
		public static const CS_FUNCITON_GETALL:String = "r_functionlist.getAllFunctionList";
		
		/**
		 * 功能点 - 添加功能开启
		 */
		public static const CS_FUNCITON_OPEN:String = "r_functionlist.addOpenFunction";
		
		/**
		 * 功能点 - 完成功能点引导
		 */
		public static const CS_FUNCITON_INDICATE_COMPLETE:String = "r_functionlist.completeFunctionIndicate";
		
		/**
		 * 快速登录(通过设备Mac登录)
		 */
		public static const CS_QUICKLOGIN_QUICKLOGIN:String = "r_quicklogin.quicklogin";
		/**
		 * 快速登录(通过用户名密码的authcode)
		 */
		public static const CS_QUICKLOGIN_QUICKLOGIN20:String = "r_quicklogin.quicklogin20";
		/**
		 * 第三方创建帐号
		 */
		public static const CS_QUICKLOGIN_THIRDPARTYCREATE:String = "r_quicklogin.thirdpartycreate";
		/**
		 * 第三方登录
		 */
		public static const CS_QUICKLOGIN_THIRDPARTYLOGIN:String = "r_quicklogin.thirdpartylogin";
		/**
		 * 商城 - 获取商城道具
		 */
		public static const CS_MALL_GETITEMS:String = "r_mall.getitems";
		/**
		 * 商城 - 获取商城全部道具
		 */
		public static const CS_MALL_GETALLITEMS:String = "r_mall.getallitems";
		
		/**
		 * 商城 - 购买商城道具
		 */
		public static const CS_MALL_BUYITEM:String = "r_mall.buyitem";
		/**
		 * 获取在线奖励信息
		 */
		public static const CS_OLREWARD_GET_INFO:String = "r_online_reward.get_info";
		/**
		 * 激活奖励
		 */
		public static const CS_OLREWARD_ACTIVATE:String = "r_online_reward.activate";
		/**
		 * 领取奖励
		 */
		public static const CS_OLREWARD_GET_REWARD:String = "r_online_reward.get_reward";
		/**
		 * 获取竞技场信息 
		 */
		public static const CS_ARENA_GETINFO:String = "r_arena.getarenainfo";
		/**
		 * 获取竞技榜信息
		 */
		public static const CS_ARENA_GETRNAK:String = "r_rank.getarenarank";
		/**
		 * 购买挑战次数
		 */
		public static const CS_ARENA_BUYCHALLENGECHANCE:String = "r_arena.buychallengechance";
		/**
		 * 清除CD
		 */
		public static const CS_ARENA_CLEARCDTIME:String = "r_arena.clearcdtime";
		/**
		 * 获取购买次数
		 */
		public static const CS_ARENA_GETBUYTIMES:String = "r_arena.gettodaybuynums"
		/**
		 * 竞技场战斗
		 */
		public static const CS_ARENA_BATTLE:String = "r_arena.battle";
		/**
		 * 获取战报 
		 */		
		public static const CS_ARENA_REPORT:String = "r_arena.report";
		/**
		 * 获取挑战记录
		 */
		public static const CS_ARENA_GETRECORD:String = "r_arena.getarenarecord"
		/**
		 * 领取上次排名奖励
		 */
		public static const CS_ARENA_REWARD:String = "r_arena.reward";
		/**
		 * 用于纠正客户端时间，及检测是否可领奖
		 */
		public static const CS_ARENA_CHECKTIME:String = "r_arena.checkawardtime";
		/**
		 *发送大喇叭 
		 */		
		public static const CS_ARENA_SPEAKER:String = "r_arena.tospeaker";
		
		/**
		 * 邮件-获取邮件
		 */
		public static const CS_MAIL_GET_MAILS:String = "r_mail.getmails";
		/**
		 * 邮件-读邮件
		 */		
		public static const CS_MAIL_READ_MAIL:String = "r_mail.readmail";
		/**
		 * 邮件-获取邮件附件
		 */
		public static const CS_MAIL_RECV_MAIL_ATTACH:String = "r_mail.recvmailattach";
		/**
		 * 邮件-删除邮件
		 */
		public static const CS_MAIL_DEL_MAIL:String = "r_mail.delmail";
		
		/*升级给自己发消息*/
		public static const SC_SYNC_SELF_UPLEVEL:String = "r_self.syncuplevel";
		
		/*自己被夺宝，同步赏金值*/
		public static const SC_SYNC_DUOBAOED:String = "r_self.duobaoed";
		
		/*夺宝雇佣，好友加银子*/
		public static const SC_SYNC_DUOBAOFRISLIVER:String = "r_self.duobaofrisliver";
		
		/**
		 * 注册push 
		 */
		public static const CS_REGISTER_PUSH:String = "r_push.registertoken";
		
		/** 记录客户端错误日志 - 批量 */
		public static const CS_CLIENT_ERROR_ALL:String = "r_record.clienterrorall";
		/** 记录客户端错误日志 - 单独一条 */
		public static const CS_CLIENT_ERROR:String = "r_record.clienterror";
		/** 获取武将传功信息 */
		public static const CS_TRANS_GET_TRANS_INFO:String = "r_trans.gettransinfo";
		/**  武将传功 */
		public static const CS_TRANS_HERO_TRANS:String = "r_trans.herotrans";
		
		/** 获取首次充值礼包奖励 */
		public static const CS_FIRST_RECHARGE_GET_GIFT_BAG:String = "r_firstrecharge.getgiftbag";
		/** 获取评论活动奖励 */
		public static const CS_COMMENT_GOTOCOMMENT:String = "r_comment.gotocomment";
		
		/**
		 * 客户端启动 
		 */
		public static const CS_CLIENT_STARTUP:String = "r_record.clientstartup";
		
		/**
		 * 客户端动作统计 
		 */
		public static const CS_CLIENT_RECORD_ACTION:String = "r_record.clientaction";
		/**  有新消息提醒通知 */
		public static const SC_CMD_SYNC_NOTICE:String = "r_sync.syncnotice";
		
		/*获取活跃度信息*/
		public static const CS_GET_ACTIVITY_DATA:String = "r_activity.getActivityData";
		/*获取活跃度奖励*/
		public static const CS_GET_ACTIVITY_REWARD:String = "r_activity.getReward";
		
		/** 使用随机宝箱 */
		public static const CS_ITEM_USERANDOMBOX:String = "r_item.userandombox";
		
		/** 获取VIP信息 */
		public static const CS_VIP_INFO:String = "r_vip.getInfo";
		
		/**
		 * 世界boss获取所有的数据 
		 */
		public static const CS_WORLDBOSS_GETALL:String = "r_worldboss.getAll";
		
		
		/*每日任务 获取所有数据*/
		public static var CS_DAILYTASK_GETALL:String = "r_dailytask.getAll";
		
		/*每日任务 接受任务*/
		public static var CS_DAILYTASK_ACCEPT:String = "r_dailytask.accept";
		
		/*每日任务 立即完成*/
		public static var CS_DAILYTASK_IMDCOMPLETE:String = "r_dailytask.imdComplete";
		
		/*每日任务 领取奖励*/
		public static var CS_DAILYTASK_REWARD:String = "r_dailytask.reward";
		
		/*每日任务 自动刷新任务*/
		public static var CS_DAILYTASK_REFRESH:String = "r_dailytask.autorefresh";
		
		/*每日任务 立即刷新任务*/
		public static var CS_DAILYTASK_IMDREFRESH:String = "r_dailytask.imdrefresh";
		
		/*每日任务 进度变化消息*/
		public static var SC_DAILYTASK_PROGRESSCHANGE:String = "r_dailytask.server2client"
		
		/* 平台充值票据 - 建立票据 */
		public static var CS_RECEIPT_CREATEORDER:String = "r_receipt.createOrderId";
		
		/* 平台充值票据 - 校验票据 */
		public static var CS_RECEIPT_VERIFYRECEIPT:String = "r_receipt.verifyreceipt";
		
		public static var CS_RECEIPT_VERIFYRECEIPT20:String = "r_receipt.verifyreceipt20";
		
		/** 激活cdkey兑换礼品 **/
		public static var CS_CDKEY_ACTIVATE:String = "r_cdkey.activate";
		
		/** 每日签到基本信息 */
		public static var CS_QIANDAO_BASEINFO:String = "r_qiandao.getBaseQDInfo";
		
		/** 签到 */
		public static var CS_QIANDAO_QIANDAO:String = "r_qiandao.qianDao";
		
		/** 签到奖励 */
		public static var CS_QIANDAO_GIFT:String = "r_qiandao.getAward";
		
		/** 获得当前服务器时间 */
		public static var CS_KFCONTEND_ServerTime:String = "r_kfcontend.getCurServerTime";
		
		
		/** 累积充值 */
		public static var CS_PILE_RECHARGE_GETINFO:String = "r_pilerecharge.getInfo";
		/** 单笔充值 */
		public static var CS_SINGLE_RECHARGE_GETINFO:String = "r_singlerecharge.getsinglerechargeinfo";
		
		/** 夺宝 */
		public static var CS_DUOBAO_GET_TREASURE_FOR_FIND:String = "r_treasurehunter.gettreasureforfind";
		
		public static var CS_DUOBAO_FIND:String = "r_treasurehunter.find";
		
		public static var CS_DUOBAO_GET_TREASURE_FOR_MERGE:String = "r_treasurehunter.gettreasureformerge";
		
		public static var CS_DUOBAO_MERGE:String = "r_treasurehunter.merge";
		
		public static var CS_DUOBAO_COLLECT:String = "r_treasurehunter.collect";
		
		public static var CS_DUOBAO_GET_LOOT_LIST:String = "r_treasurehunter.getLootList";
		
		public static var CS_DUOBAO_LOOT_TREASURE_PART:String = "r_treasurehunter.lootTreasurePart";
		
		/** 寻宝--寻宝 */
		public static var CS_XUNBAO_XUNBAO:String = "r_treasurehunter.find";
		/** 寻宝--增加寻宝次数 */
		public static var CS_XUNBAO_ADDNUM:String = "r_treasurehunter.buyfindnum";
		/** 寻宝--获得寻宝基础数据 */
		public static var CS_XUNBAO_BASEINFO:String = "r_treasurehunter.gettreasureforfind";
		/** 夺宝--增加夺宝次数 */
		public static var CS_DUOBAO_ADDNUM:String = "r_treasurehunter.buyduonum";
		/** 夺宝寻宝--获得当前已经购买的次数 */
		public static var CS_DUOBAO_GETCURBUYNUM:String = "r_treasurehunter.getCurBuyNum";
		
		/** 开服争霸数据 */
		public static const CS_KFCONTEND_RICH_LEVEL:String = "r_kfcontend.getrankrichlevel";//土豪榜
		public static const CS_KFCONTEND_LEVEL:String = "r_kfcontend.getranklevel";//等级榜
		public static const CS_KFCONTEND_GETRNAK:String = "r_kfcontend.getarenarank";//格斗之神
		public static const CS_KFCONTEND_BATTLE:String = "r_kfcontend.getrankbattlelevel";//战争之王
		
		/*夺宝雇佣 - 雇佣*/
		public static var CS_DUOBAO_TRYEMPLOY:String = "r_duobaoemploy.tryEmploy";
		
		/*夺宝雇佣 - 同意*/
		public static var CS_DUOBAO_AGREE:String = "r_duobaoemploy.agreeEmploy";
		
		/*夺宝雇佣 - 拒绝*/
		public static var CS_DUOBAO_REJECT:String = "r_duobaoemploy.rejectEmploy";
		
		/*夺宝雇佣 - 获取我的雇佣信息*/
		public static var CS_DUOBAO_GETMYEMPLOYDATA:String = "r_duobaoemploy.getMyEmployData";
		
		/*夺宝雇佣 - 获取我的雇佣申请列表*/
		public static var CS_DUOBAO_EMPLOYAPPLY:String = "r_duobaoemploy.getMyApplyList";
		
		/*夺宝阵型 - 保存雇佣阵型信息*/
		public static var CS_DUOBAO_SAVEEMPLOYFORMATION:String = "r_duobaoemploy.saveEmployHeroFormation";
		
		/*夺宝雇佣 - 申请雇佣被通过*/
		public static var SC_DUOBAO_APPLYAGREED:String = "r_duobaoemploy.applyagreed";
		
		/*夺宝雇佣 - 获取好友可被雇佣武将信息*/
		public static const CS_GET_EMPLOY_HERO_INFO:String = "r_duobaoemploy.getEmployHerosInfo";
		
		/*发奖 - 获取所有数据*/
		public static var CS_REWARD_GETALL:String = "r_allplayergift.getvalidlist";
		
		/*发奖 - 获取奖励*/
		public static var CS_REWARD_GETREWARD:String = "r_allplayergift.gainGift";
		
		/*发奖 - 有新奖励*/
		public static var SC_REWARD_GETREWARD:String = "r_reward.newreward";
		
		
		/*里程碑 */
		public static var CS_ACHIEVEMENT_GETINFO:String = "r_achievement.getInfo";
		
		public static var CS_ACHIEVEMENT_GETREWARD:String = "r_achievement.getReward";
		
		/*9splay 普通注册*/
		public static var NINESPLAY_REGISTER:String = "/api/MemberCreate";
		/*9splay 快速注册*/
		public static var NINESPLAY_REGISTERQUICK:String = "/api/MemberMake";
		/*9splay 登录*/
		public static var NINESPLAY_LOGIN:String = "/api/MemberLogin";
		/*9splay 登录*/
		public static var NINESPLAY_MODPWD:String = "/api/MemberModPwd";
		
	}
}