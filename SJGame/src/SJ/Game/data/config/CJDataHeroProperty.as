package SJ.Game.data.config
{
	import SJ.Game.data.json.Json_hero_propertys;

	/**
	 +------------------------------------------------------------------------------
	 * @name 武将的静态属性DAO类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-1 下午2:19:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataHeroProperty extends Json_hero_propertys
	{
		
		public function CJDataHeroProperty(dataList:Object = null)
		{
			
		}
		

//		public function get logo():String
//		{
//			return "touxiang_"+this.anim;
//		}
		
		private var _talent:uint;

		/**
		 * 武将天赋
		 */
		public function get talent():uint
		{
			return _talent;
		}

		/**
		 * @private
		 */
		public function set talent(value:uint):void
		{
			_talent = value;
		}
	}
}