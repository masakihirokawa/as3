package jp.atziluth.utils{
	import flash.external.ExternalInterface;
	public class CheckOnline {
		private static var locationHref:String = String(ExternalInterface.call("function(){return location.href}"));;
		public static function get result():Boolean {
			if (CheckOnline.locationHref == null) {
				return (false);
			} else {
				if (CheckOnline.locationHref.substr(0,4) == "http") {
					return (true);
				}
			}
			return (false);
		}
	}
}