package SJ.Game.rank
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 排行榜层
	 * @author zhengzheng
	 * 
	 */	
	public class CJRankLayer extends SLayer
	{
		public function CJRankLayer()
		{
			super();
			this.setSize(480, 320);
		}
		
		/** 按钮类型 */
		/** 等级榜*/
		private static const BTN_TYPE_RANK_LEVEL:int = 0;
		/** 战力榜 */
		private static const BTN_TYPE_RANK_BATTLE_LEVEL:int = 1;
		/** 土豪榜 */
		private static const BTN_TYPE_RANK_RICH_LEVEL:int = 2;
		
		/** 按钮 */
		private var _btnVec:Vector.<Button>;
		/** 当前按钮类型 */
		private var _currentBtnType:int = 0;
		
		/** 等级榜层 */
		private var _layerRankLevel:CJRankLevelLayer;
		/** 战力榜层 */
		private var _layerRankBattleLevel:CJRankBattleLevelLayer;
		/** 土豪榜层 */
		private var _layerRankRichLevel:CJRankRichLevelLayer;
		
		/** 排行榜显示标签数组*/
		private var _arrLabRankInfo:Array;
		/** 排行榜显示信息标题数组*/
		private var _arrLabRankInfoTitle:Array;
		
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			
			//背景遮罩图
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanbingdise", 1 ,1 , 1, 1);
			imgBg.width = 480;
			imgBg.height = 320;
			this.addChildAt(imgBg, 0);
			
			// 全屏头部底
			var imgHeadBg:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			imgHeadBg.width = SApplicationConfig.o.stageWidth;
			imgHeadBg.width = 480;
			this.addChildAt(imgHeadBg, 1);
			// 边角
			this.imgBgcorner = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanpingzhuangshi", 14.5, 13, 1, 1);
			this.imgBgcorner.x = 0;
			this.imgBgcorner.y = 0;
			this.imgBgcorner.width = 480;
			this.imgBgcorner.height = 320;
			this.addChildAt(imgBgcorner, 2);
			
			
			//标题
			var labTitle:CJPanelTitle = new CJPanelTitle(this._getLang("RANK_LIST"));
			this.addChild(labTitle);
			labTitle.x = 100;
			
			
			//背景底图
			var imgOperateBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinew", 1 ,1 , 1, 1);
			imgOperateBg.width = this.operatLayer.width;
			imgOperateBg.height = this.operatLayer.height;
			this.operatLayer.addChildAt(imgOperateBg, 0);
			
//			// 操作层 - 边框装饰
//			var operateFrame:ImageLoader = new ImageLoader();
//			operateFrame.source = SApplication.assets.getTexture("paihangbang_zhuangshi");
//			operateFrame.x = -1;
//			this.operatLayer.addChildAt(operateFrame, 1);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.operatLayer.width - 8 , this.operatLayer.height - 8);
			bgBall.x = 4;
			bgBall.y = 4;
			this.operatLayer.addChildAt(bgBall, 1);
			
			//操作层遮罩
			var imgOperateShade:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 43, 43,1,1);
			imgOperateShade.width = this.operatLayer.width - 20;
			imgOperateShade.height = this.operatLayer.height - 20;
			imgOperateShade.x = 10;
			imgOperateShade.y = 10;
			this.operatLayer.addChildAt(imgOperateShade, 2);
			
			//操作层 - 外边框图
			var imgOutFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew", 15 , 15 , 1, 1);
			imgOutFrame.width = this.operatLayer.width;
			imgOutFrame.height = this.operatLayer.height;
			this.operatLayer.addChildAt(imgOutFrame, 3);
			
//			var operateFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("paihangbang_zhuangshi", 15,15,3,3);
//			operateFrame.width = this.operatLayer.width - 4;
//			operateFrame.height = this.operatLayer.height - 4;
//			operateFrame.x = 2;
//			operateFrame.y = 1;
//			this.operatLayer.addChildAt(operateFrame, 0);
			
			this.setChildIndex(btnClose, this.numChildren - 1);
			this.setChildIndex(this.operatLayer, this.getChildIndex(btnClose) - 1);
			
			// 页签按钮
			this._btnVec = new Vector.<Button>;
			this._btnVec.push(this.btnRankLevel, this.btnRankBattleLevel, this.btnRankRichLevel);
			
			
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.defaultSelectedSkin = this._getImgBtnSel();
				btnTemp.defaultLabelProperties.textFormat = new TextFormat("Arial", 10, 0xEDDB94);
				
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
			}

			var defaultBtnType:int = BTN_TYPE_RANK_LEVEL;
			this._currentBtnType = defaultBtnType;
			this._onAddOperatLayer(defaultBtnType);
			
			// 为关闭按钮添加监听
			this._btnClose.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				// 退出好友模块
				SApplication.moduleManager.exitModule("CJRankModule");
			});
