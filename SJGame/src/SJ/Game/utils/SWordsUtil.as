package SJ.Game.utils
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 +------------------------------------------------------------------------------
	 * 计算字符串的长度
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-26 下午4:49:30  
	 +------------------------------------------------------------------------------
	 */
	public class SWordsUtil
	{
		private static var _cnFeeds:String = "神将工作室";
		private static var _enFeeds:String = "abcde";
		private static var _tf:TextFormat = new TextFormat("黑体",10);
		private static var _regExp:RegExp = new RegExp("\\w|\\s" , "ig") ;
		
		public static function getStandardTextWidth(text:String , textFormat:TextFormat = null):int
		{
			if(!textFormat)
			{
				textFormat = _tf;
			}
			
			var words:int = text.split("").length;
			var enWords:Array = text.match(_regExp);
			var enWordsCount:int = enWords ? enWords.length : 0 ;
			return enWordsCount*standardEnWordsWidth(textFormat) + (words - enWordsCount)*standardCnWordsWidth(textFormat);
		}
		
		public static function getWordsBitMap(text:String):Array
		{
			var words:Array = text.split("");
			var length:int = words.length;
			var bitmap:Array = new Array(length);
			for(var i:int = 0 ; i < length ; i++)
			{
				bitmap[i] = words[i].match(new RegExp("\\w")) ? 0 : 1;
			}
			return bitmap;
		}
		
		public static function standardCnWordsWidth(textFormat:TextFormat = null):int
		{
			return Math.floor(getAccurateTextWidth(_cnFeeds , textFormat)/_cnFeeds.split("").length);
		}
		
		public static function standardEnWordsWidth(textFormat:TextFormat = null):int
		{
			return Math.floor(getAccurateTextWidth(_enFeeds , textFormat)/_enFeeds.split("").length);
		}
		
		public static function getAccurateTextWidth(text:String, textFormat:TextFormat):int
		{
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.wordWrap = false;
			tf.defaultTextFormat = textFormat;
			tf.text = text;
			return tf.textWidth;
		}
		
		public static function reproduceString(text:String , width:int , textFormat:TextFormat = null):String
		{
			if(text == null || text =="")
			{
				return text;
			}
			if(!textFormat)
			{
				textFormat = _tf;
			}
			var standardWidth:int = getStandardTextWidth(text , textFormat);
			if(standardWidth < width)
			{
				return text;
			}
			
			var words:Array = text.split("");
			var length:int = words.length;
			var wordsMap:Array = getWordsBitMap(text);
			var resultString:String = "";
			var currentLength:int = 0;
			var cnLen:int = standardCnWordsWidth(textFormat);
			var enLen:int = standardEnWordsWidth(textFormat);
			for(var i:int = 0 ; i < length ; i++)
			{
				var currentWordLen:int;
				if(int(wordsMap[i]) == 1)
				{
					currentWordLen = cnLen;	
				}
				else
				{
					currentWordLen = enLen;
				}
				currentLength += currentWordLen;
				if(currentLength >= width)
				{
					resultString += "<br/>" + words[i];
					currentLength = currentWordLen;
				}
				else
				{
					resultString += words[i];
				}
			}
			return resultString + "<br/>";
		}
	}
}