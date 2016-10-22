package SJ.Game.battle
{
	import engine_starling.display.SLayer;
	
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.extensions.PDParticleSystem;
	
	public class CJBattleQTELayer extends SLayer
	{
		private var _bgImage:Image;
		private var particle:PDParticleSystem;
		private var _particles:Vector.<PDParticleSystem>;
		private var _qteShow:CJBattleQTEShowTip;
		private var _onfinish:Function;
		private var _mjugger:Juggler;
		
		
		
		//持续时间
		private var _duringTime:int;

		public function get duringTime():int
		{
			return _duringTime;
		}

		public function set duringTime(value:int):void
		{
			_duringTime = value;
		}

		
		
		
		public function CJBattleQTELayer(onfinish:Function,mjugger:Juggler)
		{
			super();
			_onfinish = onfinish;
			_mjugger = mjugger;
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		override protected function initialize():void
		{
//			_bgImage = new Image(SApplication.assets.getTexture("qte_di"));	
			_qteShow = new CJBattleQTEShowTip(_onfinish,_mjugger);	
			_qteShow.duringTime = _duringTime;
			addChild(_qteShow);
			super.initialize();
		}
		

		
		
	}
}