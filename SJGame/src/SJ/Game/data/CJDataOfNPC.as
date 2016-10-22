package SJ.Game.data
{
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	/**
	 * NPC数据信息
	 * @author zhengzheng
	 * 
	 */
	public class CJDataOfNPC
	{
		public function CJDataOfNPC()
		{
			_initData();
		}
		
		private static var _o:CJDataOfNPC;
		public static function get o():CJDataOfNPC
		{
			if(_o == null)
				_o = new CJDataOfNPC();
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
			var npcConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonNPC) as Array;
			for(var i:String in npcConf)
			{
				_dataDict[int(npcConf[i].id)] = npcConf[i];
			}
		}
		

		/**
		 * 通过id获取NPC信息
		 * @param id NPC标识
		 * @return NPC信息实例
		 * 
		 */
		public function getNpcInfo(id:int):Object
		{
			return _dataDict[id];
		}
	}
}