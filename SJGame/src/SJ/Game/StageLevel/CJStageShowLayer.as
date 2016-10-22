package SJ.Game.StageLevel
{
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstStageLevel;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_stageLevel;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfStageLevelProperty;
	import SJ.Game.data.json.Json_role_stage_change;
	import SJ.Game.data.json.Json_role_stage_force_star;
	import SJ.Game.data.json.Json_role_stage_level;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.layer.CJPanelBaseLayer;
	
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
	
	/**
	 * 展示武星信息
	 * @author longtao
	 * 
	 */
	public class CJStageShowLayer extends SLayer
	{
		private var _layerCommon:SLayer;
		/**  普通界面 **/
		public function get layerCommon():SLayer
		{
			return _layerCommon;
		}
		/** @private **/
		public function set layerCommon(value:SLayer):void
		{
			_layerCommon = value;
		}
		private var _labelCommonNote:Label;
		/**  说明文字 **/
		public function get labelCommonNote():Label
		{
			return _labelCommonNote;
		}
		/** @private **/
		public function set labelCommonNote(value:Label):void
		{
			_labelCommonNote = value;
		}
		private var _labelCommonNeed:Label;
		/**  级别条件 **/
		public function get labelCommonNeed():Label
		{
			return _labelCommonNeed;
		}
		/** @private **/
		public function set labelCommonNeed(value:Label):void
		{
			_labelCommonNeed = value;
		}
		private var _labelCommonConsume:Label;
		/**  消耗 **/
		public function get labelCommonConsume():Label
		{
			return _labelCommonConsume;
		}
		/** @private **/
		public function set labelCommonConsume(value:Label):void
		{
			_labelCommonConsume = value;
		}
		private var _layerSkill:SLayer;
		/**  技能界面 **/
		public function get layerSkill():SLayer
		{
			return _layerSkill;
		}
		/** @private **/
		public function set layerSkill(value:SLayer):void
		{
			_layerSkill = value;
		}
		private var _labelSkillNote:Label;
		/**  说明文字 **/
		public function get labelSkillNote():Label
		{
			return _labelSkillNote;
		}
		/** @private **/
		public function set labelSkillNote(value:Label):void
		{
			_labelSkillNote = value;
		}
		private var _labelSkillName:Label;
		/**  技能名称 **/
		public function get labelSkillName():Label
		{
			return _labelSkillName;
		}
		/** @private **/
		public function set labelSkillName(value:Label):void
		{
			_labelSkillName = value;
		}
		private var _labelSkillDes:Label;
		/**  技能描述 **/
		public function get labelSkillDes():Label
		{
			return _labelSkillDes;
		}
		/** @private **/
		public function set labelSkillDes(value:Label):void
		{
			_labelSkillDes = value;
		}
		private var _labelSkillNeed:Label;
		/**  级别条件 **/
		public function get labelSkillNeed():Label
		{
			return _labelSkillNeed;
		}
		/** @private **/
		public function set labelSkillNeed(value:Label):void
		{
			_labelSkillNeed = value;
		}
		private var _labelSkillConsume:Label;
		/**  消耗 **/
		public function get labelSkillConsume():Label
		{
			return _labelSkillConsume;
		}
		/** @private **/
		public function set labelSkillConsume(value:Label):void
		{
			_labelSkillConsume = value;
		}
		private var _layerImage:SLayer;
		/**  形象界面 **/
		public function get layerImage():SLayer
		{
			return _layerImage;
		}
		/** @private **/
		public function set layerImage(value:SLayer):void
		{
			_layerImage = value;
		}
		private var _animationBG:Label;
		/**  形象动画底框 **/
		public function get animationBG():Label
		{
			return _animationBG;
		}
		/** @private **/
		public function set animationBG(value:Label):void
		{
			_animationBG = value;
		}
		private var _animationPos:Label;
		/**  形象动画 **/
		public function get animationPos():Label
		{
			return _animationPos;
		}
		/** @private **/
		public function set animationPos(value:Label):void
		{
			_animationPos = value;
		}
		private var _labelImageNote:Label;
		/**  说明文字 **/
		public function get labelImageNote():Label
		{
			return _labelImageNote;
		}
		/** @private **/
		public function set labelImageNote(value:Label):void
		{
			_labelImageNote = value;
		}
		private var _labelImageNeed:Label;
		/**  条件 **/
		public function get labelImageNeed():Label
		{
			return _labelImageNeed;
		}
		/** @private **/
		public function set labelImageNeed(value:Label):void
		{
			_labelImageNeed = value;
		}
		private var _labelImageConsume:Label;
		/**  消耗 **/
		public function get labelImageConsume():Label
		{
			return _labelImageConsume;
		}
		/** @private **/
		public function set labelImageConsume(value:Label):void
		{
			_labelImageConsume = value;
		}
		private var _showBG:SLayer;
		/**  底框 **/
		public function get showBG():SLayer
		{
			return _showBG;
		}
		/** @private **/
		public function set showBG(value:SLayer):void
		{
			_showBG = value;
		}
		private var _labelTitle:Label;
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
		private var _btnActivate:Button;
		/**  激活按钮 **/
		public function get btnActivate():Button
		{
			return _btnActivate;
		}
		/** @private **/
		public function set btnActivate(value:Button):void
		{
			_btnActivate = value;
		}



		
		
		/** 当前武星索引 **/
		private var _curforceStar:int = 0;
		/** 升阶信息 **/
		private var _jsStageLevel:Json_role_stage_level;
		/** 武星信息 **/
		private var _jsForceStar:Json_role_stage_force_star;
		/** 形象变化信息 **/
		private var _jsStageChange:Json_role_stage_change;
		
//		/**武将空闲动画*/
//		private var _animate_hero:CJPlayerNpc;
		private var _animate_hero:CJStageChangeImage;
		
		/** 点击底框触发关闭 **/
		private var _panelbaseLayer:CJPanelBaseLayer;
		
		public function CJStageShowLayer()
		{
			super();
		}
		
		/**
		 * 退出
		 * */
		public function exit():void
		{
			if(_animate_hero)
				_animate_hero.exit();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			// 武星索引  职业 性别
			var forceStar:String = String(_curforceStar);
			var job:String = String(CJDataManager.o.DataOfRole.job);
			var sex:String = String(CJDataManager.o.DataOfRole.sex);
			// 获取对应信息
			_jsStageLevel = CJDataOfStageLevelProperty.o.getData(forceStar);
			_jsForceStar = CJDataOfStageLevelProperty.o.getForceStarData(forceStar, job, sex);
			Assert( _jsStageLevel != null, "CJStageShowLayer.initialize()  _jsStageLevel == null");
			Assert( _jsForceStar != null, "CJStageShowLayer.initialize()  _jsForceStar == null");
			
			// 获取的数据
			if (_curforceStar%ConstStageLevel.ConstMaxStar == 0)
			{
				var s:String = String(_curforceStar/ConstStageLevel.ConstMaxStar);
				_jsStageChange = CJDataOfStageLevelProperty.o.getStageChange(s, job, sex);
				Assert( _jsStageChange != null, "CJStageShowLayer.initialize()  _jsStageChange == null");	
			}
			
			
			// 显示的类型
			var type:uint = uint(_jsStageLevel.type);
			
//			// 关闭按钮
//			btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
//			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
//			btnClose.addEventListener(Event.TRIGGERED, function (e:Event):void{
//				SApplication.moduleManager.exitModule("CJStageShowModule");
//			});
			
			// 添加层级索引
			var layerIndex:uint = 0;
			var _bg:Scale9Image;
			
			// 背景修饰框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi") , new Rectangle(19,19,1,1)));
			_bg.x = showBG.x;
			_bg.y = showBG.y;
			_bg.width = showBG.width;
			_bg.height = showBG.height;
			addChildAt(_bg, layerIndex++);
			
			// 激活按钮
			btnActivate.name = "CJStageLevel_1";
			btnActivate.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			btnActivate.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			btnActivate.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			btnActivate.width = btnActivate.defaultSkin.width;
			btnActivate.height = btnActivate.defaultSkin.height;
			btnActivate.addEventListener(Event.TRIGGERED, function (e:Event):void{
				// 判断主角武魂是否足够
				if (CJDataManager.o.DataOfStageLevel.forceSoul < int(_jsStageLevel.forcesoul))
				{
					CJMessageBox(CJLang("ERROR_STAGE_FORCE_SOUL"));
					return;
				}
				// 判断主角等级是否足够
				if (uint(CJDataManager.o.DataOfHeroList.getMainHero().level) < int(_jsStageLevel.level))
				{
					CJMessageBox(CJLang("ERROR_STAGE_LEVEL"));
					return;
				}
				
				// 监听事件
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onActivateComplete);
				// 请求激活
				SocketCommand_stageLevel.activate_force_star();
			});

			layerCommon.visible = false;
			layerSkill.visible = false;
			layerImage.visible = false;
			
			switch(type)
			{
				case ConstStageLevel.ConstStageTypeCommon:
					initCommon();
					break;
				case ConstStageLevel.ConstStageTypeSkill:
					initSkill();
					break;
				case ConstStageLevel.ConstStageTypeImage:
					initImage();
					break;
				default:
					Assert( false, "CJStageShowLayer.initialize error type="+type);
			}
			
			btnActivate.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnActivate.label = CJLang("STAGE_ACTIVATE");
			// 判断激活按钮是否可按
			/// 当前激活的武星索引
			var forceStarIndex:uint = CJDataManager.o.DataOfStageLevel.forceStar;
			if (_curforceStar <= forceStarIndex) // 已激活的
			{
				btnActivate.visible = false;
			}
			else if (_curforceStar > forceStarIndex+1) // 不可被激活的
			{
				btnActivate.isEnabled = false;
			}
			
			
			//处理指引 初次点击圆球进入指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			_panelbaseLayer = new CJPanelBaseLayer;
			_panelbaseLayer.callbackClose = function ():void{
				SApplication.moduleManager.exitModule("CJStageShowModule");
			};
			addChildAt(_panelbaseLayer, 0);
			
		}
		
		// 普通类型
		private function initCommon():void
		{
			layerCommon.visible = true;
			// 标题
			labelTitle.textRendererProperties.textFormat = ConstTextFormat.textformatsubheading;
			labelTitle.text = CJLang(_jsStageLevel.name);
			
			var _bg:Scale9Image;
			// 背景修饰框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zhujueshengjie_biaotoudi") , new Rectangle(52,13,60,3)));
			_bg.x = showBG.x + 2;
			_bg.y = showBG.y + 2;
			_bg.width = showBG.width-4;
			layerCommon.addChild(_bg);
			
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_zuoshangjiaodi") , new Rectangle(10,10,6,6)));
			_bg.x = showBG.x + 6;
			_bg.y = showBG.y + 40;
			_bg.width = showBG.width-12;
			_bg.height = 158;
			layerCommon.addChildAt(_bg, 0);
			
			
			// 说明文字
			labelCommonNote.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelCommonNote.textRendererProperties.multiline = true;
			labelCommonNote.textRendererProperties.wordWrap = true;
			// 当前js _jsForceStar	
			var lastFS:String =  String(_curforceStar-1);
			var lastJsForceStar:Json_role_stage_force_star = CJDataOfStageLevelProperty.o.getForceStarData(lastFS, String(CJDataManager.o.DataOfRole.job), String(CJDataManager.o.DataOfRole.sex));
			labelCommonNote.text = ConstStageLevel.getCommonDescribe(_jsForceStar, lastJsForceStar);//CJLang(_jsForceStar.describe);
			
			// 条件
			labelCommonNeed.visible = int(_jsStageLevel.level) == 0 ? false : true;
			labelCommonNeed.textRendererProperties.textFormat = ConstTextFormat.textformatblue;
			labelCommonNeed.text = CJLang("STAGE_NEED_LEVEL", {"level":_jsStageLevel.level});
			labelCommonConsume.visible = int(_jsStageLevel.forcesoul) == 0 ? false : true;
			labelCommonConsume.textRendererProperties.textFormat = ConstTextFormat.textformatblue;
			labelCommonConsume.text = CJLang("STAGE_NEED_SOUL", {"soul":_jsStageLevel.forcesoul});
		}
		// 技能类型
		private function initSkill():void
		{
			layerSkill.visible = true;
			// 标题
			labelTitle.textRendererProperties.textFormat = ConstTextFormat.textformatsubheading;
			labelTitle.text = CJLang(_jsStageLevel.name);
			var _bg:Scale9Image;
			// 背景修饰框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zhujueshengjie_biaotoudi") , new Rectangle(52,13,60,3)));
			_bg.x = showBG.x;
			_bg.y = showBG.y;
			_bg.width = showBG.width;
			layerSkill.addChild(_bg);
			
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_zuoshangjiaodi") , new Rectangle(10,10,6,6)));
			_bg.x = showBG.x + 6;
			_bg.y = showBG.y + 40;
			_bg.width = showBG.width-12;
			_bg.height = 158;
			layerSkill.addChildAt(_bg, 0);
			
			// 说明文字
			labelSkillNote.textRendererProperties.textFormat = ConstTextFormat.textformatgreen;
			labelSkillNote.textRendererProperties.multiline = true;
			labelSkillNote.textRendererProperties.wordWrap = true; // 自动换行
			
			labelSkillNote.text = ConstStageLevel.getSkillDescribe(CJDataManager.o.DataOfHeroList.getMainHero().heroProperty, String(ConstStageLevel.getStageLevel(_curforceStar)), _jsForceStar);
			
			
//			// 获取技能信息
//			var skillObj:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(_jsForceStar.newskill) as Json_skill_setting;
//			Assert( skillObj!=null, "skillObj == null");
//			if (skillObj != null)
//			{
//				// 技能名称
//				labelSkillName.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
//				labelSkillName.text = CJLang(skillObj.skillname);
//				// 技能描述
//				labelSkillDes.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
//				labelSkillDes.textRendererProperties.multiline = true;
//				labelSkillDes.text = CJLang(skillObj.skilldes);
//			}
			
			// 条件
			labelSkillNeed.visible = int(_jsStageLevel.level) == 0 ? false : true;
			labelSkillNeed.textRendererProperties.textFormat = ConstTextFormat.textformatblue;
			labelSkillNeed.text = CJLang("STAGE_NEED_LEVEL", {"level":_jsStageLevel.level});
			labelSkillConsume.visible = int(_jsStageLevel.forcesoul) == 0 ? false : true;
			labelSkillConsume.textRendererProperties.textFormat = ConstTextFormat.textformatblue;
			labelSkillConsume.text = CJLang("STAGE_NEED_SOUL", {"soul":_jsStageLevel.forcesoul});
		}
		// 主角更换形象
		private function initImage():void
		{
			layerImage.visible = true;
			
			// 底框
			var _bg:Scale9Image;
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zhujueshengjie_xingzikuang") , new Rectangle(12,12,3,3)));
			_bg.x = animationBG.x;
			_bg.y = animationBG.y;
			_bg.width = animationBG.width;
			_bg.height = animationBG.height;
			layerImage.addChild(_bg);
			
			/// 武将展示位置以及底盘
			var img:ImageLoader = new ImageLoader;
			img.source = SApplication.assets.getTexture("common_dizuo");
			img.pivotX = 69;
			img.pivotY = 12;
			img.x = animationPos.x;
			img.y = animationPos.y;
			layerImage.addChild(img);
			
			// 判断变化形象js是否存在
			if (_jsStageChange)
			{
				// 主角要更换的形象
				_animate_hero = new CJStageChangeImage(_jsStageChange.oldtid, _jsStageChange.newtid);
				_animate_hero.x = animationPos.x;
				_animate_hero.y = animationPos.y;
				layerImage.addChild(_animate_hero);
				
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_STAGE_LEVEL_IMAGE_COMPLETE, __imageComplete);
				
				btnActivate.isEnabled = false;
				
				function __imageComplete():void
				{
					var forceStarIndex:uint = CJDataManager.o.DataOfStageLevel.forceStar;
					if (_curforceStar > forceStarIndex+1) // 不可被激活的
						btnActivate.isEnabled = false;
					else
						btnActivate.isEnabled = true;
					CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_STAGE_LEVEL_IMAGE_COMPLETE, __imageComplete);
				}
			}
			
			// 条件
			labelImageNeed.visible = int(_jsStageLevel.level) == 0 ? false : true;
			labelImageNeed.textRendererProperties.textFormat = ConstTextFormat.textformatblue;
			labelImageNeed.text = CJLang("STAGE_NEED_LEVEL", {"level":_jsStageLevel.level});
			labelImageConsume.visible = int(_jsStageLevel.forcesoul) == 0 ? false : true;
			labelImageConsume.textRendererProperties.textFormat = ConstTextFormat.textformatblue;
			labelImageConsume.text = CJLang("STAGE_NEED_SOUL", {"soul":_jsStageLevel.forcesoul});
		}

		/** 当前武星索引 **/
		public function set curforceStar(value:int):void
		{
			_curforceStar = value;
		}

		protected function _onActivateComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_STAGELEVEL_ACTIVATE_FORCE_STAR)
				return;
			
			switch(message.retcode)
			{
				case 0:
					//重新获取角色技能
					CJDataManager.o.DataOfUserSkillList.loadFromRemote();
					break;
				case 2:
					CJMessageBox(CJLang("ERROR_STAGE_LEVEL"));
					return;
				case 3:
					CJMessageBox(CJLang("ERROR_STAGE_FORCE_SOUL"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJStageShowLayer._onActivateComplete retcode="+message.retcode );
					return;
			}
			// 移除事件
			e.target.removeEventListener(e.type, _onActivateComplete);
			// 退出模块
			SApplication.moduleManager.exitModule("CJStageShowModule");
		}
	}
}