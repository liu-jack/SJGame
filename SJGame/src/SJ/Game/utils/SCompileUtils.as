package SJ.Game.utils
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_black_device_setting;
	import SJ.Game.data.json.Json_compilelist;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SPlatformUtils;
	import engine_starling.utils.SStringUtils;

	
	/**
	 * 编译开关 ，用于针对不同的渠道和版本的功能屏蔽
	 */ 
	public class SCompileUtils
	{
		private static var _o:SCompileUtils;
		private var _dic:Dictionary;
		
		/**
		 * 黑名单设备 peng.zhi ++ 
		 */		
		private var _black_devicename:Dictionary = new Dictionary();
		
		public function SCompileUtils(s:Singal)
		{
			_dic = new Dictionary();
			this._initData();
		}
		
		public static function get o():SCompileUtils
		{
			if(_o == null)
			{
				_o = new SCompileUtils(new Singal());
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonCompileList) as Array;
			if(obj == null)
			{
				return;
			}
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var compileConfig:Json_compilelist = new Json_compilelist();
				compileConfig.loadFromJsonObject(obj[i]);
				_dic[i] = compileConfig;
			}
			
			
			var devicetype:int = -1;
			if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_IOS)
			{
				devicetype = 0;
			}
			else if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_ANDROID)
			{
				devicetype = 1;
			}
			
			var blackdevice:Json_black_device_setting = new Json_black_device_setting();
			obj = AssetManagerUtil.o.getObject(ConstResource.sResJsonBlackDeviceSetting) as Array;
			if(obj == null)
			{
				return;
			}
			length = obj.length;
			for(i=0;i<length;i++)
			{
				blackdevice.loadFromJsonObject(obj[i]);
				//根据设备添加屏蔽列表
				if(int(blackdevice.devicetype) == devicetype)
				{
					_black_devicename[blackdevice.devicename] = true;
				}
			}
		}
		
		/**
		 * 是否正在审核中
		 */ 
		public function isOnVerify():Boolean
		{
			var currentVersion:String = SPlatformUtils.getApplicationVersion();
			var channel:int = int(ConstGlobal.CHANNEL);
			
			for(var i:String in this._dic)
			{
				var compilerConfig:Json_compilelist = _dic[i];
//				渠道id相等 版本号相等，并且配置是在审核中
				if(int(compilerConfig.channelid) == channel && !SStringUtils.isEmpty(compilerConfig.version) && compilerConfig.version == currentVersion && compilerConfig.isonverify == 1)
				{
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * 是否是黑名单设备 
		 * @return True 在黑名单中
		 * 
		 */
		public function isBlackDevice():Boolean
		{
			if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_ANDROID ||
				SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_IOS)
			{
				if(_black_devicename.hasOwnProperty(ConstGlobal.DeviceInfo.DeviceName))
				{
					return true;
				}
				return false;
			}
			return false;
		}
	}
}

class Singal{}