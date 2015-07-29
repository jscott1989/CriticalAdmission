package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * Game's menu. Disabled at the moment.
 */
class GameOverState extends FlxSubState {

	public function new() {
		super();
	}

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		// fill background with black
        var background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        var logo = new FlxSprite(0,0);
		logo.loadGraphic("assets/images/Logo.png");
		add(logo);

		var btnMenu = Utils.createButton("Return to Menu", clickMenu, 5);
		btnMenu.x = FlxG.width / 2 - btnMenu.width - 10;
		btnMenu.y = FlxG.height - btnMenu.height - 10;
		add(btnMenu);

		var btnRetry = Utils.createButton("Restart Day", clickRetry, 5);
		btnRetry.x = FlxG.width / 2 + 10;
		btnRetry.y = FlxG.height - btnRetry.height - 10;
		add(btnRetry);
		super.create();

		// Cancel the fade
        FlxG.camera.stopFX();

        //Reset level information
        Levels.populateLevels();
	}

	private function clickMenu():Void {
		FlxG.switchState(new MenuState());
	}	

	private function clickRetry():Void {
		FlxG.switchState(new PassingToPlayState(PlayState.getInstance().lastSaveState));
	}	
}