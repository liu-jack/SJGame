package SJ.Game.worldboss
{
	import flash.text.TextFormat;
	
	import SJ.Game.chat.CJMainChatLayer;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.lang.CJLang;
	import SJ.Game.loader.CJLoaderMoudle;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.core.ITextRenderer;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss菜单层
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-22 下午2:33:19  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossPanelLayer extends SLayer
	{
		private var _gateNameImage:ImageLoader;
		private var _leftGateName:Label;
		private var _leftGateHpBar:ProgressBar;
		private var _mainGateBar:ProgressBar;
		private var _rightGateHpBar:ProgressBar;
		private var _rankPanel:CJWorldBossRankPanel;
		private var _chatLayer:CJMainChatLayer;
		
		private var _quan:ImageLoader;
		
		private var _toRightGateButton:Button;
		private var _backToTown:Button;
		private var _hornButton:Button;
		private var _reliveButton:Button;
		private var _courageButton:Button;
		private var _trusteeshipButton:Button;
		private var _tween:STween;
		
		private var _leftGateHp:Label;
		private var _mainGateHp:Label;
		private var _rightGateHp:Label;
		
		private var _nextRoundLeftTime:Label;
		private var _currentRound:Label;
		private var _addEffect:Label;
		
		public function CJWorldBossPanelLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _drawContent():void
		{
			toRightGateButton.labelOffsetY = 1;
			toRightGateButton.labelFactory = function():ITextRenderer
			{
				var tr:TextFieldTextRendererEx = new TextFieldTextRendererEx();
				var tf:TextFormat = new TextFormat();
				tf.color = 0xffffff;
				tr.textFormat = tf;
				return tr;
			};
			
			_quan.pivotX = 20;
			_quan.pivotY = 20;
			
			_tween = new STween(_quan, 6);
			_tween.animate("rotation", 2*Math.PI);
			_tween.loop = 1;
			Starling.juggler.add(_tween);
		}
		
		override protected function draw():void
		{
			super.draw();
			_chatLayer.resize(false);
			if(CJDataOfScene.o.sceneid == CJDataOfScene.SCENE_ID_WORLD_BOSS_EAST)
			{
				toRightGateButton.label = CJLang('WORLDBOSS_xichengmen');
				_gateNameImage.source =  SApplication.assets.getTexture("worldboss_dongcheng");
			}
			else
			{
				toRightGateButton.label = CJLang('WORLDBOSS_dongchengmen');
				_gateNameImage.source =  SApplication.assets.getTexture("worldboss_xicheng");
			}
		}
		
		private function _addEventListeners():void
		{
			_toRightGateButton.addEventListener(Event.TRIGGERED  , this._onChangeScene);
			_backToTown.addEventListener(Event.TRIGGERED , this._onBackToTown);
		}
		
		private function _onChangeScene(e:Event):void
		{
			var button:Button = e.target as Button;
			SApplication.moduleManager.exitModule("CJWorldBossModule");
			if(CJDataOfScene.o.sceneid == CJDataOfScene.SCENE_ID_WORLD_BOSS_EAST)
			{
				SApplication.moduleManager.enterModule("CJWorldBossModule" , {"sceneId":CJDataOfScene.SCENE_ID_WORLD_BOSS_WEAST});
			}
			else
			{
				SApplication.moduleManager.enterModule("CJWorldBossModule" , {"sceneId":CJDataOfScene.SCENE_ID_WORLD_BOSS_EAST});
			}
		}
		
		private function _onBackToTown(e:Event):void
		{
			SApplication.moduleManager.exitModule("CJWorldBossModule");
			CJLoaderMoudle.helper_enterMainUI({"cityid":CJDataOfScene.RELIVE_CITY_ID});
		}
		
		override public function dispose():void
		{
			super.dispose();
			Starling.juggler.remove(_tween);
			_tween = null;
		}

		public function get gateNameImage():ImageLoader
		{
			return _gateNameImage;
		}

		public function set gateNameImage(value:ImageLoader):void
		{
			_gateNameImage = value;
		}

		public function get leftGateName():Label
		{
			return _leftGateName;
		}

		public function set leftGateName(value:Label):void
		{
			_leftGateName = value;
		}

		public function get toRightGateButton():Button
		{
			return _toRightGateButton;
		}

		public function set toRightGateButton(value:Button):void
		{
			_toRightGateButton = value;
		}

		public function get mainGateBar():ProgressBar
		{
			return _mainGateBar;
		}

		public function set mainGateBar(value:ProgressBar):void
		{
			_mainGateBar = value;
		}

		public function get rankPanel():CJWorldBossRankPanel
		{
			return _rankPanel;
		}

		public function set rankPanel(value:CJWorldBossRankPanel):void
		{
			_rankPanel = value;
		}

		public function get backToTown():Button
		{
			return _backToTown;
		}

		public function set backToTown(value:Button):void
		{
			_backToTown = value;
		}

		public function get hornButton():Button
		{
			return _hornButton;
		}

		public function set hornButton(value:Button):void
		{
			_hornButton = value;
		}

		public function get reliveButton():Button
		{
			return _reliveButton;
		}

		public function set reliveButton(value:Button):void
		{
			_reliveButton = value;
		}

		public function get courageButton():Button
		{
			return _courageButton;
		}

		public function set courageButton(value:Button):void
		{
			_courageButton = value;
		}

		public function get trusteeshipButton():Button
		{
			return _trusteeshipButton;
		}

		public function set trusteeshipButton(value:Button):void
		{
			_trusteeshipButton = value;
		}

		public function get chatLayer():CJMainChatLayer
		{
			return _chatLayer;
		}

		public function set chatLayer(value:CJMainChatLayer):void
		{
			_chatLayer = value;
		}

		public function get quan():ImageLoader
		{
			return _quan;
		}

		public function set quan(value:ImageLoader):void
		{
			_quan = value;
		}

		public function get leftGateHp():Label
		{
			return _leftGateHp;
		}

		public function set leftGateHp(value:Label):void
		{
			_leftGateHp = value;
		}

		public function get mainGateHp():Label
		{
			return _mainGateHp;
		}

		public function set mainGateHp(value:Label):void
		{
			_mainGateHp = value;
		}

		public function get rightGateHp():Label
		{
			return _rightGateHp;
		}

		public function set rightGateHp(value:Label):void
		{
			_rightGateHp = value;
		}

		public function get nextRoundLeftTime():Label
		{
			return _nextRoundLeftTime;
		}

		public function set nextRoundLeftTime(value:Label):void
		{
			_nextRoundLeftTime = value;
		}

		public function get currentRound():Label
		{
			return _currentRound;
		}

		public function set currentRound(value:Label):void
		{
			_currentRound = value;
		}

		public function get addEffect():Label
		{
			return _addEffect;
		}

		public function set addEffect(value:Label):void
		{
			_addEffect = value;
		}
	}
}