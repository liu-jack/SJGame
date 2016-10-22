package engine_starling.display
{
	import feathers.core.PopUpManager;
	
	import flash.filters.DisplacementMapFilter;
	
	import starling.display.DisplayObject;

	/**
	 * 模态层 
	 * @author caihua
	 * 
	 */
	public class SUIModalLayer extends PopUpManager
	{
		public function SUIModalLayer()
		{
			
			super();
		}
		
	
		public function addChild(child:DisplayObject,isModal:Boolean = true, isCentered:Boolean = true):void
		{
			addPopUp(child,isModal,isCentered);
		}
		public function removeChild(child:DisplayObject,dispose:Boolean = false):void
		{
			removePopUp(child,dispose);
		}
		
		
	}
}