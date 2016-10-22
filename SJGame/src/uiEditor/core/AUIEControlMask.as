package uiEditor.core
{
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.core.FeathersControl;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.Shape;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class AUIEControlMask extends SLayer
	{
		private  static const ANCHOR_LT:String = "lt";
		private  static const ANCHOR_LD:String = "ld";
		private  static const ANCHOR_RT:String = "rt";
		private  static const ANCHOR_RD:String = "rd";
		
		private var _anchors:Dictionary = new Dictionary(true);
		
		private var _authorPoint:SImage;
		private var _control:FeathersControl;
		private var _propertyControl:AUIEControlPropertyLayer;
		private var _maskshape:Shape;
		public function AUIEControlMask(control:FeathersControl,propertyControls:AUIEControlPropertyLayer)
		{
			_control = control;
			_propertyControl = propertyControls;
//			_control.addChild(this);
		}
		
		private function _genAnchor(AnchorType:String):void
		{
			_authorPoint = new SImage(Texture.fromColor(4,4,0xFFFF0000),true);
			_authorPoint.touchable = true;
			_authorPoint.pivotX = 4/2;
			_authorPoint.pivotY = 4/2;
			_authorPoint.name = AnchorType;
			_anchors[AnchorType] = _authorPoint;
			
			addChild(_authorPoint);
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			if (isInvalid(INVALIDATION_FLAG_ALL))
			{
				
				_maskshape.graphics.clear();
				_maskshape.graphics.beginFill(0x0000FF,0.4);
				_maskshape.graphics.drawRect(0,0,_control.width,_control.height);
				_maskshape.graphics.endFill();
				
				
				for each(var _authorPoint:SImage in _anchors)
				{
					switch(_authorPoint.name)
					{
						case ANCHOR_LT:
						{
							
							break;
						}
						case ANCHOR_LD:
						{
							_authorPoint.y = _control.height;
							break;
						}
						case ANCHOR_RT:
						{
							_authorPoint.x = _control.width;
							break;
						}
						case ANCHOR_RD:
						{
							_authorPoint.x = _control.width;
							_authorPoint.y = _control.height;
							break;
						}
					}
				}
				
				x = _control.x;
				y = _control.y;
			}
			super.draw();
		}
		
		override protected function initialize():void
		{
			_maskshape = new Shape();
			addChild(_maskshape);
			
			_genAnchor(ANCHOR_LT);
			_genAnchor(ANCHOR_LD);
			_genAnchor(ANCHOR_RD);
			_genAnchor(ANCHOR_RT);
			
			
			addEventListener(TouchEvent.TOUCH,_onTouch);
//			_control.addEventListener(Event.RESIZE,_onCtrlSizeChange);
//			_authorPoint = new SImage(Texture.fromColor(4,4,0xFFFF0000),true);
//			_authorPoint.touchable = true;
//			_authorPoint.pivotX = 4/2;
//			_authorPoint.pivotY = 4/2;
//			addChild(_authorPoint);
			
			super.initialize();
		}
		private function _onCtrlSizeChange(e:Event):void
		{
			this.invalidate();
		}
		
		private var _isDrag:Boolean = false;
		private var _Dragoffset:Point;
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			
			if(touch)
			{
				
				var localPoint:Point =  globalToLocal(new Point(touch.globalX,touch.globalY));
				if(hitTest(localPoint,true) != null)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						
						
						_Dragoffset = new Point();
						_Dragoffset.x = localPoint.x;
						_Dragoffset.y = localPoint.y;
						_isDrag = true;
						//						dispatchEventWith(MouseEvent.Event_MouseClick,false,touch);
					}
					if(touch.phase == TouchPhase.MOVED && _isDrag)
					{
						var pos:Point = parent.globalToLocal(new Point(touch.globalX,touch.globalY));
						_control.x = pos.x - _Dragoffset.x;
						_control.y = pos.y - _Dragoffset.y;
						this.invalidate();
					}
					else if(touch.phase == TouchPhase.ENDED)
					{
						var pos:Point = parent.globalToLocal(new Point(touch.globalX,touch.globalY));
						_control.x = pos.x - _Dragoffset.x;
						_control.y = pos.y - _Dragoffset.y;
						_isDrag = false;
						_propertyControl.editProperty(_control,this);
						this.invalidate();
					}
				}
				
			}
		}
		
	}
}