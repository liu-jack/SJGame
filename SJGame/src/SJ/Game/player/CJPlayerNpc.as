package SJ.Game.player
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.getTimer;
	
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Common.Constants.ConstPlayerAnims;
	import SJ.Common.Constants.ConstPlayerState;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstSkill;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.controls.CJHorseUtil;
	import SJ.Game.controls.CJSAnimateFrameScript;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.map.CJBattleMapManager;
	import SJ.Game.map.MapLayer;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.AnimateEvent;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SAtlasLabel;
	import engine_starling.stateMachine.StateMachineEvent;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SBitSet;
	import engine_starling.utils.SStringUtils;
	import engine_starling.utils.STween;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.core.PopUpManager;
	
	import lib.engine.math.Vector2D;
	import lib.engine.utils.CTimerUtils;
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class CJPlayerNpc extends CJPlayerBase
	{
		
		protected var _npcAnimname:String;
		protected var _npcTextureName:String;
		/**
		 * NPC资源随机名称 
		 */		
		private var _npcResGroupName:String;
		
		protected var _imageOfShadow:Image;
		
		protected var _npcId:String = "defalut";
		
		private var _logger:Logger;
		
		private var _playerData:CJPlayerData;
		private var _shadowImage:Image;
		private var _animguangquan:SAnimate;
		
		private var _bloadResourceAysnc:Boolean;
	
		/**
		 * 用户信息层,主要是血条什么的东西 
		 */
		private var _playerInfoLayer:CJPlayerInfoLayer;

		public function get playerData():CJPlayerData
		{
			return _playerData;
		}

		/**
		 * NPC的唯一索引,同时设置元件的name 
		 */
		public function get npcId():String
		{
			return _npcId;
		}

		/**
		 * @private
		 */
		public function set npcId(value:String):void
		{
			name = value;
			_npcId = value;
		}
		
		/**
		 * LOD等级 0 只包含最小贴图 sceneidle 半身像
		 */
		public static const LEVEL_LOD_0:int = 1;
		
		/**
		 * LOD 等级1 idle,run rideidle riderun 
		 */		
		public static const LEVEL_LOD_1:int = 1<<1;
		
		/**
		 * LOD2 等级2 包含战斗相关的资源 
		 */
		public static const LEVEL_LOD_2:int = 1<<2;
		/**
		 * LOD All 包含所有贴图.默认是这个 
		 */
		public static const LEVEL_LOD_ALL:int = 0xFFFFFFF;
		
		private var _lodlevel:SBitSet = new SBitSet(LEVEL_LOD_ALL);
		
		/**
		 * Npc类 
		 * @param data NPC数据
		 * @param jugger 定时器
		 * @param async true 异步加载 false 同步加载
		 */
		public function CJPlayerNpc(data:CJPlayerData,jugger:Juggler,async:Boolean = true)
		{
			super();
			
			_loadingNode.visible = async;
			_playerData = data;
			_npcAnimname = data.playerAnim;
			_npcTextureName = data.playerTextureName;
			_npcResGroupName = "npc_resource_" + _npcAnimname +CTimerUtils.getCurrentTime() +""+ int(Math.random() * 100000)
//			_jugger = SApplication.juggler;
			_jugger = new Juggler();
			SApplication.juggler.add(_jugger);
			
			_logger = Logger.getInstance(CJPlayerNpc);
			_PlayerTitleLayer.displayname = data.displayName;
			_PlayerTitleLayer.isNpc = !data.isPlayer;
			_PlayerTitleLayer.juggler = _jugger;
			showTitle(CJPlayerTitleLayer.TITLETYPE_NAME);
		}
		
		

		
		override protected function initialize():void
		{
			_playerInfoLayer = new CJPlayerInfoLayer(this);
			_PlayerBattleUINode.addChild(_playerInfoLayer);
			super.initialize();
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			if(isDispose)
			{
				return;
			}
			AssetManagerUtil.o.disposeAssetsByGroup(_npcResGroupName);
			CJDataManager.o.DataOfHorse.removeEventListener(DataEvent.DataChange,_changeRideState);
			canAutoRide = false;
			if(_animguangquan != null)
			{
				_animguangquan.removeFromJuggler();
			}
			
			if(_runtween != null)
			{
				_runtween.reset(this,0);
				_jugger.remove(_runtween);
				_runtween = null;
			}
			
			closeBattleTips();
			
			
			_playerData = null;
			_npcAnimname = null;
			SApplication.juggler.remove(_jugger);
			_jugger.purge();
			_jugger = null;
			
			
			super.dispose();
		}
		
		/**
		 * 升级特效
		 */		
		public function showUplevelAnims():void
		{
			var anim:SAnimate = new SAnimate(SApplication.assets.getTextures(ConstResource.sResUplevelAnims))
			if(!anim)
			{
				return;
			}
			anim.scaleX = anim.scaleY = 1.3;
			anim.pivotY = 110;
			anim.pivotX = 80;
			if(_jugger)
			{
				_jugger.add(anim);
			}
			else
			{
				Starling.juggler.add(anim);
			}
			this._frontNode.addChild(anim);
			anim.loop = false;
			anim.addEventListener(Event.COMPLETE , function(e:Event):void
			{
				if(e.target is SAnimate)
				{
					_removeUplevelAnims(e.target as SAnimate);
				}
			});
		}
		
		private function _removeUplevelAnims(anim:SAnimate):void
		{
			if(anim!= null)
			{
				anim.removeFromParent();
				anim.removeFromJuggler();
			}
		}
		public static function getLoadResourceListByTemplateId(templateid:int,LodLevel:int):Array
		{
			var resdata:CJPlayerData = new CJPlayerData();
			resdata.templateId = templateid;
			return getLoadResourceList(resdata,LodLevel);
		}
		/**
		 * 获取远程资源下载列表 
		 * @param _npcTextureName
		 * @param LodLevel
		 * @return 
		 * 
		 */
		public static function getLoadResourceList(playerData:CJPlayerData,LodLevel:int):Array
		{
			var _npcTextureName:String = playerData.playerTextureName;
			var resArr:Array = new Array();
			var resourcename:String = null;
			var _lodlevel:SBitSet = new SBitSet(LodLevel);
			if (_lodlevel.test(LEVEL_LOD_0))
			{
				resourcename = SStringUtils.format("resource_{0}_lod0.xml",_npcTextureName);
				if(AssetManagerUtil.o.hasObjectInRemoteResource(resourcename))
				{
					resArr.push(resourcename);
				}
				
				
			}
			
			if(_lodlevel.test(LEVEL_LOD_1))
			{
				resourcename = SStringUtils.format("resource_{0}_lod1.xml",_npcTextureName);
				if(AssetManagerUtil.o.hasObjectInRemoteResource(resourcename))
				{
					resArr.push(resourcename);
				}
			}
			
			if(_lodlevel.test(LEVEL_LOD_2))
			{
				for (var i:int = 0;i<int(playerData.heroBattleConfig.texturecount);i++)
				{
					resourcename = SStringUtils.format("resource_{0}_{1}.xml",_npcTextureName,i);
					if(AssetManagerUtil.o.hasObjectInRemoteResource(resourcename))
					{
						resArr.push(resourcename);
					}
				}
			}
			
			resourcename = SStringUtils.format("anim_{0}.anims",playerData.playerAnim);
			resArr.push(resourcename);
			
			resourcename = "anim_skillname.anims";
			resArr.push(resourcename);
			//加载通用的anims
			resArr.push("anim_common_hero.anims");
			//加载坐骑的anims
			resArr.push("anim_rides.anims");
			
			return resArr;
			
		}

		
		override protected function _loadResource():void
		{
			super._loadResource();
			
			//添加影子
			_shadowImage = new Image(SApplication.assets.getTexture("shadow"));
			_bgNode.addChild(_shadowImage);
			_shadowImage.pivotX = _shadowImage.width/2;
			_shadowImage.pivotY = _shadowImage.height / 2;
			

//			CONFIG::tech{
//					//位置辅助
//					var imageOfLocal:Image = new SImage(Texture.fromColor(2,2,0xFFFFFF00),true);
//					this._debugNode.addChild(imageOfLocal);
//			}
			var maskImage:Quad = new Quad(40,70,0xFF0000);
			maskImage.alpha = 0.01;
//			maskImage.height = 70;
//			var maskImage:SImage = new SImage(Texture.fromColor(40,70,0x01FF00FF),true)
			maskImage.pivotX = maskImage.width / 2;
			maskImage.pivotY = maskImage.height;
			this._touchNode.addChild(maskImage);
			
			//加载资源
			var resourceString:String = null;
			var resourceArray:Array = getLoadResourceList(_playerData,_lodlevel.toUint());
			
			//必须要加载的资源
			var nessloadres:Array = new Array();
			var length:int = resourceArray.length;
			_bloadResourceAysnc = false;
			for(var i:int=0;i<length;i++)
			{
				if(AssetManagerUtil.o.hasAsset(resourceArray[i]) == false)
				{
					_bloadResourceAysnc = true;
					break;
				}
			}
			_loadingNode.visible = _bloadResourceAysnc;
			if(_bloadResourceAysnc == false)
			{
				_loadResourceCompleted();
			}
				
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_npcResGroupName,resourceArray);
			AssetManagerUtil.o.loadQueue(function (r:Number):void
				{
					if(_bloadResourceAysnc && r==1 && isDispose == false)
					{
						_loadResourceCompleted();
					}
				});
			
		}
		private function _getResourceListByLodLevel():Array
		{
			var resArr:Array = new Array();
			var resourcename:String = null;
			if (_lodlevel.test(LEVEL_LOD_0))
			{
				resourcename = SStringUtils.format("resource_{0}_lod0.xml",_npcTextureName);
				if(AssetManagerUtil.o.hasObjectInRemoteResource(resourcename))
				{
					resArr.push(resourcename);
				}
				
			}
			
			if(_lodlevel.test(LEVEL_LOD_1))
			{
				resourcename = SStringUtils.format("resource_{0}_lod1.xml",_npcTextureName);
				if(AssetManagerUtil.o.hasObjectInRemoteResource(resourcename))
				{
					resArr.push(resourcename);
				}
			}
			
			if(_lodlevel.test(LEVEL_LOD_ALL))
			{
				for (var i:int = 0;i<int(_playerData.heroBattleConfig.texturecount);i++)
				{
					resourcename = SStringUtils.format("resource_{0}_{1}.xml",_npcTextureName,i);
					if(AssetManagerUtil.o.hasObjectInRemoteResource(resourcename))
					{
						resArr.push(resourcename);
					}
				}
			}
			
			return resArr;
			
		}
		
		override protected function _loadResourceCompleted():void
		{
			// TODO Auto Generated method stub
			//加载动画
			_loadAnim(ConstPlayerState.SConstPlayerStateIdle);
			_loadAnim(ConstPlayerState.SConstPlayerStateSceneIdle);
			_loadAnim(ConstPlayerState.SConstPlayerStateAttack);
			_loadAnim(ConstPlayerState.SConstPlayerStateRun);
			_loadAnim(ConstPlayerState.SConstPlayerStateSkill1);
			_loadAnim(ConstPlayerState.SConstPlayerStateSkillBegin);
			_loadAnim(ConstPlayerState.SConstPlayerStateSkill2);
			_loadAnim(ConstPlayerState.SConstPlayerStateUnderAttack);
			_loadAnim(ConstPlayerState.SConstPlayerStateWin);
			_loadAnim(ConstPlayerState.SConstPlayerStateLose);
			_loadAnim(ConstPlayerState.SConstPlayerStateDead);
			_loadAnim(ConstPlayerState.SConstPlayerStateShanIn);
			_loadAnim(ConstPlayerState.SConstPlayerStateShanOut);
			_loadAnim(ConstPlayerState.SConstPlayerStateAttackBegin);
//			
//			//主角骑乘动作
			_loadAnim(ConstPlayerState.SConstPlayerStateRideIdle);
			_loadAnim(ConstPlayerState.SConstPlayerStateRideRun);
			
			
			if(_playerData.super_hero)
			{
				var animObject:Object = AssetManagerUtil.o.getObject("anim_hero_wuxingeffect");
				_animguangquan = SAnimate.SAnimateFromAnimJsonObject(animObject);
				_jugger.add(_animguangquan);
				_animguangquan.gotoAndPlay();
				_frontNode.addChild(_animguangquan);
			}
			
			super._loadResourceCompleted();
		}
		
		/**
		 * 添加光圈	 
		 * 
		 */
		public function setGuangquan(enable:Boolean):void
		{
			if(_animguangquan != null)
			{
				_animguangquan.removeFromJuggler();
				_animguangquan.removeFromParent(true);
			}
			if(enable)
			{	
				var animObject:Object = AssetManagerUtil.o.getObject("anim_hero_wuxingeffect");
				_animguangquan = SAnimate.SAnimateFromAnimJsonObject(animObject);
				_jugger.add(_animguangquan);
				_animguangquan.gotoAndPlay();
				_frontNode.addChild(_animguangquan);
			}
		}
		
		/**
		 * 加载动画	 
		 * @param animName 动画名称
		 * 
		 */
		override protected function _loadAnim(animName:String):void
		{
			//下载远程资源
			
			var animObject:Object = AssetManagerUtil.o.getObject("anim_" + _npcAnimname + "_" + animName);
			if(animObject == null)
				return;
			var anim:SAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject,CJSAnimateFrameScript);
			if(anim != null)
			{
				_setMovie(animName,anim);
			}
		}
		
		override internal function _onstate_dead(e:StateMachineEvent):void
		{

			super._onstate_dead(e);
			this.currentMovieclip.addEventListener(Event.COMPLETE,function _e(e:Event):void
			{
				e.target.removeEventListener(e.type,_e);
				visible = false;
				
			});
		
		}
		private var _canAutoRide:Boolean = false;

		/**
		 * 是否可以通过监听骑乘变化事件骑乘 
		 */
		public function get canAutoRide():Boolean
		{
			return _canAutoRide;
		}

		/**
		 * @private
		 */
		public function set canAutoRide(value:Boolean):void
		{
			if(_canAutoRide == value)
			{
				return;
			}
			_canAutoRide = value;
			
			
			if(_canAutoRide == true)
			{
				CJDataManager.o.DataOfHorse.addEventListener(DataEvent.DataChange,_changeRideState);
				_flushridestate(CJDataManager.o.DataOfHorse.dic_baseInfo);
				
			}
			else
			{
				CJDataManager.o.DataOfHorse.removeEventListener(DataEvent.DataChange,_changeRideState);
			}
			
			
		}
		/**
		 * 刷新骑乘状态 
		 * @param state CJDataManager.o.DataOfHorse.dic_baseInfo
		 * 
		 */
		private function _flushridestate(state:Object):void
		{
			var isRide:int = state.isriding;
			if(isRide == 1)//骑乘中
			{
				RideId = state.activehorseid;
			}
			else
			{
				RideId = RIDE_ID_INVALID;
			}
			_speedAccRatio = CJHorseUtil.getAccelarateRatio(state.activehorseid);
		}
		
		private function _changeRideState(e:Event):void
		{
			if(e.data != null && e.data.key == "dic_baseinfo")
			{
				_flushridestate(e.data.value);
			}
		}
		

		/**
		 * 无效骑乘ID 
		 */
		public static const RIDE_ID_INVALID:int = -1;
		
		/**
		 * 骑乘ID 
		 */
		private var _RideId:int = RIDE_ID_INVALID;

		/**
		 * 是否骑乘 
		 */
		public function get RideId():int
		{
			return _RideId;
		}

		private var playerTitleLayeroldY:int = 0;
		private var CONST_RIDE_PLAYERTITLE_HEIGTH_OFFSET:int = -40;
		private var _horseSprite:CJHorseSprite;
		
		/**
		 * @private
		 */
		public function set RideId(value:int):void
		{
			if(_RideId == value)
			{
				return;
			}
			_RideId = value;
			
			if(_RideId != RIDE_ID_INVALID)
			{
				if(_horseSprite != null && _horseSprite.horseId != _RideId)
				{
					_horseSprite.removeFromParent(true);
					_horseSprite = null;
				}
				_load_rideanims();
				_speedAccRatio = CJHorseUtil.getAccelarateRatio(_horseSprite.horseId);
				if(playerTitleLayeroldY == 0)
				{
					playerTitleLayeroldY = _PlayerTitleLayer.y;
				}
				_PlayerTitleLayer.y = playerTitleLayeroldY + CONST_RIDE_PLAYERTITLE_HEIGTH_OFFSET;
			}
			else
			{
				_clear_rideanims();
				_PlayerTitleLayer.y = playerTitleLayeroldY;
				_speedAccRatio = 0;
			}
			idle();
		}
		
		/**
		 * 是否在骑乘中 
		 * @return 
		 * 
		 */		
		public function get isRiding():Boolean
		{
			return _RideId != RIDE_ID_INVALID;
		}
		
		/**
		 * 加载跑动动画 
		 * 
		 */
		private function _load_rideanims():void
		{
			if(_horseSprite == null)
			{
				_horseSprite = new CJHorseSprite(_RideId , _jugger);
				_rideNode.addChild(_horseSprite);
			}
			_horseSprite.visible = true;
			
		}
		
		/**
		 * 清空跑动动画 
		 * 
		 */
		private function _clear_rideanims():void{
			if(_horseSprite)
			{
				_horseSprite.visible = false;
			}
		}
		
		override internal function _onstate_rideidle(e:StateMachineEvent):void
		{
			
			super._onstate_rideidle(e);
			if(_horseSprite != null)
			{
				_horseSprite.idle();
			}
		}
		
		override internal function _onstate_riderun(e:StateMachineEvent):void
		{
			
			super._onstate_riderun(e);
			if(_horseSprite != null)
			{
				_horseSprite.run();
			}
		}
		


		
		public function npcSkill(d_playerdata:CJBattlePlayerData,d_player:CJPlayerNpc,skillData:Object,onfinish:Function = null):void
		{
			_params = {"d_playerdata":d_playerdata,"d_player":d_player,"skillData":skillData,"onfinish":onfinish};
			_smc.changeState(ConstPlayerState.SConstPlayerStateSkillBegin);
			
		}

		
		
		
		/**
		 * 技术技能 
		 * 
		 */
		private function _endSkill():void
		{
			_playerInfoLayer.visible = true;
			_shadowImage.visible = true;
			_skillanimFront = null;
			_bSkilling = false;
			//去除遮罩
			//zhengzheng ++
			if(_showSkillBackground)
			{
				_showSkillBackground = false;
				CJBattleMapManager.o.skillmaskLayer.popActive();
			}
			if(_animguangquan != null)
			{
				_animguangquan.visible = true;
			}
		}
		
		
		/**
		 * 目标身上的技能Buff 
		 * @param skillData
		 * @param _onFinish
		 * 
		 */
		protected function _execNpcTargetSkill(skillData:Object,targetPlayer:Vector.<CJPlayerNpc>,_onFinish:Function = null):void
		{
			var skillAnimName:String = skillData["skilltargetanim"];
			var anim:Object = null;
			var anims:SAnimate = null;
			if(!SStringUtils.isEmpty(skillAnimName))
			{
				anim = AssetManagerUtil.o.getObject(skillAnimName);
				anims = SAnimate.SAnimateFromAnimJsonObject(anim);
			}
			else	//不需要 则返回
			{
				return;
			}
			
			var length:int = targetPlayer.length;
			for(var i:int=0;i<length;i++)
			{
				
				var player:CJPlayerNpc = targetPlayer[i];
				anims = SAnimate.SAnimateFromAnimJsonObject(anim);
				anims.loop = false;
				anims.gotoAndPlay();
				
				player.addChild(anims);
				anims.data = player;
				anims.addEventListener(Event.COMPLETE,function(e:Event):void
				{
					try
					{
						(e.currentTarget as SAnimate).removeFromParent();
						_jugger.remove(e.currentTarget as SAnimate);
					}
					catch(e:Error)
					{
						
					}
				});
				_jugger.add(anims);
				
			}

				
				
		}
		
		
		
		protected function _execPlayerSkill(skillData:Object):void
		{
			
			//			"skillData"	Object (@5695329)	
			//			skillattacknum	"3"	
			//			skill_e0	"2"	
			//			skillendanim	"anim_skill_baofengxueeffect"	
			//			skill_ev0	"1000"	
			//			skillicon	"icon_0004"	
			//			skillid	"1"	
			//			skillname	""	
			//			skillstartanim	"anim_skill_huifu"	
			//			skilltargetnum	"0"	
			//			skilltargettype	"1"	
			//			skilltype	"1"	
			var skilltype:int = skillData["skilltype"];
			var skillTargetType:int = skillData["skilltargettype"];
			var skillTargetNum:int = skillData["skilltargetnum"];
			var skillStartAnimName:String = skillData["skillstartanim"];
			
			//设置播放起手动作
			var anim:Object = AssetManagerUtil.o.getObject(skillStartAnimName);
			var anims:SAnimate = SAnimate.SAnimateFromAnimJsonObject(anim);
			_setMovie(ConstPlayerState.SConstPlayerStateSkill1,anims);
			
			
		}
		protected function _execPlayerSkillMid(skillData:Object):void
		{
			var skillStartAnimName:String = skillData["skillduringanim"];
			
			if(SStringUtils.isEmpty(skillStartAnimName))
			{
				_execNpcSkillEnd(skillData);
			}
			else
			{
				Assert(false,"目前没有设计技能中间特效");
			}
		}
		
		
		
		override internal function _onstate_attack(e:StateMachineEvent):void
		{
			super._onstate_attack(e);
		}
		
		/**
		 *  改变血量 
		 * @param type ConstPlayer.SConstPlayerAttackTypeNormal
		 * @param hpchangevalue 变化值
		 * @param hpfinalvalue 血量最终值
		 * @param reduce 是否是掉血
		 * @param isblood 是否为吸血
		 * @param _onfinish 结束
		 * 
		 */
		protected function _changeHp(type:String,hpchangevalue:uint
									 ,hpfinalvalue:uint,reduce:Boolean = true,isblood:Boolean = false,_onfinish:Function = null):void
		{
			var hpChangeLabel:SAtlasLabel = new SAtlasLabel();
			hpChangeLabel.hAlign = HAlign.CENTER;
			var hpchangeflag:String = "-";
			
//			if(playerData.hp == hpfinalvalue)
//			{
//				if(_onfinish != null)
//					_onfinish();
//				return;
//			}
//			type = ConstPlayer.SConstPlayerAttackTypeNormal;
			if(reduce)
			{
				if(type == ConstPlayer.SConstPlayerAttackTypeNormal)
				{
					hpChangeLabel.registerChars("+-0123456789","zhandouwenzi_shanghai",SApplication.assets);
					hpChangeLabel.space_x = -1;
				}
				else
				{
					hpChangeLabel.registerChars("+-0123456789","zhandouwenzi_baoji",SApplication.assets);
					hpChangeLabel.space_x = 0;
				}
			}
			else
			{
				if(type == ConstPlayer.SConstPlayerAttackTypeNormal)
				{
					hpChangeLabel.registerChars("+-0123456789","zhandouwenzi_jiaxue",SApplication.assets);
					hpChangeLabel.space_x = -1;
					hpchangeflag = "+";
				}
				else
				{
					hpChangeLabel.registerChars("+-0123456789","zhandouwenzi_jiaxue",SApplication.assets);
					hpChangeLabel.space_x = 0;
					hpchangeflag = "+";
				}
			}
			
			playerData.hp = hpfinalvalue;
			//peng.zhi ++
			//增加字体间距
			
			hpChangeLabel.text = hpchangeflag + hpchangevalue + "";
//			hpChangeLabel.scaleX = hpChangeLabel.scaleY = 0.5;
			CJBattleMapManager.o.scoreLayer.addChild(hpChangeLabel);
		
			
			var offsetx:int = int(_playerData.heroBattleConfig.shuzix);
			var offsety:int = int(_playerData.heroBattleConfig.shuziy);
			
			hpChangeLabel.x = x + scaleX * offsetx;
			hpChangeLabel.y = y + offsety;
			

			
//			var helpPoint:Quad = new Quad(2,2,0xFFFF00);
//			helpPoint.x = hpChangeLabel.x;
//			helpPoint.y = hpChangeLabel.y;
//			CJBattleMapManager.o.scoreLayer.addChild(helpPoint);
			//修正技能中的数字显示位置
			//fix peng.zhi 
			//目前只修正加血
			if(_bSkilling && reduce == false && isblood)
			{
				var sAnimate:SAnimate = _getMoive(ConstPlayerState.SConstPlayerStateSkill1)
				if(sAnimate != null && sAnimate.isComplete && _skillanimFront!= null) //起手动画播放完毕了.我们可以认为是那种自己隐藏的技能
				{
					
					//镜像位置 
					hpChangeLabel.x = _skillanimFront.x - _skillanimFront.pivotX+ scaleX * offsetx; 
					hpChangeLabel.y = _skillanimFront.y + offsety;
					if(!_playerData.isSelf)
					{
						var lpos:Point = CJBattleMapManager.o.skillBackLayer.otherSkillLayer.localToGlobal(new Point(hpChangeLabel.x,hpChangeLabel.y));
						hpChangeLabel.x  = lpos.x;
					}
					
				}
			}
			
//			hpChangeLabel.x -= 30;
//			hpChangeLabel.x += (Math.random() * 30.0);
//			
//			hpChangeLabel.y -= 15;
//			hpChangeLabel.y += (Math.random() * 15.0);
			
			
			var textTween:STween = null;
			//文字帧频
			var txtfps:Number = 30;
			var offset1:int = -15;
			var offset2:int = -40;
			var offset3:int = -44;
			
			var fps1:int = 13;
			var fps2:int = 20;
			var fps3:int = 6;
			
			if(type == ConstPlayer.SConstPlayerAttackTypeNormal)
			{
//				fps1 = 5;
//				fps2 = 16;
//				fps3 = 6;
//				offset1 = -10;
//				offset2 = -27;
//				offset3 = -30;
				//正常放大
				var sScaleTween:STween = new STween(hpChangeLabel,6/txtfps);
				sScaleTween.animate("scaleX",2.0);
				sScaleTween.animate("scaleY",2.0);
				
				
				sScaleTween.nextTween  = new STween(hpChangeLabel,4/txtfps);
				sScaleTween.nextTween.animate("scaleX",1.0);
				sScaleTween.nextTween.animate("scaleY",1.0);
				_jugger.add(sScaleTween);
			}
				
			else
			{
				
//				offset1 = -20;
//				offset2 = -33;
//				offset3 = -35;
//				fps1 = 14;
//				fps2 = 15;
//				fps3 = 6;
				
				
				//暴击放大
				var sScaleTween:STween = new STween(hpChangeLabel,6/txtfps);
				sScaleTween.animate("scaleX",2.0);
				sScaleTween.animate("scaleY",2.0);
				
				
				sScaleTween.nextTween  = new STween(hpChangeLabel,4/txtfps);
				sScaleTween.nextTween.animate("scaleX",1.0);
				sScaleTween.nextTween.animate("scaleY",1.0);
				_jugger.add(sScaleTween);
				
			}
			
			
			
			var smoveTween:STween = new STween(hpChangeLabel,fps1/txtfps);
			smoveTween.moveTo(hpChangeLabel.x,hpChangeLabel.y + offset1);
			
			var easeoutT:STween = new STween(hpChangeLabel,fps3/txtfps);
			easeoutT.moveTo(hpChangeLabel.x,hpChangeLabel.y + offset3);//69
			easeoutT.animate("alpha",0.001);
			easeoutT.onComplete = function():void
			{
				hpChangeLabel.removeFromParent();
				if(_onfinish != null)
					_onfinish();
			};
			
			
			smoveTween.nextTween = new STween(hpChangeLabel,fps2/txtfps);
			smoveTween.nextTween.moveTo(hpChangeLabel.x,hpChangeLabel.y + offset2);//63
			smoveTween.nextTween.nextTween = easeoutT;
		
			_jugger.add(smoveTween);
				
		}
		
		/**
		 * 躲闪基础位置 
		 * @return 
		 * 
		 */		
		private var _missbasex:Number = 0;
		private var _missanims:STween;
		private var _bshowmiss:Boolean = false;
		/**
		 * 显示miss 
		 * 
		 */
		private function _domissaction():void
		{
			if(_bshowmiss)
			{
				//冲断上一次移动
				_jugger.remove(_missanims);
				_missanims = null;
				//还原
				x = _missbasex;
			}
			else
			{
				_missbasex = x;
			}
			
			_bshowmiss = true;
			_missanims = new STween(this,6/30.0,Transitions.EASE_OUT);
			_missanims.moveTo(x - scaleX * 10,y);
			_missanims.nextTween = new STween(this,6/30.0);
			_missanims.moveTo(x,y);
			_missanims.nextTween.onComplete = function():void{
				_bshowmiss = false;
				_missanims = null;
			}
			_jugger.add(_missanims);
			
			//添加躲闪特效
			var animObject:Object = AssetManagerUtil.o.getObject("anim_duoshaneffect");
			var anim:SAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject);
			anim.loop = false;
			_jugger.add(anim);
			
			var offsetx:int = int(_playerData.heroBattleConfig.missx);
			var offsety:int = int(_playerData.heroBattleConfig.missy);
			
			anim.x = x + offsetx * scaleX;
			anim.y = y + offsety;
			anim.gotoAndPlay();
			anim.addEventListener(Event.COMPLETE,function _e(e:Event):void
			{
				(e.target as SAnimate).removeFromJuggler();
				(e.target as SAnimate).removeFromParent(true);
				
			});
			CJBattleMapManager.o.scoreLayer.addChild(anim);
			
		}
		
		/**
		 * 显示暴击 
		 * 
		 */
		private function _doCrit():void
		{
//			CJBattleMapManager.o.rootMapLayer.shake(0,10,10,4/30.0);
			return;
			
			var animObject:Object = AssetManagerUtil.o.getObject("anim_baojieffect");
			var anim:SAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject);
			_jugger.add(anim);
			
			var offsetx:int = int(_playerData.heroBattleConfig.baojix);
			var offsety:int = int(_playerData.heroBattleConfig.baojiy);
			anim.x = x + offsetx * scaleX;
			anim.y = y + offsety;
			anim.gotoAndPlay();
			anim.addEventListener(Event.COMPLETE,function _e(e:Event):void
			{
				(e.target as SAnimate).removeFromJuggler();
				(e.target as SAnimate).removeFromParent(true);
			});
			CJBattleMapManager.o.scoreLayer.addChild(anim);
		}
		
		override public function underAttack(params:Object=null):void
		{
			idle();
			
			_params = params;
			var type:String = _params["type"];
			var hpchangevalue:uint = _params["hpchangevalue"];
			var hpfinalvalue:uint = _params["hpfinalvalue"];
			
			_changeHp(type,hpchangevalue,hpfinalvalue);
			
			_smc.changeState(ConstPlayerState.SConstPlayerStateUnderAttack);
		}
		
		
		override internal function _onstate_underAttack(e:StateMachineEvent):void
		{
			var type:String = _params["type"];
			var hpchangevalue:uint = _params["hpchangevalue"];
			var hpfinalvalue:uint = _params["hpfinalvalue"];
			super._onstate_underAttack(e);
			
			var effectduringtime:Number = _params["attackshaketime"];
//			currentMovieclip.setFrameDuration(currentMovieclip.currentFrame,effectduringtime);
			_shake(this,effectduringtime,currentMovieclip.fps);

			currentMovieclip.addEventListener(starling.events.Event.COMPLETE,function():void
			{
				if(playerData.hp <=0)
				{
					dead();
				}
				else
				{
					idle();
				}
			});	
		}
		private function _onShakeScreen(e:Event):void
		{
			var params:Array = (e.data as String).split(",");
			
			var shakecount:int = parseInt(params[0]);
			var shakeoffset:int = parseInt(params[1]);
			var shaketype:int = parseInt(params[2]);
			var shakefps:int = parseInt(params[3]);
			return;
			_shakeScreen(shakecount,shakefps,shaketype,shakeoffset);
		}
		/**
		 * 抖动屏幕 
		 * @param _shaketime
		 * @param _shakefps
		 * @param _shaketype
		 * @param _shakeoffset
		 * @return 
		 * 
		 */
		private function _shakeScreen(_shaketime:Number,_shakefps:Number,_shaketype:int = 1,_shakeoffset:int = 1):void
		{
			var t:Tween = new Tween(CJBattleMapManager.o.rootMapLayer,_shakefps/30);
			
			t.repeatCount = _shaketime;
			t.onRepeat = function():void
			{
				if(_shaketype == 0)
				{
					CJBattleMapManager.o.rootMapLayer.x = t.repeatCount % 2 == 0?_shakeoffset:(-1 * _shakeoffset);
				}
				else
				{
					CJBattleMapManager.o.rootMapLayer.y = t.repeatCount % 2 == 0?_shakeoffset:(-1 * _shakeoffset);
				}
				
			};
			t.onComplete = function():void
			{
				CJBattleMapManager.o.rootMapLayer.x = 0;
				CJBattleMapManager.o.rootMapLayer.y = 0;
			};
			
			_jugger.add(t);
			
		}
		/**
		 * 抖动 
		 * @param shakeobject 
		 * @param _shaketime 抖动时间
		 * @param _shaketype 抖动类型 0 上下 左右逗 1上下 2 左右
		 * @param _shakeoffset 抖动幅度
		 * 
		 */
		private function _shake(shakeobject:CJPlayerNpc,_shaketime:Number,_shakefps:Number,_shaketype:int = 1,_shakeoffset:int = 1):void
		{
			
			if(_shaketime == 0)
				return;
			
			shakeobject.needAutoSort = false;
			var basex:Number = shakeobject.x;
			var basey:Number = shakeobject.y;
			var t:STween = new STween(shakeobject,_shaketime);
			var _shakeaction:int = 0;
			if(_shaketype == 1)
			{
				_shakeaction = 0;
			}
			else
			{
				_shakeaction = 1;
			}
			var _shaketime:Number = getTimer() / 1000.0;
			
			
			t.onUpdate = function(player:CJPlayerNpc):void
			{
				//控制抖动的频率
				var _now:Number = getTimer() / 1000.0;
				if(_now - _shaketime > 1/_shakefps)
				{
					_shaketime += 1/_shakefps;
				}
				else
				{
					return;
				}
				
				//控制抖动的类型
				if(_shaketype == 0)
				{
					_shakeaction = int(Math.random() + 0.5);
				}
				
				//横向抖动
				if(_shakeaction == 0)
				{
					if(player.x >= basex)
					{
						player.x = basex -_shakeoffset;
					}
					else
					{
						player.x = basex + _shakeoffset;
					}
				}
				else//纵向抖动
				{
					
					if(player.y >= basey)
					{
						player.y = basey -_shakeoffset;
					}
					else
					{
						player.y = basey + _shakeoffset;
					}
				}
			};
			t.onUpdateArgs = [shakeobject];
			t.onComplete = function(player:CJPlayerNpc):void
			{
				player.x = basex;
				player.y = basey;
				shakeobject.needAutoSort = true;
				_jugger.remove(t);
			};
			t.onCompleteArgs =[shakeobject];
			
			_jugger.add(t);
		}
		

		/**
		 * 技能攻击 
		 * @param d_players 目标用户
		 * @param onfinish 完成事件
		 * @param params 服务器发来的JSON参数
		 * 
		 */
		public function skillAttack(d_players:Vector.<CJPlayerNpc>,onfinish:Function = null,params:Object = null):void
		{
			_params = {"d_players":d_players,"onfinish":onfinish,"params":params};
			var skillId:int = parseInt(params.skill);
			var skillConfig:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(skillId)  as Json_skill_setting;
			_params["skillData"] = skillConfig;
			_smc.changeState(ConstPlayerState.SConstPlayerStateSkillBegin);
		}
		
		private var _showSkillBackground:Boolean;
		override internal function _onstate_skillbegin(e:StateMachineEvent):void
		{
			// TODO Auto Generated method stub
			super._onstate_skillbegin(e);
			currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_SKILLNAMESOUND,
				function _onskillnamesound(e:Event):void
				{
					var skillnamesound:String = _params["skillData"]["skillsounds"];
					if(SStringUtils.isEmpty(skillnamesound) == false)
					{
						var soundObject:Object = AssetManagerUtil.o.getObject(skillnamesound);
						if(soundObject)
						{
							SSoundEffectUtil.playSoundEffect(soundObject as Sound);
						}
					}
				});
			currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_SKILLNAME,
				function _onskillname(e:Event):void
				{
					var skillid:String = _params["skillData"]["skillid"];
					var skillname:String = _params["skillData"]["skillnameanim"];
					var skillObject:Object = AssetManagerUtil.o.getObject(skillname);
					if(skillObject != null)
					{
						var animateskillname:SAnimate = SAnimate.SAnimateFromAnimJsonObject(skillObject);
						CJBattleMapManager.o.skillLayer.addChild(animateskillname);
						animateskillname.loop = false;
						
						var offsetx:int = int(_playerData.heroBattleConfig.skillnamex);
						var offsety:int = int(_playerData.heroBattleConfig.skillnamey);
						animateskillname.x = SApplicationConfig.o.stageWidth/2;
						animateskillname.y = SApplicationConfig.o.stageHeight/4;
						
						animateskillname.gotoAndPlay();
						_jugger.add(animateskillname);
						animateskillname.addEventListener(Event.COMPLETE,function(e:Event):void
						{
							(e.target as SAnimate).removeFromJuggler();
							(e.target as SAnimate).removeFromParent();
						});
					}
				});
			
			
			
			currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_ATTACKBEGINEFFECT,
				function _onskillstarteffect(e:Event):void
				{
					//boss施法特效和普通人施法特效
					var animString:String = _playerData.playerType == 2?"anim_shifatexiaoboss":"anim_shifatexiao";
					
					var animObject:Object = AssetManagerUtil.o.getObject(animString);
					var anims:SAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject);
					anims.gotoAndPlay();
					anims.addEventListener(Event.COMPLETE,function (e:*):void
					{
						anims.removeFromParent(true);
						anims.removeFromJuggler();
						
					});
					
					_animsNode.addChild(anims);
					_jugger.add(anims);
				});
			
			_showSkillBackground = false;
			currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_SKILLBACKGROUND,
				function _onskillbackground(e:Event):void
				{
					e.target.removeEventListener(e.type,_onskillbackground);
					_showSkillBackground = true;
					CJBattleMapManager.o.skillmaskLayer.pushActive();
				});
			
			currentMovieclip.addEventListener(Event.COMPLETE,function _finish(e:Event):void
			{
				_smc.changeState(ConstPlayerState.SConstPlayerStateSkill1);	
			});
			
			
		}
		
		override internal function _onstate_skill1(e:StateMachineEvent):void
		{
			
			//更换NPC特效起手
			_execNpcSkill(_params['skillData']);
			super._onstate_skill1(e);
			currentMovieclip.addEventListener(starling.events.Event.COMPLETE,_event_exec);
			currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_STARTEND,_event_exec);
			
			function _event_exec(e:Event):void
			{
					(e.currentTarget as SAnimate).removeEventListener(starling.events.Event.COMPLETE,_event_exec);
					(e.currentTarget as SAnimate).removeEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_STARTEND,_event_exec);
					_execNpcSkillMid(_params['skillData']);
			}
		}
		
		/**
		 * 释放技能中 
		 */
		private var _bSkilling:Boolean = false;
		
		/**
		 * 开始技能 
		 * 
		 */
		private function _beginSkill():void
		{
			//隐藏血条啥的
			_playerInfoLayer.visible = false;
			_shadowImage.visible = false;
			_bSkilling = true;
			if(_animguangquan != null)
			{
				_animguangquan.visible = false;
			}
			
		}
		
		
		private function _execNpcSkillMid(skillData:Object):void
		{
			
			_beginSkill();
			
			_logger.debug("_execNpcSkillMid");
			var skillAnimName:String = skillData["skillduringanim"];
			
			if(SStringUtils.isEmpty(skillAnimName))
			{
				_execNpcSkillEnd(skillData,_params['onfinish']);
			}
			else
			{
				Assert(false,"目前没有设计技能中间特效");
			}
		}
		private var _skillanimFront:SAnimate = null;
		
		private function _execNpcSkillEnd(skillData:Object,_onFinish:Function = null):void
		{
			var skilltype:int = skillData["skilltype"];
			var skillTargetType:int = skillData["skilltargettype"];
			var skillTargetNum:int = skillData["skilltargetnum"];
			var skillEndAnimName:String = skillData["skillendanim"];
			//技能攻击次数
			var skillAttackNum:int  = int(skillData["skillattacknum"]);
			var animFrontObject:Object = null;
			var animsFront:SAnimate = null;
			var targetPlayer:Vector.<CJPlayerNpc> = _params["d_players"];
			var i:int = 0;
			
//			skillAttackNum = 2;
			//前景动画
			if(!SStringUtils.isEmpty(skillEndAnimName))
			{
				animFrontObject = AssetManagerUtil.o.getObject(skillEndAnimName);
				_skillanimFront = animsFront = SAnimate.SAnimateFromAnimJsonObject(animFrontObject);
			}
			
			//地面特效
			var animObjectbackground:Object = AssetManagerUtil.o.getObject(skillEndAnimName + "background");
			var animsBackground:SAnimate = null;
			if(animObjectbackground != null)
			{
				animsBackground = SAnimate.SAnimateFromAnimJsonObject(animObjectbackground);
			}
			
			
			//技能释放到的位置
			var skillpos:Point = new Point();
			
			skillpos.x = targetPlayer[0].x;
			skillpos.y = targetPlayer[0].y;
			//AOE技能
			
			switch(skilltype)
			{
				case ConstSkill.skillTypeAOE://AOE
					skillpos.x = _playerData.isSelf?387:95;
					skillpos.y = 247;
					break;
				case ConstSkill.skillTypeFrontCol://前排
//					skillpos.x = _playerData.isSelf?341:141;
					skillpos.x = _playerData.isSelf?336:146;
					skillpos.y = 247;
					break;
				case ConstSkill.skillTypeBackCol:
//					skillpos.x = _playerData.isSelf?435:47;
					skillpos.x = _playerData.isSelf?425:57;
					skillpos.y = 247;
					break;
			}
			
			//基础缩放,因为技能全部是向左面制作,所以自己施法都是正的 敌人施法都是反的
			var skillLayer:MapLayer = _playerData.isSelf?CJBattleMapManager.o.skillLayer.selfSkillLayer
				:CJBattleMapManager.o.skillLayer.otherSkillLayer;
			
			var skillbackgroundLayer:MapLayer = _playerData.isSelf?CJBattleMapManager.o.skillBackLayer.selfSkillLayer:
				CJBattleMapManager.o.skillBackLayer.otherSkillLayer;
			
			skillpos = skillLayer.globalToLocal(skillpos);
			
			
			//如果没有结束动画 直接出目标动画
			if(animsFront == null)
			{
				_executeCompleteFunction(targetPlayer);
				return;
			}
			_logger.debug("_execNpcSkillEnd");
			//前景目标动画开始播放
			animsFront.loop = false;
			animsFront.gotoAndPlay();
			animsFront.x = skillpos.x;
			animsFront.y = skillpos.y;
			animsFront.data = targetPlayer;
			skillLayer.addChild(animsFront);
			animsFront.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				(e.currentTarget as SAnimate).removeFromParent();
				_jugger.remove(e.currentTarget as SAnimate);
				
				
				//执行目标身上特效
				var undertargetPlayer:Vector.<CJPlayerNpc> = (e.target as SAnimate).data as Vector.<CJPlayerNpc>;
				_executeCompleteFunction(undertargetPlayer);
				
			});
			
			animsFront.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_UNDERATTACK,
				_on_underAttack);
			
			animsFront.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_SHAKE,
				_onShakeScreen);
			_jugger.add(animsFront);
			
			//添加地面动画
			if(animsBackground != null)
			{
				animsBackground.gotoAndPlay();
				animsBackground.x = skillpos.x;
				animsBackground.y = skillpos.y;
				animsBackground.loop = false;
				animsBackground.addEventListener(Event.COMPLETE,function(e:Event):void
				{
					animsBackground.removeFromParent();
					animsBackground.removeFromJuggler();
					
				});

				skillbackgroundLayer.addChild(animsBackground);
				_jugger.add(animsBackground);
			}
			
			
			
			
			/**
			 * 执行受击动画 
			 * @param e
			 * 
			 */
			function _on_underAttack(e:Event):void
			{
	
				
					
					//增加硬直
					var stopframe:int = parseInt((e.data as String).split(',')[0]);
					var attackshaketype:int = parseInt((e.data as String).split(',')[1]);
					var anim:SAnimate = (e.currentTarget as SAnimate);
					
//					anim.setFrameDuration(anim.currentFrame,stopframe / anim.fps);

					
					var undertargetPlayer:Vector.<CJPlayerNpc> = (e.target as SAnimate).data as Vector.<CJPlayerNpc>;
					var length:int = undertargetPlayer.length;
					for(i=0;i<length;i++)
					{
//						[0]	Object (@188daee1)	
//						attacktype	0	
//						destheroid	"216175330854576135"	
//						d_hpchange	15557 [0x3cc5]	
//						d_hpchangetype	0	
//						d_hpcurrent	20443 [0x4fdb]	
//						d_hpold	36000 [0x8ca0]	
//						s_blood	155 [0x9b]	
//						s_hpcurrent	391200 [0x5f820]	
//						s_hpold	391200 [0x5f820]	
//						s_iscrit	0	
//						s_ismiss	0	
//						srcheroid	"216175330854576130"	
						
						var step:Object = _params["params"].dosteps[i]
						var attackType:String = ConstPlayer.SConstPlayerAttackTypeNormal;
						var battack:Boolean = true;
						if(parseInt(step.d_hpchangetype) == 1)
						{
							//加血操作
							battack = false;
						}
						
						if(battack)
						{
							if(int(step.s_ismiss) == 1)
							{
								undertargetPlayer[i]._domissaction();
							}
							else
							{
								if(int(step.s_blood) != 0)
								{
									
									//修改多次攻击加血效果
									var hpChangecure:int = parseInt(step.s_blood);
									if(skillAttackNum != 1)
									{
										hpChangecure = parseInt(step.s_blood)/_playerData.heroBattleConfig.normalattacknum;
										hpChangecure -= (hpChangecure * 0.1);
										hpChangecure += (Math.random() * (hpChangecure * 0.2));
										
									}
									_changeHp(ConstPlayer.SConstPlayerAttackTypeNormal,hpChangecure,int(step.s_hpcurrent),false,true);
								}
								if(parseInt(step.s_iscrit) == 1)
								{
									attackType = ConstPlayer.SConstPlayerAttackTypeBaoji;
									_doCrit();
								}
								
								//修改多次攻击掉血效果
								var hpChangeNum:int = parseInt(step.d_hpchange);
								if(skillAttackNum != 1)
								{
									hpChangeNum = parseInt(step.d_hpchange)/skillAttackNum;
									hpChangeNum -= (hpChangeNum * 0.1);
									hpChangeNum += (Math.random() * (hpChangeNum * 0.2));
									
								}
								undertargetPlayer[i].underAttack({"hpchangevalue":hpChangeNum,
									"type":attackType,"hpfinalvalue":parseInt(step.d_hpcurrent),
									"stopframe":stopframe,
									"attackshaketype":attackshaketype,
									"attackshaketime":stopframe / currentMovieclip.fps
								});
							}
						}
						else
						{
							if(parseInt(step.s_iscrit) == 1)
							{
								attackType = ConstPlayer.SConstPlayerAttackTypeBaoji;
								_doCrit();
								
							}
							undertargetPlayer[i]._changeHp(attackType,parseInt(step.d_hpchange),parseInt(step.d_hpcurrent),false);
							
						}
					}
			}
			
			
			
			function _executeCompleteFunction(vtargetPlayer:Vector.<CJPlayerNpc>):void
			{
				var animBackName:String = skillData['skillbackanim'];
				//查找是否有闪回动画
				//如果没有闪回动画,则直接IDLE
				if(SStringUtils.isEmpty(animBackName))
				{		
					idle();	
				}
				else
				{
					//播发出现动画 
					var animBackObject:Object = AssetManagerUtil.o.getObject(animBackName);
					var animBackanims:SAnimate = SAnimate.SAnimateFromAnimJsonObject(animBackObject);
					animBackanims.loop = false;
					animBackanims.gotoAndPlay();
					_animsNode.addChild(animBackanims);
					_jugger.add(animBackanims);
					animBackanims.addEventListener(Event.COMPLETE,function(e:*):void{
						animBackanims.removeFromJuggler();
						animBackanims.removeFromParent();
						idle();
					});
					
				}
				
				_endSkill();
				_execNpcTargetSkill(skillData,vtargetPlayer);
				
				if(_onFinish != null)
				{
					_onFinish();
				}
				
			}
		}
		

		
		
		
		protected function _execNpcSkill(skillData:Object):void
		{
			
			//			"skillData"	Object (@5695329)	
			//			skillattacknum	"3"	
			//			skill_e0	"2"	
			//			skillendanim	"anim_skill_baofengxueeffect"	
			//			skill_ev0	"1000"	
			//			skillicon	"icon_0004"	
			//			skillid	"1"	
			//			skillname	""	
			//			skillstartanim	"anim_skill_huifu"	
			//			skilltargetnum	"0"	
			//			skilltargettype	"1"	
			//			skilltype	"1"	
			var skilltype:int = skillData["skilltype"];
			var skillTargetType:int = skillData["skilltargettype"];
			var skillTargetNum:int = skillData["skilltargetnum"];
			var skillStartAnimName:String = skillData["skillstartanim"];
			
			//设置播放起手动作
			var anim:Object = AssetManagerUtil.o.getObject(skillStartAnimName);
			var anims:SAnimate = SAnimate.SAnimateFromAnimJsonObject(anim);
			if(anims == null)
			{
				_logger.info("can't found: {0}",skillStartAnimName);
			}
			_setMovie(ConstPlayerState.SConstPlayerStateSkill1,anims);	
		}
		
		public function normalAttack(d_player:CJPlayerNpc,movetype:int = 0
									 ,onfinish:Function = null,params:Object = null):void
		{
			_params = {"d_player":d_player,"moveType":movetype,"onfinish":onfinish,"params":params};
			_smc.changeState(ConstPlayerState.SConstPlayerStateAttackBegin);
		}
		
		override internal function _onstate_attackbegin(e:StateMachineEvent):void
		{
			super._onstate_attackbegin(e);
			
			currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_ATTACKBEGINEFFECT,
				function _onattackbegin(e:Event):void
				{
					
					var animString:String = "anim_attackbegineffect";
					var animObject:Object = AssetManagerUtil.o.getObject(animString);
					var anims:SAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject);
					anims.loop = false;
					//坐标偏移
					var offsetx:int = int(_playerData.heroBattleConfig.attackbegineffectx);
					var offsety:int = int(_playerData.heroBattleConfig.attackbegineffecty);
					
					anims.x = x + scaleX * offsetx;
					anims.y = y + offsety;
					
					anims.gotoAndPlay();
					anims.addEventListener(Event.COMPLETE,function (e:*):void
					{
						anims.removeFromParent(true);
						anims.removeFromJuggler();
					});
					
					CJBattleMapManager.o.playerInfoLayer.addChild(anims);
					_jugger.add(anims);
					
					
				});
			
			currentMovieclip.addEventListener(starling.events.Event.COMPLETE,function():void
			{
				_normalAttack();
			});
		}
		
		
		
		

		
		protected function _normalAttack():void
		{
			var d_x:int,d_y:int;
			var d_player:CJPlayerNpc = _params["d_player"];
			var moveType:int = _params["moveType"];
			var onfinish:Function = _params["onfinish"];
			var params:Object = _params["params"];
			var step:Object = _params["params"].dosteps[0]
				
//			"params"	Object (@18001e99)	
//			bSkillAttack	0	
//			destheroids	[] (@17fa8af1)	
//			[0]	"216175330854576135"	
//			length	1	
//			dosteps	[] (@17fa8a91)	
//			[0]	Object (@17fe2fd1)	
//			attacktype	0	
//			destheroid	"216175330854576135"	
//			d_hpchange	366 [0x16e]	
//			d_hpchangetype	0	
//			d_hpcurrent	35634 [0x8b32]	
//			d_hpold	36000 [0x8ca0]	
//			s_blood	3	
//			s_hpcurrent	40800 [0x9f60]	
//			s_hpold	40800 [0x9f60]	
//			s_iscrit	0	
//			s_ismiss	0	
//			srcheroid	"216175330854576129"	
//			length	1	
//			heroid	"216175330854576129"	
//			skill	"4"	

			var attackAnims:SAnimate = _getMoive(ConstPlayerState.SConstPlayerStateAttack);
			var attackTexture:Texture = attackAnims.getFrameTexture(0);
			var offsetx:int = attackTexture.frame.width * parseFloat(_playerData.heroBattleConfig.attackoffset);
			d_x = d_player.x > x? d_player.x - offsetx:d_player.x + offsetx;
			d_y = d_player.y + 1;
			
			
			
			var vec2d:Vector2D = new Vector2D(x,y);
			
			var attackType:String = ConstPlayer.SConstPlayerAttackTypeNormal;
			
			
			if(parseInt(step.s_iscrit) == 1)
			{
				attackType = ConstPlayer.SConstPlayerAttackTypeBaoji;
			}
			var bRmoteattack:Boolean = false;
			var bcure:Boolean = false;
			
			if (parseInt(playerData.heroConfig.normalattacktype) == 1)
			{
				bcure = true;
			}
			
			if(parseInt(playerData.heroConfig.attacktype) == 1)
			{
				//远程攻击
				bRmoteattack = true;
			}
			
			if(bRmoteattack)
			{
				_remoteAttack();
			}
			else
			{
				_attack();
				
			}
			
			/**
			 * 加血 
			 * 
			 */
			function _remoteAttack():void
			{
				//原地播放攻击动作
				attack();
				currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_UNDERATTACK,_onremoteAgent);
				function _onremoteAgent(e:Event):void
				{
					e.target.removeEventListener(AnimateEvent.Event_Custom,_onremoteAgent);
					try
					{
						_onremoteAttack(e);
					}
					catch(e:Error)
					{
						
					}
				}
				function _onremoteAttack(e:Event):void
				{
					
				
					//增加硬直
					var stopframe:int = parseInt((e.data as String).split(',')[0]);
					var attackshaketype:int = parseInt((e.data as String).split(',')[1]);	
					
					
					if(attackType == ConstPlayer.SConstPlayerAttackTypeBaoji)
					{
						_doCrit();
					}
					if(bcure)
					{
						d_player._changeHp(attackType,parseInt(step.d_hpchange),parseInt(step.d_hpcurrent),false);
					}
					else
					{
						
						if(int(step.s_ismiss) == 1)
						{
							d_player._domissaction();
						}
						else
						{
							//增加硬直间隔
//							currentMovieclip.setFrameDuration(currentMovieclip.currentFrame,stopframe / currentMovieclip.fps);
							
							if(int(step.s_blood) != 0)
							{
								//修改多次攻击加血效果
								var hpChangecure:int = parseInt(step.s_blood);
								if(_playerData.heroBattleConfig.normalattacknum != 1)
								{
									hpChangecure = parseInt(step.s_blood)/_playerData.heroBattleConfig.normalattacknum;
									hpChangecure -= (hpChangecure * 0.1);
									hpChangecure += (Math.random() * (hpChangecure * 0.2));
									
								}
								_changeHp(ConstPlayer.SConstPlayerAttackTypeNormal,hpChangecure,int(step.s_hpcurrent),false,true);
							}
							
							//修改多次攻击掉血效果
							var hpChangeNum:int = parseInt(step.d_hpchange);
							if(_playerData.heroBattleConfig.normalattacknum != 1)
							{
								hpChangeNum = parseInt(step.d_hpchange)/_playerData.heroBattleConfig.normalattacknum;
								hpChangeNum -= (hpChangeNum * 0.1);
								hpChangeNum += (Math.random() * (hpChangeNum * 0.2));
								
							}
							
							
							d_player.underAttack({"hpchangevalue":hpChangeNum,
								"type":attackType,
								"hpfinalvalue":parseInt(step.d_hpcurrent),
								"stopframe":stopframe,
								"attackshaketype":attackshaketype,
								"attackshaketime":stopframe / currentMovieclip.fps
							});
						}
					}
					
					

					
					//获取攻击特效 
					var animObject:Object = AssetManagerUtil.o.getObject("anim_" + _npcAnimname + "_attackeffect");
					if(animObject != null)
					{
						var anim:SAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject);
						anim.loop = false;
						d_player.addChild(anim);
						d_player._jugger.add(anim);
						anim.gotoAndPlay();
						anim.addEventListener(Event.COMPLETE,function _e(e:Event):void
						{
							e.target.removeEventListener(e.type,_e);
							(e.target as SAnimate).removeFromJuggler();
							(e.target as SAnimate).removeFromParent(true);
						});
					}

				}
				currentMovieclip.addEventListener(Event.COMPLETE,function _e(e:Event):void
				{
					e.target.removeEventListener(e.type,_e);
					
						if(onfinish != null)
						{
							onfinish();
						}
						idle();
			
				});
			}
			/**
			 * 攻击 
			 * @return 
			 * 
			 */
			function _attack():void
			{
				//移动过去
				shan(new Point(d_x,d_y),onComplete,new Point(x,y));
				function onComplete (pos:Point):void
				{
					var s_x:int = pos.x;
					var s_y:int = pos.y;
					
					attack();
					currentMovieclip.addEventListener(ConstPlayerAnims.ANIM_CUSTOM_EVENT_UNDERATTACK,_underAttack);
					function _underAttack(e:Event):void
					{
						//增加硬直
						var stopframe:int = parseInt((e.data as String).split(',')[0]);
						var attackshaketype:int = parseInt((e.data as String).split(',')[1]);
						
						//增加硬直间隔
//						currentMovieclip.setFrameDuration(currentMovieclip.currentFrame,stopframe / currentMovieclip.fps);
						
						
						if(int(step.s_ismiss) == 1)
						{
							d_player._domissaction();
						}
						else
						{
							
							if(attackType == ConstPlayer.SConstPlayerAttackTypeBaoji)
							{
								_doCrit();
							}
						
							if(int(step.s_blood) != 0)
							{
								//修改多次攻击加血效果
								var hpChangecure:int = parseInt(step.s_blood);
								if(_playerData.heroBattleConfig.normalattacknum != 1)
								{
									hpChangecure = parseInt(step.s_blood)/_playerData.heroBattleConfig.normalattacknum;
									hpChangecure -= (hpChangecure * 0.1);
									hpChangecure += (Math.random() * (hpChangecure * 0.2));
									
								}
								_changeHp(ConstPlayer.SConstPlayerAttackTypeNormal,hpChangecure,int(step.s_hpcurrent),false);
							}
							
							//修改多次攻击掉血效果
							var hpChangeNum:int = parseInt(step.d_hpchange);
							if(_playerData.heroBattleConfig.normalattacknum != 1)
							{
								hpChangeNum = parseInt(step.d_hpchange)/_playerData.heroBattleConfig.normalattacknum;
								hpChangeNum -= (hpChangeNum * 0.1);
								hpChangeNum += (Math.random() * (hpChangeNum * 0.2));
								
							}
							d_player.underAttack({"hpchangevalue":hpChangeNum,
														"type":attackType,
														"hpfinalvalue":parseInt(step.d_hpcurrent),
														"stopframe":stopframe,
														"attackshaketype":attackshaketype,
														"attackshaketime":stopframe / currentMovieclip.fps
							});
						}
						
					}
					
					currentMovieclip.addEventListener(Event.COMPLETE,function _e(e:Event):void
					{
						
						e.target.removeEventListener(e.type,_e);
						//闪回来
						shan(new Point(s_x,s_y),function (arg:*):void{
							if(onfinish != null)
							{
								onfinish();
							}
							idle();
						});
					});
					
				};
			}
			
		}
		
	
		
		
		
		
		override public function set x(value:Number):void
		{
			if(super.x == value)
				return;
			super.x = value;
			_jugger.delayCall(dispatchEventWith,0.001,CJEvent.Event_PlayerPosChange,false,{"x":x,"y":y});
//			dispatchEventWith(CJEvent.Event_PlayerPosChange,false,{"x":x,"y":y});
		}
		
		override public function set y(value:Number):void
		{
			if(super.y == value)
				return;
			super.y = value;
			_jugger.delayCall(dispatchEventWith,0.001,CJEvent.Event_PlayerPosChange,false,{"x":x,"y":y});
//			dispatchEventWith(CJEvent.Event_PlayerPosChange,false,{"x":x,"y":y});
		}
		
		
		/**
		 * 反转缩放 
		 */
		private var _filpscale:int = 1;
		private var _runtween:Tween;
		private var _runfinish:Function;
		/*坐骑加速比例 0.2表示加速20%*/
		private var _speedAccRatio:Number = 0;
	
		override public function set scaleX(value:Number):void
		{
			// TODO Auto Generated method stub
			super.scaleX = value;
			if(_playerInfoLayer)
			{
				_playerInfoLayer.scaleX = value;
			}
		}
		
		override public function sceneidle():void
		{
			if(RideId == RIDE_ID_INVALID)
			{
				_smc.changeState(ConstPlayerState.SConstPlayerStateSceneIdle);
			}
			else
			{
				_smc.changeState(ConstPlayerState.SConstPlayerStateRideIdle);
				
			}
		}
		
		
		override public function idle():void
		{
			if(RideId == RIDE_ID_INVALID)
			{
				_smc.changeState(ConstPlayerState.SConstPlayerStateIdle);
			}
			else
			{
				_smc.changeState(ConstPlayerState.SConstPlayerStateRideIdle);
				
			}
			
		}
		
		override public function run():void
		{
			if(RideId == RIDE_ID_INVALID)
			{
				_smc.changeState(ConstPlayerState.SConstPlayerStateRun);
			}
			else
			{
				_smc.changeState(ConstPlayerState.SConstPlayerStateRideRun);
				
			}
		}
		
		/**
		 * 跑动调整 
		 * 
		 */
		private function _runadjust(destPoint:Point):void
		{
			var mfilpscale:int = 1;
			if(destPoint.x < x)
			{
				mfilpscale = -1;
			}
			else
			{
				mfilpscale = 1;
			}
			if(mfilpscale != _filpscale)
			{
				_filpscale = mfilpscale
				this.scaleX = this.scaleX * -1;
			}
		}
		
		
		public function RandomRun(rect:Rectangle):void
		{
			var basex:Number = 50;
			var offsetx:Number = 150;
			var basey:Number = 20;
			var offsety:Number = 20;
			
			_jugger.delayCall(_randomRun,Math.random() * 10);
			function _randomRun():void
			{
				var destx:Number = x - (basex + offsetx) + 2 * (basex + offsetx) * Math.random();
				var desty:Number = y - (basey + offsety) + 2 * (basey + offsety) * Math.random();
				
				destx = Math.min(rect.right,destx);
				destx = Math.max(rect.left,destx);
				
				desty = Math.max(rect.top,desty);
				desty = Math.min(rect.bottom,desty);
				
				var destpoint:Point = new Point(destx,desty);
				
				runTo(destpoint,
				function ():void
				{
					RandomRun(rect);
				});	
			}
		}
		
		/**
		 * 跑到某个坐标点 
		 * @param destPoint
		 * @param finish 完成回调 function(npc:CJPlayerNpc):void
		 */
		public function get speed():Number
		{
			return (this.playerData.speed * (1+ _speedAccRatio) / 10);
		}
		private var _runfromstate:String;
		public function runTo(destPoint:Point,finish:Function = null):void
		{
			if(_smc.state != ConstPlayerState.SConstPlayerStateRun &&
				_smc.state != ConstPlayerState.SConstPlayerStateRideRun)
			{
				_runfromstate = _smc.state;
			}
			var intdestPoint:Point = new Point(int(destPoint.x),int(destPoint.y));
			_runadjust(intdestPoint);
			run();
			
			var vecsrc:Vector2D = new Vector2D(x,y);
			var vecdest:Vector2D = new Vector2D(intdestPoint.x,intdestPoint.y);
			var distance:Number =  vecdest.dist(vecsrc);
			var time:Number = distance / speed;
			var npcins:CJPlayerNpc = this;
			if(_runtween == null)
				_runtween = new Tween(this,time);
			
			_runtween.reset(this,time);
			_runtween.moveTo(intdestPoint.x,intdestPoint.y);
			_runtween.onComplete = function():void
			{
				
				//fix 还原回原来的状态
				if(_runfromstate == ConstPlayerState.SConstPlayerStateSceneIdle)
				{
					sceneidle();
				}
				else
				{
					idle();
				}
				_runfromstate = "";
				_jugger.remove(_runtween);
				if(_runfinish != null)
					_runfinish(npcins);
				_runfinish = null;
			};
			
			_runfinish = finish;
			//jugger 本身已经做了判断了 防止重复添加
			_jugger.add(_runtween);
		}
		/**
		 * 停止跑动 
		 * 
		 */
		public function stoprun():void
		{
			if(_runtween != null)
				_jugger.remove(_runtween);
		}
		/**
		 * 放置到指定的坐标点 
		 * @param destPoint
		 * @return 
		 * 
		 */
		public function setToPosition(destPoint:Point):void
		{
			if(_runtween != null)
				_jugger.remove(_runtween);
			x = destPoint.x;
			y = destPoint.y;
		}
		
		/**
		 * 加载资源等级 默认是ALL
		 */
		public function set lodlevel(value:uint):void
		{
			_lodlevel.clear(LEVEL_LOD_ALL);
			_lodlevel.set(value);
		}

		private var _battletipLayer:CJPlayerBattleTip = null;
		/**
		 * 显示战斗tip 
		 * 
		 */
		public function showBattleTips():void
		{

			closeBattleTips();
			_battletipLayer =  SFeatherControlUtils.genLayoutFromXMLHelp("battleTips.sxml",CJPlayerBattleTip);
			_battletipLayer.playerData = playerData;
			CJLayerManager.o.addToModal(_battletipLayer);
		}
		
		/**
		 * 关闭战斗tip 
		 * 
		 */
		public function closeBattleTips():void
		{
			if(_battletipLayer != null)
			{
				if(PopUpManager.isPopUp(_battletipLayer))
				{
				CJLayerManager.o.disposeFromModal(_battletipLayer,true);
				}
				_battletipLayer = null;
			}
		}
		
	}
}