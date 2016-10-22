package SJ.Game.horse
{
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.data.CJDataManager;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	/**
	 @author	Weichao 幻化大界面
	 2013-5-20
	 */
	public class CJHorseHuanhuaLayer extends SLayer
	{
		private var _layerMain:SLayer;
		private var _layerContent:SLayer;
		private var _button_left:Button;
		private var _button_right:Button;
		private var _imagePageBack:Scale3Image;
		private var _labelPage:Label;
		
		private var _arr_horseList:Array;
		private var _currentPage:int = 0;
		
		public function CJHorseHuanhuaLayer()
		{
			super();
		}

		protected override function initialize():void
		{
			super.initialize();
			
			this._drawBackground();
			
			var tf:TextFormat = new TextFormat();
			tf.size = 16;
			tf.color = 0xffffff;
			tf.align = TextFormatAlign.CENTER;
			this.labelPage.textRendererProperties.textFormat = tf;
			
			_imagePageBack = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("common_fanyeyemawenzidi") , 6 ,5));
			_imagePageBack.width = 70 ;
			_imagePageBack.height = 20 ;
			_imagePageBack.x = 209;
			_imagePageBack.y = 295;
			this.layerMain.addChildAt(_imagePageBack , 1);
			
			_arr_horseList = new Array();
			for (var i:int = 0; i <= 5; i++)
			{
				var xml_huanhuaDetail:XML = AssetManagerUtil.o.getObject("horseHuanhuaDetail.sxml") as XML;
				var horseHuanHuaDetailLayer:CJHorseHuanhuaDetailLayer = 
					SFeatherControlUtils.o.genLayoutFromXML(xml_huanhuaDetail,CJHorseHuanhuaDetailLayer) as CJHorseHuanhuaDetailLayer;
				_arr_horseList.push(horseHuanHuaDetailLayer);
				horseHuanHuaDetailLayer.x = 24 + i % 3 * 136;
				horseHuanHuaDetailLayer.y = 10 + Math.floor(i / 3) * 136;
				horseHuanHuaDetailLayer.width = 131;
				horseHuanHuaDetailLayer.height = 131;
				this.layerContent.addChild(horseHuanHuaDetailLayer);
			}
			
			this.button_left.addEventListener(starling.events.Event.TRIGGERED, _onLeftButtonClicked);
			this.button_right.addEventListener(starling.events.Event.TRIGGERED, _onRightButtonClicked);
			this.button_left.pivotX = this.button_left.width;
			this.button_left.pivotY = this.button_left.height;
			this.button_left.rotation = Math.PI;
			
			this._refresh();
			
			CJDataManager.o.DataOfHorse.addEventListener(DataEvent.DataChange, _refresh);
		}
		
		private function _drawBackground():void
		{
			//装饰
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(15 ,13 , 1, 1)));
			bgWrap.width = this.layerContent.width;
			bgWrap.height = this.layerContent.height;
			bgWrap.x = 32;
			bgWrap.y = 15;
			this.addChildAt(bgWrap , 0);
			
			//整个框设置背景
			var s9image_contentBack:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew"), new Rectangle(1,1 , 1,1)));
			s9image_contentBack.x = 31;
			s9image_contentBack.y = 15;
			s9image_contentBack.width = this.layerContent.width;
			s9image_contentBack.height = this.layerContent.height;
			this.addChildAt(s9image_contentBack , 0);
		}
		
		private function _refresh():void
		{
			this._refreshPageCount();
			this._refreshCurrentPage();
		}
		
		/**
		 * 刷新坐骑信息
		 */
		private function _refreshCurrentPage():void
		{
			var array_allHorseConfig:Array = CJHorseUtil.getJsonAllHorseInfo();
			var totalCount:int = array_allHorseConfig.length;
			for (var i:int = 0; i <= 5; i++)
			{
				var horseHuanHuaDetailLayer:CJHorseHuanhuaDetailLayer = _arr_horseList[i];
				var indexInConfigArray:int = 6 * _currentPage + i;
				if (indexInConfigArray > totalCount - 1)
				{
					horseHuanHuaDetailLayer.visible = false;
				}
				else
				{
					horseHuanHuaDetailLayer.visible = true;
					var dic_horseBaseInfo:Object = array_allHorseConfig[indexInConfigArray];
					var horseid:int = int(dic_horseBaseInfo["horseid"]);
					horseHuanHuaDetailLayer.refreshWithHorseid(horseid);
				}
			}
		}
		
		/**
		 * 刷新下面的页数和按钮状态
		 */
		private function _refreshPageCount():void
		{
			//更新下面的页面计数和左右箭头状态
			var array_allHorseConfig:Array = CJHorseUtil.getJsonAllHorseInfo();
			var totalCount:int = array_allHorseConfig.length;
			var totalPage:int = Math.ceil(totalCount * 1.0 / 6);
			_currentPage = _currentPage < 0? 0:_currentPage;
			_currentPage = _currentPage > totalPage - 1? totalPage -1:_currentPage;
			this.labelPage.text = String(_currentPage + 1) + "/" + String(totalPage);
			
			this.button_left.isEnabled = (0 < _currentPage); 
			this.button_right.isEnabled = (_currentPage < totalPage - 1);
		}
		
		private function _onLeftButtonClicked(e:Event):void
		{
			var newPage:int = _currentPage - 1;
			newPage = 0 > newPage ? 0:newPage;
			if (newPage != _currentPage)
			{
				_currentPage = newPage;
				this._refresh();
			}
		}
		
		private function _onRightButtonClicked(e:Event):void
		{
			var newPage:int = _currentPage + 1;
			var array_allHorseConfig:Array = CJHorseUtil.getJsonAllHorseInfo();
			var totalCount:int = array_allHorseConfig.length;
			var totalPage:int = Math.ceil(totalCount * 1.0 / 6);
			newPage = newPage > totalPage - 1? totalPage -1:newPage;
			if (newPage != _currentPage)
			{
				_currentPage = newPage;
				this._refresh();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			//移除监听
			CJDataManager.o.DataOfHorse.removeEventListener(DataEvent.DataChange , this._refresh);
			this.button_left.removeEventListener(starling.events.Event.TRIGGERED, _onLeftButtonClicked);
			this.button_right.removeEventListener(starling.events.Event.TRIGGERED, _onRightButtonClicked);
		}
		
		public function get layerMain():SLayer
		{
			return _layerMain;
		}
		
		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}
		
		public function get layerContent():SLayer
		{
			return _layerContent;
		}
		
		public function set layerContent(value:SLayer):void
		{
			_layerContent = value;
		}
		
		public function get button_left():Button
		{
			return _button_left;
		}
		
		public function set button_left(value:Button):void
		{
			_button_left = value;
		}
		
		public function get button_right():Button
		{
			return _button_right;
		}
		
		public function set button_right(value:Button):void
		{
			_button_right = value;
		}
		
		public function get labelPage():Label
		{
			return _labelPage;
		}
		
		public function set labelPage(value:Label):void
		{
			_labelPage = value;
		}
	}
}