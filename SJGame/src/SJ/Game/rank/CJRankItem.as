package SJ.Game.rank
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstRank;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.textures.Texture;
	

	/**
	 * 排行榜滑动显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJRankItem extends CJItemTurnPageBase
	{
		/**选中背景图*/
		private var _imgSelected:Scale9Image;
		/**前三名之后玩家排名等级*/
		private var _labRankLevel:Label;
		/**前三名玩家排名等级*/
		private var _imgRankLevel:ImageLoader;
		/**前三名玩家背景图*/
		private var _imgRankBg:Scale9Image;
		/**玩家排名变化*/
		private var _imgRankChange:ImageLoader;
		/**玩家名称*/
		private var _labName:Label;
		/**玩家等级*/
		private var _labLevel:Label;
		/**玩家总战力*/
		private var _labBattlePower:Label;
//		/**玩家阵营*/
//		private var _imgCamp:ImageLoader;
		/**玩家Vip*/
		private var _imgVip:ImageLoader;
		/**玩家军团名*/
		private var _labGroupName:Label;
		
		public function CJRankItem()
		{
			super("CJRankItem");
		}
		override protected function initialize():void
		{
			super.initialize();
			this.width = 405;
			this.height = 40;
			_drawContent();
			_refreshCoordinate();
		}
		/**
		 * 刷新坐标
		 * 
		 */		
		private function _refreshCoordinate():void
		{
			_imgRankBg.x = 4;
			
			_imgSelected.x = 4;
			
			_labRankLevel.x = 15;
			_labRankLevel.y = 13;
			
			_imgRankLevel.x = 3;
			_imgRankLevel.y = 4;
			
			_imgRankChange.x = 36;
			_imgRankChange.y = 17;
			
			_labName.x = 47;
			_labName.y = 13;
			
			_imgVip.x = 123;
			_imgVip.y = 12;
			
			
			_labBattlePower.x = 175;
			_labBattlePower.y = 13;
			
			_labLevel.x = 252;
			_labLevel.y = 13;
			
			_labGroupName.x = 315;
			_labGroupName.y = 13;
		}
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			this._drawBg();
			_imgRankBg = ConstNPCDialog.genS9ImageWithTextureNameAndRect("paihangbang_mingcidi01",5,8 ,1 , 1);
			_imgRankBg.width = 400;
			_imgRankBg.height = 40;
			_imgRankBg.visible = false;
			addChild(_imgRankBg);
			
			_imgSelected = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_liebiaoxuanzhong",4,4 ,1 , 1);
			_imgSelected.width = 400;
			_imgSelected.height = 40;
			_imgSelected.visible = false;
			addChild(_imgSelected);
			
			_labRankLevel = new Label();
			_labRankLevel.width = 20;
			_labRankLevel.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			addChild(_labRankLevel);
			
			_imgRankLevel = new ImageLoader();
			addChild(_imgRankLevel);
			
			_imgRankChange = new ImageLoader();
			addChild(_imgRankChange);
			
			_labName = new Label();
			_labName.width = 65;
			_labName.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xB2B344,null,null,null,null,null, TextFormatAlign.CENTER);
			addChild(_labName);
			
			_labLevel = new Label();
			_labLevel.width = 63;
			_labLevel.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			addChild(_labLevel);
			
			_labBattlePower = new Label();
			_labBattlePower.width = 78;
			_labBattlePower.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xFF7920, null,null,null,null,null, TextFormatAlign.CENTER);
			_labBattlePower.textRendererFactory = textRender.standardTextRender;
			addChild(_labBattlePower);
			
			_imgVip = new ImageLoader();
			_imgVip.width = 48;
			_imgVip.height = 16;
			addChild(_imgVip);
			
			
			_labGroupName = new Label();
			_labGroupName.width = 85;
			_labGroupName.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x9E6C13,null,null,null,null, null, TextFormatAlign.CENTER);
			addChild(_labGroupName);
		}
		/**
		 * 
		 * 设置背景图，防止item有透明区域
		 */		
		private function _drawBg():void
		{
			var bg:SImage = new SImage(Texture.fromColor(405,40, 0x01FFFFFF,false,SApplication.assets.scaleFactor),true);
			this.addChild(bg);
		}
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				_refreshCoordinate();
				//玩家当前排名,前三名要特殊处理
				if (data.rankid == 0)
				{
					_labRankLevel.visible = false;
					_imgRankBg.visible = true;
					_imgRankLevel.visible = true;
					_imgRankLevel.source = SApplication.assets.getTexture("paihangbang_mici01");
					_imgRankBg.textures = new Scale9Textures(SApplication.assets.getTexture('paihangbang_mingcidi01') , new Rectangle(5,8,1,1));
				}
				else if (data.rankid == 1)
				{
					_labRankLevel.visible = false;
					_imgRankBg.visible = true;
					_imgRankLevel.visible = true;
					_imgRankLevel.source = SApplication.assets.getTexture("paihangbang_mici02");
					_imgRankBg.textures = new Scale9Textures(SApplication.assets.getTexture('paihangbang_mingcidi02') , new Rectangle(5,8,1,1));
				}
				else if (data.rankid == 2)
				{
					_labRankLevel.visible = false;
					_imgRankBg.visible = true;
					_imgRankLevel.visible = true;
					_imgRankLevel.source = SApplication.assets.getTexture("paihangbang_mici03");
					_imgRankBg.textures = new Scale9Textures(SApplication.assets.getTexture('paihangbang_mingcidi03') , new Rectangle(5,8,1,1));
				}	
				else
				{
					_imgRankLevel.visible = false;
					_imgRankBg.visible = false;
					_labRankLevel.visible = true;
					_labRankLevel.text = data.rankid + 1;
				}
				//判断名次上升或者下降
				if (data.rankid > data.lastrankid)
				{
					_imgRankChange.source = SApplication.assets.getTexture("paihangbang_jiantou01");
				}
				else if (data.rankid == data.lastrankid)
				{
					_imgRankChange.source = SApplication.assets.getTexture("paihangbang_kong");
					_imgRankChange.y += 4;
				}
				else
				{
					_imgRankChange.source = SApplication.assets.getTexture("paihangbang_jiantou01");
				}
				var roleName:String = data.name;
				if (roleName.length > 5)
				{
					roleName = roleName.substring(0, 5) + "...";
				}
				//玩家名称
				_labName.text = roleName;
				//玩家等级
				_labLevel.text = "LV" + data.level;
				if (data.hasOwnProperty("expensegold"))
				{
					//玩家使用总元宝
					_labBattlePower.text = data.expensegold;
				}
				else
				{
					//玩家总战力
					_labBattlePower.text = data.battlelevel;
				}
				//玩家vip等级
				_imgVip.source = SApplication.assets.getTexture("zhujiemian_daziVIP" + data.viplevel);
				if (int(data.viplevel) >= 10)
				{
					_imgVip.x = 120;
				}
