package jp.cellfusion.ui.video.ui {
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.button.MovieClipButton;
	import jp.cellfusion.ui.video.IVideoPlayer;	/**	 * @author Mk-10:cellfusion	 */	public class StopButtonBase extends MovieClipButton implements IStopButton
	{
		private var _player:IVideoPlayer;
		override public function atClick():void
		{			super.atClick();
			_player.stop();		}				public function initialize(player:IVideoPlayer):void
		{
			_player = player;
			_player.addEventListener(VideoEvent.PLAY_START, playStart);
			_player.addEventListener(VideoEvent.PLAY_STOP, playStop);
			enabled = _player.isPlay;
		}

		private function playStop(event:VideoEvent):void
		{			enabled = false;
		}

		private function playStart(event:VideoEvent):void
		{			enabled = true;
		}

		public function update():void
		{
			
		}		

		public function finalize():void
		{
		}

		public function reset():void
		{
		}
	}}