package com.reymadrid.events
{
	import flash.display.Sprite;
	
	public class AlbumViewer extends Sprite
	{
		private var _imageList:Array;
		private var _path:String;
		private var _currentImage:int;
		private var _ld:ImageLoader;
		
		public function AlbumViewer()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_imageList = [];
			_currentImage = 0;
		}
		
		private function loadImg():void
		{
			_ld = new ImageLoader(_path + _imageList[_currentImage]);
			_ld.addEventListener(ImageEvent.IMAGE_LOADED, onLoad);
		}
		private function onLoad(e:ImageEvent):void
		{
			if (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			this.addChild(e.image);
		}
		
		public function display():void
		{
			loadImg();
		}
		
		public function next():void
		{
			_currentImage++;
			if(_currentImage == _imageList.length)
			{
				_currentImage = 0;
			}
			_ld = new ImageLoader(_path + _imageList[_currentImage]);
			_ld.addEventListener(ImageEvent.IMAGE_LOADED, onLoad);
		}
		public function previous():void
		{
			_currentImage--;
			if(_currentImage < 0)
			{
				_currentImage = _imageList.length-1;
			}
			_ld = new ImageLoader(_path + _imageList[_currentImage]);
			_ld.addEventListener(ImageEvent.IMAGE_LOADED, onLoad);
		}
		
		public function set path(value:String):void
		{
			_path = value;
		}
		
		public function set imageList(value:Array):void
		{
			_imageList = value;
		}
	}
}