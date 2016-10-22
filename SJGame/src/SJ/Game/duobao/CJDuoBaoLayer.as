package SJ.Game.duobao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJDuoBaoLayer extends SLayer
	{
		
		public static  var TabIndex:int = -1;//0 夺宝 1寻宝
		
		// 字体 - 按钮选中
		private const fontBtnSel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFDCA8B, null, null, null, null, null, TextFormatAlign.CENTER);
		// 字体 - 按钮未选中
		private const fontBtnUnsel:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xE5DB8E, null, null, null, null, null, TextFormatAlign.CENTER);
		
		private var closeButton:Button;//关闭按钮
		private var dubaoTabBt:Button;//夺宝按钮
		private var xunbaoTabBt:Button;//寻宝按钮
		
		private var subXunBaoLayer:CJSubXunBaoLayer;//寻宝子面板
		private var subDuoBaoLayer:CJSubDuoBaoLayer;
		
		public function CJDuoBaoLayer()
		{
			super();
			this.setSize(480, 320);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 背景
			var textureBg:Texture = SApplication.assets.getTexture("common_tankuangdi");
			var bgScaleRange:Rectangle = new Rectangle(19,19,1,1);
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
			var bgImage:Scale9Image = new Scale9Image(bgTexture);
			bgImage.width = width;
			bgImage.height = height;
			this.addChildAt(bgImage, 0);
			
//			//背景2
//			var texture:Texture = SApplication.assets.getTexture("common_dizhezhaonew");
//			var imgBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
//			imgBg.x = 2;
//			imgBg.y = 0;
//			imgBg.width = width-4;
//			imgBg.height = 179;
//			this.addChild(imgBg);
			
			// 边角
			var imgBgcorner:Scale9Image;
			imgBgcorner = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanpingzhuangshidi", 14.5, 13, 1, 1);
			imgBgcorner.x = 0;
			imgBgcorner.y = 0;
			imgBgcorner.width = width;
			imgBgcorner.height = height;
			this.addChild(imgBgcorner);
			
			// 全屏头部底
			var imgHeadBg:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			imgHeadBg.width = width;
			imgHeadBg.height = 15;
			imgHeadBg.x = 0;
			imgHeadBg.y = 0;
			this.addChild(imgHeadBg);
			
			//标题
			var labTitle:CJPanelTitle = new CJPanelTitle(CJLang("DUOBAO_TITLE"));
			labTitle.x = 100;
			this.addChild(labTitle);
			
			//关闭按钮
			closeButton = new Button();
			closeButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			closeButton.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			closeButton.addEventListener(Event.TRIGGERED , _closeHandle);
			closeButton.x = 438;
			closeButton.name = "closeBt";
			this.addChild(closeButton);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.width - 70 , this.height - 50);
			bgBall.x = 67;
			bgBall.y = 32;
			this.addChild(bgBall);
			
			// 纹理边框
			var textureBiankuang:Texture = SApplication.assets.getTexture("common_waikuangnew");
			var bgScaleRangeBk:Rectangle = new Rectangle(15 , 15 , 1, 1);
			var bgTextureBk:Scale9Textures = new Scale9Textures(textureBiankuang, bgScaleRangeBk);
			var imgBiankuang:Scale9Image = new Scale9Image(bgTextureBk);
			imgBiankuang.width = width-65;
			imgBiankuang.height = height-45;
			imgBiankuang.x = 65;
			imgBiankuang.y = 30;
			this.addChild(imgBiankuang);
				
			//夺宝按钮
			dubaoTabBt = new Button();
			dubaoTabBt.x = 2;
			dubaoTabBt.y = 60;
			dubaoTabBt.defaultSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka02"));
			dubaoTabBt.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka01"));
			dubaoTabBt.width = 65;
			dubaoTabBt.height = 40;
			dubaoTabBt.defaultLabelProperties.textFormat = fontBtnUnsel;
			dubaoTabBt.selectedDownLabelProperties.textFormat = fontBtnSel;
			dubaoTabBt.selectedHoverLabelProperties.textFormat = fontBtnSel;
			dubaoTabBt.selectedUpLabelProperties.textFormat = fontBtnSel;
			dubaoTabBt.addEventListener(Event.TRIGGERED, duoTabClick);
			dubaoTabBt.label = CJLang("DUOBAO_TAB_1");
			addChild(dubaoTabBt);
			
			//寻宝按钮
			xunbaoTabBt = new Button();
			xunbaoTabBt.x = 2;
			xunbaoTabBt.y = 110;
			xunbaoTabBt.defaultSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka02"));
			xunbaoTabBt.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka01"));
			xunbaoTabBt.width = 65;
			xunbaoTabBt.height = 40;
			xunbaoTabBt.defaultLabelProperties.textFormat = fontBtnUnsel;
			xunbaoTabBt.selectedDownLabelProperties.textFormat = fontBtnSel;
			xunbaoTabBt.selectedHoverLabelProperties.textFosrmat = fontBtnSel;
			xunbaoTabBt.selectedUpLabelProperties.textFormat = fontBtnSel;
			xunbaoTabBt.addEventListener(Event.TRIGGERED, xunTabClick);
			xunbaoTabBt.label = CJLang("DUOBAO_TAB_2");
			addChild(xunbaoTabBt);
			
			duoTabClick(null);
		}
		
		//夺宝
		private function duoTabClick(e:Event):void
		{
			if(TabIndex == 0)
				return;
			TabIndex = 0;
			
			dubaoTabBt.isSelected = true;
			xunbaoTabBt.isSelected = false;
			
			if(subXunBaoLayer != null)subXunBaoLayer.visible = false;
			if(subDuoBaoLayer == null)
			{
				subDuoBaoLayer = new CJSubDuoBaoLayer();
				subDuoBaoLayer.x = 0;
				subDuoBaoLayer.y = 0;
				subDuoBaoLayer.initUI();
				addChild(subDuoBaoLayer);
			}
		}
		
		//寻宝
		private function xunTabClick(e:Event):void
		{
			if(TabIndex == 1)
				return;
			TabIndex = 1;
			
			dubaoTabBt.isSelected = false;
			xunbaoTabBt.isSelected = true;
			
			if(subXunBaoLayer == null)
			{
				subXunBaoLayer = new CJSubXunBaoLayer(this);
				addChild(subXunBaoLayer);
			}
			subXunBaoLayer.visible = true;
		}
		
		/**
		 * 寻宝模块点击宝物显示信息用
		 * @return Object
		 */		
		public function getTreasureData():Object
		{
			if(subDuoBaoLayer != null)
				return subDuoBaoLayer.getTreasureData()
			return null;
		}
		
		/**
		 * 寻宝结束刷新左侧列表
		 * @return Object
		 */		
		public function flushBaoList():void
		{
			if(subDuoBaoLayer != null)subDuoBaoLayer._rpcGetTreasureForMerge()
		}
		
		//关闭窗口
		private function _closeHandle(eve:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJDuoBaoModule");
		}
		
		private function removeAllListener():void
		{
			closeButton.removeEventListener(Event.TRIGGERED , _closeHandle);
			dubaoTabBt.removeEventListener(Event.TRIGGERED, duoTabClick);
			xunbaoTabBt.removeEventListener(Event.TRIGGERED, xunTabClick);
		}
		
		override public function dispose():void
		{
			TabIndex = -1;
			removeAllListener();
			
			closeButton = null;
			super.dispose();
			
			if(subDuoBaoLayer != null && contains(subDuoBaoLayer)){
				subDuoBaoLayer.removeFromParent(true);
			}
			
			if(subXunBaoLayer != null && contains(subXunBaoLayer)){
				subXunBaoLayer.removeFromParent(true);
			}
			
		}
	}
}