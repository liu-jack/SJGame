package lib.engine.utils.functions
{
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import lib.engine.utils.CStringUtils;
	
	/**
	 * 就是Assert了... 
	 * @param expression 表达式 false的是否抛出异常
	 * @param message 弹出的信息{0}...{n}
	 * @param params 参数化内容,
	 */
	
	CONFIG::debug public function Assert(expression:Boolean,message:String = "",... params):void
	{
		if(SPlatformUtils.isReleaseBuild())
			return;
		
		var paramsobj:Object = new Object();
		for(var key:String in params)
		{
			paramsobj[key] = params[key];
		}
		var traceString:String = CStringUtils.replaceStringByKey(message,paramsobj);
		if(!expression)
		{
//			if (PlatformUtils.isDebug())
//			{
//				throw Error(traceString);
//			}
//			else
//			{
				Logger.log("Assert",traceString);
//			}
		}
	}
	CONFIG::release public function Assert(expression:Boolean,message:String = "",... params):void
	{
		
	}
}