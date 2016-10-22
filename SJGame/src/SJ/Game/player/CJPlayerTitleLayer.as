package SJ.Game.player
{
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SBitSet;
	
	import feathers.controls.ImageLoader;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	
	import starling.animation.Juggler;
	import starling.text.TextField;
	
	public class CJPlayerTitleLayer extends SLayer
	{
		
		private static var _seek:uint = 0;
		/**
		 * 显示名称 
		 */
		public static const TITLETYPE_NAME:uint = (++_seek);
		/**
		 * 任务问号 (灰色)
		 */
		
		public static const TITLETYPE_TASK_UNQUESTION:uint = 1<<(++_seek);
		/**
		 * 任务问号 
		 */
		public static const TITLETYPE_TASK_QUESTION:uint = 1<<(++_seek);
		/**
		 * 任务叹号(灰色)
		 */
		public static const TITLETYPE_TASK_UNCLAIM:uint = 1<<(++_seek);
		/**
		 * 任务叹号
		 */
		public static const TITLETYPE_TASK_CLAIM:uint = 1<<(++_seek);
		/**
		 * 寻路中...
		 */
		public static const TITLETYPE_TASK_NAVIGATING:uint = 1<<(++_seek);
		
		/**
		 * 等级提升...
		 */
		public static const TITLETYPE_UPLEVEL:uint = 1<<(++_seek);
		/**
		 * 显示所有 
		 */
		public static const TITLETYPE_ALL:uint = 0xFFFFFFFF;
		
		/**
		 * 显示标志位 
		 */
		private var _showflag:SBitSet;
		/*头顶的状态*/
		private var _tasklabel:SAnimate;
		private var _navLabel:ImageLoader;
		
		private var _juggler:Juggler;
		
		public function CJPlayerTitleLayer()
		{
			super();
			_showflag = new SBitSet();
		}
		private var _isNpc:Boolean;
		
		/**
		 * 显示标题 
		 * @param type TITLETYPE
		 * 
		 */
		public function showtitle(type:uint = 1):void
		{
			_showflag.set(type);	
			this.invalidate();
		}
		/**
		 * 隐藏标题 
		 * @param type
		 * 
		 */
		public function hidetitle(type:uint = TITLETYPE_ALL):void
		{
			_showflag.clear(type);
			this.invalidate();
		}
		
		public function get isNpc():Boolean
		{
			return _isNpc;
		}
		
		public function set isNpc(value:Boolean):void
		{
			_isNpc = value;
		}
		
		private var _nameField:TextField;
		
		private var _displayname:String = "";

		private var rect:SImage;
		
		public function get displayname():String
		{
			return _displayname;
		}
		
		/**
		 * 设置显示的名称 
		 * @param value
		 * 
		 */
		public function set displayname(value:String):void
		{
			_displayname = value;
			
			this.invalidate();
		}
		
		private function _drawname():void
		{
			_nameField.visible = false;
			if(_showflag.test(TITLETYPE_NAME))
			{
				if(_isNpc)
				{
					_nameField.color = 0xFFFFFF;
				}
				else
				{
					_nameField.color = 0x33D639;
				}
				_nameField.text = _displayname;
				_nameField.visible = true;
			}
		}
		
		private function _drawtask():void
		{
			_navLabel.visible = false;
			if(_tasklabel != null)
			{
				_tasklabel.visible = false;
			}
			if(_showflag.test(TITLETYPE_TASK_UNQUESTION))
			{
				if(_tasklabel != null)
				{
					_tasklabel.removeFromJuggler()
					_tasklabel.removeFromParent();
				}
				_tasklabel = new SAnimate(SApplication.assets.getTextures("common_heroloading_wenhaohui_") , 4);
				_tasklabel.y = -35;
				_tasklabel.x = -20;
				_tasklabel.visible = true;
				this.juggler.add(_tasklabel);
				this.addChild(_tasklabel);
			}
			else if(_showflag.test(TITLETYPE_TASK_QUESTION))
			{
				if(_tasklabel != null)
				{
					_tasklabel.removeFromJuggler()
					_tasklabel.removeFromParent();
				}
				_tasklabel = new SAnimate(SApplication.assets.getTextures("common_heroloading_wenhao_") , 4);
				_tasklabel.y = -35;
				_tasklabel.x = -20;
				_tasklabel.visible = true;
				this.juggler.add(_tasklabel);
				this.addChild(_tasklabel);
			}
			else if(_showflag.test(TITLETYPE_TASK_UNCLAIM))
			{
				if(_tasklabel != null)
				{
					_tasklabel.removeFromJuggler()
					_tasklabel.removeFromParent();
				}
				_tasklabel = new SAnimate(SApplication.assets.getTextures("common_heroloading_tanhaohui_") , 4);
				_tasklabel.y = -35;
				_tasklabel.x = -20;
				_tasklabel.visible = true;
				this.juggler.add(_tasklabel);
				this.addChild(_tasklabel);
			}
			else if(_showflag.test(TITLETYPE_TASK_CLAIM))
			{
				if(_tasklabel != null)
				{
					_tasklabel.removeFromJuggler()
					_tasklabel.removeFromParent();
				}
				_tasklabel = new SAnimate(SApplication.assets.getTextures("common_heroloading_tanhao_") , 4);
				_tasklabel.y = -35;
				_tasklabel.x = -20;
				_tasklabel.visible = true;
				this.juggler.add(_tasklabel);
				this.addChild(_tasklabel);
			}
			else if(_showflag.test(TITLETYPE_TASK_NAVIGATING))
			{
				_navLabel.source = SApplication.assets.getTexture("common_zidongxunluzhong");
				_navLabel.visible = true;
				_navLabel.x = -70;
			}
			else if(_showflag.test(TITLETYPE_UPLEVEL))
			{
				_navLabel.source = SApplication.assets.getTexture("common_dengjitisheng");
				_navLabel.visible = true;
				_navLabel.x = -70;
			}
		}
		
		override protected function draw():void
		{
			if(isInvalid(INVALIDATION_FLAG_ALL))
			{
				_drawname();
				_drawtask();
			}
			super.draw();
		}
		
		override protected function initialize():void
		{
			_nameField = new TextField(150,30,"");
			_nameField.y = -25;
			_nameField.pivotX = 75;
			_nameField.color = 0x33D639;
			_nameField.visible = false;
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			_nameField.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
			addChild(_nameField);

			_navLabel = new ImageLoader();
			_navLabel.visible = false;
			_navLabel.y = -35;
			this.addChild(_navLabel);
			
			
//			_tasklabel = new SAnimate(SApplication.assets.getTextures("common_heroloading_wenhaohui_") , 4);
//			_tasklabel.y = -35;
//			_tasklabel.x = -20;
//			_tasklabel.visible = false;
//			this.juggler.add(_tasklabel);
//			this.addChild(_tasklabel);
			
			super.initialize();
		}

		public function get juggler():Juggler
		{
			return _juggler;
		}

		public function set juggler(value:Juggler):void
		{
			_juggler = value;
		}
		
		override public function dispose():void
		{
			if(_tasklabel)
			{
				_tasklabel.removeFromJuggler();
			}
			_juggler = null;
			super.dispose();
		}
		
		

	}
}