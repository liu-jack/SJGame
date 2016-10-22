package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 *  
	 * @author yongjun
	 * 
	 */
	public class CJDataOfLangProperty
	{
		public function CJDataOfLangProperty()
		{
			_init();
		}
		
		private static var _o:CJDataOfLangProperty;
		private var _dictCn:Dictionary;
		private var _dictEn:Dictionary;
		public static function get o():CJDataOfLangProperty
		{
			if(_o == null)
				_o = new CJDataOfLangProperty();
			return _o;
		}
		private function _init():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonLang) as Array;
			var len:int = obj.length;
			if( len > 0)
			{
				_dictCn = new Dictionary;
				_dictEn = new Dictionary;
				for(var i:int = 0; i < len; i++)
				{
					_dictCn[obj[i].languageid] = obj[i].zn;
					_dictEn[obj[i].languageid] = obj[i].en;
				}
			}
		}
		/**
		 * 获取中文字符串 
		 * @param id
		 * @return 
		 * 
		 */
		public function getCn(id:String):String
		{
			if(_dictCn.hasOwnProperty(id))
			{
				return _dictCn[id];
			}
			return "";
		}
		/**
		 *  获取英文字符串
		 * @param id
		 * @return 
		 * 
		 */
		public function getEn(id:String):String
		{
			return _dictEn[id];
		}
		
	}
}