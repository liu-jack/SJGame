package SJ.Game.layer
{
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import starling.core.Starling;
	
	/**
	 * 确认提示框，有确定和取消2个按钮
	 *  
	 */
	public function CJConfirmMessageBox(msg:String,okcallBack:Function,cancelcallBack:Function = null,okbuttontext:String = null,cancelbuttontext:String = null):void
	{
		var alertLayer:CJConfirmMessageBoxLayer = CJConfirmMessageBoxLayer.o;
		if(alertLayer.parent) return;
		alertLayer.text = msg;
		alertLayer.callBack = okcallBack;
		alertLayer.cancelBack = cancelcallBack;
		if(okbuttontext != null)
		{
			alertLayer.oktext = okbuttontext;
		}
		else
		{
			alertLayer.oktext = CJLang("COMMON_TRUE");
		}
		if(cancelbuttontext != null)
		{
			alertLayer.canceltext = cancelbuttontext;
		}
		else
		{
			alertLayer.canceltext = CJLang("COMMON_CANCEL");
		}
		alertLayer.x = (Starling.current.stage.stageWidth - alertLayer.width)>>1;
		alertLayer.y = (Starling.current.stage.stageHeight - alertLayer.height)>>1;
		CJLayerManager.o.addToModal(alertLayer);
	}
}