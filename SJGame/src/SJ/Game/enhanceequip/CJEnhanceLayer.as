package SJ.Game.enhanceequip
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.equipment.CJItemMakeLayer;
	import SJ.Game.equipment.CJItemRecastLayer;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.jewelCombine.CJJewelCombineLayer;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class CJEnhanceLayer extends SLayer
	{
		public function CJEnhanceLayer()
		{
			super();
			
		}
		
		public function setPageType(type:int = BTN_TYPE_QIANGHUA):void
		{
			if (type in BTN_TYPES)
			{
				this._pageType = type;
			}
		}
		
		/**
		 * 设置打开武将id
		 * @param heroId
		 * 
		 */		
		public function setOpenHeroId(heroId:String):void
		{
			_openHeroId = heroId;
		}
		
		/** 页面类型 */
		private var _pageType:int = 0;
		/** 进入界面时默认选中的武将id */
		private var _openHeroId:String = "";
		
		/** 按钮类型 */
		public static const BTN_TYPE_QIANGHUA:int = 0;
		public static const BTN_TYPE_ZHUZAO:int = 1;
		public static const BTN_TYPE_SHENGJIE:int = 2;
		public static const BTN_TYPE_XILIAN:int = 2;
		private static const BTN_TYPES:Array = [BTN_TYPE_QIANGHUA, BTN_TYPE_ZHUZAO, BTN_TYPE_SHENGJIE, BTN_TYPE_XILIAN];
		
		/** 铸造弹窗与强化弹窗的Y坐标偏移量 */
		private static const OFFSET_Y:int = 12;
		/** 按钮 */
		private var _btnVec:Vector.<Button> = new Vector.<Button>;
		/** 当前按钮类型 */
		private var _currentBtnType:int = 0;
		
		/** 装备强化层 */
		private var _layerEnhanceEquip:CJEnhanceEquipLayer;
		
		
		/** 装备铸造层 */
		private var _layerItemMake:CJItemMakeLayer;
		private static const Event_LoadZhuzaoComplete:String = "Event_LoadZhuzaoComplete";
		
		/** 宝石合成层 */
		private var _layerJewelCombine:CJJewelCombineLayer;
		private static const Event_LoadJewelCombineComplete:String = "Event_LoadJewelCombineComplete";
		
		private var _layer_recast:CJItemRecastLayer;
		/** 标题 */
		private var _title:CJPanelTitle;
		override protected function initialize():void
		{
			super.initialize();
			
			var texture:Texture;
			// 背景
			texture = SApplication.assets.getTexture("common_quanbingdise");
			var imgBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
			imgBg.width = width;
			imgBg.height = height;
			this.addChildAt(imgBg, 0);
			
			// 边角
			var textureCorner:Texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			var corScaleRange:Rectangle = new Rectangle(13, 14, 1, 1);
			var corTexture:Scale9Textures = new Scale9Textures(textureCorner, corScaleRange);
			this.imgBgcorner = new Scale9Image(corTexture);
			this.imgBgcorner.x = 0;
			this.imgBgcorner.y = 0;
			this.imgBgcorner.width = 480;
			this.imgBgcorner.height = 320;
			this.addChildAt(imgBgcorner, 1);
			
			// 标题背景
			var img:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			img.width = SApplicationConfig.o.stageWidth;
			img.x = 0;
			img.y = 0;
			img.height = 20;
			this.addChild(img);
			// 标题
			this._title = new CJPanelTitle(this._getLang("ENHANCE_TITLE_EQUIP"));
			this.addChild(this._title);
			this._title.x = SApplicationConfig.o.stageWidth - this._title.width >> 1 ;
			_resetTitle();
			
			// 页签按钮
			this._btnVec.push(this.btnQianghua, 
							  this.btnZhuzao, 
//							  this.btnShengjie, 
							  this.btnXilian);
			
			
			this.btnQianghua.label = this._getLang("ENHANCE_BTN_QIANGHUA");
			this.btnQianghua.name = "qianghua";
			this.btnZhuzao.label = this._getLang("ENHANCE_BTN_ZHUZAO");
			this.btnZhuzao.name = "zhuzao";
			this.btnXilian.label = this._getLang("ENHANCE_BTN_XILIAN");
			this.btnXilian.name = "xilian";
			
			var roleLevel:int = int(CJDataManager.o.DataOfHeroList.getMainHero().level);
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.defaultSkin = this._getImgBtnDft();
				btnTemp.defaultSelectedSkin = this._getImgBtnSel();
				btnTemp.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xF1D98E );
				
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
				var btnNeedOpenLevel:int = CJDataOfFuncPropertyList.o.getPropertyByIconName("gongnengzhenghe_" + btnTemp.name).level;
				btnTemp.visible = roleLevel < btnNeedOpenLevel ? false : true;
			}
			
			// 关闭按钮
			this._btnClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			//为关闭按钮添加监听
			this._btnClose.addEventListener(Event.TRIGGERED, _onBtnClickClose);

			
			this.setChildIndex(btnClose, this.numChildren - 1);
			this.setChildIndex(this.operatLayer, this.getChildIndex(btnClose));

			this._onAddOperatLayer(_pageType);
			
			this.addEventListener(Event_LoadZhuzaoComplete, _onLoadZhuzaoComplete);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			_openHeroId = "";
		}
		
		/**
		 * 按钮点击事件响应 - 关闭按钮
		 * @param e
		 * 
		 */		
		private function _onBtnClickClose(e:Event):void{
			//退出背包模块
			SApplication.moduleManager.exitModule("CJEnhanceModule");
		}
		
		/**
		 * 根据当前按钮类型重新设置标题内容
		 * 
		 */		
		private function _resetTitle():void
		{
			switch(this._pageType)
			{
				case BTN_TYPE_QIANGHUA:
					this._title.titleName = this._getLang("ENHANCE_TITLE_EQUIP");
					break;
				case BTN_TYPE_ZHUZAO:
					this._title.titleName = this._getLang("TITLE_ZHUANGBEIZHUZAO");
					break;
				case BTN_TYPE_XILIAN:
					this._title.titleName = this._getLang("TITLE_ZHUANGBEIXILIAN");
					break;
			}
		}
		
		/**
		 * 按钮点击事件响应 - 类型按钮
		 * @param event
		 * 
		 */		
		private function _onClickTypeBtn(event:Event):void
		{
			var btnType:int = -1;
			switch(event.target)
			{
				case this.btnQianghua:
					btnType = BTN_TYPE_QIANGHUA;
					break;
				case this.btnZhuzao:
					btnType = BTN_TYPE_ZHUZAO;
					break;
//				case this.btnShengjie:
//					btnType = BTN_TYPE_SHENGJIE;
//					break;
				case this.btnXilian:
					btnType = BTN_TYPE_XILIAN;
					break;
			}
			if (-1 == btnType)
			{
				return;
			}
			if (btnType == this._currentBtnType)
			{
				return;
			}
			// 原按钮类型
			var oldBtnType:int = this._currentBtnType;
			// 移除现在显示信息
			this._onRemoveOperatLayer(oldBtnType);
			// 将当前按钮类型赋值为当前点击按钮类型
			this._currentBtnType = btnType;
			this._pageType = btnType;
			_resetTitle();
			// 显示选择页签信息
			this._onAddOperatLayer(btnType);
		}
		
		/**
		 * 移除操作层内容
		 * @param type 原按钮类型
		 * 
		 */		
		private function _onRemoveOperatLayer(type:int):void
		{
			switch(type)
			{
				case BTN_TYPE_QIANGHUA:
					this.operatLayer.removeChild(_layerEnhanceEquip);
					break;
				case BTN_TYPE_ZHUZAO:
					this.operatLayer.removeChild(_layerItemMake);
					this.operatLayer.y += OFFSET_Y;
					break;
//				case BTN_TYPE_SHENGJIE:
//					break;
				case BTN_TYPE_XILIAN:
					this.operatLayer.removeChild(_layer_recast);
					break;
			}
		}
		
		/**
		 * 根据按钮类型显示相应页面信息
		 * @param type 按钮类型
		 * 
		 */		
		private function _onAddOperatLayer(type:int):void
		{
			this._currentBtnType = type;
			// 变更页签按钮显示
			this._changeButton(type);
			
			switch(type)
			{
				case BTN_TYPE_QIANGHUA:
					this._onClickQianghua();
					break;
				case BTN_TYPE_ZHUZAO:
					this._onClickZhuzao();
					break;
//				case BTN_TYPE_SHENGJIE:
//					this._onClickShengjie();
//					break;
				case BTN_TYPE_XILIAN:
					this._onClickXilian();
					break;
			}
		}
		
		/**
		 * 强化
		 * @param event
		 * 
		 */		
		private function _onClickQianghua():void
		{
			this._onLoadQianghuaComplete();
		}
		
		/**
		 * 强化加载成功
		 * 
		 */		
		private function _onLoadQianghuaComplete():void
		{
			//进入模块时添加背包层
			var enhanceEquipXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlEnhanceEquipConfig) as XML;
			_layerEnhanceEquip = SFeatherControlUtils.o.genLayoutFromXML(enhanceEquipXml, CJEnhanceEquipLayer) as CJEnhanceEquipLayer;
			if (_openHeroId != "")
			{
				_layerEnhanceEquip.setOpenHeroId(_openHeroId);
			}
			this._addOperation(_layerEnhanceEquip);
		}
		
		/**
		 * 向操作层添加layer, 将显示于强化界面关闭按钮下方
		 * @param layer
		 * @return 
		 * 
		 */		
		private function _addOperation(layer:SLayer):void
		{
			this.operatLayer.addChild(layer);
			this.setChildIndex(this.btnClose, this.numChildren - 1);
		}
		
		/**
		 * 铸造
		 * @param event
		 * 
		 */		
		private function _onClickZhuzao():void
		{
			var event:Event = new Event(Event_LoadZhuzaoComplete);
			// 获取背包数据
			var bagData:CJDataOfBag = CJDataManager.o.getData("CJDataOfBag");
			if(bagData.dataIsEmpty)
			{
				bagData.addEventListener(DataEvent.DataLoadedFromRemote, _fucZhuzao);
				bagData.loadFromRemote();
			}
			else
			{
//				dispatchEvent(event);
				_onLoadZhuzaoComplete();
			}
		}
		/**
		 * 移除背包数据的监听 
		 * @param e
		 * 
		 */		
		private function _fucZhuzao():void
		{
			var event:Event = new Event(Event_LoadZhuzaoComplete);
			dispatchEvent(event);
			var bagData:CJDataOfBag = CJDataManager.o.getData("CJDataOfBag");
			bagData.removeEventListener(DataEvent.DataLoadedFromRemote, _fucZhuzao);
		}
		
		/**
		 * 装备铸造加载成功
		 * 
		 */		
		private function _onLoadZhuzaoComplete():void
		{
			//进入模块时添加背包层
			var itemMakeXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlItemMakeConfig) as XML;
			_layerItemMake = SFeatherControlUtils.o.genLayoutFromXML(itemMakeXml, CJItemMakeLayer) as CJItemMakeLayer;
			this.operatLayer.y -= OFFSET_Y;
			this._addOperation(_layerItemMake);
		}
		
		/**
		 * 升阶
		 * @param event
		 * 
		 */		
		private function _onClickShengjie():void
		{
			
		}
		
		/**
		 * 洗练
		 * @param event
		 * 
		 */		
		private function _onClickXilian():void
		{
			//进入模块时添加洗练层
			var xml_itemRecaste:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlItemRecast) as XML;
			_layer_recast = SFeatherControlUtils.o.genLayoutFromXML(xml_itemRecaste, CJItemRecastLayer) as CJItemRecastLayer;
			if (_openHeroId != "")
			{
				_layer_recast.setOpenHeroId(_openHeroId);
			}
			this._addOperation(_layer_recast);
		}
		/**
		 * 功能按钮显示变更
		 * 
		 */		
		private function _changeButton(buttonType:int):void
		{
			for(var i:uint = 0; i < this._btnVec.length; i++)
			{
				if (buttonType == i)
				{
					// 选中
					this._btnVec[i].isSelected = true;
					this._btnVec[i].width = 62;
					this._btnVec[i].height = 50;
					this._btnVec[i].x = 0;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 16, 0xFFBD6E );
				}
				else
				{
					// 未选中
					this._btnVec[i].isSelected = false;
					this._btnVec[i].width = 53;
					this._btnVec[i].height = 47;
					this._btnVec[i].x = 7;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xF1D98E );
				}
			}
		}
		
		/**
		 * 获取按钮默认图片
		 * @return 
		 * 
		 */		
		private function _getImgBtnDft():SImage
		{
			return new SImage(SApplication.assets.getTexture("common_xuanxiangka02"));
		}
		/**
		 * 获取按钮选中图片
		 * @return 
		 * 
		 */		
		private function _getImgBtnSel():SImage
		{
			return new SImage(SApplication.assets.getTexture("common_xuanxiangka01"))
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.removeEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
			}
			
			this._btnClose.removeEventListener(Event.TRIGGERED, _onBtnClickClose);
			if (this._layerEnhanceEquip != null)
			{
				this._layerEnhanceEquip.removeAllEventListener();
			}
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
		
		/** 背景图 */
		private var _imgBg:Scale9Image;
		/** 背景角 */
		private var _imgBgcorner:Scale9Image;
		/** 分割线 */
		private var _imgLine:Scale3Image;
		/** 标题背景图 */
		private var _imgTitleBg:SImage;
		/** 标题文字 */
		private var _labTitle:Label;
		/** 强化按钮 */
		private var _btnQianghua:Button;
		/** 打造按钮 */
		private var _btnZhuzao:Button;
		/** 升阶按钮 */
		private var _btnShengjie:Button;
		/** 洗练按钮 */
		private var _btnXilian:Button;
		/** 关闭按钮 */
		private var _btnClose:Button;
		/** 操作界面层 */
		private var _operatLayer:SLayer;
		
		/** setter */
		public function set imgBg(value:Scale9Image):void
		{
			this._imgBg = value;
		}
		public function set imgBgcorner(value:Scale9Image):void
		{
			this._imgBgcorner = value;
		}
		public function set imgLine(value:Scale3Image):void
		{
			this._imgLine = value;
		}
		public function set imgTitleBg(value:SImage):void
		{
			this._imgTitleBg = value;
		}
		public function set labTitle(value:Label):void
		{
			this._labTitle = value;
		}
		public function set btnQianghua(value:Button):void
		{
			this._btnQianghua = value;
		}
		public function set btnZhuzao(value:Button):void
		{
			this._btnZhuzao = value;
		}
		public function set btnShengjie(value:Button):void
		{
			this._btnShengjie = value;
		}
		public function set btnXilian(value:Button):void
		{
			this._btnXilian = value;
		}
		public function set btnClose(value:Button):void
		{
			this._btnClose = value;
		}
		public function set operatLayer(value:SLayer):void
		{
			this._operatLayer = value;
		}
		
		/** getter */
		public function get imgBg():Scale9Image
		{
			return this._imgBg;
		}
		public function get imgBgcorner():Scale9Image
		{
			return this._imgBgcorner;
		}
		public function get imgLine():Scale3Image
		{
			return this._imgLine;
		}
		public function get imgTitleBg():SImage
		{
			return this._imgTitleBg;
		}
		public function get labTitle():Label
		{
			return this._labTitle;
		}
		public function get btnQianghua():Button
		{
			return this._btnQianghua;
		}
		public function get btnZhuzao():Button
		{
			return this._btnZhuzao;
		}
		public function get btnShengjie():Button
		{
			return this._btnShengjie;
		}
		public function get btnXilian():Button
		{
			return this._btnXilian;
		}
		public function get btnClose():Button
		{
			return this._btnClose;
		}
		public function get operatLayer():SLayer
		{
			return this._operatLayer;
		}
	}
}