package fxengine.game.action
{
	import flash.utils.Dictionary;
	
	import fxengine.game.iface.FUpdateInterface;
	import fxengine.game.node.FNode;
	
	import lib.engine.ui.impact.UI_Impact;
	
	import mx.collections.ArrayCollection;

	public class FActionManager implements FUpdateInterface
	{
		
		private var _targets:Dictionary = new Dictionary();
		
		
		private var _currentTarget:Object = null;
		
		public function FActionManager()
		{
		}
		
		public function addAction(action:FAction,target:FNode,pause:Boolean):void
		{
			var elements:Object = _targets[target];
			if(elements == null)
			{
				elements = new Object();
				elements["target"] = target;
				elements["pause"] = pause;
				elements["actions"] = new ArrayCollection();
				
				_targets[target] = elements;
			}
			
			var actions:ArrayCollection = elements["actions"];
			if(actions.contains(action))
				return;
			
			actions.addItem(action);
			
			action.startWithTarget(target);
			
		}
		public function removeAllActions():void
		{
			_targets = new Dictionary();
		}
		
		
		public function removeAllActionsFromTarget(target:FNode):void
		{
			if(target == null)
			{
				return;
			}
			var elements:Object = _targets[target];
			if(elements != null)
			{
				delete _targets[target];
			}
			
		}
		
		public function removeAction(action:FAction):void
		{
			if(action == null)
				return;
			
			var target:FNode = action.originalTarget;
			var elements:Object = _targets[target];
			if(elements != null)
			{
				var actions:ArrayCollection = elements["actions"];
				var deleteIndex:int = actions.getItemIndex(action);
				if(deleteIndex != -1)
				{
					actions.removeItemAt(deleteIndex);
				}
			}
		}
		
		public function removeActionByTag(tag:int,target:FNode):void
		{
			if(target == null)
				return;
			
			var elements:Object = _targets[target];
			if(elements != null)
			{
				var actions:ArrayCollection = elements["actions"];
				
				for(var i:int = 0;i<actions.length;i++)
				{
					var action:FAction = actions[i];
					if(tag == action.tag && action.originalTarget == target )
					{
						actions.removeItemAt(i);
						break;	
					}
				}
			}
		}
		
		public function getActionByTag(tag:int,target:FNode):FAction
		{
			if(target == null)
				return null;
			
			var elements:Object = _targets[target];
			if(elements != null)
			{
				var actions:ArrayCollection = elements["actions"];
				
				for(var i:int = 0;i<actions.length;i++)
				{
					var action:FAction = actions[i];
					if(tag == action.tag)
					{
						return action;
					}
				}
			}
			
			return null;
		}
		
		public function numberOfRunningActionsInTarget(target:FNode):uint
		{
			var elements:Object = _targets[target];
			if(elements != null)
			{
				var actions:ArrayCollection = elements["actions"];
				return actions.length;
			}
			return 0;
		}
		
		
		public function pauseTarget(target:FNode):void
		{
			var elements:Object = _targets[target];
			if(elements != null)
			{
				elements["pause"] = true;
			}
		}
		
		public function resumeTarget(target:FNode):void
		{
			var elements:Object = _targets[target];
			if(elements != null)
			{
				elements["pause"] = false;
			}
		}
		public function resumeTargets(targetsToResume:ArrayCollection):void
		{
			for each(var target:FNode in targetsToResume)
			{
				resumeTarget(target);
			}
		}
		public function pauseAllRunningActions():ArrayCollection
		{
			var idsWithAction:ArrayCollection = new ArrayCollection();
			
			for each (var elements:Object in _targets)
			{
				var target:FNode = elements["target"];
				var pause:Boolean = elements["pause"];
				if(!pause)
				{
					elements["pause"] = true;
					idsWithAction.addItem(target);
				}
			}
			return idsWithAction;
		}
		

		
		public function update(currenttime:Number, escapetime:Number):void
		{
//			var keys:*;
//			for (var key:* in _targets)
//			{
//				
//			}
			
			
			//TODO 认为是单线程或者超线程把 直接遍历了
			var DoneActions:ArrayCollection = new ArrayCollection();
			for each (var elements:Object in _targets)
			{
				var target:FNode = elements["target"];
				var pause:Boolean = elements["pause"];
				var actions:ArrayCollection = elements["actions"];
				
				if(!pause)
				{
					
					
					DoneActions.removeAll();
					
					for each(var action:FAction in actions)
					{
						action.step(escapetime);
						if(action.isDone)
						{
							DoneActions.addItem(action);
						}
					}
					
					for each(var doneaction:FAction in DoneActions)
					{
						removeAction(doneaction);
					}
					
					DoneActions.removeAll();
				
					
				}
			}
			
		}
		
	}
}