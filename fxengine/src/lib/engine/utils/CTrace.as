package lib.engine.utils
{
	
	/**
	 * 调试输出 
	 */
	public function CTrace(info:String,... params):void
	{
		var paramsobj:Object = new Object();
		for(var key:String in params)
		{
			paramsobj[key] = params[key];
		}
		var traceString:String = CStringUtils.replaceStringByKey(info,paramsobj);
		CLogUtils.o._print(CLogUtils._DEBUGFLAG,traceString);
	}
	
}