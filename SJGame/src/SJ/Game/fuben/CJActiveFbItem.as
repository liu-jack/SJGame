package SJ.Game.fuben
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJTimerUtil;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.textures.Texture;
	
	public class CJActiveFbItem extends CJItemTurnPageBase implements IListItemRenderer
	{
		private var btn:Button;
		private var icon:SImage
		private var hasopen:Boolean = false
		private var openbg:Scale3Image
		private var unopenbg:Scale3Image
		private var openLabel:Label
		private var leftTimeText:Label
		private var leftTimeLabel:Label
		private var descLabel:Label
		private var _awardCDTimeLabel:CJTimerUtil
		public function CJActiveFbItem()
		{
			super("CJActiveFbItem");
		}

		override protected function initialize():void
		{

			this.setSize(375,47);
			openbg= new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("huodong_dikuang01"),4,5))
			openbg.width = 375;
			unopenbg = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("huodong_dikuang02"),4,5))
			unopenbg.width = 375;
			btn = new Button;
			btn.defaultSkin = unopenbg
			this.addChild(btn);
			
			icon = new SImage(Texture.empty(0,0),true)
			icon.x = 2;
			icon.y = -8;
			this.addChild(icon);
			
			openLabel = new Label
			openLabel.x = 69;
			openLabel.y = 6;
			openLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatunopen;
			this.addChild(openLabel)
				
			leftTimeText = new Label
			leftTimeText.x = 188;
			leftTimeText.y = 6;
			leftTimeText.textRendererProperties.textFormat = ConstTextFormat.actItemContenttextformatopen;
			leftTimeText.text = CJLang("ACTFB_OPENLEFTLABEL")
			this.addChild(leftTimeText)
				
			leftTimeLabel = new Label
			leftTimeLabel.x = 242;
			leftTimeLabel.y = 6;
			this.addChild(leftTimeLabel)
				
			var descBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("liaotian_wenzidikuang"),new Rectangle(8,8,1,1)));
			descBg.width = 217;
			descBg.height = 17;
			descBg.x = 63;
			descBg.y = 27;
			this.addChild(descBg)
			descLabel = new Label
			descLabel.x = 63;
			descLabel.y = 28;
			descLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			this.addChild(descLabel);
			
			_awardCDTimeLabel = new CJTimerUtil
			_awardCDTimeLabel.x = 242
			_awardCDTimeLabel.y = 6
			this.addChild(_awardCDTimeLabel)
			super.initialize();
		}
		
		override protected function draw():void
		{
			this.hasopen = (data["hasopen"] == 1)?true:false
			if(hasopen)
			{
				btn.defaultSkin = openbg
				openLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatopen;
				openLabel.text = CJLang(data['name']);
				leftTimeText.text = CJLang("ACTFB_CLOSELEFTLABEL")
				leftTimeText.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			}
			else
			{
				
			}
			icon.texture = SApplication.assets.getTexture(_data['icon']);
			icon.scaleX = icon.scaleY = 0.75
			icon.readjustSize();
//			leftTimeLabel.text = _data['lefttime'];
			_awardCDTimeLabel.setTimeAndRun( _data['lefttime']);
			descLabel.text = CJLang(_data["decs"]);
			super.draw();
		}
		
		override protected function onSelected():void
		{
		   if(this.hasopen)
		   {
				this.dispatchEventWith("click",true,_data['id'])
		   }
		}
	}
}