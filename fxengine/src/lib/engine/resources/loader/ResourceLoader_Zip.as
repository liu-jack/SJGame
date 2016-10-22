package lib.engine.resources.loader
{
	import com.deng.fzip.FZip;
	import com.deng.fzip.FZipFile;
	
	import flash.utils.ByteArray;
	
	import lib.engine.resources.ResourceManager;
	import lib.engine.resources.ResourceType;

	/**
	 * 压缩文件加载器 
	 * @author caihua
	 * 
	 */
	public class ResourceLoader_Zip extends ResourceLoader
	{
		public function ResourceLoader_Zip()
		{
			
			super("zipd",ResourceType.TYPE_ZIP);
		}
		
		
		override protected function onLoading(bytes:ByteArray):*
		{
			var fzip:FZip = new FZip();
			//Assert(bytes.length == 0,"bytes.length == [" + bytes.length + "]");
			fzip.loadBytes(bytes);
			var fileCount:int = fzip.getFileCount();
			
			for(var i:int = 0;i< fileCount;i++)
			{
				var file:FZipFile = fzip.getFileAt(i);
				//file.sizeCompressed == 0 的时候,被压缩的内容大小为0,
				//一般情况下也就是文件夹
				if(file.sizeCompressed != 0)
				{
					ResourceManager.o.getResByPath(file.filename,null,file.content);
				}
				
			}
			
			return fzip;
		}
		
		
		
	}
}