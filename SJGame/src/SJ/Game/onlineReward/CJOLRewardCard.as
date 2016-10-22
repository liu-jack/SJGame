package SJ.Game.onlineReward
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_onlineReward;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfOLReward;
	import SJ.Game.data.config.CJDataOfOLRewardProperty;
	import SJ.Game.data.json.Json_online_reward_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 在线奖励牌
	 * @author longtao
	 * 
	 */
	public class CJOLRewardCard extends SLayer
	{
		/** 可领取状态 **/
		public static const STATE_RECEIVE:uint = 0;
		/** 倒计时 **/
		public static const STATE_COUNTDOWN:uint = 1;
		/** 未满足条件 **/
		public static const STATE_NOT_CONTENT:uint = 2;
		/** 已领取 **/
		public static const STATE_HAVE_RECEIVE:uint = 3;
		
		private var _index:uint;
		/** 领取按钮 **/
		private var _btn:Button;
		/** 倒计时背景框 **/
		private var _timeGB:Scale9Image;
		/** 文字显示 **/
		private var _label:Label;
		/** 倒计时时间 **/
		private var _time:uint = 0;
		/** 当前状态 **/
		private var _state:uint = STATE_RECEIVE;
		
		public function CJOLRewardCard(tWidth:uint, tHeight:uint)
		{
			super();
			
			width = tWidth;
			height = tHeight;
		}
		
		/**
		 * 设置当前形态
		 * @param value
		 */
		public function setState(value:uint):void
		{
			if (_state == value)
				return;
			
			_state = value;
			// 更新界面
			_update();
		}
		
		/**
		 * 更新时间
		 */
		public function updateTime( ):void
		{
			
			// 在线奖励
			var dataofOLReward:CJDataOfOLReward = CJDataManager.o.DataOfOLReward;
			// json数据
			var nextid:String = String(uint(dataofOLReward.rewardid)+1);
			var json:Json_online_reward_setting = CJDataOfOLRewardProperty.o.getData(nextid);
			Assert( json!=null, "CJOLRewardCard.updateTime() json!=null");
			
			var differtime:int = dataofOLReward.countdown;
			var h:Number = Math.floor( differtime / 3600); 
			var m:Number = Math.floor( ( differtime - h * 3600 ) / 60 ); 
			var s:Number = differtime - h * 3600 - m * 60;
			
			var sh:String = h.toString();
			var sm:String = m.toString();
			var ss:String = s.toString();
			if (sh.length == 1)
				sh = "0" + sh;
			if (sm.length == 1)
				sm = "0" + sm;
			if (ss.length == 1)
				ss = "0" + ss;
			// 冷却时间
			_label.text = sh + ":" + sm + ":" + ss;
		}
		
		override protected function initialize():void
		{
			// 底框
			var texture:Texture = SApplication.assets.getTexture("zaixianjiangli_kuang");
			var scale9Texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(10,10 ,2,1));
			var bg:Scale9Image = new Scale9Image(scale9Texture);
			bg.width = width;
			bg.height = height;
			addChild(bg);
			
			// 黄色底图
			var backpanel:ImageLoader = new ImageLoader;
			backpanel.source = SApplication.assets.getTexture("zaixianjiangli_liwuzhuangshi");
			backpanel.x = 2;
			backpanel.y = 15;
			addChild(backpanel);
			
			// 宝箱
			var treasureChests:ImageLoader = new ImageLoader;
			treasureChests.source = SApplication.assets.getTexture("zaixianjiangli_baoxiang");
			treasureChests.x = backpanel.x+6;
			treasureChests.y = backpanel.y+4;
			treasureChests.width = 51;
			treasureChests.height = 52;
			addChild(treasureChests);
			
			// 分割线
			var imgLine:ImageLoader = new ImageLoader;
			imgLine.source = SApplication.assets.getTexture("zaixianjiangli_xian");
			imgLine.x = 4;
			imgLine.y = 85;
			addChild(imgLine);
			
			// 倒计时背景图片
			texture = SApplication.assets.getTexture("zaixianjiangli_daojishidi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(2,2 ,5,5));
			_timeGB = new Scale9Image(scale9Texture);
			_timeGB.x = 7;
			_timeGB.y = 95;
			_timeGB.width = 53;
			_timeGB.height = 17;
			addChild(_timeGB);
			
			// 倒计时label
			_label = new Label;
			_label.textRendererProperties.textFormat = ConstTextFormat.textformatblackcenter;
			_label.x = 0;
			_label.y = _timeGB.y+1;
			_label.width = bg.width;
			_label.height = bg.height;
			addChild(_label);
			
			// 领取按钮
			_btn = new Button;
			_btn.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			_btn.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btn.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btn.x = 9;
			_btn.y = 93;
			_btn.width = 50;
			_btn.height = 18;
			addChild(_btn);
			_btn.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			_btn.addEventListener(Event.TRIGGERED, function (e:*):void{
				SocketCommand_onlineReward.get_reward(String(index+1));
			});
			
			_update();
		}
		
		/** 更新界面 **/
		private function _update():void
		{
			_btn.isEnabled = true;
			switch( _state )
			{
				case STATE_RECEIVE: // 未领取状态
					_timeGB.visible = false;
					_label.visible = false;
					_btn.visible = true;
					
					_btn.label = CJLang("ONLINE_REWARD_RECEIVE");
					break;
				case STATE_COUNTDOWN: // 倒计时
					_timeGB.visible = true;
					_label.visible = true;
					_btn.visible = false;
					
					updateTime();
					break;
				case STATE_NOT_CONTENT: // 未满足条件
					_timeGB.visible = false;
					_label.visible = true;
					_btn.visible = false;
					
					_label.text = CJLang("ONLINE_REWARD_CAN_NOT_RECEIVE");
					break;
				case STATE_HAVE_RECEIVE: // 已领取
					_timeGB.visible = false;
					_label.visible = false;
					_btn.visible = true;
					
					_btn.label = CJLang("ONLINE_REWARD_HAVE_RECEIVE");
					_btn.isEnabled = false;
					break;
				default:
					Assert( false, "CJOLRewardCard._update  unknow state="+_state );
					return;
			}
		}

		/** 索引 **/
		public function get index():uint
		{
			return _index;
		}
		/**
		 * @private
		 */
		public function set index(value:uint):void
		{
			_index = value;
		}

		
	}
}