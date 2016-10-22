package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTextFormat;
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
	import flash.text.TextFormatAlign;
	
	import starling.events.Event;
	
	/**
	 * 动态基本操作层
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicBaseOperateLayer extends SLayer
	{
		
		/**左按钮*/
		protected var btnLeft:Button;
		/**右按钮*/
		protected var btnRight:Button;
		/** 页码显示 */
		protected var labelPageShow:Label;
		/**当前页数*/
		protected var currentPage:int = 1;
		/**总页数*/
		protected var pageNum:int = 10;
		/** 一键领取描述 */
		protected var labelGetDesc:Label;
		/** 一键领取按钮 */
		protected var btnGetOneKey:Button;
		
		public function CJDynamicBaseOperateLayer()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
			_drawContent();
		}
		
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			
			//左按钮
			this.btnLeft = new Button();
			this.btnLeft.name = "pre";
			this.btnLeft.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnLeft.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnLeft.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnLeft.scaleX = -1;
			this.btnLeft.width = 27;
			this.btnLeft.height = 41;
			this.btnLeft.x = 185 + this.btnLeft.width;
			this.btnLeft.y = 237;
			this.addChild(btnLeft);
			//右按钮
			this.btnRight = new Button();
			this.btnRight.name = "next";
			this.btnRight.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnRight.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnRight.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnRight.width = 27;
			this.btnRight.height = 41;
			this.btnRight.x = 263;
			this.btnRight.y = 237;
			this.addChild(btnRight);
			
			//页数显示背景图
			var imgPageBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_fanyeyemawenzidi", 5, 5,1,1);
			imgPageBg.x = 169;
			imgPageBg.y = 246;
			imgPageBg.width = 84;
			imgPageBg.height = 23;
			this.addChild(imgPageBg);
				
			//页码显示
			labelPageShow = new Label();
			labelPageShow.x = 169;
			labelPageShow.y = 250;
			labelPageShow.width = 84;
//			labelPageShow.text = "12 / 15";
			this.addChild(labelPageShow);
			
			//一键领取描述 
			labelGetDesc = new Label();
			labelGetDesc.x = 312;
			labelGetDesc.y = 237;
			labelGetDesc.width = 92;
			labelGetDesc.text = CJLang("DYNAMIC_GET_DESCRIPTION");
//			this.addChild(labelGetDesc);
			
			//一键领取按钮
			this.btnGetOneKey = new Button();
			this.btnGetOneKey.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnGetOneKey.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnGetOneKey.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			this.btnGetOneKey.width = 94;
			this.btnGetOneKey.height = 28;
			this.btnGetOneKey.x = 312;
			this.btnGetOneKey.y = 252;
			this.btnGetOneKey.label = CJLang("DYNAMIC_GET_ONE_KEY");
//			this.addChild(btnGetOneKey);
			
			_setTextFormat();
		}
		
		/**
		 * 设置控件的字体 
		 */		
		private function _setTextFormat():void
		{
			var fontFormat:TextFormat;
			labelPageShow.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			fontFormat = new TextFormat( "Arial", 8, 0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			labelGetDesc.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "Arial", 13, 0xFFFFFF);
			this.btnGetOneKey.defaultLabelProperties.textFormat = fontFormat;
		}
	}
}