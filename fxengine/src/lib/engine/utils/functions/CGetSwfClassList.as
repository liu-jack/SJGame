package lib.engine.utils.functions
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 返回SWF中对象的名称
	 * @Author peng.zhi
	 * @param srcbytes SWF的字节流
	 * @return 
	 * 对象名称字符串列表 
	 */
	public function CGetSwfClassList(srcbytes:ByteArray):Array
	{
		
		var bytes:ByteArray = new ByteArray();
		var rtnArray:Array = new Array();
		var srcidx:int = srcbytes.position;
		bytes.writeBytes(srcbytes);
		srcbytes.position = srcidx;
		bytes.position = 0;
		
		bytes.endian=Endian.LITTLE_ENDIAN;
		bytes.writeBytes(bytes,8);
		bytes.uncompress();
		bytes.position=Math.ceil(((bytes[0]>>>3)*4+5)/8)+4;
		while(bytes.bytesAvailable>2){
			var head:int=bytes.readUnsignedShort();
			var size:int=head&63;
			if (size==63)size=bytes.readInt();
			if (head>>6!=76)bytes.position+=size;
			else {
				head=bytes.readShort();
				for(var i:int=0;i<head;i++){
					bytes.readShort();
					size=bytes.position;
					while(bytes.readByte()!=0){};
					size=bytes.position-(bytes.position=size);
					//trace(bytes.readUTFBytes(size));
					rtnArray.push(bytes.readUTFBytes(size));
				}
			}
		}
		
		return rtnArray;
	}
}