package SJ.Game.player
{
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.data.SDataBase;

	/**
	 * 玩家数据类 
	 * @author caihua
	 * 
	 */
	public class CJPlayerData extends SDataBase
	{
		public function CJPlayerData()
		{
			super("CJPlayerData");
		}
		
		private var _templateId:int;
		private var _heroConfig:CJDataHeroProperty;
		private var _heroBattleConfig:Json_hero_battle_propertys;
		
		private var _level:int = 1;
		private var _heroId:String;

		
		public function get heroConfig():CJDataHeroProperty
		{
			
			return _heroConfig;
		}
		public function get heroBattleConfig():Json_hero_battle_propertys
		{
			return _heroBattleConfig;
		}

		/**
		 * 等级 最小为1
		 */
		public function get level():int
		{
			return _level;
		}

		/**
		 * @private
		 */
		public function set level(value:int):void
		{
			_level = value;
		}

		/**
		 * 武将ID 
		 */
		public function get templateId():int
		{
			return _templateId;
		}

		/**
		 * @private
		 */
		public function set templateId(value:int):void
		{
			_templateId = value;
			
			_heroConfig = CJDataOfHeroPropertyList.o.getProperty(_templateId);
			_heroBattleConfig = CJDataOfHeroPropertyList.o.getBattleProperty(_heroConfig.resourceid);
			
			_displayName =  CJLang("NPC_NAME_" + _templateId);
			
			_speed = _heroConfig.speed
//			_compareBasePropertys();
		}

		private var _displayName:String = CJLang("PLAYER_2B_YOUTH");

		/**
		 * 显示名称 
		 */
		public function get displayName():String
		{
			return _displayName;
		}

		/**
		 * @private
		 */
		public function set displayName(value:String):void
		{
			_displayName = value;
		}

		
		private var _name:String;

		/**
		 * 名字 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}



		/**
		 * 速度 0-20000 
		 */
		private var _speed:Number
		
		public function get speed():Number
		{
			return 1200;
		}
		/**
		 * 设置速度，副本整体移动需要，需设置为相同的速度 
		 * @return 
		 * 
		 */		
		public function set speed(value:Number):void
		{
//			_speed = value
			_speed = 500;
		}
		/**
		 * NPC类型 
		 * 0玩家,1武将,2Boss
		 */		
		public function get playerType():int
		{
			return _heroConfig.type;
		}
		
		private var _isPlayer:Boolean;

		/**
		 * 是否是玩家 
		 */
		public function get isPlayer():Boolean
		{
			return _isPlayer;
		}

		/**
		 * @private
		 */
		public function set isPlayer(value:Boolean):void
		{
			_isPlayer = value;
		}
	
		private var _formationId:int = 0;

		/**
		 *  阵型索引,
		 */
		public function get formationId():int
		{
			return _formationId;
		}

		/**
		 * @private
		 */
		public function set formationId(value:int):void
		{
			_formationId = value;
		}

		
		private var _locationindex:int;

		/**
		 * 站位索引 
		 */
		public function get formationindex():int
		{
			return _locationindex;
		}

		/**
		 * @private
		 */
		public function set formationindex(value:int):void
		{
			_locationindex = value;
		}

		/**
		 * 动画文件名称,这个属性先放这里 不一定合适 
		 */
		public function get playerAnim():String
		{
			return _heroBattleConfig.anim;
		}
		public function get playerTextureName():String
		{
			return _heroBattleConfig.texturename;
		}
		
		private var _isSelf:Boolean = true;

		/**
		 * 是否是自己人,只在战斗的时候有用.. 
		 */
		public function get isSelf():Boolean
		{
			return _isSelf;
		}

		/**
		 * @private
		 */
		public function set isSelf(value:Boolean):void
		{
			_isSelf = value;
			setData("isSelf",value);
		}
		
		/**
		 * 计算属性 
		 * 
		 */
//		private function _compareBasePropertys():void
//		{
//			setData('hp',_heroConfig.hp) + (_level - 1) * _heroConfig.hpgrow;
//		}
		private var _hp_max:int;

		/**
		 * 最大血量 
		 */
		public function get hp_max():int
		{
			return _hp_max;
		}

		/**
		 * @private
		 */
		public function set hp_max(value:int):void
		{
			_hp_max = value;
		}

		/**
		 * 当前血量 
		 * @return 
		 * 
		 */
		public function get hp():int
		{
			return getData('hp');
		}
		
		public function set hp(value:int):void
		{
			setData('hp',value);
		}
		public function isDead():Boolean
		{
			return (hp<= 0);
		}
		
		public function skill1():int
		{
			return _heroConfig.skill1;
		}
//		public function skill2():int
//		{
//			return _heroConfig.skill2 ?_heroConfig.skill2:-1;
//		}
		
		


		public function get heroId():String
		{
			return _heroId;
		}

		public function set heroId(value:String):void
		{
			_heroId = value;
		}
		
		private var _battleeffect:int = 0;

		/**
		 * 是否是超级武将,5伍星 
		 */
		public function get super_hero():Boolean
		{
			return _super_hero;
		}

		/**
		 * @private
		 */
		public function set super_hero(value:Boolean):void
		{
			_super_hero = value;
		}

		/**
		 * 战斗力 
		 */
		public function get battleeffect():int
		{
			return _battleeffect;
		}

		/**
		 * @private
		 */
		public function set battleeffect(value:int):void
		{
			_battleeffect = value;
		}

		/**
		 * 武将星级 
		 */
		public function get herostar():int
		{
			return _herostar;
		}

		/**
		 * @private
		 */
		public function set herostar(value:int):void
		{
			_herostar = value;
		}

		/**
		 * 技能开始回合数
		 */
		public function get skillstartround():int
		{
			return _skillstartround;
		}

		/**
		 * @private
		 */
		public function set skillstartround(value:int):void
		{
			_skillstartround = value;
		}

		/**
		 * 技能回合数 
		 */
		public function get skilleachround():int
		{
			return _skilleachround;
		}

		/**
		 * @private
		 */
		public function set skilleachround(value:int):void
		{
			_skilleachround = value;
		}

		/**
		 * 当前使用技能 
		 */
		public function get skillcurrentid():int
		{
			return _skillcurrentid;
		}

		/**
		 * @private
		 */
		public function set skillcurrentid(value:int):void
		{
			_skillcurrentid = value;
		}

		/**
		 * 是否是怪物 
		 * @return 
		 * 
		 */
		public function get isMonster():Boolean
		{
			if (parseInt(heroConfig.type) == 2 ||level == 0)
			{
				return true;
			}
			return false;
		}
		private var _herostar:int = 0;
		
		
		private var _super_hero:Boolean = false;
		
		private var _skillcurrentid:int;
		private var _skillstartround:int = 0;
		private var _skilleachround:int = 0;

		
	}
}