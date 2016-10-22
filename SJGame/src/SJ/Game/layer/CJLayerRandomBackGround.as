package SJ.Game.layer
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	import engine_starling.display.SNode;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.STween;
	
	import feathers.controls.Label;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class CJLayerRandomBackGround extends SLayer
	{
		private var _bgimage:Image;
		
		private var _netLoadNode:SNode;
		
		
		
		
		public static const status_netLoad:String = "status_netLoad";
		public static const status_NormalLoad:String = "status_NormalLoad";
		
		private var _status:String = status_netLoad;
		private var _logger:Logger = Logger.getInstance(CJLayerRandomBackGround);
		private var _langidx:uint = 0;
		private var _langbgidx:uint = 0;
		public function CJLayerRandomBackGround(s:singleon)
		{
			super();
		}
		
		override protected function draw():void
		{
			var texture:Texture = null;
			_bgimage.touchable = false;
			
			if(_status == status_NormalLoad)
			{
				texture = AssetManagerUtil.o.getTexture("resloading" + int(Math.random() * 8) );
				_netLoadNode.visible = false;
				_netLoadNode.removeFromParent(true);
				SApplication.assets.removeTexture("netresloading_loading");
				SApplication.assets.removeTexture("netresloading_niu");
			}
			else if(_status == status_netLoad)
			{
				_bgimage.touchable = true;
				 texture = AssetManagerUtil.o.getTexture("netresloading_loading");
				 _netLoadNode.visible = true;
				 
				 var _randomTxt:Label = _netLoadNode.getChildByName("_randomTxt") as Label;
				 var _randomBgTxt:Label = _netLoadNode.getChildByName("_randomBgTxt") as Label;
				 _randomTxt.text = CJLang("RLOADL_" + int(_langidx % 200));
				 _randomBgTxt.text = CJLang("RLOADLBG_" + int(_langbgidx%50));
				 
//				 var music:SMuiscChannel =  SMuiscChannel.SMuiscChannelCreate(SApplication.assets.getSound("music_loadingbg"));
//				 var musicbg:SMuiscNode = new SMuiscNode(music);
//				 musicbg.loop = true;
//				 addChild(musicbg);
			}
			
			_bgimage.texture = texture;
			super.draw();
		}
		
		override protected function initialize():void
		{
		
			
			_bgimage = new Image(AssetManagerUtil.o.getTexture("netresloading_loading"));
			addChild(_bgimage);
			
			_netLoadNode = new SNode();
			addChild(_netLoadNode);
			

			//背景女人
			var _bgnvren:Image;
			_bgnvren = new Image(AssetManagerUtil.o.getTexture("netresloading_niu"));
			_bgnvren.y = 13;
			_bgnvren.x = -13;
			_bgnvren.addEventListener(TouchEvent.TOUCH,function(e:TouchEvent):void
			{
				var touch:Touch = e.getTouch(_bgnvren,TouchPhase.ENDED);
				if(touch)
				{
					
//					var  music:SMuiscChannel =  SMuiscChannel.SMuiscChannelCreate(SApplication.assets.getSound("music_loadingclick"));
//					music.fadeIn(false,0.1,1);
//					_randomTxt.text = CJLang("RLOADL_" + int(Math.random() * 200));
					_langidx ++;
					invalidate();
				}
			});
			_netLoadNode.addChild(_bgnvren);
			
			var _randomTxt:Label;
			_randomTxt = new Label();
			_randomTxt.y = 278;
			_randomTxt.width = SApplicationConfig.o.stageWidth;
			_randomTxt.textRendererFactory = textRender.standardTextRender;
			_randomTxt.name = "_randomTxt";
			
			
			var tf:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFFFFF, null,null,null,null,null, TextFormatAlign.CENTER);
			_randomTxt.textRendererProperties.textFormat = tf;
			_randomTxt.touchable = false;
			
			_netLoadNode.addChild(_randomTxt);
			
			
			var _randomBgTxt:Label;
			_randomBgTxt = new Label();
			_randomBgTxt.name = "_randomBgTxt";
			_randomBgTxt.x = 235;
			_randomBgTxt.y = 46;
			_randomBgTxt.width = 230;
			_randomBgTxt.height = 120;
			_randomBgTxt.textRendererFactory = textRender.htmlTextRender;
			_randomBgTxt.textRendererProperties.textFormat = ConstTextFormat.textformatheitiwhite;
			_randomBgTxt.textRendererProperties.wordWrap = true;
			_randomBgTxt.text = CJLang("RANDOM_BG_TXT");
			_randomBgTxt.touchable = false;
			
			_bgimage.addEventListener(TouchEvent.TOUCH,function(e:TouchEvent):void
			{
				var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.ENDED);
				if(touch)
				{
//					_randomBgTxt.text = CJLang("RLOADLBG_" + int(Math.random() * 50));
					_langbgidx++;
					invalidate();
				}
			});
			
			_netLoadNode.addChild(_randomBgTxt);
			_netLoadNode.visible = false;

			
			super.initialize();
		}
		private var isshowing:Boolean = false;
		
		/**
		 *  显示 
		 * @param parentlayer 要出现的父类
		 * 
		 */
		protected function _show(parentlayer:SNode,style:String = "status_NormalLoad"):void
		{
		
			_logger.info("Show");
			if(_fadeout != null)
			{
				Starling.juggler.remove(_fadeout);
			}
			alpha = 1;
			
			if(style == status_netLoad)
			{
				var bglangTween:Tween = new Tween(this,5);
				bglangTween.repeatCount = int.MAX_VALUE;
				bglangTween.onRepeat = function():void{
					_langbgidx++;
					invalidate();
				};
				Starling.juggler.add(bglangTween);
					
			}
			
			//重现显示,则换图片
			if(isshowing == false)
			{
				_status = style;
				this.invalidate();
			}
			else
			{
				
			}

			if(parent != parentlayer)
			{
				removeFromParent();
				parentlayer.addChild(this);	
			}
			isshowing = true;
			
			
		}
		protected var _fadeout:STween;
		/**
		 * 关闭 淡出
		 * 
		 */
		protected function _close():void
		{
			_logger.info("Close");
			if(_fadeout == null)
			{
				
				_fadeout = new STween(this,0.75);
				_fadeout.delay = 0.75;
				_fadeout.animate("alpha",0.0001);
				var pthis:CJLayerRandomBackGround = this;
				_fadeout.onComplete = function():void
				{
					isshowing = false;
					pthis.removeFromParent();
					Starling.juggler.removeTweens(pthis);
				}
			}
			else
			{
				_fadeout.softReset();
			}
			Starling.juggler.add(_fadeout);
			
		}
		
		
		private static var _o:CJLayerRandomBackGround;
		private static function get o():CJLayerRandomBackGround
		{
			if(_o == null)
				_o = new CJLayerRandomBackGround(new singleon());
			return _o;
		}
		
		/**
		 * 显示 
		 * @param parentlayer
		 * 
		 */
		public static function Show(parentlayer:SNode,style:String = "status_NormalLoad"):void
		{
			
			o._show(parentlayer,style);
		}
		/**
		 * 隐藏 
		 * 
		 */
		public static function Close():void
		{
			o._close();
		}
	}
	
	
}

class singleon{}