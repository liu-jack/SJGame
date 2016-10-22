package SJ.Game.NPCDialog
{
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
		
	/**
	 *  剧情
	 * @author yongjun
	 * 
	 */	
	public class CJNPCTaskDialogLayer extends SLayer
	{
		private var _npcImage:ImageLoader;
		private var _roleImage:ImageLoader;
		private var _npcTalkLabel:CJNPCNameItem;
		private var _roleTalkLabel:CJNPCNameItem;
		//对话内容label		
		private var _talkLabel:Label
		private var _contentLayer:SLayer
		//结束后的回调函数
		private var _callBack:Function
		//此任务对话所有内容
		private var _talkContent:Array
		//当前NPC对话内容
		private var _currentContent:Array
		//当前对话内容
		private var _currentContentWords:Array = new Array;
		//当前对话的NPCid
		private var _currentNpcId:int
		
		private var _currentTimeOutId:uint;
		
		private var _PORTRAIT_WIDTH:Number = 140;
		private var _PORTRAIT_HEIGHT:Number = 160;
		
		public function CJNPCTaskDialogLayer()
		{
			super();
			var quad:Quad = new Quad(SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight,0x000000);
			quad.alpha = 0.1;
			this.addChild(quad);
			this.setSize(SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight)
			this.addEventListener(TouchEvent.TOUCH,touchHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,_start);
			_init();
		}
		
		public function _init():void
		{
			_initNpcImg();
			_contentLayer = new SLayer;
			_contentLayer.y = SApplicationConfig.o.stageHeight - 66;
			this.addChild(_contentLayer);
			_initName();
			_initBg()
			_initActionLabel();
			_initRoleId();
		}
		
		private function _initName():void
		{
			_npcTalkLabel = new CJNPCNameItem;
			_npcTalkLabel.x = 0;
			_npcTalkLabel.y = -20;
			_contentLayer.addChild(_npcTalkLabel);
			_roleTalkLabel = new CJNPCNameItem;
			_roleTalkLabel.x = SApplicationConfig.o.stageWidth - 108;
			_roleTalkLabel.y = -20;
			_contentLayer.addChild(_roleTalkLabel);
		}
		private function _initNpcImg():void
		{
			_npcImage = new ImageLoader;
			_npcImage.name = "npcimage";
			this.addChild(_npcImage)
			_roleImage = new ImageLoader;
			_roleImage.name = "roleimage";
			this.addChild(_roleImage)
		}
		
		private function _initBg():void
		{
			var bgFrame:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgFrame.width = SApplicationConfig.o.stageWidth;
			bgFrame.height = 66;
			_contentLayer.addChild(bgFrame);
			
			var bgFramebg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi") , new Rectangle(19,19,1,1)));
			bgFramebg.width = SApplicationConfig.o.stageWidth-5;
			bgFramebg.height = 61;
			bgFramebg.x = 2;
			bgFramebg.y = 2;
			_contentLayer.addChild(bgFramebg);

			_talkLabel = new Label;
			_talkLabel.textRendererProperties.textFormat = ConstTextFormat.taskdialogtextformatwhite
			_talkLabel.textRendererProperties.wordWrap = true;
			_talkLabel.width = 450
			_talkLabel.x = 25;
			_talkLabel.y = 8;
			_contentLayer.addChild(_talkLabel);
		}
		
		private function _initActionLabel():void
		{
			var passLabel:Label = new Label;
			passLabel.textRendererProperties.textFormat = ConstTextFormat.textformat;
			passLabel.text = CJLang("NPCDIALOG_PASS");
			passLabel.x = 20;
			passLabel.y = 44;
			passLabel.name = "pass"
			passLabel.addEventListener(TouchEvent.TOUCH,_touchLabelHandler);
			_contentLayer.addChild(passLabel)
			var continueLable:Label = new Label;
			continueLable.textRendererProperties.textFormat = ConstTextFormat.textformat;
			continueLable.text = CJLang("NPCDIALOG_CONTINUE");
			continueLable.x = 420;
			continueLable.y = 44;
			continueLable.name = "continue"
			continueLable.addEventListener(TouchEvent.TOUCH,_touchLabelHandler);
			_contentLayer.addChild(continueLable)
		}
		
		public function set npcId(id:int):void
		{
			if(id != _currentNpcId)
			{
				_currentNpcId = id;
				var heroConfig:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(id);
				var herobattle:Json_hero_battle_propertys =  CJDataOfHeroPropertyList.o.getBattleProperty(heroConfig.resourceid);
				var texturename:String = "banshenxiang_"+herobattle.texturename
				var texture:Texture = SApplication.assets.getTexture(texturename);
				var region:Rectangle = SApplication.assets.getAtlasTextureRegion(texturename);
				if(texture)
				{
					_npcImage.source = texture;
					var originalWidth:Number = texture.width;
					var originalHeight:Number = texture.height;
					
					var ratioWidth:Number = _PORTRAIT_WIDTH / originalWidth ;
					var ratioHeight:Number =  _PORTRAIT_HEIGHT / originalHeight;
					
					var ratio:Number = Math.max(ratioWidth , ratioHeight);
					

					
					_npcImage.pivotX = 0 - texture.frame.x;
					_npcImage.pivotY = region.height - texture.frame.y;
					
					_npcImage.x = 0
					_npcImage.y = SApplicationConfig.o.stageHeight - 66;
					_npcImage.scaleX = _npcImage.scaleY = 1.4;
				}
				_npcTalkLabel.npcname = CJLang(heroConfig.name)
				_npcTalkLabel.visible = false;
			}
		}
		
		public function set callBack(func:Function):void
		{
			_callBack = func
		}
		private var _heroConfig:CJDataHeroProperty
		public function _initRoleId():void
		{
			var heroList:CJDataOfHeroList = CJDataManager.o.getData("CJDataOfHeroList") as CJDataOfHeroList;
			var roleId:String = heroList.getRoleId();
			var roleConf:CJDataOfHero = heroList.getHero(roleId);
			_heroConfig = roleConf.heroProperty;//CJDataOfHeroPropertyList.o.getProperty("20008");
			var herobattle:Json_hero_battle_propertys =  CJDataOfHeroPropertyList.o.getBattleProperty(_heroConfig.resourceid);
			var texturename:String = "banshenxiang_"+herobattle.texturename;
			var texture:Texture = SApplication.assets.getTexture(texturename);
			var region:Rectangle = SApplication.assets.getAtlasTextureRegion(texturename);
			if(texture)
			{
				_roleImage.source = texture;
				
				var originalWidth:Number = texture.width;
				var originalHeight:Number = texture.height;
				
				var ratioWidth:Number = _PORTRAIT_WIDTH / originalWidth ;
				var ratioHeight:Number =  _PORTRAIT_HEIGHT / originalHeight;
				
				var ratio:Number = Math.max(ratioWidth , ratioHeight);
				
				_roleImage.pivotX = region.width - texture.frame.x;
				_roleImage.pivotY = region.height - texture.frame.y;
				
				_roleImage.x = SApplicationConfig.o.stageWidth
				_roleImage.y = SApplicationConfig.o.stageHeight - 66;
				_roleImage.scaleX = _roleImage.scaleY = 1.4;
			}
			_roleTalkLabel.npcname = CJLang("STORY_WO")
		}
		
		public function setTalkContent(content:Array):void
		{
			_talkContent = content
		}
		/**
		 * 放大半身像 
		 * @param npcImage
		 * 
		 */		
		private function _ZoomOut(npcImage:ImageLoader):void
		{
			if(npcImage.name == "npcimage")
			{
				_npcImage.visible = true;
				_roleImage.visible = false;
				_npcTalkLabel.visible = true;
				_roleTalkLabel.visible = false;
			}
			else
			{
				_roleImage.visible = true;
				_npcImage.visible = false;
				_npcTalkLabel.visible = false;
				_roleTalkLabel.visible = true;
			}
		}
		/**
		 * 每100ms显示出一个字 
		 * 
		 */		
		private function _showTalkWords():void
		{
			if(_currentContentWords.length == 0) return;
			_currentTimeOutId = setTimeout(function():void
			{
				var worlds:String = _currentContentWords.shift()
				_talkLabel.text = _talkLabel.text + worlds;
				if(_currentContentWords.length > 0)
				{
					_showTalkWords();
				}
			},10)
		}
		
		private function showAll():void
		{
			if(_currentContentWords.length == 0)
			{
				this._next();
				return;
			}
			clearTimeout(this._currentTimeOutId);
			_talkLabel.text = _talkLabel.text + _currentContentWords.join("");
			_currentContentWords.splice(0);
		}
		
		private function _touchLabelHandler(e:TouchEvent):void
		{
			if(!e.currentTarget is Label)return;
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN)
			if(touch)
			{
				var label:Label = e.currentTarget as Label
				switch(label.name)
				{
					case "pass":
						_end();
						break;
					case "continue":
						_next();
						break;
				}
				e.stopImmediatePropagation();
			}
		}
		
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if(touch)
			{
				showAll();
			}
		}
		private var i:int = 0;
		public function _start(e:Event = null):void
		{
			if(_talkContent.length == 0)
			{
				_end();
				return;
			}
			var content:String = _talkContent.shift()
			if(i%2 == 0)
			{
				_ZoomOut(_roleImage)
			}
			else
			{
				_ZoomOut(_npcImage)
			}
			i++;
			_currentContent =  content.split("&");
			_next();
		}
		/**
		 * 下一句话 
		 * 
		 */		
		private function _next():void
		{
			_currentContentWords.splice(0);
			_talkLabel.text = "";
			
			if(_currentContent.length >0)
			{
				var content:String = CJLang(_currentContent.shift());
				_currentContentWords = content.split("");
				_currentContentWords = filterArray(_currentContentWords);
				_talkLabel.text = _currentContentWords.shift();
				_showTalkWords();
			}
			else
			{
				_start();
			}
		}
		
		private function filterArray(arr:Array):Array
		{
			var narr:Array = new Array;
			for each(var i:String in arr)
			{
				if(i==String(undefined))
					continue;
				narr.push(i);
			}
			return narr;
		}
		
		/**
		 * 结束 
		 * 
		 */		
		private function _end():void
		{
			i = 0;
			SApplication.moduleManager.exitModule("CJNPCTaskDialogMoudle");
			if(_callBack!=null)
			{
				_callBack();
			}
		}
		
		override public function dispose():void
		{
			this.removeEventListener(TouchEvent.TOUCH,touchHandler);
			this.removeEventListener(Event.ADDED_TO_STAGE,_start);
			
			super.dispose();
		}
	}
}