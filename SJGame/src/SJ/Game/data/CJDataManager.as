package SJ.Game.data
{
	import SJ.Game.activity.CJActivityManager;
	import SJ.Game.data.config.CJDataOfEnhanceEquipProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.upgrade.CJDataOfUserHabit;
	import SJ.Game.worldboss.CJWorldBossMonsterManager;
	
	import engine_starling.data.SDataBase;
	
	/**
	 * 数据管理器
	 * 维护公共信息
	 * @author longtao
	 * 
	 */
	public class CJDataManager extends SDataBase
	{
		private static var _ins:CJDataManager = null;
		
		public function CJDataManager()
		{
			super("CJDataManager")
			_init();
		}
		
		private function _init():void
		{
			// 注册数据
			register( new CJDataOfAccounts );	// 帐号数据
			register( new CJDataOfRole );		// 玩家角色数据
			register( new CJDataOfHeroList );	// 玩家武将列表
			register( new CJDataOfFormation );		// 阵型数据
			register( new CJDataOfUserSkillList );		// 阵型数据
			register( new CJDataOfBag );		// 背包数据
			register( new CJDataOfItemProperty );	// 道具模板数据
			register( new CJDataOfTaskList );	// 任务列表数据
			register( new CJDataOfWinebar );	// 酒馆数据
			register( new CJDataOfHorse);		// 坐骑数据
			register( new CJDataOfEnhanceEquip );	// 装备强化数据
			register( new CJDataOfEnhanceEquipProperty );	// 装备强化配置数据
			register( new CJDataOfHeroTag );	// 武将标签信息
			register( new CJDataOfFuben);
//			register( new CJDataOfScene);	//场景数据
			register( new CJDataOfHeroEquip );	// 武将穿着中的装备映射
			register( new CJDataOfEquipmentbar );	// 武将穿着中的装备详细信息
			register( new CJDataOfHeroStar );	// 获取武将星级信息
			register( new CJDataOfTreasureList);	// 用户灵丸信息列表
			register( new CJDataOfTreasureUserInfo);	// 用户聚灵公共信息
			register( new CJDataOfHeroTreasureList);	// 用户武将聚灵培养信息
			register( new CJDataOfInlayJewel );		// 用户宝石镶嵌信息
			register( new CJDataOfRecast);		// 用户洗练信息
			register( new CJDataOfChat);	// 聊天信息
			register( new CJDataOfStageLevel);	// 主角升阶信息
			register( new CJDataOfMoneyTreeMine );	// 我的摇钱树数据
			register( new CJDataOfMoneyTreeFriend );	// 好友的摇钱树数据
			register( new CJDataOfCamp);	// 阵营数据
			register( new CJDataOfHeroTrain ); // 武将训练
			register( new CJDataOfFunctionList ); // 功能开启数据
			register( new CJDataOfMall );	// 商城数据
			register( new CJDataOfOLReward ); // 在线礼包
			register( new CJDataOfUserHabit ); // 在线礼包
			register( new CJDataOfFriends); //好友数据
			register( new CJDataOfSetting); //系统设置
			register( new CJDataOfAssistantInFormation); //助战武将在阵型中的数据
			register( new CJDataOfMail);//邮件数据
			register( new CJDataOfNavigator)//导航
			register( new CJDataOfActFb)//活动副本
			register( new CJDataOfBattlePlayer)//与其他玩家进行切磋 add by longtao
			register( new CJDataOfRanklist);//排行榜数据
			register(new CJDataOfNavigator)//导航
			register(new CJDataOfActFb)//活动副本
			register(new CJDataOfNotice)//公告数据
			register(new CJDataOfActivity())//活跃度数据
			register(new CJDataOfNews())//新消息提醒数据
			register(new CJDataOfVIP)//VIP
			register(new CJDataOfArena)//竞技场
			register(new CJDataOfWorldBoss());//世界副本
			register(new CJDataOfPileRecharge);// 累积充值 add by longtao
			register(new CJDataOfDuoBaoEmploy);
			register(new CJDataOfReward);
			
			//注册agent
			register(new CJActivityManager())//活跃度agent
			register(new CJWorldBossMonsterManager())//世界BOSS管理器
			register(new CJDataOfBattlePlayer)//与其他玩家进行切磋 add by longtao
			register(new CJDataOfDailyTask)//每日任务
			register(new CJDataOfPlatformReceipt);//充值平台票据数据 add by sangxu
			register(new CJDataOfPlatformProducts);//充值类型数据 add by sangxu
			register(new CJDataOfSingleRecharge);// 单笔充值 add by sangxu
			
		}
		
		/**
		 * 注册数据
		 * @return 
		 * 
		 */
		private function register( data:* ):void
		{
			super.setData( data.dataBasename, data );
		}
		
		public static function get o():CJDataManager
		{
			if(_ins == null)
				_ins = new CJDataManager();
			return _ins;
		}
		
		/**
		 * 设置数据
		 * @param key
		 * @param value
		 * 
		 */
		override public function setData(key:String, value:*):void
		{
			register(value);
		}
		
		/**
		 * 获取数据
		 * @param key
		 * @return 
		 * 
		 */
		override public function getData(key:String,D:* = null):*
		{
			return super.getData(key,D);
		}
		
		/**
		 * 清空所有数据
		 * 仅仅在玩家登出时使用
		 */
		public function clearData():void
		{
			for each(var data:* in  _dataContains)
				if (data) data.clearAll();
		}
		
		public function saveAll():void
		{
			for each( var item:* in _dataContains)
				if (item) item.saveToCache();
		}
		
		/**
		 * 账户数据 
		 * @return 
		 * 
		 */
		public function get DataOfAccounts():CJDataOfAccounts
		{
			return getData("CJDataOfAccounts") as CJDataOfAccounts
		}
		/**
		 * 角色基础数据 
		 * @return 
		 * 
		 */
		public function get DataOfRole():CJDataOfRole
		{
			return getData("CJDataOfRole") as CJDataOfRole
		}
		
		/**
		 * 自身武将列表
		 * @return 
		 */
		public function get DataOfHeroList():CJDataOfHeroList
		{
			return getData("CJDataOfHeroList") as CJDataOfHeroList;
		}
		
		/**
		 * 阵型信息 
		 */		
		public function get DataOfFormation():CJDataOfFormation
		{
			return getData("CJDataOfFormation") as CJDataOfFormation
		}
		
		/**
		 * 主角技能信息
		 */		
		public function get DataOfUserSkillList():CJDataOfUserSkillList
		{
			return getData("CJDataOfUserSkillList") as CJDataOfUserSkillList
		}
		
		/**
		 * 任务列表
		 */
		public function get DataOfTaskList():CJDataOfTaskList
		{
			return getData("CJDataOfTaskList") as CJDataOfTaskList;
		}
		
		/**
		 * 酒馆信息
		 */		
		public function get DataOfWinebar():CJDataOfWinebar
		{
			return getData("CJDataOfWinebar") as CJDataOfWinebar
		}
		
		/**
		 * 坐骑信息
		 */
		public function get DataOfHorse():CJDataOfHorse
		{
			return getData("CJDataOfHorse") as CJDataOfHorse;
		}
		
		/**
		 * 装备强化信息
		 */
		public function get DataOfEnhanceEquip():CJDataOfEnhanceEquip
		{
			return getData("CJDataOfEnhanceEquip") as CJDataOfEnhanceEquip;
		}
		/**
		 * 坐骑信息
		 */
		public function get DataOfHeroTag():CJDataOfHeroTag
		{
			return getData("CJDataOfHeroTag") as CJDataOfHeroTag;
		}
		
		/**
		 * 武将穿着中的装备
		 * @return 
		 * 
		 */
		public function get DataOfHeroEquip():CJDataOfHeroEquip
		{
			return getData("CJDataOfHeroEquip") as CJDataOfHeroEquip;
		}
		
		public function get DataOfBag():CJDataOfBag
		{
			return getData("CJDataOfBag") as CJDataOfBag;
		}
		
		/**
		 * 装备格子中的装备数据
		 * @return 
		 * 
		 */
		public function get DataOfEquipmentbar():CJDataOfEquipmentbar
		{
			return getData("CJDataOfEquipmentbar") as CJDataOfEquipmentbar;
		}
		
		/**
		 * 灵丸列表信息
		 */
		public function get DataOfTreasureList():CJDataOfTreasureList
		{
			return getData("CJDataOfTreasureList") as CJDataOfTreasureList;
		}
		
		/**
		 * 用户聚灵公共信息
		 */
		public function get DataOfTreasureUserInfo():CJDataOfTreasureUserInfo
		{
			return getData("CJDataOfTreasureUserInfo") as CJDataOfTreasureUserInfo;
		}
		
		/**
		 * 武将灵丸培养信息
		 */
		public function get DataOfHeroTreasureList():CJDataOfHeroTreasureList
		{
			return getData("CJDataOfHeroTreasureList") as CJDataOfHeroTreasureList;
		}
		
		/**
		 * 获取武将星级信息
		 */
		public function get DataOfHeroStar():CJDataOfHeroStar
		{
			return getData("CJDataOfHeroStar") as CJDataOfHeroStar;
		}
		
		/**
		 * 获取武将宝石镶嵌信息
		 */		
		public function get DataOfInlayJewel():CJDataOfInlayJewel
		{
			return getData("CJDataOfInlayJewel") as CJDataOfInlayJewel;
		}
		
		/**
		 * 获取武将洗练信息
		 */		
		public function get DataOfRecast():CJDataOfRecast
		{
			return getData("CJDataOfRecast") as CJDataOfRecast;
		}
		/**
		 * 获取武将星级信息
		 */
		public function get DataOfChat():CJDataOfChat
		{
			return getData("CJDataOfChat") as CJDataOfChat;
		}
		
		/**
		 * 主角升阶
		 * */
		public function get DataOfStageLevel():CJDataOfStageLevel
		{
			return getData("CJDataOfStageLevel") as CJDataOfStageLevel;
		}
		
		public function get DataOfMoneyTreeMine():CJDataOfMoneyTreeMine
		{
			return getData("CJDataOfMoneyTreeMine") as CJDataOfMoneyTreeMine;
		}
		
		public function get DataOfMoneyTreeFriend(): CJDataOfMoneyTreeFriend
		{
			return getData("CJDataOfMoneyTreeFriend") as CJDataOfMoneyTreeFriend;
		}
		
		/**
		 * 阵营数据
		 */ 
		public function get DataOfCamp():CJDataOfCamp
		{
			return getData("CJDataOfCamp") as CJDataOfCamp;
		}
		
		public function get DataOfHeroTrain():CJDataOfHeroTrain
		{
			return getData("CJDataOfHeroTrain") as CJDataOfHeroTrain;
		}
		
		/**
		 * 功能开启数据
		 */
		public function get DataOfFuncList():CJDataOfFunctionList
		{
			return getData("CJDataOfFunctionList") as CJDataOfFunctionList;
		}
		
		public function get DataOfOLReward():CJDataOfOLReward
		{
			return getData("CJDataOfOLReward") as CJDataOfOLReward;
		}
		
		/**
		 * 用户使用偏好
		 */
		public function get DataOfUserHabit():CJDataOfUserHabit
		{
			return getData("CJDataOfUserHabit") as CJDataOfUserHabit;
		}
		public function get DataOfFriends():CJDataOfFriends
		{
			return getData("CJDataOfFriends") as CJDataOfFriends;
		}
		public function get DataOfSetting():CJDataOfSetting
		{
			return getData("CJDataOfSetting") as CJDataOfSetting;
		}
		/**
		 * 助战武将在阵型中的数据
		 */
		public function get DataOfAssistantInFormation():CJDataOfAssistantInFormation
		{
			return getData("CJDataOfAssistantInFormation") as CJDataOfAssistantInFormation;
		}
		/**
		 * 邮件动态数据
		 */		
		public function get DataOfMail():CJDataOfMail
		{
			return getData("CJDataOfMail") as CJDataOfMail;
		}
		
		/**
		 * 公告数据
		 */
		public function get DataOfNotice():CJDataOfNotice
		{
			return getData("CJDataOfNotice") as CJDataOfNotice;
		}
		
		/**
		 * 活跃度数据
		 */
		public function get DataOfActivity():CJDataOfActivity
		{
			return getData("CJDataOfActivity") as CJDataOfActivity;
		}
		
		/**
		 * 活跃度agent
		 */
		public function get activityManager():CJActivityManager
		{
			return getData("CJActivityManager") as CJActivityManager;
		}
		
		public function get DataOfBattlePlayer():CJDataOfBattlePlayer
		{
			return getData("CJDataOfBattlePlayer") as CJDataOfBattlePlayer;
		}
		/**
		 * 排行榜数据
		 */
		public function get DataOfRanklist():CJDataOfRanklist
		{
			return getData("CJDataOfRanklist") as CJDataOfRanklist;
		}
		/**
		 * 新消息提醒数据
		 */
		public function get DataOfNews():CJDataOfNews
		{
			return getData("CJDataOfNews") as CJDataOfNews;
		}
		
		/**
		 * 世界Boss数据
		 */ 
		public function get DataOfWorldBoss():CJDataOfWorldBoss
		{
			return getData("CJDataOfWorldBoss") as CJDataOfWorldBoss;
		}
		
		/** 2013.09.16: vip信息 目前主要是经验值，vip等级还是在CJDataOfRole **/
		public function get DataOfVIP():CJDataOfVIP
		{
			return getData("CJDataOfVIP") as CJDataOfVIP;
		}
		
		public function get DataOfDailyTask():CJDataOfDailyTask
		{
			return getData("CJDataOfDailyTask") as CJDataOfDailyTask;
		}
		public function get DataOfPlatformProducts():CJDataOfPlatformProducts
		{
			return getData("CJDataOfPlatformProducts") as CJDataOfPlatformProducts;
		}
		
		public function get DataOfPileRecharge():CJDataOfPileRecharge
		{
			return getData("CJDataOfPileRecharge") as CJDataOfPileRecharge;
		}
		
		public function get DataOfSingleRecharge():CJDataOfSingleRecharge
		{
			return getData("CJDataOfSingleRecharge") as CJDataOfSingleRecharge;
		}
		
		/**
		 * 夺宝雇佣
		 */ 
		public function get DataOfDuoBaoEmploy():CJDataOfDuoBaoEmploy
		{
			return getData("CJDataOfDuoBaoEmploy") as CJDataOfDuoBaoEmploy;
		}
		
		/**
		 * 奖励
		 */ 
		public function get DataOfReward():CJDataOfReward
		{
			return getData("CJDataOfReward") as CJDataOfReward;
		}
	}
}