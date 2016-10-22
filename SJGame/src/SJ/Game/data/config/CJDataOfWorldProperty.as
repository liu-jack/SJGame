package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 *  世界地图
	 * @author yongjun
	 * 
	 */
	public class CJDataOfWorldProperty
	{
		public function CJDataOfWorldProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfWorldProperty;
		public static function get o():CJDataOfWorldProperty
		{
			if(_o == null)
				_o = new CJDataOfWorldProperty();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		private function _initData():void
		{
			_dataDict = new Dictionary;
			var mainConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResWorld) as Array;
			for(var i:String in mainConf)
			{
				_dataDict[int(mainConf[i].id)] = mainConf[i];
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getData(type:String):Dictionary
		{
			var list:Dictionary = new Dictionary
			for(var i:String in _dataDict)
			{
				if(_dataDict[i].type == 0)
				{
					list[i] = _dataDict[i];
				}
				if(_dataDict[i].type>0)
				{
					if(type == ConstFuben.FUBEN_SUPER && _dataDict[i].type == 2)	
					{
						list[i] = _dataDict[i]				
					}
					if(type == ConstFuben.FUBEN_COMMON && _dataDict[i].type == 1)
					{
						list[i] = _dataDict[i]
					}
				}
			}
			return list;
		}
		
		/**
		 * 是否是普通副本
		 */ 
		public function isNormalFB(fid:int):Boolean
		{
			var list:Dictionary = this.getData(ConstFuben.FUBEN_COMMON);
			for(var i:String in list)
			{
				var data:Object = list[i];
				if(int(data.itemid) == int(fid))
				{
					return true;
				}
			}
			return false;
		}
	}
}