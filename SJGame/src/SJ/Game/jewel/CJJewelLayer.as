package SJ.Game.jewel
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
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
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class CJJewelLayer extends SLayer
	{
		public function CJJewelLayer()
		{
			super();
		}
		
		public function setPageType(type:int = BTN_TYPE_XIANGQIAN):void
		{
			if (type in BTN_TYPES)
			{
				this._pageType = type;
			}
		}
		/** 页面类型 */
		private var _pageType:int = BTN_TYPE_XIANGQIAN;
		/** 按钮类型 */
		/** 镶嵌 */
		public static const BTN_TYPE_XIANGQIAN:int = 0;
		/** 合成 */
		public static const BTN_TYPE_HECHENG:int = 1;
		public static const BTN_TYPES:Array = [BTN_TYPE_XIANGQIAN, BTN_TYPE_HECHENG];
		
		/** 按钮 */
		private var _btnVec:Vector.<Button>;
		/** 当前按钮类型 */
		private var _currentBtnType:int = 0;
		
		/** 宝石镶嵌层 */
		private var _layerJewelInlay:CJJewelInlayLayer;
		/** 宝石合成层 */
		private var _layerJewelCombine:CJJewelCombineLayer;
		private static const Event_LoadJewelCombineComplete:String = "Event_LoadJewelCombineComplete";
		/** 标题 */
		private var _title:CJPanelTitle;
		
		/** 进入界面时默认选中的武将id */
		private var _openHeroId:String = "";
		override protected function initialize():void
		{
			super.initialize();
			
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			
			var texture:Texture;
			// 背景遮罩图
//			var imgBg:Scale9Image;
//			texture = SApplication.assets.getTexture("common_dinew");
//			var bgScaleRange:Rectangle = new Rectangle(44, 44, 1, 1);
//			var bgTexture:Scale9Textures = new Scale9Textures(texture, bgScaleRange);
//			imgBg = new Scale9Image(bgTexture);
//			imgBg.width = SApplicationConfig.o.stageWidth;
//			imgBg.height = SApplicationConfig.o.stageHeight;
//			imgBg.alpha = 0.7;
//			this.addChildAt(imgBg, 0);
			
			// 背景
			texture = SApplication.assets.getTexture("common_quanbingdise");
			var imgBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
			imgBg.width = width;
			imgBg.height = height;
			this.addChildAt(imgBg, 0);
			
			// 边角
			var imgBgcorner:Scale9Image;
			var textureCorner:Texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			var corScaleRange:Rectangle = new Rectangle(14, 14, 1, 1);
			var corTexture:Scale9Textures = new Scale9Textures(textureCorner, corScaleRange);
			imgBgcorner = new Scale9Image(corTexture);
			imgBgcorner.x = 0;
			imgBgcorner.y = 0;
			imgBgcorner.width = SApplicationConfig.o.stageWidth;
			imgBgcorner.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(imgBgcorner, 1);
			
			var img:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			img.width = SApplicationConfig.o.stageWidth;
			img.x = 0;
			img.y = 0;
			img.height = 20;
			this.addChild(img);
			
			// 标题
			this._title = new CJPanelTitle(CJLang("TITLE_XIANGQIAN"));
			this.addChild(this._title);
			this._title.x = SApplicationConfig.o.stageWidth - this._title.width >> 1 ;
			
			// 页签按钮
			this._btnVec = new Vector.<Button>;
			this._btnVec.push(this.btnXiangqian, 
							  this.btnHecheng);
			
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.defaultSkin = this._getImgBtnDft();
				btnTemp.defaultSelectedSkin = this._getImgBtnSel();
				btnTemp.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xF1D98E );
				
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
			}
			this.btnXiangqian.label = this._getLang("JEWEL_BTN_XIANGQIAN");
			this.btnHecheng.label = this._getLang("JEWEL_BTN_HECHENG");
			
			
			// 关闭按钮
			this._btnClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			// 为关闭按钮添加监听
			this._btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
//			this.imgBg.width = this.width;
//			this.imgBg.height = this.height;
			
