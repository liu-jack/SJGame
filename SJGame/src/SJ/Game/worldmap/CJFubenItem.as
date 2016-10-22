package SJ.Game.worldmap
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfFubenProperty;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.fuben.CJFubenTaskGuidIcon;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	public class CJFubenItem extends CJAbstractItem
	{
		
		private var fname:Label;
		private var desc:Label;
		private var status:Label;
		private var guidIcon:CJFubenTaskGuidIcon
		public function CJFubenItem(name:String, multiSelection:Boolean)
		{
			super(name, multiSelection);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var descBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("liaotian_wenzidikuang"),new Rectangle(8,8,1,1)));
			descBg.width = 363;
			descBg.height = 20;
			descBg.x = 10;
			descBg.y = 5;
			this.addChild(descBg);
			
			fname = new Label;
			fname.x = 10;
			fname.y = 6;
			fname.textRendererProperties.textFormat = ConstTextFormat.worldmapcityname;
			this.addChild(fname);
			
			desc = new Label;
			desc.x = 259;
			desc.y = 9;
			desc.textRendererProperties.textFormat = ConstTextFormat.worldmapguankaname;
			this.addChild(desc);
			
			status = new Label;
			status.x = 24;
			status.y = 30;
			this.addChild(status);
			
			guidIcon = new CJFubenTaskGuidIcon;
			guidIcon.visible = false;
			guidIcon.x = 150;
			this.addChild(guidIcon);
		}
		
		override protected function draw():void
		{
			fname.text = data['name'];
			desc.text = data['desc'];
			
			if(data['ret'] == 1)
			{
				if(data['ispass'] == 1)
				{
					status.text = CJLang("WORLDMAP_HASPASS");
					status.textRendererProperties.textFormat = ConstTextFormat.worldmappass;
				}
				else
				{
					status.text = CJLang("WORLDMAP_NEWOPEN");
					status.textRendererProperties.textFormat = ConstTextFormat.worldmapnewopen;
				}
			}
			else
			{
				this.touchable = false;
				var fubenConf:Json_fuben_config = CJDataOfFubenProperty.o.getPropertyById(data['id']);
				status.text = fubenConf.openvalue+CJLang("WORLDMAP_LEVELOPEN");
				status.textRendererProperties.textFormat = ConstTextFormat.worldmaplevelopen;
			}
			if(data['taskid'] == data['id'])
			{
				guidIcon.visible = true;
			}
			else
			{
				guidIcon.visible = false;
			}
		}
		
		override protected function onSelected():void
		{
			this.dispatchEventWith("click",true,data)
		}
	}
}