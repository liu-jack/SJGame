package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.utils.Logger;
	
	import feathers.core.FeathersControl;

	public class FeatherControlPropertyBuilderDefault implements IFeatherControlPropertyBuilder
	{
		protected var _editControl:FeathersControl;
		protected var _editOwnerControl:FeathersControl;
		protected var _logger:Logger;
		public function FeatherControlPropertyBuilderDefault()
		{
			_logger = Logger.getInstance(FeatherControlPropertyBuilderDefault);
		}
		
		public function get fullClassName():String
		{
			return "defalut setter";
		}
		
		protected function _onbeginEdit():void
		{
			
		}
		public final function beginEdit(control:FeathersControl,ownerControl:FeathersControl):void
		{
			_editControl = control;
			_editOwnerControl = ownerControl;
			_onbeginEdit();
			
		}
		protected function _onEndEdit():void
		{
			
		}
		public final function endEdit():void
		{
			_onEndEdit();
			_editControl = null;
			_editOwnerControl = null;
			
		}
		
		public final function setProperty(key:String, value:*):void
		{
			if(hasOwnProperty(key))
			{
				_log("{0}:SetSpecialProperty {1}:{2}",fullClassName,key,value);
				this[key] = value;
			}
			else
			{
				if(_editControl.hasOwnProperty(key))
				{
					_log("{0}:SetProperty {1}:{2}",fullClassName,key,value);
					_editControl[key] = value;
				}
				else
				{
					_log("{0}:Ignore SetProperty {1}:{2}",fullClassName,key,value);
				}
			}
			
		}
		
		protected function _log(msg:String,...args):void
		{
//			_logger.info(msg,args);
		}


		/**
		 * 设置所有的变量 
		 * @param value
		 * 
		 */
		public function set ownerVar(value:String):void
		{
			if(_editOwnerControl != null && _editOwnerControl.hasOwnProperty(value))
			{
				_editOwnerControl[value] = _editControl;
			}
			
		}
		
		
	}
}