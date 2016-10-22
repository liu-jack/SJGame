package SJ.Game.equipment
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * 装备位显示层
	 @author	zhengzheng
	 * 
	 */
	
	public class CJRecastEquipLayer extends SLayer
	{
		public static const EventRecastPosClicked:String = "EventRecastPosClicked";
		//装备位选中
		private var _imgSelected:ImageLoader;
		/** 图标按钮组 */
		private var _btnVec:Vector.<Button>;
		//选中图相对于装备位图标偏移量-X
		private const IMGSEL_SPACE_X:int = -1;
		//选中图相对于装备位图标偏移量-Y
		private const IMGSEL_SPACE_Y:int = -1;
		/** 当前选中装备位类型 */
		private var _curPosType:int;
		
		public function CJRecastEquipLayer()
		{
			super();
		}

		protected override function initialize():void
		{
			super.initialize();
			_initData();
			
			// 装备位按钮
			_filter = new ColorMatrixFilter();
			_filter.adjustSaturation(-1);
			
			// 装备位按钮
			this.btnWeapon.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_WUQI));
			this.btnWeapon.name = String(ConstItem.SCONST_ITEM_POSITION_WEAPON);
			this.btnWeapon.filter = _filter;
			
			this.btnHead.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_TOUKUI));
			this.btnHead.name = String(ConstItem.SCONST_ITEM_POSITION_HEAD);
			this.btnHead.filter = _filter;
			
			this.btnCloak.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_PIFENG));
			this.btnCloak.name = String(ConstItem.SCONST_ITEM_POSITION_CLOAK);
			this.btnCloak.filter = _filter;
			
			this.btnArmor.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_KUIJIA));
			this.btnArmor.name = String(ConstItem.SCONST_ITEM_POSITION_ARMOR);
			this.btnArmor.filter = _filter;
			
			this.btnShoe.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_XIEZI));
			this.btnShoe.name = String(ConstItem.SCONST_ITEM_POSITION_SHOE);
			this.btnShoe.filter = _filter;
			
			this.btnBelt.defaultSkin = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_YAODAI));
			this.btnBelt.name = String(ConstItem.SCONST_ITEM_POSITION_BELT);
			this.btnBelt.filter = _filter;
			
			_imgSelected = new ImageLoader();
			_imgSelected.source = SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_KUANG);
			_imgSelected.x = btnWeapon.x + IMGSEL_SPACE_X; 
			_imgSelected.y = btnWeapon.y + IMGSEL_SPACE_Y; 
			_imgSelected.width = this.btnWeapon.width;
			_imgSelected.height = this.btnWeapon.height;
			this.addChild(_imgSelected);
			onSelEquip(ConstItem.SCONST_ITEM_POSITION_WEAPON);
		}
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 装备位按钮组
			this._btnVec = new Vector.<Button>();
			this._btnVec.push(this.btnWeapon, 
				this.btnHead, 
				this.btnCloak, 
				this.btnArmor, 
				this.btnShoe, 
				this.btnBelt);
			this._addBtnVecListener();
			
			// 文字 - 对应部位
			var fontFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x89EE4F,null,null,null,null,null,TextFormatAlign.CENTER);
			this.labPosition0.text = this._getLang("EQUIP_POSITION_WUQI");
			this.labPosition0.textRendererProperties.textFormat = fontFormat;
			
			this.labPosition1.text = this._getLang("EQUIP_POSITION_TOUKUI");
			this.labPosition1.textRendererProperties.textFormat = fontFormat;
			
			this.labPosition2.text = this._getLang("EQUIP_POSITION_PIFENG");
			this.labPosition2.textRendererProperties.textFormat = fontFormat;
			
			this.labPosition3.text = this._getLang("EQUIP_POSITION_KAIJIA");
			this.labPosition3.textRendererProperties.textFormat = fontFormat;
			
			this.labPosition4.text = this._getLang("EQUIP_POSITION_XIEZI");
			this.labPosition4.textRendererProperties.textFormat = fontFormat;
			
			this.labPosition5.text = this._getLang("EQUIP_POSITION_YAODAI");
			this.labPosition5.textRendererProperties.textFormat = fontFormat;
			
			
		}
		/**
		 * 按钮组加监听事件
		 * 
		 */		
		private function _addBtnVecListener():void
		{
			for each (var btnTemp:Button in _btnVec)
			{
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickEquip);
			}
		}
		
		/**
		 * 点击图标事件处理
		 * @param event
		 * 
		 */		
		private function _onClickEquip(event:Event):void
		{
			var posType:int = 0;
			switch(event.target)
			{
				case this.btnWeapon:
					// 武器
					posType = ConstItem.SCONST_ITEM_POSITION_WEAPON;
					break;
				case this.btnHead:
					// 头盔
					posType = ConstItem.SCONST_ITEM_POSITION_HEAD;
					break;
				case this.btnCloak:
					// 披风
					posType = ConstItem.SCONST_ITEM_POSITION_CLOAK;
					break;
				case this.btnArmor:
					// 铠甲
					posType = ConstItem.SCONST_ITEM_POSITION_ARMOR;
					break;
				case this.btnShoe:
					// 鞋子
					posType = ConstItem.SCONST_ITEM_POSITION_SHOE;
					break;
				case this.btnBelt:
					// 腰带
					posType = ConstItem.SCONST_ITEM_POSITION_BELT;
					break;
			}
			
			this.onSelEquip(posType);
		}
		
		/**
		 * 设置当前选中装备位后，调用此方法刷新界面显示
		 * @return 
		 * 
		 */		
		public function onSelEquip(curPosType:int):void
		{
			this._curPosType = curPosType;
			for each (var btnTemp:Button in this._btnVec)
			{
				if (btnTemp.name == String(curPosType))
				{
					btnTemp.isSelected = true;
					this._imgSelected.x = btnTemp.x + IMGSEL_SPACE_X;
					this._imgSelected.y = btnTemp.y + IMGSEL_SPACE_Y;
					btnTemp.filter = null;
				}
				else
				{
					btnTemp.isSelected = false;
					btnTemp.filter = _filter;
				}
			}
			CJEventDispatcher.o.dispatchEventWith(EventRecastPosClicked, false, {"curPosType":_curPosType});
		}
		
		/**
		 * 获取语言表对应语言
		 * @param langKey
		 * @return 
		 * 
		 */		
		private function _getLang(langKey:String) : String
		{
			return CJLang(langKey);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_filter.dispose();
		}
		
		
		
		private var _btnBelt:Button;
		/** 图标腰带 **/
		public function get btnBelt():Button
		{
			return _btnBelt;
		}
		/** @private **/
		public function set btnBelt(value:Button):void
		{
			_btnBelt = value;
		}
		private var _btnCloak:Button;
		/** 图标披风 **/
		public function get btnCloak():Button
		{
			return _btnCloak;
		}
		/** @private **/
		public function set btnCloak(value:Button):void
		{
			_btnCloak = value;
		}
		private var _btnHead:Button;
		/** 图标头盔 **/
		public function get btnHead():Button
		{
			return _btnHead;
		}
		/** @private **/
		public function set btnHead(value:Button):void
		{
			_btnHead = value;
		}
		private var _btnWeapon:Button;
		/** 图标武器 **/
		public function get btnWeapon():Button
		{
			return _btnWeapon;
		}
		/** @private **/
		public function set btnWeapon(value:Button):void
		{
			_btnWeapon = value;
		}
		private var _btnShoe:Button;
		/** 图标鞋子 **/
		public function get btnShoe():Button
		{
			return _btnShoe;
		}
		/** @private **/
		public function set btnShoe(value:Button):void
		{
			_btnShoe = value;
		}
		private var _labPosition5:Label;
		/** 文字 - 腰带 **/
		public function get labPosition5():Label
		{
			return _labPosition5;
		}
		/** @private **/
		public function set labPosition5(value:Label):void
		{
			_labPosition5 = value;
		}
		private var _labPosition0:Label;
		/** 文字 - 武器 **/
		public function get labPosition0():Label
		{
			return _labPosition0;
		}
		/** @private **/
		public function set labPosition0(value:Label):void
		{
			_labPosition0 = value;
		}
		private var _labPosition1:Label;
		/** 文字 - 头盔 **/
		public function get labPosition1():Label
		{
			return _labPosition1;
		}
		/** @private **/
		public function set labPosition1(value:Label):void
		{
			_labPosition1 = value;
		}
		private var _labPosition2:Label;
		/** 文字 - 披风 **/
		public function get labPosition2():Label
		{
			return _labPosition2;
		}
		/** @private **/
		public function set labPosition2(value:Label):void
		{
			_labPosition2 = value;
		}
		private var _labPosition3:Label;
		/** 文字 - 护甲 **/
		public function get labPosition3():Label
		{
			return _labPosition3;
		}
		/** @private **/
		public function set labPosition3(value:Label):void
		{
			_labPosition3 = value;
		}
		private var _labPosition4:Label;
		/** 文字 - 鞋子 **/
		public function get labPosition4():Label
		{
			return _labPosition4;
		}
		/** @private **/
		public function set labPosition4(value:Label):void
		{
			_labPosition4 = value;
		}
		private var _btnArmor:Button;
		
		private var _filter:ColorMatrixFilter;
		/** 图标护甲 **/
		public function get btnArmor():Button
		{
			return _btnArmor;
		}
		/** @private **/
		public function set btnArmor(value:Button):void
		{
			_btnArmor = value;
		}
	}
}