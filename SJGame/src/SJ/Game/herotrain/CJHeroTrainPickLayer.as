package SJ.Game.herotrain
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstHeroTrain;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_heroTrain;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.layer.CJMsgBoxSilverNotEnough;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 武将训练选中
	 * @author longtao
	 * 
	 */
	public class CJHeroTrainPickLayer extends SLayer
	{
		private var _labelTitle:Label
		/**  标题 **/
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private **/
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
		}
		private var _btnClose:Button
		/**  关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		private var _layerBG:SLayer
		/**  背景 **/
		public function get layerBG():SLayer
		{
			return _layerBG;
		}
		/** @private **/
		public function set layerBG(value:SLayer):void
		{
			_layerBG = value;
		}
		private var _panelBG:SLayer
		/**  面板底框 **/
		public function get panelBG():SLayer
		{
			return _panelBG;
		}
		/** @private **/
		public function set panelBG(value:SLayer):void
		{
			_panelBG = value;
		}
		private var _insideBG:SLayer
		/**  内框 **/
		public function get insideBG():SLayer
		{
			return _insideBG;
		}
		/** @private **/
		public function set insideBG(value:SLayer):void
		{
			_insideBG = value;
		}
		private var _tagBG:ImageLoader
		/**  标签底图 **/
		public function get tagBG():ImageLoader
		{
			return _tagBG;
		}
		/** @private **/
		public function set tagBG(value:ImageLoader):void
		{
			_tagBG = value;
		}
		private var _heroname:Label
		/**  武将名称 **/
		public function get heroname():Label
		{
			return _heroname;
		}
		/** @private **/
		public function set heroname(value:Label):void
		{
			_heroname = value;
		}
		private var _herolevel:Label
		/**  等级 **/
		public function get herolevel():Label
		{
			return _herolevel;
		}
		/** @private **/
		public function set herolevel(value:Label):void
		{
			_herolevel = value;
		}
		private var _cooltime:Label
		/**  冷却时间 **/
		public function get cooltime():Label
		{
			return _cooltime;
		}
		/** @private **/
		public function set cooltime(value:Label):void
		{
			_cooltime = value;
		}
		private var _state:Label
		/**  状态 **/
		public function get state():Label
		{
			return _state;
		}
		/** @private **/
		public function set state(value:Label):void
		{
			_state = value;
		}
		private var _pickLayer:SLayer
		/**  训练选择 **/
		public function get pickLayer():SLayer
		{
			return _pickLayer;
		}
		/** @private **/
		public function set pickLayer(value:SLayer):void
		{
			_pickLayer = value;
		}
		private var _btnAllPick:Button
		/**  全选 **/
		public function get btnAllPick():Button
		{
			return _btnAllPick;
		}
		/** @private **/
		public function set btnAllPick(value:Button):void
		{
			_btnAllPick = value;
		}
		private var _btnTrainCommon:Button
		/**  普通训练 **/
		public function get btnTrainCommon():Button
		{
			return _btnTrainCommon;
		}
		/** @private **/
		public function set btnTrainCommon(value:Button):void
		{
			_btnTrainCommon = value;
		}
		private var _btnTrainDouble:Button
		/**  二倍训练 **/
		public function get btnTrainDouble():Button
		{
			return _btnTrainDouble;
		}
		/** @private **/
		public function set btnTrainDouble(value:Button):void
		{
			_btnTrainDouble = value;
		}
		private var _btnTrainQuintuple:Button
		/**  五倍训练 **/
		public function get btnTrainQuintuple():Button
		{
			return _btnTrainQuintuple;
		}
		/** @private **/
		public function set btnTrainQuintuple(value:Button):void
		{
			_btnTrainQuintuple = value;
		}
		private var _btnCleanCDAll:Button
		/**  全部完成 **/
		public function get btnCleanCDAll():Button
		{
			return _btnCleanCDAll;
		}
		/** @private **/
		public function set btnCleanCDAll(value:Button):void
		{
			_btnCleanCDAll = value;
		}
		private var _trainLayer:SLayer
		/**  训练开始 **/
		public function get trainLayer():SLayer
		{
			return _trainLayer;
		}
		/** @private **/
		public function set trainLayer(value:SLayer):void
		{
			_trainLayer = value;
		}
		private var _totalCost:Label
		/**  总计花费 **/
		public function get totalCost():Label
		{
			return _totalCost;
		}
		/** @private **/
		public function set totalCost(value:Label):void
		{
			_totalCost = value;
		}
		private var _imgMoney:ImageLoader
		/**  货币图片 **/
		public function get imgMoney():ImageLoader
		{
			return _imgMoney;
		}
		/** @private **/
		public function set imgMoney(value:ImageLoader):void
		{
			_imgMoney = value;
		}
		private var _cost:Label
		/**  花费 **/
		public function get cost():Label
		{
			return _cost;
		}
		/** @private **/
		public function set cost(value:Label):void
		{
			_cost = value;
		}
		private var _btnStartTrain:Button
		/**  开始训练 **/
		public function get btnStartTrain():Button
		{
			return _btnStartTrain;
		}
		/** @private **/
		public function set btnStartTrain(value:Button):void
		{
			_btnStartTrain = value;
		}

		
		/** 标题框 **/
		private var _title:CJPanelTitle;
		/** 训练列表 **/
		private var _trainPickPanel:CJHeroTrainPickPanel;
		
		/** 武将训练开始界面 **/
		private var _startLayer:CJHeroTrainStartLayer;
		
