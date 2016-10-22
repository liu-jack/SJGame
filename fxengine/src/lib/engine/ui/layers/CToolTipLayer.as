package lib.engine.ui.layers
{
	import lib.engine.layer.Clayer;
	
	public class CToolTipLayer extends Clayer
	{
		public function CToolTipLayer()
		{
			super();
			this.name = "CToolTipLayer";
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
	}
}