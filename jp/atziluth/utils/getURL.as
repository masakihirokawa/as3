﻿package jp.atziluth.utils{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	public function getURL(url:String, target:String="_self"):void {
		if (url == null) {
			return;
		}
		try {
			navigateToURL(new URLRequest(url),target);
		} catch (error:Error) {
			return;
		}
	}
}