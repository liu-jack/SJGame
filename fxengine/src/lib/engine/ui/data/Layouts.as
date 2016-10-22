package lib.engine.ui.data
{
	import lib.engine.iface.ISerialization;
	import lib.engine.iface.ui.I_XGD_UIBuilder;
	import lib.engine.ui.Manager.UIManager;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.utils.CPackUtils;
	
	public class Layouts extends XDG_UI_Data implements ISerialization
	{
		public static const VER:int = 1;
		public static const TYPE:String = "TYPE_LAYOUT";
		public function Layouts()
		{
			super(TYPE);
			_UI_FactoryBuilder = UIManager.o.ui_Factory;
			
		}
		
		private var _ver:int = new int(VER);
	
		private var _UI_FactoryBuilder:I_XGD_UIBuilder;
		/**
		 * 设置组件构造器 
		 * @param builder
		 * 
		 */

		public function get ver():int
		{
			return _ver;
		}

		public function set ver(value:int):void
		{
			_ver = value;
		}

		
		/**
		 * 切图列表 
		 */
//		private var _imagesSets:Dictionary = new Dictionary();
		
		/**
		 * 控件列表 
		 */		
		private var _controls:Array = new Array();
		
//		public function addImageSet(imageset:ImagesSet):void
//		{
//			if(_checkImageSetRepeat(imageset.name))
//			{
//				return;
//			}
//			_imagesSets[imageset.name] = imageset;
//		}
//		
//		public function getImageSet():Dictionary
//		{
//			return _imagesSets;
//		}
//		/**
//		 * 检测控件名称是否重复 
//		 * @param name
//		 * @return T 重复 F不重复
//		 * 
//		 */
//		private function _checkImageSetRepeat(name:String):Boolean
//		{
//			return _imagesSets[name] != null;
//		}
		

		/**
		 * 添加控件,注意重名的控件讲添加失败
		 * @param ctrl
		 * @param int
		 * @param idx
		 * @return 
		 * 
		 */
		public function addControlAt(ctrl:XDG_UI_Data,idx:int = 0):Boolean
		{
			if(_checknamerepeat(ctrl.name))
				return false;
			
			/*如果控件是按钮*/
			_controls.splice(idx,0,ctrl);
			return true;
		}
		
		/**
		 * 添加控件,注意重名的控件讲添加失败 
		 * @param ctrl 被添加的控件
		 * @return T 添加成功,F 添加失败
		 * 
		 */
		public function addControl(ctrl:XDG_UI_Data):Boolean
		{
			if(_checknamerepeat(ctrl.name))
				return false;
			
			/*如果控件是按钮*/
			_controls.push(ctrl);
			return true;
		}
		
		/**
		 * 移除控件 
		 * @param ctrlname 控件名称
		 * @return 被移除的控件
		 * 
		 */
		public function removeControl(ctrlname:String):XDG_UI_Data
		{
			var idx:int = getControlIndex(ctrlname);
			if(idx == -1)
				return null;
			var ctrl:XDG_UI_Data = _controls[idx];
			//删除控件,并且其它控件顺序排列
			_controls.splice(idx,1);
			return ctrl;
		}
		
		public function getControls():Array
		{
			return _controls;
		}
		
		/**
		 * 获得控件 
		 * @param controlname 控件名称
		 * @return 
		 * 
		 */
		public function getControl(controlname:String):XDG_UI_Data
		{
			for each(var ctrl:XDG_UI_Data in _controls)
			{
				if(controlname == ctrl.name)
				{
					return ctrl;
				}
			}
			return null;
		}
		
		/**
		 * 获取控件索引 
		 * @param controlname
		 * @return 
		 * 
		 */
		public function getControlIndex(controlname:String):int
		{
			for(var i:int = 0;i<_controls.length;i++)
			{
				if(_controls[i].name == controlname)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 检测控件名称是否重复 
		 * @param name
		 * @return T 重复 F不重复
		 * 
		 */
		private function _checknamerepeat(name:String):Boolean
		{
			for each(var ctrl:XDG_UI_Data in _controls)
			{
				if(ctrl.name == name)
					return true;
			}
			return false;
		}
		
		
		public function Reset():void
		{
			clearControls();
			//_imagesSets = [];
			
//			for (var id:String in _imagesSets)
//			{       
//				delete _imagesSets[id];
//			}
		}
		
		public function clearControls():void
		{
			_controls = [];
		}
		
		public function Serialization():String
		{
			
			var s:String = JSON.stringify(Pack());
			return s;
		}
		
		public function UnSerialization(object:String):void
		{
			clearControls();
			var obj:Object = JSON.parse(object);
			UnPack(obj);
		}
		
		override public function Pack():Object
		{

			//获取ImageSet的引用
//			var needsLayouts:Dictionary = new Dictionary();
//			for each(var ctrl:XDG_UI_Data in _controls)
//			{
//				var n:Dictionary = ctrl.getnecessaryImageSets();
//				if(n!= null)
//				{
//					for (var key:String in n)
//					{
//						needsLayouts[key] = _imagesSets[key];
//					}
//				}
//				
//			}
			
			var obj:Object = super.Pack();
			
//			obj.imagesets = new Array();
//			for each(var value:ImagesSet in needsLayouts)
//			{
//				//等于Null只有一种情况，就是在压缩Layout文件的时候，因为这个时候不获取Imageset文件，
//				//所以直接操作文件路径
//				if(value != null)
//					obj.imagesets.push({'name':value.name,'filename':value.filename});
//			}
			//检查需要用到的imageset
			
			obj.controls = new Array();
			
			
			//调整深度，倒序调整
			//用户操作的时候，是0为最上，但是存储是0为最下
			for(var i:int=0;i<_controls.length;i++)
			{
				XDG_UI_Data(_controls[i]).depth = _controls.length - 1 - i;
			}
			
			for each(var ctrl:XDG_UI_Data in _controls)
			{
				obj.controls.push(ctrl.Pack());
			}
			
			
			
			return obj;
		}
		
		override public function UnPack(obj:Object):void
		{
			// TODO Auto Generated method stub
			//super.UnPack(obj);
			CPackUtils.UnPackettoObject(obj,this,false);
			
//			for each(var value:Object in obj.imagesets)
//			{
//				if (_imagesSets[value.name] == null)
//					_imagesSets[value.name] = value.filename;
//			}
			for each(var ctrl:Object in obj.controls)
			{
				if(_UI_FactoryBuilder != null)
				{
					var mctrl:XDG_UI_Data = _UI_FactoryBuilder.CreateCtrlInfo(ctrl.type);
					mctrl.UnPack(ctrl);
					addControl(mctrl);
				}

			}
		}
		
		/**
		 * 控件排序 
		 * 
		 */		
		protected function _sortControls():void
		{
			
		}
		
		/**
		 * 移动控件 
		 * @param name 控件名称
		 * @param isup 是否上移 T上移
		 * @return {control:ControlBaseInfo,oldIdx:int,newIdx:int}
		 */
		public function MoveControl(name:String,isup:Boolean = false):Object
		{

			
			var idx:int = getControlIndex(name);
			
			if(idx == -1)
				return {'control':null,'oldIdx':-1,'newIdx':-1};
			var newidx:int = idx;
			var ctrl:XDG_UI_Data = _controls[idx];
			if(isup && idx != 0)//上移
			{		
				newidx = idx - 1;

			}
			else if((isup == false) && idx != _controls.length - 1)//下移
			{
				newidx = idx + 1;
			}
			_controls[idx] = _controls[newidx];
			_controls[newidx] = ctrl;
			return {'control':ctrl,'oldIdx':idx,'newIdx':newidx};
			
		}
		
		
		
	}
}