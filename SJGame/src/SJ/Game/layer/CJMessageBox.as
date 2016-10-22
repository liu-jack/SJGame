package SJ.Game.layer
{
	import SJ.Game.layer.CJLayerManager;
	
	import starling.core.Starling;
	
	/** 只有确定按钮的提示框
	 * msg：提示文字 ， 
	 * callBack：点击确定后的回调
	 */
	public function CJMessageBox(msg:String,callBack:Function = null):void
	{
		var alertLayer:CJMessageBoxLayer = CJMessageBoxLayer.o;
		if(alertLayer.parent)return;
		alertLayer.text = msg;
		alertLayer.callBack = callBack;
		alertLayer.x = (Starling.current.stage.stageWidth - alertLayer.width)>>1;
		alertLayer.y = (Starling.current.stage.stageHeight - alertLayer.height)>>1;
//		CJLayerManager.o.addToModal(alertLayer);
		CJLayerManagerWrapper.o.addToModalSequence(alertLayer);
	}
}