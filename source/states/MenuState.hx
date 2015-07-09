package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxDestroyUtil;
import states.playstate.PlayState;
import flixel.ui.FlxButton;

import Utils;

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
		btnPlay = Utils.createButton("New Game", clickPlay, 5, 30);
		btnPlay.screenCenter();
		//btnPlay.x = (FlxG.width / 2) - btnPlay.width - 10;
		//btnPlay.y = FlxG.height - btnPlay.height - 10;
		add(btnPlay);
		super.create();
		
	}

	private function clickPlay():Void {
		FlxG.switchState(PlayState.getInstance());
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