package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_npc_talk_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	/**
	 *  NPC对白
	 * @author yongjun
	 * 
	 */	
	public class CJDataOfNpcTalkProperty
	{
		
		private var _dataDict:Dictionary
		public function CJDataOfNpcTalkProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfNpcTalkProperty;
		public static function get o():CJDataOfNpcTalkProperty
		{
			if(_o == null)
				_o = new CJDataOfNpcTalkProperty();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonNPCTalkConfig) as Array;
			if(obj == null)
			{
				return;
			}
			_dataDict = new Dictionary;
			for(var i:String in obj)
			{
				var jsonObj:Json_npc_talk_setting = new Json_npc_talk_setting;
				jsonObj.loadFromJsonObject(obj[i])
				_dataDict[jsonObj.talkid] = jsonObj
			}
		}
		/**
		 * 根据ID获取对话数组 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getConfigById(id:int):Array
		{

			if(!_dataDict.hasOwnProperty(id))
			{
				return null;
			}
			var data:Array = new Array;
			for(var i:int =1;i<=20;i++)
			{
				var key:String = "talk"+String(i);
				if(_dataDict[id][key])
				{
					data.push(_dataDict[id][key]);
				}
			}
			return data;
		}
	}
}