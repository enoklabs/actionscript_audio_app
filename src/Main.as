/*
Rey Madrid
05/1/13
FAT 1304 01
Assignment #4 - Audio Application
*/ 
package
{
	import com.reymadrid.app.MusicApp;
	import flash.display.Sprite;

	[SWF (height="280", width="800")]
	
	public class Main extends Sprite
	{
		//initializes Application
		public function Main()
		{
			init();
		}
		
		private function init() : void
		{
			//display app on screen
			var app:MusicApp = new MusicApp();
			app.x = 150;
			app.y = 50;
			addChild(app);
		}	
	}
}
