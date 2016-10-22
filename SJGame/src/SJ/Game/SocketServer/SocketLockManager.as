package SJ.Game.SocketServer
{
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.Logger;
	
	import flash.utils.Dictionary;
	
	import starling.display.Quad;

	public class SocketLockManager
	{
		public function SocketLockManager(s:singleton)
		{
			_lockdict = new Dictionary();
		}
		
		private static var _o:SocketLockManager;
		private var _lockdict:Dictionary;
		private static function get o():SocketLockManager
		{
			if(_o == null)
				_o = new SocketLockManager(new singleton);
			return _o
		}
		
		/**
		 * 解锁所有的东西 
		 */
		private function _unlockall():void
		{
			for each (var lockquad:Quad in _lockdict)
			{
				CJLayerManager.o.disposeFromModal(lockquad);
			}
			_lockdict = new Dictionary();
		}

		
		/**
		 * 加锁 
		 * @param lockKey : 一般为调用的rpc接口的串如 SocketCommand_formation.saveFormation
		 */
		public static function KeyLock(lockKey:String):void
		{
			o._keylock(lockKey);
			CJLoadingLayer.show();
			Logger.log("SocketLockManager.KeyLock --->" , lockKey);
		}
		/**
		 * 解锁 
		 * @param lockKey : 一般为调用的rpc接口的串如 SocketCommand_formation.saveFormation
		 */
		public static function KeyUnLock(lockKey:String):void
		{
			if(o._keyunlock(lockKey))
			{
				CJLoadingLayer.close();
				Logger.log("SocketLockManager.KeyUnLock --->" , lockKey);
			}
		}
		
		private function _keylock(lockKey:String):void
		{
			_keyunlock(lockKey);
			var lockquad:Quad = new Quad(1,1,0x00000000);
			lockquad.alpha = 0.0001;
			CJLayerManager.o.addToModal(lockquad);
			_lockdict[lockKey] = lockquad;
		}
		
		private function _keyunlock(lockKey:String):Boolean
		{
			if(_lockdict.hasOwnProperty(lockKey))
			{
				var lockquad:Quad = _lockdict[lockKey] as Quad;
				CJLayerManager.o.disposeFromModal(lockquad);
				
				delete _lockdict[lockKey];
				lockquad.dispose();
				
				return true;
			}
			return false;
		}
		
		public static function UnLockAll():void
		{
		
			o._unlockall();
		}
	}
}

class singleton{}