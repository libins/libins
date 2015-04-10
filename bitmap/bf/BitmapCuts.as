package cn.libins.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import __AS3__.vec.Vector;
	import gs.TweenLite;
    import fl.transitions.easing.*;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	/**
	 * v01
	 * @author libins
	 */
	public class BitmapCuts extends Sprite 
	{
		private var _oldBitmap:Bitmap;
		private var _wNum     :uint;
		private var _hNum     :uint;
		private var _debug    :Boolean = false;
		private var _sprites  :Vector.<Sprite>;
		private var _stage    :Stage;
		private var _disNum   :uint;
		private var _initX    :Number;
		private var _initY    :Number;
		private var _delayInt :Number;
		private var _disX     :Number;
		private var _disY     :Number;
		private var _disZ     :Number;
		private var _disA     :Number;
		private var _currNum  :uint;
		private var _total    :uint;
		private var _closeIcon:MovieClip;
		/*
		 * Param1 需要运动的对象
		 * Param2 横坐标个数
		 * Param3 纵坐标个数
		 * Param4 小框之间距离
		 * Param5 偏移的X坐标
		 * Param6 偏移的Y坐标
		 * Param7 偏移的Z坐标
		 * Param8 偏移的alpha坐标
		 */
		public function BitmapCuts($target:DisplayObject, $wNum:uint = 5, $hNum:uint = 5, $disNum:uint = 5, $disX:Number = 100,$disY:Number = 100,$disZ:Number = 100,$disA:Number = 0.5) {
			 if ($target is Bitmap) {
				 _oldBitmap = $target as Bitmap;
			 }else {
				 _oldBitmap = getBitmap($target);
			 }
			 _wNum    = $wNum;
			 _hNum    = $hNum;
			 _disNum  = $disNum;
			 _sprites =  new Vector.<Sprite>();
	     	 _initX   = $target.x;
		     _initY   = $target.y;
			 _disX    = $disX;
			 _disY    = $disY;
			 _disZ    = $disZ;
			 _disA    = $disA;
			 _total   = $wNum * $hNum;
			 $target.visible = false;
			 addEventListener(Event.ADDED_TO_STAGE, addToStage);
			 // initEvent($target);
		}
		
		private function addToStage(event:Event):void {
		     removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			 _stage   = stage;
			 startCuts(_wNum, _hNum, _disNum);
		}
		
		private function startCuts($wNum:uint, $hNum, $disNum):void {
		     var width :Number  = _oldBitmap.width / $wNum;
			 var height:Number  = _oldBitmap.height / $hNum;
			 var i     :uint    = 0;
			 while (i<$wNum) 
			 {
				 var j:uint     = 0;
				 while (j<$hNum) 
				 {
					 var bitmapData:BitmapData = new BitmapData(width, height,true,0xff334455);
					 bitmapData.copyPixels(_oldBitmap.bitmapData, new Rectangle(i * width, j * height, width, height),new Point(0,0));
					 var mc:MovieClip          =  makeSprite(bitmapData, width, height);
					 mc.x                      = _initX + (width + _disNum) * i;
					 mc.y                      = _initY+(height + _disNum) * j;
					 mc.name                   = i + "_" + j;
					 mc.i                      = i;
					 mc.j                      = j;
					 mc.moveed                 = false;
					 mc.addEventListener(MouseEvent.CLICK, spClick);
					 addChild(mc);
					 j++; 
					 _sprites.push(mc);
				 }
				 i++;
			 }
		}
		
		private function makeSprite($bitmapData:BitmapData,$width:Number,$height:Number):MovieClip {
			var mc :MovieClip = new MovieClip();
			 mc.graphics.clear();
			 //if(_debug)  mc.graphics.lineStyle(1);
			 mc.graphics.beginBitmapFill($bitmapData);
			 mc.graphics.drawRect(0, 0, $width, $height);
			 mc.graphics.endFill();
			 return  mc;
		}
		
		private function getBitmap($target:DisplayObject):Bitmap {
		     var bitmapData:BitmapData = new BitmapData($target.width, $target.height, true);
			 bitmapData.draw($target);
			 return new Bitmap(bitmapData);
		}
		
		/*private function initEvent($mc:DisplayObject):void {
			 $mc.addEventListener(MouseEvent.CLICK, picClick);
		}*/
		
		private function spClick(event:MouseEvent):void {
			var mc:MovieClip = event.currentTarget as MovieClip;
			moveSP(mc.i,mc.j);
		}
		
		private function moveSP($i:uint, $j:uint) {
			var mc:MovieClip = this.getChildByName($i + "_" + $j) as MovieClip;
			if (mc.moveed) return;
			_currNum    = 0;
			mc.endX     = mc.x +_disX;
			mc.endY     = mc.y +_disY;
			mc.endZ     = mc.z +_disZ;
			mc.endA     = _disA;
			mc.moveed   = true;
			_delayInt   = setTimeout(checkPoint, 50, $i, $j);
			mc.interval = _delayInt;
			TweenLite.to(mc, 2, { x:mc.endX, z:mc.endZ, y:mc.endY, alpha:mc.endA, ease:Elastic.easeOut,onComplete:removeInterval,onCompleteParams:[mc.interval]} );
			
		}
		
		private function removeInterval($interval:Number):void {
			clearTimeout($interval);
			_currNum  ++;
			if (_currNum == _total) {
			     showCloseIcon();
			}
		}
		private function checkPoint($i:uint, $j:uint):void {
			 //left
			 if ($i > 0) moveSP($i - 1, $j);
			 //up
			 if ($j > 0) moveSP($i, $j - 1);
			 //right
			 if ($i < _wNum - 1) moveSP($i + 1, $j);
			 //down
			 if ($j < _hNum - 1)  moveSP($i , $j + 1);
			 //
		}
		
		
		private function showCloseIcon():void {
			
		}
		
		public function get wNum():uint { return _wNum; }
		
		public function set wNum(value:uint):void 
		{
			_wNum = value;
		}
		
		public function get hNum():uint { return _hNum; }
		
		public function set hNum(value:uint):void 
		{
			_hNum = value;
		}
		
		public function get disNum():uint { return _disNum; }
		
		public function set disNum(value:uint):void 
		{
			_disNum = value;
		}
	}
	
}