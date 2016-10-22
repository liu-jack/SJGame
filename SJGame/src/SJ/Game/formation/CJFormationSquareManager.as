package SJ.Game.formation
{
	/**
	 +------------------------------------------------------------------------------
	 * @comment 阵型方块管理器用于计算武将的位置
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-3 上午09:52:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationSquareManager
	{
		/*保存阵型所有方块*/
		private var _squareList:Array;
		/*阵型方块数量 包含主将*/
		public static const SQUARE_NUM:int = 6;
		
		private static var INSTANCE:CJFormationSquareManager = null;
		
		public function CJFormationSquareManager()
		{
			this._init();
		}
		
		public static function get o():CJFormationSquareManager
		{
			if(INSTANCE == null)
			{
				INSTANCE = new CJFormationSquareManager();
			}
			return INSTANCE;
		}
		
		/**
		 * 生成方块 
		 */		
		private function _init():void
		{
			this._squareList = new Array();
			for (var i:int = 0; i < SQUARE_NUM; i++) 
			{
				var square:CJFormationSquare = new CJFormationSquare(i);
				this._squareList[i] = square;
			}
		}
		
		/**
		 *  根据阵型类型获得方块列表
		 */		
		public function getSquareList():Array
		{
			return this._squareList;
		}
		
		/**
		 *  根据前后排武将确定显示的方块
		 */		
		public function showSquare():void
		{
			var len:int = this._squareList.length;
			for (var i:int = 0; i < len; i++) 
			{
				var square:CJFormationSquare = this._squareList[i];
				square.showSquare();
			}
		}
		
		/**
		 *  武将放置以后 隐藏所有的方块
		 */		
		public function hideAllSquare():void
		{
			for each(var item:CJFormationSquare in this._squareList)
			{
				item.hideSquare();
			}
		}
		
		/**
		 * 销毁 
		 */		
		public function dispose():void
		{
			for(var i:int = 0;i < SQUARE_NUM ; i++)
			{
				var square:CJFormationSquare = this._squareList[i] as CJFormationSquare;
				if(square.parent)
				{
					square.removeFromParent(true);
				}
				else
				{
					square.dispose();
				}
			}
			this._squareList = null;
			INSTANCE = null;
		}
	}
}