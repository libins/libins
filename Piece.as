package cn.libins {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.*;
	import flash.events.Event;
	public class Piece extends Sprite {
		public static var picType:Number = 0;
		private var dis:Number = 2.5;
		private var mloader:Loader;
		public var colum:uint;
		public var row:uint;
		private var _type:Number;
		private var folderPath:String = "image\\";
		private var mObject:Object;
		public var lineRect:Sprite;
		private var lineColor:Number = 0xFFFF00;
		
		public function Piece(object:Object) {
			colum = object.col;
			row = object.row;
			mObject = object;
			this.x =  mObject.col * mObject.space;
			this.y =  mObject.row * mObject.space;
			_type = Math.ceil(Math.random() * object.picType);
			mloader = new Loader();
			mloader.load(new URLRequest(folderPath + _type + ".png"));
			mloader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			
			}
			
		public function get type():Number { return _type; }
		
		
		private function loadComplete(event:Event):void {
			var pic:Bitmap = (mloader.content as Bitmap);
			pic.smoothing = true;
			this.addChild(pic);
			//pic.x = pic.y =1;
			this.width =this.height=  mObject.space-dis;
			draw();
		}
		   
		
		
		private function draw() {
			lineRect = new Sprite();
			lineRect.graphics.lineStyle(1, lineColor);
			lineRect.graphics.drawRect(0, 0, mObject.space, mObject.space);
			this.addChild(lineRect);
			lineRect.visible = false;
			}
		}
	}