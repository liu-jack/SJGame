package SJ.Game.worldboss
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfWorldBossMonsterData;
	import SJ.Game.data.config.CJWorldBossBattleMonsterConfigList;
	import SJ.Game.data.json.Json_world_boss_battle_monster_info;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.display.SLayer;
	
	/**
	 +------------------------------------------------------------------------------
	 * 战斗怪物NPC
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-30 上午11:55:57  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldMonster extends SLayer
	{
		private var _monsterData:CJDataOfWorldBossMonsterData;
		private var _monsterConfig:Json_world_boss_battle_monster_info;
		private var _npc:CJPlayerNpc;
		
		public function CJWorldMonster()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
		}
		
		override protected function draw():void
		{
			super.draw();
			if(!this._monsterData)
			{
				return;
			}
			var data:CJPlayerData = new CJPlayerData();
			_monsterConfig = CJWorldBossBattleMonsterConfigList.o.getMonsterGroupByid(_monsterData.monsterinfoId);
			data.templateId = _monsterConfig.keymonster;
			if(!_npc)
			{
				_npc = new CJPlayerNpc(data , null) ;
				_npc.lodlevel = CJPlayerNpc.LEVEL_LOD_0 | CJPlayerNpc.LEVEL_LOD_1;
				this.addChild(_npc);
				_npc.x = CJDataManager.o.DataOfWorldBoss.bornPoint.x;
				_npc.y = CJDataManager.o.DataOfWorldBoss.bornPoint.y;
				_npc.scaleX = -1;
				_npc.onloadResourceCompleted = function (npc:CJPlayerNpc):void{
					npc.idle();
					npc.run();
				};
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		/**
		 * 设置世界BOSS单个怪的数据
		 */ 
		public function set monsterData(obj:CJDataOfWorldBossMonsterData):void
		{
			if(obj == this._monsterData)
			{
				return;
			}
			this._monsterData = obj;
			this.invalidate();
		}
		
		public function get monsterData():CJDataOfWorldBossMonsterData
		{
			return this._monsterData;
		}
	}
}