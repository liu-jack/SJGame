package SJ.Game.layer
{
	import flash.geom.Point;
	
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	import engine_starling.display.SUIRoot;
	import engine_starling.utils.STween;
	
	import feathers.core.IFeathersControl;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	
	/**
	 * 游戏层次结构 
	 * UI管理层
	 * @author kk
	 * 
	 */
	public class CJLayerManager
	{
		/*单例对象*/
		private static var _ins:CJLayerManager = null;
		private var _screenLayer:SLayer = null;
		/*模块层*/
		private var _moduleLayer:SLayer = null;
		/*面板层 */
		private var _panelLayer:SLayer = null;
		/*聊天层*/
		private var _chatLayer:SLayer = null;
		/*提示层*/
		private var _tipsLayer:SLayer = null;
		/*指引层*/
		private var _indicateLayer:SLayer = null;
		/*根节点*/
		private var _rootLayer:SUIRoot = null;
		
		/**
		 * fadein 字典
		 */
		private var _fadelayers:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public function CJLayerManager()
		{
			super();
			init();
		}
		
		public static function get o():CJLayerManager
		{
			if(_ins == null)
				_ins = new CJLayerManager();
			return _ins;
		}

		/**
		 *  
		 * 初始化
		 */
		private function init():void
		{
			_rootLayer = new SUIRoot();
			this._screenLayer = new SLayer();
			this._moduleLayer = new SLayer();
			this._panelLayer = new SLayer();
			this._chatLayer = new SLayer();
			this._tipsLayer = new SLayer();
			this._indicateLayer = new SLayer();
			
			SApplication.UIRootNode.addChild(_rootLayer);
			_rootLayer.normalLayer.addChild(_screenLayer);
			_rootLayer.normalLayer.addChild(_moduleLayer);
			_rootLayer.normalLayer.addChild(_panelLayer);
			_rootLayer.normalLayer.addChild(_chatLayer);
			_rootLayer.normalLayer.addChild(_tipsLayer);
			_rootLayer.normalLayer.addChild(_indicateLayer);
		}
		
		/**
		 * 添加到模态层有淡入效果
		 */ 
		public function addToModalLayerFadein(layer:DisplayObjectContainer , time:Number = 0.5 ):void
		{
			if(layer == null)
			{
				return;
			}
			this.addToModal(layer);
			this._fadeIn(layer , time);
		}
		
		/**
		 * 添加模块层有淡入效果
		 */ 
		public function addToModuleLayerFadein(layer:DisplayObjectContainer , time:Number = 0.5  , withMask:Boolean = true):void
		{
			if(layer == null)
			{
				return;
			}
			
			this.addModuleLayer(layer , withMask);
			this._fadeIn(layer , time);
		}
		
		/**
		 * 删除模块层有淡出效果
		 */
		public function removeFromLayerFadeout(layer:SLayer , time:Number = 0.2):void
		{
			if(layer == null)
			{
				return;
			}
			
			
			this._fadeOut(layer , time);
		}
		
		/**
		 * 淡入
		 * @layer : 淡入的层
		 * @time : 淡入时间
		 */ 
		private function _fadeIn(layer:DisplayObject , time:Number = 0.5):void
		{
			
			_fadelayers.push(layer);
			//peng.zhi ++
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_NOT_DISPLAY_SCENE_PLAYERS);
			
			
			layer.alpha = 0.001;
			var tween:STween = new STween(layer , time);
			tween.animate("alpha" , 1);
			Starling.juggler.add(tween);
			tween.onComplete = function():void
			{
				Starling.juggler.remove(tween);
				
			};
		}
		
		/**
		 * 淡出
		 * @layer : 淡出的层
		 * @time : 淡出时间
		 */ 
		private function _fadeOut(layer:DisplayObject , time:Number = 0.2):void
		{
			var tween:STween = new STween(layer , time);
			tween.animate("alpha" , 0.001);
			Starling.juggler.add(tween);
			tween.onCompleteArgs = [layer];
			tween.onComplete = function(thislayer:SLayer):void
			{
				const index:int = _fadelayers.indexOf(thislayer);
				if(index != -1)
				{
					_fadelayers.splice(index, 1);
					//peng.zhi ++
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_DISPLAY_SCENE_PLAYERS);
				}
				
				thislayer.removeFromParent(true);
				Starling.juggler.remove(tween);
				
				
			};
		}
		
		/**
		 * 添加元素到模态层 
		 * @param child
		 * 
		 */
		public function addToModal(child:DisplayObject):void
		{
			_rootLayer.modalLayer.addChild(child);
		}
		
		/**
		 * 从模态层清除 
		 * @param child
		 * 
		 */
		public function disposeFromModal(child:DisplayObject,bdispose:Boolean = true):void
		{
			_rootLayer.modalLayer.removeChild(child,bdispose);
		}
		
		/**
		 * 添加元素到最高层 删除同样使用  disposeFromModal
		 * 慎重使用
		 * @param child
		 */
		public function addToTop(child:DisplayObject):void
		{
			_rootLayer.modalLayer.addChild(child,false);
		}
		
		/**
		 * 添加模块层 
		 * @param layer
		 */
		public function addModuleLayer(layer:DisplayObjectContainer , withMask:Boolean = true):void
		{
			Assert(layer != null,"addMoudleLayer not be null");
			
			var quad:Quad = new Quad(10  , 10 , 0x000000);
			quad.width = SApplicationConfig.o.stageWidth;
			quad.height = SApplicationConfig.o.stageHeight;
			quad.name = "modulemask";
			quad.touchable = withMask;
			quad.visible = withMask;
			this._moduleLayer.addChild(layer);
			
			_forceCenter(layer);
			
			var localPoint:Point = layer.globalToLocal(Starling.current.stage.localToGlobal(new Point( 0 , 0)));
			quad.x = localPoint.x;
			quad.y = localPoint.y;
			quad.alpha = 0.4;
			if(layer.getChildByName("modulemask") == null)
			{
				layer.addChildAt(quad , 0);
			}
		}
		
		/**
		 * 添加元素到模态层 
		 * @param child
		 * 
		 */
		public function addToTipsLayer(child:DisplayObject):void
		{
			child.x = (SApplicationConfig.o.stageWidth - child.width)/2;
			child.y = (SApplicationConfig.o.stageHeight - child.height)/2;
			this._tipsLayer.addChild(child);
		}
		
		public function addToScreenLayer(layer:SLayer):void
		{
			Assert(layer != null,"addMoudleLayer not be null");
			this._screenLayer.addChild(layer);
		}
		
		/**
		 * 添加面板 
		 * @param layer
		 */		
		public function addPanelLayer(layer:SLayer):void
		{
			this.panelLayer.addChild(layer);
		}
		
		/**
		 * 指引层
		 * @param layer
		 */		
		public function addIndicateLayer(layer:SLayer):void
		{
			this.indicateLayer.addChild(layer);
		}
		
		/**
		 * 移除面板 
		 * @param layer
		 */
		public function removePanelLayer(layer:SLayer):void
		{
			if(layer.parent)
			{
				layer.removeFromParent(true);
			}
		}
		
		/**
		 * 清除模块层 
		 * @param layer
		 */
		public function removeModuleLayer(layer:SLayer):void
		{
			if(layer && layer.parent)
			{
				layer.removeFromParent(true);
			}
		}
		
		/**
		 * 指引层 
		 * @param layer
		 */
		public function removeIndicateLayer(layer:SLayer):void
		{
			if(layer.parent)
			{
				layer.removeFromParent(true);
			}
		}
		
		/**
		 * 移除module layer上面的所有东西
		 */ 
		public function removeAllModuleLayer():void
		{
			_moduleLayer.removeChildren();
		}
		
		/**
		 * 回收
		 */
		public static function purgeInstance():void
		{
			_ins._rootLayer.removeFromParent(true);
			_ins = null;
		}
		
		/**
		 * 清场 
		 */
		public function removeAllChildren():void
		{
			_screenLayer.removeChildren(0,-1,true);
			_moduleLayer.removeChildren(0,-1,true);
			_panelLayer.removeChildren(0,-1,true);
			_chatLayer.removeChildren(0,-1,true);
			_tipsLayer.removeChildren(0,-1,true);
			_rootLayer.removeChildren(0,-1,true);
			_indicateLayer.removeChildren(0,-1,true);
		}
		
		/**
		 * 居中显示
		 */ 
		private function _forceCenter(layer:DisplayObject):void
		{
			if(layer is IFeathersControl)
			{
				IFeathersControl(layer).validate();
			}
			layer.x = (SApplicationConfig.o.stageWidth - layer.width) / 2;
			layer.y = (SApplicationConfig.o.stageHeight - layer.height) / 2;
		}
		
		/**
		 * 根节点
		 */ 
		public function get rootLayer():SUIRoot
		{
			return _rootLayer;
		}
		
		/**
		 * module 层 
		 */
		public function get screenLayer():SLayer
		{
			return _screenLayer;
		}
		
		/**
		 * module 层 
		 */
		public function get moduleLayer():SLayer
		{
			return _moduleLayer;
		}
		
		public function get panelLayer():SLayer
		{
			return this._panelLayer;
		}
		
		public function get chatLayer():SLayer
		{
			return this._chatLayer;
		}
		
		public function get tipsLayer():SLayer
		{
			return this._tipsLayer;
		}
		
		public function get indicateLayer():SLayer
		{
			return this._indicateLayer;
		}
	}
}