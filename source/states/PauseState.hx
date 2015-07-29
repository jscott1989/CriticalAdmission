 package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import states.playstate.Patient;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * This allows exiting or resuming the game
 */
class PauseState extends FlxSubState {

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {

        // fill background with black
        var background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        var btnPlay = Utils.createButton("Continue", clickPlay, 5);
        btnPlay.x = FlxG.width / 2 - btnPlay.width / 2;
        btnPlay.y = 1000;
        add(btnPlay);

        var btnRetry = Utils.createButton("Restart Day", clickRetry, 5);
        btnRetry.x = FlxG.width / 2 - btnRetry.width / 2;
        btnRetry.y = 1125;
        add(btnRetry);

        var btnMenu = Utils.createButton("Return to Menu", clickMenu, 5);
        btnMenu.x = FlxG.width / 2 - btnMenu.width / 2;
        btnMenu.y = 1250;
        add(btnMenu);

        super.create();

        // Cancel the fade
        FlxG.camera.stopFX();
    }

    private function clickPlay():Void {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
            close();
            FlxG.camera.stopFX();
            PlayState.getInstance().isActive = true;
        });
    }

    private function clickRetry():Void {
        FlxG.switchState(new PassingToPlayState(PlayState.getInstance().lastSaveState));
    }

    private function clickMenu():Void {
        FlxG.switchState(new MenuState());
    }
}