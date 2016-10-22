package SJ.Game.moneytree
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfMoneyTreeMine;
	import SJ.Game.data.config.CJDataOfMoneyTreeProperty;
	import SJ.Game.data.json.Json_money_tree_setting;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.textures.Texture;
	
	/**
	 * 摇钱树 - 成长
	 * @author sangxu
	 * 
	 */	
	public class CJMoneyTreeChengZhangOperate extends SLayer
	{
		public function CJMoneyTreeChengZhangOperate()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 摇钱树配置数据 */
		private var _moneyTreeConfig:CJDataOfMoneyTreeProperty;
		/** 数据 - 我的摇钱树 */
		private var _dataMTMine:CJDataOfMoneyTreeMine;
		/** 数据 - 武将 */
		private var _dataHeroList:CJDataOfHeroList;
		
		/** 是否为我的摇钱树 */
		private var _isMyTree:Boolean = true;
		/** 是否可收获 */
		private var _canHarvest:Boolean;
		
		private var _tpContant:CJTurnPage;
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			this._moneyTreeConfig = CJDataOfMoneyTreeProperty.o;
			this._dataMTMine = CJDataManager.o.getData("CJDataOfMoneyTreeMine") as CJDataOfMoneyTreeMine;
			this._dataHeroList = CJDataManager.o.getData("CJDataOfHeroList") as CJDataOfHeroList;
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			var texture:Texture;
			
//			// 标题框背景
//			var imgTitleBg:SImage = new SImage(SApplication.assets.getTexture("common_tankuangdi"));
//			imgTitleBg.x = 2;
//			imgTitleBg.y = 1;
//			imgTitleBg.width = 410;
//			imgTitleBg.height = 212;
//			this.addChild(imgTitleBg);
			
			// 边框
			var imgBiankuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_tankuangwenzidi");
			var bkScaleRange:Rectangle = new Rectangle(11, 11, 1, 1);
			var bkTexture:Scale9Textures = new Scale9Textures(texture, bkScaleRange);
			imgBiankuang = new Scale9Image(bkTexture);
			imgBiankuang.x = 4;
			imgBiankuang.y = 23;
			imgBiankuang.width = 401;
			imgBiankuang.height = 185;
			this.addChild(imgBiankuang);
			
			var fontFormatBigTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFF960, null, null, null, null, null, TextFormatAlign.CENTER);
			// 文字 - 标题
			var labTitle:Label = new Label();
			labTitle.textRendererFactory = textRender.standardTextRender;
			labTitle.textRendererProperties.textFormat = fontFormatBigTitle;
			labTitle.text = CJLang("MONEYTREE_TITLE_JILU");
			labTitle.x = 161;
			labTitle.y = 5;
			labTitle.width = 90;
			labTitle.height = 16;
			this.addChild(labTitle);
			
			var fontFormatLevel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x73FF42, null, null, null, null, null, TextFormatAlign.CENTER);
			var fontFormatTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFF7E00, null, null, null, null, null, TextFormatAlign.LEFT);
			var fontFormatCont:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xE8FF99, null, null, null, null, null, TextFormatAlign.LEFT);
			var fontFormatVip:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x5DFDFF, null, null, null, null, null, TextFormatAlign.LEFT);
			var fontFormatToVip:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x73FF42, null, null, true, null, null, TextFormatAlign.LEFT);
			
			
			
			var mtCfg:Json_money_tree_setting = _moneyTreeConfig.getConfig(this._dataMTMine.treeLevel);
			
			
			_tpContant = new CJTurnPage(4);
			_tpContant.x = 9;
			_tpContant.y = 28;
			_tpContant.setRect(390, 172);
			_tpContant.type = CJTurnPage.SCROLL_V;
			
			// item渲染属性
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = 1; // item间隙
			
			var listData:Array = _getDataArr();
			var groceryList:ListCollection = new ListCollection(listData);
			
			_tpContant.layout = listLayout; // 设置渲染属性
			_tpContant.dataProvider = groceryList;// 设置成长信息数据
			_tpContant.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJMoneyTreeChengZhangItem = new CJMoneyTreeChengZhangItem();
				render.owner = _tpContant;
				return render;
			}; // 设置Item工厂函数指针
			addChild(_tpContant); // 
			
			return;
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			
		}
		
		
		/**
		 * 获取列表数据
		 * @return 
		 * 
		 */		
		private function _getDataArr():Array
		{
			var history:String = this._dataMTMine.history;
			
			var arr:Array = new Array();
			var elementArray:Array = new Array();
			var jsonObj:Array = JSON.parse(history) as Array;
			
			
			var length:int = jsonObj.length;
			for(var i:int=0; i < length; i++)
			{
//				if (jsonObj[i].feedtype == 1)
//				{
//					arr.push(jsonObj[i]);
//				}
				// 屏蔽自己的施肥信息
				if (String(jsonObj[i].srcuid) != String(_dataHeroList.getRoleId()))
				{
					arr.push(jsonObj[i]);
				}
			}
			
			return arr;
		}
		
	}
}