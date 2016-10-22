package SJ.Game.StageLevel
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstStageLevel;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfStageLevel;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfStageLevelProperty;
	import SJ.Game.data.json.Json_role_stage_force_star;
	import SJ.Game.data.json.Json_role_stage_level;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class CJStageLevelLayer extends SLayer
	{
		private var _labelTitle:Label;
		/**  标题框 **/
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private **/
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
		}
		private var _btnClose:Button;
		/**  关闭界面 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		private var _stageBG:SLayer;
		/**  升阶面板 **/
		public function get stageBG():SLayer
		{
			return _stageBG;
		}
		/** @private **/
		public function set stageBG(value:SLayer):void
		{
			_stageBG = value;
		}
		private var _forcesoulBG:SLayer;
		/**  武魂面板 **/
		public function get forcesoulBG():SLayer
		{
			return _forcesoulBG;
		}
		/** @private **/
		public function set forcesoulBG(value:SLayer):void
		{
			_forcesoulBG = value;
		}
		private var _galaxy:ImageLoader;
		/**  星系 **/
		public function get galaxy():ImageLoader
		{
			return _galaxy;
		}
		/** @private **/
		public function set galaxy(value:ImageLoader):void
		{
			_galaxy = value;
		}
		private var _labelForceSoul:Label;
		/**  武魂 **/
		public function get labelForceSoul():Label
		{
			return _labelForceSoul;
		}
		/** @private **/
		public function set labelForceSoul(value:Label):void
		{
			_labelForceSoul = value;
		}
		private var _labelForceSoulValue:Label;
		/**  武魂 **/
		public function get labelForceSoulValue():Label
		{
			return _labelForceSoulValue;
		}
		/** @private **/
		public function set labelForceSoulValue(value:Label):void
		{
			_labelForceSoulValue = value;
		}
		private var _imgLion:ImageLoader;
		/**  武魂龙头底图 **/
		public function get imgLion():ImageLoader
		{
			return _imgLion;
		}
		/** @private **/
		public function set imgLion(value:ImageLoader):void
		{
			_imgLion = value;
		}
		private var _fsDetails:SLayer;
		/**  左侧相信信息 **/
		public function get fsDetails():SLayer
		{
			return _fsDetails;
		}
		/** @private **/
		public function set fsDetails(value:SLayer):void
		{
			_fsDetails = value;
		}
		private var _forceSoulTitle:Label;
		/**  小标题头 **/
		public function get forceSoulTitle():Label
		{
			return _forceSoulTitle;
		}
		/** @private **/
		public function set forceSoulTitle(value:Label):void
		{
			_forceSoulTitle = value;
		}
		private var _forceStarDesc:Label;
		/**  描述 **/
		public function get forceStarDesc():Label
		{
			return _forceStarDesc;
		}
		/** @private **/
		public function set forceStarDesc(value:Label):void
		{
			_forceStarDesc = value;
		}
		private var _forceSoulLevel:Label;
		/**  主角等级 **/
		public function get forceSoulLevel():Label
		{
			return _forceSoulLevel;
		}
		/** @private **/
		public function set forceSoulLevel(value:Label):void
		{
			_forceSoulLevel = value;
		}
		private var _forceSoulConsume:Label;
		/**  消耗武魂 **/
		public function get forceSoulConsume():Label
		{
			return _forceSoulConsume;
		}
		/** @private **/
		public function set forceSoulConsume(value:Label):void
		{
			_forceSoulConsume = value;
		}
		private var _stageLevelBG:SLayer;
		/**  滑动块layer **/
		public function get stageLevelBG():SLayer
		{
			return _stageLevelBG;
		}
		/** @private **/
		public function set stageLevelBG(value:SLayer):void
		{
			_stageLevelBG = value;
		}
		private var _explainBG:SLayer;
		/**  说明底框 **/
		public function get explainBG():SLayer
		{
			return _explainBG;
		}
		/** @private **/
		public function set explainBG(value:SLayer):void
		{
			_explainBG = value;
		}
		private var _labelExplain:Label;
		/**  武星说明 **/
		public function get labelExplain():Label
		{
			return _labelExplain;
		}
		/** @private **/
		public function set labelExplain(value:Label):void
		{
			_labelExplain = value;
		}
		private var _star_1_1:Label;
		/**  青龙1星 **/
		public function get star_1_1():Label
		{
			return _star_1_1;
		}
		/** @private **/
		public function set star_1_1(value:Label):void
		{
			_star_1_1 = value;
		}
		private var _star_1_2:Label;
		/**  青龙2星 **/
		public function get star_1_2():Label
		{
			return _star_1_2;
		}
		/** @private **/
		public function set star_1_2(value:Label):void
		{
			_star_1_2 = value;
		}
		private var _star_1_3:Label;
		/**  青龙3星 **/
		public function get star_1_3():Label
		{
			return _star_1_3;
		}
		/** @private **/
		public function set star_1_3(value:Label):void
		{
			_star_1_3 = value;
		}
		private var _star_1_4:Label;
		/**  青龙4星 **/
		public function get star_1_4():Label
		{
			return _star_1_4;
		}
		/** @private **/
		public function set star_1_4(value:Label):void
		{
			_star_1_4 = value;
		}
		private var _star_1_5:Label;
		/**  青龙5星 **/
		public function get star_1_5():Label
		{
			return _star_1_5;
		}
		/** @private **/
		public function set star_1_5(value:Label):void
		{
			_star_1_5 = value;
		}
		private var _star_1_6:Label;
		/**  青龙6星 **/
		public function get star_1_6():Label
		{
			return _star_1_6;
		}
		/** @private **/
		public function set star_1_6(value:Label):void
		{
			_star_1_6 = value;
		}
		private var _star_1_7:Label;
		/**  青龙7星 **/
		public function get star_1_7():Label
		{
			return _star_1_7;
		}
		/** @private **/
		public function set star_1_7(value:Label):void
		{
			_star_1_7 = value;
		}
		private var _star_1_8:Label;
		/**  青龙8星 **/
		public function get star_1_8():Label
		{
			return _star_1_8;
		}
		/** @private **/
		public function set star_1_8(value:Label):void
		{
			_star_1_8 = value;
		}
		private var _star_1_9:Label;
		/**  青龙9星 **/
		public function get star_1_9():Label
		{
			return _star_1_9;
		}
		/** @private **/
		public function set star_1_9(value:Label):void
		{
			_star_1_9 = value;
		}
		private var _star_1_10:Label;
		/**  青龙10星 **/
		public function get star_1_10():Label
		{
			return _star_1_10;
		}
		/** @private **/
		public function set star_1_10(value:Label):void
		{
			_star_1_10 = value;
		}
		private var _star_2_1:Label;
		/**  白虎1星 **/
		public function get star_2_1():Label
		{
			return _star_2_1;
		}
		/** @private **/
		public function set star_2_1(value:Label):void
		{
			_star_2_1 = value;
		}
		private var _star_2_2:Label;
		/**  白虎2星 **/
		public function get star_2_2():Label
		{
			return _star_2_2;
		}
		/** @private **/
		public function set star_2_2(value:Label):void
		{
			_star_2_2 = value;
		}
		private var _star_2_3:Label;
		/**  白虎3星 **/
		public function get star_2_3():Label
		{
			return _star_2_3;
		}
		/** @private **/
		public function set star_2_3(value:Label):void
		{
			_star_2_3 = value;
		}
		private var _star_2_4:Label;
		/**  白虎4星 **/
		public function get star_2_4():Label
		{
			return _star_2_4;
		}
		/** @private **/
		public function set star_2_4(value:Label):void
		{
			_star_2_4 = value;
		}
		private var _star_2_5:Label;
		/**  白虎5星 **/
		public function get star_2_5():Label
		{
			return _star_2_5;
		}
		/** @private **/
		public function set star_2_5(value:Label):void
		{
			_star_2_5 = value;
		}
		private var _star_2_6:Label;
		/**  白虎6星 **/
		public function get star_2_6():Label
		{
			return _star_2_6;
		}
		/** @private **/
		public function set star_2_6(value:Label):void
		{
			_star_2_6 = value;
		}
		private var _star_2_7:Label;
		/**  白虎7星 **/
		public function get star_2_7():Label
		{
			return _star_2_7;
		}
		/** @private **/
		public function set star_2_7(value:Label):void
		{
			_star_2_7 = value;
		}
		private var _star_2_8:Label;
		/**  白虎8星 **/
		public function get star_2_8():Label
		{
			return _star_2_8;
		}
		/** @private **/
		public function set star_2_8(value:Label):void
		{
			_star_2_8 = value;
		}
		private var _star_2_9:Label;
		/**  白虎9星 **/
		public function get star_2_9():Label
		{
			return _star_2_9;
		}
		/** @private **/
		public function set star_2_9(value:Label):void
		{
			_star_2_9 = value;
		}
		private var _star_2_10:Label;
		/**  白虎10星 **/
		public function get star_2_10():Label
		{
			return _star_2_10;
		}
		/** @private **/
		public function set star_2_10(value:Label):void
		{
			_star_2_10 = value;
		}
		private var _star_3_1:Label;
		/**  朱雀1星 **/
		public function get star_3_1():Label
		{
			return _star_3_1;
		}
		/** @private **/
		public function set star_3_1(value:Label):void
		{
			_star_3_1 = value;
		}
		private var _star_3_2:Label;
		/**  朱雀2星 **/
		public function get star_3_2():Label
		{
			return _star_3_2;
		}
		/** @private **/
		public function set star_3_2(value:Label):void
		{
			_star_3_2 = value;
		}
		private var _star_3_3:Label;
		/**  朱雀3星 **/
		public function get star_3_3():Label
		{
			return _star_3_3;
		}
		/** @private **/
		public function set star_3_3(value:Label):void
		{
			_star_3_3 = value;
		}
		private var _star_3_4:Label;
		/**  朱雀4星 **/
		public function get star_3_4():Label
		{
			return _star_3_4;
		}
		/** @private **/
		public function set star_3_4(value:Label):void
		{
			_star_3_4 = value;
		}
		private var _star_3_5:Label;
		/**  朱雀5星 **/
		public function get star_3_5():Label
		{
			return _star_3_5;
		}
		/** @private **/
		public function set star_3_5(value:Label):void
		{
			_star_3_5 = value;
		}
		private var _star_3_6:Label;
		/**  朱雀6星 **/
		public function get star_3_6():Label
		{
			return _star_3_6;
		}
		/** @private **/
		public function set star_3_6(value:Label):void
		{
			_star_3_6 = value;
		}
		private var _star_3_7:Label;
		/**  朱雀7星 **/
		public function get star_3_7():Label
		{
			return _star_3_7;
		}
		/** @private **/
		public function set star_3_7(value:Label):void
		{
			_star_3_7 = value;
		}
		private var _star_3_8:Label;
		/**  朱雀8星 **/
		public function get star_3_8():Label
		{
			return _star_3_8;
		}
		/** @private **/
		public function set star_3_8(value:Label):void
		{
			_star_3_8 = value;
		}
		private var _star_3_9:Label;
		/**  朱雀9星 **/
		public function get star_3_9():Label
		{
			return _star_3_9;
		}
		/** @private **/
		public function set star_3_9(value:Label):void
		{
			_star_3_9 = value;
		}
		private var _star_3_10:Label;
		/**  朱雀10星 **/
		public function get star_3_10():Label
		{
			return _star_3_10;
		}
		/** @private **/
		public function set star_3_10(value:Label):void
		{
			_star_3_10 = value;
		}
		private var _star_4_1:Label;
		/**  玄武1星 **/
		public function get star_4_1():Label
		{
			return _star_4_1;
		}
		/** @private **/
		public function set star_4_1(value:Label):void
		{
			_star_4_1 = value;
		}
		private var _star_4_2:Label;
		/**  玄武2星 **/
		public function get star_4_2():Label
		{
			return _star_4_2;
		}
		/** @private **/
		public function set star_4_2(value:Label):void
		{
			_star_4_2 = value;
		}
		private var _star_4_3:Label;
		/**  玄武3星 **/
		public function get star_4_3():Label
		{
			return _star_4_3;
		}
		/** @private **/
		public function set star_4_3(value:Label):void
		{
			_star_4_3 = value;
		}
		private var _star_4_4:Label;
		/**  玄武4星 **/
		public function get star_4_4():Label
		{
			return _star_4_4;
		}
		/** @private **/
		public function set star_4_4(value:Label):void
		{
			_star_4_4 = value;
		}
		private var _star_4_5:Label;
		/**  玄武5星 **/
		public function get star_4_5():Label
		{
			return _star_4_5;
		}
		/** @private **/
		public function set star_4_5(value:Label):void
		{
			_star_4_5 = value;
		}
		private var _star_4_6:Label;
		/**  玄武6星 **/
		public function get star_4_6():Label
		{
			return _star_4_6;
		}
		/** @private **/
		public function set star_4_6(value:Label):void
		{
			_star_4_6 = value;
		}
		private var _star_4_7:Label;
		/**  玄武7星 **/
		public function get star_4_7():Label
		{
			return _star_4_7;
		}
		/** @private **/
		public function set star_4_7(value:Label):void
		{
			_star_4_7 = value;
		}
		private var _star_4_8:Label;
		/**  玄武8星 **/
		public function get star_4_8():Label
		{
			return _star_4_8;
		}
		/** @private **/
		public function set star_4_8(value:Label):void
		{
			_star_4_8 = value;
		}
		private var _star_4_9:Label;
		/**  玄武9星 **/
		public function get star_4_9():Label
		{
			return _star_4_9;
		}
		/** @private **/
		public function set star_4_9(value:Label):void
		{
			_star_4_9 = value;
		}
		private var _star_4_10:Label;
		/**  玄武10星 **/
		public function get star_4_10():Label
		{
			return _star_4_10;
		}
		/** @private **/
		public function set star_4_10(value:Label):void
		{
			_star_4_10 = value;
		}






		
		
		
		/** 星象面板 **/
		private var _stageLevelPanel:CJStageLevelPanel;
		/** 狮头动画 **/
		private var _lionAnim:SAnimate;
		/** 标题 **/
		private var _title:CJPanelTitle;
		
		public function CJStageLevelLayer()
		{
			super();
		}
		
		override public function dispose():void
		{
			if (_stageLevelPanel)
				_stageLevelPanel.removeFromParent(true);
			if(_lionAnim)
			{
				_lionAnim.removeFromJuggler();
			}
			// 监听武星激活事件
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onStageLevelLayerComplete);
			
			super.dispose();
		}
		
		// 初始化
		override protected function initialize():void
		{
			super.initialize();
			
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			var _bg:Scale9Image;
			var img:ImageLoader;
			// 
			// 背景上层的深色图层
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1,1 ,2,2)));
			_bg.width = ConstMainUI.MAPUNIT_WIDTH;
			_bg.height = ConstMainUI.MAPUNIT_HEIGHT;
			addChild(_bg);
			
