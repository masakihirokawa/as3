package jp.atziluth.gui{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	public class ScreenFit extends Sprite {
		private var _stage:Stage;
		private var sw:uint;
		private var sh:uint;
		private var $scope:DisplayObjectContainer;
		private var aspectReferenceSource:Boolean;
		private var aspect:Number;
		private var absolutelyFit:Boolean;
		public function ScreenFit(
		stage:Stage, 
		$scope:DisplayObjectContainer, 
		aspectReferenceSource:Boolean=true, 
		aspect:Number=1.6, 
		absolutelyFit:Boolean=false
		):void {
			if ($scope == null) {
				throw new ArgumentError("screenFit クラスのターゲットが存在しません。");
				return;
			}
			this._stage = stage;
			this.$scope = $scope;
			this.aspectReferenceSource = aspectReferenceSource;
			this.aspect = aspect;
			this.absolutelyFit = absolutelyFit;
			init();
		}
		private function init():void {
			sw = _stage.stageWidth;
			sh = _stage.stageHeight;
			if (absolutelyFit) {
				$scope.width = sw;
				$scope.height = sh;
			} else {
				if (aspectReferenceSource) {
					aspect = $scope.width / $scope.height;
				}
				$scope.width = sw;
				$scope.height = sw / aspect;
				if ($scope.height < sh) {
					$scope.height = sh;
					$scope.width = sh * aspect;
				}
				centering($scope);
			}
			/*
			trace("$scope.x: "+$scope.x+" | "+
			  "$scope.y: "+$scope.y+" | "+
			  "$scope.width: "+$scope.width+" | "+
			  "$scope.height: "+$scope.height+" | "+
			  "aspectReferenceSource: "+aspectReferenceSource+" | "+
			  "aspect: "+aspect+" | "+
			  "absolutelyFit: "+absolutelyFit
			);
			*/
		}
		private function centering($scope:DisplayObjectContainer):void {
			if ($scope.width >= sw) {
				$scope.x = (sw-$scope.width)/2;
			}
			if ($scope.height >= sh) {
				$scope.y = (sh-$scope.height)/2;
			}
		}
	}
}