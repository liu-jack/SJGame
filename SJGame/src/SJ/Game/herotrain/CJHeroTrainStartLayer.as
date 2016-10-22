package SJ.Game.herotrain
{
	import SJ.Common.Constants.ConstHeroTrain;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_heroTrain;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.config.CJDataOfHeroTrainProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_hero_train_setting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.layer.CJMsgBoxSilverNotEnough;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 武将训练开始界面
	 * @author longtao
	 * 
	 */
	public class CJHeroTrainStartLayer extends SLayer
	{
		private var _labelTitle:Label
		/**  标题 **/
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private **/
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
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
		private var _layerBG:SLayer
		/**  背景 **/
		public function get layerBG():SLayer
		{
			return _layerBG;
		}
		/** @private **/
		public function set layerBG(value:SLayer):void
		{
			_layerBG = value;
		}
		private var _shadeBG:ImageLoader
		/**  底纹 **/
		public function get shadeBG():ImageLoader
		{
			return _shadeBG;
		}
		/** @private **/
		public function set shadeBG(value:ImageLoader):void
		{
			_shadeBG = value;
		}
		private var _panelBG:SLayer
		/**  面板底框 **/
		public function get panelBG():SLayer
		{
			return _panelBG;
		}
		/** @private **/
		public function set panelBG(value:SLayer):void
		{
			_panelBG = value;
		}
		private var _insideBG:SLayer
		/**  内框 **/
		public function get insideBG():SLayer
		{
			return _insideBG;
		}
		/** @private **/
		public function set insideBG(value:SLayer):void
		{
			_insideBG = value;
		}
		private var _blackBG:ImageLoader
		/**  黑色透明底 **/
		public function get blackBG():ImageLoader
		{
			return _blackBG;
		}
		/** @private **/
		public function set blackBG(value:ImageLoader):void
		{
			_blackBG = value;
		}
		private var _tagBG:ImageLoader
		/**  标签底图 **/
		public function get tagBG():ImageLoader
		{
			return _tagBG;
		}
		/** @private **/
		public function set tagBG(value:ImageLoader):void
		{
			_tagBG = value;
		}
		private var _heroname:Label
		/**  武将名称 **/
		public function get heroname():Label
		{
			return _heroname;
		}
		/** @private **/
		public function set heroname(value:Label):void
		{
			_heroname = value;
		}
		private var _herolevel:Label
		/**  等级 **/
		public function get herolevel():Label
		{
			return _herolevel;
		}
		/** @private **/
		public function set herolevel(value:Label):void
		{
			_herolevel = value;
		}
		private var _cooltime:Label
		/**  冷却时间 **/
		public function get cooltime():Label
		{
			return _cooltime;
		}
		/** @private **/
		public function set cooltime(value:Label):void
		{
			_cooltime = value;
		}
		private var _state:Label
		/**  状态 **/
		public function get state():Label
		{
			return _state;
		}
		/** @private **/
		public function set state(value:Label):void
		{
			_state = value;
		}
		private var _pickLayer:SLayer
		/**  训练选择 **/
		public function get pickLayer():SLayer
		{
			return _pickLayer;
		}
		/** @private **/
		public function set pickLayer(value:SLayer):void
		{
			_pickLayer = value;
		}
		private var _btnAllPick:Button
		/**  全选 **/
		public function get btnAllPick():Button
		{
			return _btnAllPick;
		}
		/** @private **/
		public function set btnAllPick(value:Button):void
		{
			_btnAllPick = value;
		}
		private var _btnTrainCommon:Button
		/**  普通训练 **/
		public function get btnTrainCommon():Button
		{
			return _btnTrainCommon;
		}
		/** @private **/
		public function set btnTrainCommon(value:Button):void
		{
			_btnTrainCommon = value;
		}
		private var _btnTrainDouble:Button
		/**  二倍训练 **/
		public function get btnTrainDouble():Button
		{
			return _btnTrainDouble;
		}
		/** @private **/
		public function set btnTrainDouble(value:Button):void
		{
			_btnTrainDouble = value;
		}
		private var _btnTrainQuintuple:Button
		/**  五倍训练 **/
		public function get btnTrainQuintuple():Button
		{
			return _btnTrainQuintuple;
		}
		/** @private **/
		public function set btnTrainQuintuple(value:Button):void
		{
			_btnTrainQuintuple = value;
		}
		private var _btnCleanCDAll:Button
		/**  全部完成 **/
		public function get btnCleanCDAll():Button
		{
			return _btnCleanCDAll;
		}
		/** @private **/
		public function set btnCleanCDAll(value:Button):void
		{
			_btnCleanCDAll = value;
		}
		private var _trainLayer:SLayer
		/**  训练开始 **/
		public function get trainLayer():SLayer
		{
			return _trainLayer;
		}
		/** @private **/
		public function set trainLayer(value:SLayer):void
		{
			_trainLayer = value;
		}
		private var _totalCost:Label
		/**  总计花费 **/
		public function get totalCost():Label
		{
			return _totalCost;
		}
		/** @private **/
		public function set totalCost(value:Label):void
		{
			_totalCost = value;
		}
		private var _imgMoney:ImageLoader
		/**  货币图片 **/
		public function get imgMoney():ImageLoader
		{
			return _imgMoney;
		}
		/** @private **/
		public function set imgMoney(value:ImageLoader):void
		{
			_imgMoney = value;
		}
		private var _cost:Label
		/**  花费 **/
		public function get cost():Label
		{
			return _cost;
		}
		/** @private **/
		public function set cost(value:Label):void
		{
			_cost = value;
		}
		private var _btnStartTrain:Button
		/**  开始训练 **/
		public function get btnStartTrain():Button
		{
			return _btnStartTrain;
		}
		/** @private **/
		public function set btnStartTrain(value:Button):void
		{
			_btnStartTrain = value;
		}
		
		
		
		
		/** 标题框 **/
		private var _title:CJPanelTitle;
		/** 训练类型 **/
		private var _trainType:uint;
		/** 要训练的武将 **/
		private var _herolist:Array;
		/** 武将id列表 **/
		private var _heroidlist:Array;
		
		private var _startPanel:CJHeroTrainStartPanel;
		
		public function CJHeroTrainStartLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 设置宽高
			this.width = ConstMainUI.MAPUNIT_WIDTH;
			this.height = ConstMainUI.MAPUNIT_HEIGHT;
			
			// 层级
			var tierIndex:int = 0;
			var texture:Texture;
			var scale9Texture:Scale9Textures;
			var bg:Scale9Image;
//			// 底
//			texture = SApplication.assets.getTexture("common_dinew");
//			scale9Texture = new Scale9Textures(texture, new Rectangle(15,15 ,3,3));
//			bg = new Scale9Image(scale9Texture);
//			bg.x = 0;
//			bg.y = 0;
//			bg.width = ConstMainUI.MAPUNIT_WIDTH;
//			bg.height = ConstMainUI.MAPUNIT_HEIGHT;
//			bg.alpha = 0.2;
//			addChildAt(bg , tierIndex++);
			
			// 面板框
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = layerBG.y;
			bg.width = layerBG.width;
			bg.height = layerBG.height;
			addChildAt(bg , tierIndex++);
			// 底纹罩
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = layerBG.y;
			bg.width = layerBG.width;
			bg.height = layerBG.height;
			addChildAt(bg , tierIndex++);
			
			// 底纹罩
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = insideBG.y;
			bg.width = layerBG.width;
			bg.height = insideBG.height;
			addChildAt(bg , tierIndex++);
			
			// 花边
			var frame:CJPanelFrame = new CJPanelFrame(layerBG.width-6, layerBG.height-6);
			frame.x = layerBG.x + 3;
			frame.y = layerBG.y + 3;
			frame.touchable = false;
			addChildAt(frame , tierIndex++);
			
			// 外框
			texture = SApplication.assets.getTexture("common_waikuangnew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(15 , 15 , 1, 1));
			bg = new Scale9Image(scale9Texture);
			bg.x = layerBG.x;
			bg.y = layerBG.y;
			bg.width = layerBG.width;
			bg.height = layerBG.height;
			addChildAt(bg , tierIndex++);
			
//			// 内框
//			texture = SApplication.assets.getTexture("common_dinew");
//			scale9Texture = new Scale9Textures(texture, new Rectangle(40,40 ,8,8));
//			bg = new Scale9Image(scale9Texture);
//			bg.x = insideBG.x;
//			bg.y = insideBG.y;
//			bg.width = insideBG.width;
//			bg.height = insideBG.height;
//			addChildAt(bg , tierIndex++);
			
//			// 底纹
//			shadeBG.alpha = 0.15;
////			shadeBG.visible = false;
////			// 内框
//			blackBG.source = Texture.fromColor(blackBG.width, blackBG.height, 0x64000000);
////			blackBG.visible = false;
			
			// 标题框
			_title = new CJPanelTitle(CJLang("HERO_TRAIN_TITLE"));
			addChild(_title);
			_title.x = labelTitle.x;
			_title.y = labelTitle.y;
			
			// 关闭按钮纹理
			btnClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new") );
			btnClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new") );
			btnClose.addEventListener(Event.TRIGGERED, _onClose);
			
			// 初始化表头
			// 武将名称
			heroname.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			heroname.text = CJLang("HERO_TRAIN_NAME");
			// 等级
			herolevel.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			herolevel.text = CJLang("HERO_TRAIN_LEVEL");
			// 冷却时间
			cooltime.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			cooltime.text = CJLang("HERO_TRAIN_CD");
			// 获得经验
			state.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			state.text = CJLang("HERO_TRAIN_EXP");
			
			// 不显示训练图层
			pickLayer.visible = false;
			
			// 总计花费
			totalCost.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			totalCost.text = CJLang("HERO_TRAIN_COST");
			
			// 花费数值
			cost.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			
			// 开始训练
			btnStartTrain.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			btnStartTrain.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			btnStartTrain.addEventListener(Event.TRIGGERED, _startTrain);
			btnStartTrain.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnStartTrain.label = CJLang("HERO_TRAIN_SUBTITLE");
			
//			// 翻页面板
//			_startPanel = new CJHeroTrainStartPanel(insideBG.width, insideBG.height);
//			_startPanel.x = insideBG.x + 2;
//			_startPanel.y = insideBG.y + 22;
//			addChild(_startPanel);
		}
		
		/**
		 * 显示画布 更新画布
		 * @param trainType	训练类型
		 * @param herolist	武将列表
		 * 
		 */
		public function ShowLayer(trainType:int, herolist:Array):void
		{
			Assert(herolist != null , "CJHeroTrainStartLayer.ShowLayer herolist==null");
			
			// 赋值
			_trainType = trainType;
			_herolist = herolist;
			// 设置为显示
			this.visible = true;
			// 翻页面板
			if (_startPanel != null)
				_startPanel.removeFromParent();
			_startPanel = new CJHeroTrainStartPanel(insideBG.width, insideBG.height);
			_startPanel.x = insideBG.x + 2;
			_startPanel.y = insideBG.y + 22;
			addChild(_startPanel);
			// 更换 货币图片
			if (trainType == ConstHeroTrain.HERO_TRAIN_TYPE_COMMON)
				imgMoney.source = SApplication.assets.getTexture("common_yinliang");
			else
				imgMoney.source = SApplication.assets.getTexture("common_yuanbao");
			
			// 武将id
			_heroidlist = new Array;
			// 玩家武将列表信息
			var obj:Object;
			// 累加值 
			var costValue:int = 0;
			for(var i:int=0; i<herolist.length; ++i)
			{
				obj = herolist[i];
				obj.traintype = trainType;
				// 武将信息
				var js:Json_hero_train_setting = CJDataOfHeroTrainProperty.o.getData(String(obj.level));
				Assert(js!=null, "CJHeroTrainStartLayer.ShowLayer js==null");
				if (trainType == ConstHeroTrain.HERO_TRAIN_TYPE_COMMON) // 普通训练
					costValue += int(js.silver);
				else if (trainType == ConstHeroTrain.HERO_TRAIN_TYPE_2) // 双倍训练
					costValue += int(js.gold2);
				else // 五倍训练
					costValue += int(js.gold5);
				
				// 压入
				_heroidlist.push(obj.heroid);
			}
			// 计算花费
			cost.text = costValue.toString();
			// 更改数据
			_startPanel.data = herolist;
		}
		
		// 关闭
		private function _onClose(e:Event):void
		{
			this.visible = false;
			if (_startPanel != null)
				_startPanel.removeFromParent();
		}
		
		// 开始训练
		private function _startTrain(e:Event):void
		{
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			var bHaveMainHero:Boolean = false;
			// 判断主角训练次数
			var mainHeroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getMainHero();
			// 判断是否有主角进行训练
			for ( var i:int=0; i<_heroidlist.length; i++ )
			{
				if (_heroidlist[i] == mainHeroInfo.heroid)
				{
					bHaveMainHero = true;
					break;
				}
			}
			
			// 判断是否需要检测主将训练次数
			if (bHaveMainHero)
			{
//				var maxTrainCount:int = int(CJDataOfGlobalConfigProperty.o.getData("MAX_TRAIN_COUNT"));
				var viplevel:int = CJDataManager.o.DataOfRole.vipLevel;
				var vipFuncJs:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(viplevel));
				var maxTrainCount:int = int(vipFuncJs.hero_traincount);
				var traincount:int = CJDataManager.o.DataOfHeroTrain.trainCount;
				if ( traincount >= maxTrainCount )
				{
					new CJTaskFlowString(CJLang("HERO_TRAIN_COUNT_MAX"), 3, 20).addToLayer();
					return;
				}
			}
			
			
			// 花销
			var tCost:int = int(cost.text);
			var curMoney:uint = 0;
			// 判断自身的货币是否足够
			if (_trainType == ConstHeroTrain.HERO_TRAIN_TYPE_COMMON)
			{
				// 判断银币
				curMoney = CJDataManager.o.DataOfRole.silver;
				if (curMoney < tCost)
				{
//					CJMessageBox(CJLang("HERO_TRAIN_SILVER"));
					// 银两不足提示框 modify by sangxu 2013-09-04
					CJMsgBoxSilverNotEnough(CJLang("HERO_TRAIN_SILVER"), 
											"", 
											function():void{
												SApplication.moduleManager.exitModule("CJHeroTrainModule");
											});
					return;
				}
			}
			else
			{
				// 判断元宝
				curMoney = CJDataManager.o.DataOfRole.gold;
				if (curMoney < tCost)
				{
					CJMessageBox(CJLang("HERO_TRAIN_GOLD"));
					return;
				}
			}
			
			// 训练中的是否有主将
			if (bHaveMainHero)
			{
				var str:String = String(traincount+1) + "/" + maxTrainCount;
				new CJTaskFlowString(CJLang("HERO_TRAIN_COUNT", {"count":str}), 3, 20).addToLayer();
			}
				
			
			SocketCommand_heroTrain.start_train(_trainType, _heroidlist);
			this.visible = false;
			_heroidlist = null;
		}
	}
}