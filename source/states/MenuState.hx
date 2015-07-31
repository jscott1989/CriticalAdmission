package states;

import flash.Lib;
import flash.net.URLRequest;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.plugin.MouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;



/**
 * Game's menu. Disabled at the moment.
 */
class MenuState extends FlxState {
	private var btnPlay:FlxButton;
	private var btnHighscore:FlxButton;
	private var btnOptions:FlxButton;
	private var btnCredits:FlxButton;
	private var btnExit:FlxButton;

	private var btnBeginning:FlxButton;
	private var btnSkipTutorial:FlxButton;
	private var btnCancel:FlxButton;

	private var BUTTONS:Float = 2;
	private var BUTTON_HEIGHT:Float = 60;
	//private var BUTTON_TOP:Float = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2;

	private var overGrenade = false;
	private var tooltipText:FlxText;
	private var tooltipSprite:FlxSprite;

	private var intro:FlxText;
	private var grenade:FlxSprite;
	private var background:FlxSprite;
	private var logo:FlxSprite;
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		// Enable debugger if in debug mode
		FlxG.debugger.visible = true;
		
		var options = new FlxSave();
		options.bind("options");
		if (options.data.fullscreen == null) {
			options.data.fullscreen = true;
		}
		if (options.data.sound_on == null) {
			options.data.sound_on = true;
		}
		if (options.data.subtitles_on == null) {
			options.data.subtitles_on = true;
		}
		FlxG.fullscreen = options.data.fullscreen;
		Config.SOUND_ON = options.data.sound_on;
		Config.SUBTITLES_ON = options.data.subtitles_on;

		PlayState.clearInstance();

		tooltipText = new FlxText(0, 0, 0, "SAGDCX", 50); 
        tooltipText.font = "assets/fonts/Cabin-Regular.ttf";
        tooltipSprite = new FlxSprite();
        tooltipSprite.makeGraphic(Std.int(tooltipText.width + 50), Std.int(tooltipText.height), FlxColor.BLACK);
        add(tooltipText);
        add(tooltipSprite);

		background = new FlxSprite(0,0);
		background.loadGraphic("assets/images/MenuScreen.png");
		add(background);

		logo = new FlxSprite(0,0);
		logo.loadGraphic("assets/images/Logo.png");
		add(logo);

		grenade = new FlxSprite(0,0);
		grenade.loadGraphic("assets/images/Grenade.png");
		grenade.x = FlxG.width - grenade.width;
		grenade.y = FlxG.height - grenade.height;

		var tween:FlxTween = null;

		MouseEventManager.add(grenade, function(sprite:FlxSprite) {
			if (tween != null) tween.cancel();
			tween = FlxTween.tween(sprite.scale,{"x": 1.2, "y": 1.2}, 0.1);
		}, function(sprite:FlxSprite) {
			if (tween != null) tween.cancel();
			tween = FlxTween.tween(sprite.scale,{"x": 1, "y": 1}, 0.1);
			Lib.getURL (new URLRequest ("http://awfuljams.com"));
		}, function(sprite:FlxSprite) {
			overGrenade = true;
		}, function(sprite:FlxSprite) {
			if (tween != null) tween.cancel();
			tween = FlxTween.tween(sprite.scale,{"x": 1, "y": 1}, 0.1);
			overGrenade = false;
		});
		add(grenade);

		intro = new FlxText(100, 330, 700, "The junior doctors have done it again.\n\nYou told them having only one senior surgeon would end in disaster.\n\nThere are queues going out the door and everyone is muddled up.\n\nPut the patients back together, and for god's sake don't miss anything out!", 40);
		intro.font = "assets/fonts/Cabin-Bold.ttf";
		intro.color = FlxColor.BLACK;
		add(intro);

		btnPlay = Utils.createButton("New Game", clickPlay, 5);
		btnPlay.screenCenter();
		btnPlay.y = 920;
		add(btnPlay);

		btnHighscore = Utils.createButton("Highscores", clickHighscores, 5);
		btnHighscore.screenCenter();
		btnHighscore.y = 1045;
		add(btnHighscore);

		btnOptions = Utils.createButton("Options", clickOptions, 5);
		btnOptions.screenCenter();
		btnOptions.y = 1170;
		add(btnOptions);

		btnCredits = Utils.createButton("Credits", clickCredits, 5);
		btnCredits.screenCenter();
		btnCredits.y = 1295;
		add(btnCredits);

		btnExit = Utils.createButton("Exit", clickExit, 5);
		btnExit.screenCenter();
		btnExit.y = 1420;
		add(btnExit);

		super.create();
		
	}

	private function clickPlay():Void {

		var options = new FlxSave();
		options.bind("options");

		if (options.data.hasPlayedLevel5 != true) {
			clickBeginning();
		} else {
			if (btnBeginning == null) {
				btnBeginning = Utils.createButton("Level 1", clickBeginning, 5);
				btnSkipTutorial = Utils.createButton("Level 5", clickSkipTutorial, 5);
				btnCancel = Utils.createButton("Cancel", clickCancel, 5);

				btnBeginning.screenCenter();
				btnSkipTutorial.screenCenter();
				btnCancel.screenCenter();

				btnBeginning.y = 920;
				btnSkipTutorial.y = 1045;
				btnCancel.y = 1170;
			}

			remove(btnPlay, true);
			remove(btnHighscore, true);
			remove(btnOptions, true);
			remove(btnCredits, true);
			remove(btnExit, true);

			add(btnBeginning);
			add(btnSkipTutorial);
			add(btnCancel);
		}
	}

	private function clickBeginning() {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(PlayState.getInstance());
        });
	}

	private function clickSkipTutorial() {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(PlayState.getInstance(5));
        });
	}

	private function clickCancel() {
		remove(btnBeginning);
		remove(btnSkipTutorial);
		remove(btnCancel);

		add(btnPlay);
		add(btnHighscore);
		add(btnOptions);
		add(btnCredits);
		add(btnExit);
	}

	private function clickHighscores():Void {
		openSubState(new HighscoreState());
	}

	private function clickOptions():Void {
		openSubState(new OptionState());
	}

	private function clickCredits():Void {
		openSubState(new CreditsState());
	}

	private function clickExit():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			System.exit(0);
        });
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
		btnPlay = FlxDestroyUtil.destroy(btnPlay);
		btnOptions = FlxDestroyUtil.destroy(btnOptions);
		btnCredits = FlxDestroyUtil.destroy(btnCredits);
		btnBeginning = FlxDestroyUtil.destroy(btnBeginning);
		btnSkipTutorial = FlxDestroyUtil.destroy(btnSkipTutorial);
		btnCancel = FlxDestroyUtil.destroy(btnCancel);

		intro = FlxDestroyUtil.destroy(intro);
		grenade = FlxDestroyUtil.destroy(grenade);
		background = FlxDestroyUtil.destroy(background);
		logo = FlxDestroyUtil.destroy(logo);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		if (overGrenade) {
			tooltipText.x = FlxG.mouse.x - (tooltipText.width / 2);
            tooltipText.y = FlxG.mouse.y + tooltipText.height + 20;

            Utils.bringToFront(members, tooltipSprite);
            Utils.bringToFront(members, tooltipText, tooltipSprite);

            tooltipSprite.x = tooltipText.x - 25;
	        tooltipSprite.y = tooltipText.y;
		} else {
			tooltipText.x = -1000;
			tooltipText.y = -1000;
			tooltipSprite.x = -1000;
			tooltipSprite.y = -1000;

		}

		super.update();
	}	
}