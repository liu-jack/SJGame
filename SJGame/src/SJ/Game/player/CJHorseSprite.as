package SJ.Game.player
{
	import SJ.Common.Constants.ConstHorse;
	import SJ.Game.data.json.Json_horsebaseinfo;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	
	import engine_starling.display.SAnimate;
	import engine_starling.display.SNode;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	
	import starling.animation.Juggler;
	import starling.core.Starling;

	/**
	 * 坐骑类
	 * @author caihua
	 * 
	 */
	public class CJHorseSprite extends SNode
	{
		/**
		 * 构造 
		 * @param horseid 坐骑模板类id
		 * @param _juggler =null 为全局_juggler类
		 * 
		 */
		public function CJHorseSprite(horseid:int,_juggler:Juggler = null)
		{
			if(_juggler == null)
			{
				_juggler = Starling.juggler;
			}
			this._juggler = _juggler;
			this._horseId = horseid;
			
			_horseResouceGroupName = "horse_resource_" + int(Math.random() * 100000)
		}
		
		private var _juggler:Juggler;
		
		override protected function initialize():void
		{
//					var imageOfLocal:Image = new SImage(Texture.fromColor(2,2,0xFF00FF00),true);
//					this.addChild(imageOfLocal);

			
			_loadResource();
			
			
			super.initialize();
		}
		
		
		override public function dispose():void
		{
			
			super.dispose();
			
			_disposehorseResource();
			
		}
		
		private var _horseId:int = 0;
		
		private var _horseResouceGroupName:String;
		
		/**
		 * 骑乘动画,待机 
		 */
		private var _ride_idle_anims:SAnimate = null;
		/**
		 * 骑乘动画,跑动 
		 */
		private var _ride_run_anims:SAnimate = null;
		
		private static const STATE_IDLE:int = 0;
		private static const STATE_RUN:int = 1;
		
		private var _state:int = STATE_IDLE;
		
		private function get _resourceLoaded():Boolean
		{
			if(_ride_run_anims != null && _ride_idle_anims != null)
			{
				return true;
			}
			return false;
		}
		
		private function _disposehorseResource():void
		{
			if(_resourceLoaded)
			{
				_ride_idle_anims.removeFromJuggler();
				_ride_idle_anims.removeFromParent(true);
				_ride_idle_anims = null;
			
				_ride_run_anims.removeFromParent(true);
				_ride_run_anims.removeFromJuggler();
				_ride_idle_anims = null;
			
				AssetManagerUtil.o.disposeAssetsByGroup(_horseResouceGroupName);
			}
		}
		
		
		private function _loadResource():void
		{
			if(_resourceLoaded)
			{
				_disposehorseResource();
			}
			//加载坐骑资源
			var housetemplate:Json_horsebaseinfo= ConstHorse.getHorseBaseInfoWithHorseID(_horseId);
			var resourceString:String = null;
			
//			resourceString = SStringUtils.format("resource_ride_{0}.xml",housetemplate.resourcename);
			resourceString = housetemplate.resourcetexturename;
			AssetManagerUtil.o.loadPrepareInQueue(_horseResouceGroupName,resourceString);
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				if(r == 1)
				{
					if(isDispose)
					{
						AssetManagerUtil.o.disposeAssetsByGroup(_horseResouceGroupName);
						
					}
					else
					{
						//设置坐骑待机和跑动动画
						//资源加载结束
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_HORSE_LOAD_COMPLETE);
						
						var animObject:Object = AssetManagerUtil.o.getObject("anim_" + housetemplate.resourcename + "_rideidle");
						_ride_idle_anims = SAnimate.SAnimateFromAnimJsonObject(animObject);
						
						animObject = AssetManagerUtil.o.getObject("anim_" + housetemplate.resourcename + "_riderun");
						_ride_run_anims = SAnimate.SAnimateFromAnimJsonObject(animObject);
						
						_playerMovie();
					}
				}
				
			});
		}
				
		
		
		private function _playerMovie():void
		{
			if(_ride_run_anims != null && _ride_idle_anims != null)
			{
				_ride_idle_anims.removeFromJuggler();
				_ride_idle_anims.removeFromParent();
				
				_ride_run_anims.removeFromParent();
				_ride_run_anims.removeFromJuggler();
				
				if(_state == STATE_IDLE)
				{
					addChild(_ride_idle_anims);
					_juggler.add(_ride_idle_anims);
					_ride_idle_anims.gotoAndPlay();
				}
				else if(_state == STATE_RUN)
				{
					addChild(_ride_run_anims);
					_juggler.add(_ride_run_anims);
					_ride_run_anims.gotoAndPlay();
				}
			}
		}
		public function idle():void
		{
			if(_state == STATE_IDLE)
			{
				return;
			}
			_state = STATE_IDLE;
			_playerMovie();
		}
		public function run():void
		{
			if(_state == STATE_RUN)
			{
				return;
			}
			_state = STATE_RUN;
			_playerMovie();
		}

		/**
		 * 坐骑模板ID 
		 */
		public function get horseId():int
		{
			return _horseId;
		}


		
	}
	
}