//		/** 武将信息 **/
//		private var _heroList:CJDataOfHeroList;
//		/** 武将训练信息 **/
//		private var _heroTrain:CJDataOfHeroTrain;
		
		/** 武将信息标示 **/
		private const FLAG_HERO_INFO:uint = 1;
		/** 武将训练信息标示 **/
		private const FLAG_HERO_TRAIN_INFO:uint = 2;
		/** 标示是否获取到 武将新信息 与 武将训练新信息 **/
		private var _startTrainFlag:uint = 0;
		
		/** 是否全选 **/
		private var _isPickAll:Boolean = true;
		
		public function CJHeroTrainPickLayer()
		{
			super();
		}
		
		override public function dispose():void
		{
			_startLayer.removeFromParent(true);
			_startLayer = null;
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 设置宽高
			this.width = ConstMainUI.MAPUNIT_WIDTH;
			this.height = ConstMainUI.MAPUNIT_HEIGHT;
			
			// 层级
			var tierIndex:int = 0;
			var texture:Texture;
			var scale9Texture:Scale9Textures;
			var bg:Scale9Image;
//			// 底
//			texture = SApplication.assets.getTexture("common_dinew");
//			scale9Texture = new Scale9Textures(texture, new Rectangle(15,15 ,3,3));
//			bg = new Scale9Image(scale9Texture);
//			bg.x = 0;
//			bg.y = 0;
//			bg.width = ConstMainUI.MAPUNIT_WIDTH;
//			bg.height = ConstMainUI.MAPUNIT_HEIGHT;
//			bg.alpha = 0.5;
//			addChildAt(bg , tierIndex++);

			// 面板框
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = layerBG.y;
			bg.width = layerBG.width;
			bg.height = layerBG.height;
			addChildAt(bg , tierIndex++);
			
			// 内框
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = layerBG.y;
			bg.width = layerBG.width;
			bg.height = layerBG.height;
			addChildAt(bg , tierIndex++);
			// 内框
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = insideBG.y;
			bg.width = layerBG.width;
			bg.height = insideBG.height;
			addChildAt(bg , tierIndex++);
			
			// 花边
			var frame:CJPanelFrame = new CJPanelFrame(layerBG.width-6, layerBG.height-6);
			frame.x = layerBG.x + 3;
			frame.y = layerBG.y + 3;
			frame.touchable = false;
			addChildAt(frame , tierIndex++);
			
			// 外框
			texture = SApplication.assets.getTexture("common_waikuangnew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(15 , 15 , 1, 1));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = layerBG.y;
			bg.width = layerBG.width;
			bg.height = layerBG.height;
			addChildAt(bg , tierIndex++);

			
			// 标题框
			_title = new CJPanelTitle(CJLang("HERO_TRAIN_TITLE"));
			addChild(_title);
			_title.x = labelTitle.x;
			_title.y = labelTitle.y;
			
			// 关闭按钮纹理
			btnClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new") );
			btnClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new") );
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJHeroTrainModule");
			});
			
			// 初始化表头
			// 武将名称
			heroname.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			heroname.text = CJLang("HERO_TRAIN_NAME");
			// 等级
			herolevel.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			herolevel.text = CJLang("HERO_TRAIN_LEVEL");
			// 冷却时间
			cooltime.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			cooltime.text = CJLang("HERO_TRAIN_CD");
			// 状态
			state.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			state.text = CJLang("HERO_TRAIN_STAGE");
			
			// 不显示训练图层
			trainLayer.visible = false;
			// 按钮
			// 全选
			btnAllPick.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			btnAllPick.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			btnAllPick.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
			btnAllPick.addEventListener(Event.TRIGGERED, _onPickAll);
			btnAllPick.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnAllPick.label = CJLang("HERO_TRAIN_PICK_ALL");
			btnAllPick.isEnabled = false;
			// 普通
			btnTrainCommon.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			btnTrainCommon.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			btnTrainCommon.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
			btnTrainCommon.addEventListener(Event.TRIGGERED, _onTrainCommon);
			btnTrainCommon.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnTrainCommon.label = CJLang("HERO_TRAIN_COMMON");
			btnTrainCommon.isEnabled = false;
			// 双倍
			btnTrainDouble.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			btnTrainDouble.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			btnTrainDouble.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
			btnTrainDouble.addEventListener(Event.TRIGGERED, _onTrainDouble);
			btnTrainDouble.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnTrainDouble.label = CJLang("HERO_TRAIN_DOUBLE");
			btnTrainDouble.isEnabled = false;
			// 五倍
			btnTrainQuintuple.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			btnTrainQuintuple.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			btnTrainQuintuple.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
			btnTrainQuintuple.addEventListener(Event.TRIGGERED, _onTrainQuintuple);
			btnTrainQuintuple.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnTrainQuintuple.label = CJLang("HERO_TRAIN_QUINTUPLE");
			btnTrainQuintuple.isEnabled = false;
			
			// 全部完成
			btnCleanCDAll.defaultSkin = new SImage( SApplication.assets.getTexture("common_tipanniu01") );
			btnCleanCDAll.downSkin = new SImage( SApplication.assets.getTexture("common_tipanniu02") );
			btnCleanCDAll.addEventListener(Event.TRIGGERED, _onCleanAllCD);
			btnCleanCDAll.defaultLabelProperties.textFormat = ConstTextFormat.textformatblackleft;
			btnCleanCDAll.label = CJLang("HERO_TRAIN_ALLOVER");//全部完成
			btnCleanCDAll.visible = false;
			btnCleanCDAll.width = 57;
			addChild(btnCleanCDAll);
			
			
			// 选择列表
			_trainPickPanel = new CJHeroTrainPickPanel(insideBG.width, insideBG.height);
			_trainPickPanel.x = insideBG.x + 2;
			_trainPickPanel.y = insideBG.y + 22;
			addChild(_trainPickPanel);
			
			// 武将训练开始界面
			var s:XML = AssetManagerUtil.o.getObject("heroTrainLayout.sxml") as XML;
			_startLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJHeroTrainStartLayer) as CJHeroTrainStartLayer;
			_startLayer.visible = false;
			addChild(_startLayer);
			
			
			// 及时获取武将训练信息
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _doInit);
			SocketCommand_heroTrain.get_train_info();
		}
		
		public function addAllListener():void
		{
			// 监听事件
			// 开始训练成功
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onTrainComplete);
			// 清空训练cd
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onCleanCDComplete);
			// 某个标签倒计时完成，请求获取信息更新
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_HERO_TRAIN_TIME_UP , _sendRPC2Update);
			// 监听武将item被点中
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_HERO_TRAIN_PICK_ITEM, _onPickItem);
		}
		
		public function removeAllListener():void
		{
			// 开始训练成功
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onTrainComplete);
			// 清空训练cd
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onCleanCDComplete);
			// 某个标签倒计时完成，请求获取信息更新
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_HERO_TRAIN_TIME_UP , _sendRPC2Update);
			// 监听武将item被点中
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_HERO_TRAIN_PICK_ITEM, _onPickItem);
		}
		
		private function _doInit(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TRAIN_GET_INFO)
				return;
			e.target.removeEventListener(e.type, _doInit);
			
			CJDataManager.o.DataOfHeroTrain.trainCount = message.retparams[0];
			CJDataManager.o.DataOfHeroTrain.initData(message.retparams[1]);
			
			// 可点击
			btnAllPick.isEnabled = true;
			btnTrainCommon.isEnabled = true;
			btnTrainDouble.isEnabled = true;
			btnTrainQuintuple.isEnabled = true;
			
			// 更新选择界面
			_trainPickPanel.updateLayer();
			// 检测所有pickitem是否均在训练中
			btnAllPick.isEnabled = !(_isAllRunning());
			// 更新
			_updataCleanCDAll();
		}
		
		// 全选
		private function _onPickAll(e:Event):void
		{
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			var arr:Array = _trainPickPanel.dataProvider.data as Array;
			var obj:Object;
			
			for (var i:int=0; i<arr.length; ++i)
			{
				obj = arr[i];
				obj.isSelected = _isPickAll;
				_trainPickPanel.updateItem(i);
			}
			
			_isPickAll = !_isPickAll;
			_updataPickAllBtn()
		}
		
		private function _updataPickAllBtn():void
		{
			if (_isPickAll)
				btnAllPick.label = CJLang("HERO_TRAIN_PICK_ALL");
			else
				btnAllPick.label = CJLang("HERO_TRAIN_PICK_NO");
		}
		
		private function _updataCleanCDAll():void
		{
			btnCleanCDAll.visible = false;
				
			var arr:Array = _trainPickPanel.dataProvider.data as Array;
			var obj:Object;
			for (var i:int=0; i<arr.length; ++i)
			{
				obj = arr[i];
				if (obj.state == ConstHeroTrain.HERO_STATE_BUSY)
				{
					// 有训练中的武将
					btnCleanCDAll.visible = true;
					break;
				}
			}
			
		}
		
		// 选中item
		private function _onPickItem(e:*):void
		{
			var arr:Array = _trainPickPanel.dataProvider.data as Array;
			var obj:Object = e.data;
			obj.isSelected = !obj.isSelected;
			_trainPickPanel.updateItem(obj.index );
			
			_isPickAll = false;
			// 是否全选
			for (var i:int=0; i<arr.length; ++i)
			{
				obj = arr[i];
				// 选中状态， 武将是否满级
				if (!obj.isSelected && obj.state==ConstHeroTrain.HERO_STATE_IDLE)
				{
					_isPickAll = true;
					break;
				}
			}
			
			if (_isPickAll)
				btnAllPick.label = CJLang("HERO_TRAIN_PICK_ALL");
			else
				btnAllPick.label = CJLang("HERO_TRAIN_PICK_NO");
		}
		
		// 普通训练
		private function _onTrainCommon(e:Event):void
		{
			var temp:Array = _getPickedHeros();
			if (temp.length == 0)
			{
				// 提示“请先选择武将”
				CJMessageBox(CJLang("HERO_TRAIN_NO_PICK"));
				return;
			}
			_startLayer.ShowLayer(ConstHeroTrain.HERO_TRAIN_TYPE_COMMON, temp);
		}
		// 双倍训练
		private function _onTrainDouble(e:Event):void
		{
			var temp:Array = _getPickedHeros();
			if (temp.length == 0)
			{
				// 提示“请先选择武将”
				CJMessageBox(CJLang("HERO_TRAIN_NO_PICK"));
				return;
			}
			_startLayer.ShowLayer(ConstHeroTrain.HERO_TRAIN_TYPE_2, temp);
		}
		// 五倍训练
		private function _onTrainQuintuple(e:Event):void
		{
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			var temp:Array = _getPickedHeros();
			if (temp.length == 0)
			{
				// 提示“请先选择武将”
				CJMessageBox(CJLang("HERO_TRAIN_NO_PICK"));
				return;
			}
			_startLayer.ShowLayer(ConstHeroTrain.HERO_TRAIN_TYPE_5, temp);
		}
		
		// 全部完成
		private function _onCleanAllCD(e:Event):void
		{
			// 判断是否有主角
			var arr:Array = _trainPickPanel.dataProvider.data as Array;
			
			var i:int=0;
			for (; i<arr.length; ++i)
			{
				obj = arr[i];
				var heroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(String(obj.heroid));
				if (heroInfo.isRole)
				{
					var viplevel:int = CJDataManager.o.DataOfRole.vipLevel;
					var vipFuncJs:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(viplevel));
					var maxTrainCount:int = int(vipFuncJs.hero_traincount);
//					var maxTrainCount:int = int(CJDataOfGlobalConfigProperty.o.getData("MAX_TRAIN_COUNT"));
					var traincount:int = CJDataManager.o.DataOfHeroTrain.trainCount;
					if ( traincount >= maxTrainCount )
					{
						new CJTaskFlowString(CJLang("HERO_TRAIN_CAN_NOT_CLEAN_CD"), 1, 20).addToLayer();
						return;
					}
				}
			}
			
			var totalcost:uint = 0;
			// 训练时间花费元宝系数
			var baseGold:Number = Number(CJDataOfGlobalConfigProperty.o.getData("HERO_TRAIN_GOLD_BASE"));
			
			
			var obj:Object;
			for (i=0; i<arr.length; ++i)
			{
				obj = arr[i];
				totalcost += Math.ceil(obj.remaintime * baseGold);
			}
			
			CJConfirmMessageBox(CJLang("HERO_TRAIN_CLEAN_CD_DES", {"cost":totalcost}), _sendCleanALLCD);
		}
		
		private function _sendCleanALLCD():void
		{
			SocketCommand_heroTrain.clean_cd_all(_onCleanCDALL);
		}
		
		// 全部完成
		private function _onCleanCDALL(e:SocketMessage):void
		{
			var message:SocketMessage = e;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("HERO_TRAIN_GOLD"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJHeroTrainPickLayer._onCleanCDALL retcode="+message.retcode );
					return;
			}
			
			// 及时获取武将训练信息
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _doInit);
			SocketCommand_heroTrain.get_train_info();
			
			_isPickAll = true;
			_updataPickAllBtn();
		}

		
		// 获取选中的武将
		private function _getPickedHeros():Array
		{
			// 被选中的heroid列表
			var herolist:Array = new Array;
			
			var arr:Array = _trainPickPanel.dataProvider.data as Array;
			var obj:Object;
			for (var i:int=0; i<arr.length; ++i)
			{
				obj = arr[i];
				// 被选中且为空闲状态的才为真正需要训练的
				if(obj.isSelected && obj.state == ConstHeroTrain.HERO_STATE_IDLE)
					herolist.push(obj);
			}
			
			return herolist;
		}
		
		
		// 开始训练成功
		private function _onTrainComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TRAIN_START_TRAIN)
				return;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
