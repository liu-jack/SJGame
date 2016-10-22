package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 *  副本通关界面
	 * @author yongjun
	 * 
	 */
	public class CJFubenGuankaPassLayer extends SLayer
	{
		private var xpvalue:Label;
		private var silivervalue:Label;
		private var wuhunvalue:Label;
		private var hitcontinue:Label;
		private var _fid:int;
		private var _gid:int;
		public function CJFubenGuankaPassLayer(fid:int,gid:int)
		{
			super();
			_fid = fid;
			_gid = gid;
			this.setSize(480,215);
			_init();
		}
		private function _init():void
		{
			_initBg();
			_initContent();
		}
		/**
		 * 初始背景 
		 * 
		 */		
		private function _initBg():void
		{
			var scaleTexture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_dinew"),new Rectangle(1 ,1 , 1, 1));
			var bg:Scale9Image = new Scale9Image(scaleTexture);
			bg.width = 480;
			bg.height = 211;
			this.addChild(bg);
			
			var scaleTexture2:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_dinewzhezhao"),new Rectangle(44,44,2,2));
			var bg2:Scale9Image = new Scale9Image(scaleTexture2);
			bg2.width = 480;
			bg2.height = 211;
			this.addChild(bg2);
			
			var textname:String = "common_biankuanghuawen";
			var texture:Texture = SApplication.assets.getTexture(textname);
			var topImage:TiledImage = new TiledImage(texture)
			topImage.width = 480;
			this.addChild(topImage)
				
			var bottomImage:TiledImage = new TiledImage(texture)
			bottomImage.width = 480;
			bottomImage.y = 211-texture.height
			this.addChild(bottomImage)
				
			var fx:SImage = new SImage(SApplication.assets.getTexture("common_fengexian"))
				fx.width = 240
				fx.y = 73;
			this.addChild(fx);
			
			var fx2:SImage = new SImage(SApplication.assets.getTexture("common_fengexian"))
			fx2.width = 240
			fx2.y = 110;
			this.addChild(fx2);
//			var texture:Texture = SApplication.assets.getTexture("common_biankuanghuawen")
//			var toptileImg:TiledImage = new TiledImage(texture);
//			toptileImg.width = 480;
//			toptileImg.height = 7;
//			this.addChild(toptileImg)
				
//			var bottomtileImg:TiledImage = new TiledImage(texture);
//			bottomtileImg.width = 480;
//			bottomtileImg.height = 7;
//			bottomtileImg.y = 202;
//			this.addChild(bottomtileImg)
		}
		/**
		 * 初始内容 
		 * 
		 */		
		private function _initContent():void
		{
			//通关图片
			var reticon:SImage = new SImage(SApplication.assets.getTexture("fuben_tongguan_logo"));
			reticon.x = 258;
			reticon.y = -10;
			this.addChild(reticon);
			//战利品
			var zhanliping:SImage = new SImage(SApplication.assets.getTexture("fuben_tongguan_zhanlipin"));
			zhanliping.x = 82;
			zhanliping.y = 16;
			this.addChild(zhanliping);
			//经验
			var xp:SImage = new SImage(SApplication.assets.getTexture("fuben_jingyan"));
			xp.x = 71;
			xp.y = 45;
			this.addChild(xp);
			//银两
			var siliver:SImage = new SImage(SApplication.assets.getTexture("fuben_yinliang"));
			siliver.x = 86;
			siliver.y = 81;
			this.addChild(siliver);
			//武魂
			var wuhun:SImage = new SImage(SApplication.assets.getTexture("tongguan_wuhun"))
			wuhun.x = 71;
			wuhun.y = 119;
			this.addChild(wuhun);//add by zhengzheng
			
			
			//星级评定
			var starLabel:Label = new Label;
			starLabel.textRendererProperties.textFormat = ConstTextFormat.textformat;
			starLabel.x = 284;
			starLabel.y = 132;
			starLabel.text = CJLang("FUBEN_STARLABEL")
			this.addChild(starLabel);
			//点击继续
			hitcontinue = new Label;
			hitcontinue.x = 198;
			hitcontinue.y = 215;
			hitcontinue.textRendererProperties.textFormat = ConstTextFormat.fubenContineformat;
			hitcontinue.text = CJLang("FUBEN_HITCONINTUE")
			this.addEventListener(TouchEvent.TOUCH,hitContinueHandler);
			this.addChild(hitcontinue);
			
			
			xpvalue = new Label;
			xpvalue.textRendererProperties.textFormat = ConstTextFormat.fubenResultText;
			xpvalue.x = 152;
			xpvalue.y = xp.y;
			this.addChild(xpvalue);
			
			silivervalue = new Label;
			silivervalue.textRendererProperties.textFormat = ConstTextFormat.fubenResultText;
			silivervalue.x = 169;
			silivervalue.y = siliver.y;
			this.addChild(silivervalue);
			
			wuhunvalue = new Label;
			wuhunvalue.textRendererProperties.textFormat = ConstTextFormat.fubenResultText;
			wuhunvalue.x = 153;
			wuhunvalue.y = wuhun.y + 3;
			this.addChild(wuhunvalue);
			
		}
		/**
		 * 设置数据 
		 * @param value
		 * 
		 */		
		public function set data(value:Object):void
		{
			xpvalue.text = value.xp
			silivervalue.text = value.silver;
			if (value.hasOwnProperty("forcesoul"))
			{
				wuhunvalue.text = value.forcesoul;
			}
			else
			{
				wuhunvalue.text = "0";
			}
			//星级评定
			var starnum:int = value.star
			for(var i:int =0;i<3;i++)
			{
				var starimg:SImage
				if(i<=starnum)
				{
					starimg = new SImage(SApplication.assets.getTexture("fuben_tongguan_xing1"))
				}
				else
				{
					starimg = new SImage(SApplication.assets.getTexture("fuben_tongguan_xing2"))
				}
				starimg.x = 317+i*(33+9)
				starimg.y = 155;
				this.addChild(starimg)
			}
		}
		/**
		 * 点击继续 
		 * @param e
		 * 
		 */
		private var _boxLayer:CJFubenGuankaBoxLayer
		private var _randList:Vector.<int> = new Vector.<int>;
		private function hitContinueHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN)
			if(touch)
			{
				this.removeEventListener(TouchEvent.TOUCH,hitContinueHandler);
				this.removeFromParent(true);
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,randkAwardItemRet);
				SocketCommand_fuben.randAwarditem(_fid,_gid)

			}
		}
		
		private function randkAwardItemRet(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage
			if(msg.getCommand() == ConstNetCommand.CS_FUBEN_PASS_RAND_AWARD)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData,randkAwardItemRet)
				if(msg.retcode!=0)
				{
					switch(msg.retcode)
					{
						case 1:
							
							break;
					}
					return;
				}
				var iteminfo:Object = msg.retparams;
				_boxLayer = new CJFubenGuankaBoxLayer(_fid,_gid);
				_boxLayer.iteminfo = iteminfo
				CJLayerManager.o.addModuleLayer(_boxLayer);
			}
		}
		
		public function clear():void
		{
			_boxLayer.clear();
			_boxLayer.removeFromParent(true);
			_boxLayer = null;
		}
		
	}
}