//			// 分割线
//			var textureLine:Texture = SApplication.assets.getTexture("common_fengexian");
//			var lineTexture:Scale3Textures = new Scale3Textures(textureLine, textureLine.width/2-1, 1);
//			this.imgLine = new Scale3Image(lineTexture);
//			this.imgLine.x = 0;
//			this.imgLine.y = 10;
//			this.imgLine.width = 480;
//			this.imgLine.height = 7;
//			this.addChildAt(imgLine, 2);
			
			
			
			this.setChildIndex(btnClose, this.numChildren - 1);
			this.setChildIndex(this.operatLayer, this.getChildIndex(btnClose));

//			new SImage(SApplication.assets.getTexture("common_biaotilan"));
			
//			this._changeButton(BTN_TYPE_QIANGHUA);
//			var defaultBtnType:int = BTN_TYPE_XIANGQIAN;
			this._currentBtnType = this._pageType;
			this._onAddOperatLayer(this._pageType);
			// 重新设置标题内容
			_resetTitle();
//			this.addEventListener(Event_LoadQianghuaComplete, _onLoadQianghuaComplete);
//			this.addEventListener(Event_LoadJewelCombineComplete, _onLoadJewelCombineComplete);
			
			var optIdx:int = 0;
			// 操作层 - 底图
			var imgOptBgKuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_dinew");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
			imgOptBgKuang.x = 0;
			imgOptBgKuang.y = 0;
			imgOptBgKuang.width = this.operatLayer.width;
			imgOptBgKuang.height = this.operatLayer.height;
			this.operatLayer.addChildAt(imgOptBgKuang, optIdx++);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(44, 44, 1, 1)));
			imgOptBgKuang.x = 0;
			imgOptBgKuang.y = 0;
			imgOptBgKuang.width = this.operatLayer.width;
			imgOptBgKuang.height = this.operatLayer.height;
			this.operatLayer.addChildAt(imgOptBgKuang, optIdx++);
			
			// 花框
//			var imgOutFrameDecorate:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_zhuangshinew", 15, 15,7,3);
//			imgOutFrameDecorate.x = 3;
//			imgOutFrameDecorate.y = 3;
//			imgOutFrameDecorate.width = this.operatLayer.width - 6;
//			imgOutFrameDecorate.height = this.operatLayer.height - 6;
//			this.operatLayer.addChildAt(imgOutFrameDecorate, optIdx++);
			var panelFrame:CJPanelFrame = new CJPanelFrame(this.operatLayer.width - 6, this.operatLayer.height - 6);
			panelFrame.x = 3;
			panelFrame.y = 3;
			this.operatLayer.addChildAt(panelFrame, optIdx++);
			
			// 操作层 - 边框
			var textureBiankuang:Texture = SApplication.assets.getTexture("common_waikuangnew");
			var bgScaleRangeBk:Rectangle = new Rectangle(15 , 15 , 1, 1);
			var bgTextureBk:Scale9Textures = new Scale9Textures(textureBiankuang, bgScaleRangeBk);
			var imgBiankuang:Scale9Image = new Scale9Image(bgTextureBk);
			imgBiankuang.width = this.operatLayer.width;
			imgBiankuang.height = this.operatLayer.height;
			this.operatLayer.addChildAt(imgBiankuang, optIdx++);
			