//					CJMessageBox(CJLang("HERO_TRAIN_SILVER"));
					// 银两不足提示框 modify by sangxu 2013-09-04
					CJMsgBoxSilverNotEnough(CJLang("HERO_TRAIN_SILVER"), 
											"", 
											function():void{
												SApplication.moduleManager.exitModule("CJHeroTrainModule");
											});
					return;
				case 2:
					CJMessageBox(CJLang("HERO_TRAIN_GOLD"));
					return;
				case 3:
					CJMessageBox(CJLang("HERO_TRAIN_COUNT_MAX"));
					return;
				case 100://无
					return;
				case 101://武将不存在
					CJMessageBox(CJLang("HERO_TRAIN_NOTHAVE"));
					return;
				case 102://超过训练次数
					CJMessageBox(CJLang("HERO_TRAIN_MAXTIP"));
					return;
				case 103://在训练中
					CJMessageBox(CJLang("HERO_TRAIN_STATE_BUSY"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJHeroTrainPickLayer._onTrainComplete retcode="+message.retcode );
					return;
			}
			
			if(message.retcode == 0)
			{
				_sendRPC2Update();
				
				// 更新用户数据
				SocketCommand_role.get_role_info();
				
				// 活跃度
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_HEROTRAIN});
			}
		}
		
		/**
		 * 是否所有的武将都在训练中
		 * @return 
		 */
		private function _isAllRunning():Boolean
		{
			// 是否在训练中
			var isAllRunning:Boolean = true;
			
			var arr:Array = _trainPickPanel.dataProvider.data as Array;
			var obj:Object;
			
			for (var i:int=0; i<arr.length; ++i)
			{
				obj = arr[i];
				if(obj.state == ConstHeroTrain.HERO_STATE_FULL)
					continue;
				
				if(obj.state != ConstHeroTrain.HERO_STATE_BUSY)
				{
					isAllRunning = false;
					break;
				}
			}
			
			return isAllRunning;
		}
		
		// 获取数据
		private function _sendRPC2Update():void
		{
			_startTrainFlag = 0;
			
			// 武将信息变更
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onHeroListComplete);
			// 武将训练信息变更
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onHeroTrainComplete);
			// 获取武将信息
			SocketCommand_hero.get_heros();
			// 武将训练信息
			SocketCommand_heroTrain.get_train_info();
		}
		
		// 武将信息变更
		private function _onHeroListComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_GET_HEROS)
				return;
			if(message.retcode == 0)
			{
				e.target.removeEventListener(e.type, _onHeroListComplete);
				_startTrainFlag = _startTrainFlag | FLAG_HERO_INFO;
				_onStartUpdate()
			}
		}
		// 武将训练信息变更
		private function _onHeroTrainComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TRAIN_GET_INFO)
				return;
			if(message.retcode == 0)
			{
				e.target.removeEventListener(e.type, _onHeroTrainComplete);
				_startTrainFlag = _startTrainFlag | FLAG_HERO_TRAIN_INFO;
				// 训练信息更新
				CJDataManager.o.DataOfHeroTrain.trainCount = message.retparams[0]
				CJDataManager.o.DataOfHeroTrain.initData(message.retparams[1]);
				_onStartUpdate()
			}
		}
		
		/// 因为武将训练更新界面
		private function _onStartUpdate():void
		{
			if (((_startTrainFlag & FLAG_HERO_INFO) == FLAG_HERO_INFO) &&
				((_startTrainFlag & FLAG_HERO_TRAIN_INFO) == FLAG_HERO_TRAIN_INFO))
			{
				_trainPickPanel.updateLayer();
				
				// 检测所有pickitem是否均在训练中
				btnAllPick.isEnabled = !(_isAllRunning());
				
				// 更新全选按钮状态
				_isPickAll = btnAllPick.isEnabled;
				_updataPickAllBtn();
				
				// 更新"全部完成"按钮状态
				_updataCleanCDAll();
			}
		}
		
		// 清空训练cd
		private function _onCleanCDComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TRAIN_CLEAN_CD)
				return;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("HERO_TRAIN_GOLD"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJHeroTrainPickLayer._onCleanCDComplete retcode="+message.retcode );
					return;
			}
			
			if(message.retcode == 0)
			{
				// 
				_startTrainFlag = _startTrainFlag | FLAG_HERO_INFO;
				// 武将训练信息变更
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onHeroTrainComplete);
				// 武将训练信息
				SocketCommand_heroTrain.get_train_info();
				// 更新用户数据
				SocketCommand_role.get_role_info();
			}
		}
		
	}
}