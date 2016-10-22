package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;
	import SJ.Game.data.CJDataOfBagExpand;

	/**
	 * 背包扩充配置数据
	 * @author sangxu
	 * 
	 */	
	public class CJDataOfBagExpandProperty extends SDataBase
	{
		
		public function CJDataOfBagExpandProperty()
		{
			super("CJDataOfBagExpandSetting");
			
		}
		
		private static var _o:CJDataOfBagExpandProperty;
		public static function get o():CJDataOfBagExpandProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfBagExpandProperty();
				_o._initData();
			}
			return _o;
		}
		
		/**
		 * 初始化数据
		 * 
		 */
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonExpandConfig) as Array;
			var length:int = obj.length;
			for(var i:int=0; i < length; i++)
			{
				var template : CJDataOfBagExpand = new CJDataOfBagExpand();
				template.id = parseInt(obj[i]['id']);
				template.containerType = parseInt(obj[i]['containertype']);
				template.number = parseInt(obj[i]['number']);
				template.costType = parseInt(obj[i]['costtype']);
				template.costPrice = parseInt(obj[i]['costprice']);
				setTemplate(template);
			}
		}
		
		/**
		 * 获取全部容器扩充配置数据
		 * @return 
		 * 
		 */		
		public function getAllTemplates():Dictionary
		{
			return CObjectUtils.clone(this._dataContains);
		}
		
		/**
		 * 获取容器扩充配置数据
		 */
		public function getTemplate(templateId : int) : CJDataOfBagExpand
		{
			return CObjectUtils.clone(this.getData(String(templateId)));
		}
		
		/**
		 * 设置容器扩充配置数据
		 */
		public function setTemplate(template : CJDataOfBagExpand) : void
		{
			this.setData(String(template.id), template);
		}
	}
}