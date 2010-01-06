﻿package  sample.video{	import jp.cellfusion.abstractUI.events.VideoEvent;	import jp.cellfusion.abstractUI.video.SimpleVideoPlayer;	import flash.display.Sprite;	import flash.events.MouseEvent;	import flash.net.URLRequest;	/**	 * @author Mk-10:cellfusion	 */	public class VideoPlayerSampleDouble extends Sprite 	{		public var controller:Sprite;		public var initPlayButton:Sprite;		public var video:Sprite;		private var _videoPlayer:SimpleVideoPlayer;		private var _videoPlayer2:SimpleVideoPlayer;		public function VideoPlayerSampleDouble()		{			_videoPlayer = new SimpleVideoPlayer(640, 360);						trace("1st videoplayer width:"+_videoPlayer.width+" height:"+_videoPlayer.height);						addChildAt(_videoPlayer, 0);			_videoPlayer.autoRewind = false;			_videoPlayer.ui = controller;						_videoPlayer.addEventListener(VideoEvent.PLAY_START, playStart);			_videoPlayer.addEventListener(VideoEvent.PLAY_PAUSE, playPause);			_videoPlayer.addEventListener(VideoEvent.PLAY_STOP, playStop);						// 確認用			_videoPlayer.addEventListener(VideoEvent.LOAD_START, trace);			_videoPlayer.addEventListener(VideoEvent.LOAD_COMPLETE, trace);			_videoPlayer.addEventListener(VideoEvent.METADATA_RECEIVED, trace);			_videoPlayer.addEventListener(VideoEvent.COMPLETE, trace);						// 読み込み開始			_videoPlayer.play(new URLRequest("sample.mp4"));						_videoPlayer2 = new SimpleVideoPlayer(640, 360);			_videoPlayer2.smoothing = true;						trace("2nd videoplayer width:"+_videoPlayer2.width+" height:"+_videoPlayer2.height);						_videoPlayer2.y = 384;			addChildAt(_videoPlayer2, 1);						_videoPlayer2.play(new URLRequest("sample.mp4"));						initPlayButton.buttonMode = true;			initPlayButton.mouseChildren = false;			initPlayButton.addEventListener(MouseEvent.CLICK, initPlayButtonClick);		}				private function initPlayButtonClick(event:MouseEvent):void		{			_videoPlayer.play();		}		private function playStart(event:VideoEvent):void		{			initPlayButton.visible = false;		}				private function playPause(event:VideoEvent):void		{			initPlayButton.visible = true;		}				private function playStop(event:VideoEvent):void		{			initPlayButton.visible = true;		}	}}