package SJ.Game.data
{
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.SStringUtils;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;

	/**
	 * @name 传功阵型信息
	 * @author  zhengzheng   
	 */
	public class CJDataOfTransferAbility extends SDataBase
	{
		public static const DATA_KEY:String = "currentTransFormationData";
		/*阵型的武将数量*/
		public static const HERO_NUM_IN_FORMATION:int = 2;
		/*位置0 - 1 存储的武将heroid*/
		private var _pos0:String = "-1";
		private var _pos1:String = "-1";
		private var _heroList:CJDataOfHeroList;
		private var _npcDict:Dictionary = new Dictionary();
		/*阵型改变事件*/
		public static const TRANS_FORMATION_DATA_CHANGED:String = "TRANS_FORMATION_DATA_CHANGED";
		/*所有的阵型数据*/
		private var _dataList:Array = new Array();
		
		public function CJDataOfTransferAbility()
		{
			super("CJDataOfTransferAbility");
			this.setData(DATA_KEY , dataList);
		}

		private static var _o:CJDataOfTransferAbility;
		public static function get o():CJDataOfTransferAbility
		{
			if(_o == null)
			{
				_o = new CJDataOfTransferAbility();
			}
			return _o;
		}
		/**
		 * 武将面板拖过来替换武将
		 */		
		private function _handleChangeHero(heroId:String, posTo:int, posFrom:int):void
		{
			var dataList:Array = this.getData(DATA_KEY);
			var heroIdInPosto:String = this["pos"+posTo];
			this["pos"+posTo] = heroId;
			this.setData(DATA_KEY , dataList);
			this.dispatchEventWith(TRANS_FORMATION_DATA_CHANGED , false , {"posTo":posTo, "posFrom":posFrom});
		}
		
		/**
		 * 阵型上拖拽互换位置
		 */		
		private function _handleSwapHero(heroId:String, posTo:int, posFrom:int):void
		{
			var dataList:Array = this.getData(DATA_KEY);
			var toHeroId:String = "";
			toHeroId = dataList[posTo];
			this["pos"+posTo] = heroId;
			this["pos"+posFrom] = toHeroId;
			this.setData(DATA_KEY , dataList);
			this.dispatchEventWith(TRANS_FORMATION_DATA_CHANGED , false , {"posTo":posTo, "posFrom":posFrom});
		}
		
		/**
		 * 删除武将
		 */		
		private function _handleDeleteHero(heroId:String , posTo:int , posFrom:int = -1):void
		{
			var dataList:Array = this.getData(DATA_KEY);
			this["pos"+posFrom] = "";
			this.setData(DATA_KEY , dataList);
			this.dispatchEventWith(TRANS_FORMATION_DATA_CHANGED , false , {"heroId":heroId, "posTo":posTo, "posFrom":posFrom});
		}
		
		/**
		 *  当前出征武将列表
		 */		
		public function get currentFormationData():Array
		{
			return _dataList;
		}
		
		/**
		 *  当前添加武将个数
		 */		
		public function get hasAddHeroNum():int
		{
			var count:int;
			for (var i:int = 0; i < _dataList.length; i++) 
			{
				if (!SStringUtils.isEmpty(_dataList[i]))
				{
					count++;
				}
			}
			return count;
		}
		/**
		 * 判断英雄是否已经被放置 
		 * @param heroId
		 */		
		public function isHeroPlaced(heroId:String):Boolean
		{
			for (var i:int = 0; i < HERO_NUM_IN_FORMATION; i++) 
			{
				if(this["_pos"+i] == heroId)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 保存阵型数据 支持武将互相换位置
		 * @param posTo heroid 需要放过去的位置 -1 表示要移除
		 * @param posFrom heroid 从哪放过来的 -1 表示放过来的武将原来没有位置
		 * @param heroId 被拖拽的武将id
		 */		
		public function saveFormation(heroId:String , posTo:int , posFrom:int = -1):void
		{
			//移除操作
			if(posTo == -1)
			{
				this._handleDeleteHero(heroId , posTo , posFrom);
			}
				//交换位置操作
			else if(posFrom != -1 && posTo != -1)
			{
				this._handleSwapHero(heroId , posTo , posFrom);
			}
				//武将面板拖拽替换武将操作
			else if(posFrom == -1 && posTo != -1)
			{
				this._handleChangeHero(heroId , posTo , posFrom);
			}
			else
			{
				Assert(false , "非法的传功移动武将操作");
			}
		}
		/**
		 * 根据位置获取武将的heroid
		 * @param pos
		 */		
		public function getHeroIdByPos(pos:int):String
		{
			return this["_pos"+pos];
		}
		
		/**
		 * 根据武将id获取对应位置
		 * @param pos -1 没有对应的位置
		 */		
		public function getPosidByHeroId(heroId:String):int
		{
			for (var i:int = 0; i < HERO_NUM_IN_FORMATION; i++) 
			{
				if(int(heroId) != 0 && this["_pos"+i] == heroId)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 添加npc
		 * @param heroid
		 * @param npc
		 */		
		public function addNpc(heroid:String , npc:CJPlayerNpc):void
		{
			if(this._npcDict.hasOwnProperty(heroid))
			{
				return;
			}
			npc.alpha = 1;
			this._npcDict[heroid] = npc;
		}
		
		/**
		 * 删除npc
		 * @param heroid
		 */		
		public function delNpc(heroid:String):void
		{
			if(_npcDict[heroid])
			{
				delete _npcDict[heroid];
			}
		}
		/**
		 * 获取npc
		 * @param heroid
		 */		
		public function getNpc(heroid:String):CJPlayerNpc
		{
			if(int(heroid) != 0 && this._npcDict.hasOwnProperty(heroid))
			{
				return this._npcDict[heroid];
			}
			return null;
		}
		/**
		 * 清除数据
		 * 
		 */		
		public function dispose():void
		{
			this._npcDict = new Dictionary();
			for (var i:int = 0; i < HERO_NUM_IN_FORMATION; i++) 
			{
				this["_pos"+i] = "";
				_dataList[i] = "";
			}
		}
		
		public function get pos0():String
		{
			return _pos0;
		}
		
		public function set pos0(value:String):void
		{
			_pos0 = value;
			_dataList[0] = _pos0;
		}

		public function get pos1():String
		{
			return _pos1;
		}
		
		public function set pos1(value:String):void
		{
			_pos1 = value;
			_dataList[1] = _pos1;
		}

		public function get dataList():Array
		{
			return _dataList;
		}

	}
}