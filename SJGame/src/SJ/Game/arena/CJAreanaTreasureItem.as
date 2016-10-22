package SJ.Game.arena
{
	import SJ.Game.data.json.Json_arena_box_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	
	import starling.display.Shape;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 宝箱单个显示界面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-7-13 上午11:34:50  
	 +------------------------------------------------------------------------------
	 */
	public class CJAreanaTreasureItem extends SLayer
	{
		private var _icon:SImage;
		private var _boxName:Label;
		private var _rankLabel:Label;
		private var _rewardTitle:Label;
		private var _rewardContent:Label;
		private var _line:Shape;
		private var _config:Json_arena_box_setting;
		
		private var ITEMWIDTH:Number = 240;
		private var ITEMHEIGHT:Number = 36;
		
		public function CJAreanaTreasureItem(config:Json_arena_box_setting)
		{
			super();
			this._config = config;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
		}
		
		private function drawContent():void
		{
			this.width = ITEMWIDTH;
			this.height = ITEMHEIGHT;
			
			this._drawBoxIcon();
			this._drawBoxName();
			this._drawRank();
			this._drawReward();
			this._drawLine();
		}
		
		private function _drawLine():void
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1 , 0x403F3D);
			shape.graphics.moveTo(15 , ITEMHEIGHT );
			shape.graphics.lineTo(290 , ITEMHEIGHT);
			this.addChild(shape);
		}
		
		private function _drawReward():void
		{
			_rewardTitle = new Label();
			var tf:TextFormat = new TextFormat();
			tf.color = 0x89C362;
			_rewardTitle.textRendererProperties.textFormat = tf;
			_rewardTitle.x = 45;
			_rewardTitle.y = 18;
			_rewardTitle.text = CJLang("NPCDIALOG_REWARD")+CJLang("NPCDIALOG_YINGLIANG")+": ";
			this.addChild(_rewardTitle);
			
			_rewardContent = new Label();
			_rewardContent.textRendererProperties.textFormat = tf;
			_rewardContent.x = 99;
			_rewardContent.y = 18;
			_rewardContent.text = ""+_config.silvermin+"-"+_config.silvermax+CJLang("NPCDIALOG_YINGLIANG")+", "
								+_config.creditmin+"-"+_config.creditmax+CJLang("MALL_TYPE_CREDIT");
			this.addChild(_rewardContent);
		}
		
		private function _drawRank():void
		{
			_rankLabel = new Label();
			var tf:TextFormat = new TextFormat();
			tf.color = _config.fontcolor;
			_rankLabel.textRendererProperties.textFormat = tf;
			_rankLabel.x = 95;
			_rankLabel.y = 4;
			_rankLabel.text = "("+CJLang("ARENA_BOX_RANK")+_config.rankstart+"-"+_config.rankend+")";
			this.addChild(_rankLabel);
		}
		
		private function _drawBoxIcon():void
		{
			//技能图标
			this._icon = new SImage(SApplication.assets.getTexture("jingjichang_baoxiang0"+_config.id));
			this._icon.x = 5;
			this._icon.y = 3;
			this.addChild(this._icon);
		}
		
		private function _drawBoxName():void
		{
			_boxName = new Label();
			var tf:TextFormat = new TextFormat();
			tf.color = _config.fontcolor;
			_boxName.textRendererProperties.textFormat = tf;
			_boxName.x = 45;
			_boxName.y = 4;
			_boxName.text = CJLang(_config.name);
			this.addChild(_boxName);
		}
	}
}