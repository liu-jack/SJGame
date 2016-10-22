package SJ.Game.duobao
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.controls.CJTimerUtil;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import starling.text.TextField;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 雇佣主界面的头像小Item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-15 下午6:13:38  
	 +------------------------------------------------------------------------------
	 */
	public class CJDuoBaoEmployHead extends SLayer
	{
		/*武将头像*/
		private var _logo:ImageLoader;
		/*名字*/
		private var _nameTF:TextField;
		/*头像背景框*/
		private var _logoBG:ImageLoader;
		/*武将的配置id*/
		private var _templateId:String;
		/*武将的静态配置*/
		private var _heroConfig:CJDataHeroProperty;
		/*用户武将的唯一id*/
		private var _heroId:String;
		
		private var _heroBattleeffectLabel:CJTaskLabel;
		
		/** 武将头像背景X坐标 **/
		private const CONST_HEAD_BG_X:int = 0;
		/** 武将头像背景Y坐标 **/
		private const CONST_HEAD_BG_Y:int = 10;
		/** 武将头像X坐标 **/
		private const CONST_HEAD_X:int = 35;
		/** 武将头像Y坐标 **/
		private const CONST_HEAD_Y:int = 62;
		/** 武将头像中心点X **/
		private const CONST_HEAD_PIVOT_X:int = 47;
		/** 武将头像中心点Y **/
		private const CONST_HEAD_PIVOT_Y:int = 73;
		/** 控件宽度 **/
		private const CONST_WIDTH:int = 66;
		/** 控件高度 **/
		private const CONST_HEIGHT:int = 65;
		
		private var _employtime:Number;
		
		private var _refreshRemainTimeT:CJTaskLabel;
		
		private var _remainTimeLabel:CJTimerUtil;
		
		private var _remaintime:Number;
		private var _heroData:Object;
		
		public function CJDuoBaoEmployHead()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
		}
		
		private function drawContent():void
		{
			this.width = CONST_WIDTH;
			this.height = CONST_HEIGHT;
			//框
			this._logoBG = new ImageLoader();
			this._logoBG.source = SApplication.assets.getTexture("common_wujiangkuang");
			_logoBG.x = CONST_HEAD_BG_X;
			_logoBG.y = CONST_HEAD_BG_Y;
			
			this.addChild(this._logoBG);
			
			//头像
			this._logo = new ImageLoader();
			this._logo.x = CONST_HEAD_X;
			this._logo.y = CONST_HEAD_Y;
			this._logo.pivotX = CONST_HEAD_PIVOT_X;
			this._logo.pivotY = CONST_HEAD_PIVOT_Y;
			this.addChild(this._logo);
			//文字
			_nameTF = new TextField(15 , 60 , "" ,"Verdana" , 12 , 0xEBF8B1 , false);
			_nameTF.x = 46;
			_nameTF.y = 5;
			_drawFlow(_nameTF);
			this.addChild(_nameTF);
			
			//各个label
			_refreshRemainTimeT = new CJTaskLabel();
			_refreshRemainTimeT.fontFamily = "黑体";
			_refreshRemainTimeT.fontSize = 10;
			_refreshRemainTimeT.fontColor = 0xffffff;
			_refreshRemainTimeT.x = 0;
			_refreshRemainTimeT.y = 73;
			this.addChild(_refreshRemainTimeT);
			_refreshRemainTimeT.text = CJLang('DUOBAO_LABEL_LASTTIME');
			
			_remainTimeLabel = new CJTimerUtil();
			var tf:TextFormat = new TextFormat();
			tf.font = "黑体";
			tf.size = 10;
			tf.color = 0x98FF42;
			_remainTimeLabel.labelTextForamt = tf;
			_remainTimeLabel.x = 48;
			_remainTimeLabel.y = 73;
			this.addChild(_remainTimeLabel);
			
			_heroBattleeffectLabel = new CJTaskLabel();
			_heroBattleeffectLabel.fontFamily = "黑体";
			_heroBattleeffectLabel.fontSize = 10;
			_heroBattleeffectLabel.fontColor = 0xff0000;
			_heroBattleeffectLabel.x = 10;
			_heroBattleeffectLabel.y = 0;
			this.addChild(_heroBattleeffectLabel);
		}
		
		/**
		 * 字体描边
		 */		
		private function _drawFlow(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
		override protected function draw():void
		{
			if(!_heroId)
			{
				return;
			}
			this._heroConfig = CJDataOfHeroPropertyList.o.getProperty(int(_templateId));
			// 武将名字
			this._nameTF.text = CJLang(this._heroConfig.name);
			_nameTF.color = ConstHero.ConstHeroNameColor[int(_heroConfig.quality)];
			
			var resproperty:Json_hero_battle_propertys = CJDataOfHeroPropertyList.o.getBattlePropertyWithTemplateId(int(_templateId));
			this._logo.source = SApplication.assets.getTexture("touxiang_"+resproperty.texturename);

			_remainTimeLabel.setTimeAndRun(this._remaintime , function():void
			{
				SocketCommand_duobao.getEmployData();
			}
			);
			
			super.draw();
		}
		
		public function set data(ob:Object):void
		{
			if(!ob)
			{
				return;
			}
			this._heroId = ob['heroid'];
			this._employtime = ob['employtime'];
			this._remaintime = ob['remaintime'];
			this._heroData = JSON.parse(ob['employherodata']);
			this._templateId = this._heroData['templateid'];
			
			_heroBattleeffectLabel.text = CJLang('ITEM_TOOLTIP_ZHANDOULI')+" "+int(this._heroData["battleeffect"]);
			
			this.invalidate();
		}
	}
}