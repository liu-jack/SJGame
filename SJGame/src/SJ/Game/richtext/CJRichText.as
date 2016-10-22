package SJ.Game.richtext
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstRichText;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	import SJ.Game.utils.SWordsUtil;
	
	import engine_starling.SApplication;
	import engine_starling.Events.MouseEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class CJRichText extends SLayer
	{
		/** 当前layer宽度 */
		private var _width:int;
		/** 当前初始x坐标 */
		private var _initX:int;
		/** 当前初始y坐标 */
		private var _initY:int;
		/** 行间隔 */
		private var _spaceY:int;
		/*所有的element*/
		private var _elementArray:Array = new Array();
		/*实际的长度*/
		private var _realtextWidth:Number = 0;
		
		public function CJRichText(width:int)
		{
			super();
			this._width = width;
			this._init();
		}
		
		/**
		 * 初始化，子类实现
		 */		
		protected function _init():void
		{
		}
		
		override public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			super.y = value;
		}
		
		
		public function draWithJson(json:String):void
		{
			var elementArray:Array = CJRichTextElementHelper.JsonToElements(json);
			this.draWithElementArray(elementArray);
			
		}
		
		public function draWithElementArray(elementArray:Array):void
		{
			if(!elementArray || elementArray.length == 0)
			{
				return;
			}
			
			if(this.numChildren != 0)
			{
				this.removeChildren();
			}
			
			var element:CJRTElement;
			var curx:int = this._initX;
			var cury:int = this._initY;
			var curHeight:int = 0;
			_realtextWidth = 0;
			
			var animate:SAnimate;
			var button:Button;
			var image:SImage;
			var label:Label;
			var textFormat:TextFormat;
			
			var curLineElmArray:Array = new Array();
			this._elementArray = elementArray;
			for (var i:int = 0; i < elementArray.length; i++)
			{
				element = elementArray[i] as CJRTElement;
				switch(element.type)
				{
					case ConstRichText.CJRT_ELEMENT_TYPE_ANIMATE:
						// 动画
//						element = (element as CJRTElementAnimate);
						if (0 != curx)
						{
							// 不是本行第一个控件
							if (this._needNewLine(curx, (element as CJRTElementAnimate).width))
							{
								curx = 0;
								cury = cury + curHeight + this._spaceY;
								curHeight = element.height;
								curLineElmArray = [];
							}
						}
						curHeight = this._getCurHeight(curHeight, element.height);
						
						var aniVec:Vector.<Texture> = SApplication.assets.getTextures((element as CJRTElementAnimate).animateTextture)
						animate = new SAnimate(aniVec);
						animate.x = curx + element.spacex;
						animate.y = cury + element.spacey;
						animate.width = (element as CJRTElementAnimate).width;
						animate.height = element.height;
						this.addChild(animate);
						
						curx = curx + animate.width + element.spacex;
						curLineElmArray.push(animate);
						this._resetCurLineElemnetY(curLineElmArray, curHeight, cury);
						animate.name = ""+i;
						animate.addEventListener(MouseEvent.Event_MouseClick , this._clickHandler);
						
						_realtextWidth += animate.width;
						break;
					case ConstRichText.CJRT_ELEMENT_TYPE_BR:
						// 换行
						curx = 0;
						cury = cury + curHeight;
						curHeight = 0;
						curLineElmArray = [];
						break;
					case ConstRichText.CJRT_ELEMENT_TYPE_BUTTON:
						// 按钮
						if (0 != curx)
						{
							// 不是本行第一个控件
							if (this._needNewLine(curx, (element as CJRTElementButton).width))
							{
								curx = 0;
								cury = cury + curHeight + this._spaceY;
								curHeight = element.height;
								curLineElmArray = [];
							}
						}
						curHeight = this._getCurHeight(curHeight, element.height);
//						this._resetCurLineElemnetY(curLineElmArray, curHeight);
						
						button = new Button();
						button.x = curx + element.spacex;
						button.y = cury + element.spacey;
						button.width = (element as CJRTElementButton).width;
						button.height = element.height;
						button.defaultSkin = new SImage(SApplication.assets.getTexture((element as CJRTElementButton).defaultskin));
						if (null != (element as CJRTElementButton).downskin)
						{
							button.downSkin = new SImage(SApplication.assets.getTexture((element as CJRTElementButton).downskin));
						}
						if (null != element.text)
						{
							button.label = element.text;
						}
						this.addChild(button);
						curLineElmArray.push(button);
						this._resetCurLineElemnetY(curLineElmArray, curHeight, cury);
						button.addEventListener(Event.TRIGGERED, _onButtonClick);
						curx = curx + button.width + element.spacex;
						button.name = ""+i;
						button.addEventListener(MouseEvent.Event_MouseClick , this._clickHandler);
						
						_realtextWidth += button.width;
						break;
					case ConstRichText.CJRT_ELEMENT_TYPE_IMAGE:
						// 图片
						if (0 != curx)
						{
							// 不是本行第一个控件
							if (this._needNewLine(curx, (element as CJRTElementImage).width))
							{
								curx = 0;
								cury = cury + curHeight + this._spaceY;
								curHeight = element.height;
								curLineElmArray = [];
							}
						}
						curHeight = this._getCurHeight(curHeight, element.height);
						
						image = new SImage(SApplication.assets.getTexture((element as CJRTElementImage).textture));
						image.x = curx + element.spacex;
						image.y = cury + element.spacey;
						image.width = (element as CJRTElementImage).width;
						image.height = element.height;
						this.addChild(image);
						curx = curx + image.width + element.spacex;
						curLineElmArray.push(image);
						this._resetCurLineElemnetY(curLineElmArray, curHeight, cury);
						image.name = ""+i;
						image.addEventListener(MouseEvent.Event_MouseClick , this._clickHandler);
						
						_realtextWidth += image.width;
						break;
					case ConstRichText.CJRT_ELEMENT_TYPE_LABEL:
						// 文字
						curHeight = this._getCurHeight(curHeight, element.height);
						textFormat = new TextFormat((element as CJRTElementLabel).font,
													(element as CJRTElementLabel).size, 
													(element as CJRTElementLabel).color, 
													(element as CJRTElementLabel).bold,
													null,
													(element as CJRTElementLabel).underline);
						
						var wordsCount:int = element.text.split("").length;
						var bitMap:Array = SWordsUtil.getWordsBitMap(element.text);
						var textWidth:Number = SWordsUtil.getStandardTextWidth(element.text , textFormat);
						var cnWidth:int = SWordsUtil.standardCnWordsWidth(textFormat);
						var enWidth:int = SWordsUtil.standardEnWordsWidth(textFormat);
						var leaveWidth:int = this._width - curx - element.spacex;
						var cnWordWidth:int = SWordsUtil.standardCnWordsWidth(textFormat);
						
						if (textWidth <= leaveWidth)
						{
							// 文字宽度小于当前行剩余宽度，直接增加label
							label = new Label();
							label.x = curx + element.spacex;
							label.y = cury + element.spacey;
							label.text = element.text;
							label.height = element.height;
							label.width = textWidth + 5;
							label.textRendererProperties.textFormat = textFormat;
							this.addChild(label);
							curx = curx + textWidth + element.spacex;
							curLineElmArray.push(label);
							this._resetCurLineElemnetY(curLineElmArray, curHeight, cury);
						}
						else
						{
							var textArray:Array = element.text.split("");
							//先填充行剩余部分
							var length:int = bitMap.length;
							var count:int = 0 ;
							var totalWidth:int = 0;
							while(count <= length)
							{
								var wordLength:int = bitMap[count]== 0 ? enWidth:cnWidth;
								count++;
								totalWidth += wordLength;
								if(leaveWidth <= totalWidth)
								{
									count -- ;
									break;
								}
							}
							
							
							bitMap = bitMap.slice(count , length);
							var leaveWordArray:Array = textArray.slice(0 , count);
							textArray = textArray.slice(count, textArray.length);
							label = new Label();
							label.x = curx + element.spacex;
							label.y = cury + element.spacey;
							label.height = element.height;
							label.width = leaveWidth + 5;
							label.text = leaveWordArray.join("")+ "  ";
							label.textRendererProperties.textFormat = textFormat;
							this.addChild(label);
							curLineElmArray.push(label);
							this._resetCurLineElemnetY(curLineElmArray, curHeight, cury);
							
							//整行处理
							curx = 0;
							cury = cury + curHeight + this._spaceY;
							curHeight = element.height;
							curLineElmArray = [];
							while(textArray.length > 0)
							{
								var allTextWidth:int = SWordsUtil.getStandardTextWidth(textArray.join("") , textFormat);
								if (allTextWidth > _width)
								{
									count = 0 ;
									totalWidth = 0;
									length = bitMap.length;
									while(count <= length)
									{
										count++;
										wordLength = bitMap[count]== 0 ? enWidth:cnWidth;
										totalWidth += wordLength;
										if(_width <= totalWidth)
										{
											count -- ;
											break;
										}
									}
									
									// 当前行显示不完
									bitMap = bitMap.slice(count , length);
									var lineWordArray:Array = textArray.slice(0, count);
									textArray = textArray.slice(count, textArray.length);
									label = new Label();
									label.x = curx + element.spacex;
									label.y = cury + element.spacey;
									label.height = element.height;
									label.width = this._width;
									label.text = lineWordArray.join("") + CJTaskHtmlUtil.tab;
									label.textRendererProperties.textFormat = textFormat;
									this.addChild(label);
									curLineElmArray.push(label);
									this._resetCurLineElemnetY(curLineElmArray, curHeight, cury);
									// 换行
									curx = 0;
									cury = cury + curHeight + this._spaceY;
									curHeight = element.height;
									curLineElmArray = [];
								}
								else
								{
									label = new Label();
									label.x = curx + element.spacex;
									label.y = cury + element.spacey;
									label.height = element.height;
									label.width = allTextWidth + 5;
									label.text = textArray.join("");
									label.textRendererProperties.textFormat = textFormat;
									textArray = [];
									this.addChild(label);
									curx = curx + label.width + element.spacex;
									curHeight = element.height;
									curLineElmArray.push(label);
								}
							}
						}
						label.name = ""+i;
//						label.addEventListener(MouseEvent.Event_MouseClick , this._clickHandler);
						label.addEventListener(TouchEvent.TOUCH , this._clickHandler);
						
						_realtextWidth += textWidth;
						break;
				}
			}
			this.height = cury + curHeight;
		}
		
		/**
		 * 获取文字宽度
		 * @param text
		 * @param textFormat
		 * @return 
		 * 
		 */		
		private function _getTextWidth(text:String, textFormat:TextFormat):int
		{
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.wordWrap = false;
			tf.defaultTextFormat = textFormat;
			tf.text = text;
			return tf.textWidth;
		}
		
		private function _clickHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null)
			{
				return;
			}
			if(touch.phase == TouchPhase.ENDED)
			{
				var target:DisplayObject = e.target as DisplayObject;
				if(target == null)
				{
					return;
				}
				if(!target is Label)
				{
					return;
				}
				var name:String = target.name;
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_RICH_TEXT_CLICK_EVENT , false , {"elementdata":this._elementArray[int(name)] , "point":target.localToGlobal(new Point(target.x , target.y))});
			}
		}
		
		/**
		 * 重置本行控件y坐标
		 * @param curLineElmArray
		 * @param curHeight
		 * @param curY
		 * @return 
		 * 
		 */		
		private function _resetCurLineElemnetY(curLineElmArray:Array, curHeight:int, curY:int):void
		{
			for each (var obj:DisplayObject in curLineElmArray)
			{
				if (obj.height < curHeight)
				{
					obj.y = curY + curHeight - obj.height;
				}
			}
		}
		
		private function _onButtonClick(e:Event):void
		{
			
		}
		/**
		 * 是否需要换行
		 * @param curX
		 * @param elmWidth
		 * @return 
		 * 
		 */		
		private function _needNewLine(curX:int, elmWidth:int):Boolean
		{
			if ((curX + elmWidth) > this._width)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 获取当前行高度
		 * @param curHeight
		 * @param elmHeight
		 * @return 
		 * 
		 */		
		private function _getCurHeight(curHeight:int, elmHeight:int):int
		{
			return curHeight>elmHeight ? curHeight : elmHeight;
		}
		
		/** setter */
		public function set initX(value:int):void
		{
			this._initX = value;
		}
		public function set initY(value:int):void
		{
			this._initY = value;
		}
		public function set spaceY(value:int):void
		{
			this._spaceY = value;
		}
		
		/** getter */
		public function get initX():int
		{
			return this._initX;
		}
		public function get initY():int
		{
			return this._initY;
		}
		public function get spaceY():int
		{
			return this._spaceY;
		}
		
		override public function set width(value:Number):void
		{
			this._width = value;
		}
		override public function get width():Number
		{
			return this._width;
		}

		public function get realtextWidth():Number
		{
			return _realtextWidth;
		}

	}
}