//			// 操作层 - 边
//			var ttBianTemp:Texture = SApplication.assets.getTexture("common_biankuanghuawen");
//			var tiTop:TiledImage = new TiledImage(ttBianTemp);
//			tiTop.width = 393;
//			tiTop.height = 5;
//			tiTop.x = 14;
//			tiTop.y = 2;
//			this.operatLayer.addChild(tiTop);
//			
//			var tiBottom:TiledImage = new TiledImage(ttBianTemp);
//			tiBottom.width = 393;
//			tiBottom.height = 5;
//			tiBottom.x = 14;
//			tiBottom.y = 266;
//			this.operatLayer.addChild(tiBottom);
//			
//			var tiLeft:TiledImage = new TiledImage(ttBianTemp);
//			tiLeft.width = 246;
//			tiLeft.height = 5;
//			tiLeft.x = 7;
//			tiLeft.y = 14;
//			tiLeft.rotation = Math.PI / 2;
//			this.operatLayer.addChild(tiLeft);
//			
//			var tiRight:TiledImage = new TiledImage(ttBianTemp);
//			tiRight.width = 246;
//			tiRight.height = 5;
//			tiRight.x = 418;
//			tiRight.y = 14;
//			tiRight.rotation = Math.PI / 2;
//			this.operatLayer.addChild(tiRight);
			
			_openHeroId = "";
		}
		
		/**
		 * 按钮点击 - 关闭按钮
		 * @param event
		 * 
		 */		
		private function _onBtnClickClose(event:Event):void
		{
			// 退出宝石模块
			SApplication.moduleManager.exitModule("CJJewelModule");
		}
		
		/**
		 * 根据当前按钮类型重新设置标题内容
		 * 
		 */		
		private function _resetTitle():void
		{
			switch(this._pageType)
			{
				case BTN_TYPE_XIANGQIAN:
					this._title.titleName = this._getLang("TITLE_XIANGQIAN");
					break;
				case BTN_TYPE_HECHENG:
					this._title.titleName = this._getLang("TITLE_HECHENG");
					break;
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
		
		private function _onClickTypeBtn(event:Event):void
		{
			var btnType:int = -1;
			
			switch(event.target)
			{
				case this.btnXiangqian:
					btnType = BTN_TYPE_XIANGQIAN;
//					this._title.titleName = this._getLang("TITLE_XIANGQIAN");
					break;
				case this.btnHecheng:
					btnType = BTN_TYPE_HECHENG;
//					this._title.titleName = this._getLang("TITLE_HECHENG");
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
			// 重新设置标题内容
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
				case BTN_TYPE_XIANGQIAN:
					// 镶嵌
					this.operatLayer.removeChild(_layerJewelInlay, true);
					_layerJewelInlay = null;
					//移除装备强化的资源
//					AssetManagerUtil.o.disposeAssetsByGroup("CJJewelInlayModuleResource1");
					break;
				case BTN_TYPE_HECHENG:
					// 合成
					this.operatLayer.removeChild(_layerJewelCombine , true);
					_layerJewelCombine = null;
					//移除加载的宝石合成层的资源
//					AssetManagerUtil.o.disposeAssetsByGroup("CJJewelCombineResource1");
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
			// 变更页签按钮显示
			this._changeButton(type);
			
			switch(type)
			{
				case BTN_TYPE_XIANGQIAN:
					this._onEnterXiangqian();
					break;
				case BTN_TYPE_HECHENG:
					this._onEnterHeCheng();
					break;
			}
		}
		
		/**
		 * 强化
		 * @param event
		 * 
		 */		
		private function _onEnterXiangqian():void
		{
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
//			//添加加载动画
//			CJLayerManager.o.addToModal(loading);
//			//加载强化层的布局文件和图片资源
//			AssetManagerUtil.o.loadPrepareInQueue("CJJewelInlayModuleResource0", ConstResource.sResSxmlJewelInlayConfig);
//			AssetManagerUtil.o.loadPrepareInQueue("CJJewelInlayModuleResource1",
//				ConstResource.sResXmlZhuangbei,
//				ConstResource.sResXmlBaoshi,
//				ConstResource.SResXmlEnhanceEquipImg
//			);
//			
//			AssetManagerUtil.o.loadQueue(function (r:Number):void
//			{
//				//设置加载动画的进度
//				if(r == 1)
//				{
//					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
//					
//					_onLoadXiangqianComplete();
//				}
//			});
			_onLoadXiangqianComplete();
		}
		
		/**
		 * 宝石镶嵌加载成功
		 * 
		 */		
		private function _onLoadXiangqianComplete():void
		{
			//进入模块时添加背包层
			var jewelInlayXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlJewelInlayConfig) as XML;
			_layerJewelInlay = SFeatherControlUtils.o.genLayoutFromXML(jewelInlayXml, CJJewelInlayLayer) as CJJewelInlayLayer;
			if (_openHeroId != "")
			{
				_layerJewelInlay.setOpenHeroId(_openHeroId);
			}
			this._addOperation(_layerJewelInlay);
		}
		
		/**
		 * 合成
		 * @param event
		 * 
		 */		
		private function _onEnterHeCheng():void
		{
					
//			var event:Event = new Event(Event_LoadJewelCombineComplete);
//			// 获取背包数据
//			var bagData:CJDataOfBag = CJDataManager.o.getData("CJDataOfBag");
//			if(bagData.dataIsEmpty)
//			{
//				bagData.addEventListener(DataEvent.DataLoadedFromRemote, _funcJewelCombine);
//				bagData.loadFromRemote();
//			}
//			else
//			{
//				dispatchEvent(event);
//			}
			_onLoadJewelCombineComplete();
		}
		
		/**
		 * 移除背包数据的监听 
		 * @param e
		 * 
		 */		
		private function _funcJewelCombine(e:Event):void
		{
			var event:Event = new Event(Event_LoadJewelCombineComplete);
			dispatchEvent(event);
			var bagData:CJDataOfBag = CJDataManager.o.getData("CJDataOfBag");
			bagData.removeEventListener(DataEvent.DataLoadedFromRemote, _funcJewelCombine);
		}
		
		/**
		 * 宝石合成界面加载成功
		 * 
		 */		
		private function _onLoadJewelCombineComplete():void
		{
			//进入模块时添加背包层
			var jewelCombineXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlJewelCombineConfig) as XML;
			_layerJewelCombine = SFeatherControlUtils.o.genLayoutFromXML(jewelCombineXml, CJJewelCombineLayer) as CJJewelCombineLayer;
			this._addOperation(_layerJewelCombine);
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
//					this._btnVec[i].width = 62;
//					this._btnVec[i].height = 50;
//					this._btnVec[i].x = 0;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 16, 0xFFBD6E );
				}
				else
				{
					// 未选中
					this._btnVec[i].isSelected = false;
//					this._btnVec[i].width = 53;
//					this._btnVec[i].height = 47;
//					this._btnVec[i].x = 7;
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
			_btnClose.removeEventListener(Event.TRIGGERED, _onBtnClickClose);
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.removeEventListener(Event.TRIGGERED, _onClickTypeBtn);
			}
			super.dispose();
		}
		
		/** 背景图 */
