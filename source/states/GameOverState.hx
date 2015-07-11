package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * Game's menu. Disabled at the moment.
 */
class GameOverState extends FlxState {

	public function new() {
		super();
	}

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		var btnMenu = new FlxButton(0, 0, "Return to Menu", clickMenu);
		btnMenu.screenCenter();
		add(btnMenu);
		super.create();
	}

	private function clickMenu():Void {
		FlxG.switchState(new MenuState());
	}	
}