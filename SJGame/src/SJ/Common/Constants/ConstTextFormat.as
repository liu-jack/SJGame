package SJ.Common.Constants
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class ConstTextFormat
	{
		public function ConstTextFormat()
		{
		}

		public static const FONT_FAMILY_LISHU:String = "隶书";
		public static const FONT_FAMILY_HEITI:String = "黑体";
		public static const FONT_FAMILY_Arial:String = "Arial";
		/*** 大标题字体样式 **/
		public static var titleformat:TextFormat = new TextFormat(FONT_FAMILY_LISHU, 18, 0xFFE6BC,null,null,null,null,null,TextFormatAlign.CENTER);
		/*** 小标题字体样式 **/
		public static var smallTitleformat:TextFormat = new TextFormat(FONT_FAMILY_LISHU, 16, 0xDDF0AA);
		/** 普通文字体 **/
		public static var textformat:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 10, 0xDDF0AA);
		/** 小普通文字体 **/
		public static var textformatlittle:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 8, 0xDDF0AA);
		public static var fubentextformat:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 10, 0xDDF0AA,null,null,null,null,null,"center");
		/** 副本Item普通字体 **/
		public static var fubenitemtextformat:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 8, 0xFCE2A3);
		/** 普通文字体居中 **/
		public static var textformatcenter:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 10, 0xFCE2A3,null,null,null,null,null,TextFormatAlign.CENTER);
		/*** 副本关卡描述 **/
		public static var fubenDescformat:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 10, 0xDEE035);
		/*** 副本战斗结果界面内容**/
		public static var fubenResultText:TextFormat = new TextFormat(FONT_FAMILY_HEITI,16,0xFFFFFF);
		/*** 副本通关点击继续**/
		public static var fubenContineformat:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 16, 0xFCE2A3);
		/*** NPC对话框 NPC名字**/
		public static var npcdialognameformat:TextFormat = new TextFormat(FONT_FAMILY_HEITI,16,0xFCE2A3);
		
		/** 鲜艳黄色普通字号 **/
		public static var textformatyellow:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFFFF52);
		/** 鲜艳黄色小字号 **/
		public static var textformatyellowlittle:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 8, 0xFFFF52);
		/** 鲜艳黄色居中普通字号 **/
		public static var textformatyellowcenter:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 12, 0xFFFF52,null,null,null,null,null,TextFormatAlign.CENTER);
		/** 红色普通字号 居中对齐 **/
		public static var textformatredcenter:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 10, 0xFF0000,null,null,null,null,null, TextFormatAlign.CENTER);
		/** 红色普通字号 右对齐 **/
		public static var textformatredright:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 10, 0xFF0000,null,null,null,null,null, TextFormatAlign.RIGHT);
		/** 红色普通字号 右对齐 **/
		public static var textformatredlittle:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 8, 0xFF0000);
		/** 白色普通字号 **/
		public static var textformatwhite:TextFormat = new TextFormat(FONT_FAMILY_HEITI, FONT_SIZE_10, 0xFFFFFF);
		/** 白色普通字号 右对齐 **/
		public static var textformatwhiteright:TextFormat = new TextFormat(FONT_FAMILY_HEITI, FONT_SIZE_10, 0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
		
		public static var taskdialogtextformatwhite:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 14, 0xFFFFFF);
		
		/** 品质字体 - 居中 */
		public static var TEXT_FORMAT_QUALILTY_WIGHT_CENTER:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_QUALILTY_GREEN_CENTER:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x4EE431,null,null,null,null,null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_QUALILTY_BLUE_CENTER:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x3758E9,null,null,null,null,null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_QUALILTY_PURPLE_CENTER:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xC042EA,null,null,null,null,null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_QUALILTY_ORANGE_CENTER:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFF8400,null,null,null,null,null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_QUALILTY_RED_CENTER:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFF0000,null,null,null,null,null, TextFormatAlign.CENTER);
		/** 品质字体 - 左对齐 */
		public static var TEXT_FORMAT_QUALILTY_WIGHT_LEFT:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.LEFT);
		public static var TEXT_FORMAT_QUALILTY_GREEN_LEFT:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x4EE431,null,null,null,null,null, TextFormatAlign.LEFT);
		public static var TEXT_FORMAT_QUALILTY_BLUE_LEFT:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x3758E9,null,null,null,null,null, TextFormatAlign.LEFT);
		public static var TEXT_FORMAT_QUALILTY_PURPLE_LEFT:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xC042EA,null,null,null,null,null, TextFormatAlign.LEFT);
		public static var TEXT_FORMAT_QUALILTY_ORANGE_LEFT:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFAA219,null,null,null,null,null, TextFormatAlign.LEFT);
		public static var TEXT_FORMAT_QUALILTY_RED_LEFT:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFF0000,null,null,null,null,null, TextFormatAlign.LEFT);
		
		/**
		 * 武将品质名称颜色
		 * 1.白
		 * 2.绿
		 * 3.蓝
		 * 4.紫
		 * 5.橙
		 * 6.红
		 * @param quality	品质
		 * @param isCenter	是否居中
		 * @return  TextFormat
		 */
		public static function getFormatByQuality(quality:int, isCenter:Boolean=false):TextFormat
		{
			var arrCenter:Array = [null,
				TEXT_FORMAT_QUALILTY_WIGHT_CENTER,
				TEXT_FORMAT_QUALILTY_GREEN_CENTER,
				TEXT_FORMAT_QUALILTY_BLUE_CENTER,
				TEXT_FORMAT_QUALILTY_PURPLE_CENTER,
				TEXT_FORMAT_QUALILTY_ORANGE_CENTER,
				TEXT_FORMAT_QUALILTY_RED_CENTER];
			
			var arrLeft:Array = [null,
				TEXT_FORMAT_QUALILTY_WIGHT_LEFT,
				TEXT_FORMAT_QUALILTY_GREEN_LEFT,
				TEXT_FORMAT_QUALILTY_BLUE_LEFT,
				TEXT_FORMAT_QUALILTY_PURPLE_LEFT,
				TEXT_FORMAT_QUALILTY_ORANGE_LEFT,
				TEXT_FORMAT_QUALILTY_RED_LEFT];
			
			if (isCenter)
				return arrCenter[quality];
			else
				return arrLeft[quality];
		}
		
		/** 品质颜色 */
		public static var TEXT_COLOR_WIGHT:uint = 0xFFFFFF;
		public static var TEXT_COLOR_GREEN:uint = 0x4EE431;
		public static var TEXT_COLOR_BLUE:uint = 0x3758E9;
		public static var TEXT_COLOR_PURPLE:uint = 0xC042EA;
		public static var TEXT_COLOR_ORANGE:uint = 0xFAA219;
		public static var TEXT_COLOR_RED:uint = 0xFF0000;
		
		/** 品质颜色 */
		public static var TEXT_COLOR_WIGHT_STR:String = "#FFFFFF";
		public static var TEXT_COLOR_GREEN_STR:String = "#4EE431";
		public static var TEXT_COLOR_BLUE_STR:String = "#3758E9";
		public static var TEXT_COLOR_PURPLE_STR:String = "#C042EA";
		public static var TEXT_COLOR_ORANGE_STR:String = "#FAA219";
		public static var TEXT_COLOR_RED_STR:String = "#FF0000";
		
		/** 五行颜色 */
		public static var TEXT_COLOR_WUXING_JIN:Object = 0xE4CC00;
		public static var TEXT_COLOR_WUXING_MU:Object = 0x4A9E00;
		public static var TEXT_COLOR_WUXING_SHUI:Object = 0x00CBFE;
		public static var TEXT_COLOR_WUXING_HUO:Object = 0xEA0000;
		public static var TEXT_COLOR_WUXING_TU:Object = 0xCF960C;
		
		public static const FONT_SIZE_8:int = 8;
		public static const FONT_SIZE_9:int = 9;
		public static const FONT_SIZE_10:int = 10;
		public static const FONT_SIZE_16:int = 16;
		public static const FONT_SIZE_26:int = 26;
		
		public static const FONT_COLOR_WHITE:int = 0xFFFFFF;
		public static const FONT_COLOR_RED:int = 0xFF0000;
