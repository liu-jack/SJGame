package lib.engine.ui.layers
{
	import lib.engine.layer.Clayer;
	
	/**
	 * 鼠标图层 
	 * @author caihua
	 * 
	 */
	public class CMouseLayer extends Clayer
	{
		public function CMouseLayer()
		{
			super();
			
			this.name = "CMouseLayer";
			this.mouseEnabled = false;
			this.mouseChildren = true;
		}
	}
}