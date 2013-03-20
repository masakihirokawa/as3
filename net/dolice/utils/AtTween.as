﻿package net.dolice.utils{	public class AtTween {		import flash.display.DisplayObject;		import caurina.transitions.Tweener;		import caurina.transitions.properties.ColorShortcuts;		ColorShortcuts.init();		import caurina.transitions.properties.FilterShortcuts;		FilterShortcuts.init();		private static var Tween:Function = Tweener.addTween;		public static function fadein(		  $scope:DisplayObject,		  $time:Number=.5,		  $transition:String="liner",		  $delay:Number=0,		  $onComplete:Function=null,		  $onCompleteParams:Array=null		):void {			if ($scope == null || $scope.alpha == 1) {				return;			}			$scope.visible = true;			Tween($scope,{			  alpha:1,			  time:$time,			  transition:$transition,			  delay:$delay,			  onComplete:$onComplete,			  onCompleteParams:$onCompleteParams			  });		}		public static function fadeout(		  $scope:DisplayObject,		  $time:Number=.5,		  $transition:String="liner",		  $delay:Number=0,		  $onComplete:Function=null,		  $onCompleteParams:Array=null		):void {			if ($scope==null || ($scope.alpha == 0 && $scope.visible == false)) {				return;			}			var _func:Function = function(){$scope.visible=false;if($onComplete!=null){$onComplete.apply(null,$onCompleteParams)}};			Tween($scope,{			  alpha:0,			  time:$time,			  transition:$transition,			  delay:$delay,			  onComplete:_func			  });		}		public static function ALPHA(		  $scope:DisplayObject,		  $alpha:Number=1.0,		  $time:Number=.5,		  $transition:String="liner",		  $delay:Number=0,		  $onComplete:Function=null,		  $onCompleteParams:Array=null		 ):void {			if ($scope == null) {				return;			}			Tween($scope,{			  alpha:$alpha,			  time:$time,			  transition:$transition,			  delay:$delay,			  onComplete:$onComplete,			  onCompleteParams:$onCompleteParams			  });		}		public static function COLOR(		  $scope:DisplayObject,		  $color:uint=0x000000,		  $time:Number=.5,		  $transition:String="liner",		  $delay:Number=0,		  $onComplete:Function=null,		  $onCompleteParams:Array=null		 ):void {			if ($scope == null) {				return;			}			Tween($scope,{			  _color:$color,			  time:$time,			  transition:$transition,			  delay:$delay,			  onComplete:$onComplete,			  onCompleteParams:$onCompleteParams			  });		}		public static function BLUR(		  $scope:DisplayObject,		  $blur:uint=8,		  $alpha:uint=0,		  $time:Number=.5,		  $transition:String="liner",		  $delay:Number=0,		  $onComplete:Function=null,		  $onCompleteParams:Array=null		):void {			if ($scope == null) {				return;			}			Tween($scope,{			  _Blur_blurX:$blur,			  _Blur_blurY:$blur,			  alpha:$alpha,			  time:$time,			  transition:$transition,			  delay:$delay,			  onComplete:$onComplete,			  onCompleteParams:$onCompleteParams			  });		}		public static function GLOW(		  $scope:DisplayObject,		  $Glow_strength:Number=1.5,		  $Glow_blur:uint=8,		  $Glow_color:uint=0xFFFFFF,		  $Glow_quality:uint=2,		  $time:Number=.5,		  $transition:String="liner",		  $delay:Number=0,		  $onComplete:Function=null,		  $onCompleteParams:Array=null		):void {			if ($scope == null) {				return;			}			Tween($scope,{			  _Glow_strength:$Glow_strength,			  _Glow_blurX:$Glow_blur,			  _Glow_blurY:$Glow_blur,			  _Glow_color:$Glow_color,			  _Glow_quality:$Glow_quality,			  time:$time,			  transition:$transition,			  delay:$delay,			  onComplete:$onComplete,			  onCompleteParams:$onCompleteParams			  });		}	}}