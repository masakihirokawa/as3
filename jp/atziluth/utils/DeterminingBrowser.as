﻿package jp.atziluth.utils{
	import flash.external.ExternalInterface;
	public class DeterminingBrowser {
		private var _userAgent:String;
		private var userAgentToLowerCase:String;
		private const IE:String = "IE";
		private const FIREFOX:String = "Firefox";
		private const OPERA:String = "Opera";
		private const SAFARI:String = "Safari";
		private const CHROME:String = "Chrome";
		private const UNKNOWN:String = "Unknown";
		private const ERROR:String = "Error";
		public function DeterminingBrowser():void {
			if (ExternalInterface.available) {
				userAgentToLowerCase = ExternalInterface.call("window.navigator.userAgent.toLowerCase");
				/*
				switch (userAgentToLowerCase) {
				case "msie" :
				_userAgent = IE;
				break;
				case "firefox" :
				_userAgent = FIREFOX;
				break;
				case "opera" :
				_userAgent = OPERA;
				break;
				case "safari" :
				_userAgent = SAFARI;
				break;
				case "chrome" :
				_userAgent = CHROME;
				break;
				default :
				_userAgent = UNKNOWN;
				break;
				}
				*/
				if (userAgentToLowerCase.indexOf("msie") > -1) {
					_userAgent = IE;
				} else if (userAgentToLowerCase.indexOf("firefox") > -1) {
					_userAgent = FIREFOX;
				} else if (userAgentToLowerCase.indexOf("opera") > -1) {
					_userAgent = OPERA;
				} else if (userAgentToLowerCase.indexOf("safari") > -1) {
					_userAgent = SAFARI;
				} else if (userAgentToLowerCase.indexOf("chrome") > -1) {
					_userAgent = CHROME;
				} else {
					_userAgent = UNKNOWN;
				}
			} else {
				trace("DeterminingBrowser: ExternalInterface is not available");
				_userAgent = ERROR;
			}
		}
		public function get userAgent():String {
			if (_userAgent) {
				return (_userAgent);
			} else {
				trace("DeterminingBrowser: _userAgent is null");
				return (ERROR);
			}

		}
	}
}