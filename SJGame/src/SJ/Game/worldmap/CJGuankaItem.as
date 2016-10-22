package SJ.Game.worldmap
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.fuben.CJFubenTaskGuidIcon;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJGuankaItem extends CJAbstractItem
	{
		private var guankaName:Label;
		private var vitName:Label;
		private var status:Label;
		private var desc:Label;
		private var guidIcon:CJFubenTaskGuidIcon;
		//未通关 ，不能进入
		public static var GUANKA_UNPASS:int = 0;
		//未通关，可进入
		public static var GUANKA_CANENTER:int = 1;
		//已通关
		public static var GUANKA_PASS:int = 2;
		public function CJGuankaItem()
		{
			super("CJGuankaItem", false);
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
			
			var owner:CJGuankaItem = this;
			var tipBtn:Button = new Button;
//			tipBtn.defaultIcon = new SImage(SApplication.assets.getTexture("fuben_i"));
			tipBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			tipBtn.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			tipBtn.defaultLabelProperties.textFormat = new TextFormat("Arial", 14, 0xEDDB94);
			tipBtn.label = CJLang("FUBEN_DIAOLUOLABLE");
			tipBtn.width = 58;
			tipBtn.height = 18;
			tipBtn.addEventListener(TouchEvent.TOUCH,function(e:TouchEvent):void
			{
				var touch:Touch = e.getTouch(owner);
				if(touch == null)
				{
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					e.stopImmediatePropagation();
					dispatchEventWith("showGuankaTip",true,data);
				}
			});
			tipBtn.x = 295;
			tipBtn.y = 28;
			this.addChild(tipBtn);
				
			guankaName = new Label;
			guankaName.x = 10;
			guankaName.y = 6;
			guankaName.textRendererProperties.textFormat = ConstTextFormat.worldmapcityname;
			this.addChild(guankaName);
			
			vitName = new Label;
			vitName.x = 231;
			vitName.y = 30;
			
			vitName.textRendererProperties.textFormat = ConstTextFormat.worldguankaVit;
			this.addChild(vitName);
			
			desc = new Label;
			desc.x = 226;
			desc.y = 6;
			desc.width = 84;
			desc.textRendererProperties.textFormat = ConstTextFormat.worldmapguankadesc;
			this.addChild(desc);
			
			status = new Label;
			status.x = 24;
			status.y = 30;

			this.addChild(status);
			this.touchable = true;
			
			guidIcon = new CJFubenTaskGuidIcon;
			guidIcon.x = 150;
			guidIcon.visible = false;
			this.addChild(guidIcon);
		}
		
		override protected function draw():void
		{
			guankaName.text = data['name'];
			vitName.text = CJLang("FUBEN_VITTEXT")+":"+data['needvit'];
			desc.text = data['desc'];
			if(data['code'] == GUANKA_UNPASS)
			{
				status.textRendererProperties.textFormat = ConstTextFormat.worldmaplevelopen;
				status.text = data['level']+CJLang("WORLDMAP_LEVELOPEN");
				this.touchable = false;
			}
			if(data['code'] == GUANKA_CANENTER)
			{
				status.textRendererProperties.textFormat = ConstTextFormat.worldmapnewopen;
				status.text = CJLang("WORLDMAP_NEWOPEN");
			}
			if(data['code'] == GUANKA_PASS)
			{
				status.textRendererProperties.textFormat = ConstTextFormat.worldmappass;
				status.text = CJLang("WORLDMAP_HASPASS");
			}
			if(data['taskgid'] == data['id'])
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
			this.dispatchEventWith("click",true,data['id'])
		}
	}
}