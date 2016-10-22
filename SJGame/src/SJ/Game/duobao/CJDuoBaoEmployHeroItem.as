package SJ.Game.duobao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_propertys;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 雇佣-武将列表item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-7 下午5:01:41  
	 +------------------------------------------------------------------------------
	 */
	public class CJDuoBaoEmployHeroItem extends CJItemTurnPageBase
	{
		private var _jobImg:ImageLoader;
		
		private var _level:Label;
		/*武将名称*/
		private var _fname:Label;
		/*战斗力*/
		private var _zhandouli:Label;
		
		public const ITEMWIDTH:int = 200;
		
		public const ITEMHEIGHT:int = 35;
		
		private var _selectedMask:Scale9Image;
		
		public function CJDuoBaoEmployHeroItem()
		{
			super("CJDuoBaoEmployHeroItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _addEventListeners():void
		{
			
		}
		
		private function _drawContent():void
		{
			this.width = ITEMWIDTH;
			this.height = ITEMHEIGHT;
			
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("huodong_dikuang01"),new Rectangle(5 , 25 , 1 , 1)));
			bg.width = ITEMWIDTH - 10;
			bg.height = ITEMHEIGHT;
			this.addChild(bg);
			
			_jobImg = new ImageLoader();
			_jobImg.x = -2;
			_jobImg.y = 5;
			_jobImg.scaleX = _jobImg.scaleY = 1.2;
			this.addChild(_jobImg);
			
			var lv:Label = new Label();
			lv.textRendererFactory = textRender.standardTextRender;
			lv.textRendererProperties.textFormat = new TextFormat("黑体",12,0xFFF31E);
			lv.text = "LV.";
			lv.x = 26;
			lv.y = 10;
			this.addChild(lv);
			
			_level = new Label();
			_level.textRendererFactory = textRender.standardTextRender;
			_level.textRendererProperties.textFormat = new TextFormat("黑体",12,0xFFF31E);
			_level.text = "0";
			_level.x = 40;
			_level.y = 10;
			this.addChild(_level);
			
			_fname = new Label();
			_fname.textRendererFactory = textRender.standardTextRender;
			_fname.textRendererProperties.textFormat = new TextFormat("黑体",12,0x8FFF15);
			_fname.text = "";
			_fname.x = 60;
			_fname.y = 10;
			this.addChild(_fname);
			
			_zhandouli = new Label();
			_zhandouli.textRendererFactory = textRender.standardTextRender;
			_zhandouli.textRendererProperties.textFormat = new TextFormat("黑体",12,0xFF8C14);
			_zhandouli.text = "";
			_zhandouli.x = 100;
			_zhandouli.y = 10;
			this.addChild(_zhandouli);
			
			_selectedMask = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture('zhuzhanhaoyou_xuanzhong') ,new Rectangle(8,8,1,1)));
			_selectedMask.width = ITEMWIDTH - 3;
			_selectedMask.height = ITEMHEIGHT;
			this.addChild(_selectedMask);
			_selectedMask.visible = false;
		}
		
		/**
		 * 选中发事件
		 */ 
		override protected function onSelected():void
		{
			super.onSelected();
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_DUOBAO_SELECTHERO , false , this.data);
			_selectedMask.visible = true;
		}
		
		override protected function draw():void
		{
			super.draw();
			if(!this.data)
			{
				return;
			}
			
			var config:Json_hero_propertys = CJDataOfHeroPropertyList.o.getProperty(data.templateid);
			if(!config)
			{
				return;
			}
			_level.text = "" + data.level;
			_fname.text = "<font color='"+ConstHero.ConstHeroNameColorString[config.quality] +"'>" + CJLang(config.name) +"</font>";
			_zhandouli.text = "("+CJLang('ITEM_TOOLTIP_ZHANDOULI')+" "+int(data.battleeffect)+")";
			
			_jobImg.source = SApplication.assets.getTexture("haoyou_zhiye" + config.job);
			
			if(CJDataManager.o.DataOfDuoBaoEmploy.tempSelectHeroid != data.prop.heroid)
			{
				_selectedMask.visible = false;
			}
		}
	}
}