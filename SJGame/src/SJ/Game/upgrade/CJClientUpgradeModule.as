package SJ.Game.upgrade
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.json.Json_client_upgrade_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.utils.SApplicationUtils;
	import SJ.Game.utils.SCompileUtils;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SPlatformUtils;
	
	import starling.core.Starling;
	
	
	/**
	 * 升级功能
	 * 1.全局配置需要设置为开启升级 CLIENT_UPGRADE_ENABLE
	 * 2.对应渠道需要配置升级 神将渠道列表配置
	 */
	public class CJClientUpgradeModule extends CJModuleSubSystem
	{
		public function CJClientUpgradeModule()
		{
		}
		
		private var _upgradeconfig:Dictionary = new Dictionary();
		private var _url:*  ="http://xzoo.kaixin009.com/xzoo/cjgame/index.html";
		
		override protected function _onEnter(params:Object=null):void
		{
			//全局配置是否开启升级功能
			if(int(CJDataOfGlobalConfigProperty.o.getData('CLIENT_UPGRADE_ENABLE')) == 0)
			{
				SApplication.moduleManager.enterModule("CJLoginModule");
				return;
			}
			
			//过审核的版本不提示更新
			if (SCompileUtils.o.isOnVerify())
			{
				SApplication.moduleManager.enterModule("CJLoginModule");
				return;
			}
			
			if(CJDataManager.o.DataOfUserHabit.noUpgrade != 1)
			{
				_loadupgradeconfig();
				//需要强制升级 ， 直接崩掉
				if(_needforceupgrade())
				{
					CJMessageBox(CJLang("NEW_VERSION") , _navigateToURL);
				}
				//需要升级
				else if(_needupgrade())
				{
					CJConfirmMessageBox(CJLang("NEW_VERSION") , _navigateToURL , this._cancel);
				}
				else
				{
					SApplication.moduleManager.enterModule("CJLoginModule");
				}
			}
			else
			{
				SApplication.moduleManager.enterModule("CJLoginModule");
			}
			super._onEnter(params);
		}
		
		private function _cancel():void
		{
			CJDataManager.o.DataOfUserHabit.noUpgrade = 1;
			SApplication.moduleManager.exitModule("CJClientUpgradeModule");
			//进入登陆模块
			SApplication.moduleManager.enterModule("CJLoginModule");
		}
		
		//打开升级的URL
		private function _navigateToURL():void
		{
			var platform:ISPlatfrom = ISPlatfrom.builder(ConstGlobal.CHANNELID);
			CONFIG::CHANNELID_16
			{
				(platform as SPlatformKYIOS).installClient();
				
				Starling.juggler.delayCall(function():void
				{
					SApplicationUtils.exit();
				},2);
				
				return;
			}
			
				
			navigateToURL(new URLRequest(_url));
			Starling.juggler.delayCall(function():void
			{
				SApplicationUtils.exit();
			},2);
		}
		
		override protected function _onExit(params:Object=null):void
		{
		
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
			_initUpgradUrl();
		}
		/**
		 * 加载配置文件 
		 * 
		 */
		private function _loadupgradeconfig():void
		{
			var upgradeConfigList:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonClientUpgrade) as Array;
			if(upgradeConfigList == null)
			{
				return;
			}
//			获取当前渠道的升级配置信息
			var currentChannel:int = int(ConstGlobal.CHANNEL);
			_upgradeconfig = new Dictionary();
			var length:int = upgradeConfigList.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_client_upgrade_setting = new Json_client_upgrade_setting();
				data.loadFromJsonObject(upgradeConfigList[i]);
				//配置表中的ID
				//已当前版本号构建
				if(data.channelid == currentChannel)
				{
					_upgradeconfig[data.curverbose] = data;
				}
			}
		}
		
		/**
		 * 是否需要升級 
		 * @return 
		 * 
		 */
		private function _needupgrade():Boolean
		{
			var curverbose:String = SPlatformUtils.getApplicationVersion();
			var needUpgrade:Boolean = _upgradeconfig.hasOwnProperty(curverbose)
			//如果配置了數據,則说明要升级了
			if(needUpgrade)
			{
				var channelConfigList:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonClientChannel) as Array;
				var currentChannel:int = int(ConstGlobal.CHANNEL);
				//渠道配置为空，或者渠道配置不包含当前渠道
				if(channelConfigList == null || !channelConfigList.hasOwnProperty(currentChannel))
				{
					return false;
				}
				//当前设备型号
				var manufactory:String = SManufacturerUtils.getManufacturerType();
				if(manufactory == SManufacturerUtils.TYPE_ANDROID)
				{
					_url = channelConfigList[currentChannel].upgradeurlandroid;
				}
				else if(manufactory == SManufacturerUtils.TYPE_IOS)
				{
					_url = channelConfigList[currentChannel].upgradeurlios;
				}
				else
				{
					_url = "http://xzoo.kaixin009.com/xzoo/cjgame/index.html";
				}
			}
			
			return needUpgrade;
		}
		
		private function _initUpgradUrl():String
		{
			var channelConfigList:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonClientChannel) as Array;
			var currentChannel:int = int(ConstGlobal.CHANNEL);
			//渠道配置为空，或者渠道配置不包含当前渠道
			if(channelConfigList == null || !channelConfigList.hasOwnProperty(currentChannel))
			{
				return _url;
			}
			//当前设备型号
			var manufactory:String = SManufacturerUtils.getManufacturerType();
			if(manufactory == SManufacturerUtils.TYPE_ANDROID)
			{
				_url = channelConfigList[currentChannel].upgradeurlandroid;
			}
			else if(manufactory == SManufacturerUtils.TYPE_IOS)
			{
				_url = channelConfigList[currentChannel].upgradeurlios;
			}
			else
			{
				_url = "http://xzoo.kaixin009.com/xzoo/cjgame/index.html";
			}
			return _url;
		}
		
		/**
		 * 是否需要强制升级 
		 * @return 
		 * 
		 */
		private function _needforceupgrade():Boolean
		{
			var curverbose:String = SPlatformUtils.getApplicationVersion();
			var _mupgradecon:Json_client_upgrade_setting = _upgradeconfig[curverbose];
			if(_needupgrade())
			{
				while(true)
				{
					if(int(_mupgradecon.forceupgrade) ==  1)
					{
						return true;
					}
					else
					{
						//继续检测下一个版本
						_mupgradecon  =_upgradeconfig[_mupgradecon.upgradeverbose];
						if(_mupgradecon == null)
						{
							return false;
						}
					}
				}
			}
			else
			{
				return false;
			}
			return false;
		}
	}
}