package SJ.Game.utils
{
	import com.adobe.nativeExtensions.Networkinfo.NetworkInfo;
	
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SStringUtils;
	
	import flash.net.NetworkInfo;
	
	/**
	 * 网络工具类 
	 * @author caihua
	 * 
	 */
	public class SNetWorkUtils
	{
		public function SNetWorkUtils(s:Singleton)
		{
		}
		
		private static var _o:SNetWorkUtils; 
		public static function get o():SNetWorkUtils
		{
			if (_o == null)
			{
				_o =new  SNetWorkUtils(new Singleton());
			}
			return _o;
		}
		
		private function _getNetWorketInterface():Object
		{
			var vNetworkInterfaces:Object; 
			if (flash.net.NetworkInfo.isSupported) 
			{ 
				
				vNetworkInterfaces = flash.net.NetworkInfo.networkInfo.findInterfaces();
			} 
			else 
			{ 
//				vNetworkInterfaces = com.adobe.nativeExtensions.Networkinfo.NetworkInfo.networkInfo.findInterfaces();
			}
			return vNetworkInterfaces;
		}
		/**
		 * 获得物理地址,如果设备有多个物理地址,值返回第一个 
		 * @return 
		 * 
		 */
		public static function get hardAddress():String
		{
			var vNetworkInterfaces:Object = o._getNetWorketInterface(); 
			
			for each (var networkInterface:Object in vNetworkInterfaces)
			{ 
					if(!SStringUtils.isEmpty(networkInterface.hardwareAddress))
						return networkInterface.hardwareAddress;

			}
			
			return null;
		}
		/**
		 * 获取WIFI基础信息 
		 * @return 
		 * 
		 */
		public static function get WIFIBaseInfo():Object
		{
			var vNetworkInterfaces:Object = o._getNetWorketInterface(); 
			
			for each (var networkInterface:Object in vNetworkInterfaces) 
			{ 
				if ( (networkInterface.name == "en0" || networkInterface.name == "en1" || networkInterface.name == "WIFI" || networkInterface.displayName == "本地连接") ) 
				{
					return networkInterface
				}				
			} 
			return null;
		}
		
		/**
		 * 是否有网络 
		 * @return 
		 * 
		 */
		public static  function get WIFIEnable():Boolean
		{

			if (SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_WINDOWS)
			{
				return true;
			}
			var hasWifi:Boolean = false;
			var vNetworkInterfaces:Object = o._getNetWorketInterface(); 
			
			for each (var networkInterface:Object in vNetworkInterfaces) 
			{ 
				if ( networkInterface.active && (networkInterface.name == "en0" || networkInterface.name == "en1" || networkInterface.name == "WIFI" 
					|| networkInterface.displayName == "本地连接") ) 
				{
					hasWifi = true;
					break;
				}				
			} 
			return hasWifi;
		}
		
		/**
		 * 是否有3G连接 
		 * @return 
		 * 
		 */
		public static function get _3GEnable():Boolean
		{
	
			if (SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_WINDOWS)
			{
				return true;
			}
			var hasMobile:Boolean = false;
			
			var vNetworkInterfaces:Object = o._getNetWorketInterface(); 
			
			for each (var networkInterface:Object in vNetworkInterfaces) 
			{ 

				if ( networkInterface.active && (networkInterface.name == "pdp_ip0" || networkInterface.name == "pdp_ip1" || networkInterface.name == "pdp_ip2"
					|| networkInterface.name == "mobile") ) 
				{
					hasMobile = true;
					break;
				}
				
			} 
			return hasMobile;
		}
	}
}


class Singleton
{
	public function Singleton()
	{
		
	}
}