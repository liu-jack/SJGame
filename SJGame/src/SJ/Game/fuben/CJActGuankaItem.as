package SJ.Game.fuben
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnterGuanqia;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.textures.Texture;
	
	public class CJActGuankaItem extends CJItemTurnPageBase
	{
		private var btn:Button;
		private var icon:SImage
		private var hasopen:Boolean = false
		private var openbg:Scale3Image
		private var unopenbg:Scale3Image
		private var openLabel:Label
		private var leftTimeText:Label
		private var leftTimeLabel:Label
		private var vitText:Label
		private var vitLabel:Label
		private var descLabel:Label
		private var _dataEnterGuanqia:CJDataOfEnterGuanqia;
		public function CJActGuankaItem()
		{
			super("CJActGuankaItem", false);
			_dataEnterGuanqia = CJDataOfEnterGuanqia.o;
		}
		override protected function initialize():void
		{
			super.initialize();
			this.setSize(375,47);
			openbg= new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("huodong_dikuang01"),4,5))
			openbg.width = 375;
			unopenbg = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("huodong_dikuang02"),4,5))
			unopenbg.width = 375;
			btn = new Button;
			btn.defaultSkin = unopenbg
			this.addChild(btn);
			
			icon = new SImage(Texture.empty(0,0),true)
			icon.x = 11;
			icon.y = 8
			this.addChild(icon);
			
			openLabel = new Label
			openLabel.x = 8;
			openLabel.y = 6;
			openLabel.text = CJLang("ACTFB_UNOPEN")
			openLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatopen;
			this.addChild(openLabel)
			
			leftTimeText = new Label
			leftTimeText.x = 188;
			leftTimeText.y = 6;
			leftTimeText.text = CJLang("ACTFB_LEFTTIMES")+":";
			leftTimeText.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			this.addChild(leftTimeText)
			
			leftTimeLabel = new Label
			leftTimeLabel.x = 242;
			leftTimeLabel.y = 6;
			leftTimeLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			this.addChild(leftTimeLabel)
				
			var descBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("liaotian_wenzidikuang"),new Rectangle(8,8,1,1)))
			descBg.width = 270;
			descBg.height = 17;
			descBg.x = 8;
			descBg.y = 27;
			this.addChild(descBg)
				
			descLabel = new Label
			descLabel.x = 8
			descLabel.y = 28;
			descLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			this.addChild(descLabel);
			
			vitText = new Label
			vitText.x = 188
			vitText.y = 27;
			vitText.text = CJLang("MAIN_UI_STRENGTH")
			vitText.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			this.addChild(vitText);
			
			vitLabel = new Label;
			vitLabel.x = 220
			vitLabel.y = 27;
			vitLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			this.addChild(vitLabel);
		}
		
		override protected function draw():void
		{
			super.draw();
			btn.defaultSkin = openbg
			openLabel.text = CJLang(data['name']);
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			vitLabel.text = data['gvit']+"/"+role.vit;
			descLabel.text = CJLang(data['desc']);
			if(data["num"]<=0 || role.vit<data['gvit'])
			{
				btn.defaultSkin = unopenbg
				leftTimeText.textRendererProperties.textFormat = ConstTextFormat.actItemContenttextformatopen;
				leftTimeLabel.textRendererProperties.textFormat = ConstTextFormat.actItemContenttextformatopen;
				vitText.textRendererProperties.textFormat = ConstTextFormat.actItemContenttextformatopen;
				vitLabel.textRendererProperties.textFormat = ConstTextFormat.actItemContenttextformatopen;
			}
			else
			{
				leftTimeText.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
				leftTimeLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
				vitText.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
				vitLabel.textRendererProperties.textFormat = ConstTextFormat.actItemtextformatdesc;
			}
			leftTimeLabel.text = data["num"]+CJLang("ACTFB_CI");
//			icon.texture = SApplication.assets.getTexture(data['icon']);
//			icon.scaleX = icon.scaleY = 0.75
//			icon.readjustSize();
		}
		
		override protected function onSelected():void
		{
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			if(data["num"]<=0)
			{
				CJMessageBox(CJLang("ACTFB_NONUMS"));
				return;
			}
			if(role.vit<data['gvit'])
			{
				ConstDynamic.isEnterFromFuben = 0;
				CJConfirmMessageBox(CJLang("FUBEN_ENTER_NOVIT"),function():void
				{
					
				},function():void
				{
					(CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben).buyVit();
				},CJLang("COMMON_TRUE"),CJLang("FUBEN_BUYVIT_BTN"));
				return;
			}
			ConstDynamic.isEnterFromFuben = ConstDynamic.ENTER_FROM_ACTFB;
			_dataEnterGuanqia.fubenId = data['fid'];
			_dataEnterGuanqia.guanqiaId = data['gid'];
			_dataEnterGuanqia.firstFightId = data['fzid'];
			CJFbUtil.enterFb()
			SApplication.moduleManager.exitModule("CJActiveFbModule");
		}
			
	}
}