package SJ.Game.worldboss
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfWorldBossMonsterData;
	
	import engine_starling.data.SDataBase;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss怪物管理器 ，控制怪物的出现，消失
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-18 下午6:48:16  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossMonsterManager extends SDataBase
	{
		private var _monsterList:Vector.<CJWorldMonster> = new Vector.<CJWorldMonster>();
		
		public function CJWorldBossMonsterManager()
		{
			super("CJWorldBossMonsterManager");
		}
		
		/**
		 * 创建一个怪物
		 */ 
		private function _createNewMonster(monsterData:CJDataOfWorldBossMonsterData):void
		{
			var monster:CJWorldMonster = new CJWorldMonster();
			monster.monsterData = monsterData;
			_monsterList.push(monster);
		}
		
		public function createAllMonster():void
		{
			var monsterList:Array = CJDataManager.o.DataOfWorldBoss.monsterDataList;
			var length:int = monsterList.length;
//			for(var i:int = 0 ; i< length ; i++)
//			{
//				_createNewMonster();
//			}
			
			var monsterData:CJDataOfWorldBossMonsterData = new CJDataOfWorldBossMonsterData();
			monsterData.monsterinfoId = 1000;
			monsterData.lefthp = 5000;
			monsterData.leftmovetime = 20;
			monsterData.totalmovetime = 20;
			_createNewMonster(monsterData);
		}
			
		/**
		 * 销毁一个怪物
		 */ 	
		private function _disposeMonster(monsterinfoid:int):void
		{
			
		}

		public function get monsterList():Vector.<CJWorldMonster>
		{
			return _monsterList;
		}

	}
}
