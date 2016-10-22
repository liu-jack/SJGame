package SJ.Game.create
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstCreateRole;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfMaskWordProperty;
	import SJ.Game.data.config.CJDataOfNameProperty;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.animation.IAnimatable;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 创建角色图层
	 * @author longtao
	 * 
	 */
	public class CJCreateLayer extends SLayer implements IAnimatable
	{
		private var _bgLayer:SLayer;
		/**  **/
		public function get bgLayer():SLayer
		{
			return _bgLayer;
		}
		/** @private **/
		public function set bgLayer(value:SLayer):void
		{
			_bgLayer = value;
		}
		private var _imgCreateBG:ImageLoader;
		/**  创建角色背景图 **/
		public function get imgCreateBG():ImageLoader
		{
			return _imgCreateBG;
		}
		/** @private **/
		public function set imgCreateBG(value:ImageLoader):void
		{
			_imgCreateBG = value;
		}
		private var _imgSelect0:ImageLoader;
		/**  角色 男战士 **/
		public function get imgSelect0():ImageLoader
		{
			return _imgSelect0;
		}
		/** @private **/
		public function set imgSelect0(value:ImageLoader):void
		{
			_imgSelect0 = value;
		}
		private var _imgSelect1:ImageLoader;
		/**  角色 女法师 **/
		public function get imgSelect1():ImageLoader
		{
			return _imgSelect1;
		}
		/** @private **/
		public function set imgSelect1(value:ImageLoader):void
		{
			_imgSelect1 = value;
		}
		private var _imgSelect2:ImageLoader;
		/**  角色 男火枪手 **/
		public function get imgSelect2():ImageLoader
		{
			return _imgSelect2;
		}
		/** @private **/
		public function set imgSelect2(value:ImageLoader):void
		{
			_imgSelect2 = value;
		}
		private var _shineLayer:SLayer;
		/**  该图层用于放置选择人物高亮与其他遮罩部分 **/
		public function get shineLayer():SLayer
		{
			return _shineLayer;
		}
		/** @private **/
		public function set shineLayer(value:SLayer):void
		{
			_shineLayer = value;
		}
		private var _controlLayer:SLayer;
		/**  该图层用于放置选择人物高亮与其他遮罩部分 **/
		public function get controlLayer():SLayer
		{
			return _controlLayer;
		}
		/** @private **/
		public function set controlLayer(value:SLayer):void
		{
			_controlLayer = value;
		}
		private var _desc0:Label;
		/**  人物介绍 **/
		public function get desc0():Label
		{
			return _desc0;
		}
		/** @private **/
		public function set desc0(value:Label):void
		{
			_desc0 = value;
		}
		private var _desc1:Label;
		/**  人物介绍 **/
		public function get desc1():Label
		{
			return _desc1;
		}
		/** @private **/
		public function set desc1(value:Label):void
		{
			_desc1 = value;
		}
		private var _desc2:Label;
		/**  人物介绍 **/
		public function get desc2():Label
		{
			return _desc2;
		}
		/** @private **/
		public function set desc2(value:Label):void
		{
			_desc2 = value;
		}
		private var _desc3:Label;
		/**  人物介绍 **/
		public function get desc3():Label
		{
			return _desc3;
		}
		/** @private **/
		public function set desc3(value:Label):void
		{
			_desc3 = value;
		}
		private var _desc4:Label;
		/**  人物介绍 **/
		public function get desc4():Label
		{
			return _desc4;
		}
		/** @private **/
		public function set desc4(value:Label):void
		{
			_desc4 = value;
		}
		private var _desc5:Label;
		/**  人物介绍 **/
		public function get desc5():Label
		{
			return _desc5;
		}
		/** @private **/
		public function set desc5(value:Label):void
		{
			_desc5 = value;
		}
		private var _desc6:Label;
		/**  人物介绍 **/
		public function get desc6():Label
		{
			return _desc6;
		}
		/** @private **/
		public function set desc6(value:Label):void
		{
			_desc6 = value;
		}
		private var _desc7:Label;
		/**  人物介绍 **/
		public function get desc7():Label
		{
			return _desc7;
		}
		/** @private **/
		public function set desc7(value:Label):void
		{
			_desc7 = value;
		}
		private var _desc8:Label;
		/**  人物介绍 **/
		public function get desc8():Label
		{
			return _desc8;
		}
		/** @private **/
		public function set desc8(value:Label):void
		{
			_desc8 = value;
		}
		private var _imgCreateTinyBG:ImageLoader;
		/**  名字底图 **/
		public function get imgCreateTinyBG():ImageLoader
		{
			return _imgCreateTinyBG;
		}
		/** @private **/
		public function set imgCreateTinyBG(value:ImageLoader):void
		{
			_imgCreateTinyBG = value;
		}
		private var _tiCreateName:TextInput;
		/**  昵称输入框 **/
		public function get tiCreateName():TextInput
		{
			return _tiCreateName;
		}
		/** @private **/
		public function set tiCreateName(value:TextInput):void
		{
			_tiCreateName = value;
		}
		private var _imgCreateFight:ImageLoader;
		/**  战士标识图 **/
		public function get imgCreateFight():ImageLoader
		{
			return _imgCreateFight;
		}
		/** @private **/
		public function set imgCreateFight(value:ImageLoader):void
		{
			_imgCreateFight = value;
		}
		private var _imgCreateMagic:ImageLoader;
		/**  法师标识图 **/
		public function get imgCreateMagic():ImageLoader
		{
			return _imgCreateMagic;
		}
		/** @private **/
		public function set imgCreateMagic(value:ImageLoader):void
		{
			_imgCreateMagic = value;
		}
		private var _imgCreateGun:ImageLoader;
		/**  火枪手标识图 **/
		public function get imgCreateGun():ImageLoader
		{
			return _imgCreateGun;
		}
		/** @private **/
		public function set imgCreateGun(value:ImageLoader):void
		{
			_imgCreateGun = value;
		}
		private var _btnCreateStart:Button;
		/**  开始游戏 **/
		public function get btnCreateStart():Button
		{
			return _btnCreateStart;
		}
		/** @private **/
		public function set btnCreateStart(value:Button):void
		{
			_btnCreateStart = value;
		}
		private var _labelFake:Label;
		/**  其他角色进入游戏 130 315 **/
		public function get labelFake():Label
		{
			return _labelFake;
		}
		/** @private **/
		public function set labelFake(value:Label):void
		{
			_labelFake = value;
		}
		private var _btnRandomName:Button;
		/**  随机名称骰子 **/
		public function get btnRandomName():Button
		{
			return _btnRandomName;
		}
		/** @private **/
		public function set btnRandomName(value:Button):void
		{
			_btnRandomName = value;
		}


		
		
		
		/** 色子当前纹理名称 **/
		private var _diceName:String = "create_shaizi1";
		private var _imgRandom:ImageLoader;
		
//		/**
//		 * 左侧遮罩
//		 */
//		private var _maskleft : SImage;
//		/**
//		 * 右侧遮罩
//		 */
//		private var _maskright : SImage;
		
		/**
		 * 闪光图层
		 */
		private var _spark : Scale3Image;
		
		/**
		 * "假名字进入游戏"时间记录
		 */
		private var _fakeNewTime:Number = 0;
		private var _fakeOldTime:Number = 0;
		
		/**
		 * 保存"假名字进入游戏"文字数据
		 */
		private var _fakeTextArr:Array = new Array;
		
		private var _descScale9Image0:Scale9Image;
		private var _descScale9Image1:Scale9Image;
		private var _descScale9Image2:Scale9Image;
		
		private var _descLabel0:CJTaskLabel = new CJTaskLabel;
		private var _descLabel1:CJTaskLabel = new CJTaskLabel;
		private var _descLabel2:CJTaskLabel = new CJTaskLabel;
		
		private var _descLabel3:CJTaskLabel = new CJTaskLabel;
		private var _descLabel4:CJTaskLabel = new CJTaskLabel;
		private var _descLabel5:CJTaskLabel = new CJTaskLabel;
		
		private var _descLabel6:CJTaskLabel = new CJTaskLabel;
		private var _descLabel7:CJTaskLabel = new CJTaskLabel;
		private var _descLabel8:CJTaskLabel = new CJTaskLabel;
		
		public function CJCreateLayer()
		{
			super();
		}
		
		/**
		 * 角色的形象索引
		 */
		private var _roleIndex:uint = ConstCreateRole.ConstDefaultIndex;
		
		/**
		 * 移动遮罩Mask,并设置闪光区域
		 * @param targetX	目的坐标X
		 * @param gapWidth	两遮罩间的宽度
		 * 
		 */
		private function moveMaskAndSpark( targetX:uint, gapWidth:uint ) : void
		{
//			_maskleft.x =  targetX - _maskleft.width;
//			_maskright.x = targetX + gapWidth;
			
			_spark.visible = true;
			_spark.x = targetX;
			_spark.y = 10;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var temp:Texture;
			temp = SApplication.assets.getTexture("create_kaishi");
			_btnCreateStart.defaultSkin = new SImage( temp );
			_btnCreateStart.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				// 该处进行名称检测
				var rolename:String = tiCreateName.text;
				if (SStringUtils.isEmpty(rolename))
				{
					CJMessageBox(CJLang("ERROR_CREATE_ROLENAME_NULL"));
					return;
				}
				
				// 判断角色名称长度
				if (rolename.length < ConstCreateRole.ConstMinRoleNameCount || 
				rolename.length > ConstCreateRole.ConstMaxRoleNameCount)
				{
					CJMessageBox(CJLang("ERROR_CREATE_ROLENAME"));
					return;
				}
				
				// 判断屏蔽字
				if (CJDataOfMaskWordProperty.o.isMaskWord(rolename))
				{
					CJMessageBox(CJLang("ERROR_CREATE_ROLENAME_MASK"));
					return;
				}
				
//				// _roleIndex 为 0男战士，1女战士，2男法师，3女法师，4男火枪，5女火枪
//				// 数据定义 1战士2法师 8 火枪手
//				var job:uint = 0;
//				if (_roleIndex==0 || _roleIndex==1)
//					job = 1;
//				else if(_roleIndex==2 || _roleIndex==3)
//					job = 2;
//				else
//					job = 8;
//				var sex:uint = _roleIndex % 2 + 1; // 1男2女
				
				// _roleIndex 0男战士 1女法师 2男火枪
				var job:uint = 0;
				var sex:uint = 0;
				if (0 == _roleIndex)
				{
					job = 1;
					sex = 1;
				}
				else if(1 == _roleIndex)
				{
					job = 2;
					sex = 2;
				}
				else
				{
					job = 8;
					sex = 1;
				}
				
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onCreateRole);
				SocketCommand_role.create_role( tiCreateName.text, job.toString(), sex.toString() );
			});
			
			/// maskleft与maskright共同进行遮挡
			var color:uint = 0xC8000000;
