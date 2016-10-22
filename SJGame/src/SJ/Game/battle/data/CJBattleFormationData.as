package SJ.Game.battle.data
{
	import SJ.Common.Constants.ConstBattle;
	
	import flash.geom.Point;

	public class CJBattleFormationData
	{
		public function CJBattleFormationData()
		{
			_posObj = new Object();
		}
		
		private var _posObj:Object;
		
//		public function getSelfPlayerPos():Point{
//			return _posObj[0]["pos"];
//		}
		public function getSelfNpcPos(LocationIndex:uint):Point{
			return _posObj[LocationIndex % ConstBattle.ConstMaxLocationNum]["pos"];	
		}
//		public function getOtherPlayerPos():Point{
//			return _posObj[ConstBattle.ConstLocationOffSet]["pos"];
//		}
		public function getOtherNpcPos(LocationIndex:uint):Point{
			return _posObj[LocationIndex % ConstBattle.ConstMaxLocationNum  + ConstBattle.ConstLocationOffSet]["pos"];
		}
		public function addPos(LocationIndex:uint,x:int,y:int,postionType:int):void
		{
			_posObj[LocationIndex] = {"pos":new Point(x,y),"postionType":postionType};
		}
		
	}
}