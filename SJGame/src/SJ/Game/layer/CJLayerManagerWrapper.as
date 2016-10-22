package SJ.Game.layer
{
	import engine_starling.display.SLayer;
	import engine_starling.display.SUIModalLayer;
	
	import feathers.core.PopUpManager;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 +------------------------------------------------------------------------------
	 * 层管理器的包装类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-24 上午11:04:20  
	 +------------------------------------------------------------------------------
	 */
	public class CJLayerManagerWrapper extends EventDispatcher
	{
		private var _layerManger:CJLayerManager;
		private var _modalLayer:SUIModalLayer;
		private var _moduleLayer:SLayer;
		
		private static var INSTANCE:CJLayerManagerWrapper = null;
		
		/*modal , module , panel , tips*/
		private var _busyFlag:Array = [0 , 0 , 0 , 0];
		private var _sequenceList:Array = [[] , [] , [] , []];
		private var _keyList:Array = ["modal" , "module" , "panel" , "tips"];
		
		public function CJLayerManagerWrapper(s:Single)
		{
			super();
			_layerManger = CJLayerManager.o;
			_modalLayer = _layerManger.rootLayer.modalLayer;
			_moduleLayer = _layerManger.moduleLayer;
		}
		
		public static function get o():CJLayerManagerWrapper
		{
			if(INSTANCE == null)
				INSTANCE = new CJLayerManagerWrapper(new Single());
			return INSTANCE;
		}
		
		/**
		 * 清除标记位
		 */ 
		public function forceClear():void
		{
			_busyFlag = [0 , 0 , 0 , 0];
		}
		
		/**
		 * 加到模态层，序列
		 * @param child:要添加的对象
		 * @param forceFirst : 是否放到队列的第一位
		 */ 
		public function addToModalSequence(child:DisplayObjectContainer , forceFirst:Boolean = false):void
		{
			var index:int = _keyList.indexOf("modal");
			if(_busyFlag[index])	
			{
				if(forceFirst)
				{
					this._sequenceList[index].unshift(child);
				}
				else
				{
					this._sequenceList[index].push(child);
				}
			}
			else
			{
				_busyFlag[index] = 1;
				child.addEventListener(Event.REMOVED_FROM_STAGE, _onRemoveFromModal);
				this._layerManger.addToModal(child);
			}
		}
		
		/**
		 * 从模态层移除，序列
		 */ 
		public function removeFromModalSequence(child:DisplayObjectContainer , dispose:Boolean):void
		{
			child.removeFromParent(dispose);
		}
		
		private function _onRemoveFromModal(e:Event):void
		{
			const child:DisplayObject = DisplayObject(e.currentTarget);
			var index:int = _keyList.indexOf("modal");
			if(child)
			{
				child.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoveFromModule);
				_busyFlag[index] = 0;
			}
			
			if(this._sequenceList[index].length > 0)
			{
				this.addToModalSequence(this._sequenceList[index].shift());
			}
		}
		
		/**
		 * 加到模块层，序列
		 * @param child:要添加的对象
		 * @param forceFirst : 是否放到队列的第一位
		 */ 
		public function addToModuleSequence(child:DisplayObjectContainer , forceFirst:Boolean = false ,  withMask:Boolean = true):void
		{
			var index:int = _keyList.indexOf("module");
			if(_busyFlag[index])	
			{
				if(forceFirst)
				{
					this._sequenceList[index].unshift(child);
				}
				else
				{
					this._sequenceList[index].push(child);
				}
			}
			else
			{
				_busyFlag[index] = 1;
				child.addEventListener(Event.REMOVED_FROM_STAGE, _onRemoveFromModule);
				this._layerManger.addToModuleLayerFadein(child , 0.5 , withMask);
			}
		}
		
		private function _onRemoveFromModule(e:Event):void
		{
			const child:DisplayObject = DisplayObject(e.currentTarget);
			var index:int = _keyList.indexOf("module");
			if(child)
			{
				child.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoveFromModule);
				_busyFlag[index] = 0;
			}
			
			if(this._sequenceList[index].length > 0)
			{
				this.addToModuleSequence(this._sequenceList[index].shift());
			}
		}		
		
		/**
		 * 从模块层移除，序列
		 */ 
		public function removeFromModuleSequence(child:DisplayObjectContainer , dispose:Boolean):void
		{
			child.removeFromParent(dispose);
		}
	}
}
class Single{}