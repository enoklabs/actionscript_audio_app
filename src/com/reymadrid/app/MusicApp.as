package com.reymadrid.app
{
	import libs.MusicPlayerBase;
	import com.reymadrid.managers.SliderManager;
	import com.reymadrid.utils.RoundNumber;
	import com.reymadrid.ui.Slider;
	import com.reymadrid.vo.SongsVO;
	import com.reymadrid.events.AlbumViewer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class MusicApp extends MusicPlayerBase
	{
		private var _music:Sound;
		private var _av:AlbumViewer;	
		private var _rPeak:int;
		private var _lPeak:int;
		private var _track:Number;
		private var _filePath:String;
		private var _fileName:String;
		private var _timer:Timer;
		private var _time:String;
		private var _sec:int;
		private var _min:int;
		private var _saveSec:int;
		private var _saveCount:int;
		private var _songsList:Array;
		private var _sch:SoundChannel;
		private var _sPos:int;
		private var _st:SoundTransform;
		private var _volume:Number;
		private var _vo:SongsVO;
		
		public function MusicApp()
		{
			super();
			setup();
		}
		
		//setup the applictation elements
		private function setup():void
		{	
			//initialize int variables
			_track = 0;
			_sec = 0;
			_min = 0;
			_filePath = "assets/music/"
			_saveCount = 0;
			
			//main setup functions
			setupMusic();
			setupButtons();
			setupAlbumArt();
			
			//Loads the XML file
			var urlLoader:URLLoader = new URLLoader ();
			urlLoader.load(new URLRequest ("assets/xml/songs.xml"));
			urlLoader.addEventListener(Event.COMPLETE, onParse);
		}
		
		//Setup all UI Buttons
		private function setupButtons():void
		{
			
			//Pause/Play Button
			BtnPlay.playPause.stop();
			BtnPlay.playPause.mouseChildren = false;
			BtnPlay.playPause.buttonMode = true;
			BtnPlay.playPause.addEventListener(MouseEvent.MOUSE_DOWN, onPlay);
			
			//Next Track Button
			BtnNextTrack.stop();
			BtnNextTrack.mouseChildren = false;
			BtnNextTrack.buttonMode = true;
			BtnNextTrack.addEventListener(MouseEvent.MOUSE_DOWN, onNext);
			
			//Previous Track Button
			BtnPrevTrack.stop();
			BtnPrevTrack.mouseChildren = false;
			BtnPrevTrack.buttonMode = true;
			BtnPrevTrack.addEventListener(MouseEvent.MOUSE_DOWN, onPrev);
			
			//Mute Button
			BtnMute.stop();
			BtnMute.mouseChildren = false;
			BtnMute.buttonMode = true;
			BtnMute.addEventListener(MouseEvent.MOUSE_DOWN, mute);
			
			//volume Icon
			VolumeIcon.gotoAndStop(2);
			
			//Volume Slider
			var slider:Slider;
			slider = new Slider;
			slider.x = 243;
			slider.y = 136;
			this.addChild (slider);
			var sm:SliderManager;
			sm = new SliderManager();
			sm.setUpAssets(slider.mc_track, slider.mc_handle);
			sm.percent = .2;
			sm.addEventListener(Event.CHANGE, volumeAdjust);
		}
		
		//Setup Album art image viewer
		private function setupAlbumArt():void
		{ 
			_av = new AlbumViewer();
			_av.path = "assets/images/";
			_av.imageList = ["1.jpg", "2.jpg", "3.jpg", "4.jpg"];
			_av.display();
			_av.x=451;
			_av.y=8;
			addChild(_av);
		}
		
		//Mute Button is clicked
		private function mute( e:MouseEvent ):void
		{
			if (BtnMute.currentFrame == 1)
			{
				_sPos = _sch.position;
				_sch.stop();
				BtnMute.gotoAndStop(2);
				_st.volume = 0;
			}
			else if (BtnMute.currentFrame == 2)
			{
				setupMusic();
				_sch = _music.play(_sPos, 0, _st);
				_sch.addEventListener(Event.SOUND_COMPLETE, onDone);
				BtnMute.gotoAndStop(1);
				_st.volume = _sPos;
			}
		}
		
		//Starts Song Timer
		private function startTimer():void
		{
			_timer = new Timer (1000, 9999);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		//Runs the Song timer
		private function onTimer(event:TimerEvent):void
		{
			//Adds one second every second
			_sec++ 
	
			if (_sec == 60)
			{
				_min++;
				_sec = 0;
			}
			//Tracks the seconds past
			if (_sec <= 9)
			{
				tfTime.text = _min + ":0" + _sec;
			}
			else
			{
				tfTime.text = _min + ":" + _sec;
			}
			_saveSec = _sec
		}
		
		//Pauses Song Timer
		private function pauseTimer():void
		{
			var cc:int = _timer.currentCount;
			
			if (_saveCount == 0)
			{
				_saveCount++;
			}
			else if (_saveCount >= 1)
			{
				_sec = _saveSec + cc;
			}
			_timer.stop();
		}
		
		//Resets the Song Timer
		private function resetTimer():void
		{
			_min = 0;
			_sec = 0;
			_timer.stop();
		}
		
		//Setup the music
		private function setupMusic():void
		{
			if (_songsList)
			{
				_fileName = _songsList[_track].fileName;
				_music = new Sound();
				_music.load (new URLRequest(_filePath + _fileName));
				_st = new SoundTransform();
				_st.volume = .2;
				addEventListener(Event.ENTER_FRAME, vizualizer);
			}
		}
		
		//Parses the XML file
		private function onParse(e:Event):void
		{
			_songsList = [];
			var xmlData:XML = XML (e.target.data);
			for each (var song:XML in xmlData.song)
			{
				//Adds the values to SongsVO
				_vo = new SongsVO();
				_vo.artist = song.artist;
				_vo.title = song.title;
				_vo.fileName = song.fileName;
				_vo.track = song.track;
				_vo.albumart = song.albumart;
				_songsList.push(song);
			}
			//Sets up the textFields
			tfArtistName.text = _songsList[0].artist;
			tfTime.text = "0:00";
			tfTrackName.text = _songsList[0].title;
			tfTrack.text = "Track: " + _songsList[0].track;
		}
		
		//Sound Peaks for animating Visualizer
		private function vizualizer(e:Event):void
		{
			if (_sch)
			{
				_rPeak = _sch.rightPeak;
				_lPeak = _sch.leftPeak;
				rightBar.width = _sch.rightPeak * 250;
			}
		}
		
		//Updates the Artist and Track textfields
		private function updateTF():void
		{
			if (_songsList)
			{
				tfArtistName.text = _songsList[ _track ].artist;
				tfTrackName.text = _songsList[ _track ].title;
				tfTrack.text = "Track: " + _songsList[ _track ].track;
				if (_time)
				{
					tfTime.text = _time;
				}
			}
		}
		
		//Resets and Updates Song information
		private function resetSong():void
		{
			BtnPlay.playPause.gotoAndStop(2);
			updateTF();
			if (_timer)
			{
				resetTimer();
			}
			_sec = 0;
			startTimer();
			
			if (_sch)
			{
				_sch.stop();
			}
			setupMusic ();
			_sch = _music.play (_sPos, 0, _st);
			_sch.addEventListener (Event.SOUND_COMPLETE, onDone);
		}

		//Play/Pause Track Button is clicked
		private function onPlay(e:MouseEvent):void
		{
			setupMusic();
			
			if (BtnPlay.playPause.currentFrame == 1)
			{
				//This Plays Music
				updateTF();
				startTimer();
				_sch = _music.play (_sPos, 0, _st);
				_sch.addEventListener (Event.SOUND_COMPLETE, onDone);
				BtnPlay.playPause.gotoAndStop (2);
				addEventListener (Event.ENTER_FRAME, vizualizer);
			}
			else
			{
				//This Pauses Music
				removeEventListener (Event.ENTER_FRAME, vizualizer);
				pauseTimer ();
				_sPos = _sch.position;
				_sch.stop ();
				BtnPlay.playPause.gotoAndStop (1);
			}
		}
		
		//Previous Track Button is clicked
		private function onPrev(e:MouseEvent):void
		{
			if (_track > 0)
			{
				_av.previous();
				_track--;
				resetSong();
			}
			else if (_track <= 0)
			{
				_av.previous();
				_track = _songsList.length - 1;
				resetSong();
			}
		}
		
		//Next Track Button is clicked
		private function onNext(e:MouseEvent):void
		{
			if (_track < _songsList.length - 1 && _track >= 0)
			{
				_av.next();
				_track++;
				resetSong();
			}
			else if (_track >= _songsList.length - 1)
			{
				_av.next();
				_track = 0;
				resetSong ();
			}
		}
		
		//Plays Next Song after current Song is done
		private function onDone(e:Event):void
		{
			if (_track < _songsList.length - 1 && _track >= 0)
			{
				_av.next();
				_track++;
				resetSong();
			}
			else if (_track >= _songsList.length - 1)
			{
				_av.next();
				_track = 0;
				resetSong();
			}
		}
		
		//Adjusts the Volume
		private function volumeAdjust(e:Event):void
		{
			var sm:SliderManager = SliderManager(e.currentTarget);
			_volume = RoundNumber.roundToDecimal(sm.percent, 2);
			if (BtnPlay.playPause.currentFrame == 2)
			{
				_st.volume = _volume;
				_sch.soundTransform = _st;
			}
		}
	}
}