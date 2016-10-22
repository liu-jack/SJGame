package engine_starling.utils
	
{
	

	/**
	 *  UintBitset is a tool for wrap bit operation to logical names. This class
	 *  add follow methods:
	 *  
	 *  <ui>
	 *    <li>set #&151; set bit</li>
	 *    <li>clear #&151; clear bit</li>
	 *    <li>equal #&151; test to equals two bitsets</li>
	 *    <li>contain #&151; test to contain a few bits in bitset</li>
	 *  </ui>
	 *  
	 *  So far as UintBitset wrap uint it can use only 32 bits.
	 */ 
	public class SBitSet
	{
		//---------------------------------------------------------------------
		//
		//  Methods
		//
		//---------------------------------------------------------------------
		
		/**
		 *  @constructor
		 *  @param init is a first value of bitset 
		 */ 
		public function SBitSet(init:uint=0):void
		{
			bitset = init;
		}
		
		/**
		 *  Set bit directly.
		 * 
		 *  @param mask is uint with seted bitsh which must be seted
		 *  
		 *  for example if you need to set third bit you pass
		 *  
		 *  <pre>
		 *  0000 0000 0000 0100 // UintBitset.set(1 << 3); 
		 *  0001 0010 0001 1000 // current value 
		 *  0001 0010 0001 1100 // result
		 *  </pre>
		 */ 
		public function set(mask:uint):void
		{
			bitset |= mask;
		}
		
		
		/**
		 *  Clear bit directly.
		 * 
		 *  @param mask is uint mask with bit which must be cleared.
		 * 
		 *  for example if you need to set third bit you pass
		 *  
		 *  <pre>
		 *  0000 0000 0000 0100 // UintBitset.set(1 << 3); 
		 *  0001 0010 0001 1110 // current value 
		 *  0001 0010 0001 1010 // result
		 *  </pre>
		 */ 
		public function clear(mask:uint):void
		{
			bitset &= ~mask;
		}
		
		
		/**
		 *  Check bitset for bits from mask. 
		 *  
		 *  @param mask is uint with checked bits
		 * 
		 *  @return TRUE if bitset setted only
		 *  bits from mask. Return FALSE if in beset setted more or less bits
		 *  then in mask.
		 * 
		 *  <pre>
		 *  0000 0000 0011 0010 // mask
		 *  0000 0000 0011 0010 // bitset
		 *  return TRUE
		 * 
		 *  0000 0000 0011 0010 // mask
		 *  0010 0000 0011 0010 // bitset
		 *  return FALSE
		 *  </pre>
		 */ 
		public function equal(mask:uint):Boolean
		{
			return mask == bitset;
		}
		
		
		/**
		 *  Check bitset for bitsh from mask. Return TRUE if in betset sedded all
		 *  bits from mask. 
		 *  
		 *  @param mask is uint with checked bits
		 *  
		 *  @return FALSE if in bitset setted less bits then
		 *  in mask. 
		 *  
		 *  <pre>
		 *  0000 0000 0011 0010 // mask
		 *  0010 0000 0011 0010 // bitset
		 *  return TRUE
		 *  
		 *  0000 0000 0011 0010 // mask
		 *  0000 0000 0010 0010 // bitset
		 *  return FALSE
		 *  </pre>
		 */ 
		public function test(mask:uint):Boolean
		{
			return (mask & bitset) == mask;
		}
		
		
		
		
		//---------------------------------------------------------------------
		//
		//  Override object
		//
		//---------------------------------------------------------------------
		
		public function toString():String
		{
			var result:String = "";
			for (var i:int = 1; i <= 32; i++)
			{
				result += test(1 << i) ? "1" : "0";
				if (i % 4 == 0)
					result += " ";
				if (i % 8 == 0)
					result += "| ";
			}
			result = result.slice(0, result.length - 3);
			result = result.split("").reverse().join("");
			return result;
		}
		
		public function toUint():uint
		{
			return bitset;
		}
		
		
		
		//---------------------------------------------------------------------
		//
		//  Private logic
		//
		//---------------------------------------------------------------------
		
		private var bitset:uint = 0;
	}
}
