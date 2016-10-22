package SJ.Game.treasure
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	
	import starling.text.TextField;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵初始指引面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午5:51:39  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasureDirectPanel extends CJTreasurePanelBase
	{
		
		public function CJTreasureDirectPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			var _label:CJTaskLabel = new CJTaskLabel();
			_label.colorText(CJLang('TREASURE_BUTTON_lingwanshangxian') , "#FFDC64")
			_label.x = 190;
			_label.y = 5;
			this.addChild(_label);
			
			for(var i:int = 1 ;i<=3 ; i++)
			{
				var button:Button = new Button();
				button.defaultSkin = new SImage(SApplication.assets.getTexture("juling_kuang"));
				button.labelFactory = textRender.htmlTextRender;
				button.label = "<b>"+CJLang("TREASURE_STEP_"+i)+"</b>"
				button.touchable = false;
				button.width = 140;
				button.height = 33;
				button.x = 170;
				button.y = 47 + (i-1)*69;
				this.addChild(button);
			}
			for(var j:int = 0 ; j<2 ; j++)
			{
				var narrow:SImage = new SImage(SApplication.assets.getTexture("juling_jiantou"));
				narrow.x = 229;
				narrow.y = 88 + j*69;
				this.addChild(narrow);
			}
		}
	}
}