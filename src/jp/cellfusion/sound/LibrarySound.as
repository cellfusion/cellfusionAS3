package jp.cellfusion.sound 
{

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class LibrarySound extends SoundBase implements ISoundObject
	{
		public function LibrarySound(linkageId:Class, type:uint = BGM) 
		{
			super(new linkageId(), type);
		}
	}
}
