package jp.atziluth.utils{
	import jp.atziluth.utils.CheckOnline;
	public class CachedURL {
		private var convertedURL:String;
		public function get(url:String):String {
			convertedURL = CheckOnline.result ? url + "?" + Math.floor(Math.random() * 100):url;
			return (convertedURL);
		}
	}
}