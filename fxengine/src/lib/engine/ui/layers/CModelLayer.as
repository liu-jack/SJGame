package lib.engine.ui.layers
{
	import lib.engine.layer.Clayer;
	
	/**
	 * 模态图层 
	 * @author caihua
	 * 
	 */
	public class CModelLayer extends Clayer
	{
		private var _modelfilters:Array;
		
		public function CModelLayer(width:Number,height:Number)
		{
			super();
			this.name = "_modelLayer";
			
			this.visible = false;
			changesize(width,height);
			
		}
		
		public function changesize(width:Number,height:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,0.1);
			this.graphics.drawRect(0,0,width, height);
			this.graphics.endFill();
		}
	}
}