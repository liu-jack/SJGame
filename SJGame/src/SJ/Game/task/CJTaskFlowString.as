package SJ.Game.task
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import SJ.Game.controls.HtmlTextField;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 +------------------------------------------------------------------------------
	 * 漂浮字
	 * 使用方法 new CJTaskFlowString("xxx").addToLayer();
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-21 上午10:16:58  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskFlowString extends SLayer
	{
		private var _font:String;
		/*漂浮的字*/
		private var _label:HtmlTextField;
		private var _loadCompleteFunction:Function;
		private var _resourceType:String;
		/*显示时间*/
		private var _animateTime:Number = 1;
		private var _tween:STween;
		/*漂移距离*/
		private var _tweenDistance:Number;
		private var _offsetX:Number = 0 ;
		private var _offsetY:Number = 0 ;
		private var _defaultTextFormat:TextFormat= new TextFormat("黑体" , 12 , 0xffffff);
		
		/**
		 * @param font : 要飘的字 ，支持html
		 * @param animateTime : 动画显示时间
		 * @param tweenDistance : 漂移距离
		 */		
		public function CJTaskFlowString(font:String , animateTime:Number = 1 , tweenDistance:Number = 10 , offsetX:Number=0 , offsetY:Number=0)
		{
			super();
			this._font = font;
			this._animateTime = animateTime;
			this._tweenDistance = tweenDistance;
			this._offsetX = offsetX;
			this._offsetY = offsetY;
			
			var contentRect:Point = this._getTextWidth(this._font);
			this.width = contentRect.x + 10;
			this.height = contentRect.y + 10;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_label = new HtmlTextField(this.width , this.height , "" , true ); 
			_label.color = uint(_defaultTextFormat.color);
			_label.fontSize = Number(_defaultTextFormat.size);
			_label.fontName = _defaultTextFormat.font;
			_label.hAlign = HAlign.LEFT;
			_label.vAlign = VAlign.TOP;
			_label.autoScale = true;
			
			_label.text = this._font;
			this.addChild(_label);
			_tween = new STween(_label , this._animateTime);
			_tween.moveTo(_label.x  , _label.y - _tweenDistance);
			_tween.onComplete = _tweenCompleteHandler
			Starling.juggler.add(_tween);
		}
		
		private function _getTextWidth(content:String):Point
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat(_defaultTextFormat.font , _defaultTextFormat.size , _defaultTextFormat.color);
			if(content == null)
			{
				tf.htmlText= "";
			}
			else
			{
				tf.htmlText = content;
			}
			tf.autoSize = TextFieldAutoSize.LEFT;
			if(content.indexOf("<br>") != -1 || content.indexOf("<br/>") != -1)
			{
				tf.wordWrap = true;
			}
			else
			{
				tf.wordWrap = false;
			}
			tf.condenseWhite = true;
			return new Point(tf.textWidth + 10 , tf.textHeight + 10);
		}
		
		private function _tweenCompleteHandler():void
		{
			Starling.juggler.remove(_tween);
			if(this.parent)
			{
				this.removeFromParent(true);
			}
		}
		
		public function addToLayer():void
		{
//			CJLayerManagerWrapper.o.addToModuleSequence(this);
			CJLayerManager.o.addToTipsLayer(this);
			this.x += this._offsetX;
			this.y += this._offsetY;
		}
	}
}