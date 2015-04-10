package cn.libins{
	import flash.display.*;
	import flash.net.*;
	import flash.geom.*;
	import flash.events.*;
	/*
	*倒影类 v01
	*作者:libins 
	*/
	public class Reflection extends Sprite{
		private var _picLoader:Loader;
		private var _dis:Number = 0;
		private var _bmp:Bitmap;
		private var _showHeight:Number = 1.5;
		private var _picScale:Number = 0.5;
		public function Reflection(picPath:String,picScale:Number=1,dis:Number = 0){
			loadPic(picPath);
			_dis = dis;
			_picScale = picScale;
		}
		
		private function loadPic(picPath:String):void{
		    _picLoader = new Loader();
			_picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,picLoaded);
			_picLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,picProgres);
			_picLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, picError);
			_picLoader.load(new URLRequest(picPath));
		}
		
		private function picProgres(event:ProgressEvent):void{
		    
		}
		
		private function picError(event:IOErrorEvent):void{
		     trace("加载出错！！");
		}
		
		private function picLoaded(event:Event):void{
			 var picWidth:Number = _picLoader.width;
			 var picHeight:Number = _picLoader.height;
			 
			 var orgBMD:BitmapData = new BitmapData(picWidth,picHeight*_showHeight,true,0xffffffff);
			 orgBMD.draw(_picLoader);
			 
			 var reflectBMD:BitmapData = new BitmapData(picWidth,picHeight,true,0xffffffff);
			 var reflectMat:Matrix = new Matrix(1,0,0,-1,0,picHeight);
			 reflectBMD.draw(_picLoader,reflectMat);
			 
			 reflectMat = new Matrix(1,0,0,1,0,picHeight);
             reflectMat.createGradientBox(picWidth, picHeight, Math.PI/2, 0, 0);
			 
			 var shape:Shape = new Shape();
			 shape.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0.5,0],[0,100],reflectMat);
			 shape.graphics.drawRect(0,0,picWidth,picHeight);
			 
			 var rAlphaBMD:BitmapData = new BitmapData(picWidth,picHeight,true,0x00ffffff);
			 rAlphaBMD.draw(shape);
			 
			 var pt:Point = new Point(0,0);
			 var rt:Rectangle = new Rectangle(0,0,picWidth,picHeight);
			 reflectBMD.copyPixels(reflectBMD,rt,pt,rAlphaBMD,pt,false);
			 orgBMD.copyPixels(reflectBMD,rt,new Point(0,picHeight+_dis));
			 
			 _bmp = new Bitmap(orgBMD);
			 _bmp.scaleX = _bmp.scaleY = _picScale;
			 addChild(_bmp);
		}
	}
}