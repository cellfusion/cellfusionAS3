package  sample.video
{
	import jp.cellfusion.ui.AbstractUI;
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.video.IVideoPlayer;
	import jp.cellfusion.ui.video.VideoPlayer;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	/**	 * @author Mk-10:cellfusion	 */	public class VideoPlayerSample extends Sprite 	{		public var controller:MovieClip;		public var initPlayButton:Sprite;		public var video:Sprite;		private var _videoPlayer:IVideoPlayer;		public function VideoPlayerSample()		{
			AbstractUI.initialize(this);			_videoPlayer = new VideoPlayer("test", 640, 360);			addChildAt(DisplayObject(_videoPlayer), 0);			_videoPlayer.autoRewind = false;			_videoPlayer.smoothing = true;			_videoPlayer.addParts(controller.seekBar);			_videoPlayer.addParts(controller.playPauseButton);			_videoPlayer.addParts(controller.stopButton);			_videoPlayer.addParts(controller.backButton);			_videoPlayer.addParts(controller.muteButton);			_videoPlayer.addParts(controller.volumeBar);						_videoPlayer.addEventListener(VideoEvent.PLAY_START, playStart);			_videoPlayer.addEventListener(VideoEvent.PLAY_PAUSE, playPause);			_videoPlayer.addEventListener(VideoEvent.PLAY_STOP, playStop);						// 確認用			_videoPlayer.addEventListener(VideoEvent.LOAD_START, trace);			_videoPlayer.addEventListener(VideoEvent.LOAD_COMPLETE, trace);			_videoPlayer.addEventListener(VideoEvent.METADATA_RECEIVED, trace);			_videoPlayer.addEventListener(VideoEvent.COMPLETE, trace);						// 読み込み開始//			_videoPlayer.play(new URLRequest("sample.flv"));//			_videoPlayer.play(new URLRequest("rtmp://59.106.187.201/vod/WORKING_OP.mp4"));
			_videoPlayer.play(new URLRequest("rtmp://59.106.187.201/vod/sample1_1500kbps.f4v"));						initPlayButton.buttonMode = true;			initPlayButton.mouseChildren = false;			initPlayButton.addEventListener(MouseEvent.CLICK, initPlayButtonClick);		}				private function initPlayButtonClick(event:MouseEvent):void		{			_videoPlayer.play();		}		private function playStart(event:VideoEvent):void		{
			trace(this, "playStart");			initPlayButton.visible = false;		}				private function playPause(event:VideoEvent):void		{			trace(this, "playPause");			initPlayButton.visible = true;		}				private function playStop(event:VideoEvent):void		{			trace(this, "playStop");			initPlayButton.visible = true;		}	}}