package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJBattleEffectUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.enhanceequip.CJEnhanceLayer;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 更换装备弹出框
	 * @author longtao
	 * 
	 */
	public class CJHeroEquipTipLayer extends SLayer
	{
		public static const ConstHeroEquipTipWidth:int = 205;
		public static const ConstHeroEquipTipHeight:int = 205;
		
		public static const ConstBtnWidth:int = 50;
		public static const ConstBtnHeight:int = 20;
		public static const ConstBtnOffsetY:int = 60;
		
		// 每页道具数量
		private static const ConstPerPageItemCount:int = 3;
		// 间隙
		private static const CONST_ITEM_GAP:int = 0;
		
		// 背景
		private var _bg:Scale9Image;
		// 装备滚动
		private var _panel:CJTurnPage;
		
		// 关闭按钮
		private var _btnClose:Button;
		// 关闭按钮
		private var _btnShowClose:Button;
		
		// 
		// 武将id
		private var _heroid:String;
		// 装备位置
		private var _positiontype:String;
		
		private var _listData:Array = new Array();
		
		// 弹出框
		private var _tips:CJHeroUIEquipTip;
		
		public function CJHeroEquipTipLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_initView();
		}
		
		private function addAllEL():void
		{
			// 监听
			addEventListener(TouchEvent.TOUCH, _touchHandler);
			_btnClose.addEventListener(Event.TRIGGERED, _touchBtnClose);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_HERO_UI_CLOSE_EQUIP_TIP_LAYER, _close);
		}
		
		private function removeAllEL():void
		{
			// 监听
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
			_btnClose.removeEventListener(Event.TRIGGERED, _touchBtnClose);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_HERO_UI_CLOSE_EQUIP_TIP_LAYER, _close);
		}
		
		/// 初始化可视
		private function _initView():void
		{
			visible = true;
			// 设置宽高
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			
			if (null == _bg)
				_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi"), new Rectangle(19,19,1,1)));
			_bg.x = 243;
			_bg.y = 68;
			_bg.width = ConstHeroEquipTipWidth;
			_bg.height = ConstHeroEquipTipHeight;
			addChild(_bg);
			
			if (null == _panel)
				_panel = new CJTurnPage(ConstPerPageItemCount);
			_panel.x = _bg.x;
			_panel.y = _bg.y+5;
			_panel.setRect(ConstHeroEquipTipWidth , ConstHeroEquipTipHeight-10);
			_panel.type = CJTurnPage.SCROLL_V;
			addChild(_panel);
			
			if (null == _tips)
				_tips = new CJHeroUIEquipTip;
			_tips.x = 60;
			_tips.y = 69;
			addChild(_tips);
			
			if (null==_btnClose)
				_btnClose = new Button();
			_btnClose.x = 0;
			_btnClose.y = 0;
			_btnClose.width = ConstMainUI.MAPUNIT_WIDTH;
			_btnClose.height = ConstMainUI.MAPUNIT_HEIGHT;
			addChildAt(_btnClose, 0);
			
			// 关闭按钮
			if (null==_btnShowClose)
			{
				_btnShowClose = new Button();
			}
			_btnShowClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnShowClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			// 为关闭按钮添加监听
			_btnShowClose.addEventListener(starling.events.Event.TRIGGERED, this._touchBtnClose);
			_btnShowClose.x = _bg.x + _bg.width - 23;
			_btnShowClose.y = _bg.y - 18;
			_btnShowClose.width = 46;
			_btnShowClose.height = 45;
			addChild(_btnShowClose);

			addAllEL();
		}
		
		private function _touchBtnClose(e:Event):void
		{
			_close();
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
			
			var item:* = touch.target.parent;
			while( parent!=null )
			{
				if (item is CJHeroEquipItem)
					break;
				item = item.parent;
				if (item == null)
					return;
			}
			
			var arr:Array = _panel.dataProvider.data as Array;
			for(var i:int = 0 ; i < arr.length ; i++)
			{
				arr[i].isSelected = false;
				_panel.updateItemAt(i);
			}
			item.data.isSelected = true;
			_panel.updateItemAt(item.index);
			_refreshTips(item.data.itemid);
		}
		
		private function _close():void
		{
			removeFromParent(true);
			
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			removeAllEL();
			super.dispose();
		}
		
		
		// 更新界面
		private function _updateLayer():void
		{
			var _heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			if(_heroList.dataIsEmpty)
				return;
			if ( SStringUtils.isEmpty(_heroid) || SStringUtils.isEmpty(_positiontype) )
				return;
			
			var heroInfo:CJDataOfHero = _heroList.getHero(_heroid);
			Assert( heroInfo!=null, "CJHeroEquipTipLayer._updateLayer() heroInfo==null" );
			
			_listData = _getDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(_listData);
			_panel.dataProvider = groceryList;
			if (_listData.length == 0)
				return;
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = CONST_ITEM_GAP;
			_panel.layout = listLayout;
			_panel.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJHeroEquipItem = new CJHeroEquipItem();
				render.owner = _panel;
				return render;
			};
			
			_refreshTips(_listData[0].itemid);
			
			
		}
		
		
		private function _getDataArr():Array
		{
			var listData:Array = new Array();
			
			// 背包中的所有装备
			var bagItemsArr:Array = CJDataManager.o.DataOfBag.getItemsByContainerType( ConstBag.BAG_TYPE_EQUIP );
			// 武将信息
			var heroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(_heroid);
			if(heroInfo==null)return [];
			
			// 物品模板
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			var data:Object;
			for (var i:int=0; i<bagItemsArr.length; ++i)
			{
				var itemInfo:CJDataOfItem = bagItemsArr[i];
				// 判断该物品是否可放入候选栏中
				var itemTemplate:Json_item_setting = templateSetting.getTemplate(itemInfo.templateid);
				if(itemTemplate == null)continue;
				
				// 必须对应相应的装备位置
				if ( (int(itemTemplate.positiontype)&int(_positiontype)) == int(_positiontype))
				{
					data = {
						heroid:_heroid,
						itemTemplateid:itemInfo.templateid,
						itemid:itemInfo.itemid,
						isPutonOperate:true, // true为玩家进行装备操作
						fightValue:CJBattleEffectUtil.getEquipValue(itemInfo), // 战斗值
						isSelected:false, // 是否选中
						weight:CJBattleEffectUtil.getEquipValue(itemInfo) // 权重值
					};
					// 等级
					if ( int(itemTemplate.level) > int(heroInfo.level) )
					{
						data.disable = CJLang("HERO_UI_DISABLE_LEVEL");
						data.weight = -1;
					}
					// 职业
					if ((int(itemTemplate.needoccupation)&int(heroInfo.heroProperty.job)) != int(heroInfo.heroProperty.job))
					{
						data.disable = CJLang("HERO_UI_DISABLE_JOB");
						data.weight = -2;
					}
					
					listData.push(data);
				}
			}
			
			// 通过战斗力排序
			listData.sortOn("weight", Array.NUMERIC|Array.DESCENDING);
			
			// 已装备的默认排在首位
			var heroEquipObj:Object = CJDataManager.o.DataOfHeroEquip.heroEquipObj[_heroid];
			if (heroEquipObj != null)
			{
				// 装备中的id
				var itemid:String = heroEquipObj[int(_positiontype)];
				// 装备格上的装备
				var equipItem:CJDataOfItem = CJDataManager.o.DataOfEquipmentbar.getEquipbarItem(itemid);
				if (equipItem != null)
				{
					data = {
						heroid:_heroid,
						itemTemplateid:equipItem.templateid,
						itemid:equipItem.itemid,
						isPutonOperate:false, // true为玩家进行装备操作
						fightValue:CJBattleEffectUtil.getEquipValue(equipItem), // 战斗值
						isSelected:true // 是否选中
					}
					listData.unshift(data);
				}
			}
			
			// 首位默认选中
			if (listData.length != 0)
				listData[0].isSelected = true;
			
			return listData;
		}
		
		/**
		 * 更新tips
		 * @param tItemid
		 */
		private function _refreshTips( tItemid:String ):void
		{
			if (_tips)
			{
				_tips.updateShow(_heroid, tItemid);
			}
		}
		
		/**
		 * 设置信息
		 * @param heroid		武将id
		 * @param positiontype	装备位置(1248)
		 * @return 是否有数据显示 true为有显示,false为没有显示
		 */
		public function setData(heroid:String, positiontype:String):Boolean
		{
			_initView();
			_heroid = heroid;
			_positiontype = positiontype;
			_updateLayer();
			
			Starling.juggler.delayCall(function():void
			{
				//点击装备位，弹出装备列表菜单
				if(CJDataManager.o.DataOfFuncList.isIndicating)
				{
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
				}
			},0.3);
			
			return _listData.length == 0 ? false : true;
		}
	}
}