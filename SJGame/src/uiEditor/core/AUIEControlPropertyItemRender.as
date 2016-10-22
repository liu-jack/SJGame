package uiEditor.core
{
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class AUIEControlPropertyItemRender extends FeathersControl implements IListItemRenderer
	{
		public function AUIEControlPropertyItemRender()
		{
		}
		
		protected var itemLabel:Label;
		protected var itemText:TextInput;
		protected var _control:DisplayObject;
		protected var _maskcontrol:AUIEControlMask;
		
		protected var _index:int = -1;
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _owner:List;
		
		public function get owner():List
		{
			return List(this._owner);
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _data:Object;
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			if(value != null)
			{
				this._control = value["ext"].editorctrl;
				this._maskcontrol = value["ext"].maskctrl;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _isSelected:Boolean;
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		override protected function initialize():void
		{
			if(!this.itemLabel)
			{
				this.itemLabel = new Label();
				this.itemText = new TextInput();
				
				this.itemText.x = 50;
				this.itemText.width = 100;
				this.itemText.height = 20;
				this.itemText.text = "100";
//				var matrix:Array = [0,1,0,
//					1,1,1,
//					0,1,0];
//				this.itemText.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
//					new GlowFilter(0x00FF00,1.0,2.0,2.0,10,2)];
				
				this.addChild(this.itemLabel);
				this.addChild(this.itemText);
				
				this.itemText.addEventListener(Event.CHANGE,_textinputChange);
			}
		}
		
		private function _textinputChange(e:Event):void
		{
			_control[_data['text']] = (e.target as TextInput).text;
			_maskcontrol.invalidate();
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(dataInvalid)
			{
				this.commitData();
			}
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
			if(dataInvalid || sizeInvalid)
			{
				this.layout();
			}
		}
		
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			this.itemLabel.width = NaN;
			this.itemLabel.height = NaN;
			this.itemLabel.validate();
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this.itemLabel.width;
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = this.itemLabel.height;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		protected function commitData():void
		{
			if(this._data)
			{
				this.itemLabel.text = this._data['text'];
				this.itemText.text =  this._data['value'];
			}
			else
			{
				this.itemLabel.text = "";
			}
		}
		
		protected function layout():void
		{
			this.itemLabel.width = this.actualWidth;
			this.itemLabel.height = this.actualHeight;
		}
	}
}