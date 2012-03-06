package jp.cellfusion.ui.video.core
{
	import flash.media.Video;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 * 通常の VideoPlayer
	 */
	public class NormalVideoView extends Video implements IVideoView
	{
		public function NormalVideoView(width:Number, height:Number)
		{
			super(width, height);
		}

	}
}
