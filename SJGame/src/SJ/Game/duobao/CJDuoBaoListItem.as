package SJ.Game.duobao
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CJDuoBaoListItem extends Button implements IListItemRenderer
	{
		protected var _data:Object;
		protected var _index:int;
		protected var _owner:List;
		protected var _isScrolled:Boolean;
		
		private var _isOpen:Boolean;
		private var _id:int;
		
		private var _icon:SImage = null;
		private var _select:Scale9Image = null;
		private var _tip:SAnimate = null;
		
		public function CJDuoBaoListItem()
		{
			super();
			this.width = 51;
			this.height = 51;
			this.addEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function get isOpen():Boolean
		{
			return this._isOpen;
		}
		
		public function get id():int
		{
			return this._id;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		public function get owner():List
		{
			return this._owner;
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				List(this._owner).removeEventListener(Event.SCROLL, _changeHandler);
				List(this._owner).removeEventListener(Event.CHANGE, _updateSelected);
			}
			this._owner = value;
			if(this._owner != null)
			{
				this._owner.addEventListener(Event.SCROLL , this._changeHandler);
				this._owner.addEventListener(Event.CHANGE,_updateSelected);
			}
		}
		
		protected function onSelected():void
		{
			var parent:CJSubDuoBaoLayer = this.owner.parent as CJSubDuoBaoLayer;
			parent.onSelectItem(this);
			
			if(CJDuoBaoLayer.TabIndex==1)//0夺宝 1寻宝， 如果寻宝界面打开，会弹出该宝物信息
			{
				(this.owner.parent as CJSubDuoBaoLayer)._onClickBaoWu(null);
			}
		}
		
		protected function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null)
			{
				return;
			}
			var localpoint:Point = this.globalToLocal(new Point(touch.globalX,touch.globalY));
			if(touch.phase == TouchPhase.BEGAN)
			{
				_isScrolled = false;
			}
			else if(touch.phase == TouchPhase.ENDED && !_isScrolled)
			{
				if(this.hitTest(localpoint) != null)
				{
					onSelected();
				}
			}
		}
		
		private function _updateSelected(e:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private function _changeHandler(e:Event):void
		{
			_isScrolled = true;
		}
		
		override protected function draw():void
		{
			const isTotalInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isTotalInvalid)
			{
				this._isOpen = this._data["isOpen"];
				this._id = this._data["id"];
				this.name = this._data["id"]; 
				var imageName:String = this.data["imageName"];
				if(_icon)
				{
					this.removeChild(_icon);
					_icon = null;
				}
				if(imageName != "")
				{
					if(!_icon)
					{
						_icon = new SImage(SApplication.assets.getTexture(imageName));
						_icon.x = 3.5;
						_icon.y = 3.5;
						_icon.name = "icon";
						this.addChild(_icon);
					}
					_icon.texture = SApplication.assets.getTexture(imageName);
				}
				
				this.labelFactory = textRender.glowTextRender;
				this.defaultLabelProperties.textFormat = 
					new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0xFF8800, null, null, null, null, null, TextFormatAlign.CENTER);
				this.label = String(this.data["text"]);
				
				this.defaultSkin = new SImage(SApplication.assets.getTexture("common_tubiaokuang1"));
					
				if(_select)
				{
					this.removeChild(_select);
					_select = null;
				}
				if(this._data["select"] == true)
				{
					_select = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_daojutubiaomiaobian02") , new Rectangle(8,8,1,1)));
					_select.width = 50;
					_select.height = 50;
					this.addChild(_select);
				}
				
				if(_tip)
				{
					this.removeChild(_tip);
					Starling.juggler.remove(_tip);
					_tip = null;
				}
				if(this._data["tip"])
				{
					_tip = new SAnimate(SApplication.assets.getTextures("common_kaiqi"), 6);
					_tip.touchable = false;
					_tip.width = this.width;
					_tip.height = this.height;
					this.addChild(_tip);
					Starling.juggler.add(_tip);
				}
			}
			super.draw();
		}
		
		override public function dispose():void
		{
			_data = null;
			if(_tip)
			{
				this.removeChild(_tip);
				Starling.juggler.remove(_tip);
				_tip = null;
			}
			super.dispose();
		}
	}
}