//			/// 设置遮罩  目前不显示该遮罩
//			_maskleft = new SImage( Texture.fromColor(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight, color), true );
//			_maskleft.x = 0;
//			_maskleft.y = 0;
//			_shineLayer.addChild(_maskleft);
//			
//			_maskright = new SImage( Texture.fromColor(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight, color), true );
//			_maskright.x = _maskright.width;
//			_maskright.y = 0;
//			_shineLayer.addChild(_maskright);
			// 底部遮罩
			var mask:SImage = new SImage( Texture.fromColor(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight, color), true );
			bgLayer.addChildAt(mask, 1);
			
			/// 设置闪光图
//			_spark = new SImage( SApplication.assets.getTexture("create_guang") );
			_spark = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("create_guang"), 80, 5 , Scale3Textures.DIRECTION_VERTICAL));
			_spark.x = 0;
			_spark.y = 0;
			_spark.width = 160;
			_spark.height = 300;
			_spark.visible = false;
//			bgLayer.addChildAt( _spark, bgLayer.getChildIndex(imgCreateFrame)-1);
			shineLayer.addChild(_spark);
				
			
			// 默认选择的角色
			var img:ImageLoader = this["imgSelect"+ConstCreateRole.ConstDefaultIndex] as ImageLoader;
			if (img != null)
			{
				moveMaskAndSpark(img.x, img.width);
			}
			
			addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void
			{
				var touch:Touch = e.getTouch(stage);
				if(null == touch || touch.phase != TouchPhase.BEGAN)
					return;
				var curLayer:CJCreateLayer = e.currentTarget as CJCreateLayer;
				if (null == curLayer)
					return;
				for ( var i:uint=0; i<ConstCreateRole.ConstMaxRoleCount; ++i )
				{
					img = curLayer["imgSelect"+i] as ImageLoader;
					if (null == img) 
						continue;
					// 判断当前触点位置在那个角色图片范围内
					if ( img.x <= touch.globalX && touch.globalX <= img.x+img.width && touch.globalY <= img.y+img.height )
					{
						if (_roleIndex == i)
							return;
						_roleIndex = i;
						
						moveMaskAndSpark(img.x, img.width);
						_judgeShowDesc();
						/// 重新选择角色不随机名字  2013.08.19
//						var sex:uint = _roleIndex % 2 + 1; // 1男2女
//						// 重新随机到一个名字
//						tiCreateName.text = _randomName(sex);
						/// 重新选择角色不随机名字 end
						return;
					}
				}
			});
			
			// 设置名称输入框字体格式
			var fontFormat:Object = tiCreateName.textEditorProperties;
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = false;
			fontFormat.textAlign = "center"; 
			fontFormat.maxChars = ConstCreateRole.ConstMaxRoleNameCount;
			tiCreateName.textEditorProperties = fontFormat;
			
			/// 设置字体
			var formate:Object = labelFake.textRendererProperties; 
			formate.textFormat = new TextFormat( "Arial", 7, 0xDEE035 );
			labelFake.textRendererProperties = formate;
			// 默认添一个随机名字
