package SJ.Game.battle
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.battle.data.CJBattleQteFormation;
	import SJ.Game.event.CJEvent;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.NumberFormat;
	import engine_starling.utils.STween;
	
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.math.Vector2D;
	
	import starling.animation.DelayedCall;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.MatrixUtil;
	import starling.utils.formatString;
	
	public class CJBattleQTEShowTip extends SLayer
	{

		//持续时间
		private var _duringTime:int;
		
		public function get duringTime():int
		{
			return _duringTime;
		}
		
		public function set duringTime(value:int):void
		{
			_duringTime = value - 3;
		}

		private var _onfinish:Function;
		private var _qteIcons:Array;
		private var _lines:Array;
		private var _qteFormationData:CJBattleQteFormation;
		private var _bgImage:Image;
		private var _particles:Vector.<PDParticleSystem>;
		private var _timeLabel:Label;
		private var _mjugger:Juggler;
		/**
		 * 当前需要激活的按钮次序 
		 */
		private var _currentActiveIndex:uint;
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		override protected function initialize():void
		{
			_initLayer();
			addEventListener(TouchEvent.TOUCH,_onTouch);
			addChild(_bgImage);
			
			
			var timeLabelBg:Image = new Image(SApplication.assets.getTexture("qte_jishi"));
			addChild(timeLabelBg);
			timeLabelBg.x =185;
			timeLabelBg.y = 6;
			
			
			_timeLabel = new Label();

			
			_timeLabel.width = 115;
			_timeLabel.height = 24;
			_timeLabel.pivotX = 115/2;
			_timeLabel.pivotY = 24/2;
			
			_timeLabel.x = 243;
			_timeLabel.y = 24;
	
			var nf:NumberFormat = new NumberFormat("00");
			_timeLabel.text = formatString("00:{0}",nf.format(_duringTime));
			
			
			_timeLabel.textRendererProperties.textFormat = new TextFormat( "Arial", 24, 0xFFFFFF ,null,null,null,null,null, TextFormatAlign.CENTER);
			_timeLabel.validate();
			addChild(_timeLabel);
			
			var length:int = 0;
			var iconimage:CJBattleQTEIcon = null;
			var i:int;
			
			length = _lines.length;
			var scale3line:Scale3Image = null;
			for(i=0;i<length;i++)
			{
				scale3line = _lines[i] as Scale3Image;
				addChild(scale3line);
			}
			
			length = _qteIcons.length;
			for(i = 0;i<length;i++)
			{
				iconimage = _qteIcons[i] as CJBattleQTEIcon;
				
				addChild(iconimage);
			}
			
			_mjugger.delayCall(_changeLineRed2Blue,0.25);
			
			super.initialize();
		}
		
//		override protected function initialize_addedToStageHandler(event:Event):void
//		{
//			addEventListener(TouchEvent.TOUCH,_onTouch);
//			addChild(_bgImage);
//			
//			var length:int = 0;
//			var iconimage:CJBattleQTEIcon = null;
//			var i:int;
//			
//			length = _lines.length;
//			var scale3line:Scale3Image = null;
//			for(i=0;i<length;i++)
//			{
//				scale3line = _lines[i] as Scale3Image;
//				addChild(scale3line);
//			}
//			
//			length = _qteIcons.length;
//			for(i = 0;i<length;i++)
//			{
//				iconimage = _qteIcons[i] as CJBattleQTEIcon;
//
//				addChild(iconimage);
//				
//				iconimage.pivotX =  iconimage.width ;
//				iconimage.pivotY = iconimage.height ;
//			}
//			
//			_mjugger.delayCall(_changeLineRed2Blue,0.25);
//			super.initialize_addedToStageHandler(event);
//		}
		
		
		
		public function CJBattleQTEShowTip(onfinish:Function,mjugger:Juggler)
		{
			super();
			_onfinish = onfinish;
			_mjugger = mjugger;
			
		}
		private function _initLayer():void
		{
			_qteIcons = new Array();
			_particles = new Vector.<PDParticleSystem>();
			_bgImage = new Image(SApplication.assets.getTexture("qte_di"));
			
			var Icontexture:Texture = SApplication.assets.getTexture("qte_quanliang");
			//目前默认第0组数据吧
			_qteFormationData =  ConstBattle.sBattleQTEFormationData[int(Math.random() * 2)];
			var length:int = _qteFormationData.count;
			var iconimage:CJBattleQTEIcon = null;
			var iconpos:Point = null;
			
			_lines = new Array();
			var currentLinePos:Vector2D = null;
			var nextLinePos:Vector2D = null;
			var lineTexture:Texture = SApplication.assets.getTexture("qte_xian2");
			var scale3Texture:Scale3Textures = new Scale3Textures(lineTexture,10,2);
			var scale3line:Scale3Image = new Scale3Image(scale3Texture);
			var scale3lineheight:int = 10;
			for(var i:int = 0;i<length;i++)
			{
				iconimage = new CJBattleQTEIcon(i);
				iconpos = _qteFormationData.getPos(i);
				iconimage.x =iconpos.x;
				iconimage.y = iconpos.y;
				_qteIcons.push(iconimage);
				
				
				if(i == 0)
				{
					currentLinePos = new Vector2D(iconpos.x,iconpos.y )
						
				}
				else
				{

					nextLinePos = new Vector2D(iconpos.x,iconpos.y);
					scale3line = new Scale3Image(scale3Texture);
					scale3line.pivotY = scale3line.height / 2;
					scale3line.x = currentLinePos.x;
					scale3line.y = currentLinePos.y;
					var diffvector2d:Vector2D = currentLinePos.subtract(nextLinePos);
					scale3line.width = diffvector2d.length;
					scale3line.rotation =Math.PI + diffvector2d.angle;
					
					
					_lines.push(scale3line);
					//置换一个点
					currentLinePos.x = nextLinePos.x;
					currentLinePos.y = nextLinePos.y;
				}
			}
			
			
		}
		
		
		
		private function _changeLineRed2Blue():void
		{
			var scale3line:Scale3Image = null;
			var i:int;
			var length:int = 0;
			var lineTexture:Texture = SApplication.assets.getTexture("qte_xian1");
			var scale3Texture:Scale3Textures = new Scale3Textures(lineTexture,10,2);
			length = _lines.length;
			var fadeOut:Tween = null;
			for(i=0;i<length;i++)
			{
				scale3line = _lines[i] as Scale3Image;
				scale3line.textures = scale3Texture;
				fadeOut = new Tween(scale3line,1);
				fadeOut.fadeTo(0.25);
				_mjugger.add(fadeOut);
//				addChild(scale3line);
			}
			
			_mjugger.delayCall(_changeIconDark,0.25);
		}
		
		private function _changeIconDark():void
		{
			var Icontexture:Texture = SApplication.assets.getTexture("qte_an");
			var i:int;
			var length:int = 0;
			var iconimage:CJBattleQTEIcon = null;
			length = _qteIcons.length;
			for(i = 0;i<length;i++)
			{
				iconimage = _qteIcons[i] as CJBattleQTEIcon;
				iconimage.Dark();
			}
			
			//开始计时
			_startTimeTick();
			
			
			
		}
		private var _timeTickDelay:DelayedCall;
		
		private function _startTimeTick():void
		{
			_timeTickDelay = _mjugger.delayCall(_timeTick,1);
			
			_activeIcon();
		}
		
		private function _timeTick():void
		{
			_duringTime -- ;
			if(_duringTime <= 0)
			{
				_onfinish();
				return;
			}
			var nf:NumberFormat = new NumberFormat("00");
			_timeLabel.text = formatString("00:{0}",nf.format(_duringTime));
			_timeTickDelay = _mjugger.delayCall(_timeTick,1);
			
		}
		

		

		
		private function _activeQteEffect(index:uint):void
		{
			if(index<1 || index > _qteFormationData.count)
			{
				return;
			}
			var iconimage:CJBattleQTEIcon = _qteIcons[index - 1] as CJBattleQTEIcon;
			var scale3line:Scale3Image = _lines[index - 1] as Scale3Image;
			var xml:XML = AssetManagerUtil.o.getObject(ConstResource.sResQTEEffect) as XML;
			var particlecopy:PDParticleSystem = new PDParticleSystem(xml,SApplication.assets.getTexture("qtefire"));
			addChild(particlecopy);
			
			var vect:Vector2D = new Vector2D(scale3line.x,scale3line.y);
			vect.angle = scale3line.rotation;
			vect.normalize();
			vect.length = scale3line.width/2;
			particlecopy.start();
			particlecopy.emitterXVariance = scale3line.width/2;
			particlecopy.emitAngle = Math.PI/2 * 3 - scale3line.rotation;
			particlecopy.rotation = scale3line.rotation;
			particlecopy.x = scale3line.x + vect.x;
			particlecopy.y = scale3line.y + vect.y;
			
			_mjugger.add(particlecopy);
			_particles.push(particlecopy);
		}
		
		private function _onRemoveFromStage(e:Event):void
		{
			var length:int = _particles.length;
			for(var i:int=0;i<length;i++)
			{
				_mjugger.remove(_particles[i]);
			}
			_mjugger.remove(_timeTickDelay);
			
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (touch && touch.phase != TouchPhase.HOVER)
			{
				
				var iconimage:CJBattleQTEIcon = _qteIcons[_currentActiveIndex] as CJBattleQTEIcon;
				
				if(iconimage.hitTest(iconimage.globalToLocal(new Point(touch.globalX,touch.globalY))))
				{
					iconimage.deactive();
					_onClickIcon(_currentActiveIndex);
					
				}
			}
		}
		
		private function _onClickIcon(index:int):void
		{
			
			
			_activeQteEffect(index);
			
			var nextindex:int =index + 1;
			if(nextindex >= _qteFormationData.count)
			{
				removeEventListener(TouchEvent.TOUCH,_onTouch);
				_finish();
				return;
			}
			
			//激活下一个按钮
			_activeIcon(nextindex);
			
			
			//			Logger.log("onClickIcon",index +"");
			
		}
		private function _activeIcon(index:int = 0):void
		{
			var iconimage:CJBattleQTEIcon = null;
			iconimage = _qteIcons[index] as CJBattleQTEIcon;
			iconimage.active();
			_currentActiveIndex = index;
		}
		
		private function _finish():void
		{
			var writeImage:Image = new Image(Texture.fromColor(SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight,0xFFFFFFFF));
			writeImage.alpha = 0.001;
			var t:STween = new STween(writeImage,0.15);
			t.fadeTo(0.999);
			t.onComplete = function():void{
				
				_mjugger.remove(_timeTickDelay);
				_onfinish();
				
			};
			_mjugger.add(t);
			addChild(writeImage);
		}
	}
}