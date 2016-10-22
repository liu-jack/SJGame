package SJ.Game.rank
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	
	import flash.text.TextFormat;
	
	import starling.events.Event;
	
	/**
	 * 排行榜基本操作层
	 * @author zhengzheng
	 * 
	 */	
	public class CJRankBaseOperateLayer extends SLayer
	{
		
		/**左按钮*/
		protected var btnLeft:Button;
		/**右按钮*/
		protected var btnRight:Button;
		/** 页码显示 */
		protected var labelPageShow:Label;
		/**当前页数*/
		protected var currentPageIndex:int = 1;
		/**总页数*/
		protected var pageNum:int = 1;
		/** 我的排名 */
		protected var labelMyRank:Label;
		/** 我的排名名次 */
		protected var labelMyRankContent:Label;
		/** 我的当前数据 */
		protected var labelMyCurData:Label;
		
		public function CJRankBaseOperateLayer()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
			_drawContent();
//			_addListener();
		}
		
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			//分割线
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("paihangbang_xian"),0,1);
			var line:Scale3Image = new Scale3Image(scale3texture);
			line.x = 8;
			line.y = 229;	
			line.width = 405;
			line.height = 5;
			this.addChild(line);
			
			//页数显示背景图
			var imgPageBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_fanyeyemawenzidi", 5, 5,1,1);
			imgPageBg.x = 174;
			imgPageBg.y = 241;
			imgPageBg.width = 75;
			imgPageBg.height = 21;
//			this.addChild(imgPageBg);
			
			//左按钮
			this.btnLeft = new Button();
			this.btnLeft.name = "pre";
			this.btnLeft.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnLeft.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnLeft.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnLeft.scaleX = -1;
			this.btnLeft.width = 22;
			this.btnLeft.height = 32;
			this.btnLeft.x = 185 + this.btnLeft.width;
			this.btnLeft.y = 236;
//			this.addChild(btnLeft);
			//右按钮
			this.btnRight = new Button();
			this.btnRight.name = "next";
			this.btnRight.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnRight.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnRight.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnRight.width = 22;
			this.btnRight.height = 32;
			this.btnRight.x = 260;
			this.btnRight.y = 236;
//			this.addChild(btnRight);
			//页码显示
			labelPageShow = new Label();
			labelPageShow.x = 174;
			labelPageShow.y = 244;
			labelPageShow.width = 75;
//			this.addChild(labelPageShow);
			//我的排名
			labelMyRank = new Label();
			labelMyRank.x = 26;
			labelMyRank.y = 244;
			labelMyRank.width = 50;
			labelMyRank.text = CJLang("RANK_MY_RANK") + "：";
			this.addChild(labelMyRank);
			
			//我的排名名次
			labelMyRankContent = new Label();
			labelMyRankContent.x = 65;
			labelMyRankContent.y = 243;
			labelMyRankContent.width = 50;
			this.addChild(labelMyRankContent);
			
			//我的当前数据
			labelMyCurData = new Label();
			labelMyCurData.x = 130;
			labelMyCurData.y = 243;
			labelMyCurData.width = 200;
			this.addChild(labelMyCurData);
			
			_setTextFormat();
		}
		
		/**
		 * 设置控件的字体 
		 */		
		private function _setTextFormat():void
		{
			var fontFormat:TextFormat;
			labelPageShow.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			labelMyRankContent.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			
			fontFormat = new TextFormat( "黑体", 10, 0xA1EA57);
			labelMyRank.textRendererProperties.textFormat = fontFormat;
			labelMyCurData.textRendererProperties.textFormat = fontFormat;
			labelMyCurData.textRendererFactory = textRender.htmlTextRender;
		}
	}
}