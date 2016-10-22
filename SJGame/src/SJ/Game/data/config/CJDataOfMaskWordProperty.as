package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_mask_word_config;
	
	import engine_starling.utils.AssetManagerUtil;
	

	/**
	 * 屏蔽字
	 * @author longtao
	 * 
	 */
	public class CJDataOfMaskWordProperty
	{
		private static var _o:CJDataOfMaskWordProperty;
		public static function get o():CJDataOfMaskWordProperty
		{
			if(_o == null)
				_o = new CJDataOfMaskWordProperty();
			return _o;
		}
		
		private var _regExp:RegExp;
		
		public function CJDataOfMaskWordProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonMaskWord) as Array;
			if(obj == null)
			{
				return;
			}
			var str:String = new String;
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var heroProperty:Json_mask_word_config = new Json_mask_word_config();
				heroProperty.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				var markword:String = obj[i]['maskword'].toString();
				str += markword + "|";
			}
			str = str.substring(0, str.length-1);
			
			// 将屏蔽字中的 * 符号替换为  \\*  保证正则表达式正常运行
			var myPattern:RegExp = new RegExp("\\*", "gi");
			var strworked:String = str.replace(myPattern, "\\\*");
			
			_regExp = new RegExp(strworked , "gi") ;
		}
		
		/**
		 * 判断该字符串是否包含屏蔽字
		 * @param value 需检测的字符串
		 * @return 		true存在屏蔽字
		 */
		public function isMaskWord(value:String):Boolean
		{
			// 是否查询到有屏蔽字符
			var isFind:Boolean = false;
			for (var i:int=0; i<value.length; ++i)
			{
				var k:String = value.charAt(i);
				if (k == "\\")
					isFind = true;
			}
			// 存在反斜杠直接返回有屏蔽字
			if (isFind)
				return true;
			// 进行正则表达
			return _regExp.test(value);
		}
		
		/**
		 * 过滤屏蔽字
		 * @input :输入的字符串
		 */ 
		public function filterString(input:String):String
		{
			var matchList:Array = input.match(_regExp);
			for(var i:String in matchList)
			{
				var x:String = "";
				for(var j:int = 0 ; j < String(matchList[i]).length ; j++)
				{
					x += "*";
				}
				input = input.replace(matchList[i] ,x);
			}
			return input;
		}
	}
}