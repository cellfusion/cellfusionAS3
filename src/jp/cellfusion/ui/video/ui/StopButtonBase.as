package jp.cellfusion.ui.video.ui 
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.button.MovieClipButton;
	import jp.cellfusion.ui.video.IVideoPlayer;
	{
		private var _player:IVideoPlayer;
		override public function atClick():void
		{
			_player.stop();
		{
			_player = player;
			_player.addEventListener(VideoEvent.PLAY_START, playStart);
			_player.addEventListener(VideoEvent.PLAY_STOP, playStop);
			enabled = _player.isPlay;
		}

		private function playStop(event:VideoEvent):void
		{
		}

		private function playStart(event:VideoEvent):void
		{
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
	}