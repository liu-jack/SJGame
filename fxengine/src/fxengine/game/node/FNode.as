package fxengine.game.node
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import fxengine.FPoint;
	import fxengine.game.action.FAction;
	import fxengine.game.action.FActionManager;
	import fxengine.game.iface.FUpdateInterface;
	import fxengine.game.manager.FScheduler;
	
	public class FNode extends Sprite implements FUpdateInterface
	{
		
		/**
		 * 无效的Tag值 
		 */
		public static const TAG_INVALID:int = 0xFFFFFFFF;
		
		private var _tag:int = 0;

		/**
		 * 组件Tag标记 
		 */
		public function get tag():int
		{
			return _tag;
		}

		/**
		 * @private
		 */
		public function set tag(value:int):void
		{
			_tag = value;
		}
		
		private var _isRunning:Boolean = false;

		/**
		 * 是否在运行 
		 */
		public function get isRunning():Boolean
		{
			return _isRunning;
		}

		/**
		 * @private
		 */
		public function set isRunning(value:Boolean):void
		{
			_isRunning = value;
		}
		
		
		protected var _actionManager:FActionManager;

		public function set actionManager(value:FActionManager):void
		{
			_actionManager = value;
		}


		/**
		 *动作管理器 
		 */
		public function get actionManager():FActionManager
		{
			return _actionManager;
		}

		
		public function FNode()
		{
			super();
			
			this.actionManager = FCanvas.o.actionManager;
		}
		
		private var _contentSize:FPoint = new FPoint();

		/**
		 * 内容大小 
		 */
		public function get contentSize():FPoint
		{
			return _contentSize;
		}

		/**
		 * @private
		 */
		public function set contentSize(value:FPoint):void
		{
			_contentSize = value;
		}
		
		
		public function runAction(action:FAction):FAction
		{
			
			_actionManager.addAction(action,this,false);
			
			return action;
		}
		
		public function stopAllActions():void
		{
			_actionManager.removeAllActionsFromTarget(this);
		}
		
		public function stopAction(action:FAction):void
		{
			_actionManager.removeAction(action);	
		}
		
		public function stopActionByTag(aTag:int):void
		{
			_actionManager.removeActionByTag(aTag,this);	
		}
		
		public function getActionByTag(aTag:int):FAction
		{
			return _actionManager.getActionByTag(aTag,this);
		}
		
		public function numberOfRunningActions():uint
		{
			return _actionManager.numberOfRunningActionsInTarget(this);	
		}
		
		public function resumeSchedulerAndActions():void
		{
			_actionManager.resumeTarget(this);
			
		}
		
		public function pauseSchedulerAndActions():void
		{
			_actionManager.pauseTarget(this);
		}
					
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if(child is FNode)
			{
				(child as FNode).onEnter();
				(child as FNode).onEnterTransitionDidFinish();
			}
			return super.addChild(child);
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child is FNode)
			{
				(child as FNode).onEnter();
				(child as FNode).onEnterTransitionDidFinish();
			}
			return super.addChildAt(child,index);	
		}
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			if(child is FNode)
			{
				_detachChild((child as FNode),true);
				return child;
			}
			else
			{
				return super.removeChild(child);
			}
		}
		
		public override function removeChildAt(index:int):DisplayObject
		{
			return this.removeChild(this.getChildAt(index));
//			return super.removeChildAt(index);
			
		}
		
		private function _detachChild(child:FNode,doCleanup:Boolean):void
		{
			if(isRunning)
			{
				child.onExitTransitionDidStart();
				child.onExit();
			}
			
			if(doCleanup)
			{
				child.cleanup();
			}
			
			super.removeChild(child);
		}
		
		public function onEnter():void
		{
			
			for(var i:int = 0;i<numChildren;i++)
			{
				var child:Object = getChildAt(i);
				if(child is FNode)
				{
					(child as FNode).onEnter();
				}
			}
			this.resumeSchedulerAndActions();
			this.isRunning = true;
		}
		
		public function onEnterTransitionDidFinish():void
		{
			for(var i:int = 0;i<numChildren;i++)
			{
				var child:Object = getChildAt(i);
				if(child is FNode)
				{
					(child as FNode).onEnterTransitionDidFinish();
				}
			}
		}
		
		/**
		 * 节点退出 
		 * 
		 */
		public function onExit():void
		{
			this.pauseSchedulerAndActions();
			this.isRunning = false;
			
			for(var i:int = 0;i<numChildren;i++)
			{
				var child:Object = getChildAt(i);
				if(child is FNode)
				{
					(child as FNode).onExit();
				}
			}
		}
		public function onExitTransitionDidStart():void
		{
			for(var i:int = 0;i<numChildren;i++)
			{
				var child:Object = getChildAt(i);
				if(child is FNode)
				{
					(child as FNode).onExitTransitionDidStart();
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function cleanup():void
		{
			this.stopAllActions();
			
			for(var i:int = 0;i<numChildren;i++)
			{
				var child:Object = getChildAt(i);
				if(child is FNode)
				{
					(child as FNode).cleanup();
				}
			}
		}
		
		
		///////////scheduler
		private var _scheduler:FScheduler = null;

		/**
		 * 定时器 
		 */
		public function get scheduler():FScheduler
		{
			return _scheduler;
		}

		/**
		 * @private
		 */
		public function set scheduler(value:FScheduler):void
		{
			if(_scheduler != value && _scheduler != null)
			{
				
			}
			_scheduler = value;
			
		}
		
		public function scheduleUpdate():void
		{
			this.scheduleUpdateWithPriority(0);
		}
		public function scheduleUpdateWithPriority(priority:int):void
		{
			_scheduler.scheduleForUpdate(this);
		}
		public function unscheduleUpdate():void
		{
			_scheduler.unscheduleForTarget(this);
		}
		/**
		 * 定时执行 
		 * @param selector
		 * @param interval
		 * @param repeat
		 * @param delay
		 * 
		 */
		public function schedule(selector:Function,interval:int = 0,repeat:uint = FScheduler.FRepeatForever,delay:Number = 0):void
		{
			_scheduler.schedule(selector,this,delay,repeat);
		}
								 
								 
		public function scheduleOnce(selector:Function,delay:int):void
		{
			this.schedule(selector,0,1,delay);
		}
		
		public function unschedule(selector:Function):void
		{
			_scheduler.unschedule(selector,this);
		}
		
		public function unscheduleAllSelectors():void
		{
			_scheduler.unscheduleForTarget(this);
		}
		

		public function update(currenttime:Number, escapetime:Number):void
		{
			
			trace("update");
			// TODO Auto Generated method stub
			
		}
		
	}
}