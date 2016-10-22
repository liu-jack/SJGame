package SJ.Game.fristBattle
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Label;
	
	import flash.geom.Rectangle;
	
	import starling.textures.Texture;
	
	public class CJFristBattleDialogNpcHeadLayer extends SLayer
	{
		
		public function CJFristBattleDialogNpcHeadLayer()
		{
			super();
		}
		
		private var _left:Boolean = true;
		private var _nameLabel:Label;
		private var _PORTRAIT_WIDTH:Number = 140;
		private var _PORTRAIT_HEIGHT:Number = 160;
		
		
		private var _npcid:int = -1;
		private var _npcname:String = "";
		private var _npctexturename:String = "";
		private var _npcimage:SImage;
		private var _bgimage:SImage;
		private var _nameicon:SImage;
		
		
		override protected function draw():void
		{
			if(isInvalid())
			{
				_nameLabel.text = _npcname;
				
				
				
				if(SStringUtils.isEmpty(_npctexturename) == false)
				{
					var texture:Texture = SApplication.assets.getTexture(_npctexturename);
					var region:Rectangle = SApplication.assets.getAtlasTextureRegion(_npctexturename);
				
					if(texture)
					{
						if(_npcimage != null)
						{
							_npcimage.removeFromParent(true);
						}
						_npcimage = new SImage(texture);
						addChildAt(_npcimage,0);
						
						
						var originalWidth:Number = texture.width;
						var originalHeight:Number = texture.height;
						var ratioWidth:Number = _PORTRAIT_WIDTH / originalWidth ;
						var ratioHeight:Number =  _PORTRAIT_HEIGHT / originalHeight;
						var ratio:Number = Math.max(ratioWidth , ratioHeight);
						_npcimage.pivotX = 0 - texture.frame.x;
						_npcimage.pivotY = region.height - texture.frame.y;
						_npcimage.scaleX = _npcimage.scaleY = 1.4;
						//这里的坐标系不对
					}
					
				}
				
				if(_left)
				{
					_bgimage.x = 0;
					_npcimage.x = 0;
					
				}
				else
				{
					_npcimage.x = -_npcimage.texture.width*_npcimage.scaleX;
					_bgimage.x = -_bgimage.texture.frame.width;
				}
				_npcimage.y = 2;
				_bgimage.y = -20;
				_nameicon.x = _bgimage.x + 20;
				_nameLabel.x = _bgimage.x + 40;
				
			}
			super.draw();
		}
		
		override protected function initialize():void
		{
			_npcimage = new SImage(Texture.empty(1,1),true);
			
		 	_bgimage = new SImage(SApplication.assets.getTexture("npcduihua_mingchengdi"));
			_bgimage.y = -20;
			addChild(_bgimage);
			
			_nameicon = new SImage(SApplication.assets.getTexture("npcduihua_biao"));
			_nameicon.x = 21;
			_nameicon.y = 2 + _bgimage.y;
			addChild(_nameicon);
			
			_nameLabel = new Label;
			_nameLabel.textRendererProperties.textFormat = ConstTextFormat.npcdialognameformat;
			_nameLabel.x = 40;
			_nameLabel.y = 3 + _bgimage.y;
			_nameLabel.text = _npcname;
			
			this.addChild(_nameLabel)
			super.initialize();
		}

		public function get npcid():int
		{
			return _npcid;
		}

		public function set npcid(value:int):void
		{
			_npcid = value;
			var playerdata:CJPlayerData = new CJPlayerData();
			playerdata.templateId = _npcid;
			var heroConfig:CJDataHeroProperty = playerdata.heroConfig;
			var herobattle:Json_hero_battle_propertys =  playerdata.heroBattleConfig;
			_npctexturename = "banshenxiang_"+herobattle.texturename;
			
			
			invalidate();
		}

		public function get npcname():String
		{
			return _npcname;
		}

		public function set npcname(value:String):void
		{
			_npcname = value;
			invalidate();
		}

		public function get left():Boolean
		{
			return _left;
		}

		public function set left(value:Boolean):void
		{
			_left = value;
			invalidate();
		}
		
		
		
		
	}
}