package SJ.Game.data.config
{
	import mx.utils.ObjectUtil;

	/**
	 +------------------------------------------------------------------------------
	 * @name 阵型静态配置DAO类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-3 上午9:19:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataFormationPositionProperty
	{
		/*位置标识 0 - 5 */
		private var _posid:int = 0 ;
		/*位置标识 0 -前排 1 -后排*/
		private var _postiontype:int = 0 ;
		/*武将位置x*/
		private var _postionx:Number = 0 ;
		/*武将位置y*/
		private var _postiony:Number = 0 ;
		
		private static var _plist:Array = ["posid","postiontype","postionx","postiony"]; 
		
		public function CJDataFormationPositionProperty(dataList:Object = null)
		{
			if(dataList == null)
			{
				return ;
			}
			if(_plist == null)
			{
				_plist = ObjectUtil.getClassInfo(CJDataFormationPositionProperty).properties as Array;
			}
			for each(var p:* in _plist)
			{
//				if(dataList.hasOwnProperty(p))
//				{
					this[p] = dataList[p];
//				}
			}
		}
		
		public function get posid():int
		{
			return _posid;
		}

		public function set posid(value:int):void
		{
			_posid = value;
		}

		public function get postiontype():int
		{
			return _postiontype;
		}

		public function set postiontype(value:int):void
		{
			_postiontype = value;
		}

		public function get postionx():Number
		{
			return _postionx;
		}

		public function set postionx(value:Number):void
		{
			_postionx = value;
		}

		public function get postiony():Number
		{
			return _postiony;
		}

		public function set postiony(value:Number):void
		{
			_postiony = value;
		}

		
	}
}