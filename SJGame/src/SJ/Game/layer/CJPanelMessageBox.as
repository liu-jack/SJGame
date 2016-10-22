package SJ.Game.layer
{
	import SJ.Game.layer.CJLayerManager;
	
	import starling.core.Starling;
	
	/** 
	 * 只有确定按钮的提示框
	 * @param msg          : 提示语
	 * @param showButton   : 是否显示按钮
	 * @param btnText      : 按钮语言
	 * @param callbackSure : 回调函数 - 确定按钮
	 * @param callbackClose: 回调函数 - 关闭界面
	 */
	public function CJPanelMessageBox(msg:String, 
									  showButton:Boolean = true, 
									  btnText:String = null, 
									  callbackSure:Function = null):void
	{
		var alertLayer:CJPanelMessageBoxLayer = new CJPanelMessageBoxLayer();
		// 提示语
		alertLayer.labelText = msg;
		
		// 是否显示按钮
		alertLayer.showButton = showButton;
		
		// 按钮语言
		if (btnText != null)
		{
			alertLayer.buttonText = btnText;
		}
		
		// 回调函数 - 确定按钮
		if (callbackSure != null)
		{
			alertLayer.callbackSure = callbackSure;
		}
		
//		alertLayer.x = (Starling.current.stage.stageWidth - alertLayer.width)>>1;
//		alertLayer.y = (Starling.current.stage.stageHeight - alertLayer.height)>>1;
		CJLayerManager.o.addToModal(alertLayer);
	}
}