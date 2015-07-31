 package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * This allows exiting or resuming the game
 */
class PauseState extends FlxSubState {

    private var background:FlxSprite;
    private var pause:FlxSprite;
    private var btnPlay:FlxButton;
    private var btnRetry:FlxButton;
    private var btnMenu:FlxButton;
    private var btnOptions:FlxButton;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {

        // fill background with black
        background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        pause = new FlxSprite(0,0);
        pause.loadGraphic("assets/images/PauseText.png");
        pause.screenCenter();
        pause.y = 100;
        add(pause);

        btnPlay = Utils.createButton("Continue", clickPlay, 5);
        btnPlay.x = FlxG.width / 2 - btnPlay.width / 2;
        btnPlay.y = 1375;
        add(btnPlay);

        btnOptions = Utils.createButton("Options", clickOptions, 5);
        btnOptions.x = FlxG.width / 2 - btnOptions.width / 2;
        btnOptions.y = 1125;
        add(btnOptions);

        btnRetry = Utils.createButton("Restart", clickRetry, 5);
        btnRetry.x = FlxG.width / 2 - btnRetry.width / 2;
        btnRetry.y = 1250;
        add(btnRetry);

        btnMenu = Utils.createButton("Return to Menu", clickMenu, 5);
        btnMenu.x = FlxG.width / 2 - btnMenu.width / 2;
        btnMenu.y = 1000;
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

    private function clickOptions():Void {
        openSubState(new OptionState());
    }

    private function clickRetry():Void {
        // FlxG.switchState(new PassingToPlayState(PlayState.getInstance().lastSaveState));
        FlxG.switchState(new PassingToPlayState());
    }

    private function clickMenu():Void {
        FlxG.switchState(new MenuState());
    }

    override function destroy() {
        super.destroy();
        background = FlxDestroyUtil.destroy(background);
        pause = FlxDestroyUtil.destroy(pause);
        btnPlay = FlxDestroyUtil.destroy(btnPlay);
        btnRetry = FlxDestroyUtil.destroy(btnRetry);
        btnMenu = FlxDestroyUtil.destroy(btnMenu);
        btnOptions = FlxDestroyUtil.destroy(btnOptions);
    }
}