package jp.cellfusion.thread 
{
	import jp.cellfusion.abstractUI.video.IVideoPlayer;
	import jp.cellfusion.abstractUI.video.SimpleVideoPlayer;
	import jp.cellfusion.abstractUI.video.VideoEvent;
	import jp.cellfusion.abstractUI.video.VideoProgressEvent;

	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.Progress;

	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class VideoLoaderThread extends Thread 
	{
		private var _request:URLRequest;
		private var _player:IVideoPlayer;
		private var _progress:Progress;

		public function VideoLoaderThread(request:URLRequest, player:IVideoPlayer = null)
		{
			_request = request;
			_player = player != null ? player : new SimpleVideoPlayer(400, 300); 
			_progress = new Progress();
		}

		override protected function run():void
		{
			events();
			
			// 割り込みハンドラ設定
			interrupted(interruptedHandler);
			
			// ロード開始
			_player.load(_request);
		}
		
		private function events():void
		{
			event(_player, VideoEvent.LOAD_COMPLETE, completeHandler);			event(_player, VideoProgressEvent.PROGRESS, progressHandler);			event(_player, IOErrorEvent.IO_ERROR, ioErrorHandler);		}
		
		private function progressHandler(event:VideoProgressEvent):void
		{
			// 必要であれば開始を通知
			notifyStartIfNeeded(event.bytesTotal);
			
			// 進捗を通知
			_progress.progress(event.bytesLoaded);
			
			// 割り込みハンドラを設定
			interrupted(interruptedHandler);
			
			// 再びイベント待ち
			events();
		}
		
		private function notifyStartIfNeeded(total:Number):void
		{
			if (!_progress.isStarted) {
				_progress.start(total);
			}
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			// 必要であれば開始を通知 (問題が発生しなければ通常 progressHandler で通知される)
			notifyStartIfNeeded(0);
			
			// 失敗を通知
			_progress.fail();
			
			// IOError をスロー
			throw new IOError(event.text);
		}

		private function completeHandler(event:VideoEvent):void
		{
			// 必要であれば開始を通知 (問題が発生しなければ通常 progressHandler で通知される)
			notifyStartIfNeeded(0);
			
			// 完了を通知
			_progress.complete();
			
			// ここでスレッド終了
		}

		private function interruptedHandler():void
		{
			// 必要であれば開始を通知 (問題が発生しなければ通常 progressHandler で通知される)
			notifyStartIfNeeded(0);
			
			// ロードをキャンセル
			_player.close();
			
			// キャンセルを通知
			_progress.cancel();
		}

		public function get request():URLRequest
		{
			return _request;
		}
		
		public function get player():IVideoPlayer
		{
			return _player;
		}
		
		public function get progress():Progress
		{
			return _progress;
		}
	}
}
