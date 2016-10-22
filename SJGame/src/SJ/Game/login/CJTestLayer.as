package SJ.Game.login
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_account;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.events.Event;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.textures.Texture;
	
	public class CJTestLayer extends SLayer
	{
		public function CJTestLayer()
		{
			super();
			_vecsplit = new Vector.<Image>();
		}
		private var _buttonPKBoss:Button
		
		public function get buttonPKBoss():Button
		{
			return _buttonPKBoss;
		}
		
		public function set buttonPKBoss(value:Button):void
		{
			_buttonPKBoss = value;
		}
		private var _buttonPKoneOnoneBoss:Button;
		
		public function get buttonPKoneOnoneBoss():Button
		{
			return _buttonPKoneOnoneBoss;
		}
		
		public function set buttonPKoneOnoneBoss(value:Button):void
		{
			_buttonPKoneOnoneBoss = value;
		}
		
		private var _buttonPKoneOnone:Button;
		
		public function get buttonPKoneOnone():Button
		{
			return _buttonPKoneOnone;
		}
		
		public function set buttonPKoneOnone(value:Button):void
		{
			_buttonPKoneOnone = value;
		}
		
		private var _buttonReload:Button;
		
		public function get buttonReload():Button
		{
			return _buttonReload;
		}
		
		public function set buttonReload(value:Button):void
		{
			_buttonReload = value;
		}
		
		private var _btnNetTest:Button;
		
		/**
		 * 网络测试按钮 
		 * @return 
		 * 
		 */
		public function get btnNetTest():Button
		{
			return _btnNetTest;
		}
		public function set btnNetTest(value:Button):void
		{
			_btnNetTest = value;
		}
		private var _button:Button;
		
		public function get button():Button
		{
			return _button;
		}
		
		public function set button(value:Button):void
		{
			_button = value;
		}
		
		private var _btnNewLogin:Button;
		
		public function get btnNewLogin():Button
		{
			return _btnNewLogin;
		}
		
		public function set btnNewLogin(value:Button):void
		{
			_btnNewLogin = value;
		}
		
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		override protected function initialize():void
		{
			var buttonBgImage:Image = new SImage(Texture.fromColor(200,20,0xFFFFFF00,false,SApplication.assets.scaleFactor),true);
			_button.defaultSkin = buttonBgImage;
			_buttonPKBoss.defaultSkin = new SImage(Texture.fromColor(200,20,0xFFFFFF00,false,SApplication.assets.scaleFactor),true);
			_buttonPKoneOnone.defaultSkin = new SImage(Texture.fromColor(200,20,0xFFFFFF00,false,SApplication.assets.scaleFactor),true);
			_buttonPKoneOnoneBoss.defaultSkin = new SImage(Texture.fromColor(200,20,0xFFFFFF00,false,SApplication.assets.scaleFactor),true);
			_buttonReload.defaultSkin = new SImage(Texture.fromColor(200,20,0xFFFF0000,false,SApplication.assets.scaleFactor),true);
			_btnNetTest.defaultSkin = new SImage(Texture.fromColor(200,20,0xFF00FF00,false,SApplication.assets.scaleFactor),true);
			
			// add by long tao
			_btnNewLogin.defaultSkin = buttonBgImage;
//			_btnNewLogin.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
//				SApplication.moduleManager.exitModule("CJExampleModule");
//				SApplication.moduleManager.enterModule("CJMainUiModule");
//			});
			_btnNewLogin.label = "返回主界面";
			// add by long tao end
			
			_button.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				//				p.attack();
//				SApplication.stateManager.ChangeState("GameStateGaming",{"battletype":0});
			});
			
			_buttonPKBoss.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				//				p.attack();
//				SApplication.stateManager.ChangeState("GameStateGaming",{"battletype":1});
			});
			
			_buttonPKoneOnone.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				//				p.attack();
//				SApplication.stateManager.ChangeState("GameStateGaming",{"battletype":2});
			});
			
			_buttonPKoneOnoneBoss.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				//				p.attack();
//				SApplication.stateManager.ChangeState("GameStateGaming",{"battletype":3});
			});
			
			_buttonReload.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				//				p.attack();
				AssetManagerUtil.o.reloadCheckFile(function():void
				{
					
					AssetManagerUtil.o.disposeAssetsByGroup("resouce_profile");
					_buttonReload.defaultSkin = new SImage(Texture.fromColor(200,20,0xFF00FF00,false,SApplication.assets.scaleFactor),true);
				});
				
			});
			
			
			_buttonPKoneOnoneBoss.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				//				p.attack();