//		鲜艳黄色
		public static const FONT_COLOR_YELLOW:int = 0xFFFF52;
		public static const FONT_COLOR_TITLE:int = 0xFCE2A3;
		/** 白色普通字号 居中对齐 **/
		public static var textformatwhitecenter:TextFormat = new TextFormat( "Arial", 10, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.CENTER);

		/** 升阶武星名称标题 比较亮的黄色 **/
		public static var textformatsubheading:TextFormat = new TextFormat( FONT_FAMILY_LISHU, FONT_SIZE_16, FONT_COLOR_YELLOW,null,null,null,null,null, TextFormatAlign.CENTER);
		/** 升阶武星 技能说明 绿色字 **/
		public static var textformatgreen:TextFormat = new TextFormat( FONT_FAMILY_HEITI, FONT_SIZE_10, TEXT_COLOR_GREEN);
		/** 升阶武星 技能说明 小绿色字 **/
		public static var textformatgreenlittle:TextFormat = new TextFormat( FONT_FAMILY_HEITI, FONT_SIZE_8, TEXT_COLOR_GREEN);
		/** 升阶武星 需求武魂 蓝色字 **/
		public static var textformatblue:TextFormat = new TextFormat( FONT_FAMILY_HEITI, FONT_SIZE_10, 0x58F0E4);
		/** 升阶武星 需求武魂 小蓝色字 **/
		public static var textformatbluelittle:TextFormat = new TextFormat( FONT_FAMILY_HEITI, FONT_SIZE_8, 0x58F0E4);
		/** 青龙字体颜色 **/
		public static const FONT_COLOR_DRAGON:int = 0x51AAD8;
		/** 白虎字体颜色 **/
		public static const FONT_COLOR_TIGER:int = 0xFFFFFF;
		/** 朱雀字体颜色 **/
		public static const FONT_COLOR_BIRD:int = 0xFF0000;
		/** 玄武字体颜色 **/
		public static const FONT_COLOR_TORTOISE:int = 0xA57700;
		
		/** 获取升阶小标题字体 **/
		public static function getStageLevellittleTitleFont(stagelevel:int):TextFormat
		{
			var color:int = FONT_COLOR_DRAGON;
			switch(stagelevel)
			{
				case 1: color = FONT_COLOR_DRAGON; break;
				case 2: color = FONT_COLOR_TIGER; break;
				case 3: color = FONT_COLOR_BIRD; break;
				case 4: color = FONT_COLOR_TORTOISE; break;
				default: break;
			}
			return new TextFormat(FONT_FAMILY_HEITI, 10, color, true, null, null, null, null, TextFormatAlign.CENTER);
		}
		
		/** 绿色普通字号 居中对齐 **/
		public static var textformatgreencenter:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x73FF42, null,null,null,null,null, TextFormatAlign.CENTER);
		/** 淡蓝色普通字号 居中对齐 **/
		public static var textformatlightbluecenter:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x7CFFEB, null,null,null,null,null, TextFormatAlign.CENTER);
		/** 黑色普通字号 居中对齐 **/
		public static var textformatblackcenter:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x000000, null,null,null,null,null, TextFormatAlign.CENTER);
		/** 黑色普通字号 **/
		public static var textformatblack:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x000000, null,null,null,null,null, TextFormatAlign.RIGHT);
		/** 黑色普通字号 **/
		public static var textformatblackleft:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x000000, null,null,null,null,null, TextFormatAlign.LEFT);
		/** 白色黑体普通字号 居中对齐 **/
		public static var textformatheitiwhitecenter:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFFFFFF, null,null,null,null,null, TextFormatAlign.CENTER);
		/** 白色黑体普通字号 **/
		public static var textformatheitiwhite:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFFFFFF);

		/** 竞技场其它玩家名字***/
		public static var arenaOPlayerName:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x72ff6b, null,null,null,null,null, TextFormatAlign.CENTER);
		/** 竞技场自己名字***/
		public static var arenaSelfPlayerName:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xfff94f, null,null,null,null,null, TextFormatAlign.CENTER);
		
		/** 竞技场自己名字**/
		public static var arenaSPlayerName:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 8, 0xfff94f, null,null,null,null,null, TextFormatAlign.CENTER);
		/** 竞技场自己信息**/
		public static var arenaSPlayerInfo:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 8, 0xF6AE0C, null,null,null,null,null, TextFormatAlign.CENTER);
		/** 竞技场白色普通字体 **/
		public static var arenaBattleFormat:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10,0xffffff);
		
		public static var arenaBattleRedFormat:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10,0xff0000);
		/** 竞技场白色普通字体 **/
		public static var arenaRetFormat:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10,0xffe866);
		/** 竞技场奖励字体**/
		public static var arenaAwardFormat:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10,0xFFF72A);
		/** 竞技场个人金钱字体**/
		public static var arenaMoneyFormat:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10,0xFFFB84);
		/** 竞技场结果奖励字体**/
		public static var arenaTextFormat:TextFormat = new TextFormat(FONT_FAMILY_LISHU,18,0xFFA800);
		
		/** 青色普通字体 **/
		public static var textformatcyan:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 10, 0xBCEECB);
		
		/** 竞技榜白色字体**/
		public static var arenarankwhite:TextFormat = new TextFormat(FONT_FAMILY_HEITI,12,0xFFFFFF);
		/** 竞技榜黄色字体**/
		public static var arenarankyellow:TextFormat = new TextFormat(FONT_FAMILY_HEITI,12,0xFDFF65);
		/** 竞技榜青色字体**/
		public static var arenarankqingse:TextFormat = new TextFormat(FONT_FAMILY_HEITI,12,0x7CFFEB);
		/** 竞技榜字体**/
		public static var arenaranktitle:TextFormat = new TextFormat(FONT_FAMILY_LISHU,16,0xFFF960);
		/** 竞技榜小标题**/
		public static var arenaranksmalltitle:TextFormat = new TextFormat(FONT_FAMILY_LISHU,14,0xFFF960);
		/** 竞技榜我的排名**/
		public static var arenamyrank:TextFormat = new TextFormat(FONT_FAMILY_HEITI,12,0x8FCC53);
		/** 竞技场个人记录时间字体**/
		public static var arenarecordtime:TextFormat = new TextFormat(FONT_FAMILY_HEITI,12,0x57AA29);
		/** 竞技场战报字体**/
		public static var arenareport:TextFormat = new TextFormat(FONT_FAMILY_HEITI,12,0x38AEC5);
		/*** 竞技场查看个人**/
		public static var arenareportrecord:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10,0x8DFF41);
		/*** 竞技场战报字体**/
		public static var arenainforeport:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10);
		
		public static var arenainforeporttxt:TextFormat = new TextFormat(FONT_FAMILY_HEITI,10,0x38AEC5);
		/** 竞技场最近战绩 **/
		public static var arenainfolatesttxt:TextFormat = new TextFormat(FONT_FAMILY_LISHU,12,0xF0EC7C);
		/** 世界地图 **/
		public static var worldnametxt:TextFormat = new TextFormat(FONT_FAMILY_LISHU,12,0xFEFEB5,null,null,null,null,null,TextFormatAlign.CENTER);
		/** 副本抽奖标题**/
		public static var fubenboxtitletxt:TextFormat = new TextFormat(FONT_FAMILY_HEITI,16,0xE4CD90);
		
		/** 橘色 普通字体  左对齐 **/
		public static var textformatorange:TextFormat = new TextFormat(FONT_FAMILY_Arial, FONT_SIZE_10, 0xFF5519, true);
		
		/** 非常淡的蓝色普通字号 **/
		public static var textformatllblue:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xacffff);
		/** 卡其色普通字体 **/
		public static var textformatkhaki:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0xFCE2A3);
		/** 卡其色11号字体 **/
		public static var textformatkhakisize11:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 11, 0xFCE2A3);
		/** 卡其色14号字体 **/
		public static var textformatkhakisize14:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0xFCE2A3);
		
		public static var actItemtextformatunopen:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0xFF690F);
		
		public static var actItemtextformatopen:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0xBAFF61);
		
		public static var actItemtextformatdesc:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 12, 0xBAFF61);
		
		public static var actItemContenttextformatopen:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 12, 0xFF690F);
		
		/** vip使用黑色普通字号 **/
		public static var viptextformatblack:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 10, 0x000000, true,null,null,null,null, TextFormatAlign.LEFT, null, null, null, 3);
		
		/** 累积充值14号标签 **/
		public static var pileTextformat12:TextFormat = new TextFormat(FONT_FAMILY_HEITI, 12, 0xFFFFFF, true,null,null,null,null, TextFormatAlign.CENTER);
		
		public static var worldmapcityname:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0xF1FF79);
		
		public static var worldmapguankaname:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 12, 0xF1FF79);
		
		public static var worldmaplevelopen:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0xD1D1D1);
		
		public static var worldmappass:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0x990033,true);
		
		public static var worldmapnewopen:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0xFFB55E);
		
		public static  var worldguankaVit:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 12, 0xEBFFB4);
		
		public static var worldmapguankadesc:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 12, 0xF1FF79,null,null,null,null,null,TextFormatAlign.RIGHT);
		
		public static var twtitletextformat:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 18, 0xF2DC90,true);
		
		public static var twnormaltextformat:TextFormat = new TextFormat( FONT_FAMILY_HEITI, 14, 0xF2DC90,true);
	}
}