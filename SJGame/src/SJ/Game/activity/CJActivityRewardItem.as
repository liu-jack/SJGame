package SJ.Game.activity
{
	import SJ.Game.SocketServer.SocketCommand_activity;
	import SJ.Game.bag.CJItemTooltip;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfActivityRewardPropertyList;
	import SJ.Game.data.json.Json_activity_reward_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 奖励item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-9 下午4:02:42  
	 +------------------------------------------------------------------------------
	 */
	public class CJActivityRewardItem extends SLayer
	{
		private var _boxicon:ImageLoader;
		private var _scoreicon:ImageLoader;
		private var _addPoint:Point = new Point(50 , 51);
		private var _status:int = 0;
		private var _index:int = 1;
		
		public function CJActivityRewardItem()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_boxicon = new ImageLoader();
			_scoreicon = new ImageLoader();
			_scoreicon.x = 0;
			_scoreicon.y = 51;
			this.addChild(_boxicon);
			this.addChild(_scoreicon);
			this.addEventListener(TouchEvent.TOUCH , this._onTouch);
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				var rewardConfig:Json_activity_reward_setting = CJDataOfActivityRewardPropertyList.o.getConfigById(this._index);
				if(this._status == CJActivityEventKey.ACTIVITY_CAN_NOT_REWARD)
				{
					var tooltipLayer:CJItemTooltip = new CJItemTooltip();
					tooltipLayer.setItemTemplateIdAndRefresh(rewardConfig.rewardid);
//					CJLayerManager.o.addToModal(tooltipLayer);
					CJLayerManager.o.addToModalLayerFadein(tooltipLayer);
				}
				else if(this._status == CJActivityEventKey.ACTIVITY_REWARDED)
				{
					new CJTaskFlowString(CJLang('activity_fail')).addToLayer();
				}
				else
				{
					//检测背包是否足够
					var addItemData:Array = new Array();
					if(!rewardConfig)
					{
						new CJTaskFlowString(CJLang('activity_fail1')).addToLayer();
						return;
					}
					addItemData.push({'id':rewardConfig.rewardid , 'count':1});
					if(!CJItemUtil.canPutItemsInBag(CJDataManager.o.DataOfBag , addItemData))
					{
						new CJTaskFlowString(CJLang('activity_full')).addToLayer();
						return ;
					}
					SocketCommand_activity.getActivityReward(this._index);
				}
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			//画宝箱
			this._refreshBox();
			//画底下的文字
			this._refreshLabel();
		}
		
		private function _refreshLabel():void
		{
			_scoreicon.source = SApplication.assets.getTexture("huoyuedu_huoyue"+index*25);
		}
		
		private function _refreshBox():void
		{
			var sourceName:String = "";
			switch(_status)
			{
				case 0:sourceName = "huoyuedu_baoxiang03";break;
				case 1:sourceName = "huoyuedu_baoxiang02";break;
				case 2:sourceName = "huoyuedu_baoxiang01";break;
				default:sourceName = "huoyuedu_baoxiang03";
			}
			
			var source:Texture = SApplication.assets.getTexture(sourceName);
			_boxicon.source = source;
			 var region:Rectangle = SApplication.assets.getTextureAtlas("resourceui_commonnew0").getRegion(sourceName);
			
			_boxicon.pivotX = region.width - source.frame.x;
			_boxicon.pivotY = region.height - source.frame.y;
			_boxicon.x = _addPoint.x;
			_boxicon.y = _addPoint.y;
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			if(_status == value)
			{
				return;
			}
			_status = value;
			this.invalidate();
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			if(value <= 0)
			{
				return 
			}
			_index = value;
			this.invalidate();
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener(TouchEvent.TOUCH , this._onTouch);
		}
	}
}