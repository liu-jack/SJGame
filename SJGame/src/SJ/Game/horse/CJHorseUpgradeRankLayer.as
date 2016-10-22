package SJ.Game.horse
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_horse;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;

	/**
	 * @author	Weichao 升阶界面
	 * 2013-5-17
	 * @modified caihua 13/06/05
	 */
	
	public class CJHorseUpgradeRankLayer extends SLayer
	{
		private var _layer_content:SLayer;
		private var _imageJiantou:ImageLoader;
		private var _imageGold:ImageLoader;
		private var _label_upgradeRankDes:Label;
		private var _label_cost:Label;
		private var _button_upgradeRank:Button;
		private var _imageTopBar:ImageLoader;
		private var _label_title:Label;
		private var _button_close:Button;
		private var _layer_currentRank:CJHorseInfoDetailLayer;
		private var _layer_nextRank:CJHorseInfoDetailLayer;
		
		public function CJHorseUpgradeRankLayer()
		{
			super();
		}

		protected override function initialize():void
		{
			super.initialize();
			
			this._drawBackground();
			
			this._drawHorsePanel();
			
			this._refreshContentLayer();
			
			this._addEventListeners();
		}
		
		private function _drawBackground():void
		{
			//标头
			var title:CJPanelTitle = new CJPanelTitle(CJLang("TITLE_ZUOQIJINJIE"));
			this.addChildAt(title , 0);
			title.x = (SApplicationConfig.o.stageWidth - title.width >> 1) - 17;
			title.y = 3;
			
			//头部绿条
			var bar:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			bar.width = SApplicationConfig.o.stageWidth;
			this.addChildAt(bar , 0);
			
			//最下面的遮罩
			var mask:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi") , new Rectangle(15,14 , 1,1)));
			mask.width = SApplicationConfig.o.stageWidth;
			mask.height = SApplicationConfig.o.stageHeight;
//			mask.alpha = 0.5;
			this.addChildAt(mask , 0);
		}
		
		private function _drawHorsePanel():void
		{
//			坐骑1
			var xml_horseDetailInfo:XML = AssetManagerUtil.o.getObject("horseDetail.sxml") as XML;
			this.layer_currentRank = SFeatherControlUtils.o.genLayoutFromXML(xml_horseDetailInfo, CJHorseInfoDetailLayer) as CJHorseInfoDetailLayer;
			this.layer_currentRank.y = 0;
			this.layer_content.addChild(this.layer_currentRank);
//			坐骑2
			this.layer_nextRank = SFeatherControlUtils.o.genLayoutFromXML(xml_horseDetailInfo, CJHorseInfoDetailLayer) as CJHorseInfoDetailLayer;
			this.layer_nextRank.x = 245;
			this.layer_content.addChild(this.layer_nextRank);
//			消耗元宝
			this.label_upgradeRankDes.textRendererProperties.textFormat = new TextFormat(null, 12, 0xFFE154, true, null, null, null, null, TextFormatAlign.CENTER);
			this.label_upgradeRankDes.text = CJLang("HORSE_UPGRADERANK_COST");
			this.label_cost.textRendererProperties.textFormat = new TextFormat(null, 12, 0xFFE154, true, null, null, null, null, TextFormatAlign.LEFT);
//			升阶按钮
			this.button_upgradeRank.labelFactory = textRender.standardTextRender;
			this.button_upgradeRank.label = CJLang("HORSE_UPGRADERANKBUTTON");
			this.button_upgradeRank.defaultLabelProperties.textFormat = 
				new TextFormat(null, null, 0xFFEFBD, null, null, null, null, null, TextFormatAlign.CENTER);
			this.button_upgradeRank.labelOffsetY = 2;
		}
		
		private function _addEventListeners():void
		{
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_HORSE_UPGRADERANK_SUCCESS, _onUpgradeRankSucceess);
			this.button_close.addEventListener(starling.events.Event.TRIGGERED, _onCloseButtonClicked);
			this.button_upgradeRank.addEventListener(starling.events.Event.TRIGGERED, _onUpgradeRankButtonClicked);
		}
		
		private function _onUpgradeRankButtonClicked(e:Event):void
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var dic_baseInfo:Object = data.dic_baseInfo;
			var level:int = int(dic_baseInfo["rideskilllevel"]);
			var currentRank:int = CJHorseUtil.getRank(level);
			var currentRankConfig:Object = CJHorseUtil.getBaseConfigByRank(currentRank);
			//判断钱币是否足够
			var needgold:int = int(CJHorseUtil.getUpRankCost(currentRank));
			if(needgold != -1 && needgold　<= CJDataManager.o.DataOfRole.gold )
			{
				SocketCommand_horse.upgradeRideSkillRank();
			}
			else
			{
				new CJTaskFlowString(CJLang('ERROR_HEROTAG_GOLD')).addToLayer();
			}
		}
		
		private function _onCloseButtonClicked(e:Event):void
		{
			CJLayerManager.o.removeModuleLayer(this);
		}
		
		private function _refreshContentLayer():void
		{
//			取得当前的坐骑ID和当前的骑术等级
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var dic_baseInfo:Object = data.dic_baseInfo;
			
			var level:int = int(dic_baseInfo["rideskilllevel"]);
			
			var currentRank:int = CJHorseUtil.getRank(level);
			var currentRankConfig:Object = CJHorseUtil.getBaseConfigByRank(currentRank);
			this.layer_currentRank.refreshWithParams(level);
			this.layer_nextRank.refreshWithParams(level + 1);
			
			this.label_cost.text = ""+CJHorseUtil.getUpRankCost(currentRank);
		}
		
		private function _onUpgradeRankSucceess(e:Event):void
		{
			CJLayerManager.o.removeModuleLayer(this);
		}
		
		public function get layer_content():SLayer
		{
			return _layer_content;
		}
		
		public function set layer_content(value:SLayer):void
		{
			_layer_content = value;
		}
		
		public function get imageJiantou():ImageLoader
		{
			return _imageJiantou;
		}
		
		public function set imageJiantou(value:ImageLoader):void
		{
			_imageJiantou = value;
		}
		
		public function get imageGold():ImageLoader
		{
			return _imageGold;
		}
		
		public function set imageGold(value:ImageLoader):void
		{
			_imageGold = value;
		}
		
		public function get label_upgradeRankDes():Label
		{
			return _label_upgradeRankDes;
		}
		
		public function set label_upgradeRankDes(value:Label):void
		{
			_label_upgradeRankDes = value;
		}
		
		public function get label_cost():Label
		{
			return _label_cost;
		}
		
		public function set label_cost(value:Label):void
		{
			_label_cost = value;
		}
		
		public function get button_upgradeRank():Button
		{
			return _button_upgradeRank;
		}
		
		public function set button_upgradeRank(value:Button):void
		{
			_button_upgradeRank = value;
		}
		
		public function get imageTopBar():ImageLoader
		{
			return _imageTopBar;
		}
		
		public function set imageTopBar(value:ImageLoader):void
		{
			_imageTopBar = value;
		}
		
		public function get label_title():Label
		{
			return _label_title;
		}
		
		public function set label_title(value:Label):void
		{
			_label_title = value;
		}
		
		public function get button_close():Button
		{
			return _button_close;
		}
		
		public function set button_close(value:Button):void
		{
			_button_close = value;
		}
		
		public function get layer_currentRank():CJHorseInfoDetailLayer
		{
			return _layer_currentRank;
		}
		
		public function set layer_currentRank(value:CJHorseInfoDetailLayer):void
		{
			_layer_currentRank = value;
		}
		
		public function get layer_nextRank():CJHorseInfoDetailLayer
		{
			return _layer_nextRank;
		}
		
		public function set layer_nextRank(value:CJHorseInfoDetailLayer):void
		{
			_layer_nextRank = value;
		}
	}
}