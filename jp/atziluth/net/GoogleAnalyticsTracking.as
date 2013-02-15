package jp.atziluth.net{
	import flash.external.ExternalInterface;
	import flash.utils.escapeMultiByte;
	import jp.atziluth.utils.CheckOnline;
	public class GoogleAnalyticsTracking {
		public static function send(pageTitle:String, jsFunctionName:String="pageTracker._trackPageview", isEscapeMultiByte:Boolean=false):void {
			if (GoogleAnalyticsTracking.isOnline) {
				try {
					if (ExternalInterface.available) {
						if (isEscapeMultiByte) {
							ExternalInterface.call(jsFunctionName, escapeMultiByte(pageTitle));
						} else {
							ExternalInterface.call(jsFunctionName, pageTitle);
						}
					}
				} catch (error:Error) {
					trace(error);
				}
			}
		}
		private static function get isOnline():Boolean {
			return (CheckOnline.result);
		}
	}
}