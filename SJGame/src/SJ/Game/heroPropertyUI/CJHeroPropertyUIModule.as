package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.events.Event;
	
	/**
	 * 武将属性界面模块
	 * @author longtao
	 * 
	 */
	
	public class CJHeroPropertyUIModule extends CJModulePopupBase
	{
		private var _Layer:CJHeroBaseUI;
		// 展示数据是否加载完成
		private var _isShowInfoOK:Boolean = false;
		// 界面数据是否加载完成
		private var _isLoadingOK:Boolean = false;
		// 要展示的userid，如果为自己该值为null
		private var _otherUserid:String = null;
		// 展示其他玩家武将信息的数据
		private var _data:Object;
		//标识是不是通过好友申请的查看进入武将界面
		private var _requestid:String;
		
		public function CJHeroPropertyUIModule()
		{
			super("CJHeroPropertyUIModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
				ConstResource.sResXmlItem_1
				];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
//			params = "144118839034833409"
			super._onEnter(params);
			
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("resouce_HeroPropertyUI", getPreloadResource()); 
			
			
			if (params && params.hasOwnProperty("uid"))
			{
				_otherUserid = String(params.uid);
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onShowInfo);
				SocketCommand_hero.getShowInfo(String(params.uid));
			}
			else
				_isShowInfoOK = true;
			
			if (params && params.hasOwnProperty("requestid"))
			{
				_requestid = params.requestid;
			}
			else
			{
				_requestid = null;
			}
			AssetManagerUtil.o.loadQueue(_onLoad);
		}
		
		private function _onLoad(r:Number):void
		{
			CJLoadingLayer.loadingprogress = r;
			
			if(r == 1)
			{
				_isLoadingOK = true;
				_Completed();
			}
		}
		
		private function _onShowInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var retCode:String = message.getCommand();
			
			if (retCode == ConstNetCommand.CS_HERO_GET_SHOW_INFO)
			{
				// 格式化数据
				_initData(message.retparams[0]);
				
				_isShowInfoOK = true;
				_Completed();
			}

		}
		
		// 格式化数据
		private function _initData(obj:Object):void
		{
			_data = new Object;
			// 名称
			_data.rolename = obj.rolename;
			// 是否在线
			_data.isOnline = obj.isOnline;
			// 坐骑
			_data.horseInfo = obj.horseInfo;
			// 武将列表信息
			_data.heroListInfo = obj.heroListInfo;
			// 穿着的装备id
			_data.heroEquipment = new Object;
			// 武星
			_data.forcestar = obj.forcestar;
			var temp:Object;
			var td:Object
			for each(temp in obj.heroEquipment)
			{
				td = new Object;
				td.heroid = temp[0];
				td[1] 	= temp[1];
				td[2] 	= temp[2];
				td[4] 	= temp[3];
				td[8] 	= temp[4];
				td[16] = temp[5];
				td[32] = temp[6];
				_data.heroEquipment[td.heroid] = td
			}
			// 穿着中的装备信息
			_data.equipmentbar = new Object;
			var arr:Array = obj.equipmentbar as Array;
			var i:int = 0;
			for (; i<arr.length; ++i)
				_data.equipmentbar[arr[i].itemid] = arr[i];
			
			// 宝石镶嵌
			_data.inlayData = new Object;
			arr = obj.inlayData as Array;
			for (i=0; i<arr.length; ++i)
				_data.inlayData[arr[i].itemid] = arr[i];
			
			// 宝石镶嵌道具数据
			_data.heroInlay = obj.heroInlay;
			
			_data.playerEnhanceEquip = obj.playerEnhanceEquip;
			
			// 对方是否为自己的好友
			_data.isfriend = obj.isfriend;
			
			// 主角当前学到的技能
			_data.skillData = obj.skillData;
			//其他玩家的uid
			_data.otherUserid = _otherUserid;
			//好友申请的id
			_data.requestid = _requestid;
		}
		
		private function _Completed():void
		{
			if ( !_isShowInfoOK || !_isLoadingOK )
				return;
			
			CJLoadingLayer.close();
			
			var s:XML = AssetManagerUtil.o.getObject("heroPropertyUILayout.sxml") as XML;
			if (SStringUtils.isEmpty(_otherUserid)) // 自己
				_Layer = SFeatherControlUtils.o.genLayoutFromXML(s,CJHeroSelfInfoUI) as CJHeroSelfInfoUI;
			else
			{
				_Layer = SFeatherControlUtils.o.genLayoutFromXML(s,CJHeroOtherInfoUI) as CJHeroOtherInfoUI;
				(_Layer as CJHeroOtherInfoUI).data = _data;
			}
				
			_Layer.addAllListener(); // 添加所有监听
			CJLayerManager.o.addToModuleLayerFadein(_Layer);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			_clearAll();
		}
		
		private function _clearAll():void
		{
			_isShowInfoOK = false;
			_isLoadingOK = false;
			_otherUserid = null;
			_data = null;
		}
		
		
		
		override protected function _onExit(params:Object=null):void
		{
			_Layer.removeAllListener(); // 移除所有监听
			CJLayerManager.o.removeFromLayerFadeout(_Layer);
			_Layer = null;
			_data = null;
			// 释放资源
			AssetManagerUtil.o.disposeAssetsByGroup("resouce_HeroPropertyUI");
			// TODO Auto Generated method stub
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
	}
}