//				switch(data.camp)
//				{
//					case ConstRank.RANK_CAMP_NULL:
//						_imgCamp.source = SApplication.assets.getTexture("paihangbang_kong");
//						_imgCamp.y += 5;
//						break;
//					case ConstRank.RANK_CAMP_WEI:
//						_imgCamp.source = SApplication.assets.getTexture("paihangbang_tubiao01");
//						_imgCamp.y -= 5;
//						_imgCamp.x -= 2;
//						break;
//					case ConstRank.RANK_CAMP_SHU:
//						_imgCamp.source = SApplication.assets.getTexture("paihangbang_tubiao02");
//						_imgCamp.y -= 5;
//						_imgCamp.x -= 2;
//						break;
//					case ConstRank.RANK_CAMP_WU:
//						_imgCamp.source = SApplication.assets.getTexture("paihangbang_tubiao03");
//						_imgCamp.y -= 5;
//						_imgCamp.x -= 2;
//						break;
//					default:
//						break;
//				}
				//玩家军团名
				if(SStringUtils.isEmpty(data.guildname))
				{
					_labGroupName.addChild(new SImage(SApplication.assets.getTexture("paihangbang_kong")));
					_labGroupName.x += 36;
					_labGroupName.y += 8;
				}
				else
				{
					_labGroupName.text = data.guildname;
				}
			}
		}
		
		override public function set isSelected(value:Boolean):void
		{
			var textureBg:Texture;
			var bgScaleRange:Rectangle;
			if (value)
			{
				//设置选中效果
				_imgSelected.visible = true;
			}
			else
			{
				//设置未选中效果
				_imgSelected.visible = false;
			}
		}
		/**
		 * 处理选中事件
		 * @param selectedIndex 单元的索引
		 * 
		 */
		override protected function onSelected():void
		{
			CJEventDispatcher.o.dispatchEventWith(("selectRankPlayerInfoEvent" + ConstRank.RANK_TYPE) ,false, {"selectRankPlayerInfo":data, "rankItemIsSelected":true});
		}

	}
}