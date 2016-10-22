package lib.engine.ui.uicontrols
{
	public class XDG_UI_Container extends XDG_UI_Control
	{
		public function XDG_UI_Container()
		{
			super();
		}
		
		override protected function _init_PropertySetter():void
		{
			// TODO Auto Generated method stub
			super._init_PropertySetter();
			_registerExPropertyFilter(["width","height"]);
		}
		
		override protected function _onExPropertyChange(varname:String, oldvalue:*, newvalue:*):void
		{
			// TODO Auto Generated method stub
			super._onExPropertyChange(varname, oldvalue, newvalue);
			switch(varname)
			{
				case "width":
				{
					this.graphics.clear();
					this.graphics.beginFill(0xFFFFFF,0.8);
					this.graphics.drawRoundRect(0,0,newvalue,_property.height,10);
					this.graphics.endFill();
					break;
				}
				case "height":
				{
					this.graphics.clear();
					this.graphics.beginFill(0xFFFFFF,0.8);
					this.graphics.drawRoundRect(0,0,_property.height,newvalue,10);
					this.graphics.endFill();
					break;
				}
				
			}
			
			
		}
		
		
	}
}