package engine_starling
{
	public class Version
	{
		public function Version()
		{
		}
		
		/**
		 * 当前Engine的版本号 
		 */
		public static const VERSION:String = "1.0.9";
		
		/**
		 *
		 * 
		 * 版本号1.0.9
		 * 2013年12月17日
		 * 1.SDataBase增加忽略事件接口
		 * 2.转换Data常用接口为Inline
		 * 3.Logger增加毫秒数
		 * 4.增加SAssetCache SaveMd5为5秒一次
		 * 5.去除程序资源写入本地缓存操作
		 * 6.简化Zipd加载方式
		 * 7.增加json，MP3 为延时加载
		 * 
		 * 
		 * 
		 * 版本号1.0.8
		 * 2013年11月27日
		 * 1.增加修改ＣＭｏｄｕｌｅ为反射类注册
		 * 2.增加客户端支持lua控制台
		 * 3.增加SLayer支持LUA
		 * 4.增加CModule支持lua
		 * 
		 * 
		 * 版本号1.0.7
		 * 日期:2013年11月23日
		 * 1.增加对spriter的支持 http://www.sammyjoeosborne.com/SpriterMC/
		 * 2.修改SpriterMC骨骼动画支持换装
		 * 2.1.增加SpriterMC 解析 createSpriterMCExt
		 * 3.资源管理器支持对 scml文件解析
		 * 4.骨骼动画编辑器用 http://www.brashmonkey.com/spriter.htm (release b5)
		 * 
		 *  
		 * 版本号1.0.6
		 * 日期:2013年11月19日
		 * 1.增加对cocosstdio的支持 UI部分
		 * 
		 * 版本号1.0.5
		 * 日期:2013年11月18日
		 * 1.Socket重构到了Engine中
		 * 
		 * 
		 * 
		 * 版本号1.0.4
		 * 日期:2013年11月7日
		 * 1.修改SDataBaseJson序列化json的速度
		 * 2.修改ReplaceString的速度
		 * 3.增加SAssetCache校验文件的次序，可以通过CDN下载校验文件
		 * 
		 * 
		 * 
		 * 版本号1.0.3
		 * 日期:2013年10月23日
		 * 1.完善SAnimate类
		 * 2.完善SCamera场景剪裁
		 * 3.支持用户保存路径输出
		 * 
		 * 版本号1.0.2
		 * 日期:2013年10月16日
		 * 1.增加对Starling 1.4的支持
		 * 2.增加SCamera类自动剪裁对象属性
		 * 
		 * 
		 * 版本号1.0.1
		 * 日期:2013-09-26
		 * 1.增加可以调节速度的 SJuggler
		 * 2.增加SAssetCache下载远程文件后的回调,可以持续下载
		 * 3.分离客户端加载资源的过程。需要手动调用loadResource进行启动
		 * 
		 * 
		 * 更新记录
		 * 版本号1.0.0 创建基础版本
		 * 日期:2013年9月22日
		 * */
		
		
	}
}