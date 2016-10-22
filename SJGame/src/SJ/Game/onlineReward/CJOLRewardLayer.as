package SJ.Game.onlineReward
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstOnlineReward;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_onlineReward;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfOLReward;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfOLRewardProperty;
	import SJ.Game.data.json.Json_online_reward_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 在线奖励
	 * @author longtao
	 * 
	 */
	public class CJOLRewardLayer extends SLayer
	{
		private var _imgBG:ImageLoader;
		/**  背景 **/
		public function get imgBG():ImageLoader
		{
			return _imgBG;
		}
		/** @private **/
		public function set imgBG(value:ImageLoader):void
		{
			_imgBG = value;
		}
		private var _btnClose:Button;
		/**  关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		private var _titlePos:ImageLoader;
		/**  标题位置 **/
		public function get titlePos():ImageLoader
		{
			return _titlePos;
		}
		/** @private **/
		public function set titlePos(value:ImageLoader):void
		{
			_titlePos = value;
		}
		private var _labelTime0:Label;
		/**  时间描述0 **/
		public function get labelTime0():Label
		{
			return _labelTime0;
		}
		/** @private **/
		public function set labelTime0(value:Label):void
		{
			_labelTime0 = value;
		}
		private var _labelTime1:Label;
		/**  时间描述1 **/
		public function get labelTime1():Label
		{
			return _labelTime1;
		}
		/** @private **/
		public function set labelTime1(value:Label):void
		{
			_labelTime1 = value;
		}
		private var _labelTime2:Label;
		/**  时间描述2 **/
		public function get labelTime2():Label
		{
			return _labelTime2;
		}
		/** @private **/
		public function set labelTime2(value:Label):void
		{
			_labelTime2 = value;
		}
		private var _labelTime3:Label;
		/**  时间描述3 **/
		public function get labelTime3():Label
		{
			return _labelTime3;
		}
		/** @private **/
		public function set labelTime3(value:Label):void
		{
			_labelTime3 = value;
		}
		private var _labelTime4:Label;
		/**  时间描述4 **/
		public function get labelTime4():Label
		{
			return _labelTime4;
		}
		/** @private **/
		public function set labelTime4(value:Label):void
		{
			_labelTime4 = value;
		}
		private var _rewardCard0:ImageLoader;
		/**  奖励卡0 **/
		public function get rewardCard0():ImageLoader
		{
			return _rewardCard0;
		}
		/** @private **/
		public function set rewardCard0(value:ImageLoader):void
		{
			_rewardCard0 = value;
		}
		private var _rewardCard1:ImageLoader;
		/**  奖励卡1 **/
		public function get rewardCard1():ImageLoader
		{
			return _rewardCard1;
		}
		/** @private **/
		public function set rewardCard1(value:ImageLoader):void
		{
			_rewardCard1 = value;
		}
		private var _rewardCard2:ImageLoader;
		/**  奖励卡2 **/
		public function get rewardCard2():ImageLoader
		{
			return _rewardCard2;
		}
		/** @private **/
		public function set rewardCard2(value:ImageLoader):void
		{
			_rewardCard2 = value;
		}
		private var _rewardCard3:ImageLoader;
		/**  奖励卡3 **/
		public function get rewardCard3():ImageLoader
		{
			return _rewardCard3;
		}
		/** @private **/
		public function set rewardCard3(value:ImageLoader):void
		{
			_rewardCard3 = value;
		}
		private var _rewardCard4:ImageLoader;
		/**  奖励卡4 **/
		public function get rewardCard4():ImageLoader
		{
			return _rewardCard4;
		}
		/** @private **/
		public function set rewardCard4(value:ImageLoader):void
		{
			_rewardCard4 = value;
		}
		private var _btnReceiveAll:Button;
		/**  一键领取 **/
		public function get btnReceiveAll():Button
		{
			return _btnReceiveAll;
		}
		/** @private **/
		public function set btnReceiveAll(value:Button):void
		{
			_btnReceiveAll = value;
		}

		
		/** 标题 **/
		private var _title:CJPanelTitle;
		/** 宝箱 **/
		private var _vecRewardCard:Vector.<CJOLRewardCard>;
		/** 当前计时的宝箱 **/
		private var _tickCard:CJOLRewardCard;
		
		/** 可领取的列表 **/
		private var _arrReceive:Array;
		
		private  var _explain:Label;
		
//		/** 宝箱tip **/
//		private var _tip:CJItemTooltip;
		
		public function CJOLRewardLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.width = ConstMainUI.MAPUNIT_WIDTH;
			this.height = ConstMainUI.MAPUNIT_HEIGHT;
			
			// 关闭按钮纹理
			btnClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new") );
			btnClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new") );
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJOLRewardModul");
			});
			
			// 标题
			_title = new CJPanelTitle( CJLang("ONLINE_REWARD_TITLE") );
			addChild(_title);
			_title.x = titlePos.x;
			_title.y = titlePos.y;
			
			// 层级
			var tierIndex:int = 0;
			// 底
			var texture:Texture = SApplication.assets.getTexture("common_dinew");
			var scale9Texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			var bg:Scale9Image = new Scale9Image(scale9Texture);
			bg.width = width;
			bg.height = height;
			bg.alpha = 0.3;
			addChildAt(bg , tierIndex++);
			
			// 绿色底框
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = imgBG.x;
			bg.y = imgBG.y;
			bg.width = imgBG.width;
			bg.height = imgBG.height;
			addChildAt(bg, tierIndex++);
			
			// 遮罩
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = imgBG.x+3;
			bg.y = imgBG.y+3;
			bg.width = imgBG.width-6;
			bg.height = imgBG.height-6;
			addChildAt(bg, tierIndex++);
			
			var frame:CJPanelFrame = new CJPanelFrame(imgBG.width-6, imgBG.height-6);
			frame.x = imgBG.x+3;
			frame.y = imgBG.y+3;
			frame.touchable = false;
			addChildAt(frame, tierIndex++);
			
			// 背景框
			texture = SApplication.assets.getTexture("common_waikuangnew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(15 , 15 , 1, 1));
			bg = new Scale9Image(scale9Texture);
			bg.x = imgBG.x;
			bg.y = imgBG.y;
			bg.width = imgBG.width;
			bg.height = imgBG.height;
			addChildAt(bg, tierIndex++);
			
			// 分割线
			var imgL:ImageLoader = new ImageLoader;
			imgL.source = SApplication.assets.getTexture("common_fengexian");
			imgL.x = imgBG.x + 10;
			imgL.y = imgBG.height - 30;
			imgL.width = imgBG.width - 20;
			addChild(imgL);
			
			_vecRewardCard = new Vector.<CJOLRewardCard>;
			for (var i:int=0; i<ConstOnlineReward.ConstMaxOnlineRewardCount; ++i)
			{
				var img:ImageLoader = this["rewardCard"+i] as ImageLoader;
				Assert( img!=null, "CJOLRewardLayer.initialize()  img==null");
				
				var card:CJOLRewardCard = new CJOLRewardCard( img.width, img.height );
				card.index = i;
				card.x = img.x;
				card.y = img.y;
				addChild(card);
				_vecRewardCard.push(card);
				
				// 设置标题
				var label:Label = this["labelTime"+i] as Label;
				label.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
				label.text = CJLang("ONLINE_REWARD_TITLE"+(i+1));
			}
			
//			_tip = new CJItemTooltip();
			
//			// 一键领取
//			btnReceiveAll.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniuda01new") );
//			btnReceiveAll.downSkin = new SImage( SApplication.assets.getTexture("common_anniuda02new") );
//			btnReceiveAll.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniuda02new") );
//			btnReceiveAll.defaultLabelProperties.textFormat = ConstTextFormat.smallTitleformat;
//			btnReceiveAll.label = CJLang("ONLINE_REWARD_RECEIVE_ALL");
//			btnReceiveAll.addEventListener(Event.TRIGGERED, _receiveAll);
//			addChild(btnReceiveAll);
			
			_explain = new Label;
			_explain.x = 0;
			_explain.y = btnReceiveAll.y;
			_explain.width = ConstMainUI.MAPUNIT_WIDTH;
			_explain.height = 12;
			addChild(_explain);
			_explain.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			_explain.text = CJLang("ONLINE_REWARD_EXPLAIN");//"每天累计在线一段时间后，即可领取丰厚大礼";
			
			
			// 刷新界面
			if (CJDataManager.o.DataOfOLReward.isLoadFromRemote())
				// 需要从远程获取下载
				CJDataManager.o.DataOfOLReward.loadFromRemote();
			else
				_updateLayer();
			
		}
		
