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
	 private var _btnPlay:FlxButton;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		_btnPlay.screenCenter();
		add(_btnPlay);
		super.create();
	}

	private function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		super.update();
	}	
}