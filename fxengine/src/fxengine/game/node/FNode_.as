package fxengine.game.node
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fxengine.game.iface.FRenderInterface;
	
	import mx.collections.ArrayCollection;

	/**
	 * 所有对象的根节点 
	 * @author caihua
	 * 
	 */
	public class FNode_ implements FRenderInterface
	{
		private var _ZOrder:int = 0;
		/**
		 * 控件是否需要重新排序 
		 */
		private var _isReorderChildDirty :Boolean = false;

		/**
		 * Z排序 
		 */
		public function get ZOrder():int
		{
			return _ZOrder;
		}

		/**
		 * @private
		 */
		public function set ZOrder(value:int):void
		{
			_ZOrder = value;
			
			if(parent)
				parent.reorderChild(this,value);
		}
		
		private var _position:Point = new Point();

		/**
		 * 坐标 
		 */
		public function get position():Point
		{
			return _position;
		}

		/**
		 * @private
		 */
		public function set position(value:Point):void
		{
			_position = value;
		}
		
		private var _visible:Boolean = true;

		/**
		 * 是否可见 
		 */
		public function get visible():Boolean
		{
			return _visible;
		}

		/**
		 * @private
		 */
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}

		private var _children:ArrayCollection = new ArrayCollection();
		
		private var _parent:FNode_ = null;

		/**
		 * 父节点 
		 */
		public function get parent():FNode_
		{
			return _parent;
		}

		/**
		 * @private
		 */
		public function set parent(value:FNode_):void
		{
			_parent = value;
		}
		
		private var _tag:int = 0;

		/**
		 * TAG 
		 *  
		 * 
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
		
		private var _userObject:Object = null;

		/**
		 * 用户自定义数据 
		 */
		public function get userObject():Object
		{
			return _userObject;
		}

		/**
		 * @private
		 */
		public function set userObject(value:Object):void
		{
			_userObject = value;
		}
		
		protected var _isRunning:Boolean = false;
		
		protected var _contentSize:Point = new Point();

		/**
		 * 内容大小 
		 */
		public function get contentSize():Point
		{
			return _contentSize;
		}

		/**
		 * @private
		 */
		public function set contentSize(value:Point):void
		{
			_contentSize = value;
		}
		
		
		
		
		public function FNode_()
		{
		}
		
		
		public function visit(g:BitmapData):void
		{
			if(!_visible)
				return;
			
			
			//计算坐标
			
			var offset:Point = this.nodeToWorldSpace();
			
			if(_children.length != 0)
			{
				sortAllChildren();
				//draw z < 0;
				var i:int=0;
				var child:FNode_ = null;
				for(;i<_children.length;i++)
				{
					child = _children[i];
					if(child.ZOrder < 0 )
					{
						child.visit(g);
					}
					else
					{
						break;
					}
				}
				
				
				this.render(g,new Rectangle(offset.x,offset.y));
				
				for(;i<_children.length;i++)
				{
					child= _children[i];
					child.visit(g);
				}
			}
			else
			{
				render(g,new Rectangle(offset.x,offset.y));
			}
			
			
		}
		public function render(g:BitmapData, offset:Rectangle):void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 * 添加子空间 
		 * @param child
		 * @param z
		 * @param tag
		 * 
		 */
		public function addChild(child:FNode_):void
		{
			addChildex(child,child.ZOrder,child.tag);
		}
		
		public function addChildex(child:FNode_,z:int = 0 ,tag:int = 0):void
		{
			_isReorderChildDirty = true;
			_children.addItem(child);
			
			child._ZOrder = z;
			
			child.tag = tag;
			
			child.parent = this;
			
			if(_isRunning)
			{
				child.onEnter();
			}
		}
		
		
		/**
		 * 删除自己 
		 * @param cleanup
		 * 
		 */
		public function removeFromParentAndCleanup(cleanup:Boolean = true):void
		{
			_parent.removeChild(this,cleanup);
		}
		
		/**
		 * 删除所有的子空间
		 * @param cleanup
		 * 
		 */
		public function removeAllChildrenWithCleanup(cleanup:Boolean):void
		{
			for(var i:int = 0;i<_children.length;i++)
			{
				var child:FNode_ = _children[i];
				if(_isRunning)
				{
					child.onExit();
				}
				
				if(cleanup)
				{
					child.cleanup();
				}
				
				child.parent = null;
			}
			
			_children.removeAll();
		}
		
		/**
		 * 删除指定的子空间 
		 * @param node
		 * @param cleanup
		 * 
		 */
		public function removeChild(node:FNode_,cleanup:Boolean = true):void
		{
			if(node == null)
				return;
			
			if(_children.contains(node))
			{
				detachChild(node,cleanup);
			}
		}
		
		/**
		 * 通过Tag删除子控件 
		 * @param tag
		 * @param cleanup
		 * 
		 */
		public function removeChildByTag(tag:int,cleanup:Boolean = true):void
		{
			var child:FNode_ = getChildByTag(tag);
			if(child == null)
				return;
			removeChild(child,cleanup);
			
		}
		
		public function getChildByTag(tag:int):FNode_
		{
			for(var i:int = 0;i<_children.length;i++)
			{
				var child:FNode_ = _children[i];
				if(child.tag == tag)
					return child;
			}
			return null;
		}
		
		
		
		public function reorderChild(node:FNode_, z:int):void
		{
			_isReorderChildDirty = true;
			
			node._ZOrder = z;
			
		}
		/**
		 * 排序子空间 
		 * 
		 */		
		protected function sortAllChildren():void
		{
			if(_isReorderChildDirty)
			{
				//用C语言实现直接插入排序算法的源代码（调试通过）
				//http://www.talented.com.cn/archives/2010/5/20100520151609.html
				/*
				void Dir_Insert(int A[],int N)  //直接插入排序
				{
				int j,t;
				for(int i=1;i<N;i++)
				{
				t=A[i];
				j=i-1;
				while(A[j]>t)
				{
				A[j+1]=A[j];
				j--;
				}
				A[j+1]=t;
				}
				}
				*/
				var j:int = 0;
				var t:FNode_ = null;
				var length:int = _children.length;
				for(var i:int = 1;i<length;i++)
				{
					t = _children[i];
					j = i-1;
//					var tj:FNode = _children[j];
					
					
					while(j>=0 && (_children[j] as FNode_).ZOrder > t.ZOrder)
					{
						_children[j+1] = _children[j];
						j--;
					}
					_children[j+1] = t;
				}
				
				_isReorderChildDirty = false;
				
			}
		}
		
		
		public function boundingbox():Rectangle
		{
			return new Rectangle();
		}
		
		protected function nodeToParentSpace():Point
		{
			return _position;
		}
		
		protected function nodeToWorldSpace():Point
		{
			var t:Point = this.nodeToParentSpace();
			
			for(var p:FNode_ = _parent;p!= null;p = p.parent)
			{
				t = t.add(p.nodeToParentSpace());
			}
			return t;
		}
		
		/**
		 * 转换为子空间坐标 
		 * @param worldPoint
		 * @return 
		 * 
		 */
		public function convertToNodeSpace(worldPoint:Point):Point
		{
			var t:Point = this.nodeToWorldSpace();
			return worldPoint.subtract(t);
		}
		
		
		/**
		 * 转换为父控件坐标 
		 * @param nodePoint
		 * @return 
		 * 
		 */
		public function convertToWorldSpace(nodePoint:Point):Point
		{
			return nodePoint.add(this.nodeToWorldSpace());
		}
		
		
		protected function onEnter():void
		{
			
			for(var i:int = 0;i<_children.length;i++)
			{
				var child:FNode_ = _children[i];
				child.onEnter();
			}
			
			resumeSchedulerAndActions();
			
			_isRunning = true;
		}
		
		protected function onExit():void
		{
			pauseSchedulerAndActions();
			
			_isRunning = false;
			
			for(var i:int = 0;i<_children.length;i++)
			{
				var child:FNode_ = _children[i];
				child.onExit();
			}
			
		}
		
		
		private function detachChild(child:FNode_,doCleanup:Boolean):void
		{
			if(_isRunning)
			{
				child.onExit();
			}
			
			if(doCleanup)
			{
				child.cleanup();
			}
			
			child.parent = null;
			
			var idx:int = _children.getItemIndex(child);
			_children.removeItemAt(idx);
			
			
		}
		
		
		protected function cleanup():void
		{
			
		}
		
		protected function resumeSchedulerAndActions():void
		{
			
		}
		protected function pauseSchedulerAndActions():void
		{
			
		}
	}
}