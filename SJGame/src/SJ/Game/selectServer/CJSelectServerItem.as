package SJ.Game.selectServer
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.formation.CJItemTurnPageBase;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	
	public class CJSelectServerItem extends CJItemTurnPageBase
	{
		private static const _ITEM_WIDTH_:uint = 275;
		private static const _ITEM_HEIGHT_:uint = 35;
		
		/** 左侧按钮 **/
		private var _btnLeft:CJSelectServerBtn;
		
		/** 右侧按钮 **/
		private var _btnRight:CJSelectServerBtn;
		
		
		public function CJSelectServerItem()
		{
			super("CJSelectServerItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			setSize(_ITEM_WIDTH_, _ITEM_HEIGHT_);
			
			/// 初始化左侧部分
			_btnLeft = new CJSelectServerBtn;
			_btnLeft.x = 15;
			_btnLeft.y = 12;
			addChild(_btnLeft);
			
			/// 初始化右侧部分
			_btnRight = new CJSelectServerBtn;
			_btnRight.x = 137;
			_btnRight.y = _btnLeft.y;
			addChild(_btnRight);
		}
		
		override protected function onSelected():void
		{
			
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)// 判断是否应该刷新
			{
//				data = {id:serjson.id,
//						recommend:serjson.recommend,
//						servername:serjson.servername,
//						servermaxuser:serjson.servermaxuser,
//						state:CJSelectServerBtn.SELECT_STATE_MAINTAIN,
//						weight: int(serjson.recommend)*1000000 + serjson.id};
				var objLeft:Object = data.left;
				if(objLeft)
				{
					_btnLeft.serverid = objLeft.id;
					_btnLeft.isRecommend = objLeft.recommend==0 ? false : true;
					_btnLeft.serverName = objLeft.servername;
				}
				else
					_btnLeft.visible = false;
				
				var objRight:Object = data.right;
				if(objRight)
				{
					_btnRight.serverid = objRight.id;
					_btnRight.isRecommend = objRight.recommend==0 ? false : true;
					_btnRight.serverName = objRight.servername;
				}
				else
					_btnRight.visible = false;
				
			}
		}
		
	}
}