package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_scene_npc_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 * NPC数据信息
	 * @author zhengzheng
	 * 
	 */
	public class CJDataOfScreenNPCProperty
	{
		public function CJDataOfScreenNPCProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfScreenNPCProperty;
		public static function get o():CJDataOfScreenNPCProperty
		{
			if(_o == null)
				_o = new CJDataOfScreenNPCProperty();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		/**
		 * 从json获取NPC数据信息 
		 * 
		 */		
		private function _initData():void
		{
			_dataDict = new Dictionary;
			var npcConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonSceneNpcSetting) as Array;
			for(var i:String in npcConf)
			{
				var json:Json_scene_npc_setting = new Json_scene_npc_setting
				json.loadFromJsonObject(npcConf[i]);
				_dataDict[json.npcid] = json;
			}
		}
		
		/**
		 * 获取地图NPC配置信息
		 * @param id
		 * @return 
		 */
		public function getNpcInfo(id:int):Array
		{
			var arr:Array = new Array;
			for(var j:String in this._dataDict)
			{
				if(int(this._dataDict[j].id) == id)
				{
					var it:Object = {id:this._dataDict[j]["npcid"],x:this._dataDict[j]["npcx"],y:this._dataDict[j]["npcy"]}
					arr.push(it);
				}
			}
			return arr;
		}
		
		/**
		 * npc的配置
		 * @param npcid
		 */		
		public function getNpcConfig(npcid:int):Json_scene_npc_setting
		{
			return this._dataDict[npcid];
		}
		
		/**
		 * 取得NPC在哪个主城
		 * @return NPC所在的场景id
		 */		
		public function getNpcScene(npcid:int):int
		{
			return (this._dataDict[npcid] as Json_scene_npc_setting).id;
		}
	}
}