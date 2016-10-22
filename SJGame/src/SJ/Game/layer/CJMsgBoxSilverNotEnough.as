package SJ.Game.layer
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFunctionList;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	/**
	 * 弹出银两不足提示框，自动判断是否显示“去摇钱树”按钮
	 * @param msg          : 提示语
	 * @param btnText      : 按钮语言
	 * @param callbackSure : 回调函数 - 确定按钮
	 * @param callbackClose: 回调函数 - 关闭界面
	 */	
	public function CJMsgBoxSilverNotEnough(msg:String = "", 
											btnText:String = "", 
											callbackSure:Function = null, 
											callbackClose:Function = null):void
	{
		var alertLayer:CJPanelMessageBoxLayer = new CJPanelMessageBoxLayer();
		
		// 提示语
		if ("" == msg)
		{
			msg = CJLang("MONEYTREE_MSGBOX_TEXT_GOTO");
		}
		alertLayer.labelText = msg;
		
		// 按钮语言
		if ("" == btnText)
		{
			btnText = CJLang("BTN_GOTO_MONEYTREE");
		}
		alertLayer.buttonText = btnText;
		
		// 回调函数 - 确定按钮
		if (callbackSure != null)
		{
			alertLayer.callbackSure = callbackSure;
		}
		
		// 回调函数 - 关闭界面
		if (callbackClose != null)
		{
			alertLayer.callbackClose = callbackClose;
		}
		alertLayer.callBackSureSec = function():void {
			SApplication.moduleManager.enterModule("CJMoneyTreeModule");
		};
			
		// 按钮显示
		var dataFunctionList:CJDataOfFunctionList = CJDataManager.o.getData("CJDataOfFunctionList");
		alertLayer.showButton = dataFunctionList.isFunctionOpen("CJMoneyTreeModule");
		
		CJLayerManager.o.addToModal(alertLayer);
		
		// 按钮宽度
		var addWidth : int = 16;
		alertLayer.buttonWidth = alertLayer.buttonWidth + addWidth;
		alertLayer.buttonX = alertLayer.buttonX - (addWidth / 2);
		
	}
}