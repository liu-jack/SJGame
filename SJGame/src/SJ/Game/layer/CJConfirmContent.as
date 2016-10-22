package SJ.Game.layer
{
	import SJ.Game.layer.CJLayerManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * 确认提示框，有确定和取消2个按钮
	 *  
	 */
	public function CJConfirmContent(displayObj:CJConfirmMessageBoxLayer,msg:String,callBack:Function,cancelBack:Function = null):void
	{
		if(displayObj.parent) return;
		displayObj.text = msg
		displayObj.callBack = callBack;
		displayObj.cancelBack = cancelBack;
		displayObj.x = (Starling.current.stage.stageWidth - displayObj.width)>>1;
		displayObj.y = (Starling.current.stage.stageHeight - displayObj.height)>>1;
		CJLayerManager.o.addToModal(displayObj);
	}
}