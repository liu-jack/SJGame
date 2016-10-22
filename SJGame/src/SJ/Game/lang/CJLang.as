package SJ.Game.lang
{
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Game.data.config.CJDataOfLangProperty;
	
	import engine_starling.utils.SStringUtils;
	
	/**
	 * id:语言表中的标示
	 * params：需要替换的字符串  格式{'name':xxx,'age':12}   替换语言表中的{name},{age}
	 *  
	 */
	public function CJLang(id:String,params:Object = null):String
	{
		var str:String = "";
		switch(ConstGlobal.LANG)
		{
			case "CN":
				str = CJDataOfLangProperty.o.getCn(id);
				break;
			case "EN":
				str = CJDataOfLangProperty.o.getEn(id);
				break;
		}
		return SStringUtils.replaceStringByKey(str,params);
//		if(params!=null)
//		{
//			SStringUtils.replaceStringByKey(str,params);
//			for(var i:String in params)
//			{
//				if(-1 != str.indexOf("{"+ i +"}"))
//				{
//					str = str.replace("{"+ i +"}",params[i]);
//				}
//			}
//		}
//		return str;
	}
}