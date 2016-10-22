package SJ.Game.camp
{
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_camp;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.math.Vector2D;
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 阵营的UI
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-18 上午11:33:14  
	 +------------------------------------------------------------------------------
	 */
	public class CJCampLayer extends SLayer
	{
		private var _personImageArray:Array = new Array();
		private var _maskImageArray:Array = new Array();
		
		private var _shapeArray:Array = new Array();
		
		private var _chooseIndex:int = -1;
		
		private var _treasureImage:SImage;
		
		public function CJCampLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this.setSize(SApplicationConfig.o.stageWidth , SApplicationConfig.o.stageHeight);
			this._drawContent();
			this._addLiteners();
		}
		
		private function _drawContent():void
		{
			this._drawBg();
			this._drawTitle();
			this._drawPerson();
			this._drawFengge();
			this._drawBottom();
			this._setPosition();
			this._setShapeV();
			
			_treasureImage = new SImage(SApplication.assets.getTexture("zhenying_tuijian"));
			this.addChild(_treasureImage);
			
			setTreasureImagePos();
		}
		
		public function setTreasureImagePos():void
		{
			var recommendCampid:int = CJDataManager.o.DataOfCamp.recommendCampid;
			if(recommendCampid == 1)
			{
				_treasureImage.x = 140 ;
				_treasureImage.y = 180;
			}
			else if(recommendCampid == 2)
			{
				_treasureImage.x = 130;
				_treasureImage.y = 20;
			}
			else
			{
				_treasureImage.x = 380;
				_treasureImage.y = 180;
			}
		}
		
		private function _setShapeV():void
		{
			var v11:Vector2D = new Vector2D(34 , 52);
			var v12:Vector2D = new Vector2D(110 , 52);
			var v13:Vector2D = new Vector2D(203 , 257);
			var v14:Vector2D = new Vector2D(34 , 257);
			_shapeArray.push([v11 ,v12 , v13 , v14]);
			
			var v21:Vector2D = new Vector2D(130 , 55);
			var v22:Vector2D = new Vector2D(380 , 55);
			var v23:Vector2D = new Vector2D(200 , 204);
			_shapeArray.push([v21 ,v22 , v23]);
			
			var v31:Vector2D = new Vector2D(209 , 220);
			var v32:Vector2D = new Vector2D(227 , 258);
			var v33:Vector2D = new Vector2D(450 , 258);
			var v34:Vector2D = new Vector2D(450 , 53);
			_shapeArray.push([v31 ,v32 , v33, v34]);
		}
		
		private function _getPointInZoneIndex(p:Point):int
		{
			
			if(p.x <= 23 || p.x >=450 || p.y >= 266 || p.y <=45)
			{
				return -1;
			}
			if(p.y >=188 && p.x  >=173 && p.x <=243)
			{
				return -1;
			}
			
			if(p.x <=216)
			{
				var tempY:Number = 269 - 170/75 * (216 - p.x)
				if(tempY <= p.y)
				{
					return 0;
				}
				else
				{
					return 1;
				}
			}
			else
			{
				tempY = 242 - (230 / 307) * (p.x - 227);
				if(tempY <= p.y)
				{
					return 2;
				}
				else
				{
					return 1;
				}
			}
		}
		
		private function _drawFengge():void
		{
			var fengge:SImage = new SImage(SApplication.assets.getTexture("zhenying_fenge") , true);
			fengge.x = 28;
			fengge.y = 45;
			this.addChild(fengge);
		}
		
		private function _drawBottom():void
		{
			//底部绿版
			var line:SImage = new SImage(SApplication.assets.getTexture("zhenying_dibu"), true);
			line.width = SApplicationConfig.o.stageWidth;
			line.x = 0 ; 
			line.y = 283;
			this.addChild(line);
			
			var label:Label = new Label();
			label.x = 174;
			label.y = 294;
			label.textRendererFactory = _genTextRender;
			label.text = CJLang("CAMP_CHOICE");
			this.addChild(label);
			
			//底部花边
			var flower:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("zhenying_dibuzhuangshi") , 64 , 6));
			flower.width = SApplicationConfig.o.stageWidth;
			flower.y = 290;
			this.addChild(flower);
		}
		
		public static function _genTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx();
			_htmltextRender.isHTML = true;
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.color = 0x000000;
			tf.size = 16;
			tf.font = ConstTextFormat.FONT_FAMILY_LISHU;
			_htmltextRender.textFormat = tf
			_htmltextRender.nativeFilters = [new GlowFilter(0xFFFFFF,1.0,2.0,2.0,5,1)];
			return _htmltextRender;
		}
		
		private function _drawBg():void
		{
			//设置背景
			var bigBg:SImage = new SImage(SApplication.assets.getTexture("zhenying_beijing"), true);
			bigBg.width = SApplicationConfig.o.stageWidth;
			bigBg.height = SApplicationConfig.o.stageHeight;
			this.addChild(bigBg);
			//头部绿条
			var bar:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			bar.width = SApplicationConfig.o.stageWidth;
			this.addChild(bar);
			//中间选择框底
			var chooseBg:SImage = new SImage(SApplication.assets.getTexture("zhenying_kuang"), true);
			chooseBg.x = 13;
			chooseBg.y = 30;
			this.addChild(chooseBg);
			//滚珠
			var bgBall:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_zhuangshinew") , new Rectangle(18,18 , 3,3)));
			bgBall.width = 438;
			bgBall.height = 233;
			bgBall.x = 22;
			bgBall.y = 39;
			this.addChild(bgBall);
		}
		
		private function _drawPerson():void
		{
			for(var i:int = 0 ; i < 3 ; i++)
			{
				var personTexture:Texture = SApplication.assets.getTexture("zhenying_renwu0" + (i+1));
				var tempImage:SImage = new SImage(personTexture);
				_personImageArray.push(tempImage);
				this.addChild(_personImageArray[i]);
				tempImage.touchable = false;
				
				_maskImageArray.push(new SImage(SApplication.assets.getTexture("zhenying_xuanzhong0" + (i+1))));
				_maskImageArray[i].visible = false;
				_maskImageArray[i].touchable = false;
				this.addChild(_maskImageArray[i]);
			}
		}
		
		private function _setPosition():void
		{
			_personImageArray[0].x = 28;
			_personImageArray[0].y = 44;
			_personImageArray[1].x = 120;
			_personImageArray[1].y = 47;
			_personImageArray[2].x = 190;
			_personImageArray[2].y = 43;
			
			_maskImageArray[0].x = 28;
			_maskImageArray[0].y = 44;
			
			_maskImageArray[1].x = 120;
			_maskImageArray[1].y = 47;
			
			_maskImageArray[2].x = 190;
			_maskImageArray[2].y = 43;
		}
		
		private function _drawTitle():void
		{
			var title:CJPanelTitle = new CJPanelTitle(CJLang("TITLE_ZHENYING"));
			this.addChild(title);
			title.scaleY = 0.8;
		}
		
		/**
		 * 添加相关监听器
		 */
		private function _addLiteners():void
		{
			this.addEventListener(TouchEvent.TOUCH , this._touchHandler);
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(null != touch && touch.phase == TouchPhase.ENDED)
			{
				var localPoint:Point = touch.getLocation(this);
				var index:int = this._getPointInZoneIndex(localPoint);
				if(index == -1)
				{
					return;
				}
				else
				{
					for(var i:String in this._maskImageArray)
					{
						this._maskImageArray[i].visible = false;
					}
					this._chooseIndex = index + 1;
					this._maskImageArray[index].visible = true;	
					CJConfirmMessageBox(CJLang("CAMP_MESSAGE") , this._onConfirm);
				}
			}
		}
		
		private function _onConfirm():void
		{
			Assert(this._chooseIndex != -1 , "阵营索引错误!");
			SocketCommand_camp.joinCamp(_chooseIndex);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onJoinCampComplete);
		}		
		
		private function _onJoinCampComplete(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_JOINCAMP)
			{
				var retCode:int = msg.params(0)
				if(retCode == 1)
				{
					SApplication.moduleManager.exitModule("CJCampModule");
				}
			}
		}
		
		override public function dispose():void
		{
			_personImageArray = null;
			_maskImageArray = null;
			_shapeArray = null;
			_treasureImage = null;
			this.removeEventListener(TouchEvent.TOUCH , this._touchHandler);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData , _onJoinCampComplete);
			super.dispose();
		}
	}
}