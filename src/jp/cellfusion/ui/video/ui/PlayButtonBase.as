package jp.cellfusion.ui.video.ui {
	import jp.cellfusion.ui.button.MovieClipButton;
	import jp.cellfusion.ui.video.IVideoPlayer;	/**	 * @author Mk-10:cellfusion	 */	public class PlayButtonBase extends MovieClipButton implements IPlayButton
	{
		protected var _player:IVideoPlayer;						override public function atClick():void
		{			super.atClick();
			_player.play();			enabled = true;
		}

		public function initialize(player:IVideoPlayer):void
		{			_player = player;
		}

		public function update():void
		{			enabled = !_player.isPlay;			buttonMode = !_player.isPlay;		}

		public function finalize():void
		{
		}

		public function reset():void
		{
		}
	}}