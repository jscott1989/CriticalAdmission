package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import states.playstate.PlayState;
import flash.system.System;
import Config;

using flixel.util.FlxSpriteUtil;

/**
 * Game's menu. Disabled at the moment.
 */
class OptionState extends FlxSubState {
	// private var btnMusic:FlxButton;
	private var btnSound:FlxButton;
	private var btnSubtitles:FlxButton;
	private var btnFullscreen:FlxButton;
	private var btnBack:FlxButton;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		// Fill background with black
        var background = new FlxSprite(0,0);
		background.loadGraphic("assets/images/MenuScreen.png");
		add(background);

		var logo = new FlxSprite(0,0);
		logo.loadGraphic("assets/images/Logo.png");
		add(logo);

		// btnMusic = Utils.createButton("MUSIC: On", clickMusic, 5);
		// if(Config.MUSIC_ON){
		// 	btnMusic.label.text = "MUSIC: On";
		// }
		// else{
		// 	btnMusic.label.text = "MUSIC: Off";
		// }
		// btnMusic.screenCenter();
		// btnMusic.y = 1000;
		// add(btnMusic);

		btnSound = Utils.createButton("SOUND: On", clickSound, 5);
		if(Config.SOUND_ON){
			btnSound.label.text = "SOUND: On";
		}
		else{
			btnSound.label.text = "SOUND: Off";
		}
		btnSound.screenCenter();
		btnSound.y = 1000;
		add(btnSound);

		btnSubtitles = Utils.createButton("SUBTITLES: On", clickSubtitles, 5);
		if(Config.SUBTITLES_ON){
			btnSubtitles.label.text = "SUBTITLES: On";
		}
		else{
			btnSubtitles.label.text = "SUBTITLES: Off";
		}
		btnSubtitles.screenCenter();
		btnSubtitles.y = 1125;
		add(btnSubtitles);

		btnFullscreen = Utils.createButton("FULLSCREEN: On", clickFullscreen, 5);
		if(FlxG.fullscreen){
			btnFullscreen.label.text = "FULLSCREEN: On";
		}
		else{
			btnFullscreen.label.text = "FULLSCREEN: Off";
		}
		btnFullscreen.screenCenter();
		btnFullscreen.y = 1250;
		add(btnFullscreen);

		btnBack = Utils.createButton("Back", clickBack, 5);
		btnBack.screenCenter();
		btnBack.y = 1400;
		add(btnBack);

		super.create();

		// Cancel the fade
        FlxG.camera.stopFX();
	}

	// private function clickMusic():Void {
	// 	if(Config.MUSIC_ON){
	// 		Config.MUSIC_ON = false;
	// 		btnMusic.label.text = "MUSIC: Off";
	// 		//TODO: Hard top playing music
	// 	}
	// 	else{
	// 		Config.MUSIC_ON = true;
	// 		btnMusic.label.text = "MUSIC: On";
	// 		//TODO: Restart music
	// 	}
	// }

	private function clickSound():Void {
		if(Config.SOUND_ON){
			Config.SOUND_ON = false;
			btnSound.label.text = "SOUND: Off";
			//TODO: Hard top playing sounds
		}
		else{
			Config.SOUND_ON = true;
			btnSound.label.text = "SOUND: On";
		}
	}

	private function clickSubtitles():Void {
		if(Config.SUBTITLES_ON){
			Config.SUBTITLES_ON = false;
			btnSubtitles.label.text = "SUBTITLES: Off";
		}
		else{
			Config.SUBTITLES_ON = true;
			btnSubtitles.label.text = "SUBTITLES: On";
		}
	}

	private function clickBack():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			close();
			FlxG.camera.stopFX();
        });
	}

	private function clickFullscreen():Void {
		FlxG.fullscreen = !FlxG.fullscreen;

		if(FlxG.fullscreen){
			btnFullscreen.label.text = "FULLSCREEN: On";
		}
		else{
			btnFullscreen.label.text = "FULLSCREEN: Off";
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();

		// btnMusic = FlxDestroyUtil.destroy(btnMusic);
		btnSound = FlxDestroyUtil.destroy(btnSound);
		btnSubtitles = FlxDestroyUtil.destroy(btnSubtitles);
		btnBack = FlxDestroyUtil.destroy(btnBack);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		super.update();
	}	
}