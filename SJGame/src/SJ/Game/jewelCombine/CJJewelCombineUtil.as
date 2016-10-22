package SJ.Game.jewelCombine
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstJewel;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.json.Json_item_jewel_config;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	
	import lib.engine.utils.functions.Assert;

	/**
	 * @author zhengzheng
	 * 宝石合成工具类
	 */
	public class CJJewelCombineUtil
	{
		public function CJJewelCombineUtil()
		{
		}
		private static var _o:CJJewelCombineUtil = null;
		//宝石提示框
//		private var _tooltip:CJItemTooltip;
		/**
		 * 获得宝石合成工具类的单例
		 * @return CJJewelCombineUtil实例
		 */		
		public static function get o():CJJewelCombineUtil
		{
			if(null == _o)
			{
				_o = new CJJewelCombineUtil();
			}
			return _o;
		}
		/**
		 * 品质设置
		 * @param quality 品质
		 * @param label 文本
		 */		
		public function setItemQuality(quality:int, label:Label):void
		{
			var colorArray:Array = ConstItem.SCONST_ITEM_QUALITY_COLOR;
			var textFormat:TextFormat;
			if (quality > 6 || quality < 1)
			{
				Assert(false,"品质类型设置错误！");
				return;
			}
			textFormat = new TextFormat( "Arial", 10, colorArray[quality]);
			label.textRendererProperties.textFormat = textFormat;
		}
		/**
		 * 显示宝石提示信息
		 * @param jewelId 宝石模板id
		 * @param itemId 宝石唯一id
		 */
		public function showJeweltip(itemTemplateId:int):void
		{
//			_tooltip = new CJItemTooltip();
//			_tooltip.setItemTemplateIdAndRefresh(itemTemplateId);
//			CJLayerManager.o.addModuleLayer(_tooltip);
			CJItemUtil.showItemTooltipsWithTemplateId(itemTemplateId);
		}
		
		/**
		 * 通过宝石子类型获得宝石的属性加成
		 * @param subType 宝石子类型
		 * @param templateItemJewelConfig 道具宝石配置
		 * @return 宝石的属性加成
		 * 
		 */		
		public function getJewelPropertyBySubtype(subType:int, templateItemJewelConfig:Json_item_jewel_config):int
		{
			switch (subType)
			{
				case ConstJewel.JEWEL_SUBTYPE_BAOJI:
					return templateItemJewelConfig.baojiadd;
				case ConstJewel.JEWEL_SUBTYPE_RENXING:
					return templateItemJewelConfig.renxingadd;
				case ConstJewel.JEWEL_SUBTYPE_SHANBI:
					return templateItemJewelConfig.shanbiadd;
				case ConstJewel.JEWEL_SUBTYPE_MINGZHONG:
					return templateItemJewelConfig.mingzhongadd;
				case ConstJewel.JEWEL_SUBTYPE_FASHUMIANYI:
					return templateItemJewelConfig.famianadd;
				case ConstJewel.JEWEL_SUBTYPE_FASHUCHUANTOU:
					return templateItemJewelConfig.fachuanadd;
				case ConstJewel.JEWEL_SUBTYPE_XIXUE:
					return templateItemJewelConfig.xixueadd;
				case ConstJewel.JEWEL_SUBTYPE_FABAO:
					return templateItemJewelConfig.fabaoadd;
				case ConstJewel.JEWEL_SUBTYPE_FAREN:
					return templateItemJewelConfig.farenadd;
				case ConstJewel.JEWEL_SUBTYPE_ZHILIAOXIAOGUO:
					return templateItemJewelConfig.zhiliaoxiaoguoadd;
				case ConstJewel.JEWEL_SUBTYPE_JIANSHANG:
					return templateItemJewelConfig.jianshangadd;
				case ConstJewel.JEWEL_SUBTYPE_SHANGHAIJIASHEN:
					return templateItemJewelConfig.shanghaijiashenadd;
				case ConstJewel.JEWEL_SUBTYPE_JIN:
					return templateItemJewelConfig.jinadd;
				case ConstJewel.JEWEL_SUBTYPE_MU:
					return templateItemJewelConfig.muadd;
				case ConstJewel.JEWEL_SUBTYPE_SHUI:
					return templateItemJewelConfig.shuiadd;
				case ConstJewel.JEWEL_SUBTYPE_HUO:
					return templateItemJewelConfig.huoadd;
				case ConstJewel.JEWEL_SUBTYPE_TU:
					return templateItemJewelConfig.tuadd;
				default:
					Assert(false,"宝石子类型不存在");
					return 0;
			}	
		}
	}
}
