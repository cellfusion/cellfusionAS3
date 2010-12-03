package jp.cellfusion.ui.video.ui
{
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.button.ToggleButton;
	import jp.cellfusion.ui.video.IVideoPlayer;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class PlayPauseButtonBase extends ToggleButton implements IPlayPauseButton
	{
		protected var _player:IVideoPlayer;

		public function initialize(player:IVideoPlayer):void
		{
			_player = player;
			IControllerParts(onButton).initialize(player);
			IControllerParts(offButton).initialize(player);
			_player.addEventListener(VideoEvent.PLAY_START, playStart);
			_player.addEventListener(VideoEvent.PLAY_RESUME, playStart);
			_player.addEventListener(VideoEvent.PLAY_PAUSE, playPause);
			_player.addEventListener(VideoEvent.PLAY_STOP, playPause);
		}
		
		
		override public function atClick():void
		{
			_current.atClick();
		}

		private function playPause(event:VideoEvent):void
		{
			change("on");
		}

		private function playStart(event:VideoEvent):void
		{
			change("off");
		}

		public function finalize():void
		{
			_player = null;
		}

		public function reset():void
		{
		}

		public function update():void
		{
			
		}
	}
}
