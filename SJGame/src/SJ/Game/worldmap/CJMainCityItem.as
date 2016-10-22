package SJ.Game.worldmap
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.fuben.CJFubenTaskGuidIcon;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class CJMainCityItem extends CJAbstractItem
	{
		private var cityName:Label; 
		private var barName:Label;
		private var levelOpen:Label;
		private var _id:int;
		public function CJMainCityItem()
		{
			super("CJMainCityItem",false);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var descBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("liaotian_wenzidikuang"),new Rectangle(8,8,1,1)));
			descBg.width = 310;
			descBg.height = 20;
			descBg.x = 10;
			descBg.y = 5;
			this.addChild(descBg);
			
			cityName = new Label;
			cityName.x = 10;
			cityName.y = 6;
			cityName.textRendererProperties.textFormat = ConstTextFormat.worldmapcityname;
			this.addChild(cityName);
			
			barName = new Label;
			barName.x = 240;
			barName.y = 9;
			this.addChild(barName);
			
			levelOpen = new Label;
			levelOpen.x = 24;
			levelOpen.y = 30;
			levelOpen.textRendererProperties.textFormat = ConstTextFormat.worldmaplevelopen;
			this.addChild(levelOpen);
			
		}
		
		override protected function draw():void
		{
			cityName.text = data['name'];
			barName.text = data['barname'];
			var textformat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, int(data['barnamecolor']));
			barName.textRendererProperties.textFormat = textformat;
			var level:String = CJDataManager.o.DataOfHeroList.getMainHero().level;
			if(int(level) < data['openlevel'])
			{
				levelOpen.text = data['openlevel']+CJLang("WORLDMAP_LEVELOPEN");
			}
			this._id = data['id'];
			if(data['taskid'] == data['id'])
			{
				var guidIcon:CJFubenTaskGuidIcon = new CJFubenTaskGuidIcon
					guidIcon.x = 150;
					this.addChild(guidIcon);
			}
		}
		
		override protected function onSelected():void
		{
			this.dispatchEventWith("click",true,data['id'])
		}
	}
}