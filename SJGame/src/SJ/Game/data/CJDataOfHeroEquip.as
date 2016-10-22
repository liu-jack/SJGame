package SJ.Game.data
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	
	/**
	 * 武将穿着中的装备 
	 * @author longtao
	 * 
	 */
	public class CJDataOfHeroEquip extends SDataBaseRemoteData
	{
		// { heroid:object{装备位置:装备id} }
		private var _dataObj:Object;

		public function CJDataOfHeroEquip()
		{
			super("CJDataOfHeroEquip");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadcomplete);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_hero.get_puton_equip()
			super._onloadFromRemote(params);
		}
		
		
		/**
		 * 重新设置数据
		 * @param rtnData
		 */
		public function resetData(rtnData:Array):void
		{
			_resetData(rtnData);
		}
		
		private function _resetData(rtnData:Array):void
		{
			Assert( rtnData!=null, "CJDataOfHeroEquip._onloadcomplete rtnData==null" );
//			Assert( (rtnData.length)%DATA_GAP==0, "CJDataOfHeroEquip._onloadcomplete rtnData%DATA_GAP" );
//			const DATA_GAP:int = 7;
			_dataObj = new Object();
			var len:int = rtnData.length///DATA_GAP; // 获取有多少组数据
			for(var i:int=0; i<len; ++i )
			{
				var arr:Array = rtnData[i];
				var obj:Object = new Object;
				obj.heroid = arr[0];
				obj[ConstItem.SCONST_ITEM_POSITION_WEAPON] 	= arr[1];
				obj[ConstItem.SCONST_ITEM_POSITION_HEAD] 	= arr[2];
				obj[ConstItem.SCONST_ITEM_POSITION_CLOAK] 	= arr[3];
				obj[ConstItem.SCONST_ITEM_POSITION_ARMOR] 	= arr[4];
				obj[ConstItem.SCONST_ITEM_POSITION_SHOE] = arr[5];
				obj[ConstItem.SCONST_ITEM_POSITION_BELT] = arr[6];
				_dataObj[obj.heroid] = obj;
			}
		}
		
		/**
		 * 获取武将穿着的装备
		 * { string(heroid):object{装备位置:装备id} }
		 */
		public function get heroEquipObj():Object
		{
			return _dataObj;
		}
		
		public function set heroEquipObj(value:Object):void
		{
			_dataObj = value;
		}
		
		/**
		 * 获取单个武将装备信息
		 * @param heroid 武将id
		 * @param d		  错误信息   默认为false
		 * @return object{装备位置:装备id}
		 * 
		 */
		public function getOneHeroEquipObj(heroid:String, d:*=false):Object
		{
			if (null == _dataObj[heroid])
				return d;
			
			return _dataObj[heroid]
		}
		
		/**
		 * 判断单个武将身上是否穿戴装备
		 * @param heroid 武将id
		 * @return true ：未穿戴装备
		 * 
		 */
		public function isHeroEquipEmpty(heroid:String):Boolean
		{
			if (null == _dataObj[heroid] || (null != _dataObj[heroid] && 
				int(_dataObj[heroid][1]) == 0 && int(_dataObj[heroid][2]) == 0 && 
				int(_dataObj[heroid][4]) == 0 && int(_dataObj[heroid][8]) == 0 && 
				int(_dataObj[heroid][16]) == 0 && int(_dataObj[heroid][32]) == 0))
				return true;
			else
			{
				return false;
			}
		}
		/**
		 * 增加新武将装备信息
		 * @param heroId	武将id
		 * 
		 */		
		public function addNewHeroEquipData(heroId:String):void
		{
			var obj:Object = new Object;
			obj.heroid = heroId;
			obj[ConstItem.SCONST_ITEM_POSITION_WEAPON] = "0";
			obj[ConstItem.SCONST_ITEM_POSITION_HEAD] = "0";
			obj[ConstItem.SCONST_ITEM_POSITION_CLOAK] = "0";
			obj[ConstItem.SCONST_ITEM_POSITION_ARMOR] = "0";
			obj[ConstItem.SCONST_ITEM_POSITION_SHOE] = "0";
			obj[ConstItem.SCONST_ITEM_POSITION_BELT] = "0";
			_dataObj[obj.heroid] = obj;
		}
		
		/**
		 * 加载武将装备数据
		 * @param e
		 * 
		 */
		protected function _onloadcomplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_GET_PUTON_EQUIP)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Array = message.retparams;
				_resetData(rtnObject);
				this._onloadFromRemoteComplete();
				
				// 派发事件穿脱装备使用	add by longtao
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHANGE_EQUIP_COMPLETE, false, {command:ConstNetCommand.CS_HERO_GET_PUTON_EQUIP});
				// add by longtao end
			}
		}
	}
}