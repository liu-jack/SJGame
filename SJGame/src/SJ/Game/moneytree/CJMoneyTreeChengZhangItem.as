package SJ.Game.moneytree
{
	import SJ.Common.Constants.ConstHero;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAccounts;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfMoneyTreeFriend;
	import SJ.Game.data.CJDataOfMoneyTreeMine;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.richtext.CJRTElementLabel;
	import SJ.Game.richtext.CJRichText;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.text.TextField;
	
	/**
	 * 摇钱树成长
	 * @author sangxu
	 * 
	 */	
	public class CJMoneyTreeChengZhangItem extends CJItemTurnPageBase
	{
		/** 控件宽度 **/
		private const CONST_WIDTH:int = 390;
		/** 控件高度 **/
		private const CONST_HEIGHT:int = 26;
		/** X坐标 **/
		private const CONST_X:int = 0;
		/** Y坐标 **/
		private const CONST_Y:int = 0;
		
		/** data */
		/** 数据 - 玩家数据 */
		private var _dataAccount:CJDataOfAccounts;
		/** 数据 - 好友的摇钱树 */
		private var _dataMTFriend:CJDataOfMoneyTreeFriend;
		/** 数据 - 全局配置 */
		private var _globalConfig:CJDataOfGlobalConfigProperty;
		
		/*渲染时候在父容器的索引*/
//		private var _index:int;
		/** 富文本 - 内容 */
		private var _rtContant:CJRichText;
		
		public function CJMoneyTreeChengZhangItem()
		{
			super("CJMoneyTreeChengZhangItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._initData();
			this._initControls();
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			this._dataAccount = CJDataManager.o.getData("CJDataOfAccounts") as CJDataOfAccounts;
			
			this._dataMTFriend = CJDataManager.o.getData("CJDataOfMoneyTreeFriend") as CJDataOfMoneyTreeFriend;
			
			this._globalConfig = CJDataOfGlobalConfigProperty.o;
		}
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			width = CONST_WIDTH;
			height = CONST_HEIGHT;
			
			// 武将头像底框
			this._rtContant = new CJRichText(CONST_WIDTH);
			this._rtContant.x = CONST_X;
			this._rtContant.y = CONST_Y;
			addChild(this._rtContant);
		}
		
		override protected function draw():void
		{
			super.draw();
			var dataJson:Object = this.data as Object;
			
			var elementArray:Array = new Array();
//			var jsonObj:Object = JSON.parse(dataJson) as Object;
			
			var friendUid:String = dataJson.srcuid;
			var friendName:String = this._dataMTFriend.getFriendName(friendUid);
			var feedType:int = int(dataJson.feedtype);
			var newLv:int = int(dataJson.extinfo);
			var time:Number = Number(dataJson.time);
			// 是否是自己
			var isMine:Boolean = (friendUid == _dataAccount.userID);
			
			var elArray:Array = new Array();
			var str:String = "";
			var name:String = "";
			var rtLabel:CJRTElementLabel;
			var rtLabTime:CJRTElementLabel;
			
			if (true == isMine)
			{
				// 我的摇钱树
				
				var date:Date = new Date((time - (8 * 60 * 60)) * 1000);
					
				rtLabTime = new CJRTElementLabel();
				rtLabTime.height = 13;
				rtLabTime.color = 0xE8FF99;
				rtLabTime.size = 10;
				rtLabTime.text = "[" 
							+ _getStringValue(date.month + 1) + "-" 
							+ _getStringValue(date.date) + " " 
							+ _getStringValue(date.hours) 
							+ ":" 
							+ _getStringValue(date.minutes) 
							+ "]";
				elArray.push(rtLabTime);
				
				if (newLv > 0)
				{
					// 升级
					str = CJLang("MONEYTREE_CHENGZHANG_I_SHIFEI_LV");
					str = str.replace("{exp}", _globalConfig.getData("MONEY_TREE_FEEDTREEADDEXP"));
					str = str.replace("{level}", newLv);
					
					rtLabel = new CJRTElementLabel();
					rtLabel.height = 13;
					rtLabel.color = 0xE8FF99;
					rtLabel.size = 10;
					rtLabel.text = str;
//					rtLabel.spacex = -4;
					elArray.push(rtLabel);
					
					this._rtContant.draWithElementArray(elArray);
				}
				else
				{
					// 未升级
					str = CJLang("MONEYTREE_CHENGZHANG_I_SHIFEI");
					str = str.replace("{exp}", _globalConfig.getData("MONEY_TREE_FEEDTREEADDEXP"));
					
					rtLabel = new CJRTElementLabel();
					rtLabel.height = 13;
					rtLabel.color = 0xE8FF99;
					rtLabel.size = 10;
					rtLabel.text = str;
//					rtLabel.spacex = -4;
					elArray.push(rtLabel);
					
					this._rtContant.draWithElementArray(elArray);
				}
			}
			else
			{
				var date:Date = new Date((time - (8 * 60 * 60)) * 1000);
				
				rtLabTime = new CJRTElementLabel();
				rtLabTime.height = 13;
				rtLabTime.color = 0xE8FF99;
				rtLabTime.size = 10;
				rtLabTime.text = "[" 
					+ _getStringValue(date.month + 1) + "-" 
					+ _getStringValue(date.date) + " " 
					+ _getStringValue(date.hours) 
					+ ":" 
					+ _getStringValue(date.minutes) 
					+ "]";
				elArray.push(rtLabTime);
				
				// 好友的摇钱树
				if (newLv > 0)
				{
					// 升级
					name = CJLang("MONEYTREE_FRIEND_NAME");
					name = name.replace("{name}", friendName);
					
					str = CJLang("MONEYTREE_SHIFEI_CHENGZHANG_SHIFEI");
					str = str.replace("{exp}", _globalConfig.getData("MONEY_TREE_FEEDTREEADDEXP"));
					str = str.replace("{level}", newLv);
					
					rtLabel = new CJRTElementLabel();
					rtLabel.height = 13;
					rtLabel.color = 0xFF7E00;
					rtLabel.size = 10;
					rtLabel.text = name;
//					rtLabel.spacex = -4;
					elArray.push(rtLabel);
					
					rtLabel = new CJRTElementLabel();
					rtLabel.height = 13;
					rtLabel.color = 0xE8FF99;
					rtLabel.size = 10;
					rtLabel.text = str;
					rtLabel.spacex = -4;
					elArray.push(rtLabel);
					
					this._rtContant.draWithElementArray(elArray);
				}
				else
				{
					// 未升级
					name = CJLang("MONEYTREE_FRIEND_NAME");
					name = name.replace("{name}", friendName);
					
					str = CJLang("MONEYTREE_CHENGZHANG_FRIEND_SHIFEI");
					str = str.replace("{exp}", _globalConfig.getData("MONEY_TREE_FEEDTREEADDEXP"));
					
					rtLabel = new CJRTElementLabel();
					rtLabel.height = 13;
					rtLabel.color = 0xFF7E00;
					rtLabel.size = 10;
					rtLabel.text = name;
//					rtLabel.spacex = -4;
					elArray.push(rtLabel);
					
					rtLabel = new CJRTElementLabel();
					rtLabel.height = 13;
					rtLabel.color = 0xE8FF99;
					rtLabel.size = 10;
					rtLabel.text = str;
					rtLabel.spacex = -4;
					elArray.push(rtLabel);
					
					this._rtContant.draWithElementArray(elArray);
				}
			}
		}
		
		private function _getStringValue(value:int):String
		{
			if (value >= 10)
			{
				return String(value);
			}
			return "0" + value;
		}
		
		/**
		 * 点击事件
		 */		
		override protected function onSelected():void
		{
			
		}
	}
}