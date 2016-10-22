package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 +------------------------------------------------------------------------------
	 * @name 阵型静态配置列表类
	 * @todo 后续改进增加统一的dao静态映射
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-3 上午10:03:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataFormationPropertyList
	{
		private static var _o:CJDataFormationPropertyList;
		private var _formationList:Array;
		
		public function CJDataFormationPropertyList()
		{
			_initData();
		}
		
		public static function get o():CJDataFormationPropertyList
		{
			if(_o == null)
				_o = new CJDataFormationPropertyList();
			return _o;
		}
		
		/**
		 * 组织形式
		 * array(
		 * 		    0 =>  CJDataFormation 对象 ，代表阵型 0  ，主武将位置;
		 * 			1 =>  CJDataFormation 对象 ，代表阵型 0  ，武将第一个位置;
		 * 			......
		 * 			5 =>  CJDataFormation 对象 ，代表阵型 0  ，武将第五个位置;
		 * ) 
		 */		
		private function _initData():void
		{
			_formationList = new Array();
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonBeforeBattleFormation) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var formation:CJDataFormationPositionProperty = new CJDataFormationPositionProperty(obj[i]);
				_formationList[i] = formation;
			}
		}
		
		/**
		 * 获取阵型配置 
		 * @return array(
		 * 			0 =>  CJDataFormation 对象 ，代表阵型 0  ，主武将位置;
		 * 			1 =>  CJDataFormation 对象 ，代表阵型 0  ，武将第一个位置;
		 * 			......
		 * 			5 =>  CJDataFormation 对象 ，代表阵型 0  ，武将第五个位置;
		 * 		);
		 */		
		public function getFormationList():Array
		{
			return _formationList;
		}
		
		/**
		 * 
		 * @param posid :int 位置标号
		 * @return 对应位置的配置数据
		 */		
		public function getFormationByPosid(posid:int):CJDataFormationPositionProperty
		{
			return this._formationList[posid];
		}

		public function get size():int
		{
			return _formationList.length;
		}
	}
}