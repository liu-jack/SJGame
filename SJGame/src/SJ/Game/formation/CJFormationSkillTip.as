package SJ.Game.formation
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 +------------------------------------------------------------------------------
	 * 点击技能弹出tip框
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-7-10 上午9:03:42  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationSkillTip extends SLayer
	{
		private var _config:Json_skill_setting;
		private static var WIDTH:Number = 175;
		private static var HEIGHT:Number = 120;

		private var logo:ImageLoader;

		private var skillName:Label;

		private var skillDesc:Label;

		private var btn:Button;
		private var _quad:DisplayObject;
		
		public function CJFormationSkillTip()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
			this.width = WIDTH;
			this.height = HEIGHT;
		}
		
		private function drawContent():void
		{
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.x = -( SApplicationConfig.o.stageWidth - WIDTH)/2; 
			_quad.y = -( SApplicationConfig.o.stageHeight - HEIGHT)/2; 
			_quad.addEventListener(TouchEvent.TOUCH, onClickQuad);
			this.addChild(_quad);
			//背景
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tishikuang") , new Rectangle(16, 16, 1, 1)));
			bg.width = WIDTH;
			bg.height = HEIGHT;
			this.addChild(bg);
			//图标底
			var logoBack:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tubiaokuang1") , new Rectangle(15,15 , 1,1)));
			logoBack.x = WIDTH - 58;
			logoBack.y = 8;
			logoBack.width = 50;
			logoBack.height = 50;
			this.addChild(logoBack);
			//技能图标
			logo = new ImageLoader();
			logo.x = WIDTH - 53 ;
			logo.y = 12;
			logo.width = 40;
			logo.height = 40;
			this.addChild(logo);
			//技能名称文字
			skillName = _createLable(8 , 12 , 120 , 20);
			skillName.textRendererFactory = _genRender;
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFFEF3A;
			skillName.textRendererProperties.textFormat = tf;
			this.addChild(skillName);
			//描述头
			var descTitle:Label = _createLable(8 , 40 , 70 , 20);
			descTitle.textRendererProperties.textFormat = new TextFormat(null, null, 0xFFFFFF);
			descTitle.text = CJLang("HORSE_ITEMDES")+":";
			this.addChild(descTitle);
			//描述内容
			skillDesc = _createLable(8 , 60 , 155 , 50);
			skillDesc.textRendererFactory = _genRender;
			skillDesc.text = "";
			this.addChild(skillDesc);
		}
		
		private function onClickQuad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this._quad, TouchPhase.ENDED);
			if (!touch)
			{
				return;
			}
			this.removeFromParent();
		}
		
		private function _createLable(x:Number , y:Number , width:Number , height:Number):Label
		{
			var l:Label = new Label();
			l.x = x;
			l.y = y;
			l.width = width;
			l.height = height;
			return l;
		}
		
		private function _genRender():ITextRenderer
		{
			var tr:TextFieldTextRenderer = new TextFieldTextRenderer();
			tr.wordWrap = true;
			tr.width = 120;
			tr.maxWidth = 50;
			tr.isHTML = true;
			var tf:TextFormat = new TextFormat(); 
			tf.color = 0xBFB26A;
			tr.textFormat = tf;
			return tr;
		}
		
		public function addToLayer():void
		{
			CJLayerManager.o.addModuleLayer(this);
		}
		
		private function _close(e:Event):void
		{
			removeFromParent();
		}
		
		override protected function draw():void
		{
			super.draw();
			logo.source = SApplication.assets.getTexture(_config.skillicon);	
			skillName.text = CJLang(config.skillname);
//			skillDesc.text = CJLang(config.skilldes);
			skillDesc.text = config.skilldes;
		}

		public function get config():Json_skill_setting
		{
			return _config;
		}

		public function set config(value:Json_skill_setting):void
		{
			if(this._config && this._config.skillid == value.skillid)
			{
				return;
			}
			_config = value;
			this.invalidate();
		}
	}
}