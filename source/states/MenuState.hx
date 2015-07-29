package states;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * Game's menu. Disabled at the moment.
 */
class MenuState extends FlxState {
	private var btnPlay:FlxButton;
	private var btnOptions:FlxButton;
	private var btnCredits:FlxButton;
	private var btnExit:FlxButton;

	private var BUTTONS:Float = 2;
	private var BUTTON_HEIGHT:Float = 60;
	//private var BUTTON_TOP:Float = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2;

	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		FlxG.fullscreen = true;
		PlayState.clearInstance();

		var background = new FlxSprite(0,0);
		background.loadGraphic("assets/images/MenuScreen.png");
		add(background);

		var logo = new FlxSprite(0,0);
		logo.loadGraphic("assets/images/Logo.png");
		add(logo);

		var grenade = new FlxSprite(0,0);
		grenade.loadGraphic("assets/images/Grenade.png");
		grenade.x = FlxG.width - grenade.width;
		grenade.y = FlxG.height - grenade.height;
		add(grenade);

		var intro = new FlxText(100, 330, 700, "The junior doctors have done it again.\n\nYou told them having only one senior surgeon would end in disaster.\n\nThere are queues going out the door and everyone is muddled up.\n\nPut the patients back together, and for god's sake don't miss anything out!", 40);
		intro.font = "assets/fonts/Cabin-Bold.ttf";
		intro.color = FlxColor.BLACK;
		add(intro);

		btnPlay = Utils.createButton("New Game", clickPlay, 5);
		btnPlay.screenCenter();
		btnPlay.y = 1000;
		add(btnPlay);

		btnOptions = Utils.createButton("Options", clickOptions, 5);
		btnOptions.screenCenter();
		btnOptions.y = 1125;
		add(btnOptions);

		btnCredits = Utils.createButton("Credits", clickCredits, 5);
		btnCredits.screenCenter();
		btnCredits.y = 1250;
		add(btnCredits);

		btnExit = Utils.createButton("Exit", clickExit, 5);
		btnExit.screenCenter();
		btnExit.y = 1375;
		add(btnExit);

		super.create();
		
	}

	private function clickPlay():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(PlayState.getInstance());
        });
	}

	private function clickOptions():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			openSubState(new OptionState());
        });
	}

	private function clickCredits():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			openSubState(new CreditsState());
        });
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
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		super.update();
	}	
}