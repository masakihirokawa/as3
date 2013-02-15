﻿package jp.atziluth.net{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Stage;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.text.TextField;
	import caurina.transitions.Tweener;
	import jp.atziluth.utils.*;
	import jp.atziluth.gui.Screen;
	public class ImageLoader extends MovieClip {
		private var _stage:Stage;
		private var control:DisplayObjectContainer;
		private var container:DisplayObjectContainer;
		private var imageHolder:MovieClip;
		private var image:Loader;
		private var aspect:Number;
		private var useTransition:Boolean;
		private var transitionType:String;
		private var toScreenFit:Boolean;
		private var isFullscreen:Boolean;
		private static var onLoadFunction:Function;
		private static var onCompleteFunction:Function;
		private static var isImageStreaming:Boolean = false;
		private var imageLoadProgress:imageLoadClip=new imageLoadClip();
		private var imageLoadProgressBytesTotal:Number;
		private var imageLoadProgressBytesLoaded:Number;
		private var imageLoadProgressPercent:uint;
		private var imageLoadProgressBarscaleX:Number;
		private var Tween:Function = Tweener.addTween;
		private var removeTween:Function = Tweener.removeTweens;
		public function ImageLoader(
		  stage:Stage, 
		  control:DisplayObjectContainer, 
		  container:DisplayObjectContainer, 
		  url:String, 
		  aspect:Number=1.6, 
		  useTransition:Boolean=true, 
		  transitionType:String="Wipe", 
		  toScreenFit:Boolean=true, 
		  isFullscreen:Boolean=false, 
		  onLoadFunction:Function=null, 
		  onCompleteFunction:Function=null
		):void {
			this._stage = stage;
			this.control = control;
			this.container = container;
			this.aspect = aspect;
			this.useTransition = useTransition;
			this.transitionType = transitionType;
			this.toScreenFit = toScreenFit;
			this.isFullscreen = isFullscreen;
			ImageLoader.onLoadFunction = onLoadFunction;
			ImageLoader.onCompleteFunction = onCompleteFunction;
			var imageURL:URLRequest = new URLRequest(url);
			imageHolder = new MovieClip();
			with (imageHolder) {
				name = "bgimage";
				alpha = 0;
				x = 0;
				y = 0;
			}
			container.addChildAt(imageHolder,container.numChildren);
			image = new Loader();
			imageHolder.addChildAt(image, imageHolder.numChildren);
			with (image) {
				contentLoaderInfo.addEventListener(Event.OPEN, onLoadstartHandler);
				contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
				contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOerrorHandler);
				load(imageURL);
			}
		}
		private function onLoadstartHandler(event:Event):void {
			control.addChildAt(imageLoadProgress,control.numChildren);
			with (imageLoadProgress) {
				name = "loader";
				alpha = 0;
				x = 0;
				y = 0;
			}
			if (imageLoadProgress.alpha < 1) {
				Tween(imageLoadProgress,{alpha:1,time:.15,transition:"easeInOutCubic"});
			}
			if (ImageLoader.onLoadFunction != null) {
				ImageLoader.onLoadFunction();
			}
			ImageLoader.isImageStreaming = true;
		}
		private function onProgressHandler(event:ProgressEvent):void {
			imageLoadProgressBytesTotal = event.bytesTotal;
			imageLoadProgressBytesLoaded = event.bytesLoaded;
			imageLoadProgressPercent = Math.floor(imageLoadProgressBytesLoaded / imageLoadProgressBytesTotal * 100);
			imageLoadProgressBarscaleX = imageLoadProgressBytesLoaded / imageLoadProgressBytesTotal;
			imageLoadProgress.getChildByName("bar").scaleX = imageLoadProgressBarscaleX;
			//imageLoadProgress.per.text = imageLoadProgressPercent.toString() + "%";
		}
		private function onCompleteHandler(event:Event):void {
			if (container.alpha < 1) {
				container.alpha = 1;
			}
			Tween(imageLoadProgress,{alpha:0,time:.5,transition:"easeOutExpo",  onComplete:initImage, onCompleteParams:[imageHolder]});
			function initImage(bgimage_mc:MovieClip):void {
				if (useTransition) {
					var transitionImage:MovieClip = new TransitionTween(
					    bgimage_mc,
					    transitionType,
					    0,
					    .5,
					    "Strong.easeIn"
					);
					/*
					bgimage_mc.alpha = 1;
					var transitionManager:TransitionManager = new TransitionManager(bgimage_mc);
					switch (transitionType) {
					case "Fade" :
					transitionManager.startTransition({type:Fade,direction:Transition.IN,duration:2,easing:Regular.easeInOut});
					break;
					case "Squeeze" :
					transitionManager.startTransition({type:Squeeze, direction:Transition.IN, duration:2, easing:Elastic.easeOut, dimension:1});
					break;
					case "PixelDissolve" :
					transitionManager.startTransition({type:PixelDissolve, direction:Transition.IN, duration:.2, easing:Regular.easeIn, xSections:64, ySections:64});
					break;
					case "Zoom" :
					transitionManager.startTransition({type:Zoom, direction:Transition.IN, duration:1, easing:Elastic.easeOut});
					break;
					case "Photo" :
					transitionManager.startTransition({type:Photo, direction:Transition.IN, duration:1, easing:None.easeNone});
					break;
					case "Blinds" :
					transitionManager.startTransition({type:Blinds, direction:Transition.IN, duration:.25, easing:None.easeInOut, numStrips:256, dimension:0});
					break;
					case "Wipe" :
					transitionManager.startTransition({type:Wipe, direction:Transition.IN, duration:1, easing:Strong.easeInOut, startPoint:1});
					break;
					default :
					transitionManager.startTransition({type:Wipe, direction:Transition.IN, duration:.5, easing:Strong.easeInOut, startPoint:1});
					break;
					}
					transitionManager.addEventListener(TweenEvent.MOTION_FINISH, onCompleteTransitionManager);
					*/
				} else {
					Tween(bgimage_mc,{alpha:1,time:.5,transition:"easeInOutCubic", onComplete:onCompleteTweener()});
				}
				/*
				function onCompleteTransitionManager(event:Event):void {
				transitionManager.removeEventListener(TweenEvent.MOTION_FINISH, onCompleteTransitionManager);
				transitionManager = null;
				onFinishTween();
				}
				*/
				function onCompleteTweener():void {
					removeTween(bgimage_mc);
					onFinishTween();
				}
				function onFinishTween():void {
					if (toScreenFit) {
						Screen.fit(container,false,aspect,isFullscreen);
						ImageLoader.toSmoothingImage(event.target.content);
					}
					removeImageLoaderEventListener();
					Cleaner.deleteMovieClip(imageHolder,1,null);
					Cleaner.deleteContainer(container,1,null);
				}
				Cleaner.deleteContainer(imageLoadProgress,0,null);
			}
			if (ImageLoader.onCompleteFunction != null) {
				ImageLoader.onCompleteFunction();
			}
			ImageLoader.isImageStreaming = false;
		}
		private function onIOerrorHandler(event:IOErrorEvent):void {
			trace("IO_ERROR: " + event);
		}
		private function removeImageLoaderEventListener():void {
			with (image) {
				contentLoaderInfo.removeEventListener(Event.OPEN, onLoadstartHandler);
				contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
				contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOerrorHandler);
			}
		}
		public static function toSmoothingImage($bmp:Bitmap):void {
			var bmp:Bitmap = Bitmap($bmp);
			bmp.smoothing = true;
		}
		public static function get streaming():Boolean {
			return ImageLoader.isImageStreaming;
		}
		public static function get complete():Boolean {
			return !ImageLoader.isImageStreaming;
		}
	}
}