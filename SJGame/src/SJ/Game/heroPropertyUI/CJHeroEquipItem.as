package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	/**
	 * 装备道具
	 * @author longtao
	 * 
	 */
	public class CJHeroEquipItem extends SLayer implements IListItemRenderer
	{
		private static const _CONST_WIDTH_:int = 200;
		private static const _CONST_HEIGHT_:int = 65;
		
		private static const _CONST_BUTTON_WIDTH_:int = 60;
		private static const _CONST_BUTTON_HEIGHT_:int = 28;
		
		//item 的数据
		private var _data:Object = null;
		//渲染时候在父容器的索引
		private var _index:int;
		//放置item的容器
		private var _owner:List;
		//装备\卸下 按钮
		private var _btn:Button;
		private var _isSelected:Boolean;
		// 装备图标显示
		private var _bagItem:CJBagItem;
		// 装备名称
		private var _itemName:Label;
		// 战斗力
		private var _itemFight:Label;
		// 底框
		private var _bg:Scale9Image;
		// 
		private var _itemDisable:Label;
		
		public function CJHeroEquipItem()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = _CONST_WIDTH_;
			height = _CONST_HEIGHT_;
			
			
			// 底框 
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi"), new Rectangle(9, 9, 2, 2)));
			addChild(_bg);
			
			// 装备显示格
			_bagItem = new CJBagItem(ConstBag.FrameCreateStateUnlock);
			_bagItem.x = 13;
			_bagItem.y = 9;
			_bagItem.width = ConstBag.BAG_ITEM_WIDTH;
			_bagItem.height = ConstBag.BAG_ITEM_HEIGHT;
			addChild(_bagItem);
			
			// 装备名称
			_itemName = new Label;
			_itemName.x = 70;
			_itemName.y = 19;
			_itemName.width = 70;
			_itemName.height = 15;
			_itemName.textRendererFactory = textRender.htmlTextRender;
			addChild(_itemName);
			
			// 战斗力
			_itemFight = new Label;
			_itemFight.x = 70;
			_itemFight.y = 36;
			_itemFight.width = 70;
			_itemFight.height = 15;
			_itemFight.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			addChild(_itemFight);
			
			
			// 装备活卸下按钮
			_btn = new Button();
			_btn.visible = false;
			_btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btn.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btn.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			_btn.name = "HERO_PUTON_WEAPON";
			addChild(_btn);
			_btn.x = 130;
			_btn.y = 20;
			_btn.width = _CONST_BUTTON_WIDTH_;
			_btn.height = _CONST_BUTTON_HEIGHT_;
			
			_btn.addEventListener(Event.TRIGGERED, _click);
			
			_itemDisable = new Label;
			_itemDisable.visible = false;
			_itemDisable.x = _btn.x;
			_itemDisable.y = _btn.y;
			addChild(_itemDisable);
			_itemDisable.textRendererProperties.textFormat = ConstTextFormat.textformatorange;
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(!isSelectInvalid)
				return;
			
			// 武将id
			var heroid:String = data.heroid;
			// 装备模板id
			var itemTemplateid:String = data.itemTemplateid;
			// 装备id
			var itemid:String = data.itemid;
			// 是否是装备操作,True为装备操作, false为卸下操作, 按钮显示也不同
			var isPutonOperate:Boolean = data.isPutonOperate;
			
			// 更新装备战斗力
			_itemFight.text = CJLang("HERO_EQUIP_FIGHT") + String(data.fightValue);
			// 更新按钮显示文字
			_btn.label = isPutonOperate ? CJLang("HERO_EQUIP_PUTON") : CJLang("HERO_EQUIP_TAKEOFF");
			
			// 装备数据
			var itemInfo:CJDataOfItem = CJDataManager.o.DataOfBag.getItemByItemId(itemid);
			// 装备模板数据
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			var itemTemplate:Json_item_setting = templateSetting.getTemplate(int(itemTemplateid));
			
			if (itemTemplate == null)
				return;
			// 更新装备图标
			_bagItem.setBagGoodsItemByTmpl(itemTemplate, true);
//			_bagItem.setBagGoodsItem(itemTemplate.picture);
//			_bagItem.showQuality();
			// 更新装备名字
			// 颜色 ConstTextFormat.textformatyellow;
			_itemName.textRendererProperties.textFormat = ConstTextFormat.getFormatByQuality(int(itemTemplate.quality));//new TextFormat( "Arial", 10, ConstItem.SCONST_ITEM_QUALITY_COLOR[int(itemTemplate.quality)] );
			_itemName.text = CJLang(itemTemplate.itemname);
			
			// 背景图
			if (data.isSelected)
			{
				// 选中的
				_bg.textures = new Scale9Textures(SApplication.assets.getTexture("dongtai_xuanzhong"), new Rectangle(10,10,4,4));
				_bg.x = 3;
				_bg.y = 3;
				_bg.width = _CONST_WIDTH_ - 6;
				_bg.height = _CONST_HEIGHT_ - 2;
			}
			else
			{
				// 非中的
				_bg.textures = new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi"), new Rectangle(9, 9, 2, 2));
//				_bg.x = 0;
//				_bg.y = 0;
//				_bg.width = width;
//				_bg.height = height;
				_bg.x = 1;
				_bg.y = 3;
				_bg.width = _CONST_WIDTH_ - 6;
				_bg.height = _CONST_HEIGHT_ - 6;
			}
			
			_btn.visible = true;
			_itemDisable.visible = false;
			if ( !SStringUtils.isEmpty(data.disable) )
			{
				_itemDisable.text = data.disable;
				_itemDisable.visible = true;
				_btn.visible = false;
			}
			
			
		}
		
		// 触碰按钮
		private function _click(e:Event):void
		{
			// 武将id
			var heroid:String = data.heroid;
			// 装备模板id
			var itemTemplateid:String = data.itemTemplateid;
			// 装备id
			var itemid:String = data.itemid;
			// 是否是装备操作,True为装备操作,false为卸下操作
			var isPutonOperate:Boolean = data.isPutonOperate;
			
			if (data.isPutonOperate)
				SocketCommand_hero.puton_equip(heroid, itemid);
			else
				SocketCommand_hero.takeoff_equip(heroid, itemid);
			
			// 通知EquipTipLayer已发送信息
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_HERO_UI_CLOSE_EQUIP_TIP_LAYER);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		

		
		public function set data(value:Object):void
		{
			_data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get owner():List
		{
			return _owner;
		}
		
		public function set owner(value:List):void
		{
			_owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function set isSelected(b:Boolean):void
		{
			_isSelected = b;
		}

		public function get isSelected():Boolean
		{
			return _isSelected;
		}
	}
}









