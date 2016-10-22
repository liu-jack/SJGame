package SJ.Game.fuben
{
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class CJFubenHangLayer extends SLayer
	{
		private var _guankadesc:Label
		private var _labellevel:Label
		private var _guajibtn:Button
		private var _labeltishi:Label
		private var _btnClose:Button
		
		private var _bgFrame:Scale9Image
		private var _titleBg:Scale9Image;
		private var _selectBg:Scale9Image;
		private var _timeBg:Scale9Image;
		private var _hangTextBg:Scale9Image;
		
		private var _selectTitleImg:SImage;
		private var _guajiTitleImg:SImage;
		
		public function CJFubenHangLayer()
		{
			super();
		}
		
		public function get guankadesc():Label
		{
			return this._guankadesc;
		}
		public function set guankadesc(label:Label):void
		{
			this._guankadesc = label;
		}
		public function get labellevel():Label
		{
			return this._labellevel;
		}
		public function set labellevel(label:Label):void
		{
			_labellevel = label
		}
		public function get guajibtn():Button
		{
			return this._guajibtn;
		}
		public function set guajibtn(btn:Button):void
		{
			_guajibtn = btn
		}
		public function get labeltishi():Label
		{
			return this._labeltishi;
		}
		public function set labeltishi(label:Label):void
		{
			_labeltishi = label
		}
		public function get btnClose():Button
		{
			return _btnClose;
		}
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		override protected function initialize():void
		{
			_drawContent();
		}
		private function _drawContent():void
		{
			//界面底图
			this._bgFrame= new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tishi0"),new Rectangle(4,4,1,1)));
			this._bgFrame.width = 335;
			this._bgFrame.height = 222;
			this.addChildAt(this._bgFrame,0);
			this.setSize(this._bgFrame.width,this._bgFrame.height);
			//挂机
			_titleBg =  new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_di2"),new Rectangle(6,6,2,2)));
			this._titleBg.width = 153;
			this._titleBg.height = 43;
			_titleBg.x = 11;
			_titleBg.y = 12;
			this.addChildAt(this._titleBg,1);
			//选择挂机背景
			_selectBg =  new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_di2"),new Rectangle(6,6,2,2)));
			this._selectBg.width = 153;
			this._selectBg.height = 94;
			_selectBg.x = 11;
			_selectBg.y = 69;
			this.addChildAt(this._selectBg,2);
			
			_timeBg =  new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_di2"),new Rectangle(6,6,2,2)));
			this._timeBg.width = 61;
			this._timeBg.height = 24;
			_timeBg.x = 11;
			_timeBg.y = 187;
			this.addChildAt(this._timeBg,3);
			
			_hangTextBg =  new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_di2"),new Rectangle(6,6,2,2)));
			this._hangTextBg.width = 154;
			this._hangTextBg.height = 142;
			_hangTextBg.x = 170;
			_hangTextBg.y = 70;
			this.addChildAt(this._hangTextBg,4);
			
			_selectTitleImg = new SImage(SApplication.assets.getTexture("fuben_biantiao"));
			_selectTitleImg.x = 11;
			_selectTitleImg.y = 69;
			this.addChild(_selectTitleImg);
			
			_guajiTitleImg = new SImage(SApplication.assets.getTexture("fuben_biantiao"));
			_guajiTitleImg.x = 170;
			_guajiTitleImg.y = 69;
			this.addChild(_guajiTitleImg);
			
			var lunshuLabel:Label = new Label;
			lunshuLabel.x = 11;
			lunshuLabel.y = 70;
			lunshuLabel.text = CJLang("FUBEN_HANGNUM")
			this.addChild(lunshuLabel);
				
			var hangtitletext:Label = new Label;
			hangtitletext.x = 170;
			hangtitletext.y = 70;
			hangtitletext.text = CJLang("FUBEN_HANGAWARD")
			this.addChild(hangtitletext);
			//中止挂机按钮
			var stopHangup:Button = CJButtonUtil.createCommonButton(CJLang("FUBEN_STOPHANG"))
			stopHangup.x = 77;
			stopHangup.y = 189;
			this.addChild(stopHangup);
			//关闭按钮
			this._btnClose.addEventListener(Event.TRIGGERED,function(e:*):void{
				removeFromParent(true);
			});
			//提示挂机
			this._labeltishi.text = CJLang("");
		}
	}
}