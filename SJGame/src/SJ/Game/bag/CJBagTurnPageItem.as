package SJ.Game.bag
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfBagProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_bag_property_setting;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * 背包翻页单页显示
	 * @author sangxu
	 * 
	 */	
	public class CJBagTurnPageItem extends CJItemTurnPageBase
	{
		/** 控件宽度 **/
		private const CONST_WIDTH:int = 66;
		/** 控件高度 **/
		private const CONST_HEIGHT:int = 70;

		/** 数据 - 背包 */
		private var _dataBag:CJDataOfBag;
		/** 道具容器配置数据 - 背包 */
		private var _bagSetting:Json_bag_property_setting;
		
		/** 当前已经解锁的物品框数 */
		private var _currentUnlockedFrameNum:uint = 0;
		/** 背包容量上限 */
		private var _bagMaxCount:uint = 10;
		/** 单页行数 */
		private var _bagRowNum:uint = 5;
		/** 单页列数 */
		private var _bagColNum:uint = 4;
		/** 单页格子数量 */
		private var _onePageNum:uint = _bagRowNum * _bagColNum;
		/** 道具框间隔 */
		private var _itemSpaceX:uint = ConstBag.TwoGoodsFrameDistanceH;
		private var _itemSpaceY:uint = ConstBag.TwoGoodsFrameDistanceV;
		
		/** 背包单页显示的物品框 */
		private var _bagFrameItems:Array = new Array();
		
		/** 当前背包类型 */
		private var _curBagType:uint = 0;
		/** 当前页数, 从0开始 */
		private var _currentPage:int = 1;
		/** 物品框总页数 */
		private var _pageNum:uint;
		/** 扩充背包时点击的格子索引 */
		private var _expandIndex:int;
		/** 扩充背包提示框 */
		private var _expandLayer:CJBagExpandLayer
		
		public function CJBagTurnPageItem()
		{
			super("CJBagTurnPageItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._initData();
			this._initControls();
			this._addEventListener();
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			this._dataBag = CJDataManager.o.DataOfBag;
			this._bagSetting = CJDataOfBagProperty.o.getBagType(ConstBag.CONTAINER_TYPE_BAG);
			
			// 已解锁背包格数
			this._currentUnlockedFrameNum = this._dataBag.bagCount;
			
			// 背包容量上限
			this._bagMaxCount = int(this._bagSetting.maxcount);
			// 单页行数
			this._bagRowNum = int(this._bagSetting.rownum);
			// 单页列数
			this._bagColNum = int(this._bagSetting.colnum);
			this._itemSpaceX = int(this._bagSetting.rowdist);
			this._itemSpaceY = int(this._bagSetting.coldist);
			// 单页格子数量
			this._onePageNum = _bagRowNum * _bagColNum;
			
			//物品框总页数
			this._pageNum = this._bagMaxCount % this._onePageNum > 0 ? 
				(this._bagMaxCount / this._onePageNum + 1) :
				this._bagMaxCount / this._onePageNum;
		}
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			width = 312;
			_initFrameItems();
		}
		
		/**
		 * 添加事件监听
		 * 
		 */
		private function _addEventListener():void
		{
			// 监听背包数据获取成功
			this._dataBag.addEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveBagData);
			
		}
		
		
		
		/**
		 * 获取远程背包数据完成
		 */
		private function _onReceiveBagData(e:Event):void
		{
			_drawBagGoodsItems();
		}
		
		/**
		 * 初始化背包物品栏控件
		 */
		private function _initFrameItems():Boolean
		{
			/** 物品框*/
			var imgTubiaoKuang:CJBagItem;
			
			/** 单页行数 */
			_bagRowNum = int(CJDataOfBagProperty.o.getBagType(ConstBag.CONTAINER_TYPE_BAG).rownum);
			/** 单页列数 */
			_bagColNum = int(CJDataOfBagProperty.o.getBagType(ConstBag.CONTAINER_TYPE_BAG).colnum);
			/** 单页格子数量 */
			_onePageNum = _bagRowNum * _bagColNum;
			
			var bagFrameItems:Array = new Array();
			
			//循环行数
			for(var j:uint = 0; j < _bagRowNum; j++)
			{
				//循环列数
				for (var k:uint = 0; k < this._bagColNum; k++)
				{
					imgTubiaoKuang = new CJBagItem(ConstBag.FrameCreateStateLocked);
					imgTubiaoKuang.x += this._itemSpaceX * k + ConstBag.BAG_ITEM_INITX;
					imgTubiaoKuang.y += this._itemSpaceY * j + ConstBag.BAG_ITEM_INITY;
					imgTubiaoKuang.width = ConstBag.BAG_ITEM_WIDTH;
					imgTubiaoKuang.height = ConstBag.BAG_ITEM_HEIGHT;
					imgTubiaoKuang.index = j * _bagColNum + k;
					bagFrameItems.push(imgTubiaoKuang);
					this.addChild(imgTubiaoKuang);
				}
			}
			//重新创建物品框数组
			this._bagFrameItems = bagFrameItems;
			return true;
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid) // 判断是否应该刷新
			{
				_currentPage = int(data["page"]);	//从0开始
				_curBagType = int(data["bagtype"]);
				
				_drawBagGoodsItems();
			}
		}
		
		/**
		 * 绘制背包内容
		 * @return 是否画完
		 */
		private function _drawBagGoodsItems():void
		{
			// 当前应显示页格子数量
			var curPageMaxCount:uint = 0;
			if (this._currentPage == _pageNum)
			{
				curPageMaxCount = this._bagMaxCount - (this._currentPage - 1) * this._onePageNum;
			}
			else
			{
				curPageMaxCount = this._onePageNum;
			}
			
			// 当前页已解锁格子数量
			var curPageUnlockCount:int = this._currentUnlockedFrameNum - (this._currentPage - 1) * this._onePageNum;
			if (curPageUnlockCount > this._onePageNum)
			{
				curPageUnlockCount = this._onePageNum;
			}
			// 绘制前格子数量
			var countBefore:uint = this._bagFrameItems.length;
			
			// 绘制背包格数量
			if (countBefore != curPageMaxCount)
			{
				// 显示格子数量需要修改
				if (countBefore > curPageMaxCount)
				{
					// 背包格数量需要减少
					for (var index:uint = countBefore; index > curPageMaxCount; index--)
					{
						var cjBagItem:CJBagItem = this._bagFrameItems[index - 1];
						cjBagItem.removeFromParent(true);
//						cjBagItem.visible = false;
						this._bagFrameItems[index - 1] = null;
						this._bagFrameItems.length--;
					}
				}
				else
				{
					// 背包格数量需要增加
					var k:uint = 0;
					var j:uint = 0;
					var imgTubiaoKuang:CJBagItem;
					for (var idx:uint=countBefore; idx < curPageMaxCount; idx++)
					{
						j = idx / this._bagColNum;
						k = idx % this._bagColNum;
						imgTubiaoKuang = new CJBagItem(ConstBag.FrameCreateStateLocked);
						imgTubiaoKuang.x += ConstBag.TwoGoodsFrameDistanceH * k;
						imgTubiaoKuang.y += ConstBag.TwoGoodsFrameDistanceV * j;
						this._bagFrameItems.push(imgTubiaoKuang);
						this.addChild(imgTubiaoKuang);
					}
				}
			}
			
			// 绘制背包格锁状态与道具
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			var bagItemDatas : Array = _getItemsByContainerType(_curBagType);
			var itemData:CJDataOfItem;
			var itemTemplate:Json_item_setting;
			// 本页背包格数起始位置
			var indexBegin:uint = _onePageNum * (_currentPage - 1);
			var bagItem:CJBagItem;
			for (var i:uint=0; i < _bagFrameItems.length; i++)
			{
				bagItem = this._bagFrameItems[i];
				//				if (bagItem == null)
				//				{
				//					continue;
				//				}
				// 绘制锁状态
				if (i < curPageUnlockCount)
				{
					bagItem.status = ConstBag.FrameCreateStateUnlock;
				}
				else
				{
					bagItem.status = ConstBag.FrameCreateStateLocked;
				}
				bagItem.updateFrame();
				
				// 绘制道具
				if ((i + indexBegin) < bagItemDatas.length)
				{
					// 有道具
					itemData = bagItemDatas[i + indexBegin];
					itemTemplate = templateSetting.getTemplate(itemData.templateid)
					bagItem.setBagGoodsItem(itemTemplate.picture);
					bagItem.setQuality(int(itemTemplate.quality));
					if (parseInt(itemTemplate.maxcount) > 1)
					{
						// 可叠加道具，显示数量
						bagItem.setBagGoodsCount(String(itemData.count));
					}
					else
					{
						// 不可叠加道具，不显示数量
						bagItem.setBagGoodsCount("");
					}
					bagItem.itemId = itemData.itemid;
				}
				else
				{
					bagItem.setBagGoodsItem("");
					bagItem.clearItemId();
				}
				bagItem.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItem);
			}
		}
		/**
		 * 根据容器类型获取对应类型的道具
		 */
		private function _getItemsByContainerType(type : int) : Array
		{
			return this._dataBag.getItemsByContainerType(type);
		}
		/**
		 * 显示toolTip
		 * @param event
		 * 
		 */
		private function _onClickItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (!touch)
			{
				return;
			}
			if ((this.owner as CJTurnPage).isScrolling)
			{
				return;
			}
			var item:CJBagItem = event.currentTarget as CJBagItem;
			if (item.status == ConstBag.FrameCreateStateUnlock)
			{
				// 已解锁
				if ((item.itemId.length <= 0) || (parseInt(item.itemId) <= 0))
				{
					// 空格不做操作
					return;
				}
				// 弹出tooltip框
				this._showTooltip(item.itemId)
				
			}
			else if (item.status == ConstBag.FrameCreateStateLocked)
			{
				// 未解锁, 弹出解锁框
				this._showExpandLayer(item.index);
			}
		}
		
		/**
		 * 显示道具tooltip
		 * @param itemId 道具id
		 * 
		 */
		private function _showTooltip(itemId:String):void
		{
			CJItemUtil.showItemInBagTooltips(itemId);
		}
		
		/**
		 * 显示扩包界面
		 * @param event
		 * 
		 */		
		private function _showExpandLayer(index:int):void
		{
			var expandIndex:int = this._getExpadIndex(index);
			var expandCount:int = this._getExpandCount();
			
			this._expandIndex = expandIndex;
			
			var expandXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlBagExpand) as XML;
			_expandLayer = SFeatherControlUtils.o.genLayoutFromXML(expandXml, CJBagExpandLayer) as CJBagExpandLayer;
			
			// 监听
			_expandLayer.addEventListener(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE, _onCompleteExpand);
			
			CJLayerManager.o.addModuleLayer(_expandLayer);
			
			_expandLayer.drawInfoWithData(expandIndex, expandCount);
		}
		
		/**
		 * 响应扩包成功
		 * @param event
		 * 
		 */		
		private function _onCompleteExpand(event:Event):void
		{
			_expandLayer.addEventListener(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE, _onCompleteExpand);
			_expandLayer = null;
			// 已开格数量
			this._currentUnlockedFrameNum = this._dataBag.bagCount;
			var curPageOpenCount:uint = this._dataBag.bagCount - ((this._currentPage - 1) * this._bagRowNum * this._bagColNum);
			var bagItem:CJBagItem;
			for (var i:int = 0; i < this._bagFrameItems.length; i++)
			{
				bagItem = this._bagFrameItems[i];
				if (ConstBag.FrameCreateStateLocked == bagItem.status)
				{
					if (curPageOpenCount >= (i + 1))
					{
						bagItem.status = ConstBag.FrameCreateStateUnlock;
						bagItem.updateFrame();
					}
					else
					{
						break;
					}
				}
			}
		}
		
		/**
		 * 点击未解锁背包格，获取当前未解锁背包格索引数
		 * @param index 当前背包格在当前页索引
		 * @return 
		 * 
		 */		
		private function _getExpadIndex(index:int):int
		{
			var openCount:int = this._dataBag.bagCount;
			var expandIndex:int = 0;
			if (this._currentPage <= 1)
			{
				expandIndex = index + 1 - openCount;
			}
			else
			{
				expandIndex = this._bagRowNum * this._bagColNum * (this._currentPage - 1) + index + 1 - openCount
			}
			return expandIndex;
		}
		
		/**
		 * 获取已经过解锁的背包格数量
		 * @return 
		 * 
		 */		
		private function _getExpandCount():int
		{
			// 已开格数量
			var openCount:int = this._dataBag.bagCount;
			// 容器初始数量
			var initCount:int = this._bagSetting.initcount;
			return openCount - initCount;
		}
		
		/**
		 * 点击事件
		 * @param selectedIndex
		 * @param item
		 * 
		 */		
		override protected function onSelected():void
		{
			
			
		}
		
		/**
		 * 取消选中
		 * 
		 */		
		public function unSelected():void
		{
			
		}
	}
}