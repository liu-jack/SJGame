package SJ.Game.heroStar
{
	import engine_starling.display.SLayer;
	
	import lib.engine.utils.functions.Assert;
	
	/**
	 * 记分牌效果显示
	 * 该控件仅可以显示数字的记分牌翻拍效果
	 * @author kaixin
	 * 
	 */
	public class CJScoreBoard extends SLayer
	{
		/** 左对齐 **/
		public static const ALIGN_LEFT:uint = 1;
		/** 左对齐 **/
		public static const ALIGN_RIGHT:uint = 2;
		/** 居中对齐 **/
		public static const ALIGN_CENTER:uint = 3;
		
		
		/** 最大位数 **/
		private const ConstMaxDigit:uint = 4;
		
		/** 放置所有数字的图层 **/
		private var _layer:SLayer;
		/** 数字间的间距(单位：像素) **/
		private var _numberGap:int = -10;
		/** 当前最大位数 **/
		private var _curMaxDigit:uint;
		/** 当前计分板的数字 **/
		private var _curNumber:uint = 0;
		/** 数字控件记录数组 内部类型为CJScoreBoardNumber [0]为个位[1]为十位 以此类推 **/
		private var _numArr:Array;
		
		/** 对齐状态 **/
		private var _alignType:uint;
		
		/** 数字纹理贴图前缀 **/
		private var _textureNamePre:String;
		/** 单个数字宽度 **/
		private var _numberWidth:int;
		/** 单个数字高度 **/
		private var _numberHeight:int;
		
		/**
		 * 计分板
		 * @param maxDigit 计分板最大位数，默认为四位数
		 * @param alignType 对齐状态, 默认为左对齐
		 */
		public function CJScoreBoard(maxDigit:uint=ConstMaxDigit, alignType:uint=ALIGN_LEFT)
		{
			super();
			
			// 判断类型
			if(alignType < ALIGN_LEFT || ALIGN_CENTER < alignType )
				Assert( false, "CJScoreBoard.CJScoreBoard() unknow alignType!!!");
			
			_alignType = alignType;
			_curMaxDigit = maxDigit;
			
			// 设置图层
			_layer = new SLayer;
			_layer.x = 0;
			_layer.y = 0;
			addChild(_layer);
			
			// 设置默认属性
			setNumberStyle("texiaozi_zhandouli", 20, 23, -10);
		}
		
		/**
		 * 设置数字样式
		 * @param textureNamePre 数字纹理前缀 如"texiaozi_zhandouli0","texiaozi_zhandouli1"... 则填写 "texiaozi_zhandouli"
		 * @param tWidth	数字宽度
		 * @param tHeight	数字高度
		 * @param tGap		数字间的缝隙
		 */
		public function setNumberStyle( textureNamePre:String, tWidth:int, tHeight:int, tGap:int ):void
		{
			_textureNamePre = textureNamePre;
			_numberWidth = tWidth;
			_numberHeight = tHeight;
			_numberGap = tGap;
			
			// 设置好后 重新初始化面板
			_reinit();
		}
		
		/// 初始化
		private function _reinit():void
		{
			var i:int=0;
			if (_numArr != null) // 移除之前的子对象
			{
				for (i=0; i<_numArr.length; ++i)
				{
					removeChild(_numArr[i]);
				}
			}
			else
				_numArr = new Array;
			
			// 根据最大位数 创建新计分板
			for(i=0; i<curMaxDigit; ++i)
			{
				var temp:CJScoreBoardNumber = new CJScoreBoardNumber( _textureNamePre, _numberWidth, _numberHeight );
				temp.x = i*_numberWidth + _numberGap*i;
				temp.y = 0;
				_layer.addChild(temp);
				// 保存管理
				_numArr.unshift(temp);
			}
			
		}
		
		private function _updateLayer():void
		{
			/*------------------------------  说明  ---------------------------------*/
			// 将curNumber的每一个位上的数字剥离出来
			// 如 设置最大位数为4位，1569则被剥离为 9、6、5、1 (首先为个位)
			// 如 设置最大位数为4位，560则被剥离为 0、6、5、0 (首先为个位)
			/*------------------------------  说明 end ---------------------------------*/
			
			// 索引
			var index:uint = 0;
			// 将数字转化为字符串
			var str:String = curNumber.toString();
			// 有效位
			var validDigit:int = str.length;
			// 
			var temp:CJScoreBoardNumber;
			for (var i:int=0; i<_numArr.length; ++i)
			{
				temp = _numArr[i] as CJScoreBoardNumber;
				if (i<validDigit)
				{
					temp.visible = true;
					temp.num = uint(str.charAt(str.length-1-i));
				}
				else
					temp.visible = false;
					
			}
			
			// 判断对齐方式
			_layer.x = 0;
			// 
			// 全部宽度
			var wholeW:int = _curMaxDigit*(_numberWidth+_numberGap);
			// 有效位数宽度
			var validW:int = validDigit*(_numberWidth+_numberGap);
			if (_alignType == ALIGN_LEFT) // 左对齐
			{
				_layer.x -= (wholeW-validW);
			}
			else if (_alignType == ALIGN_RIGHT) // 右对齐
			{
				// -_-! 右对齐仿佛什么都不用做
			}
			else // 居中对齐
			{
				_layer.x -= (wholeW-validW)/2;
			}
		}
		
		public function set curNumber(value:uint):void
		{
			// 是否超过最大位数
			if (value.toString().length > _curMaxDigit)
				return;
			
			// 赋值
			_curNumber = value;
			// 更新界面
			_updateLayer();
		}
		
		public function get curNumber():uint
		{
			return _curNumber;
		}
		
		/** 当前最大位数 **/
		public function get curMaxDigit():uint
		{
			return _curMaxDigit;
		}
		
		/**
		 * @private
		 */
		public function set curMaxDigit(value:uint):void
		{
			if (_curMaxDigit == value)
				return;
			
			_curMaxDigit = value;
			
			_reinit();
		}
		
		public function set alignType(value:uint):void
		{
			if( _alignType == value )
				return;
			
			_alignType = value;
		}
	}
}