package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
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
		btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		btnPlay.screenCenter();
		add(btnPlay);
		super.create();
		FlxG.switchState(PlayState.getInstance());
	}

	private function clickPlay():Void {
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