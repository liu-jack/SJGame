package engine_starling.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.utils.ObjectUtil;

	public class SObjectUtils
	{
		public function SObjectUtils()
		{
		}
		
		/**
		 * 赋值每个属性给指定对象
		 * 要求每个属性都具有set get 方法 
		 * 对于只读属性，不包含在其中
		 * @param obj 指定对象
		 * @param output 输出对象
		 * @param includenullValue 是否包含null 对象 默认为T
		 * 
		 */
//		public static function PacktoObject(obj:Object,output:Object,includenullValue:Boolean = true):void
//		{
//			var options:Object = new Object();
//			options.includeReadOnly = false;
//			var classproperties:Array = ObjectUtil.getClassInfo(obj,null,options).properties as Array;
//			var n:QName;
//			if(includenullValue)
//			{
//				for each(n in classproperties)
//				{
//					output[n.localName] = obj[n.localName];
//				}
//			}
//			else
//			{
//				for each(n in classproperties)
//				{
//					if(obj[n.localName] != null)
//						output[n.localName] = obj[n.localName];
//				}
//			}
//		}
		public static function JsonObject2ObjectWithPropertys(jsonObj:Object,destobj:Object,propertys:Array):void
		{
			var length:int = propertys.length;
			var n:String;
			for(var i:int =0;i<length;++i)
			{
				n = propertys[i];
//				if(jsonObj.hasOwnProperty(n))
//				{
				destobj[n] = jsonObj[n];
//				}
//				else
//				{
//					destobj[n] = null;
//				}
			}
		}
		/**
		 * 简易拆箱函数 
		 * @param srcobj 序列化原对象，
		 * @param destobj 序列化目的对象
		 * @param templatefromsrc T以原对象jsonObj为模板进行序列号 F以目的对象destobj为模板进行序列化
		 * 注意,为true的时候,一般destobj 为 dynamic class 否则可能引发异常
		 * 
		 */
		public static function JsonObject2Object(jsonObj:Object,destobj:Object,templateFromJsonObj:Boolean = false):void
		{
			var options:Object = new Object();
			options.includeReadOnly = false;
			var classproperties:Array;
			//获取类模板
			if(templateFromJsonObj)
				classproperties = ObjectUtil.getClassInfo(jsonObj,null,options).properties as Array;
			else
				classproperties = ObjectUtil.getClassInfo(destobj,null,options).properties as Array;
			
			
			var length:int = classproperties.length;
			var n:QName;
			for(var i:int =0;i<length;++i)
			{
				n = classproperties[i];
				if(jsonObj.hasOwnProperty(n.localName))
				{
					destobj[n.localName] = jsonObj[n.localName];
				}
				else
				{
					destobj[n.localName] = null;
				}
			}

			
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
		 * 通过完整类名 返回类的实例 
		 * @param classname
		 * @return 
		 * 
		 */
		public static function getClassByFullName(classname:String):Class
		{
			return getDefinitionByName(classname) as Class;
		}
		
		/**
		 * 通过对象 返回类对象 
		 * @param obj
		 * @return 
		 * 
		 */
		public static function getClassByObject(obj:Object):Class
		{
			return getClassByFullName(getClassFullName(obj))
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
			return copier.readObject();
		}
	}
}