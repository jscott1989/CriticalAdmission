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
	private var btnDifficulty:FlxButton;
	private var btnMusic:FlxButton;
	private var btnSound:FlxButton;
	private var btnSubtitles:FlxButton;
	private var btnBack:FlxButton;

	private var BUTTONS:Float = 5;
	private var BUTTON_HEIGHT:Float = 60;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		// Fill background with black
        var background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(background);

        //Add buttons
		btnDifficulty = Utils.createButton("DIFFICULTY: Easy", clickDifficulty, 5, 30);
		switch Config.DIFFICULTY{
			case Config.Difficulty.Easy : btnDifficulty.label.text = "DIFFICULTY: Easy";
			case Config.Difficulty.Medium : btnDifficulty.label.text = "DIFFICULTY: Med";
			case Config.Difficulty.Hard : btnDifficulty.label.text = "DIFFICULTY: Hard";
		}
		btnDifficulty.screenCenter();
		btnDifficulty.y = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2 + (Config.BUTTON_Y_PADDING + BUTTON_HEIGHT)*0;
		add(btnDifficulty);

		btnMusic = Utils.createButton("MUSIC: On", clickMusic, 5, 30);
		if(Config.MUSIC_ON){
			btnMusic.label.text = "MUSIC: On";
		}
		else{
			btnMusic.label.text = "MUSIC: Off";
		}
		btnMusic.screenCenter();
		btnMusic.y = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2 + (Config.BUTTON_Y_PADDING + BUTTON_HEIGHT)*1;
		add(btnMusic);

		btnSound = Utils.createButton("SOUND: On", clickSound, 5, 30);
		if(Config.SOUND_ON){
			btnSound.label.text = "SOUND: On";
		}
		else{
			btnSound.label.text = "SOUND: Off";
		}
		btnSound.screenCenter();
		btnSound.y = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2 + (Config.BUTTON_Y_PADDING + BUTTON_HEIGHT)*2;
		add(btnSound);

		btnSubtitles = Utils.createButton("SUBTITLES: On", clickSubtitles, 5, 30);
		if(Config.SUBTITLES_ON){
			btnSubtitles.label.text = "SUBTITLES: On";
		}
		else{
			btnSubtitles.label.text = "SUBTITLES: Off";
		}
		btnSubtitles.screenCenter();
		btnSubtitles.y = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2 + (Config.BUTTON_Y_PADDING + BUTTON_HEIGHT)*3;
		add(btnSubtitles);

		btnBack = Utils.createButton("Back", clickBack, 5, 30);
		btnBack.screenCenter();
		btnBack.y = (FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2) + (Config.BUTTON_Y_PADDING + BUTTON_HEIGHT)*4;
		add(btnBack);

		super.create();

		// Cancel the fade
        FlxG.camera.stopFX();
	}

	private function clickDifficulty():Void {
		switch Config.DIFFICULTY{
			case Config.Difficulty.Easy : Config.DIFFICULTY = Config.Difficulty.Medium; btnDifficulty.label.text = "DIFFICULTY: Med";
			case Config.Difficulty.Medium : Config.DIFFICULTY = Config.Difficulty.Hard; btnDifficulty.label.text = "DIFFICULTY: Hard";
			case Config.Difficulty.Hard : Config.DIFFICULTY = Config.Difficulty.Easy; btnDifficulty.label.text = "DIFFICULTY: Easy";
		}
	}

	private function clickMusic():Void {
		if(Config.MUSIC_ON){
			Config.MUSIC_ON = false;
			btnMusic.label.text = "MUSIC: Off";
			//TODO: Hard top playing music
		}
		else{
			Config.MUSIC_ON = true;
			btnMusic.label.text = "MUSIC: On";
			//TODO: Restart music
		}
	}

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
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();

		btnDifficulty = FlxDestroyUtil.destroy(btnDifficulty);
		btnMusic = FlxDestroyUtil.destroy(btnMusic);
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