package engine_starling.display
{
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.events.FeathersEventType;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	
	/**
	 *  
	 * @author yongjun
	 * 
	 */
	public class SJScrollPage extends ScrollContainer
	{
		private var _type:String;
		private var _currentPage:int = -1;
		//垂直滚动
		public static const SCROLL_V:String = "V";
		//水平滚动
		public static const SCROLL_H:String = "H";
		
		public function SJScrollPage()
		{
			super();
			init();
		}
		private function init():void
		{
//			this.scrollerProperties.snapToPages = true;
			this.addEventListener(FeathersEventType.SCROLL_COMPLETE , this.updatePage);
		}
		/**
		 *  设置翻页类型
		 * @param t
		 * 
		 */
		public function set type(t:String):void
		{
			this._type = t;
//			switch(t)
//			{
//				case SCROLL_V:
//					this.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
//					this.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
//					break;
//				case SCROLL_H:
//					this.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
//					this.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
//					break;
//				default:
//					Assert(false,"滚动类型错误！");
//					break;
//			}
		}
		/**
		 * 设置可见区域 
		 * @param w
		 * @param h
		 * 
		 */
		public function setRect(w:Number,h:Number):void
		{
			this.width = w;
			this.height = h;
		}
		/**
		 * 翻到第几页 
		 * @param num
		 * 
		 */
		public function goto(num:int):void
		{
			if(this._currentPage == num)return;
			this._currentPage = num;
			switch(this._type)
			{
				case SCROLL_V:
					this.scrollToPageIndex(-1,this._currentPage , 1);
					break;
				case SCROLL_H:
					this.scrollToPageIndex(this._currentPage,-1 , 1);
					break;
			}
		}
		
		public function next():void
		{
			switch(this._type)
			{
				case SCROLL_V:
					this.scrollToPageIndex(-1,++this._verticalPageIndex , 1);
					break;
				case SCROLL_H:
					this.scrollToPageIndex(++this._horizontalPageIndex,-1 , 1);
					break;
			}
		}
		
		public function prev():void
		{
			switch(this._type)
			{
				case SCROLL_V:
					this.scrollToPageIndex(-1,--this._verticalPageIndex , 1);
					break;
				case SCROLL_H:
					this.scrollToPageIndex(--this._horizontalPageIndex,-1 , 1);
					break;
			}
		}
		
		public function updatePage(e:Event):void
		{
			this._currentPage = this._type == SCROLL_V ? this.verticalPageIndex : this.horizontalPageIndex
	;
		}

		public function get currentPage():int
		{
			return this._currentPage;
		}
	}
}