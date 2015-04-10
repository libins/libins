package cn.libins{
	import flash.net.*;
	import flash.events.*;
	public class InitXml{
		private var picArr:Array;
		private var urlArr:Array;
		private var infoArr:Array;
		private var mRoot:Object;
		private var timeDelay:Number = 0;
		private var mAutoPlay:Boolean
		
		public function InitXml(url:String,Root:Object){
			var mURLRequest:URLRequest = new URLRequest(url);
			var mURLLoader:URLLoader = new URLLoader();
			mURLLoader.load(mURLRequest);
			mURLLoader.addEventListener(Event.COMPLETE,xmlLoaded);
			mRoot = Root;
			}
		
		private function xmlLoaded(event:Event):void{
			var xml:XML = new XML(event.target.data);
			initXml(xml);
			}
		private function initXml(xml:XML):void{
			var picNum:uint = xml.descendants("pics").children().length();
			picArr = new Array();
			urlArr = new Array();
			infoArr = new Array();
			for(var i:uint = 0;i<picNum;i++){
				picArr.push(xml.descendants("pics").child("pic")[i].attribute("big").toString()); 
				urlArr.push(xml.descendants("pics").child("pic")[i].attribute("link").toString()); 
				infoArr.push(xml.descendants("pics").child("pic")[i].attribute("info").toString()); 
			}
			timeDelay = Number(xml.descendants("pics").@*[0]);
			mAutoPlay = Boolean(xml.descendants("pics").@*[1]);
            mRoot.init(picArr,urlArr,infoArr,timeDelay,mAutoPlay);
			}	
		}
	}