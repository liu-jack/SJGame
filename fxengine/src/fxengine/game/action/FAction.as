package fxengine.game.action
{
	import fxengine.game.common.constants.Constants_Actions;
	import fxengine.game.node.FNode;

	public class FAction
	{
		public function FAction()
		{
			
			
		}
		
		
		protected var _target:FNode = null;
		/**
		 * 目标对象 
		 */
		public function get target():FNode
		{
			return _target;
		}
		private var _originalTarget:FNode = null;

		/**
		 * 原始目标对象 
		 */
		public function get originalTarget():FNode
		{
			return _originalTarget;
		}

		
		protected var _tag:int = Constants_Actions.FActionTagInvaild;

		/**
		 * Action tag 
		 */
		public function get tag():int
		{
			return _tag;
		}

		/**
		 * 是否执行完毕 
		 * @return 
		 * 
		 */
		public function get isDone():Boolean
		{
			return true;
		}
		
		public function startWithTarget(target:FNode):void
		{
			_target = target;
			_originalTarget = target;
		}
		
		public function stop():void
		{
			_target = null;
			
		}
		
		//分步执行
		public function step(dt:Number):void
		{
			
		}
		
		


		public function update(t:Number):void
		{
			
			
		}
		
	}
	

	
	
}