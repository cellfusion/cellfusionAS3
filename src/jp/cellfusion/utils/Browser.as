package jp.cellfusion.utils 
{
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class Browser 
	{
		private static var _isIE:Boolean;
		private static var _isGecko:Boolean;
		private static var _isFirefox:Boolean;
		private static var _isSafari:Boolean;
		private static var _ua:String;
		private static const MSIE_RE:RegExp = /msie\ (\d+\.\d+)/i;
		private static const SAFARI_RE:RegExp = /Version\/(\d+\.\d+\.\d+)\ Safari\/(\d+\.\d+)/i;
		private static const FIREFOX_RE:RegExp = /Firefox\/(\d+\.\d+\.\d+)/i;
		private static const GECKO_RE:RegExp = /Gecko\/(\d+)/i;

		static public function initialize():void
		{
			if (!ExternalInterface.available) {
				trace('ExernalInterface が使用できません');
				return;
			}
			
			_ua = ExternalInterface.call('function getUA() { return navigator.userAgent; }');
			
			_isIE = MSIE_RE.test(_ua);
			_isFirefox = FIREFOX_RE.test(_ua);
			_isSafari = SAFARI_RE.test(_ua);
			_isGecko = GECKO_RE.test(_ua);;
		}
		
		static public function popup(request:URLRequest, width:uint, height:uint, id:String = "_blank"):void
		{
			if (_isIE) {
				popupEIexecute(request, width, height, id);
			} else if (_isFirefox) {
				popupEIexecute(request, width, height, id);
			} else if (_isSafari) {
				if (!popupEIexecute(request, width, height, id)) {
					blankWindow(request);
				}
			}
		}
		
		public static function blankWindow(request:URLRequest):void
		{
//			trace('blankWindow');
			if (_isIE) {
				ExternalInterface.call('window.open', request.url, "_blank");
			} else if (_isFirefox) {
				ExternalInterface.call('window.open', request.url, "_blank");
			} else if (_isSafari) {
				navigateToURL(request, "_blank");
			}
		}

		private static function popupEIexecute(request:URLRequest, width:uint, height:uint, id:String):Boolean
		{
			var result:* = ExternalInterface.call('openSubWindow', request.url, width, height);
			return result;
		}

		static public function get version():Number
		{
			if (_isIE) {
				var av:String = ExternalInterface.call('window.navigator.appVersion');
				av.toLowerCase();
				
				return Number(MSIE_RE.exec(_ua)[1]);
			}
			
			return 0;
		}
	}
}
