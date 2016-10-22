package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_enhance;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 装备强化数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfEnhanceEquip extends SDataBaseRemoteData
	{
		public function CJDataOfEnhanceEquip()
		{
			super("CJDataOfEnhanceEquip");
			_init()
		}
		
		private static var _o:CJDataOfEnhanceEquip;
		public static function get o():CJDataOfEnhanceEquip
		{
			if(_o == null)
			{
				_o = new CJDataOfEnhanceEquip();
			}
			return _o;
		}
		
		private function _init():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadEnhanceEquip);
		}
		
		/**
		 * 加载装备强化
		 * @param e
		 * 
		 */
		protected function _onloadEnhanceEquip(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ENHANCE_GETEQUIPENHANCEINFO)
			{
				return;
			}
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				_initEnhanceEquipData(rtnObject);
				this._onloadFromRemoteComplete();
			}
			
		}
		
		/**
		 * 设置装备强化数据
		 * @param obj
		 * 
		 */		
		private function _initEnhanceEquipData(obj:Object):void
		{
			var enhanceHero:CJDataOfEnhanceHero;
			for each(var data:Object in obj)
			{
//				for ( var key:String in retItem)
//				{
//					itemData.setData(key, retItem[key]);
//				}
				enhanceHero = new CJDataOfEnhanceHero();
				enhanceHero.heroid = String(data.heroid);
				enhanceHero.weapon = parseInt(data.weapon);
				enhanceHero.head = parseInt(data.helmet);
				enhanceHero.cloak = parseInt(data.cloak);
				enhanceHero.armour = parseInt(data.armour);
				enhanceHero.shoe = parseInt(data.shoes);
				enhanceHero.belt = parseInt(data.belt);
				
				this.setData(enhanceHero.heroid, enhanceHero);
			}
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_enhance.getEquipEnhanceInfo();
			super._onloadFromRemote(params);
		}
		
		/**
		 * 获取武将强化信息
		 * @param heroId	武将id
		 * @return 若无强化信息返回null
		 * 
		 */
		public function getHeroEnhanceInfo(heroId:String) : CJDataOfEnhanceHero
		{
			return this.getData(heroId);
		}
		
		/**
		 * 根据武将id增加武将装备强化信息
		 * @param heroId	武将id
		 * @return 如果武将id对应数据存在则不增加数据返回false，否则增加装备强化初始值并返回true
		 * 
		 */		
		public function addNewHeroEnhance(heroId:String):Boolean
		{
			if (this.getData(heroId) != null)
			{
				return false;
			}
			var data:CJDataOfEnhanceHero = new CJDataOfEnhanceHero();
			data.heroid = heroId;
			data.weapon = 0;
			data.head = 0;
			data.armour = 0;
			data.cloak = 0;
			data.shoe = 0;
			data.belt = 0;
			this.setData(heroId, data);
			return true;
		}
	}
}