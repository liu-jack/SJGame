package lib.engine.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * Object助手类 
	 * @author caihua
	 * 
	 */
	public class CObjectUtils
	{
		public function CObjectUtils()
		{
		}
		
		/**
		 * 获得类的名称 
		 * @param cls
		 * @return 
		 * 
		 */
		public static function getClassName(cls:Object):String
		{
			var clsfullname:String = getClassFullName(cls);
			var idx:int = clsfullname.lastIndexOf("::");
			
			if(idx == -1)
			{
				return clsfullname;
			}
			else
			{
				return clsfullname.substr(idx + 2);
			}
		}
		
		
		/**
		 * 获得类的完全限定名 
		 * @param cls
		 * @return 
		 * 
		 */
		public static function getClassFullName(cls:Object):String
		{
			return getQualifiedClassName(cls);
		}
		
		/**
		 * 获取父类完全限定名 
		 * @param cls
		 * @return 
		 * 
		 */
		public static function getSuperClassFullName(cls:Object):String
		{
			return getQualifiedSuperclassName(cls);
			
		}
		
		/**
		 * 获得父类名称
		 * @param cls
		 * @return 
		 * 
		 */
		public static function getSuperClassName(cls:Object):String
		{
			var clsfullname:String = getSuperClassFullName(cls);
			var idx:int = clsfullname.lastIndexOf("::");
			
			if(idx == -1)
			{
				return clsfullname;
			}
			else
			{
				return clsfullname.substr(idx + 2);
			}
		}
		
		/**
		 * 对象clone 
		 * @param value
		 * @return 
		 * 
		 */
		public static function clone(value:Object):*
		{
			if(value == null)
				return null;
			var typeName:String = getClassFullName(value);//获取全名
			//trace(”输出类的结构”+typeName);
			//return;
			var packageName:String = typeName.split("::")[0];//切出包名
			//trace(”类的名称”+packageName);
			var type:Class = getDefinitionByName(typeName) as Class;//获取Class
			//trace(type);
			registerClassAlias(packageName, type);//注册Class
			
			var copier:ByteArray = new ByteArray();
			copier.writeObject(value);
			copier.position = 0;
			var copierobj:* = copier.readObject();
			copier.clear();
			return copierobj;
		}
	}
}