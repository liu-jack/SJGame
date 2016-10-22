package engine_starling.display
{
	import flashx.textLayout.debug.assert;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.DisplayObject;

	/**
	 * UI根节点 包括层级管理
	 * @author caihua
	 * 
	 */
	public class SUIRoot extends SNode
	{
		public function SUIRoot()
		{
			super();
			super.addChildAt(_normalLayer = new SLayer(),0);
			_modalLayer = new SUIModalLayer();
//			super.addChildAt(_modalLayer = new SUIModalLayer(),1);
			
		}
		/**
		 * 普通层
		 */
		public static const SUIRootLayerType_Normal:int  = 0;
		
		/**
		 * 模态层 
		 */
		public static const SUIRootLayerType_Modal:int = 1;
		
		private var _normalLayer:SLayer;
		private var _modalLayer:SUIModalLayer;
		
		
		/**
		 * 模态层 
		 */
		public function get modalLayer():SUIModalLayer
		{
			return _modalLayer;
		}

		/**
		 * 普通层 
		 */
		public function get normalLayer():SLayer
		{
			return _normalLayer;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			// TODO Auto Generated method stub
			Assert(false,"not allow to addChild to SUIRoot");
			return super.addChildAt(child, index);
		}
		
		
		

	}
}