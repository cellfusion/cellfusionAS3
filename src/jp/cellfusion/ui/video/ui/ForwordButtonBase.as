package jp.cellfusion.ui.video.ui
{
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.button.IButton;
	import jp.cellfusion.ui.button.MovieClipButton;
	import jp.cellfusion.ui.video.IVideoPlayer;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class ForwordButtonBase extends MovieClipButton implements IButton, IControllerParts
	{
		protected var _player:IVideoPlayer;

		public function ForwordButtonBase(up:String = 'up', over:String = 'over', disable:String = 'disable')
		{
			super(up, over, disable);
		}

		override public function atClick():void
		{
			super.atClick();

			var framerate:Number = _player.metadata.videoframerate || _player.metadata.framerate;
			var minCheckSeconds:Number = 1 / framerate;

			var seconds:Number = Math.floor(_player.duration * 10) / 10;
			_player.seek(seconds + minCheckSeconds);
			
			enabled = true;
		}

		public function initialize(player:IVideoPlayer):void
		{
			_player = player;
			_player.addEventListener(VideoEvent.PLAY_START, playStart);
			_player.addEventListener(VideoEvent.PLAY_STOP, playStop);
			enabled = _player.isPlay;
		}

		private function playStop(event:VideoEvent):void
		{
			enabled = false;
		}

		private function playStart(event:VideoEvent):void
		{
			enabled = true;
		}

		public function update():void
		{
		}

		public function finalize():void
		{
			_player = null;
		}

		public function reset():void
		{
		}
	}
}
