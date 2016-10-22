package SJ.Game.formation
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * @name 翻页面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-10 下午8:25:55  
	 +------------------------------------------------------------------------------
	 */
	public class CJTurnPage extends List
	{
		/*总页数*/
		protected var _totalPage:int = 0;
		/*每页item数*/
		protected var _itemPerPage:uint = 2;
		/*当前页*/
		private var _currentPage:int = 0;
		/*滚动类型*/
		private var _type:String;
		//垂直滚动
		public static const SCROLL_V:String = "CJTurnPage.SCROLL_V";
		//水平滚动
		public static const SCROLL_H:String = "CJTurnPage.SCROLL_H";
		/*翻页动画时间*/
		private var _animationTime:Number = 1;
		/*不翻页*/
		private var _NO_TURN_PAGE:int = -1;
		/*左翻/上翻*/
		private var _preButton:Button;
		/*右翻/下翻*/
		private var _nextButton:Button;
		/*第一次打开翻页，是否已经翻到选中的Item*/
		private var _hasTurnedPageOnFirstOpen:Boolean = false;
		
		/**
		 * @param type ：翻页的方向  CJTurnPage.SCROLL_V  CJTurnPage.SCROLL_H
		 * @param itemPerPage ： 每页多少个Item
		 * @param snapToPages : 是否翻整页 true一次翻一页，false 每次可以翻几个
		 */		
		public function CJTurnPage(itemPerPage:int = 2, type:String = SCROLL_V , snapToPages:Boolean = false)
		{
			super();
			this._itemPerPage = itemPerPage;
			this.type = type;
			this.snapToPages = snapToPages;
			this.addEventListener(FeathersEventType.SCROLL_COMPLETE , this._updatePage);
			this._preButton = new Button();
			this._nextButton = new Button();
			_preButton.addEventListener(Event.TRIGGERED , this.prevPage);
			_nextButton.addEventListener(Event.TRIGGERED , this.nextPage);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.addChild(_preButton);
			this.addChild(_nextButton);
			
			addEventListener(FeathersEventType.SCROLL_START,function(e:*):void
			{
				touchable = false;
			});
			addEventListener(FeathersEventType.SCROLL_COMPLETE,function(e:*):void
			{
				touchable = true;
			});
		}
		
//		protected function startScroll():void
//		{
//			this.touchable = false;
//			super.startScroll();
//		}
//		
//		protected function completeScroll():void
//		{
//			this.touchable = true;
//			super.completeScroll();
//		}
		
		override protected function draw():void
		{
			if(this.selectedIndex != -1 && !_hasTurnedPageOnFirstOpen)
			{
				_hasTurnedPageOnFirstOpen = true;
				this.turnToItem(this.selectedIndex);
			}
			super.draw();
		}
		
		/**
		 * 设置当前页面，设置成功，会自动翻页到当前页
		 */		
		public function set currentPage(value:int):void
		{
			if(_currentPage == value)
				return;
			_currentPage = value;
			if (_currentPage < 0)
			{
				_currentPage = 0;
			}
			else if(_currentPage >= _totalPage - 1)
			{
				_currentPage = _totalPage - 1;
			}
			this._goto();
		}

		private function _updatePage(e:Event):void
		{
			if(e.type == FeathersEventType.SCROLL_COMPLETE && e.target is CJTurnPage)
			{
				//如果是整页翻
				if(this.snapToPages)
				{
					this._updateByPage();
				}
				//如果是按Item翻
				else
				{
					this._updateByItem();
				}
				this._refreshButton();
			}
		}
		
		private function _updateByPage():void
		{
			if(this._type == SCROLL_V)
			{
				this._currentPage = this._verticalPageIndex;
				this._totalPage = this.verticalPageCount;
			}
			else
			{
				this._currentPage = this._horizontalPageIndex;
				this._totalPage = this.horizontalPageCount;
			}
		}
		
		private function _updateByItem():void
		{
			if(this._type == SCROLL_V)
			{
				this._currentPage = Math.ceil(this.verticalScrollPosition / super.height );
			}
			else
			{
				this._currentPage = Math.ceil(this.horizontalScrollPosition / super.width );
			}
		}
		
		/**
		 * 翻到当前页
		 */
		private function _goto():void
		{
			if(this.snapToPages)
			{
				this._gotoPage();
			}
			else
			{
				this._gotoItem();
			}
		}
		
		private function _gotoPage():void
		{
			if(this._type == SCROLL_V)
			{
				this.scrollToPageIndex(_NO_TURN_PAGE , this._currentPage ,  animationTime);
			}
			else
			{
				this.scrollToPageIndex(this._currentPage, _NO_TURN_PAGE , animationTime);
			}
		}
		
		private function _gotoItem():void
		{
			var gotoPos:Number;
			if(this._type == SCROLL_V)
			{
				gotoPos = this._currentPage * super.height;
				if(gotoPos >= maxVerticalScrollPosition)
				{
					gotoPos = maxVerticalScrollPosition;
				}
				this.scrollToPosition(0 , gotoPos ,  animationTime);
			}
			else
			{
				gotoPos = this._currentPage * super.width;
				if(gotoPos >= maxHorizontalScrollPosition)
				{
					gotoPos = maxHorizontalScrollPosition;
				}
				this.scrollToPosition(gotoPos, 0 , animationTime);
			}
		}
		
		/**
		 * 翻到特定的位置
		 * @index:item的索引
		 */ 
		public function turnToItem(index:int):void
		{
			if(index > this.dataProvider.length)
			{
				return;
			}
			var toPage:int = int(index/itemPerPage);
			this.currentPage = toPage;
		}
		
		/**
		 * 翻下一页
		 */		
		public function nextPage():void
		{
			currentPage = currentPage + 1;
		}
		
		/**
		 * 翻上一页
		 */
		public function prevPage():void
		{
			currentPage = currentPage - 1 ;
		}
		
		/**
		 * 刷新按钮的状态
		 */		
		private function _refreshButton():void
		{
			if(this._nextButton)
			{
				if(this._currentPage >= this._totalPage - 1)
				{
					this._nextButton.isEnabled = false;
				}
				else
				{
					this._nextButton.isEnabled = true;
				}
			}
			
			if(this._preButton)
			{
				if(this._currentPage <= 0)
				{
					this._currentPage = 0;
					this._preButton.isEnabled = false;
				}
				else
				{
					this._preButton.isEnabled = true;
				}
			}
		}
		
		/**
		 *  设置翻页类型
		 * @param t : SCROLL_V|SCROLL_H
		 */
		public function set type(t:String):void
		{
			this._type = t;
			switch(t)
			{
				case SCROLL_V:
					this.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
					this.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
					break;
				case SCROLL_H:
					this.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
					this.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
					break;
				default:
					Assert(false,"滚动类型错误！");
					break;
			}
		}
		
		/**
		 * 设置list所有数据
		 */		
		override public function set dataProvider(value:ListCollection):void
		{
			super.dataProvider = value;
			if (dataProvider != null)
			{
				this._currentPage = 0;
				this._totalPage = Math.ceil(dataProvider.length / this._itemPerPage);
				_refreshButton();
			}
		}
		
		/**
		 * 获取所有的子item的数据对象 
		 */		
		public function getAllItemDatas():Array
		{
			var result:Array = new Array();
			if(this.dataProvider != null)
			{
				var len:int = this.dataProvider.length;
				for (var i:int = 0; i < len; i++) 
				{
					result[i] = this.dataProvider.getItemAt(i);
				}
			}
			return result;
		}
		
		/**
		 * 更新某个item的显示 ,一般根据touch事件确定更新的item对象
		 * @param data item的数据
		 * @param index item的位置
		 */		
		public function updateItem(data:Object , index:int):void
		{
			if(this.dataProvider)
			{
				this.dataProvider.setItemAt(data , index);
				this.dataProvider.updateItemAt(index);
			}
		}
		
		/**
		 * 更新某个item的显示
		 * @param index 索引
		 * @note  先更改对象的data再去调用该方法
		 */
		public function updateItemAt(index:int):void
		{
			this.dataProvider.updateItemAt(index);
		}
		
		/**
		 * 设置可见区域 
		 * @param w:可见区域宽
		 * @param h:可见区域高
		 */
		public function setRect(w:Number,h:Number):void
		{
			super.setSize(w , h);
		}
		
		override public function set height(value:Number):void
		{
			Assert(false,"不允许访问!使用setRect设置区域");
		}
		
		override public function set width(value:Number):void
		{
			Assert(false,"不允许访问!使用setRect设置区域");
		}
		
		/**
		 * 翻到某页
		 * @param num : 页面标号
		 */		
		public function gotoPage(num:int):void
		{
			this.currentPage = num;
		}
		
		public function get currentPage():int
		{
			return this._currentPage;
		}

		public function get totalPage():int
		{
			return _totalPage;
		}

		public function get animationTime():Number
		{
			return _animationTime;
		}

		public function set animationTime(value:Number):void
		{
			if(value > 0)
			{
				_animationTime = value;
			}
		}
		
		override public function dispose():void
		{
			itemRendererFactory = null;
			this.removeEventListener(FeathersEventType.SCROLL_COMPLETE , this._updatePage);
			if(_preButton)
			{
				_preButton.removeEventListener(Event.TRIGGERED , this.prevPage);
				this._preButton = null;
			}
			if(_nextButton)
			{
				_nextButton.removeEventListener(Event.TRIGGERED , this.nextPage);
				this._nextButton = null;
			}
			super.dispose();
		}

		public function get preButton():Button
		{
			return _preButton;
		}

		public function get nextButton():Button
		{
			return _nextButton;
		}

		public function get itemPerPage():uint
		{
			return _itemPerPage;
		}
		
		public function set itemPerPage(value:uint):void
		{
			_itemPerPage = value;
		}

		public function get type():String
		{
			return _type;
		}

	}
}