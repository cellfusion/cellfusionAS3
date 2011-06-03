package jp.cellfusion.prog4.commands.net
{
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.debug.Logger;
	import jp.progression.commands.Command;
	import jp.progression.commands.net.LoadCommand;
	import jp.progression.commands.net.LoadURL;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.data.Resource;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 * LoadURL に fock 処理を追加できるようにしたもの
	 */
	public class LoadData extends LoadCommand
	{
		public function get loader():URLLoader
		{
			return _loader;
		}

		protected var _loader:URLLoader;

		/**
		 * <span lang="ja">ダウンロードしたデータがテキスト（URLLoaderDataFormat.TEXT）生のバイナリデータ（URLLoaderDataFormat.BINARY）、または URL エンコードされた変数（URLLoaderDataFormat.VARIABLES）のいずれであるかを制御します。</span>
		 * <span lang="en">Controls whether the downloaded data is received as text (URLLoaderDataFormat.TEXT), raw binary data (URLLoaderDataFormat.BINARY), or URL-encoded variables (URLLoaderDataFormat.VARIABLES).</span>
		 */
		public function get dataFormat():String
		{
			return _dataFormat;
		}

		public function set dataFormat(value:String):void
		{
			switch ( value ) {
				case URLLoaderDataFormat.BINARY		:
				case URLLoaderDataFormat.TEXT		:
				case URLLoaderDataFormat.VARIABLES	:
					{
						_dataFormat = value;
						break; }
				default								:
					{
						throw new Error(Logger.getLog(L10NNiumMsg.getInstance().ERROR_003).toString("dataFormat")); }
			}
		}

		protected var _dataFormat:String = URLLoaderDataFormat.TEXT;

		/**
		 * <span lang="ja">新しい LoadURL インスタンスを作成します。</span>
		 * <span lang="en">Creates a new LoadURL object.</span>
		 * 
		 * @param request
		 * <span lang="ja">読み込むファイルの絶対 URL または相対 URL を表す URLRequest インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function LoadData(request:URLRequest, initObject:Object = null)
		{
			// クラスをコンパイルに含める
			progression_internal;

			// 親クラスを初期化する
			super(request, initObject);

			// initObject が LoadURL であれば
			var com:LoadData = initObject as LoadData;
			if ( com ) {
				// 特定のプロパティを継承する
				_dataFormat = com._dataFormat;
			}
		}

		/**
		 * @private
		 */
		override protected function executeFunction():void
		{
			// キャッシュを取得する
			var cache:Resource = Resource.progression_internal::$collection.getInstanceById(super.resId || super.request.url) as Resource;

			// キャッシュが存在すれば
			if ( cache is Resource ) {
				// データを保持する
				super.data = cache.data;

				// イベントを送出する
				super.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, cache.bytesTotal, cache.bytesTotal));

				// 処理を終了する
				super.executeComplete();
			} else {
				// URLLoader を作成する
				_loader = new URLLoader();
				_loader.dataFormat = _dataFormat;

				// イベントリスナーを登録する
				_loader.addEventListener(Event.COMPLETE, _complete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, _ioError);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
				_loader.addEventListener(ProgressEvent.PROGRESS, super.dispatchEvent);

				// ファイルを読み込む
				_loader.load(toProperRequest(super.request));
			}
		}

		/**
		 * @private
		 */
		override protected function interruptFunction():void
		{
			// 読み込みを閉じる
			try {
				_loader.close();
			} catch ( err:Error ) {
			}

			// 破棄する
			_destroy();
		}

		/**
		 * 破棄します。
		 */
		protected function _destroy():void
		{
			if ( _loader ) {
				// イベントリスナーを解除する
				_loader.removeEventListener(Event.COMPLETE, _complete);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, _ioError);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
				_loader.removeEventListener(ProgressEvent.PROGRESS, super.dispatchEvent);
			}
		}

		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void
		{
			// 親のメソッドを実行する
			super.dispose();
		}

		/**
		 * <span lang="ja">LoadURL インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an LoadURL subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい LoadURL インスタンスです。</span>
		 * <span lang="en">A new LoadURL object that is identical to the original.</span>
		 */
		override public function clone():Command
		{
			return new LoadURL(super.request, this);
		}

		/**
		 * 受信したすべてのデータがデコードされて URLLoader インスタンスの data プロパティへの保存が完了したときに送出されます。
		 */
		protected function _complete(e:Event):void
		{
			// データを保持する
			super.data = _loader.data;

			// 破棄する
			_destroy();
			
			// データを初期化する
			_initialize();

			// 処理を終了する
			super.executeComplete();
		}

		protected function _initialize():void
		{
		}

		/**
		 * URLLoader.load() の呼び出しによってセキュリティサンドボックスの外部にあるサーバーからデータをロードしようとすると送出されます。
		 */
		protected function _securityError(e:SecurityErrorEvent):void
		{
			// エラー処理を実行する
			super.throwError(this, new SecurityError(e.text));
		}

		/**
		 * URLLoader.load() の呼び出し時に致命的なエラーが発生してダウンロードが終了した場合に送出されます。
		 */
		protected function _ioError(e:IOErrorEvent):void
		{
			// エラー処理を実行する
			super.throwError(this, new IOError(e.text));
		}
	}
}
