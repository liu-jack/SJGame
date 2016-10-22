package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_scene;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnterGuanqia;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.loader.CJLoaderMoudle;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	
	/**
	 * 通关界面
	 * @author yongjun
	 * 
	 */
	public class CJFubenGuankaBoxLayer extends SLayer
	{
		private var _itemList:Vector.<CJGuankaBoxItem>
		private var _gid:int;
		private var _fid:int;
		private var _awardBtn:Button;
		private var xpvalue:Label;
		private var silivervalue:Label;
		private var wuhunvalue:Label;
		private var _selectGuanqiaBtn:Button;//add by zhengzheng
		//宝箱里的道具ID
		private var _data:Vector.<int>;
		//道具信息
		private var _iteminfo:Object
		public function CJFubenGuankaBoxLayer(fid:int,gid:int)
		{
			super();
			_fid = fid;
			_gid = gid;
			_init();
		}
		
		private function _init():void
		{
			_initBg();
			_initContent();
			_initAwardContent();
		}
		
		private function _initBg():void
		{
			var bgImage:SImage = new SImage(SApplication.assets.getTexture("tongguan_dikuang"))
			this.addChild(bgImage);
			
			this.setSize(480,222);
			
			var titleLabel:Label = new Label
				titleLabel.textRendererProperties.textFormat = ConstTextFormat.fubenboxtitletxt
				titleLabel.text = CJLang("FUBEN_BOX_TITLETEXT");
				titleLabel.x = 178;
				titleLabel.y = 15;
			this.addChild(titleLabel)
			
		}
		
		private function _initContent():void
		{
			_itemList = new Vector.<CJGuankaBoxItem>;
			for(var i:int = 0;i<5;i++)
			{
				var item:CJGuankaBoxItem = new CJGuankaBoxItem;
				item.addEventListener(TouchEvent.TOUCH,_touchHandler);
				item.x = 15+i*(76+12);
				item.y = 45;
				_itemList.push(item);
				this.addChild(item);
			}

			//领取奖励
			_awardBtn = CJButtonUtil.createCommonButton(CJLang("FUBEN_AWARDBACKCITY"));
			_awardBtn.addEventListener(Event.TRIGGERED,_btnTouchHandler);
			_awardBtn.height = 37;
			_awardBtn.x = 250;
			_awardBtn.y = 199;
			_awardBtn.visible = false;
			// 全局配置
			var globalConfig:CJDataOfGlobalConfigProperty = CJDataOfGlobalConfigProperty.o;
			// 出现返回关卡按钮需求等级
			var backToGuanqiaNeedLevel:int = int(globalConfig.getData("FUBEN_BACK_TO_GUANQIA_LEVEL"));
			var heroLevel:int = int(CJDataManager.o.DataOfHeroList.getMainHero().level);
			var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben)
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			var vipConf:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(role.vipLevel));
			if (!int(vipConf.fuben_saodang)|| cjdataof.from == ConstFuben.FUBEN_ACT)
			{
				_awardBtn.x = 200;
			}
			else
			{
				//返回关卡
				_selectGuanqiaBtn = CJButtonUtil.createCommonButton(CJLang("FUBEN_HANGUP"));
				_selectGuanqiaBtn.addEventListener(Event.TRIGGERED,_btnSelectGuanqiaHandler);
				_selectGuanqiaBtn.height = 37;
				_selectGuanqiaBtn.x = 150;
				_selectGuanqiaBtn.y = 199;
				_selectGuanqiaBtn.visible = false;
				this.addChild(_selectGuanqiaBtn);//add by zhengzheng
			}
			this.addChild(_awardBtn);
		}
		
		private function _initAwardContent():void
		{
			//经验
			var xp:SImage = new SImage(SApplication.assets.getTexture("fuben_jingyan"));
			xp.x = 70;
			xp.y = 165;
			this.addChild(xp);
			//银两
			var siliver:SImage = new SImage(SApplication.assets.getTexture("fuben_yinliang"));
			siliver.x = 200;
			siliver.y = xp.y;
			this.addChild(siliver);
			//武魂
			var wuhun:SImage = new SImage(SApplication.assets.getTexture("tongguan_wuhun"))
			wuhun.x = 320;
			wuhun.y = xp.y;
			this.addChild(wuhun);//add by zhengzheng
			
			
			xpvalue = new Label;
			xpvalue.textRendererProperties.textFormat = ConstTextFormat.fubenResultText;
			xpvalue.x = xp.x+46;
			xpvalue.y = xp.y+4;
			this.addChild(xpvalue);
			
			silivervalue = new Label;
			silivervalue.textRendererProperties.textFormat = ConstTextFormat.fubenResultText;
			silivervalue.x = siliver.x+46;
			silivervalue.y = xp.y+4;
			this.addChild(silivervalue);
			
			wuhunvalue = new Label;
			wuhunvalue.textRendererProperties.textFormat = ConstTextFormat.fubenResultText;
			wuhunvalue.x = wuhun.x+46;
			wuhunvalue.y = xp.y+4;
			this.addChild(wuhunvalue);
			
		}
		private var _selected:Boolean = false;
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if(touch)
			{
				_selected = true
				if(!_awardBtn.visible)
				{
					_awardBtn.visible = true;
				}
				if(_selectGuanqiaBtn)
				{
					_selectGuanqiaBtn.visible = true;
				}
				_touchDisableAll();
				var item:CJGuankaBoxItem = e.currentTarget as CJGuankaBoxItem;
				//显示出随机出来的道具
				if(this._iteminfo)
				{
					item.itemInfo = this._iteminfo
				}
				SocketCommand_fuben.awarditem(_fid,_gid)
			}
		}
		
		/**
		 * 选择关卡按钮点击
		 * @param e
		 * 
		 */
		private function _btnSelectGuanqiaHandler(e:Event):void
		{
			if(!_selected)
			{
				CJMessageBox(CJLang("FUBEN_GUANKA_SELECTAWARD"))
				return;
			}
			SocketManager.o.callwithRtn(ConstNetCommand.CS_FUBEN_SAODANG,function(message:SocketMessage):void
			{
				var retCode:int = message.retcode;
				var retData:Object = message.retparams;
				switch(retCode)
				{
					case 0:
						var tmplData:Json_item_setting = CJDataOfItemProperty.o.getTemplate(retData["battleawarditemid"]);
						
						var replaceObj:Object = {"exp":retData["award"]["xp"],"silver":retData["award"]["silver"],"forcesoul":retData["award"]["forcesoul"],
												"itemname":CJLang(tmplData.itemname),"itemnum":retData["battleawarditemnum"],"vit":retData["vit"]};
						var battleResultTxt:String = CJLang("FUBEN_SAODANG_RESULTTEXT",replaceObj);
						CJMessageBox(battleResultTxt);
						break;
					case 1:
					case 2:
					case 3:
						break;
					case 4:
						CJMessageBox(CJLang("FUBEN_ENTER_NOVIT"),_exitFbAndBackCity);
						break;
					case 7:
						CJMessageBox(CJLang("FUBEN_SAODANG_RESULTFAIL"),_exitFbAndBackCity);
						break;
					case 8:
						CJMessageBox(CJLang("FUBEN_SAODANG_BAGFULL"),_exitFbAndBackCity);
						break;
						
				}
			},false,_fid,_gid)
//			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_getAwardAndBackToGuanqia);
//			SocketCommand_fuben.getboxaward(_fid,_gid);
		}
		
		/**
		 * 领奖返回关卡
		 * @param e
		 * 
		 */		
		private function _getAwardAndBackToGuanqia(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage
			if(msg.getCommand() == ConstNetCommand.CS_FUBEN_GUANKABOXAWARD)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData,_getAwardAndBackToGuanqia);
				if (msg.retcode == 0)
				{
					var itemid:int = msg.retparams;
					var dataEnterGuanqia:CJDataOfEnterGuanqia = CJDataOfEnterGuanqia.o;
					
					CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
					SApplication.moduleManager.exitModule("CJFubenBattleBaseModule");
					SApplication.moduleManager.enterModule("CJFubenModule",
						{fid:dataEnterGuanqia.fubenId,gid:dataEnterGuanqia.guanqiaId,isBackToGuanqia:true});
//					Starling.juggler.delayCall(SApplication.moduleManager.exitModule,1,"CJFubenBattleBaseModule");
//					
					SocketCommand_item.getBag();
				}
			}
		}
		
		private function _exitFbAndBackCity():void
		{
			back();
			SocketCommand_fuben.exit();
		}
		/**
		 * 领取奖励回城按钮点击
		 * @param e
		 * 
		 */
		private function _btnTouchHandler(e:Event):void
		{
			if(!_selected)
			{
				CJMessageBox(CJLang("FUBEN_GUANKA_SELECTAWARD"))
				return;
			}
			_exitFbAndBackCity();
		}
		
		private function back():void
		{
			var last_mapid:int = (CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole).last_map;
			var prams:Object = {cityid:last_mapid};
			
			SocketCommand_scene.changeScene(last_mapid , function(msg:SocketMessage):void
			{
				var command:String = msg.getCommand();
				if(command == ConstNetCommand.CS_SCENE_CHANGE)
				{
					//成功就回城
					var retCode:int = msg.params(0)
					if(retCode == 0)
					{
						SocketCommand_item.getBag();
						Starling.juggler.delayCall(CJLoaderMoudle.helper_enterMainUI,0.1,prams);
					}
				}
			}
			);
		}
		
		public function set awardData(value:Object):void
		{
			xpvalue.text = value.xp
			silivervalue.text = value.silver;
			if (value.hasOwnProperty("forcesoul"))
			{
				wuhunvalue.text = value.forcesoul;
			}
			else
			{
				wuhunvalue.text = "0";
			}
		}
		
		public function set data(itemObj:Vector.<int>):void
		{
			_data = itemObj;
		}
		public function set iteminfo(info:Object):void
		{
			_iteminfo = info
		}
		/**
		 * 宝箱随机 
		 * @return 
		 * 
		 */		
		private function _randomItem():int
		{
			var len:int = _data.length;
			var index:int = int(Math.random()*len);
			return _data[index];
		}
		/**
		 * 禁止点击，取消事件监听 
		 * 
		 */		
		private function _touchDisableAll():void
		{
			for each(var item:CJGuankaBoxItem in _itemList)
			{
				item.touchable = false;
				item.stopJuggler();
				item.removeEventListener(TouchEvent.TOUCH,_touchHandler);
			}
		}
		
		public function clear():void
		{
			for each(var item:CJGuankaBoxItem in _itemList)
			{
				if(item.hasEventListener(TouchEvent.TOUCH))
				{
					item.removeEventListener(TouchEvent.TOUCH,_touchHandler);
				}
			}
			_awardBtn.removeEventListener(Event.TRIGGERED,_btnTouchHandler);
			this.removeChildren(0,-1,true);
			this.removeFromParent(true);
		}
		
	}
}