//			// 星图
//			addChild(galaxy);
			
			// 初始化星象面板
			_stageLevelPanel = new CJStageLevelPanel;
			_stageLevelPanel.x = galaxy.x;
			_stageLevelPanel.y = galaxy.y;
			_stageLevelPanel.width = 361;
			_stageLevelPanel.height = 261;
			stageLevelBG.addChild(_stageLevelPanel);
			addChild(stageLevelBG);
			
			// 装饰框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangzhuangshinew") , new Rectangle(66,30 ,1,1)));
			_bg.x = galaxy.x;
			_bg.y = galaxy.y;
			_bg.width = _stageLevelPanel.width;
			_bg.height = _stageLevelPanel.height - 40;
			_bg.touchable = false;
			addChild(_bg);
			
			// 背景修饰框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(14,13 ,2,2)));
			_bg.width = ConstMainUI.MAPUNIT_WIDTH;
			_bg.height = ConstMainUI.MAPUNIT_HEIGHT;
			_bg.touchable = false;
			addChild(_bg);
			// 内部修饰
			var frame:CJPanelFrame = new CJPanelFrame(stageBG.width-6, stageBG.height-6);
			frame.x = stageBG.x+3;
			frame.y = stageBG.y+3;
			frame.touchable = false;
			addChild(frame);
			
			// 升阶面板
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			_bg.x = stageBG.x;
			_bg.y = stageBG.y;
			_bg.width = stageBG.width;
			_bg.height = stageBG.height;
			_bg.touchable = false;
			addChild(_bg);
			
			// 武魂面板
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_wujiangxuanzedi") , new Rectangle(13,11 ,2,6)));
			_bg.x = forcesoulBG.x;
			_bg.y = forcesoulBG.y;
			_bg.width = forcesoulBG.width;
			_bg.height = forcesoulBG.height;
			_bg.touchable = false;
			addChild(_bg);
			
			// 武魂
			labelForceSoul.textRendererProperties.textFormat = ConstTextFormat.textformat;
			labelForceSoul.text = CJLang("STAGE_FORCE_SOUL");
			addChild(labelForceSoul);
			labelForceSoulValue.textRendererProperties.textFormat = ConstTextFormat.textformatcenter;
			addChild(labelForceSoulValue);
			// 武魂后的分割线
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("zhujueshengjie_fengexian"), 45, 6);
			var scale3Image:Scale3Image = new Scale3Image(scale3texture);
			scale3Image.width = forcesoulBG.width;
			scale3Image.x = forcesoulBG.x;
			scale3Image.y = labelForceSoulValue.y + labelForceSoulValue.height;
			addChild(scale3Image);
			
			addChild(fsDetails);
			// 小标题头
			forceSoulTitle.textRendererProperties.textFormat = ConstTextFormat.textformat;
			// 小标题下分割线
			scale3texture = new Scale3Textures(SApplication.assets.getTexture("zhujueshengjie_fengexian"), 45, 6);
			scale3Image = new Scale3Image(scale3texture);
			scale3Image.width = forcesoulBG.width;
			scale3Image.x = forcesoulBG.x;
			scale3Image.y = forceSoulTitle.y + 25;
			fsDetails.addChild(scale3Image);
			// 描述
			forceStarDesc.textRendererProperties.textFormat = ConstTextFormat.textformat;
			forceStarDesc.textRendererProperties.wordWrap = true;
			forceStarDesc.textRendererProperties.multiline = true;
			// 消耗武魂
			forceSoulConsume.textRendererProperties.textFormat = ConstTextFormat.textformat;
			
			// 说明底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi") , new Rectangle(5,5 ,10,10)));
			_bg.width = explainBG.width;
			_bg.height = explainBG.height;
			_bg.touchable = false;
			explainBG.addChild(_bg);
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(14,13 ,2,2)));
			_bg.width = explainBG.width;
			_bg.height = explainBG.height;
			_bg.touchable = false;
			explainBG.addChild(_bg);
			addChild(explainBG);

			// 武星说明
			labelExplain.textRendererProperties.textFormat = ConstTextFormat.textformatlittle;
			labelExplain.textRendererProperties.wordWrap = true;
			labelExplain.textRendererProperties.multiline = true;
			labelExplain.text = CJLang("STAGE_DES");
			addChild(labelExplain);
			
			// 分割线
			img = new ImageLoader();
			img.source = SApplication.assets.getTexture("common_fengexian");
			img.x = labelExplain.x - 5;
			img.y = labelExplain.y + 16;
			img.width = labelExplain.width;
			addChild(img);
			
			// 获取途径
			var label:Label = new Label;
			label.x = labelExplain.x;
			label.y = labelExplain.y + 23;
			label.textRendererProperties.textFormat = ConstTextFormat.textformatredlittle;
			label.text = CJLang("STAGE_GET_SOUL");
			addChild(label);
			

			
			// 武星面板
			var temp:Label;
			/// 初始化各个阶的武星位置
			var forceStarObj:Object = ConstStageLevel.ConstForceStarObj;
			for (var stage:int=1; stage<=ConstStageLevel.ConstMaxStage; stage++)
			{
				forceStarObj[stage] = new Object;
				for (var index:int=1; index<=ConstStageLevel.ConstMaxStar; index++)
				{
					temp = this["star_"+stage+"_"+index] as Label;
					forceStarObj[stage][index] = new Object;
					forceStarObj[stage][index].x = temp.x;
					forceStarObj[stage][index].y = temp.y;
				}
			}
			
			// 监听武星激活事件
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onStageLevelLayerComplete);
			
			// 更新升阶信息
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_STAGE_LEVEL_INFO_COMPLETE, _doInit);
			CJDataManager.o.DataOfStageLevel.loadFromRemote();
			
			// 狮子头动画
			var animObject:Object = AssetManagerUtil.o.getObject("anim_stagelevel_lion");
			if (animObject!=null)
			{
				_lionAnim = SAnimate.SAnimateFromAnimJsonObject(animObject);
				_lionAnim.x =  imgLion.x;
				_lionAnim.y =  imgLion.y;
				Starling.juggler.add(_lionAnim); // 开始播放
				_lionAnim.gotoAndPlay();
				addChild(_lionAnim);
			}
			
			var img1:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			img1.width = SApplicationConfig.o.stageWidth;
			img.x = 0;
			img.y = 5;
			addChild(img);
			// 标题
			_title = new CJPanelTitle(CJLang("STAGE_TITLE"));
			addChild(_title);
			_title.x = labelTitle.x;
			_title.y = labelTitle.y;
			
			// 关闭按钮
			btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			btnClose.addEventListener(Event.TRIGGERED, function (e:Event):void{
				SApplication.moduleManager.exitModule("CJStageLevelModule");
			});
			addChild(btnClose);
		}
		
		
		// 初始化数据完成
		private function _doInit():void
		{
			/// 主角升阶信息
			var stageLevel:CJDataOfStageLevel = CJDataManager.o.DataOfStageLevel;
			if(stageLevel.dataIsEmpty)
			{
				return;
			}
			
			// 移除监听
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_STAGE_LEVEL_INFO_COMPLETE, _doInit);
			
			/// 更新界面
			_updataLayer();
		}
		
		/// 更新界面
		private function _updataLayer():void
		{
			var curSoul:String = CJDataManager.o.DataOfStageLevel.forceSoul.toString();
			
			// 下一颗星信息
			var nextForceStar:int = CJDataManager.o.DataOfStageLevel.forceStar + 1;
			var maxForceStar:int = ConstStageLevel.ConstMaxStar*ConstStageLevel.ConstMaxStage;
			if (nextForceStar > maxForceStar)
			{
				fsDetails.visible = false;
				return;
			}
			
			fsDetails.visible = true;
			
			var job:String = String(CJDataManager.o.DataOfRole.job);
			var sex:String = String(CJDataManager.o.DataOfRole.sex);
			// 下一颗星信息
			var jsStageLevel:Json_role_stage_level = CJDataOfStageLevelProperty.o.getData(String(nextForceStar));
			var jsForceStar:Json_role_stage_force_star = CJDataOfStageLevelProperty.o.getForceStarData(String(nextForceStar), job, sex);
			// 当前星信息
			var jsCurForceStar:Json_role_stage_force_star = CJDataOfStageLevelProperty.o.getForceStarData(String(nextForceStar-1), job, sex);
			
			// 小标题头
			var v:int = ConstStageLevel.getStageLevel(nextForceStar);
			forceSoulTitle.textRendererProperties.textFormat = ConstTextFormat.getStageLevellittleTitleFont(v);
			forceSoulTitle.text = CJLang(jsStageLevel.name);
			
			var describe:String = "";
			switch(uint(jsStageLevel.type))
			{
				case ConstStageLevel.ConstStageTypeCommon:
					forceStarDesc.textRendererProperties.textFormat = ConstTextFormat.textformatyellowlittle;
					describe = ConstStageLevel.getCommonDescribe(jsForceStar, jsCurForceStar);
					break;
				case ConstStageLevel.ConstStageTypeSkill:
					forceStarDesc.textRendererProperties.textFormat = ConstTextFormat.textformatgreenlittle;
					describe = ConstStageLevel.getSkillDescribe(CJDataManager.o.DataOfHeroList.getMainHero().heroProperty, String(v), jsForceStar);
					break;
				case ConstStageLevel.ConstStageTypeImage:
					forceStarDesc.textRendererProperties.textFormat = ConstTextFormat.textformatyellowlittle;
					describe = ConstStageLevel.getImageDescribe(CJDataManager.o.DataOfHeroList.getMainHero().heroProperty, String(v));
					break;
				default:
					break;
			}
			
			// 描述
			forceStarDesc.text = describe;
			
			if (int(jsStageLevel.level) == 0)
				forceSoulLevel.visible = false;
			else
				forceSoulLevel.visible = true;
			// 需要等级
			// 判断等级是否符合要求
			if ( int(CJDataManager.o.DataOfHeroList.getMainHero().level) >= int(jsStageLevel.level) )
				forceSoulLevel.textRendererProperties.textFormat = ConstTextFormat.textformatbluelittle;
			else
				forceSoulLevel.textRendererProperties.textFormat = ConstTextFormat.textformatredlittle;
			forceSoulLevel.text = CJLang("STAGE_NEED_LEVEL", {"level":jsStageLevel.level});
			
			// 消耗武魂
			// 判断消耗武魂是否充足
			if ( int(curSoul) >= int(jsStageLevel.forcesoul))
			{
				labelForceSoulValue.textRendererProperties.textFormat = ConstTextFormat.textformatcenter;
				forceSoulConsume.textRendererProperties.textFormat = ConstTextFormat.textformatbluelittle;
			}
			else
			{
				labelForceSoulValue.textRendererProperties.textFormat = ConstTextFormat.textformatredcenter;
				forceSoulConsume.textRendererProperties.textFormat = ConstTextFormat.textformatredlittle;
			}
			// 更新武魂数 左上角
			labelForceSoulValue.text = curSoul;// + "/" + maxSoul;
			// 左下角
			forceSoulConsume.text = CJLang("STAGE_NEED_SOUL", {"soul":jsStageLevel.forcesoul});
		}
		
		protected function _onStageLevelLayerComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_STAGELEVEL_ACTIVATE_FORCE_STAR)
				return;
			
			if (message.retcode != 0)
				return;
			
			// 活跃度
			CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_STAGEUPLEVEL});
			// 更新主界面总战斗力
			SocketCommand_hero.get_heros();
			
			// 返回相同的武星信息，直接返回不做处理
			if ( CJDataManager.o.DataOfStageLevel.forceStar == uint(message.retparams[1]) )
				return;
			
			CJDataManager.o.DataOfStageLevel.forceStar = uint(message.retparams[1]);
			CJDataManager.o.DataOfStageLevel.forceSoul = uint(message.retparams[2]);
			
			// 
			var forceStar:String = CJDataManager.o.DataOfStageLevel.forceStar.toString();
			var job:String = CJDataManager.o.DataOfRole.job.toString();
			var sex:String = CJDataManager.o.DataOfRole.sex.toString();
			var jsForceStarInfo:Json_role_stage_force_star = CJDataOfStageLevelProperty.o.getForceStarData(forceStar, job, sex);

			// 更新主将信息
			var mainHeroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getMainHero();
			if (int(jsForceStarInfo.newtid) != 0)
			{
				// 更新主将模板id与模板数据
				var tid:String = mainHeroInfo.heroProperty.nexttemplateid;
				var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(tid));
				Assert(heroProperty!=null, "CJStageLevelLayer._onStageLevelLayerComplete heroProperty == null and" + "tid==" + tid);
				if (heroProperty)
				{
					mainHeroInfo.templateid = int(tid);
					mainHeroInfo.heroProperty = heroProperty;
					// 通知场景更换主角形象
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_PLAYER_ROLEUPDATE , false);
				}
			}
			// 判断是否更新技能或者被动技能
			if (int(jsForceStarInfo.passivityskill) != 0)
				// 赋值被动技能
				mainHeroInfo.currenttalent = jsForceStarInfo.passivityskill;
			
			_updataLayer();
			
			//飘字
			new CJTaskFlowString(getCurDesc(), 1.6, 46).addToLayer();
		}
		
		private function getCurDesc():String
		{
			var curSoul:String = CJDataManager.o.DataOfStageLevel.forceSoul.toString();
			
			// 当前颗星信息
			var curForceStar:int = CJDataManager.o.DataOfStageLevel.forceStar;
			
			var job:String = String(CJDataManager.o.DataOfRole.job);
			var sex:String = String(CJDataManager.o.DataOfRole.sex);
			// 星信息
			var jsStageLevel:Json_role_stage_level = CJDataOfStageLevelProperty.o.getData(String(curForceStar));
			var jsForceStar:Json_role_stage_force_star = CJDataOfStageLevelProperty.o.getForceStarData(String(curForceStar), job, sex);
			// 当前星信息
			var jsCurForceStar:Json_role_stage_force_star = CJDataOfStageLevelProperty.o.getForceStarData(String(curForceStar-1), job, sex);
			
			var v:int = ConstStageLevel.getStageLevel(curForceStar);
			
			var describe:String = "";
			switch(uint(jsStageLevel.type))
			{
				case ConstStageLevel.ConstStageTypeCommon:
					forceStarDesc.textRendererProperties.textFormat = ConstTextFormat.textformatyellowlittle;
					describe = ConstStageLevel.getCommonDescribe(jsForceStar, jsCurForceStar);
					break;
				case ConstStageLevel.ConstStageTypeSkill:
					forceStarDesc.textRendererProperties.textFormat = ConstTextFormat.textformatgreenlittle;
					describe = ConstStageLevel.getSkillDescribe(CJDataManager.o.DataOfHeroList.getMainHero().heroProperty, String(v), jsForceStar);
					break;
				case ConstStageLevel.ConstStageTypeImage:
					forceStarDesc.textRendererProperties.textFormat = ConstTextFormat.textformatyellowlittle;
					describe = ConstStageLevel.getImageDescribe(CJDataManager.o.DataOfHeroList.getMainHero().heroProperty, String(v));
					break;
				default:
					break;
			}
			
			// 描述
			return describe;
		}
		
	}
}