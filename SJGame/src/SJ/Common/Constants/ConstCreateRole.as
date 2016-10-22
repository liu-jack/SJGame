package SJ.Common.Constants
{
	/**
	 * 创建角色常量信息
	 * @author longtao
	 * 
	 */
	public final class ConstCreateRole
	{
		public function ConstCreateRole()
		{
		}
		
		/**
		 * 最大角色数量
		 */
		public static const ConstMaxRoleCount:uint = 3;
		
		/**
		 * 选择角色时默认的选择索引
		 */
		public static const ConstDefaultIndex:uint = 0;
		
		/**
		 * 角色名称最大长度
		 */
		public static const ConstMaxRoleNameCount:uint = 12;
		
		/**
		 * 角色名称最小长度
		 */
		public static const ConstMinRoleNameCount:uint = 2;
		
		/**
		 * 假名字进入游戏时间间隔	单位：秒
		 */
		public static const ConstTimeGap:uint = 2;
		
		/**
		 * 假名字进入游戏Lable最大显示行数
		 */
		public static const ConstFakeLabelMaxLine:uint = 5;
	}
}