//		override public function dispose():void
//		{
//			if ( null != _tip ) _tip.removeFromParent(true);
//		}
		
		/** 添加所有监听 **/
		public function addAllListener():void
		{
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_OLREWARD_GET_INFO, _getInfo);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_OLREWARD_ACTIVATE, _activate);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_OLREWARD_GET_REWARD, _getReward);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_OLREWARD_TICK, _advanceTime);
			
			addEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		
		/** 移除所有监听 **/
		public function removeAllListener():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_OLREWARD_GET_INFO, _getInfo);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_OLREWARD_ACTIVATE, _activate);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_OLREWARD_GET_REWARD, _getReward);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_OLREWARD_TICK, _advanceTime);
			
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		
		/**
		 * 每隔一段时间添加一次
		 * @param time
		 */
		private function _advanceTime():void
		{
			if (_tickCard != null)
				_tickCard.updateTime();
		}
		
		/** 更新面板 **/
		private function _updateLayer():void
		{
			// 在线奖励
			var dataofOLReward:CJDataOfOLReward = CJDataManager.o.DataOfOLReward;
			// 激活的最大索引 0为均未激活
			var index:int = int(dataofOLReward.rewardid);
			// 已经去的礼包list
			var arr:Array = dataofOLReward.receiverewardlist;
			
			_tickCard = null;
			
			_arrReceive = new Array;
			btnReceiveAll.isEnabled = false;
			for (var i:int=0; i<ConstOnlineReward.ConstMaxOnlineRewardCount; ++i)
			{
				// card状态默认为未领取
				var card:CJOLRewardCard = _vecRewardCard[i];
				
				if (i < index && -1==arr.indexOf(String(i+1)) ) // 可领取
				{
					card.setState(CJOLRewardCard.STATE_RECEIVE);
					_arrReceive.push(String(i+1));
					btnReceiveAll.isEnabled = true;
				}
				else if ( i<index && -1!=arr.indexOf(String(i+1)) ) // 已领取
				{
					card.setState(CJOLRewardCard.STATE_HAVE_RECEIVE);
				}
				else if (index == i) // 倒计时的card
				{
					card.setState(CJOLRewardCard.STATE_COUNTDOWN);
					_tickCard = card; // 记录当前计时的礼包
				}
				else // 未满足条件
				{
					card.setState(CJOLRewardCard.STATE_NOT_CONTENT);
				}
				
			}
		}
		
		/** 全部领取 **/
		private function _receiveAll(e:*):void
		{
			for(var i:uint=0; i<_arrReceive.length; ++i)
			{
				var id:String = _arrReceive[i];
				SocketCommand_onlineReward.get_reward(id);
			}
		}
		
		/** 获取完成 **/
		private function _getInfo(e:Event):void
		{
			_updateLayer();
		}
		
		/** 激活完成 **/
		private function _activate(e:Event):void
		{
			_updateLayer();
		}
		/** 选择领奖 **/
		private function _getReward(e:Event):void
		{
			_updateLayer();			
			var templateid:uint = uint(e.data["templateid"]);
			var desc:String = CJDataOfItemProperty.o.getTemplate(templateid).description;
			_showPiaozi(CJLang(desc));
		}	
		
		private function _showPiaozi(str:String):void
		{
			var seccessLabel:Label = new Label();
			seccessLabel.text = str;
			seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			seccessLabel.x = 0;
			seccessLabel.y = (SApplicationConfig.o.stageHeight - seccessLabel.height) / 2 - this.y;
			seccessLabel.width = SApplicationConfig.o.stageWidth;
			var textTween:STween = new STween(seccessLabel, 2, Transitions.LINEAR);
			textTween.moveTo(seccessLabel.x, seccessLabel.y- 50);
			
			textTween.onComplete = function():void
			{
				Starling.juggler.remove(textTween);
				seccessLabel.removeFromParent(true);
			}
			this.addChild(seccessLabel);
			
			Starling.juggler.add(textTween);
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
				// 判断位置
				for (var i:int=0; i<ConstOnlineReward.ConstMaxOnlineRewardCount; ++i)
				{
					// card状态默认为未领取
					var card:CJOLRewardCard = _vecRewardCard[i];
					if (_hitTest(touch.globalX, touch.globalY, card.x+8, card.y+19, 52, 52))
					{
						var json:Json_online_reward_setting = CJDataOfOLRewardProperty.o.getData(String(i+1));
						Assert( json!=null, "CJOLRewardLayer._touchHandler(), json==null")
//						var _tip:CJItemTooltip = new CJItemTooltip();
//						_tip.setItemTemplateIdAndRefresh(uint(json.giftbagid));
//						CJLayerManager.o.addModuleLayer(_tip);
						CJItemUtil.showItemTooltipsWithTemplateId(uint(json.giftbagid));
						return;
					}
				}
			}
		}
		
		
		/**
		 * 判断是否能点中目标
		 * @param hitX		点击位置x
		 * @param hitY		点击位置y
		 * @param testX		目标x
		 * @param testY		目标x
		 * @param testW		目标宽度
		 * @param testH		目标高度
		 * @return 			是否点中目标
		 * 
		 */
		private function _hitTest(hitX:Number, hitY:Number, testX:Number, testY:Number, testW:Number, testH:Number):Boolean
		{
			if(hitX >= testX && hitY >= testY && hitX <= testX+testW && hitY <= testY+testH)
				return true;
			return false;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}