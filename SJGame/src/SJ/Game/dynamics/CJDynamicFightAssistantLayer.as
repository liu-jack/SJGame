package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAssistantInFormation;
	import SJ.Game.data.CJDataOfEnterGuanqia;
	import SJ.Game.data.CJDataOfFormation;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import flash.text.TextFormat;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 选择助战好友弹窗
	 * @author zhengzheng 
	 * 
	 */	
	public class CJDynamicFightAssistantLayer extends SLayer
	{
		/**标题标签 */
		private var _labTitle:Label;
//		/**关闭按钮*/
//		private var _btnClose:Button;
		/**刷新按钮*/
		private var _btnRefresh:Button;
		/**跳过按钮*/
		private var _btnJump:Button;
		/**显示的数据*/
		private var _listData:Array;
		/** 阵型数据*/
		private var _formationData:CJDataOfFormation;
		/** 进入的关卡数据*/
		private var _dataEnterGuanqia:CJDataOfEnterGuanqia;
		/** 助战武将的id*/
		private var _heroId:String;
		/** 助战武将的模板id*/
		private var _heroTemplateId:String;
		/**助战好友显示层*/
		private var _assistantShowLayer:CJDynamicAssistantShowLayer;
		/**可点击背景*/
		private var _quad:Quad;
		public function CJDynamicFightAssistantLayer()
		{
			super();
			this.setSize(269,294);
			_dataEnterGuanqia = CJDataOfEnterGuanqia.o;
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadSelectHeroInfo);
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadSelectHeroInfo);
			if (_formationData)
			{
				_formationData.removeEventListener(DataEvent.DataLoadedFromRemote , _initFormation);
			}
			super.dispose();
		}
		
		
		/**
		 * 加载服务器选择的助战好友数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadSelectHeroInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_SELECT_INVITE_HEROS)
			{
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FUBEN_SELECT_INVITE_HEROS);
				if (message.retcode == 0)
				{
					var selectHeroInfo:Object = message.retparams;
					_heroId = selectHeroInfo.heroid;
					_heroTemplateId = selectHeroInfo.templateid;
					_dataEnterGuanqia.assistantUid = selectHeroInfo.userid
					_listData = _assistantShowLayer.itemsPanel.getAllItemDatas();
					for (var i:int = 0; i < _listData.length; i++) 
					{
						if (selectHeroInfo.userid == _listData[i].uid)
						{
							_dataEnterGuanqia.isFriend = _listData[i].isfriend;
							break;
						}
					}
					
					_enterFormation();
				}
			}
		}
		
		
		/**
		 * 第一次初始化
		 * 
		 */		
		override protected function initialize():void
		{
			_initData();
			_drawContent();
			_addListener();
		}
		/**
		 * 初始化基本数据
		 */		
		private function _initData():void
		{
			_formationData = CJDataManager.o.DataOfFormation;
		}
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			//	 整体背景
			var bg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tankuangdi", 19,19,1,1);
			bg.width = this.width;
			bg.height = this.height;
			this.addChild(bg);
			
			_labTitle = new Label();
			_labTitle.x = 98;
			_labTitle.y = 4;
			_labTitle.text = CJLang("DYNAMIC_SELECT_ONE_FRIEND");
			_labTitle.textRendererProperties.textFormat = ConstTextFormat.textformatgreencenter;
			_labTitle.textRendererFactory = textRender.standardTextRender;
			this.addChild(_labTitle);
			
