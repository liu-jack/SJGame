package SJ.Game.formation
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfUserSkillList;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	
	import feathers.controls.ImageLoader;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * @name 主角技能封装类
	 * @comment 画技能，名称，处理点击事件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-2 下午14:13:22  
	 +------------------------------------------------------------------------------
	 */
	public class CJItemSkill extends CJItemTurnPageBase
	{
		public const ITEMWIDTH:int = 70;
		public const ITEMHEIGHT:int = 70;
		
		private var _nameTextField:TextField;
		/*技能图标*/
		private var _logo:ImageLoader;
		/*技能背景框未选中*/
		private var _logoBG_uselect:Scale9Image;
		/*技能背景框选中*/
		private var _logoBG_select:Scale9Image;
		/*技能名字*/
		private var _skillName:String;
		/*技能的id*/
		private var _id:int;
		private var _tip:CJFormationSkillTip;
		private var _fire:SAnimate;
		
		public function CJItemSkill()
		{
			super("CJItemSkill" , true);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(data == null)
			{
				return;
			}
			const isAllInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isAllInvalid)
			{
				var texture:Texture = SApplication.assets.getTexture(data['skillicon']);
				this._logo.source = texture;
				this._nameTextField.text = data['skillname'];
				this._id = data['id'];
				
				this._logoBG_select.visible = this.owner.selectedIndex == this.index;
				
				if(data.learned != 1)
				{
					this._logo.color = 0x303030;
				}
				else
				{
					this._logo.color = 0xFFFFFF;
				}
				
				if(data.showfire && data.showfire == 1)
				{
					_fire.visible = true;
				}
			}
		}
		
		override protected function canSelectItem():Boolean
		{
			return data.learned == 1;
		}
		
		override protected function onSelected():void
		{
			_tip.config = CJDataOfSkillPropertyList.o.getProperty(this._id);
			_tip.addToLayer();
			//选中的是已经学的技能
			if(this.data.learned == 1)
			{
				//所有其他技能不选中
				var skillDataList:CJDataOfUserSkillList = CJDataManager.o.DataOfUserSkillList;
				skillDataList.setBattleSkill(this._id);
			}
		}

		private function drawContent():void
		{
			this.width = ITEMWIDTH;
			this.height = ITEMHEIGHT;
			//背景框 未选中
			this._logoBG_uselect = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tubiaokuang1") , new Rectangle(15,15 , 1,1)));
			this._logoBG_uselect.x = 5;
			this._logoBG_uselect.width = 50;
			this._logoBG_uselect.height = 50;
			this.addChild(this._logoBG_uselect);
			//技能图标
			this._logo = new ImageLoader();
			this._logo.x = 9;
			this._logo.y = 3;
			this._logo.width = 44;
			this._logo.height = 44;
			this.addChild(this._logo);
			//文字
			_nameTextField = new TextField(50 , 20,"" ,"宋体" , 10 , 0xFFE9A7 ,true);
			_nameTextField.x = 4;
			_nameTextField.y = 45;
			_drawFlow(_nameTextField);
			this.addChild(_nameTextField);
			
			//背景框 选中
			this._logoBG_select = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_daojutubiaomiaobian02") , new Rectangle(8,8,1,1)));
			this._logoBG_select.visible = false;
			this._logoBG_select.x = 5;
			this._logoBG_select.width = 50;
			this._logoBG_select.height = 50;
			this.addChild(this._logoBG_select);
			
			_tip = new CJFormationSkillTip();
			
			_fire = new SAnimate(SApplication.assets.getTextures("common_kaiqi"), 6);
			var texture:Texture = SApplication.assets.getTextures("common_kaiqi")[0];
			_fire.pivotX = texture.frame.width/2;
			_fire.pivotY = texture.frame.height/2;
			_fire.scaleX = _fire.scaleY = 1.6;
			_fire.x = 30;
			_fire.y = 25;
			_fire.touchable = false;
			_fire.visible = false;
			this.addChild(_fire);
			Starling.juggler.add(_fire);
		}
		
		override public function dispose():void
		{
			super.dispose();
			Starling.juggler.remove(_fire);
		}
		
		/**
		 * 字体描边
		 */		
		private function _drawFlow(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
	}
}