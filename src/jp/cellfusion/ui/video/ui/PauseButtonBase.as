package jp.cellfusion.ui.video.ui 
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.button.MovieClipButton;
	import jp.cellfusion.ui.video.IVideoPlayer;
	{
		protected var _player:IVideoPlayer;

		override public function atClick():void
		{
			_player.pause();
		}

		public function initialize(player:IVideoPlayer):void
		{
			_player.addEventListener(VideoEvent.PLAY_START, playStart);
			_player.addEventListener(VideoEvent.PLAY_RESUME, playStart);
			_player.addEventListener(VideoEvent.PLAY_PAUSE, playPause);
		}

		private function playPause(event:VideoEvent):void
		{
		}


		public function update():void
		{

		public function finalize():void
		{
			_player = null;
		}

		public function reset():void
		{
		}
	}