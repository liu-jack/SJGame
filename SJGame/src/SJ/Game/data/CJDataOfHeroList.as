package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_formation;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;
	
	import starling.events.Event;
	
	/**
	 * 保存玩家所有武将列表
	 * 
	 * @example： 
	 * 武将列表
	 * var herolistdata:CJDataOfHeroList = CJDataManager.o.getData( "CJDataOfHeroList" ) as CJDataOfHeroList;
	 * var herolist:Dictionary = herolistdata.herolist;
	 * 
	 * 初始化武将列表
	 * var herolistdata:CJDataOfHeroList = CJDataManager.o.getData( "CJDataOfHeroList" ) as CJDataOfHeroList;
	 * herolistdata.initHeroList( obj )
	 * 
	 * 添加武将
	 * var herolistdata:CJDataOfHeroList = CJDataManager.o.getData( "CJDataOfHeroList" ) as CJDataOfHeroList;
	 * herolistdata.addHero( heroid, heroInfo )
	 * 
	 * 删除武将
	 * var herolistdata:CJDataOfHeroList = CJDataManager.o.getData( "CJDataOfHeroList" ) as CJDataOfHeroList;
	 * herolistdata.delHero( heroid )
	 * 
	 * @author longtao
	 * 
	 */
	public class CJDataOfHeroList extends SDataBaseRemoteData
	{
		/**
		 * 主将信息
		 */
		private var _mainHeroInfo:CJDataOfHero;
		/**
		 * 武将个数（包括主将）
		 * */
		private var _heroCount:uint = 0;
		/*新招武将的容器*/
		private var _newHeroList:Dictionary = new Dictionary();
		
		public function CJDataOfHeroList()
		{
			super("CJDataOfHeroList");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadHeroList);
		}
		
		/**
		 * 初始化武将列表
		 * @param obj 武将列表
		 * 
		 */
		private function _initHeroList( obj:Object ):void
		{
			_heroCount = 0;
			var dict:Dictionary = new Dictionary;
			var heroInfo:CJDataOfHero;
			var temp:Object;
			for (var key:String in obj)
			{
				temp = obj[key];
				heroInfo = _createheroInfo(temp.heroid, int(temp.templateid));
				heroInfo.heroid 	= temp.heroid;
				heroInfo.templateid = temp.templateid;
				heroInfo.level 		= temp.level;
				heroInfo.stagelevel = temp.stagelevel;
				heroInfo.currentexp = temp.currentexp;
				heroInfo.userid		= temp.userid;
				heroInfo.heroProperty = CJDataOfHeroPropertyList.o.getProperty(int(heroInfo.templateid));
				heroInfo.currentskill = temp.currentskill;
				heroInfo.formationindex = temp.formationindex;
				heroInfo.currenttalent = temp.currenttalent;
				heroInfo.starlevel = temp.starlevel;
				heroInfo.battleeffectsum = temp.battleeffectsum;
				// 添加武将
				dict[heroInfo.heroid] = heroInfo;
				if (heroInfo.isRole)
				{
					_mainHeroInfo = heroInfo;
				}
			}
			// 设置herolist数据
			herolist = dict;
		}
		
		/**
		 * 创建heroInfo实体
		 * @param heroid		武将id
		 * @param templateid	武将模板id
		 * @return 
		 * 
		 */
		private function _createheroInfo( heroid:String, templateid:int ) : CJDataOfHero
		{
			var heroInfo:CJDataOfHero = new CJDataOfHero;
			heroInfo.heroid 	= heroid;
			heroInfo.templateid = templateid;
			heroInfo.heroProperty = CJDataOfHeroPropertyList.o.getProperty(int(heroInfo.templateid));
			heroInfo.level 		= heroInfo.heroProperty.level.toString();
			heroInfo.stagelevel = "1";
			heroInfo.currentexp = "0";
			heroInfo.userid		= CJDataManager.o.DataOfAccounts.userID;
			heroInfo.currentskill = heroInfo.heroProperty.skill1==null ? "" : heroInfo.heroProperty.skill1;
			heroInfo.formationindex = "-1"//temp.formationindex;
			heroInfo.currenttalent = heroInfo.heroProperty.genius_0==null ? "" : heroInfo.heroProperty.genius_0;
			heroInfo.starlevel = "0";
			
			// 更新数量
			_heroCount++;
			
			return heroInfo;
		}
		
		/**
		 * 添加一个武将
		 * @param heroid	武将id
		 * @param heroInfo	武将信息
		 * 
		 */
		public function addHero( heroid:String, templateid:int ):void
		{
			herolist[heroid] = _createheroInfo(heroid, templateid);
			_newHeroList[heroid] = templateid;
		}
		
		/**
		 * 删除一个武将 
		 * @param heroid	武将id
		 * 
		 */
		public function delHero( heroid:String ):void
		{
			if (herolist[ heroid ] != null)
				_heroCount--; // 更新武将数量
			
			delete herolist[ heroid ];
		}
		
		/**
		 * 获取武将列表<\heroid, heroInfo\>
		 * @notice 不要直接对字典进行添加删除元素操作，请直接调用addHero、delHero函数
		 */
		public function get herolist():Dictionary
		{
			return getData("herolist");
		}
		
		/**
		 * 获取单个英雄的信息
		 */		
		public function getHero(heroId:String):CJDataOfHero
		{
			if(herolist.hasOwnProperty(heroId))
			{
				return herolist[heroId];
			}
			return null;
		}
		
		/**
		 * 获取主将数据CJDataOfHero
		 * @return 
		 * 
		 */
		public function getMainHero():CJDataOfHero
		{
			return _mainHeroInfo;
		}
		
		/**
		 * add by caihua
		 * 获取主角的heroid 
		 * @return heroid
		 */		
		public function getRoleId():String
		{
			var dic:Dictionary = this.herolist;
			if(dic != null)
			{
				for(var heroId:String in dic)
				{
					if((dic[heroId] as CJDataOfHero).isRole)
					{
						return heroId;
					}
				}
			}
			return "";
		}
		
		/**
		 * 检测某个Heroid是否是主角
		 * @param heroId
		 */		
		public function checkIsRole(heroId:String):Boolean
		{
			if(int(heroId) == 0 || int(heroId) == -1)
			{
				return false;
			}
			var dic:Dictionary = this.herolist;
			if(dic != null)
			{
				if((dic[heroId] as CJDataOfHero).isRole)
				{
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * 获取武将数量（包括主将在内)
		 * @return 
		 */
		public function get heroCount():uint
		{
			return _heroCount;
		}
		
		
		/**
		 * 设置武将列表
		 * @note 仅在初始化时调用，其他情况不推荐直接调用
		 */
		public function set herolist(value:Dictionary):void
		{
			setData("herolist", value);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_hero.get_heros();
			super._onloadFromRemote(params);
		}
			
		/**
		 * 加载武将数据
		 * @param e
		 * 
		 */
		protected function _onloadHeroList(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_GET_HEROS)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				_initHeroList(rtnObject);
				
				CJDataManager.o.DataOfNews.setNewsData();
				
				this._onloadFromRemoteComplete();
			}
		}

		/**
		 * 是否是新武将
		 */ 
		public function isNewHero(heroid:String):Boolean
		{
			return this._newHeroList.hasOwnProperty(heroid);
		}
	}
}