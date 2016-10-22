package SJ.Game.battle.data
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	
	
	/**
	 * Qte阵型数据 
	 * @author caihua
	 * 
	 */
	public class CJBattleQteFormation
	{
		public function CJBattleQteFormation(mtype:uint)
		{
			_posObject = new Dictionary();
			_type = mtype;
		}
		
		
		private var _count:int = 0;

		/**
		 * qte按键数量 
		 */
		public function get count():int
		{
			return _count;
		}

		
		private var _type:int = 0;

		/**
		 * qte类型ID 
		 */
		public function get type():int
		{
			return _type;
		}

		
		/**
		 * 位置索引 
		 */
		private var _posObject:Dictionary;
		
		
		public function addPos(posid:uint,x:uint,y:uint):void
		{
			if(posid + 1>_count)
			{
				_count = posid + 1;
			}
			_posObject[posid] = new Point(x,y);
			
		}
		
		public function getPos(posid:uint):Point
		{
			return _posObject[posid % _count];	
		}
	}
}