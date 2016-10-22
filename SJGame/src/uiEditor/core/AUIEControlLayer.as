package uiEditor.core
{
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.text.BitmapFontTextFormat;
	
	import flash.geom.Point;
	import flash.text.ReturnKeyLabel;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	

	
	public class AUIEControlLayer extends SLayer
	{
		private var _canvas:AUIECanvas;
		public function AUIEControlLayer(canvas:AUIECanvas)
		{
			_canvas = canvas;
			super();
		}
		
		override protected function draw():void
		{
			if(isInvalid(INVALIDATION_FLAG_STATE))
			{
				if(_canvas.zoomLevel == 1)
				{
					
					_btn_zoom.label = "<font color=\"#ff0000\"><B>Z</B></font>oomIn";
				}
				else
				{
					_btn_zoom.label = "ZoomOut";
				}
			}
			super.draw();
		}
		
		private var _btn_zoom:Button;
		private var _titleLabel:Label;
		private var _propertylayer:AUIEControlPropertyLayer;
		override protected function initialize():void
		{
			
			
			_titleLabel = new Label();
			_titleLabel.text = "ToolBox";
			_titleLabel.addEventListener(TouchEvent.TOUCH,_onTouch);
			addChild(new SImage(Texture.fromColor(70,20),true));
			addChild(_titleLabel);
			
			_btn_zoom = new Button();
			_btn_zoom.defaultSkin = new SImage(Texture.fromColor(70,20),true);
			_btn_zoom.labelFactory = function ():ITextRenderer
			{
				var r:TextFieldTextRenderer = new TextFieldTextRenderer();
				r.isHTML = true;
				return r;
			}
			_btn_zoom.label = "ZoomIn";
		
			_btn_zoom.y = 20;
			addChild(_btn_zoom);
			_btn_zoom.addEventListener(Event.TRIGGERED,function(e:*):void
			{
				
				if(_canvas.zoomLevel == 1)
				{
					_canvas.zoomLevel = 0.5;
				}
				else
				{
					_canvas.zoomLevel = 1;
				}
				invalidate(INVALIDATION_FLAG_STATE);
			});
			
			
			
			
			var list:List = new List();
			list.y = 40;
			list.backgroundSkin = new SImage(Texture.fromColor(70,20,0x7FFFFF00),true);
			list.width = 70;
			list.height = 300;
			this.addChild( list );
			
			var groceryList:ListCollection = new ListCollection(
				[
					{ text: "Button"},
					{ text: "ImageLoader"},
					{ text: "Bread"},
					{ text: "Chicken"},
				]);
			
			list.addEventListener(Event.CHANGE,function change(e:Event):void
			{
				var nbtn:Button = new Button();
				nbtn.defaultSkin = new SImage(Texture.fromColor(70,20),true);
				nbtn.width = 70;
				nbtn.height = 20;
				nbtn.label = "nbtn";
				_canvas.rootUI.addChild(nbtn);
				var  mask:AUIEControlMask = new AUIEControlMask(nbtn,_propertylayer);
				_canvas.rootUIMask.addChild(mask);
				
				_propertylayer.editProperty(nbtn,mask);
			});
			list.dataProvider = groceryList;
			
			list.itemRendererProperties.labelField = "text";
			list.itemRendererProperties.iconTextureField = "thumbnail";
			
			
			_propertylayer = new AUIEControlPropertyLayer();
			_propertylayer.x = 70
			addChild(_propertylayer);
			
			
			super.initialize();
		}
		private var _isDrag:Boolean = false;
		private var _Dragoffset:Point;
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			
			if(touch)
			{
				
				var localPoint:Point = globalToLocal(new Point(touch.globalX,touch.globalY));
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
//						var pos:Point = globalToLocal(new Point(touch.globalX,touch.globalY));
						x = touch.globalX - _Dragoffset.x;
						y = touch.globalY - _Dragoffset.y;
					}
					else if(touch.phase == TouchPhase.ENDED)
					{
						x = touch.globalX - _Dragoffset.x;
						y = touch.globalY - _Dragoffset.y;
						_isDrag = false;
					}
				}
				
			}
		}
		
		
	}
}