//			this.setChildIndex(this.operatLayer, this.numChildren - 1);
		}
		private function _initData():void
		{
			this.btnRankLevel.label = this._getLang("RANK_LEVEL_LIST");
			this.btnRankBattleLevel.label = this._getLang("RANK_BATTLE_POWER_LIST");
			this.btnRankRichLevel.label = this._getLang("RANK_RICH_LEVEL_LIST");
			
			_arrLabRankInfo = new Array(
				this.labTitleRank,this.labTitlePlayer,this.labTitleLevel,
				this.labTitleBattleLv,this.labTitleCamp,this.labTitleGroup
			);
			for (var i:int = 0; i < _arrLabRankInfo.length; i++)
			{
				var labRankInfo:Label = _arrLabRankInfo[i] as Label;
				labRankInfo.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFEFE66,null,null,null,null,null,TextFormatAlign.CENTER);
			}
			_setRankTitle();
		}
		/**
		 * 设置排行榜
		 * 
		 */		
		private function _setRankTitle(btnType:int = 0):void
		{
			if (btnType == BTN_TYPE_RANK_RICH_LEVEL)
			{
				_arrLabRankInfoTitle = new Array(
					CJLang("RANK_RANK"),CJLang("RANK_PLAYER"),"VIP"+ CJLang("RANK_LEVEL"),
					CJLang("RANK_TOTAL_USE_GOLD"),CJLang("RANK_LEVEL"),CJLang("RANK_ARMY_GROUP_NAME")
				);
			}
			else
			{
				_arrLabRankInfoTitle = new Array(
					CJLang("RANK_RANK"),CJLang("RANK_PLAYER"),"VIP"+ CJLang("RANK_LEVEL"),
					CJLang("RANK_TOTAL_BATTLE_POWER"),CJLang("RANK_LEVEL"),CJLang("RANK_ARMY_GROUP_NAME")
				);
			}
			for (var i:int = 0; i < _arrLabRankInfo.length; i++)
			{
				var labRankInfo:Label = _arrLabRankInfo[i] as Label;
				labRankInfo.text = _arrLabRankInfoTitle[i];
			}
		}
		private function _onClickTypeBtn(event:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			var btnType:int = -1;
			switch(event.target)
			{
				case this.btnRankLevel:
					btnType = BTN_TYPE_RANK_LEVEL;
					_setRankTitle();
					break;
				case this.btnRankBattleLevel:
					btnType = BTN_TYPE_RANK_BATTLE_LEVEL;
					_setRankTitle();
					break;
				case this.btnRankRichLevel:
					btnType = BTN_TYPE_RANK_RICH_LEVEL;
					_setRankTitle(BTN_TYPE_RANK_RICH_LEVEL);
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
				case BTN_TYPE_RANK_LEVEL:
					// 等级榜
					this.operatLayer.removeChild(_layerRankLevel, true);
					break;
				case BTN_TYPE_RANK_BATTLE_LEVEL:
					// 战力榜
					this.operatLayer.removeChild(_layerRankBattleLevel , true);
					break;
				case BTN_TYPE_RANK_RICH_LEVEL:
					// 土豪榜
					this.operatLayer.removeChild(_layerRankRichLevel , true);
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
				case BTN_TYPE_RANK_LEVEL:
					this._onEnterRankLevelLayer();
					break;
				case BTN_TYPE_RANK_BATTLE_LEVEL:
					this._onEnterRankBattleLevelLayer();
					break;
				case BTN_TYPE_RANK_RICH_LEVEL:
					this._onEnterRankRichLevelLayer();
					break;
			}
		}
		
		/**
		 * 进入等级榜层
		 * 
		 */		
		private function _onEnterRankLevelLayer():void
		{
			_layerRankLevel = new CJRankLevelLayer();
			this._addOperation(_layerRankLevel);
		}
		
		/**
		 * 进入战力榜层
		 * 
		 */		
		private function _onEnterRankBattleLevelLayer():void
		{
			_layerRankBattleLevel = new CJRankBattleLevelLayer();
			this._addOperation(_layerRankBattleLevel);
		}
		
		/**
		 * 进入土豪榜层
		 * 
		 */		
		private function _onEnterRankRichLevelLayer():void
		{
			_layerRankRichLevel = new CJRankRichLevelLayer();
			this._addOperation(_layerRankRichLevel);
		}
		/**
		 * 向操作层添加layer, 将显示于关闭按钮下方
		 * @param layer
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
					this._btnVec[i].width = 62;
					this._btnVec[i].height = 47;
					this._btnVec[i].x = 0;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat("Arial", 12, 0xFDC68B );
				}
				else
				{
					// 未选中
					this._btnVec[i].isSelected = false;
					this._btnVec[i].width = 55;
					this._btnVec[i].height = 42;
					this._btnVec[i].x = 7;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat("Arial", 10, 0xF7E399 );
				}
			}
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
		
		/** 背景图 */
		private var _imgBg:ImageLoader;
		/** 背景角 */
		private var _imgBgcorner:Scale9Image;
		/** 分割线 */
		private var _imgLine:Scale3Image;
		/** 标题背景图 */
		private var _imgTitleBg:SImage;
		/** 等级榜按钮 */
		private var _btnRankLevel:Button;
		/** 战力榜按钮 */
		private var _btnRankBattleLevel:Button;
		/** 土豪榜按钮 */
		private var _btnRankRichLevel:Button;
		/** 关闭按钮 */
		private var _btnClose:Button;
		/** 操作界面层 */
		private var _operatLayer:SLayer;
		
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
		public function set btnClose(value:Button):void
		{
			this._btnClose = value;
		}
		public function set operatLayer(value:SLayer):void
		{
			this._operatLayer = value;
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
		public function get btnClose():Button
		{
			return this._btnClose;
		}
		public function get operatLayer():SLayer
		{
			return this._operatLayer;
		}

		/** 等级榜按钮 */
		public function get btnRankLevel():Button
		{
			return _btnRankLevel;
		}

		public function set btnRankLevel(value:Button):void
		{
			_btnRankLevel = value;
		}

		/** 战力榜按钮 */
		public function get btnRankBattleLevel():Button
		{
			return _btnRankBattleLevel;
		}

		public function set btnRankBattleLevel(value:Button):void
		{
			_btnRankBattleLevel = value;
		}
		private var _imgTitleFrame:ImageLoader;
		/**  分类标题背景图 **/
		public function get imgTitleFrame():ImageLoader
		{
			return _imgTitleFrame;
		}
		/** @private **/
		public function set imgTitleFrame(value:ImageLoader):void
		{
			_imgTitleFrame = value;
		}
		private var _labTitleRank:Label;
		/**  分类标题文字-排名 **/
		public function get labTitleRank():Label
		{
			return _labTitleRank;
		}
		/** @private **/
		public function set labTitleRank(value:Label):void
		{
			_labTitleRank = value;
		}
		private var _labTitlePlayer:Label;
		/**  分类标题文字-玩家 **/
		public function get labTitlePlayer():Label
		{
			return _labTitlePlayer;
		}
		/** @private **/
		public function set labTitlePlayer(value:Label):void
		{
			_labTitlePlayer = value;
		}
		private var _labTitleLevel:Label;
		/**  分类标题文字-等级 **/
		public function get labTitleLevel():Label
		{
			return _labTitleLevel;
		}
		/** @private **/
		public function set labTitleLevel(value:Label):void
		{
			_labTitleLevel = value;
		}
		private var _labTitleBattleLv:Label;
		/**  分类标题文字-总战力 **/
		public function get labTitleBattleLv():Label
		{
			return _labTitleBattleLv;
		}
		/** @private **/
		public function set labTitleBattleLv(value:Label):void
		{
			_labTitleBattleLv = value;
		}
		private var _labTitleCamp:Label;
		/**  分类标题文字-阵营 **/
		public function get labTitleCamp():Label
		{
			return _labTitleCamp;
		}
		/** @private **/
		public function set labTitleCamp(value:Label):void
		{
			_labTitleCamp = value;
		}
		private var _labTitleGroup:Label;
		/**  分类标题文字-军团名 **/
		public function get labTitleGroup():Label
		{
			return _labTitleGroup;
		}
		/** @private **/
		public function set labTitleGroup(value:Label):void
		{
			_labTitleGroup = value;
		}

		public function get btnRankRichLevel():Button
		{
			return _btnRankRichLevel;
		}

		public function set btnRankRichLevel(value:Button):void
		{
			_btnRankRichLevel = value;
		}


	}
}