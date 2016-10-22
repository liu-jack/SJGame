package SJ.Game.funcopen
{
	import SJ.Game.SocketServer.SocketCommand_funcpoint;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfFuncIndicatePropertyList;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.json.Json_function_indicate_setting;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.data.SDataBase;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	import engine_starling.utils.Logger;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能点开启
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-25 下午4:00:16  
	 +------------------------------------------------------------------------------
	 */
	public class CJFuncOpenLayer extends SLayer
	{
		//遮罩
		private var _mask:SLayer;
		//指引列表
		private var _indicateList:Array;
		//当前指引步骤
		private var _currentStep:int = -1;
		//功能开启配置
		private var _functionConfig:Json_function_open_setting;
		//指引配置
		private var _indicateConfig:Json_function_indicate_setting;
		//开启的功能点id
		private var _openFunctionId:int;
		//指引箭头
		private var _arrow:CJFuncArrow;
		//指引火圈
		private var _fire:SAnimate;
		private var _touchTime:int = 0;
		
		private const TYPE_MESSAGEBOX:int = 0;
		private const TYPE_DYNAMICMENU:int = 1;
		private const TYPE_INMODULE:int = 2;
		private const TYPE_MENU:int = 3;
		
		
		public function CJFuncOpenLayer(functionid:int)
		{
			super();
			this._openFunctionId = functionid;
		}
		
		override protected function initialize():void
		{
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			this._addEventListeners();
			this._initData();
			
		}
		
		private function _addEventListeners():void
		{
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_INDICATE_NEXT_STEP , this._nextStep);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_INDICATE_PRE_STEP , this._preStep);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_MAIN_BUTTON_MENU_OPENED, _onMeunOpen);
			this.addEventListener(TouchEvent.TOUCH , this._onTouch);
		}
		private function _force_exit():void
		{
			SocketCommand_funcpoint.completeFuncitonIndicate(_openFunctionId);
			SApplication.moduleManager.exitModule("CJFunctionOpenModule");
		}
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
				this._touchTime ++;
				if(this._touchTime >= 3)
				{
					
					_force_exit();
				}
			}
		}
		
		/**
		 * 指引上一步
		 */		
		private function _preStep(e:Event):void
		{
			if(e.type != CJEvent.EVENT_INDICATE_PRE_STEP)
			{
				return;
			}
			currentStep = currentStep - 1;
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_ENTER , false , {"step":currentStep});
			this._touchTime = 0;
		}
		
		/**
		 * 指引下一步
		 */	
		private function _nextStep(e:Event):void
		{
			if(e.type != CJEvent.EVENT_INDICATE_NEXT_STEP)
			{
				return;
			}
			//移除其它面板
			currentStep = currentStep + 1;
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_ENTER , false , {"step":currentStep});
			if(_currentStep >= this._indicateList.length)
			{
				SocketCommand_funcpoint.completeFuncitonIndicate(_openFunctionId);
				//销毁开启引导层
				SApplication.moduleManager.exitModule("CJFunctionOpenModule");
			}
			this._touchTime = 0;
		}
		
		/**
		 * 指引初始化数据 ， 开启功能点Id ，开启配置，指引配置
		 */	
		private function _initData():void
		{
			_functionConfig = CJDataOfFuncPropertyList.o.getProperty(_openFunctionId);
			_indicateList = CJDataOfFuncPropertyList.o.getFuncIndicateList(_openFunctionId);
			
			if(_indicateList.length == 0)
			{
				_indicateConfig = null;
			}
			else
			{
				_indicateConfig = CJDataOfFuncIndicatePropertyList.o.getProperty(_indicateList[_currentStep]);
			}
			currentStep = 0;
			
		}

		private function _drawPanelTo(pos:Point):void
		{
			var panel:CJFuncDescPanel = new CJFuncDescPanel(_functionConfig , _indicateConfig);
			panel.width = int(this._indicateConfig.maskwidth)+ 6;
			panel.height = int(this._indicateConfig.maskheight)+ 4;
			panel.x = (this.width - panel.width) >> 1;
			panel.y = (this.height - panel.height) >> 1;
			this.addChild(panel);
		}
		
		private function _drawFireTo(pos:Point,size:Point):void
		{
			_fire = new SAnimate(SApplication.assets.getTextures("common_kaiqi"), 6);
			var texture:Texture = SApplication.assets.getTextures("common_kaiqi")[0];

			_fire.pivotX = texture.frame.width/2;
			_fire.pivotY = texture.frame.height/2;
			_fire.x = pos.x + size.x/2;
			_fire.y = pos.y + size.y/2;
			_fire.scaleX = _fire.scaleY = 1.5;
			
			_fire.touchable = false;
			this.addChild(_fire);
			Starling.juggler.add(_fire);
		}
		
		private function _drawMashTo(pos:Point,size:Point):void
		{
			this._mask = CJMaskUtil.createMaskWithHoleOnTarget(pos.x - 5 ,pos.y - 5, size.x ==0?_indicateConfig.maskwidth:size.x  + 10
				, size.y ==0?_indicateConfig.maskheight:size.y + 10 , this);
			this._mask.alpha = 0.5;
			this.addChild(_mask);
		}
		
		private function _drawArrowTo(pos:Point,size:Point):void
		{
			pos = new Point(pos.x,pos.y);
			
			_arrow = new CJFuncArrow(_functionConfig , this._indicateConfig);
			_arrow.x = this._indicateConfig.iconx;
			_arrow.y = this._indicateConfig.icony;
			_arrow.touchable = false;
			//			1-左 2 - 上 3-右 4-下
			switch(parseInt(this._indicateConfig.icontype))
			{
				case 1:
					pos.x += size.x + 10;
					pos.y += size.y/2;
					break;
				case 2:
					pos.x += size.x/2;
					pos.y += size.y  + 10;
					break;
				case 3:
					pos.x -= 10;
					pos.y += size.y/2;
					break;
				case 4:
					pos.x += size.x/2;
					pos.y -= 10;
					break;
			}
			_arrow.x =pos.x;
			_arrow.y = pos.y;
			this.addChild(_arrow);
//			Starling.juggler.add(_arrow);
		}
		
		private function _draw_Type_TYPE_MESSAGEBOX():void
		{
			if(parseInt(_indicateConfig.functiontype) == TYPE_MESSAGEBOX&&
				_indicateConfig.functionctrlname != null)
			{
				_drawPanelTo(pos);
				var child:DisplayObject = CJLayerManager.o.rootLayer.getChildByNameDeep(_indicateConfig.functionctrlname);
				if(child == null)
				{
					Logger.log("CJFuncOpenLayer","can't found indicate type:" +_indicateConfig.functiontype +" control:"+_indicateConfig.functionctrlname);
					_force_exit();
					return;
				}
				var pos:Point = child.localToGlobal(new Point(0,0));
				pos = this.globalToLocal(pos);
				
				
				
				
				_drawArrowTo(pos,new Point(child.width,child.height));
			}
		}
		private function _draw_Type_TYPE_MENU():void
		{
			if(parseInt(_indicateConfig.functiontype) == TYPE_MENU&&
				_indicateConfig.functionctrlname != null)
			{
				var child:DisplayObject = CJLayerManager.o.rootLayer.getChildByNameDeep(_indicateConfig.functionctrlname);
				if(child == null)
				{
					Logger.log("CJFuncOpenLayer","can't found indicate type:" +_indicateConfig.functiontype +" control:"+_indicateConfig.functionctrlname);
					_force_exit();
					return;
				}
				
				var pos:Point = child.localToGlobal(new Point(0,0));
				pos = this.globalToLocal(pos);
				var size:Point = new Point(child.width,child.height);
				
				_drawMashTo(pos,size);
				_drawArrowTo(pos,size);
				_drawFireTo(pos,size);
			}
		}
		private function _draw_Type_TYPE_DYNAMICMENU():void
		{
			if(parseInt(_indicateConfig.functiontype) == TYPE_DYNAMICMENU&&
				_indicateConfig.functionctrlname != null)
			{
				var child:DisplayObject = CJLayerManager.o.rootLayer.getChildByNameDeep(_indicateConfig.functionctrlname);
				if(child == null)
				{
					Logger.log("CJFuncOpenLayer","can't found indicate type:" +_indicateConfig.functiontype +" control:"+_indicateConfig.functionctrlname);
					_force_exit();
					return;
				}
				

				var pos:Point = child.localToGlobal(new Point(0,0));
				pos = this.globalToLocal(pos);
				var size:Point = new Point(child.width,child.height);
				_drawMashTo(pos,size);
				_drawArrowTo(pos,size);
				_drawFireTo(pos,size);
			}
		}
		private function _draw_Type_TYPE_INMODULE():void
		{
			if(parseInt(_indicateConfig.functiontype) == TYPE_INMODULE&&
				_indicateConfig.functionctrlname != null)
			{
				var child:DisplayObject = CJLayerManager.o.rootLayer.getChildByNameDeep(_indicateConfig.functionctrlname);
				if(child == null)
				{
					Logger.log("CJFuncOpenLayer","can't found indicate type:" +_indicateConfig.functiontype +" control:"+_indicateConfig.functionctrlname);
					_force_exit();
					return;
				}
				

				var pos:Point = child.localToGlobal(new Point(0,0));
				pos = this.globalToLocal(pos);
				var size:Point = new Point(child.width,child.height);
				_drawMashTo(pos,size);
				_drawArrowTo(pos,size);
				_drawFireTo(pos,size);
			}
		}
		
		private function _onMeunOpen(e:Event):void
		{
			_draw_Type_TYPE_DYNAMICMENU();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(_indicateConfig == null)
			{
				SApplication.moduleManager.exitModule("CJFunctionOpenModule");
				return;
			}
			
			_draw_Type_TYPE_MESSAGEBOX();
			_draw_Type_TYPE_MENU();
			_draw_Type_TYPE_INMODULE();
			
			
			
		}
		
		
		/**
		 * 当前指引步骤
		 */		
		public function get currentStep():int
		{
			return _currentStep;
		}

		/**
		 * 当前指引步骤
		 */	
		public function set currentStep(value:int):void
		{
			if(_currentStep == value)
			{
				return;
			}
			this.removeChildren(0 , -1 , true);
			
			Starling.juggler.remove(_arrow);
			Starling.juggler.remove(_fire);
			_currentStep = value;
			//超出了，结束
			if(currentStep >= this._indicateList.length)
			{
				return;
			}
			_indicateConfig = CJDataOfFuncIndicatePropertyList.o.getProperty(_indicateList[_currentStep]);
			this.invalidate();
		}
		
		/**
		 * 销毁指引层
		 */		
		override public function dispose():void
		{
			super.dispose();
			if(_fire != null && Starling.juggler.contains(_fire))
			{
				Starling.juggler.remove(_fire);
			}
			if(_arrow != null && Starling.juggler.contains(_arrow))
			{
				Starling.juggler.remove(_arrow);
			}
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_INDICATE_NEXT_STEP , this._nextStep);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_INDICATE_PRE_STEP , this._preStep);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_MAIN_BUTTON_MENU_OPENED, _onMeunOpen);
		}
	}
}