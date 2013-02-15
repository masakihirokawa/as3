﻿package jp.atziluth.net{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import caurina.transitions.Tweener;
	public class MiniLoader extends MovieClip {
		private var $parent:DisplayObjectContainer;
		public var $child:DisplayObject;
		private var loader:Loader = new Loader();
		private var contentLoaderInfo:LoaderInfo;
		private var urlRequest:URLRequest;
		protected static var onLoadFunction:Function;
		protected static var onCompleteFunction:Function;
		private static var isLoading:Boolean = false;
		private static var progressBytesTotal:Number;
		private static var progressBytesLoaded:Number;
		private static var progressPercent:uint;
		private static var childFadeInParams:Array = [.25,"liner",0];
		private var Tween:Function = Tweener.addTween;
		private var removeTween:Function = Tweener.removeTweens;
		public function load(
		    container:DisplayObjectContainer,
		    url:String,
		    onLoadFunction:Function=null,
		    onCompleteFunction:Function=null
		):void {
			addLoadContainer(container);
			initLoadParams(url);
			MiniLoader.onLoadFunction = onLoadFunction;
			MiniLoader.onCompleteFunction = onCompleteFunction;
			addLoadEventListener();
			startLoad();
		}
		/*
		private var isRepeat:Boolean;
		private var isLoop:Boolean;
		private var loopNum:uint;
		public function repeat(
		    container:DisplayObjectContainer,
		    urlList:Array,
		    loop:Boolean=false
		):void {
		load(container, urlList[0]);
		isRepeat = true;
		isLoop = loop;
		}
		*/
		private function addLoadContainer(container:DisplayObjectContainer):void {
			$child = loader.content;
			$parent = container;
			$parent.addChildAt(loader, $parent.numChildren);
		}
		private function initLoadParams(url:String):void {
			urlRequest = new URLRequest(url);
			contentLoaderInfo = loader.contentLoaderInfo;
		}
		private function startLoad():void {
			loader.load(urlRequest);
		}
		private function onLoadHandler(event:Event):void {
			with (loader) {
				visible = false;
				alpha = 0;
			}
			if (MiniLoader.onLoadFunction != null) {
				MiniLoader.onLoadFunction();
			}
			MiniLoader.isLoading = true;
		}
		private function onProgressHandler(event:ProgressEvent):void {
			MiniLoader.bytesTotal = event.bytesTotal;
			MiniLoader.bytesLoaded = event.bytesLoaded;
			MiniLoader.percent = Math.floor(MiniLoader.bytesLoaded / MiniLoader.bytesTotal * 100);
		}
		private function onCompleteHandler(event:Event):void {
			if (loader.alpha < 1) {
				Tween(loader, {
				    visible:true,
				    alpha:1,
				    time:MiniLoader.childFadeInSecond,
				    transition:MiniLoader.childFadeInEase,
				    delay:MiniLoader.childFadeInDelay,
				    onComplete:removeTween,
				    onCompleteParams:[loader]
				});
			}
			removeLoadEventListener();
			if (MiniLoader.onCompleteFunction != null) {
				MiniLoader.onCompleteFunction();
			}
			MiniLoader.isLoading = false;
		}
		private function onIOErrorHandler(event:IOErrorEvent):void {
			trace(event);
		}
		private function addLoadEventListener():void {
			contentLoaderInfo.addEventListener(Event.OPEN, onLoadHandler);
			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		private function removeLoadEventListener():void {
			contentLoaderInfo.removeEventListener(Event.OPEN, onLoadHandler);
			contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		public static function get loading():Boolean {
			return (MiniLoader.isLoading);
		}
		public static function get complete():Boolean {
			return !(MiniLoader.isLoading);
		}
		public static function set bytesTotal(bytes:Number):void {
			MiniLoader.progressBytesTotal = bytes;
		}
		public static function get bytesTotal():Number {
			return (MiniLoader.progressBytesTotal);
		}
		public static function set bytesLoaded(bytes:Number):void {
			MiniLoader.progressBytesLoaded = bytes;
		}
		public static function get bytesLoaded():Number {
			return (MiniLoader.progressBytesLoaded);
		}
		public static function set percent(rate:uint):void {
			MiniLoader.progressPercent = rate;
		}
		public static function get percent():uint {
			return (MiniLoader.progressPercent);
		}
		public static function set childFadeInSecond(sec:Number):void {
			MiniLoader.childFadeInParams[0] = sec;
		}
		public static function get childFadeInSecond():Number {
			return (MiniLoader.childFadeInParams[0]);
		}
		public static function set childFadeInEase(ease:String):void {
			MiniLoader.childFadeInParams[1] = ease;
		}
		public static function get childFadeInEase():String {
			return (MiniLoader.childFadeInParams[1]);
		}
		public static function set childFadeInDelay(delay:Number):void {
			MiniLoader.childFadeInParams[2] = delay;
		}
		public static function get childFadeInDelay():Number {
			return (MiniLoader.childFadeInParams[2]);
		}
	}
}