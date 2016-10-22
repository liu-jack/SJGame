package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstFilter;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.loader.CJLoaderMoudle;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * 副本战斗UI
	 * @author yongjun
	 * 
	 */
	public class CJFubenBattleLayer extends SLayer
	{
		//当前战斗句柄 
		private var _relayhandler:CJBattleReplayManager;
		private var _button_back:Button;
		private var _showfast:Boolean  =false;
		public function CJFubenBattleLayer(ReplayManager:CJBattleReplayManager)
		{
			_relayhandler = ReplayManager;
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
			if(!_showfast)
			{
				_button_back.filter = ConstFilter.genBlackFilter();
			}
			else
			{
				if(_button_back.filter != null)
				{
					_button_back.filter.dispose();
				}
				_button_back.filter = null;
			}
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_button_back= new Button();
			_button_back.defaultSkin = new SImage(SApplication.assets.getTexture("common_suzhansujue"));
			_button_back.x = (SApplicationConfig.o.stageWidth - _button_back.defaultSkin.width) >> 1;
			_button_back.y = SApplicationConfig.o.stageHeight - _button_back.defaultSkin.height;
			_button_back.name = "end";
			_button_back.addEventListener(Event.TRIGGERED,_onClickBack);
			addChild(_button_back);
			
//			var _button_backCity:Button = new Button();
//			_button_backCity.defaultSkin = new SImage(Texture.fromColor(200,20,0xFF00FFFF),true);
//			_button_backCity.label = "回城";
//			_button_backCity.name = "back"
//			_button_backCity.addEventListener(Event.TRIGGERED,_onClickBack);
//			_button_backCity.x = 230;
//			_button_backCity.y = 20;
//			addChild(_button_backCity);
		}
		public function showFast(value:Boolean):void
		{
			_showfast = value;
			if(_showfast)
			{
				_button_back.scaleX = 1.2;
				_button_back.scaleY = 1.2;
				_button_back.x = (SApplicationConfig.o.stageWidth - _button_back.defaultSkin.width * 1.2) >> 1;
				_button_back.y = SApplicationConfig.o.stageHeight - _button_back.defaultSkin.height * 1.2;
			}
			this.invalidate();
			var sec:int = int(CJDataOfGlobalConfigProperty.o.getData("SUZHANSUJUE_ENABLE_DELAY"));
			if(!_showfast)
			{
				Starling.juggler.delayCall(_suzhansujueEnable, sec);	
			}
		}
		
		private function _suzhansujueEnable():void
		{
			_showfast = true;
			_button_back.scaleX = 1.2;
			_button_back.scaleY = 1.2;
			_button_back.x = (SApplicationConfig.o.stageWidth - _button_back.defaultSkin.width * 1.2) >> 1;
			_button_back.y = SApplicationConfig.o.stageHeight - _button_back.defaultSkin.height * 1.2;
			this.invalidate();
		}
		
		
		private function _onClickBack(e:Event):void
		{
			switch((e.currentTarget as Button).name)
			{
				case "end":
					if((e.currentTarget as Button).filter)
					{
						CJMessageBox(CJLang("FUBEN_SUZHANSUJUE_DISABLE"),function():void
						{
							
						});
					}
					else 
					{
						_relayhandler.playtoend();
					}		
					break;
				case "back":
					SApplication.moduleManager.exitModule("CJFubenBattleModule");
					SApplication.moduleManager.exitModule("CJFubenBattleBaseModule");
//					SApplication.moduleManager.enterModule("CJMainUiModule");
					CJLoaderMoudle.helper_enterMainUI();
					break;
			}
			
		}
	}
}