//		private var _imgBg:Scale9Image;
		/** 背景角 */
//		private var _imgBgcorner:Scale9Image;
		/** 分割线 */
//		private var _imgLine:Scale3Image;
		/** 标题背景图 */
//		private var _imgTitleBg:SImage;
		/** 标题文字 */
//		private var _labTitle:Label;
		/** 镶嵌按钮 */
		private var _btnXiangqian:Button;
		/** 合成打造按钮 */
		private var _btnHecheng:Button;
		/** 关闭按钮 */
		private var _btnClose:Button;
		/** 操作界面层 */
		private var _operatLayer:SLayer;
		
		/** setter */
//		public function set imgBg(value:Scale9Image):void
//		{
//			this._imgBg = value;
//		}
//		public function set imgBgcorner(value:Scale9Image):void
//		{
//			this._imgBgcorner = value;
//		}
//		public function set imgLine(value:Scale3Image):void
//		{
//			this._imgLine = value;
//		}
//		public function set imgTitleBg(value:SImage):void
//		{
//			this._imgTitleBg = value;
//		}
//		public function set labTitle(value:Label):void
//		{
//			this._labTitle = value;
//		}
		public function set btnXiangqian(value:Button):void
		{
			this._btnXiangqian = value;
		}
		public function set btnHecheng(value:Button):void
		{
			this._btnHecheng = value;
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
//		public function get imgBg():Scale9Image
//		{
//			return this._imgBg;
//		}
//		public function get imgBgcorner():Scale9Image
//		{
//			return this._imgBgcorner;
//		}
//		public function get imgLine():Scale3Image
//		{
//			return this._imgLine;
//		}
//		public function get imgTitleBg():SImage
//		{
//			return this._imgTitleBg;
//		}
//		public function get labTitle():Label
//		{
//			return this._labTitle;
//		}
		public function get btnXiangqian():Button
		{
			return this._btnXiangqian;
		}
		public function get btnHecheng():Button
		{
			return this._btnHecheng;
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