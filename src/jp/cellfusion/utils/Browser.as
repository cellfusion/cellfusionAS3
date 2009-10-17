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
		private static var _isOpera:Boolean;		private static var _isLunascape:Boolean;		private static var _isChrome:Boolean;
		private static var _ua:String;
		private static const MSIE_RE:RegExp = /msie\ (\d+(\.\d+){1,3})/i;
		private static const SAFARI_RE:RegExp = /Version\/(\d+\(\.\d+){1,2})\ Safari\/(\d+\(\.\d+){1,2})/i;
		private static const FIREFOX_RE:RegExp = /Firefox\/(\d+(\.\d+){1,2})/i;
		private static const GECKO_RE:RegExp = /Gecko\/(\d+)/i;
		private static const OPERA_RE:RegExp = /Opera\/(\d+\.\d+)/i;
		private static const LUNA_RE:RegExp = /Lunascape\ (\d+(\.\d+){1,2}( .+\d+)?)/i;
		private static const CHROME_RE:RegExp = /Chrome\/(\d+(\.\d+){1,3})/i;
		private static var _isReady:Boolean;

		static public function initialize():void
		{
			if (_isReady) {
				return;
			}
			
			if (!ExternalInterface.available) {
				trace('ExernalInterface が使用できません');
				return;
			}
			
			_ua = ExternalInterface.call('function getUA() { return navigator.userAgent; }');
			
			_isIE = MSIE_RE.test(_ua);
			_isFirefox = FIREFOX_RE.test(_ua);
			_isSafari = SAFARI_RE.test(_ua);
			_isGecko = GECKO_RE.test(_ua);			_isOpera = OPERA_RE.test(_ua);			_isLunascape = LUNA_RE.test(_ua);			_isChrome = CHROME_RE.test(_ua);
			
			_isReady = true;
		}
		
		static public function popup(request:URLRequest, width:uint, height:uint, id:String = "_blank"):void
		{
			if (!_isReady) {
				initialize();
			}
			
			if (_isIE) {
				popupEIexecute(request, width, height, id);
			} else if (_isFirefox) {
				popupEIexecute(request, width, height, id);
			} else if (_isSafari) {
				if (!popupEIexecute(request, width, height, id)) {
					blankWindow(request);
				}
			} else if (_isChrome) {
				if (!popupEIexecute(request, width, height, id)) {
					blankWindow(request);
				}
			} else if (_isOpera) {
				popupEIexecute(request, width, height, id);
			} else if (_isLunascape) {
				popupEIexecute(request, width, height, id);
			} else {
				popupEIexecute(request, width, height, id);
			}
		}
		
		public static function blankWindow(request:URLRequest):void
		{
			if (!_isReady) {
				initialize();
			}
			
//			trace('blankWindow');
			if (_isIE) {
				ExternalInterface.call('window.open', request.url, "_blank");
			} else if (_isFirefox) {
				ExternalInterface.call('window.open', request.url, "_blank");
			} else if (_isSafari) {
				navigateToURL(request, "_blank");
			} else if (_isChrome) {
				navigateToURL(request, "_blank");
			} else if (_isOpera) {
				ExternalInterface.call('window.open', request.url, "_blank");
			} else if (_isLunascape) {
				ExternalInterface.call('window.open', request.url, "_blank");
			} else {
				ExternalInterface.call('window.open', request.url, "_blank");
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
