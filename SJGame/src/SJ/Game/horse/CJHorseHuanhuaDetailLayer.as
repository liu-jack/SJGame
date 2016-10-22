package SJ.Game.horse
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_horse;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.data.json.Json_horsebaseinfo;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.CJTaskFlowImage;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 @author	Weichao 幻化界面里面每一个坐骑的界面
	 2013-5-20
	 */
	
	public class CJHorseHuanhuaDetailLayer extends SLayer
	{
		private var _layerMain:SLayer;
		private var _imageHorseBack:ImageLoader;
		private var _imageHorse:ImageLoader;
		private var _labelRide:Label;
		private var _imageHorseLock:ImageLoader;
		private var _labelHorseName:Label;
		private var _layer_tooltip:CJHorseHuanhuaTipLayer;
		
		private var _horseid:int = -1;
		
		public function CJHorseHuanhuaDetailLayer()
		{
			super();
		}

		protected override function initialize():void
		{
			super.initialize();
			
			this.labelHorseName.textRendererFactory = textRender.htmlTextRender;
			this.labelHorseName.textRendererProperties.textFormat = new TextFormat(null, null, 0xFFF54D, null, null, null, null, null, TextFormatAlign.CENTER);
			
			this.labelRide.text = CJLang("HORSE_RIDE");
			this.labelRide.textRendererProperties.textFormat = new TextFormat(null, null, 0xFFF54D, null, null, null, null, null, TextFormatAlign.CENTER);
			this.labelRide.textRendererProperties.wordWrap = true;
			
			var image9Back:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangzhuangshinew", 65 ,31 , 1, 1);
			image9Back.width = this.width;
			image9Back.height = this.height;
			this.addChildAt(image9Back , 0);
			
			var bg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("huoyuedu_liebiaodi", 2 ,2 , 1, 1);
			bg.width = this.width;
			bg.height = this.height;
			this.addChildAt(bg , 0);
			
			var button_showTip:Button = new Button();
			button_showTip.x = button_showTip.y = 0;
			button_showTip.width = this.width;
			button_showTip.height = this.height;
			button_showTip.addEventListener(starling.events.Event.TRIGGERED, _showTipLayer);
			this.addChild(button_showTip);
			
			CJEventDispatcher.o.addEventListener("horseactived" , this._onActive);
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener("horseactived" , this._onActive);
			super.dispose();
		}
		
		
		private function _onActive(e:Event):void
		{
			if(e.type != "horseactived")
			{
				return;
			}
			
			var horseid:int = e.data.horseid;
			if(horseid != this._horseid)
			{
				return;
			}
			//播放激活特效
			var anim:SAnimate = new SAnimate(SApplication.assets.getTextures("zuoqihuanhua_jihuotexiao"));
			if(!anim)
			{
				return;
			}
			
			anim.pivotX = anim.width >> 1;
			anim.pivotY = anim.height >> 1;
			
			anim.scaleX = anim.scaleY = 0.7;
			
			anim.x += 60;
			anim.y += 62;
			
			this.layerMain.addChild(anim);
			
			Starling.juggler.add(anim);
			
			anim.addEventListener(Event.COMPLETE , function(e:Event):void
			{
				if(e.target is SAnimate)
				{
					SocketCommand_horse.getHorseInfo();
					_removeAnims(e.target as SAnimate);
				}
			});
			
			//飘字
			new CJTaskFlowImage("texiaozi_jihuochenggong").addToLayer();
		}
		
		private function _removeAnims(anim:SAnimate):void
		{
			if(anim!= null)
			{
				anim.removeFromParent();
				anim.removeFromJuggler();
			}
		}
		
		public function refreshWithHorseid(horseid:int):void
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			//玩家基础坐骑信息
			var dic_baseInfo:Object = data.dic_baseInfo;
			var horseid_current:int = int(dic_baseInfo["currenthorseid"]);
			_horseid = horseid;
			
			var dic_horseInfo:Json_horsebaseinfo = CJHorseUtil.getHorseBaseInfoWithHorseID(horseid);
			this.labelHorseName.text = CJLang(dic_horseInfo.name);
			
			this.imageHorse.source = SApplication.assets.getTexture("zuoqi_"+dic_horseInfo.resourcename);
			
			var status:int = CJHorseUtil.calcHorseStatus(horseid);
//			没激活，显示锁，描黑
			if(status == CJHorseUtil.HORSE_UNACTIVATED)
			{
				this.imageHorseLock.visible = true;
				this.filter = ConstFilter.genBlackFilter();
				this.labelRide.visible = false;
			}
			else if(status == CJHorseUtil.HORSE_REST)
			{
				this.imageHorseLock.visible = false;
				if(filter != null)
				{
					filter.dispose();
				}
				this.filter = null;
				this.labelRide.visible = false;
			}
			else
			{
				this.imageHorseLock.visible = false;
				if(filter != null)
				{
					filter.dispose();
				}
				this.filter = null;
				this.labelRide.visible = true;
			}
		}
		

		private function _showTipLayer(e:Event):void
		{
			if (-1 != _horseid)
			{
				if (null == _layer_tooltip)
				{
					var xml_tip:XML = AssetManagerUtil.o.getObject("horseHuanhuaTip.sxml") as XML;
					_layer_tooltip = SFeatherControlUtils.o.genLayoutFromXML(xml_tip, CJHorseHuanhuaTipLayer) as CJHorseHuanhuaTipLayer;
				}
				CJLayerManager.o.addModuleLayer(_layer_tooltip);
				_layer_tooltip.refreshWithHorseid(_horseid , CJHorseUtil.calcHorseStatus(_horseid));
			}
		}
		
		public function get layerMain():SLayer
		{
			return _layerMain;
		}
		
		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}
		
		public function get imageHorseBack():ImageLoader
		{
			return _imageHorseBack;
		}
		
		public function set imageHorseBack(value:ImageLoader):void
		{
			_imageHorseBack = value;
		}
		
		public function get imageHorse():ImageLoader
		{
			return _imageHorse;
		}
		
		public function set imageHorse(value:ImageLoader):void
		{
			_imageHorse = value;
		}
		
		public function get labelRide():Label
		{
			return _labelRide;
		}
		
		public function set labelRide(value:Label):void
		{
			_labelRide = value;
		}
		
		public function get imageHorseLock():ImageLoader
		{
			return _imageHorseLock;
		}
		
		public function set imageHorseLock(value:ImageLoader):void
		{
			_imageHorseLock = value;
		}
		
		public function get labelHorseName():Label
		{
			return _labelHorseName;
		}
		
		public function set labelHorseName(value:Label):void
		{
			_labelHorseName = value;
		}
	}
}