package SJ.Game.layer
{
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.lang.CJLang;
	
	import feathers.controls.Button;
	
	import starling.events.Event;

	public class CJBuyVitConfirmLayer extends CJConfirmMessageBoxLayer
	{
		private var _quedingButton:Button;
		private var _quxiaoButton:Button;
		private var _space:Number = 39;
		public function CJBuyVitConfirmLayer()
		{
			super();
			
		}
		override protected function _initButton():void
		{
			_quedingButton = CJButtonUtil.createCommonButton(CJLang("COMMON_TRUE"));
			_quedingButton.addEventListener(Event.TRIGGERED,_touchHandler);
			_quedingButton.labelOffsetY = -1;
			_quedingButton.x = 20;
			_quedingButton.y = this.height- _space;
			this.addChild(_quedingButton);
			
			_quxiaoButton = CJButtonUtil.createCommonButton(CJLang("FUBEN_BUYVIT_BTN"));
			_quxiaoButton.addEventListener(Event.TRIGGERED,_cancelHandler);
			_quxiaoButton.labelOffsetY = -1;
			_quxiaoButton.x = 130;
			_quxiaoButton.y = _quedingButton.y;
			this.addChild(_quxiaoButton);
		}
	}
}