package engine_starling.utils.FeatherControlUtils
{
	import feathers.controls.List;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;

	public class FeatherControlCocosXPropertyBuilderList extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderList()
		{
			super();
		}
		override public function get fullClassName():String
		{
			return "feathers.controls.List";
		}
		
		override protected function _onEndEdit():void
		{
			super._onEndEdit();
		}
		
		override protected function _onbeginEdit():void
		{
			super._onbeginEdit();
		}
		
		public function set direction(value:int):void
		{
			if(value == 2)
			{
				const listLayout:HorizontalLayout = new HorizontalLayout();
				listLayout.hasVariableItemDimensions = true;
				listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
				listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
				(_editControl as List).layout = listLayout;
			}
			else //垂直滚动
			{
				const VlistLayout:VerticalLayout = new VerticalLayout();
				VlistLayout.hasVariableItemDimensions = true;
				VlistLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
				VlistLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
				(_editControl as List).layout = VlistLayout;
			}
			
		}
		
		public function set innerHeight(value:Number):void
		{
			
		}
		
		public function set innerWidth(value:Number):void
		{
//			(_editControl as List).viewPort = new
		}
		
		
//		
//		"direction": 2,
//		"innerHeight": 240,
//		"innerWidth": 202,
	}
}