//			tiCreateName.text = _randomName(1);
			
			// 重新随机玩家姓名 
			_imgRandom = new ImageLoader();
			_imgRandom.x = btnRandomName.x;
			_imgRandom.y = btnRandomName.y;
			_imgRandom.source = SApplication.assets.getTexture(_diceName);
			_imgRandom.touchable = false;
			addChild(_imgRandom);
			
			_btnRandomName.defaultSkin = new SImage( Texture.fromColor(30, 30, 0x0000000000), true );
			_btnRandomName.addEventListener(Event.TRIGGERED, _reRandomName);
			

			// 武将描述
			_descScale9Image0 = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi"), new Rectangle(8,8,1,1)));
			_descScale9Image0.x = desc0.x;
			_descScale9Image0.y = desc0.y;
			_descScale9Image0.width = desc0.width;
			_descScale9Image0.height = desc0.height*4;
			addChild(_descScale9Image0);
			_descScale9Image0.touchable = false;
			
			_descScale9Image1 = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi"), new Rectangle(8,8,1,1)));
			_descScale9Image1.x = desc3.x;
			_descScale9Image1.y = desc3.y;
			_descScale9Image1.width = desc3.width;
			_descScale9Image1.height = desc3.height*4;
			addChild(_descScale9Image1);
			_descScale9Image1.touchable = false;
			_descScale9Image1.visible = false;
			
			_descScale9Image2 = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi"), new Rectangle(8,8,1,1)));
			_descScale9Image2.x = desc6.x;
			_descScale9Image2.y = desc6.y;
			_descScale9Image2.width = desc6.width;
			_descScale9Image2.height = desc6.height*4;
			addChild(_descScale9Image2);
			_descScale9Image2.touchable = false;
			_descScale9Image2.visible = false;
			
			var offsetY:int = 5;
			for (var i:int=0; i<9; ++i)
			{
				var label:Label = this["desc"+i];
				var descLabel:CJTaskLabel = this["_descLabel"+i];
				descLabel.fontSize = 12;
				descLabel.x = label.x;
				descLabel.y = label.y;
				descLabel.width = label.width;
				descLabel.height = label.height;
				addChild(descLabel);
				descLabel.text = CJLang("CREATE_DESC_"+i);
				descLabel.touchable = false;
				descLabel.visible = false;
			}
			_descLabel0.visible = true;
			_descLabel1.visible = true;
			_descLabel2.visible = true;
		}
		
		// 判断显示
		private function _judgeShowDesc():void
		{
			if (_roleIndex >= ConstCreateRole.ConstMaxRoleCount)
				return;
			// 
			_descScale9Image0.visible = false;
			_descScale9Image1.visible = false;
			_descScale9Image2.visible = false;
			
			for (var i:int=0; i<9; ++i)
				this["_descLabel"+i].visible = false;
			
			(this["_descScale9Image"+_roleIndex] as Scale9Image).visible = true;
			
			var temp:int = _roleIndex*3;
			for (i=0; i<3; ++i)
			{
				var v:CJTaskLabel = this["_descLabel"+String(temp+i)] as CJTaskLabel;
				v.visible = true;
			}
		}
		
		private function _reRandomName(e:Event):void
		{
			var sex:uint = _roleIndex % 2 + 1; // 1男2女
			// 重新随机到一个名字
			tiCreateName.text = _randomName(sex);
			_diceName = "create_shaizi"+((uint(Math.random() * 37))%5 + 1);
			_imgRandom.source = SApplication.assets.getTexture(_diceName);
		}
		
		/**
		 * 创建角色
		 * @param e
		 * 
		 */
		private function _onCreateRole( e:Event ) : void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ROLE_CREATE)
				return;
			
			e.target.removeEventListener(e.type,_onCreateRole);
			var retCode:uint = message.params(0);
			var isSucceed:Boolean = message.params(1)// 创建成功
				
			switch(retCode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_CREATE_ROLENAME_SAME", _reRandomName));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJCreateLayer._onCreateRole retcode="+message.retcode );
					return;
			}
			
			if ( isSucceed )
			{
				var userLoginData:CJDataOfRole = CJDataManager.o.DataOfRole;
				userLoginData.name = tiCreateName.text;
				
				SApplication.moduleManager.exitModule("CJCreateModule");
				SApplication.stateManager.ChangeState("GameStateGaming");
			}
		}
		
		/**
		 * 每隔一段时间添加一次
		 * @param time
		 * 
		 */
		public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			_fakeNewTime += time;
			if ( (_fakeNewTime - _fakeOldTime) < ConstCreateRole.ConstTimeGap )
			{
				return;
			}
			_fakeOldTime = _fakeNewTime;
			
			/// 名称
			var fakeName:String = _randomName();
			
			/// 保存对应条数数据
			if( _fakeTextArr.length > ConstCreateRole.ConstFakeLabelMaxLine )
			{
				_fakeTextArr.shift();
				
			}
			var fakeDesc:String = fakeName + CJLang("CREATE_ALREADY_ENTER") + "\n";
			_fakeTextArr.push(fakeDesc)
			
			labelFake.text = "";
			for ( var i:* in _fakeTextArr )
			{
				labelFake.text += _fakeTextArr[i];
			}
		}
		
		/**
		 * 随机一个名字
		 * @param sex 性别 0随机性别1男2女
		 * @return 
		 * 
		 */
		private function _randomName(sex:int=0):String
		{
			// 姓氏
			var lastNamelist:Array = CJDataOfNameProperty.o.getLastNameList();
			// 男子名
			var maleNamelist:Array = CJDataOfNameProperty.o.getMaleNameList();
			// 女子名
			var femaleNamelist:Array = CJDataOfNameProperty.o.getFemaleNamelist();
			// 中间名
			var midNamelist:Array = CJDataOfNameProperty.o.getMidNameArr();
			
			var len:uint = lastNamelist.length;
			var ranNum:uint = (Math.random()*2089*17) % len;
			var str:String = new String;
			
			// 检测随机名字是否包含敏感字
			for (;;)
			{
				len = lastNamelist.length;
				ranNum = (Math.random()*2089*17) % len;
				// 先随机姓
				str = lastNamelist[ranNum];
				
				// 默认则先随机姓名
				if (0==sex)
					sex = (Math.random()*2089*31) % 2 +1;
				
				// 随机中间名称
				len = midNamelist.length;
				ranNum = (Math.random()*2089*31) % len;
				str += midNamelist[ranNum]
				
				// 随机名
				if (1 == sex)
				{
					len = maleNamelist.length;
					ranNum = (Math.random()*2089*31) % len;
					str += maleNamelist[ranNum];
				}
				else
				{
					len = maleNamelist.length;
					ranNum = (Math.random()*2089*31) % len;
					str += femaleNamelist[ranNum];
				}
				
				// 判断屏蔽字
				if (!CJDataOfMaskWordProperty.o.isMaskWord(str))
					break;
			}

			
			return str;
		}
		
	}
}