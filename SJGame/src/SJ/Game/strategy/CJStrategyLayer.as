package SJ.Game.strategy
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.display.SScale3Plane;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 攻略层
	 * @author zhengzheng
	 * 
	 */	
	public class CJStrategyLayer extends SLayer
	{
		public function CJStrategyLayer()
		{
			super();
			
		}
		
		/** 按钮类型 */
		public static const BTN_TYPE_ZHANDOULI:int = 0;
		public static const BTN_TYPE_JINGYAN:int = 1;
		public static const BTN_TYPE_YINLIANG:int = 2;
		public static const BTN_TYPE_YUANBAO:int = 3;
		private static const BTN_TYPES:Array = [BTN_TYPE_ZHANDOULI, BTN_TYPE_JINGYAN, 
			BTN_TYPE_YINLIANG, BTN_TYPE_YUANBAO];
		
		/** 按钮 */
		private var _btnVec:Vector.<Button> = new Vector.<Button>;
		/** 当前按钮类型 */
		private var _currentBtnType:int = 0;
		
		/** 攻略战斗力层 */
		private var _layerStrategyBattle:CJStrategyBattleLayer;
		/** 攻略经验层 */
		private var _layerStrategyExp:CJStrategyExpLayer;
		/** 攻略银两层 */
		private var _layerStrategySilver:CJStrategySilverLayer;
		/** 攻略元宝层 */
		private var _layerStrategyGold:CJStrategyGoldLayer;
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
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.operatLayer.width, this.operatLayer.height);
			bgBall.x = 0;
			bgBall.y = 30;
			this.addChildAt(bgBall, 1);
			
			// 边角
			var textureCorner:Texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			var corScaleRange:Rectangle = new Rectangle(13, 14, 1, 1);
			var corTexture:Scale9Textures = new Scale9Textures(textureCorner, corScaleRange);
			this.imgBgcorner = new Scale9Image(corTexture);
			this.imgBgcorner.x = 0;
			this.imgBgcorner.y = 0;
			this.imgBgcorner.width = 480;
			this.imgBgcorner.height = 320;
			this.addChildAt(imgBgcorner, 2);
			
			texture = SApplication.assets.getTexture("common_wujiangxuanzedi");
			var leftPanelBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(14.5 ,14.5 , 1, 1)));
			leftPanelBg.width = 104;
			leftPanelBg.height = 268;
			leftPanelBg.x = 10;
			leftPanelBg.y = 39;
			this.addChildAt(leftPanelBg, 3);
			
			texture = SApplication.assets.getTexture("green_dikuang");
			var playerInfoBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(20 ,20 , 1, 1)));
			playerInfoBg.width = 95;
			playerInfoBg.height = 68;
			playerInfoBg.x = 15;
			playerInfoBg.y = 44;
			this.addChildAt(playerInfoBg, 4);
			
			//分割线
			var line:ImageLoader = new ImageLoader();
			line.source = SApplication.assets.getTexture("common_fengexian");
			line.pivotX = line.width / 2;
			line.pivotY = line.height / 2;
			line.rotation = Math.PI / 2;
			line.x = 121;
			line.y = 38;
			line.width = 268;
			line.height = 5;
			this.addChildAt(line, 5);
			
			// 标题背景
			var img:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			img.width = SApplicationConfig.o.stageWidth;
			img.x = 0;
			img.y = 0;
			img.height = 20;
			this.addChild(img);
			// 标题
			this._title = new CJPanelTitle(this._getLang("STRATEGY_PROMOTION_GUIDE"));
			this.addChild(this._title);
			this._title.x = SApplicationConfig.o.stageWidth - this._title.width >> 1 ;
			
			// 页签按钮
			this._btnVec.push(this.btnBattle, 
							  this.btnExp, 
							  this.btnSilver,
							  this.btnGold);
			
			
			this.btnBattle.label = this._getLang("STRATEGY_BATTLE_POWER");
			this.btnExp.label = this._getLang("STRATEGY_EXPERIENCE");
			this.btnSilver.label = this._getLang("STRATEGY_SILVER");
			this.btnGold.label = this._getLang("STRATEGY_GOLD");
			
			this.labRoute.text = this._getLang("STRATEGY_ROUTE");
			
			var textFormat:TextFormat = new TextFormat( "黑体", 12, 0xFDF77A);
			this.labRoute.textRendererProperties.textFormat = textFormat;
			
			this.labStar.text = this._getLang("STRATEGY_RECOMMEND_STAR");
			this.labStar.textRendererProperties.textFormat = textFormat;
			
			this.labEnter.text = this._getLang("STRATEGY_ENTRANCE");
			this.labEnter.textRendererProperties.textFormat = textFormat;
			
			var roleData:CJDataOfRole = CJDataManager.o.DataOfRole;
			var mainHeroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getMainHero();
			var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(mainHeroInfo.templateid));
			var color:int = ConstHero.ConstHeroNameColor[int(heroProperty.quality)];
			textFormat = new TextFormat( "黑体", 12, color);
			this.labRoleName.text = roleData.name;
			this.labRoleName.textRendererProperties.textFormat = textFormat;
			
			textFormat = new TextFormat( "黑体", 12, 0xFAF355);
			this.labLevel.text = CJLang("STRATEGY_LEVEL") + mainHeroInfo.level;
			this.labLevel.textRendererProperties.textFormat = textFormat;
			
			textFormat = new TextFormat( "黑体", 12, 0x93D437);
			this.labVip.text = "VIP" + roleData.vipLevel;
			this.labVip.textRendererProperties.textFormat = textFormat;
			
			textFormat = new TextFormat( "黑体", 12, 0xE9B86E);
			this.labBattlePower.text = CJLang("STRATEGY_BATTLE_POWER") + " " + mainHeroInfo.battleeffectsum;
			this.labBattlePower.textRendererProperties.textFormat = textFormat;
			
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.defaultSelectedSkin = this._getImgBtnSel();
				btnTemp.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xEDE7C8 );
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
			}
			
			//为关闭按钮添加监听
			this._btnClose.addEventListener(Event.TRIGGERED, _onBtnClickClose);

			
			this.setChildIndex(btnClose, this.numChildren - 1);
			this.setChildIndex(this.operatLayer, this.getChildIndex(btnClose));

			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			_onAddOperatLayer(BTN_TYPE_ZHANDOULI);
		}
		
		/**
		 * 按钮点击事件响应 - 关闭按钮
		 * @param e
		 * 
		 */		
		private function _onBtnClickClose(e:Event):void{
			//退出背包模块
			SApplication.moduleManager.exitModule("CJStrategyModule");
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
				case this.btnBattle:
					btnType = BTN_TYPE_ZHANDOULI;
					break;
				case this.btnExp:
					btnType = BTN_TYPE_JINGYAN;
					break;
				case this.btnSilver:
					btnType = BTN_TYPE_YINLIANG;
					break;
				case this.btnGold:
					btnType = BTN_TYPE_YUANBAO;
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
				case BTN_TYPE_ZHANDOULI:
					this.operatLayer.removeChild(_layerStrategyBattle, true);
					break;
				case BTN_TYPE_JINGYAN:
					this.operatLayer.removeChild(_layerStrategyExp, true);
					break;
				case BTN_TYPE_YINLIANG:
					this.operatLayer.removeChild(_layerStrategySilver, true);
					break;
				case BTN_TYPE_YUANBAO:
					this.operatLayer.removeChild(_layerStrategyGold, true);
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
				case BTN_TYPE_ZHANDOULI:
					this._onClickZhandouli();
					break;
				case BTN_TYPE_JINGYAN:
					this._onClickJingyan();
					break;
				case BTN_TYPE_YINLIANG:
					this._onClickYinliang();
					break;
				case BTN_TYPE_YUANBAO:
					this._onClickYuanbao();
					break;
			}
		}
		
		/**
		 * 进入战斗力层
		 * 
		 */		
		private function _onClickZhandouli():void
		{
			_layerStrategyBattle = new CJStrategyBattleLayer();
			this._addOperation(_layerStrategyBattle);
		}
		
		
		/**
		 * 进入经验层
		 * 
		 */		
		private function _onClickJingyan():void
		{
			_layerStrategyExp = new CJStrategyExpLayer();
			this._addOperation(_layerStrategyExp);
		}
		
		
		/**
		 * 进入银两层
		 * 
		 */		
		private function _onClickYinliang():void
		{
			_layerStrategySilver = new CJStrategySilverLayer();
			this._addOperation(_layerStrategySilver);
		}
		
		/**
		 * 进入元宝层
		 * 
		 */		
		private function _onClickYuanbao():void
		{
			_layerStrategyGold = new CJStrategyGoldLayer();
			this._addOperation(_layerStrategyGold);
		}
		
		
		/**
		 * 向操作层添加layer
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
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 16, 0xF0F95B );
				}
				else
				{
					// 未选中
					this._btnVec[i].isSelected = false;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xEDE7C8 );
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
			return new SImage(SApplication.assets.getTexture("gonglue_xuanzhonganjian"))
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
		/** 关闭按钮 */
		private var _btnClose:Button;
		/** 操作界面层 */
		private var _operatLayer:SLayer;
		
		
		private var _imgTitleBg:SScale3Plane;
		/** 标题背景图 **/
		public function get imgTitleBg():SScale3Plane
		{
			return _imgTitleBg;
		}
		/** @private **/
		public function set imgTitleBg(value:SScale3Plane):void
		{
			_imgTitleBg = value;
		}
		private var _labRoleName:Label;
		/** 名称 **/
		public function get labRoleName():Label
		{
			return _labRoleName;
		}
		/** @private **/
		public function set labRoleName(value:Label):void
		{
			_labRoleName = value;
		}
		private var _labLevel:Label;
		/** 主角等级 **/
		public function get labLevel():Label
		{
			return _labLevel;
		}
		/** @private **/
		public function set labLevel(value:Label):void
		{
			_labLevel = value;
		}

		private var _btnExp:Button;
		/** 经验按钮 **/
		public function get btnExp():Button
		{
			return _btnExp;
		}
		/** @private **/
		public function set btnExp(value:Button):void
		{
			_btnExp = value;
		}
		private var _labBattlePower:Label;
		/** 总战斗力 **/
		public function get labBattlePower():Label
		{
			return _labBattlePower;
		}
		/** @private **/
		public function set labBattlePower(value:Label):void
		{
			_labBattlePower = value;
		}
		private var _btnBattle:Button;
		/** 战斗力按钮 **/
		public function get btnBattle():Button
		{
			return _btnBattle;
		}
		/** @private **/
		public function set btnBattle(value:Button):void
		{
			_btnBattle = value;
		}
		private var _labVip:Label;
		/** vip等级 **/
		public function get labVip():Label
		{
			return _labVip;
		}
		/** @private **/
		public function set labVip(value:Label):void
		{
			_labVip = value;
		}
		private var _labEnter:Label;
		/** 入口 **/
		public function get labEnter():Label
		{
			return _labEnter;
		}
		/** @private **/
		public function set labEnter(value:Label):void
		{
			_labEnter = value;
		}
		private var _btnSilver:Button;
		/** 银两按钮 **/
		public function get btnSilver():Button
		{
			return _btnSilver;
		}
		/** @private **/
		public function set btnSilver(value:Button):void
		{
			_btnSilver = value;
		}
		private var _btnGold:Button;
		/** 元宝按钮 **/
		public function get btnGold():Button
		{
			return _btnGold;
		}
		/** @private **/
		public function set btnGold(value:Button):void
		{
			_btnGold = value;
		}
		private var _labRoute:Label;
		/** 途径描述 **/
		public function get labRoute():Label
		{
			return _labRoute;
		}
		/** @private **/
		public function set labRoute(value:Label):void
		{
			_labRoute = value;
		}
	
		private var _labStar:Label;
		/** 推荐星级 **/
		public function get labStar():Label
		{
			return _labStar;
		}
		/** @private **/
		public function set labStar(value:Label):void
		{
			_labStar = value;
		}

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