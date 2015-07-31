package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import sounds.SoundManager;

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

	private var background:FlxSprite;
	private var logo:FlxSprite;
	private var options:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		// Fill background with black
        background = new FlxSprite(0,0);
		background.loadGraphic("assets/images/MenuScreen.png");
		add(background);

		logo = new FlxSprite(0,0);
		logo.loadGraphic("assets/images/Logo.png");
		add(logo);

		options = new FlxSprite(100,270);
        options.loadGraphic("assets/images/options.png");
        add(options);

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

	private function clickSound():Void {
		if(Config.SOUND_ON){
			Config.SOUND_ON = false;
			btnSound.label.text = "SOUND: Off";
			FlxG.sound.muted = true;
		}
		else{
			Config.SOUND_ON = true;
			btnSound.label.text = "SOUND: On";
			FlxG.sound.muted = false;
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
		var options = new FlxSave();
		options.bind("options");
		options.data.fullscreen = FlxG.fullscreen;
		options.data.subtitles_on = Config.SUBTITLES_ON;
		options.data.sound_on = Config.SOUND_ON;
		options.flush();
		close();
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
		btnFullscreen = FlxDestroyUtil.destroy(btnFullscreen);
		btnBack = FlxDestroyUtil.destroy(btnBack);

		background = FlxDestroyUtil.destroy(background);
		logo = FlxDestroyUtil.destroy(logo);
		options = FlxDestroyUtil.destroy(options);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		super.update();
	}	
}