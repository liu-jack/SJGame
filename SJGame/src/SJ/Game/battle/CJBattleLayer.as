package SJ.Game.battle
{
	import SJ.Game.lang.CJLang;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SDisplayUtils;
	
	import feathers.controls.Button;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 战斗UI 
	 * @author caihua
	 * 
	 */
	public class CJBattleLayer extends SLayer
	{
		/**
		 * 返回按钮 
		 */
		private var _button_back:Button;
		
		/**
		 * 重新播放 
		 */
		private var _button_replay:Button;
		
		/**
		 * 当前战斗句柄 
		 */
		private var _relayhandler:CJBattleReplayManager;
		public function CJBattleLayer(ReplayManager:CJBattleReplayManager)
		{
			_relayhandler = ReplayManager;
			super();
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		override protected function initialize():void
		{
			name = "CJBattleLayer";
			_button_back = new Button();
			_button_back.defaultSkin = new SImage(Texture.fromColor(200,20,0xFF00FFFF),true);
			_button_back.label = CJLang("BATTLE_QUICK_BATTLE");
			_button_back.addEventListener(Event.TRIGGERED,_onClickBack);
			_button_back.y = 20;
			addChild(_button_back);
			
			_button_replay = new Button();
			_button_replay.defaultSkin = new SImage(Texture.fromColor(200,20,0xFF00FFFF),true);
			_button_replay.label = CJLang("BATTLE_REPLAY");
			_button_replay.addEventListener(Event.TRIGGERED,_onClickRelplayer);
			_button_replay.x= 200;
			_button_replay.y = 20;
			addChild(_button_replay);
			
//			var bgImage:Image = new Image(SApplication.assets.getTexture("common_battle0"));
//			SDisplayUtils.setAnchorPoint(bgImage);
//			bgImage.x =  bgImage.width/2;
//			bgImage.y = bgImage.height/2;
//			CJBattleMapManager.o.backgroundLayer.addChild(bgImage);
			
			super.initialize();
		}
		
		
		
		private function _onClickRelplayer(e:Event):void
		{
			_relayhandler.stop();
			
			
			CJBattleMapManager.o.removeAllChildren();
//			var bgImage:Image = new Image(SApplication.assets.getTexture("common_battle0"));
//			SDisplayUtils.setAnchorPoint(bgImage);
//			bgImage.x =  bgImage.width/2;
//			bgImage.y = bgImage.height/2;
//			CJBattleMapManager.o.backgroundLayer.addChild(bgImage);
			
			_relayhandler.play();
		}
		
		private function _onClickBack(e:Event):void
		{
//			_relayhandler.playtoend();
			SApplication.moduleManager.exitModule("CJBattleModule");
			SApplication.moduleManager.enterModule("CJMainUiModule");
		}
		
		public function hideBottomBar():void
		{
			
//			var TMoveTo:Tween = new Tween(_bottomBarImage,0.5);
//			TMoveTo.moveTo((SApplicationConfig.o.stageWidth - _bottomBarImage.width)/2,SApplicationConfig.o.stageHeight - 30);
//
//			Starling.juggler.add(TMoveTo);

		}
		
		public function showBottomBar(_onfinish:Function):void
		{
//			var TMoveTo:Tween = new Tween(_bottomBarImage,0.5);
//			TMoveTo.moveTo((SApplicationConfig.o.stageWidth - _bottomBarImage.width)/2,SApplicationConfig.o.stageHeight - _bottomBarImage.height);
//			Starling.juggler.add(TMoveTo);
//			_bottomBarImage.show(_onfinish);
		}
		
		
	}
}