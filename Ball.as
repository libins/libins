package cn.libins {
	import flash.display.Sprite;
	
public class Ball extends Sprite {
	  private var _vx:uint       = 0;
	  private var _vy:uint       = 0;
	  private var _color:Number  = 0;
	  private var _radius:Number = 0;
	
		public function Ball(radius:Number =5,color:Number= 0xff0000) {
			this._radius = radius;
			this._color  = color;
			draw();
		}
		
		private function draw() {
		     graphics.clear();
			 graphics.beginFill(_color);
			 graphics.drawCircle(0, 0, _radius);
			 graphics.endFill();
		}
		
	     public function get vx():uint { return _vx; }
	
	     public function set vx(value:uint):void 
	     {
		    _vx = value;
			draw();
	     }
	
	     public function get vy():uint { return _vy; }
	
	     public function set vy(value:uint):void 
	     {
		    _vy = value;
			draw();
	     }
		 
		 public function get radius():Number { return _radius; }
	
	     public function set radius(value:Number):void 
	     {
		    _radius = value;
			draw();
	     }
		 
		 public function updata():void {
		     if (_vx != 0) this.x += _vx;
			 if (_vy != 0) this.y += _vy;
		 }
	}
}