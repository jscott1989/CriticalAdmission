package states;

import flixel.FlxG;
import flixel.FlxState;
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
class MenuState extends FlxState {
	private var btnPlay:FlxButton;
	private var btnOptions:FlxButton;
	private var btnQuit:FlxButton;

	private var BUTTONS:Float = 2;
	private var BUTTON_HEIGHT:Float = 60;
	//private var BUTTON_TOP:Float = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		PlayState.clearInstance();
		btnPlay = Utils.createButton("New Game", clickPlay, 5, 30);
		btnPlay.screenCenter();
		btnPlay.y = FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2;
		add(btnPlay);

		btnOptions = Utils.createButton("Options", clickOptions, 5, 30);
		btnOptions.screenCenter();
		btnOptions.y = (FlxG.height/2 - (BUTTONS*(Config.BUTTON_Y_PADDING + BUTTON_HEIGHT))/2) + Config.BUTTON_Y_PADDING + BUTTON_HEIGHT;
		add(btnOptions);

		// btnQuit = Utils.createButton("Quit", clickQuit, 5, 30);
		// btnQuit.screenCenter();
		// add(btnQuit);

		super.create();
		
	}

	private function clickPlay():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(PlayState.getInstance());
        });
	}

	private function clickOptions():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(PlayState.getInstance());
        });
	}

	// private function clickQuit():Void {
	// 	FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
	// 		System.exit(0);
 //        });
	// }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
		btnPlay = FlxDestroyUtil.destroy(btnPlay);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		super.update();
	}	
}