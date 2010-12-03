package jp.cellfusion.ui.video.ui {
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.button.MovieClipButton;
	import jp.cellfusion.ui.video.IVideoPlayer;	/**	 * @author Mk-10:cellfusion	 */	public class PauseButtonBase extends MovieClipButton implements IPauseButton
	{
		protected var _player:IVideoPlayer;

		override public function atClick():void
		{			super.atClick();
			_player.pause();			enabled = true;
		}

		public function initialize(player:IVideoPlayer):void
		{			_player = player;
			_player.addEventListener(VideoEvent.PLAY_START, playStart);
			_player.addEventListener(VideoEvent.PLAY_RESUME, playStart);
			_player.addEventListener(VideoEvent.PLAY_PAUSE, playPause);			enabled = _player.isPlay;
		}

		private function playPause(event:VideoEvent):void
		{			enabled = false;
		}
		private function playStart(event:VideoEvent):void		{			enabled = true;		}

		public function update():void
		{			enabled = _player.isPlay;		}

		public function finalize():void
		{
			_player = null;
		}

		public function reset():void
		{
		}
	}}