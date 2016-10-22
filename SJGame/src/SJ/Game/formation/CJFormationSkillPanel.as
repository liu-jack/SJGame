package SJ.Game.formation
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfUserSkill;
	import SJ.Game.data.CJDataOfUserSkillList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;

	/**
	 +------------------------------------------------------------------------------
	 * @name 技能面板 控制技能翻页，技能选择事件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-11 下午2:47:01  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationSkillPanel extends SLayer
	{
		/*放置技能图标的面板*/
		private var _skillPanel:CJTurnPage = new CJTurnPage(3 , CJTurnPage.SCROLL_V);
		/*下翻按钮*/
		private var _btnSkillDown:Button;
		/*初始技能页面号*/
		private var _currentSkillPage:int = 0;
		/*技能数据源*/
		private var _skillList:CJDataOfUserSkillList;
		/*item 间距*/
		public const ITEMSPAN:int = 2;
		/*滑动面板距离顶部的pix*/
		public const SKILL_PANEL_PADDING_TOP:int = 5;
		
		private var _bg:Scale9Image;
		
		public function CJFormationSkillPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			//需修改 根据数据获得的方式
			this._initData();
		}
		
		private function _drawContent():void
		{
			this._bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zhenxing_jinengbeijing") , new Rectangle(5,5 , 2,2)));
			this._bg.width = 66;
			this._bg.height = 248;
			this._bg.alpha = 0.7;
			this.addChildTo(this._bg , 0 , 0);
			
			this._skillPanel.setRect(66 , 215);
			this._skillPanel.y = SKILL_PANEL_PADDING_TOP;
			
			this._skillPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._skillPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._skillPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._skillPanel.nextButton.scaleY = -1;
			this._skillPanel.nextButton.x = 11;
			this._skillPanel.nextButton.y = 244;
		}
		
		private function _initData():void
		{
			this._skillList = CJDataManager.o.DataOfUserSkillList;
			if(this._skillList.dataIsEmpty)
			{
				return;
			}
			else
			{
				this._doInit();
			}
		}
		
		private function _loadComplete(e:Event):void
		{
			this._doInit();
		}
		
		private function _doInit():void
		{
			//设置渲染属性
			this._setDataProvider();
			this._setLayout();
			this._setRenerItem();
			this.addChild(this._skillPanel);
		}
		
		private function _setRenerItem():void
		{
			this._skillPanel.itemRendererFactory = function ():IListItemRenderer
			{
				const render:CJItemSkill = new CJItemSkill();
				render.owner = _skillPanel;
				return render;
			}
		}
		
		private function _setLayout():void
		{
			const listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.paddingLeft = 4;
			listLayout.gap = ITEMSPAN;
			this._skillPanel.layout = listLayout;
		}
		
		private function _setDataProvider():void
		{
			var listData:Array = new Array();
			var skillDao:CJDataOfUserSkill = CJDataManager.o.DataOfUserSkillList.skillDao;
			var allSkillList:Dictionary = CJDataManager.o.DataOfUserSkillList.getAllSkill();
			var selecteddata:Object;
			for(var skillid:String in allSkillList)
			{
				var skillConfig:Json_skill_setting = allSkillList[skillid] as Json_skill_setting;
				var learned:int = 1;
				var selected:int = skillDao.isSkillSelected(int(skillid));
				
				var data:Object = { id:skillid,
					"skillicon":skillConfig.skillicon,
					"skillname":CJLang(skillConfig.skillname),
					"selected":selected,
					"learned":learned};
				
				if(selected)
				{
					selecteddata = data;
				}
					
				listData.push(data);
			}
			
			listData.sort(_compare , Array.DESCENDING);
			
			//如果需要放出火圈
			if(CJDataManager.o.DataOfFormation.isSkillNeedFire())
			{
				listData[0]['showfire'] = 1;
			}
			
			var groceryList:ListCollection = new ListCollection(listData);
			this._skillPanel.dataProvider = groceryList;
			this._skillPanel.selectedItem = selecteddata;
		}
		
		/**
		 * 由小到大排序
		 */ 
		private function _compare(ob1:Object , ob2:Object):int
		{
			if(int(ob1.id) > int(ob2.id) )
			{
				return 1;
			}
			else if(int(ob1.id) < int(ob2.id) )
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * #角色类型 战士
			ROLE_JOB_ZHANSHI = 1
			#角色类型 军师
			ROLE_JOB_JUNSHI = 2
			#角色类型 射手
			ROLE_JOB_SHESHOU = 8
			#性别 男
			ROLE_SEX_MALE = 1
			#性别 女
			ROLE_SEX_FEMALE = 2
		 */ 
		private function _getSkillType():int
		{
			var roleData:CJDataOfRole = CJDataManager.o.DataOfRole;
			if(roleData.job == 1 && roleData.sex == 1)
			{
				return 1;
			}
			else if(roleData.job == 1 && roleData.sex == 2)
			{
				return 2;
			}
			else if(roleData.job == 2 && roleData.sex == 1)
			{
				return 3;
			}
			else if(roleData.job == 2 && roleData.sex == 2)
			{
				return 4;
			}
			else if(roleData.job == 8 && roleData.sex == 1)
			{
				return 5;
			}
			else if(roleData.job == 8 && roleData.sex == 2)
			{
				return 6;
			}
			return 7;
		}
		

		public function get btnSkillDown():Button
		{
			return _btnSkillDown;
		}

		public function set btnSkillDown(value:Button):void
		{
			_btnSkillDown = value;
		}
	}
}