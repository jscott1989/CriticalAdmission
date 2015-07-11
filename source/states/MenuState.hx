package states;

import flixel.FlxG;
import flixel.FlxState;
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

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		PlayState.clearInstance();
		btnPlay = Utils.createButton("New Game", clickPlay, 5, 30);
		btnPlay.screenCenter();
		add(btnPlay);
		super.create();
		
	}

	private function clickPlay():Void {
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(PlayState.getInstance());
        });
	}
	
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