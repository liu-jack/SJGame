package lib.engine.game.Impact
{
	public class GameImpactEmpty extends GameObjectImpact
	{
		public function GameImpactEmpty()
		{
			super();
			
		}
		
		override protected function _onInit():void
		{
			// TODO Auto Generated method stub
			this.autodelete = true;
			super._onInit();
		}
		
		
	}
}