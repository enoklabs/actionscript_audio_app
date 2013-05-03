package com.reymadrid.events
{
	import com.reymadrid.events.ImageEvent;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	
	public class ImageLoader extends EventDispatcher
	{
		private var ld:Loader;
		
		public function ImageLoader(file:String)
		{
			super();
			ld = new Loader();
			ld.load(new URLRequest(file));
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad)
		}
		private function onLoad(e:Event):void
		{
			var evt:ImageEvent = new ImageEvent(ImageEvent.IMAGE_LOADED);
			evt.image = e.target.content;
			dispatchEvent(evt);
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad)
			ld.unload();
			ld = null;
		}
	}
}