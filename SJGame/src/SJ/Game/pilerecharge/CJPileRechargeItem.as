package SJ.Game.pilerecharge
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.bag.CJItemTooltip;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	
	import feathers.controls.ImageLoader;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJPileRechargeItem extends CJItemTurnPageBase
	{
		private static const CONST_WIDTH:int = 290;
		private static const CONST_HEIGHT:int = 54;
		
		private static const ARR_COLOR:Array = new Array( 
			ConstTextFormat.TEXT_COLOR_WIGHT_STR,
			ConstTextFormat.TEXT_COLOR_WIGHT_STR,
			ConstTextFormat.TEXT_COLOR_GREEN_STR,
			ConstTextFormat.TEXT_COLOR_BLUE_STR,
			ConstTextFormat.TEXT_COLOR_PURPLE_STR,
			ConstTextFormat.TEXT_COLOR_ORANGE_STR,
			ConstTextFormat.TEXT_COLOR_RED_STR
		);
		
		private var _text:CJTaskLabel = new CJTaskLabel;
		// 是否领取该礼包
		private var _hasGetImg0:ImageLoader = new ImageLoader;
		private var _hasGetImg1:ImageLoader = new ImageLoader;
		private var _hasGetImg2:ImageLoader = new ImageLoader;
		
		// 背包物品框单元
		private var _bagitem0:CJBagItem;
		private var _bagitem1:CJBagItem;
		private var _bagitem2:CJBagItem;
		private var _bagitem3:CJBagItem;
		private var _bagitem4:CJBagItem;
		
		/** 最大礼包数量 **/
		private const _max_gift_const_:uint = 3;
		
		
		public function CJPileRechargeItem()
		{
			super("CJPileRechargeItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = CONST_WIDTH;
			height = CONST_HEIGHT;
			
			_text.x = 0;
			_text.y = 5;
			_text.width = 120;
			_text.height = 80;
//			_text.textRendererProperties.multiline = true;
//			_text.textRendererProperties.wordWrap = true; 
			_text.wrap = true;
			addChild(_text);
			
			
			var bagitem:CJBagItem;
			for (var i:int=0; i<_max_gift_const_; ++i)
			{
				bagitem = new CJBagItem();
				bagitem.x = 130 + i*(bagitem.width-5);
				bagitem.y = 2;
				bagitem.scaleX = 0.8;
				bagitem.scaleY = 0.8;
				addChild(bagitem);
				bagitem.visible = false;
				this["_bagitem"+i] = bagitem;
				
			}
			var _hasGetImg:ImageLoader;
			for (i=0; i<_max_gift_const_; ++i)
			{
				_hasGetImg = this["_hasGetImg"+i] as ImageLoader;
				_hasGetImg.source = SApplication.assets.getTexture("chongzhi_yilingqu");
				_hasGetImg.rotation = Math.PI/8;
				_hasGetImg.visible = false;
				_hasGetImg.touchable = false;
				addChild(_hasGetImg);
				bagitem = this["_bagitem"+i] as CJBagItem;
				_hasGetImg.x = bagitem.x + bagitem.width/4;
				_hasGetImg.y = bagitem.y - 5;
			}
			

			
			addEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		
		override public function dispose():void
		{
			if(isDispose)
				return;
			
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
			super.dispose();
		}
		
		/** 检测移动范围 **/
		private var _checkPosY:int = 0;
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null)
				return;
			if (touch.phase == TouchPhase.BEGAN)
				_checkPosY = touch.globalY;
			if (touch.phase != TouchPhase.ENDED)
				return;
			if (Math.abs(_checkPosY-touch.globalY) > 5)
				return;
			
			var target:* = touch.target;
			if (target==null)
				return;
			
			var bagitem:CJBagItem;
			for (;;)
			{
				if (target is CJBagItem)
				{
					bagitem = target as CJBagItem;
					break;
				}
				
				target = target.parent;
				if (null == target) return;
			}
			
			var tooltipLayer:CJItemTooltip = new CJItemTooltip();
			tooltipLayer.setItemTemplateIdAndRefresh(bagitem.templateId);
			CJLayerManager.o.addToModalLayerFadein(tooltipLayer);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(data == null)
			{
				return;
			}
			const isAllInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isAllInvalid)
			{
				// 1白2绿3蓝4紫5橙6红
				var color:String = ARR_COLOR[int(data.itemquality)];
				if (null == color)
					color = ARR_COLOR[0];
				
				if (data.desc)
				{
					_text.text = data.desc;
				}
				
				var bagitem:CJBagItem;
				var _hasGetImg:ImageLoader;
				for (var i:int=0; i<_max_gift_const_; ++i)
				{
					bagitem = this["_bagitem"+i] as CJBagItem;
					if (null == data.gifts[i])
						bagitem.visible = false;//false;
					else
					{
						bagitem.visible = true;
						bagitem.setBagGoodsItemByTmplId(data.gifts[i].itemtid);
					}
					
					_hasGetImg = this["_hasGetImg"+i] as ImageLoader;
					if (bagitem.visible)
						_hasGetImg.visible = (data.isGet == 1)?true:false;
					else
						_hasGetImg.visible = false;
				}
				
				
			}
		}
		
		override protected function onSelected():void
		{
		}
		
		
		
		
	}
}