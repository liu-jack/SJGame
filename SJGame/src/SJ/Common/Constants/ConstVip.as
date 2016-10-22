package SJ.Common.Constants
{
	public class ConstVip
	{
		public function ConstVip()
		{
		}
		
		/** vip特权表头最大数，vip数量  vip0~vip12 **/		
		public static const VIP_MAX_FIELD:uint = 13;
		/** vip特权每页item **/
		public static const VIP_MAX_LINE:uint = 6;
		/** vip表头 **/
		public static const VIP_FIELD_NAME_ARR:Array = [
			"fb_vit","fb_rewards","fb_assist","fb_forcesoul","fb_quickfinish","actfb_extracount",
			"mt_batharvest","mt_nowatercd","mt_quickwater","mt_watercount","mt_upgradegold","arena_cancelcd",
			"arena_count","arena_quickfinish","jewel_batmake","jewel_discount","jewel_openhole","enhance_succeed",
			"recast_silver","recast_gold","hero_turncount","hero_transitem","hero_traincount","hero_notraincd",
			"xunbao_num","duobao_num","fuben_saodang"
		];

		/** 数量 **/
		public static const VIP_SHOW_TYPE_COUNT:uint = 0;
		/** 百分比 **/
		public static const VIP_SHOW_TYPE_PERCENT:uint = 1;
		/** 是否 **/
		public static const VIP_SHOW_TYPE_BOOLEAN:uint = 2;
		
		/** vip内信息类型 **/
		public static const VIP_FIELD_TYPE_OBJ:Object = {
			"fb_vit":VIP_SHOW_TYPE_COUNT,"fb_rewards":VIP_SHOW_TYPE_COUNT,"fb_assist":VIP_SHOW_TYPE_COUNT,
			"fb_forcesoul":VIP_SHOW_TYPE_PERCENT,"fb_quickfinish":VIP_SHOW_TYPE_BOOLEAN,"actfb_extracount":VIP_SHOW_TYPE_COUNT,
			"mt_batharvest":VIP_SHOW_TYPE_BOOLEAN,"mt_nowatercd":VIP_SHOW_TYPE_BOOLEAN,"mt_quickwater":VIP_SHOW_TYPE_BOOLEAN,
			"mt_watercount":VIP_SHOW_TYPE_COUNT,"mt_upgradegold":VIP_SHOW_TYPE_BOOLEAN,"arena_cancelcd":VIP_SHOW_TYPE_BOOLEAN,
			"arena_count":VIP_SHOW_TYPE_COUNT,"arena_quickfinish":VIP_SHOW_TYPE_BOOLEAN,"jewel_batmake":VIP_SHOW_TYPE_BOOLEAN,
			"jewel_discount":VIP_SHOW_TYPE_PERCENT,"jewel_openhole":VIP_SHOW_TYPE_BOOLEAN,"enhance_succeed":VIP_SHOW_TYPE_BOOLEAN,
			"recast_silver":VIP_SHOW_TYPE_PERCENT,"recast_gold":VIP_SHOW_TYPE_PERCENT,"hero_turncount":VIP_SHOW_TYPE_COUNT,
			"hero_transitem":VIP_SHOW_TYPE_PERCENT,"hero_traincount":VIP_SHOW_TYPE_COUNT,"hero_notraincd":VIP_SHOW_TYPE_BOOLEAN,
			"xunbao_num":VIP_SHOW_TYPE_COUNT,"duobao_num":VIP_SHOW_TYPE_COUNT,"fuben_saodang":VIP_SHOW_TYPE_BOOLEAN
		};
	}
}