//			this._btnClose = new Button();
//			this._btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
//			this._btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
//			this._btnClose.x = 247;
//			this._btnClose.y = -5;
//			this.addChild(_btnClose);
			
			var textFormat:TextFormat = new TextFormat( "Arial", 12, 0xE9DBAD);
			this._btnJump = new Button();
			this._btnJump.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			this._btnJump.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			this._btnJump.x = 34;
			this._btnJump.y = 259;
			this._btnJump.width = 87;
			this._btnJump.height = 28;
			this._btnJump.label = CJLang("DYNAMIC_JUMP");
			this._btnJump.defaultLabelProperties.textFormat = textFormat;
			this.addChild(_btnJump);
			
			this._btnRefresh = new Button();
			this._btnRefresh.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			this._btnRefresh.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			this._btnRefresh.x = 149;
			this._btnRefresh.y = 259;
			this._btnRefresh.width = 87;
			this._btnRefresh.height = 28;
			this._btnRefresh.label = CJLang("DYNAMIC_REFRESH");
			this._btnRefresh.defaultLabelProperties.textFormat = textFormat;
			this.addChild(_btnRefresh);
				
			_assistantShowLayer = new CJDynamicAssistantShowLayer();
			_assistantShowLayer.x = 6;
			_assistantShowLayer.y = 18;
			this.addChild(this._assistantShowLayer);
			
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.x = (this.width - SApplicationConfig.o.stageWidth) / 2;
			_quad.y = (this.height - SApplicationConfig.o.stageHeight) / 2;
			this.addChildAt(_quad, 0);
		}
		/**
		 * 进入阵型
		 * @param heroId 助战武将id
		 */		
		private function _enterFormation():void
		{
			//阵型数据
			if(_formationData.dataIsEmpty)
			{
				_formationData.addEventListener(DataEvent.DataLoadedFromRemote , _initFormation);
				_formationData.loadFromRemote();
			}
			else 
			{
				_initFormation();
			}
		}
		/**
		 * 初始化阵型数据
		 * @param heroId 助战武将id
		 * 
		 */		
		private function _initFormation():void
		{
			var dataList:Array = _formationData.dataList;
			var dataAssistantInFormation:CJDataOfAssistantInFormation = CJDataManager.o.DataOfAssistantInFormation;
			_formationData.dataAssistant = CJDataManager.o.DataOfAssistantInFormation;
			var assistantHeroPos:int = dataAssistantInFormation.assistantHeroPos;
			if (assistantHeroPos != 0 && assistantHeroPos != -1
				&& int(dataList[assistantHeroPos]) == -1)
			{
				_formationData["pos" + assistantHeroPos] = _heroId;
				ConstDynamic.isAssistantAdd = true;
			}
			else
			{
				for (var i:int = 0; i < dataList.length; i++) 
				{
					if ((int(dataList[i]) == 0 || int(dataList[i]) == -1) 
						&& !ConstDynamic.isAssistantAdd)
					{
						_formationData["pos" + i] = _heroId;
						assistantHeroPos = i;
						ConstDynamic.isAssistantAdd = true;
						break;
					}
				}
			}
			_formationData.assistantHeroId = _heroId;
			dataAssistantInFormation.assistantHeroId = _heroId;
			dataAssistantInFormation.assistantHeroTemplateId = _heroTemplateId;
			dataAssistantInFormation.assistantHeroPos = assistantHeroPos;
			dataAssistantInFormation.saveToCache();
			_formationData.dataAssistant.assistantHeroTemplateId = _heroTemplateId;
			_formationData.dispatchEventWith(CJDataOfFormation.FORMATION_DATA_CHANGED);
			this.removeFromParent(true);
			SApplication.moduleManager.enterModule("CJFormationModule");
		}
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			_quad.addEventListener(TouchEvent.TOUCH, _onClickQuad);
//			_btnClose.addEventListener(Event.TRIGGERED , this._closeTriggered);
			_btnRefresh.addEventListener(Event.TRIGGERED , this._btnRefreshTriggered);
			_btnJump.addEventListener(Event.TRIGGERED , this._btnJumpTriggered);
		}
		/**
		 * 触发关闭事件
		 * @param e
		 * 
		 */		
		private function _onClickQuad(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.ENDED);
			if (!touch)
			{
				return;	
			}
			this.removeFromParent(true);
		}
		/**
		 * 触发跳过事件
		 * @param e
		 * 
		 */		
		private function _btnJumpTriggered(e:Event):void
		{
			SSoundEffectUtil.playTipSound();
			this.removeFromParent(true);
			var dataEnterGuanqia:CJDataOfEnterGuanqia = CJDataOfEnterGuanqia.o;
			if (dataEnterGuanqia.assistantUid)
			{
				dataEnterGuanqia.assistantUid = null;
			}
			SApplication.moduleManager.enterModule("CJFormationModule");
		}
		/**
		 * 触发刷新事件
		 * @param e
		 * 
		 */		
		private function _btnRefreshTriggered(e:Event):void
		{
			SSoundEffectUtil.playTipSound();
			var confirmDialog:CJRefreshAssistantDialog = new CJRefreshAssistantDialog();
			CJLayerManager.o.addModuleLayer(confirmDialog);
		}
	}
}