//				CONFIG::tech
//				{
//					SApplication.moduleManager.enterModule("SocketModule");
//				}
				//				SApplication.stateManager.ChangeState("GameStateGaming",{"battletype":3});
			});
			//			var change:Boolean = false;
			_btnNetTest.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
//				CONFIG::tech
//				{
//					if (!SocketManager.o.connected)
//					{
//					}
//					else
//					{
//						SocketCommand_account.login("peng.zhi","111111");
//						//SocketManager.o.call(ConstNetCommand.CS_LOGIN,"abc","abc");
////						SocketCommand_account.create_account("peng.zhi","111111");
//					}
//					
//					
//					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onLogined)
//					
//					
//					
//					
//					function _onLogined(e:Event):void
//					{
//						if((e.data as SocketMessage).getCommand() == ConstNetCommand.CS_LOGIN)
//						{
//							trace("logined:" + (e.data as SocketMessage).params());
//							SocketManager.o.removeEventListener(ConstNetCommand.CS_LOGIN,_onLogined)
//						}
//					}
//						
//						
//						//SApplication.moduleManager.enterModule("SocketModule");
//					}
				});
				super.initialize();
				
				
				return;
				
				q = new QuadBatch();
				
				
				
				var texture:Texture = SApplication.assets.getTexture("guanyu_attack_0000");
				var cutwidth:int = 3;
				var cutRect:Rectangle = new Rectangle();
				//剪裁图片
				for(var c_y:int = 0;c_y<texture.height ;c_y += cutwidth)
				{
					
					for(var c_x:int = 0;c_x<texture.width ;c_x += cutwidth)
					{
						cutRect.x = c_x;
						cutRect.y = c_y;
						cutRect.width = c_x + cutwidth>texture.width?texture.width - c_x:cutwidth;
						cutRect.height = c_y + cutwidth>texture.height?texture.height - c_y:cutwidth;
						
						var image:Image = new Image(Texture.fromTexture(texture,cutRect));
						_vecsplit.push(image);
						image.x = c_x - texture.frame.x;
						image.y = c_y - texture.frame.y;
						
					}
					
				}
				_quadBatchNeedRender = true;
				
				addChild(q);
				
				
				
				var mask:PixelMaskDisplayObject = new PixelMaskDisplayObject();
				
				var maskImage:Image = new Image(texture);
				var maskDisplayedImage:Quad = new Quad(maskImage.width,maskImage.height,0xCCCCCC);
				mask.mask = new Image(texture);
				mask.addChild(maskDisplayedImage);
				maskDisplayedImage.y = - maskDisplayedImage.height;
				addChild(mask);
				mask.alpha = 0.5;
				
				var t:STween = new STween(maskDisplayedImage,1);
				t.moveTo(0,0);
				t.onComplete = function():void{
					var length:int = _vecsplit.length;
					for(var i:int=0;i<length;i++)
					{
						mask.removeFromParent(true);
						animatefinish(i);
					}
				};
				Starling.juggler.add(t);
					
					
				}
				private function animatefinish(frameindex:int):void
				{
					if(frameindex >= _vecsplit.length)
						return;
					
					var t:STween = new STween(_vecsplit[frameindex],1.0,Transitions.EASE_OUT);
					_vecsplit[frameindex].scaleX = 0.5;
					_vecsplit[frameindex].scaleY = 0.5;
					t.moveTo(_vecsplit[frameindex].x + 100 * Math.random(),_vecsplit[frameindex].y + 20 * Math.random() -  10);
					//			t.scaleTo(0.5);
					//			t.fadeTo(0.001);
					t.onUpdate = function update():void{
						_quadBatchNeedRender = true;
					};
					
					Starling.juggler.add(t);
				}
				
				private var _vecsplit:Vector.<Image>;
				private var q:QuadBatch;
				private var _quadBatchNeedRender:Boolean;
				override public function render(support:RenderSupport, parentAlpha:Number):void
				{
					if(_quadBatchNeedRender)
					{
						_quadBatchNeedRender = false;
						q.reset();
						var length:int = _vecsplit.length;
						for(var i:int=0;i<length;i++)
						{
							q.addImage(_vecsplit[i]);
						}
					}
					
					
					
					super.render(support, parentAlpha);
					
					
				}
				
				
			}
				}