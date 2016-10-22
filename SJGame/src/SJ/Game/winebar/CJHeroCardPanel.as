package SJ.Game.winebar
{
	import SJ.Common.Constants.ConstWinebar;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfWinebar;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	/**
	 * 武将卡牌面板
	 * @author longtao
	 * 
	 */
	public class CJHeroCardPanel extends SLayer
	{
		// 武将卡牌管理器
		private var _heroCardsVec:Vector.<CJHeroCardItem> = new Vector.<CJHeroCardItem>;
		// 武将卡牌间隙
		private const _constGap:int = 0;
		private var _quad:Quad;
		
		public function CJHeroCardPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_init();
		}
		
		private function _init():void
		{
			var goalX:Number = (2*CJHeroCardItem._CONST_WIDTH_ + 2*_constGap) + CJHeroCardItem._CONST_WIDTH_/2;
			var goalY:Number = 20 + CJHeroCardItem._CONST_HEIGHT_/2;
			for (var index:uint=0; index<ConstWinebar.ConstWinebarMaxHeroCards; ++index)
			{
				var temp:CJHeroCardItem = new CJHeroCardItem;
				temp.index = index.toString();
				// 设置位置与移动到的位置
				temp.homePos = new Point((index*temp.width + index*_constGap) + temp.width/2, 20 + temp.height/2); 
				temp.moveToPos = new Point(goalX, goalY);
				_heroCardsVec.push(temp);
				addChild(temp);
			}
			
			_quad = new Quad(480 , 175);
			_quad.alpha = 0;
			_quad.x = 0;
			_quad.y = 30;
			_quad.touchable = false;
			_quad.name = "CLICK_CARD_PANEL";
			this.addChild(_quad);
		}
		
		
		/**
		 * 更新界面
		 */
		public function updateLayer():void
		{
			var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			var isPlaying:Boolean = false;
			// 刷新每一个界面
			for (var index:uint=0; index<ConstWinebar.ConstWinebarMaxHeroCards; ++index)
			{
				var temp:CJHeroCardItem = _heroCardsVec[index];
				if (temp.isplaying)
					return;
			}
			for (index=0; index<ConstWinebar.ConstWinebarMaxHeroCards; ++index)
			{
				temp = _heroCardsVec[index];
				temp.updateLayer();
			}
		}
		
		
		/**
		 * 洗牌
		 */
		public function cutCards():void
		{
			// 刷新每一个界面
			for (var index:uint=0; index<ConstWinebar.ConstWinebarMaxHeroCards; ++index)
			{
				var temp:CJHeroCardItem = _heroCardsVec[index];
				temp.cardBackAndTurn();
			}
		}
		
		/**
		 * 是否在播放动画
		 * @return 
		 */
		public function get isplaying():Boolean
		{
			// 刷新每一个界面
			for (var index:uint=0; index<ConstWinebar.ConstWinebarMaxHeroCards; ++index)
			{
				var temp:CJHeroCardItem = _heroCardsVec[index];
				if (temp.isplaying)
					return true;
			}
			return false;
		}
	}
}




