package lib.engine.game.data.anim
{
	import lib.engine.game.data.GameData;
	import lib.engine.utils.functions.Assert;
	
	import mx.collections.ArrayCollection;

	/**
	 * 动画组描述 
	 * @author caihua
	 * 
	 */
	public class GameData_AnimGroup extends GameData
	{
		private var _animcontains:ArrayCollection;
		public function GameData_AnimGroup()
		{
			_animcontains = new ArrayCollection();
		}
		
		private var _name:String;

		/**
		 * 动画组名称 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		private var _resPath:String;

		/**
		 * 资源路径,相对路径 
		 */
		public function get resPath():String
		{
			return _resPath;
		}

		/**
		 * @private
		 */
		public function set resPath(value:String):void
		{
			_resPath = value;
		}
		
		
//		private var _classname:String;
//
//		/**
//		 * 资源导出类名称 
//		 */
//		public function get classname():String
//		{
//			return _classname;
//		}
//
//		/**
//		 * @private
//		 */
//		public function set classname(value:String):void
//		{
//			_classname = value;
//		}
		
		
		public function addAnimData(data:GameData_Anim):void
		{
			for each(var d:GameData_Anim in _animcontains)
			{
				if(d.name == data.name)
				{
					d = data;
					_animcontains.refresh();
					return;
				}
			}
			_animcontains.addItem(data);
		}
		
		public function removeAnimData(Animname:String):void
		{
			Assert(Animname!=null,"Animname == null");
			Assert(Animname != "","Animname is Empty");
			//Assert(_animcontains[Animname] != null,"Anim is null");
			
			for(var i:String in _animcontains)
			{
				if(_animcontains[i].name == Animname)
				{
					_animcontains.removeItemAt(int(i));
					return;
				}
			}
			
		}
		public function removeAllAnimData():void
		{
			_animcontains.removeAll();
		}
		/**
		 * 获得动画数据 
		 * @param Animname
		 * @return 
		 * 
		 */
		public function getAnimData(Animname:String):GameData_Anim
		{
			Assert(Animname!=null,"Animname == null");
			Assert(Animname != "","Animname is Empty");
			//Assert(_animcontains[Animname] != null,"Anim is null");
			
			for each(var d:GameData_Anim in _animcontains)
			{
				if(d.name == Animname)
				{
				
					return d;
				}
			}
			return null;
		}
		/**
		 * 返回动画名称列表 
		 * @return 
		 * 
		 */
		public function getAnimnameList():Vector.<String>
		{
			var vec:Vector.<String> = new Vector.<String>();
			for each (var d:GameData_Anim in _animcontains)
			{
				vec.push(d.name);
			}
			return vec;
		}
		
		public function getAnimList():ArrayCollection
		{
			return _animcontains;
		}
		
		override public function Pack():Object
		{
			var obj:Object = super.Pack();
			
			obj.animlist = new Array();
			for each (var d:GameData_Anim in _animcontains)
			{
				obj.animlist.push(d.Pack());
			}
			return obj;
		}
		
		override public function UnPack(obj:Object):void
		{
			super.UnPack(obj);
			//删除所有动画数据
			removeAllAnimData();
			
			var animlist:Array = obj.animlist;
			
			for each(var animData:Object in animlist)
			{
				var animD:GameData_Anim = new GameData_Anim();
				animD.UnPack(animData);
				addAnimData(animD);
			}
		}
		

		
		/**
		 *  建立缓存文件 异步建立,
		 * @param callback function(Groupdata:GameData_AnimGroup,animData:GameData_Anim):void
		 * @return T 已经建立 F异步建立
		 * 
		 */
		public function BuildCache(animName:String,callback:Function = null):Boolean
		{
			var animdata:GameData_Anim = getAnimData(animName);
			Assert(animdata != null,"动画建立缓存错误!动画不存在 动画名[" + animName + "]");
			if(animdata == null)
			{
				return false;
			}
			
			return animdata.BuildCache(this,callback);
			
		}
		
		

	}
}