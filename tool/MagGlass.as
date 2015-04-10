package cn.libins.tool{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	public class MagGlass extends Sprite {
		private const MAXSIZE       :uint  = 2880;
		private var _zoom           :Number;
		private var _zoomSmall      :Number;
		private var _imageW         :Number;
		private var _imageH         :Number;
	    private var _imageBitmap    :Bitmap;
		private var _newBitmap      :Bitmap;
		private var _imageBitmapData:BitmapData;
		private var _dataW          :Number;
		private var _dataH          :Number;
		private var _filtered       :Boolean;
		private var _glassSp        :Sprite;
		private var _isZooming      :Boolean;
		private var _Stage          :Object;
		private var _target         :DisplayObject;
 		/*
		 * Param1 需要缩放的对象
		 * Param2 缩放的倍数,默认为3倍
		 * Param3 显示框的宽度
		 * Param4 显示框的高度
		 * Param5 是否添加阴影滤镜
		 */
		public function MagGlass($target:DisplayObject, $zoom:Number = 3, $width:Number = 100, $height:Number = 80, $filtered:Boolean = true) {
			trace("MagGlass v01");
			if ($target is Bitmap) {
			     _imageBitmap = $target as Bitmap;	
			}else {
				 _imageBitmap = getBitmap($target);
			}
			_imageBitmap.scaleX = $zoom;
			_imageBitmap.scaleY = $zoom; 
			if (_imageBitmap.width > MAXSIZE || _imageBitmap.width > MAXSIZE) {
				  trace("图片尺寸超过范围！");
			      return;	
			}
			var newSp:Sprite    = new Sprite();
			newSp.addChild(_imageBitmap);
			_newBitmap          = getBitmap(newSp);
			_imageBitmapData    = _newBitmap.bitmapData;
			_target             = $target;
			_zoom               = $zoom;
			_imageW             = $width;
			_imageH             = $height;
			_filtered           = $filtered;
			this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		
		private function addToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			_Stage = stage;
			initGlass();
			initEvent(_target);
		}
		
		private function initGlass():void {
			_glassSp = new Sprite();
			_glassSp.buttonMode = _glassSp.mouseChildren = _glassSp.mouseEnabled = false;
			if(_filtered) _glassSp.filters = [new DropShadowFilter()];
			addChild(_glassSp);
		}
		
		private function initEvent($target:DisplayObject):void {
			 $target.addEventListener(MouseEvent.ROLL_OUT,  targetOut,true);
             $target.addEventListener(MouseEvent.MOUSE_DOWN, targetDown);
		     _Stage.addEventListener(MouseEvent.MOUSE_UP,  targetOut);	
		}
		
		
		private function targetDown(event:MouseEvent):void {
			_isZooming = true;
			Mouse.hide();
			var hitPoint:Point = new Point(event.localX, event.localY);
			//trace("hitPoint",hitPoint);
			_glassSp.x = this.mouseX- _imageW / 2;
			_glassSp.y = this.mouseY- _imageH / 2;
			ShowBig(hitPoint);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE,targetMove);
		}
		
		private  function glassClear():void {
		     _glassSp.graphics.clear();
	    }
		private function targetOut(event:MouseEvent):void {
			 _isZooming = false;
			 glassClear();
			 Mouse.show();
			 this.removeEventListener(MouseEvent.MOUSE_MOVE,targetMove);
		}
		
		private function targetMove(event:MouseEvent):void {
			   var movePoint:Point = new Point(_target.mouseX, _target.mouseY);
			   //trace("movePoint",movePoint);
			   _glassSp.x         = this.mouseX- _imageW / 2;
			   _glassSp.y         = this.mouseY- _imageH / 2;
			   ShowBig(movePoint);
			   event.updateAfterEvent();
		}
		
		private function getBitmap($target:DisplayObject):Bitmap {
			var bitmapData:BitmapData = new BitmapData($target.width, $target.height,true,0xffff0000);
			bitmapData.draw($target);
			return new Bitmap(bitmapData);
		}
		
		/*
		 * Param1 坐标,即需要显示的坐标中点
		 */
		private function ShowBig($point:Point) {
			drawGlass(new Point($point.x*_zoom,$point.y*_zoom));
		}
		
		private function drawGlass($point:Point):void {
			 var curBitmapData:BitmapData;
			 var curBitmap    :Bitmap;
			 var startX       :Number = $point.x - _imageW / 2;
			 var startY       :Number = $point.y - _imageH / 2;
			 curBitmap                = new Bitmap(new BitmapData(_imageW, _imageH));
			 curBitmap.bitmapData.copyPixels(_imageBitmapData, new Rectangle(startX, startY, _imageW, _imageH), new Point(0, 0));
			 curBitmapData            = curBitmap.bitmapData;
			 _glassSp.graphics.clear();
			 _glassSp.graphics.lineStyle();
			 _glassSp.graphics.beginBitmapFill(curBitmapData);
			 _glassSp.graphics.drawRect(0, 0, _imageW, _imageH);
			 _glassSp.graphics.endFill();
		}
	}
}