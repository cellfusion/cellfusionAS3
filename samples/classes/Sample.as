package  
{
	import jp.cellfusion.abstractUI.video.SimpleVideoPlayer;
	import jp.cellfusion.thread.VideoLoaderThread;

	import org.libspark.thread.EnterFrameThreadExecutor;
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.utils.FunctionThread;
	import org.libspark.thread.utils.Executor;
	import org.libspark.thread.utils.SerialExecutor;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class Sample extends Sprite 
	{
		private var _player:SimpleVideoPlayer;
		private var _vlt:VideoLoaderThread;
		private var _debug:TextField;

		public function Sample()
		{
			Thread.initialize(new EnterFrameThreadExecutor());
			
			_player = new SimpleVideoPlayer(640, 360);
			_vlt = new VideoLoaderThread(new URLRequest('sample.mp4'), _player);
			_debug = new TextField();
			_debug.width = 640;
			_debug.height = 360;
			var tf:TextFormat = _debug.defaultTextFormat;
			tf.color = 0xFFFFFF;
			tf.font = 'Georgia';
			_debug.defaultTextFormat = tf;
			
			var executor:Executor = new SerialExecutor();
			executor.addThread(_vlt);
			executor.addThread(new FunctionThread(_player.play));
			executor.start();
			
			addEventListener(Event.ENTER_FRAME, debug);
			
			addChild(_player);
			addChild(_debug);
		}
		
		private function debug(event:Event):void
		{
			_debug.appendText('// '+getTimer()+'\n');			_debug.appendText('progress:'+_vlt.progress.percent+'\n');			_debug.appendText('total:'+_vlt.progress.total+'\n');			_debug.appendText('current:'+_vlt.progress.current+'\n');
			_debug.scrollV = _debug.maxScrollV;
		}
	}
}
