package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.friends.CJHeroHeadIconItem;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.textures.Texture;

	/**
	 * 选择助战单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicAssistantItem extends CJItemTurnPageBase
	{
		/**选中背景图*/
		private var _imgSelected:Scale9Image;
		/**助战玩家战力最高武将单元*/
		private var _itemHero:CJHeroHeadIconItem;
		/**助战玩家战力最高武将等级*/
		private var _labHeroLevel:Label;
		/**助战玩家战力最高武将名称*/
		private var _labHeroName:Label;
		/**助战玩家战力最高武将战斗力*/
		private var _labBattlePower:Label;
//		/**竖线图标*/
//		private var _imgLine:SImage;
		/**助战玩家名称*/
		private var _labRoleName:Label;
		/**助战玩家战力最高武将技能*/
		private var _labHeroSkill:Label;
		public function CJDynamicAssistantItem()
		{
			super("CJDynamicAssistantItem");
		}
		override protected function initialize():void
		{
			_initData();
			_drawContent();
		}
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				var heroTmpl:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(data.battleherotemplateid);
				var settingSkill:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(data.battleheroskillid) as Json_skill_setting;
				_itemHero.setHeadImg(heroTmpl.headicon);
				_labHeroLevel.text = "LV：" + data.level;
				_labHeroName.text = CJLang(heroTmpl.name);
				_labBattlePower.text = CJLang("DYNAMIC_BATTLE_POWER").replace("{battlepower}", data.battleheropower);
				var rolename:String;
				if (data.isfriend == 0)
				{
					rolename = CJLang("DYNAMIC_PASSERBY").replace("{rolename}", data.rolename);
				}
				else
				{
					rolename = CJLang("DYNAMIC_FRIEND_WITH_ROLENAME").replace("{rolename}", data.rolename);
				}
				if (rolename.length > 9)
				{
					rolename = rolename.substring(0, 9) + "...";
				}
				_labRoleName.text = rolename;
				if(settingSkill == null)
				{
					_labHeroSkill.text = CJLang("DYNAMIC_HERO_SKILL").replace("{skill}", CJLang("FRIEND_RELATION_NULL"));
				}
				else
				{
					_labHeroSkill.text = CJLang("DYNAMIC_HERO_SKILL").replace("{skill}", CJLang(settingSkill.skillname));
				}
			}
		}
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			this.width = 258;
			this.height = 58;
			
		}
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			_imgSelected = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_liaotian_wenzidi", 2, 2, 2, 2);
			_imgSelected.width = this.width;
			_imgSelected.height = this.height;
			_imgSelected.alpha = 0.8;
			this.addChild(_imgSelected);
			
			
			_itemHero = new CJHeroHeadIconItem();
			_itemHero.x = 3;
			_itemHero.y = 4;
			this.addChild(_itemHero);
			
			_labHeroLevel = new Label();
			_labHeroLevel.x = 3;
			_labHeroLevel.y = 38;
			_labHeroLevel.width = 50;
			_labHeroLevel.textRendererProperties.textFormat = ConstTextFormat.textformatgreencenter;
			_labHeroLevel.textRendererFactory = textRender.standardTextRender;
			this.addChild(_labHeroLevel);
			
			_labHeroName = new Label();
			_labHeroName.x = 58;
			_labHeroName.y = 14;
			_labHeroName.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xE9FBB2);
			this.addChild(_labHeroName);
			
			_labBattlePower = new Label();
			_labBattlePower.x = 58;
			_labBattlePower.y = 30;
			_labBattlePower.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xBF5B18);
			_labBattlePower.textRendererFactory = textRender.standardTextRender;
			this.addChild(_labBattlePower);
			
			_labRoleName = new Label();
			_labRoleName.x = 158;
			_labRoleName.y = 14;
			_labRoleName.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xE59600);
			this.addChild(_labRoleName);
			
			_labHeroSkill = new Label();
			_labHeroSkill.x = 158;
			_labHeroSkill.y = 30;
			_labHeroSkill.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x5AFCEE);
			this.addChild(_labHeroSkill);
			
		}
		
		/**
		 * 处理选中事件
		 * @param selectedIndex 单元的索引
		 * 
		 */
		override protected function onSelected():void
		{
			var textureBg:Texture = SApplication.assets.getTexture("dongtai_xuanzhong");
			var bgScaleRange:Rectangle = new Rectangle(10, 10, 2, 2);
			_imgSelected.textures = new Scale9Textures(textureBg, bgScaleRange);
			SocketCommand_fuben.selectInviteHeros(data.uid);
		}

	}
}