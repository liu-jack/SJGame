package SJ.Game.recharge
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	/**
	 * 充值层单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJRechargeItem extends SLayer
	{
		/** 能兑换的元宝数量 */
		private var _labGoldNum:Label;
		/** 需要的人民币数量 */
		private var _labRmbNum:Label;
//		/** 购买按钮*/
//		private var _btnBuy:Button;
		/** 购买标签 */
		private var _labBuy:Label;
		/** 选中图 */
		private var _imgSelected:Scale9Image;
		/** 平台套餐名 */
		private var _productName:String;
		public function CJRechargeItem()
		{
			super();
			_drawContent();
		}
		
		/**
		 * 绘制界面内容
		 */		
		private function _drawContent():void
		{
			this.width = 112;
			this.height = 62;
			
			//背景底图
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("chongzhi_kuang", 10.5, 10,1,1);
			imgBg.width = this.width;
			imgBg.height = this.height;
			this.addChild(imgBg);
			
			//元宝文字底图
			var imgGoldBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("chongzhi_wenzidi", 3, 3,1,1);
			imgGoldBg.x = 6;
			imgGoldBg.y = 10;
			imgGoldBg.width = 54;
			imgGoldBg.height = 16;
			this.addChild(imgGoldBg);
			
			//人民币文字底图
			var imgRmbBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("chongzhi_wenzidi", 3, 3,1,1);
			imgRmbBg.x = 71;
			imgRmbBg.y = 10;
			imgRmbBg.width = 35;
			imgRmbBg.height = 16;
			this.addChild(imgRmbBg);
			
			//元宝图片
			var imgGold:SImage = new SImage(SApplication.assets.getTexture("common_yuanbao"));
			imgGold.x = 9;
			imgGold.y = 13;
			this.addChild(imgGold);
			
			_labGoldNum = new Label();
			_labGoldNum.x = 24;
			_labGoldNum.y = 10;
			_labGoldNum.width = 35;
			this.addChild(_labGoldNum);
			
			//人民币图片
			var imgRmb:SImage = new SImage(SApplication.assets.getTexture("chongzhi_qian"));
			imgRmb.x = 76;
			imgRmb.y = 14;
			this.addChild(imgRmb);
			
			_labRmbNum = new Label();
			_labRmbNum.x = 85;
			_labRmbNum.y = 10;
			this.addChild(_labRmbNum);
			
			//兑换图片
			var imgExchange:SImage = new SImage(SApplication.assets.getTexture("chongzhi_duideng"));
			imgExchange.x = 59;
			imgExchange.y = 13;
			this.addChild(imgExchange);
			
			//分割线
			var imgLine:SImage = new SImage(SApplication.assets.getTexture("chongzhi_xian"));
			imgLine.x = 6;
			imgLine.y = 31;
			this.addChild(imgLine);
			
			_labBuy = new Label();
			_labBuy.x = 30;
			_labBuy.y = 35;
			this.addChild(_labBuy);
			
//			_btnBuy = new Button();
//			_btnBuy.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
//			_btnBuy.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
//			_btnBuy.width = 50;
//			_btnBuy.height = 20;
//			_btnBuy.x = 30;
//			_btnBuy.y = 35;
//			this.addChild(_btnBuy);
			
			//选中图
			_imgSelected = ConstNPCDialog.genS9ImageWithTextureNameAndRect("chognzhi_xuanzhong", 10,10,2,2);
			_imgSelected.width = this.width;
			_imgSelected.height = this.height;
			_imgSelected.visible = false;
			this.addChild(_imgSelected);
			
			_setTextShow();
		}
		/**
		 * 设置文本显示
		 */		
		private function _setTextShow():void
		{
			var fontFormat:TextFormat = new TextFormat( "Arial", 10, 0xFEFE6F);
			_labGoldNum.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "Arial", 10, 0xF3D472);
			_labRmbNum.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "Arial", 12, 0xFEFE6F);
			_labBuy.textRendererProperties.textFormat = fontFormat;
			_labBuy.textRendererFactory = this._getTextRender;
			_labBuy.text = CJLang("RECHARGE_BUY");
		}

		/**
		 * 卷积，发光
		 */		
		private function _getTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			
			_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x16241D,1.0,2.0,2.0,5,2)];
			return _htmltextRender;
		}
		/** 能兑换的元宝数量*/
		public function get labGoldNum():Label
		{
			return _labGoldNum;
		}

		/**
		 * @private
		 */
		public function set labGoldNum(value:Label):void
		{
			_labGoldNum = value;
		}

		/** 需要的人民币数量*/
		public function get labRmbNum():Label
		{
			return _labRmbNum;
		}

		/**
		 * @private
		 */
		public function set labRmbNum(value:Label):void
		{
			_labRmbNum = value;
		}

		/**选中背景图*/
		public function get imgSelected():Scale9Image
		{
			return _imgSelected;
		}

		/**
		 * @private
		 */
		public function set imgSelected(value:Scale9Image):void
		{
			_imgSelected = value;
		}
		
		/**
		 * 设置游戏币数量
		 * @param value
		 * 
		 */		
		public function set gold(value:String):void
		{
			labGoldNum.text = value;
		}

		/**
		 * 设置人民币数量
		 * @param value
		 * 
		 */		
		public function set rmb(value:String):void
		{
			labRmbNum.text = value;
		}
		/**
		 * 设置平台产品名
		 * @param value
		 * 
		 */		
		public function set productName(value:String):void
		{
			_productName = value;
		}
		/**
		 * 获取平台产品名
		 * @return 
		 * 
		 */		
		public function get productName():String
		{
			return _productName;
		}
	}
}