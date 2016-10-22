package SJ.Game.duobao
{
	import SJ.Common.Constants.ConstFilter;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class CJDuoBaoBattleTopLayer extends SLayer
	{
		private var _relayhandler:CJBattleReplayManager;	
		private var _showfast:Boolean = false;
		private var _button_back:Button;
		
		public function CJDuoBaoBattleTopLayer(ReplayManager:CJBattleReplayManager)
		{
			super();
			_relayhandler = ReplayManager;
			_init();
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
				_button_back.filter = null;
			}
		}
		
		private function _init():void
		{
			_button_back = new Button();
			var texture:Texture = SApplication.assets.getTexture("common_suzhansujue");
			_button_back.defaultSkin = new SImage(texture);
			_button_back.name = "end";
			_button_back.addEventListener(Event.TRIGGERED,_onClickBack);
			_button_back.x = (SApplicationConfig.o.stageWidth - _button_back.defaultSkin.width) >> 1;
			_button_back.y = SApplicationConfig.o.stageHeight - _button_back.defaultSkin.height;
			addChild(_button_back);
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
						CJMessageBox(CJLang("DUOBAO_SUZHANSUJUE_DISABLE"),function():void
						{
							
						});
					}
					else 
					{
						_relayhandler.playtoend();
					}	
					break;
			}
		}
	}
}