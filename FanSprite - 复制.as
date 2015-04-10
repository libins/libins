package cn.libins{
	import flash.display.Sprite;
    import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/*2D扇形工具 V01
	*作者：Libins
	*时间: 2009-9-23
	*/
	public class FanSprite extends Sprite {
		private var mySp         :Sprite;
		public  var Rotation     :Number;
		public  var orgX         :Number;
		public  var orgY         :Number;
		public  var endX         :Number;
		public  var endY         :Number;
		public  var moveRotation :Number;
		private var yidong       :Number;
		private var speed        :Number;

		public function FanSprite() {
			initSP();
		}
		
		private function initSP():void {
			mySp = new Sprite();
			addChild(mySp);

		}
		     //参数说明：  X座标   Y座标     半径            开始角度       结束角度       高度           上面的颜色     左边的颜色        右边的颜色        前边的颜色      时间间隔   Y轴的比例
		public function drawSector(x:Number, y:Number, radius:Number, sAngle:Number, lAngle:Number,sheight:Number,upColor:Number,leftColor:Number,rightColor:Number,frontColor:Number,delay:Number,scale:Number = 0.6,yidong:Number = 40,speed:Number = 5) {
			
            moveRotation = Math.PI*(sAngle+lAngle)/360;
		    orgX         = mySp.x;
	        orgY         = mySp.y;
			this.yidong  = yidong;
			this.speed   = speed;
	        mouseEvent(this);
			
			var leftSP:Sprite  = new Sprite();
			var rightSP:Sprite = new Sprite();
			var frontSP:Sprite = new Sprite();
			var upSP:Sprite    = new Sprite();

			mySp.addChild(rightSP);
			mySp.addChild(leftSP);
			mySp.addChild(frontSP);
			mySp.addChild(upSP);
			mySp.x = -x;
			mySp.y = -y;

			//位置排列
			//trace("1",sAngle,lAngle);
			sAngle %=360;
			lAngle %=360;
			//trace("2",sAngle,lAngle);
			if (lAngle<sAngle) {
				lAngle+=360;
			}
			//if(sAngle>270) sAngle -=360;
			//trace("3",sAngle,lAngle);
			if (sAngle>-90&&sAngle<90||sAngle>270&&sAngle<360) {
				mySp.setChildIndex(rightSP,0);
				//trace("s1");
			} else {
				mySp.setChildIndex(rightSP,2);
				//trace("s2");
			}
			if (lAngle>90&&lAngle<270) {
				mySp.setChildIndex(leftSP,0);
				//trace("e1");
			} else if(lAngle>270&&lAngle<=360) {
				//trace(lAngle)
				mySp.setChildIndex(leftSP,2)
			}else {
				mySp.setChildIndex(leftSP,1);
				//trace("e2");
			}
			//关键点的定位
			var p1:Point   = new Point();
			var p2:Point   = new Point();
			var p3:Point   = new Point();
			var p4:Point   = new Point();

			var sx = radius;
			var sy = 0;
			if (sAngle != 0) {
				sx = Math.cos(sAngle * Math.PI/180) * radius;
				sy = Math.sin(sAngle * Math.PI/180) * radius;
			}
			// g.moveTo(x, y)
			// g.lineTo(x + sx, y +sy);
			p1.x = x;
			p1.y = y;
			p2.x = x+sx;
			p2.y = y+sy;
			p4.x = p2.x;
			p4.y = p2.y;
			//画右图
			rightSP.graphics.beginFill(rightColor);
			rightSP.graphics.moveTo(p1.x,p1.y);
			rightSP.graphics.lineTo(p2.x,p2.y);
			rightSP.graphics.lineTo(p2.x,p2.y+sheight);
			rightSP.graphics.lineTo(p1.x,p1.y+sheight);
			rightSP.graphics.endFill();

			var a =  lAngle * Math.PI / 180 / lAngle;
			var cos = Math.cos(a);
			var sin = Math.sin(a);
			var startID:uint = sAngle;

			var myInterval:Number = setInterval(drawSX,delay,startID);

			function drawSX(id:uint) {
				var nx = cos * sx - sin * sy;
				var ny = cos * sy + sin * sx;
				sx = nx;
				sy = ny;
				p3.x = sx + x;
				p3.y = sy + y;
				drawfrontSP(frontSP,p4,new Point(p4.x,p4.y+sheight),new Point(p3.x,p3.y+sheight),p3);
				drawleftSP(leftSP,p1,p3,new Point(p3.x,p3.y+sheight),new Point(p1.x,p1.y+sheight));
				drawupSP(upSP,p1,p4,p3);
				if ((startID++)==lAngle) {
					clearInterval(myInterval);
				}
				p4.x = p3.x;
				p4.y = p3.y;
			}
			function drawfrontSP(sp:Sprite,p1:Point,p2:Point,p3:Point,p4:Point) {
				var mySP:Sprite = new Sprite();
				sp.addChild(mySP);
				mySP.graphics.beginFill(frontColor);
				mySP.graphics.moveTo(p1.x,p1.y);
				mySP.graphics.lineTo(p2.x,p2.y);
				mySP.graphics.lineTo(p3.x,p3.y);
				mySP.graphics.lineTo(p4.x,p4.y);
				mySP.graphics.endFill();
			}

			function drawleftSP(sp:Sprite,p1:Point,p2:Point,p3:Point,p4:Point) {
				sp.graphics.clear();
				sp.graphics.beginFill(leftColor);
				sp.graphics.moveTo(p1.x,p1.y);
				sp.graphics.lineTo(p2.x,p2.y);
				sp.graphics.lineTo(p3.x,p3.y);
				sp.graphics.lineTo(p4.x,p4.y);
				sp.graphics.endFill();
			}

			function drawupSP(sp:Sprite,p1:Point,p2:Point,p3:Point,p4:Point = null) {
				var mySP:Sprite = new Sprite();
				sp.addChild(mySP);
				mySP.graphics.beginFill(upColor);
				mySP.graphics.moveTo(p1.x,p1.y);
				mySP.graphics.lineTo(p2.x,p2.y);
				mySP.graphics.lineTo(p3.x,p3.y);
				mySP.graphics.endFill();
			}
		}
		
		private  function mouseEvent(sp:FanSprite):void{
	            this.buttonMode = true;
				var currentMC:FanSprite;
	            this.addEventListener(MouseEvent.MOUSE_OVER,mouseover);
	            this.addEventListener(MouseEvent.MOUSE_OUT,mouseout);
				
				function mouseover(event:MouseEvent):void{
	                  var sp:FanSprite = event.currentTarget as FanSprite;
	                  currentMC = sp;
	                  currentMC.endX = yidong*Math.cos(moveRotation);
	                  currentMC.endY = yidong*Math.sin(moveRotation);
	                  sp.addEventListener(Event.ENTER_FRAME,mcEnterFrame);
                }
				
				function mouseout(event:MouseEvent):void{
	                 var sp:FanSprite = event.currentTarget as FanSprite;
	                 currentMC.endX = orgX;
	                 currentMC.endY = orgY;
					 sp.addEventListener(Event.ENTER_FRAME,mcEnterFrame);
               }


				
				function mcEnterFrame(event:Event):void{
	                 var sp:FanSprite = event.currentTarget as FanSprite;
	                 sp.x +=(sp.endX - sp.x)/speed;
	                 sp.y +=(sp.endY - sp.y)/speed;
	                 if(Math.abs(sp.x - sp.endX)<1&&Math.abs(sp.y-sp.endY)<1){
						  trace("11")
		                  sp.removeEventListener(Event.ENTER_FRAME,mcEnterFrame);
	                 }
	
           }
        }

	}
}