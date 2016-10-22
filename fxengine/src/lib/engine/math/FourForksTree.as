package lib.engine.math
{
	

	public class FourForksTree
	{
		private var _treesinglewidth:Number;
		private var _treesingleheight:Number;
		private var _treemaxwitdh:Number;
		private var _treemaxheight:Number;
		
		private var _widthcount:int = 0;
		
		private var _objectsContains:Vector.<Object> = new Vector.<Object>();
		private var _objectsidx:Array = new Array();
		
		public function FourForksTree()
		{
		}
		
		/**
		 * 
		 * @param singlewidth
		 * @param singleheight
		 * @param maxwidth
		 * @param maxheight
		 * 
		 */
		public function setSize(singlewidth:Number,singleheight:Number,maxwidth:Number,maxheight:Number):void
		{
			_treesinglewidth = singlewidth;
			_treesingleheight = singleheight;
			_treemaxwitdh = maxwidth;
			_treemaxheight = maxheight;
			
			//横向单元个数
			_widthcount = _treemaxwitdh / _treesinglewidth + 1;
			
			rebuildindex();
		}
		
		/**
		 * 重建索引 
		 * 
		 */
		public function rebuildindex():void
		{
			
		}
		
		public function getindex(x:Number,y:Number):int
		{
			return int((y  / _treesingleheight) * _widthcount + x / _treesinglewidth);
		}
		
		public function addObject(x:Number,y:Number,obj:Object):void
		{
			var idx:int = getindex(x,y);
			
			if(idx == -1)
				return;
			if(_objectsidx[idx] == null)
			{
				_objectsidx[idx] = new Vector.<Object>();
			}
			var fidx:Vector.<Object> = _objectsidx[idx];
			
			fidx.push(obj);
		}
	}
}