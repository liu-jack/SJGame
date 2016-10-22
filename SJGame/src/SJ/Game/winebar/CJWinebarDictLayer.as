package SJ.Game.winebar
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroDictConfig;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	import feathers.display.TiledImage;
	
	
	/**
	 * 武将宝典
	 * @author longtao
	 * 
	 */
	public class CJWinebarDictLayer extends SLayer
	{
		private var _cardLayer:SLayer
		/**  专门放置武将卡牌的 **/
		public function get cardLayer():SLayer
		{
			return _cardLayer;
		}
		/** @private **/
		public function set cardLayer(value:SLayer):void
		{
			_cardLayer = value;
		}
		private var _btnPrev:Button
		/**  上翻页 **/
		public function get btnPrev():Button
		{
			return _btnPrev;
		}
		/** @private **/
		public function set btnPrev(value:Button):void
		{
			_btnPrev = value;
		}
		private var _btnNextPage:Button
		/**  下翻页 **/
		public function get btnNextPage():Button
		{
			return _btnNextPage;
		}
		/** @private **/
		public function set btnNextPage(value:Button):void
		{
			_btnNextPage = value;
		}
		private var _labelPageNum:Label
		/**  页码 **/
		public function get labelPageNum():Label
		{
			return _labelPageNum;
		}
		/** @private **/
		public function set labelPageNum(value:Label):void
		{
			_labelPageNum = value;
		}
		private var _imgTuBiaoLan:ImageLoader
		/**  标题栏 **/
		public function get imgTuBiaoLan():ImageLoader
		{
			return _imgTuBiaoLan;
		}
		/** @private **/
		public function set imgTuBiaoLan(value:ImageLoader):void
		{
			_imgTuBiaoLan = value;
		}
		private var _labelBiaoTi:Label
		/**  标题 **/
		public function get labelBiaoTi():Label
		{
			return _labelBiaoTi;
		}
		/** @private **/
		public function set labelBiaoTi(value:Label):void
		{
			_labelBiaoTi = value;
		}
		private var _btnClose:Button
		/**  关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		private var _btnJobAll:Button
		/**  全部武将 **/
		public function get btnJobAll():Button
		{
			return _btnJobAll;
		}
		/** @private **/
		public function set btnJobAll(value:Button):void
		{
			_btnJobAll = value;
		}
		private var _btnJob1:Button
		/**  战士 **/
		public function get btnJob1():Button
		{
			return _btnJob1;
		}
		/** @private **/
		public function set btnJob1(value:Button):void
		{
			_btnJob1 = value;
		}
		private var _btnJob2:Button
		/**  军师 **/
		public function get btnJob2():Button
		{
			return _btnJob2;
		}
		/** @private **/
		public function set btnJob2(value:Button):void
		{
			_btnJob2 = value;
		}
		private var _btnJob8:Button
		/**  射手 **/
		public function get btnJob8():Button
		{
			return _btnJob8;
		}
		/** @private **/
		public function set btnJob8(value:Button):void
		{
			_btnJob8 = value;
		}
		private var _btnJob4:Button
		/**  方士 **/
		public function get btnJob4():Button
		{
			return _btnJob4;
		}
		/** @private **/
		public function set btnJob4(value:Button):void
		{
			_btnJob4 = value;
		}
		
		/** 全部职业 **/
		private const CONST_JOB_ALL:String = "CONST_JOB_ALL";

		/** 每页最大武将数量 **/
		private const COSNT_MAX_HERO_COUNT:uint = 8;
		
		/** 卡牌行数 **/
		private const CONST_CARD_LINE_COUNT:uint = 2;
		/** 卡牌列数 **/
		private const CONST_CARD_ROW_COUNT:uint = 4;
		/** 卡牌X轴间隔 **/
		private const CONST_CARD_GAP_X:uint = 5;
		/** 卡牌Y轴间隔 **/
		private const CONST_CARD_GAP_Y:uint = 30;
		/** 卡牌初始X位置 **/
		private const CONST_CARD_X:uint = 88;
		/** 卡牌初始Y位置 **/
		private const CONST_CARD_Y:uint = 45;
		
		// 当前页数
		private var _curPage:uint = 1;
		// 总页数
		private var _totalPage:uint;
		// 当前职业类别
		private var _curJobTag:String = CONST_JOB_ALL;
		// 武将卡牌保存管理
		private var _heroCardArr:Array = new Array;
		// 保存不同职业类型的武将数据
		// {job:Array}
		private var _diffJobHeroObj:Object;
		
		private var _title:CJPanelTitle;
		
		public function CJWinebarDictLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			/// 标题
//			labelBiaoTi.textRendererProperties.textFormat = ConstTextFormat.smallTitleformat;
//			labelBiaoTi.text = CJLang("WINEBAR_DICT_TITEL");
			_title = new CJPanelTitle(CJLang("WINEBAR_DICT_TITEL"));
			addChild(_title);
			_title.x = labelBiaoTi.x;
			_title.y = labelBiaoTi.y;

			// 关闭按钮纹理
			btnClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_quanpingguanbianniu01") );
			btnClose.downSkin = new SImage( SApplication.assets.getTexture("common_quanpingguanbianniu02") );
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJWinebarDictModule");
			});
			
			// 底框
			// 层级
			var tierIndex:int = 0;
			// 底
			var texture:Texture = SApplication.assets.getTexture("common_dinew");
			var scale9Texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			var bg:Scale9Image = new Scale9Image(scale9Texture);
			bg.width = width;
			bg.height = height;
			addChildAt(bg , tierIndex++);
			
			texture = SApplication.assets.getTexture("common_liaotian_wenzidi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(8,8 ,4,4));
			bg = new Scale9Image(scale9Texture);
			bg.width = width;
			bg.height = height;
			bg.alpha = 0.8;
			addChildAt(bg , tierIndex++);
			
			
//			// 标题底纹
			var top:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			top.width = width;
			addChildAt(top , tierIndex++);
			// 边框
			texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(14,13 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.width = this.width;
			bg.height = this.height;
			addChildAt(bg, tierIndex++);
			
			// 专门放置武将卡牌的图层
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = cardLayer.x;
			bg.y = cardLayer.y;
			bg.width = cardLayer.width;
			bg.height = cardLayer.height;
			addChildAt(bg , tierIndex++);
			// 增加一层黑色层，加深颜色
			texture = SApplication.assets.getTexture("common_liaotian_wenzidi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(8,8 ,4,4));
			bg = new Scale9Image(scale9Texture);
			bg.x = cardLayer.x;
			bg.y = cardLayer.y;
			bg.width = cardLayer.width;
			bg.height = cardLayer.height;
			addChildAt(bg , tierIndex++);
			// 外边框
			texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(14,13 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = cardLayer.x;
			bg.y = cardLayer.y;
			bg.width = cardLayer.width;
			bg.height = cardLayer.height;
			addChildAt(bg , tierIndex++);
			
			// 最下端的底框
			var dibuwen:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("jiuguan_dibuwenli") , 34 , 1));
			dibuwen.x = 0;
			dibuwen.y = 290;
			dibuwen.width = SApplicationConfig.o.stageWidth;
//			dibuwen.scaleX = dibuwen.scaleY = 2;
			addChildAt(dibuwen , tierIndex++);
			
			// 左侧按钮
			btnJobAll.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka01") );
			btnJobAll.addEventListener(Event.TRIGGERED, _touchHandler);
			btnJobAll.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnJobAll.label = CJLang("WINEBAR_DICT_ALL");
			btnJob1.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob1.addEventListener(Event.TRIGGERED, _touchHandler);
			btnJob1.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnJob1.label = CJLang("HERO_UI_JOB1");
			btnJob2.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob2.addEventListener(Event.TRIGGERED, _touchHandler);
			btnJob2.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnJob2.label = CJLang("HERO_UI_JOB2");
			btnJob8.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob8.addEventListener(Event.TRIGGERED, _touchHandler);
			btnJob8.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnJob8.label = CJLang("HERO_UI_JOB8");
			btnJob4.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob4.addEventListener(Event.TRIGGERED, _touchHandler);
			btnJob4.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnJob4.label = CJLang("HERO_UI_JOB4");
			
			// 卡牌区域，初始化卡牌
			for(var j:int=0; j<CONST_CARD_LINE_COUNT; ++j)
			{
				for (var i:int=0; i<CONST_CARD_ROW_COUNT; ++i)
				{
					var tItem:CJWinebarDictItem = new CJWinebarDictItem;
					tItem.x = CONST_CARD_X + i*(tItem.width+CONST_CARD_GAP_X);
					tItem.y = CONST_CARD_Y + j*(tItem.width+CONST_CARD_GAP_Y);
					_heroCardArr.push(tItem);
					addChild(tItem);
				}
			}
			
			// 上翻页
			btnPrev.defaultSkin = new SImage( SApplication.assets.getTexture("common_fanyeright01") );
			btnPrev.downSkin = new SImage( SApplication.assets.getTexture("common_fanyeright02") );
			btnPrev.scaleX = -1;
			btnPrev.width = 22;
			btnPrev.height = 22;
			btnPrev.addEventListener(Event.TRIGGERED, function(e:Event):void{
				_pageTurning(false);
			});
			addChild(btnPrev);
			// 下翻页
			btnNextPage.defaultSkin = new SImage( SApplication.assets.getTexture("common_fanyeright01") );
			btnNextPage.downSkin = new SImage( SApplication.assets.getTexture("common_fanyeright02") );
			btnNextPage.width = 22;
			btnNextPage.height = 22;
			btnNextPage.addEventListener(Event.TRIGGERED, function(e:Event):void{
				_pageTurning(true);
			});
			addChild(btnNextPage);
			// 显示页码Label
			labelPageNum.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			labelPageNum.touchable = false;
			
			// 初始化数据
			_initData();
			
			_updateLayer();
		}
		
		/// 初始化数据
		private function _initData():void
		{
			_diffJobHeroObj = new Object;
			
			// 初始化各职业
			_diffJobHeroObj[CONST_JOB_ALL] = new Array;
			_diffJobHeroObj[String(ConstHero.constHeroJobFighter)] = new Array;
			_diffJobHeroObj[String(ConstHero.constHeroJobWizard)] = new Array;
			_diffJobHeroObj[String(ConstHero.constHeroJobPastor)] = new Array;
			_diffJobHeroObj[String(ConstHero.constHeroJobArcher)] = new Array;
			
			// 所有的武将模板信息
			var heroArr:Array = CJDataOfHeroDictConfig.o.getData();
			for (var i:int=0; i<heroArr.length; ++i)
			{
				var heroInfo:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(heroArr[i]);
				if (heroInfo == null)
					continue;
				// 需要保存的数据
				var data:Object = new Object;
				data.id = heroInfo.id; // 模板id
				data.card = heroInfo.card; // 卡牌形象
				data.name = heroInfo.name; // 武将名称
				// 查找技能信息
				var skillObj:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(heroInfo.skill1) as Json_skill_setting;
				if (skillObj!=null)
					data.skillname = skillObj.skillname; // 技能名称
				else
					data.skillname = "";
				
				data.job = heroInfo.job; // 职业id
				// 不同职业的武将
				var curJobObj:Array = _diffJobHeroObj[String(data.job)] as Array;
				if (curJobObj)
					curJobObj.push(data);
				// 所有的武将
				var allJobObj:Array = _diffJobHeroObj[CONST_JOB_ALL] as Array;
				if (allJobObj)
					allJobObj.push(data);
			}
		}
		
		// 翻页
		private function _pageTurning(isNext:Boolean):void
		{
			if (isNext)
				_curPage++;
			else
				_curPage--;
			
			// 更新
			_updateLayer();
		}
		
		// 触摸职业标签
		private function _touchHandler(e:Event):void
		{
			/// 将所有按钮设置为未选中
			btnJobAll.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob1.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob2.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob8.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			btnJob4.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			
			// 当前选中的按钮
			var curBtn:Button = e.target as Button;
			curBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka01"));
			
			// 当前选择的职业标签
			_curJobTag = curBtn.name;
			// 重新定位到第一页
			_curPage = 1;
			// 更新界面
			_updateLayer();
		}
		
		
		/// 更新界面
		private function _updateLayer():void
		{
			// 当前标签
			// {index:{id:xxx, card:xxx, name:xxx, skillname:xxx, job:xxx}}
			var curJobArr:Array = _diffJobHeroObj[_curJobTag];
			// 总页数
			if (curJobArr.length % COSNT_MAX_HERO_COUNT == 0)
				_totalPage = curJobArr.length/COSNT_MAX_HERO_COUNT;
			else
				_totalPage = curJobArr.length/COSNT_MAX_HERO_COUNT + 1;
			// 判断当前页数是否正确
			if (_curPage < 1)
				_curPage = 1;
			else if (_curPage > _totalPage)
				_curPage = _totalPage;
			
			// 当前页数
			var tIndex:int = 0;
			var i:int=(_curPage-1)*COSNT_MAX_HERO_COUNT;
			var limitValue:int = _curPage * COSNT_MAX_HERO_COUNT;
			for (; i<limitValue; ++i)
			{
				var temp:CJWinebarDictItem = _heroCardArr[tIndex];
				if (null == temp)
					break;
				temp.data = curJobArr[i];
				++tIndex;
			}
			
			labelPageNum.text = _curPage+"/"+_totalPage;
		}

		

	}
}