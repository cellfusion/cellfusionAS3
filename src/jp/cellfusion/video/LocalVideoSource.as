package jp.cellfusion.video
{
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author cellfusion
	 */
	public class LocalVideoSource
	{
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _metadata:Object;

		public function LocalVideoSource()
		{
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, connectionNsStatusHandler);
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netConnectionAsyncError);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, netConnectionIoError);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netConnectionSecurityError);
			_nc.client = {};
		}

		private function connectionNsStatusHandler(event:NetStatusEvent):void
		{
			_ns = new NetStream(_nc);
			_ns.addEventListener(IOErrorEvent.IO_ERROR, nsIoError);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, nsAsyncError);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, nsStatus);
			_ns.addEventListener(ErrorEvent.ERROR, nsError);
			_ns.client = {onMetaData:metaDataHandler, onPlayStatus:playStatusHandler, onCuePoint:cuePointHandler, onImageData:imageDataHandler, onTextData:textDataHandler};
		}

		private function netConnectionSecurityError(event:SecurityErrorEvent):void
		{
			// trace("netConnectionSecurityError", event.text);
		}

		private function netConnectionIoError(event:IOErrorEvent):void
		{
			// trace("netConnectionIoError", event.text);
		}

		private function netConnectionAsyncError(event:AsyncErrorEvent):void
		{
			// trace("netConnectionAsyncError", event.text);
		}

		private function nsError(event:ErrorEvent):void
		{
			// trace("nsError");
		}

		private function nsAsyncError(event:AsyncErrorEvent):void
		{
			// trace("nsAsyncError", event.error);
		}

		private function cuePointHandler(data:Object):void
		{
			// trace("cuePointHandler");
		}

		private function imageDataHandler(data:Object):void
		{
			// trace("imageDataHandler");
		}

		private function textDataHandler(data:Object):void
		{
			// trace("textDataHandler");
		}

		private function metaDataHandler(data:Object):void
		{
			// trace("metadataHandler");
			_metadata = data;
//			dispatchEvent(new VideoEvent(VideoEvent.METADATA_RECEIVED));
		}

		private function playStatusHandler(data:Object):void
		{
			// trace("onPlayStatus");
		}

		private function nsStatus(event:NetStatusEvent):void
		{
			// trace("nsStatus", event.info.code);
			switch (event.info.code) {
				case "NetStream.Buffer.Empty":
//					dispatchEvent(new VideoEvent(VideoEvent.BUFFER_EMPTY));
					break;
				case "NetStream.Buffer.Full":
//					dispatchEvent(new VideoEvent(VideoEvent.BUFFER_FULL));
					break;
				case "NetStream.Buffer.Flush":
//					dispatchEvent(new VideoEvent(VideoEvent.BUFFER_FLUSH));
					break;
				case "NetStream.Play.Start":
					break;
				case "NetStream.Play.Stop":
					break;
				case "NetStream.Play.StreamNotFound":
//					dispatchEvent(new VideoEvent(VideoEvent.PLAY_STREAM_NOT_FOUND));
					break;
				case "NetStream.Play.Failed":
//					dispatchEvent(new VideoEvent(VideoEvent.PLAY_FAILED));
					break;
				case "NetStream.Seek.Failed":
//					dispatchEvent(new VideoEvent(VideoEvent.SEEK_FAILED));
					break;
				case "NetStream.Seek.InvalidTime":
//					dispatchEvent(new VideoEvent(VideoEvent.SEEK_INVALID_TIME));
					break;
				case "NetStream.Seek.Notify":
//					dispatchEvent(new VideoEvent(VideoEvent.SEEK_NOTIFY));
					break;
				case "NetStream.Play.Reset":
					break;
				case "NetStream.Pause.Notify":
					break;
				case "NetStream.Unpause.Notify":
					break;
				default:
					for (var i : String in event.info) {
						trace(i, event.info[i]);
					}
			}
		}

		private function nsIoError(event:IOErrorEvent):void
		{
			// trace("nsIoError", event.text);
//			dispatchEvent(event);
		}
	}
}
