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
 * This gives an overview of progress so far, in between levels
 */
class IntrimState extends FlxSubState {
    public static var LEVEL_TEXT = [
        "Blah blah introduce the game...",
        "This is level 1 somethign something"
    ];

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        var state = PlayState.getInstance();

        // fill background with black
        var background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(background);

        var dayText = new FlxText(50, 50, 0, "Day " + (state.currentLevel + 1), 100);
        add(dayText);

        var infoText = new FlxText(50, 200, 0, "Hospital Reputation: " + state.reputation + "            Patients treated: " + state.treatedPatients.length, 50);
        add(infoText);

        var levelText = new FlxText(50, 400, 0, LEVEL_TEXT[state.currentLevel], 50);
        add(levelText);

        var btnPlay = Utils.createButton("Continue", clickPlay, 5, 30);
        btnPlay.screenCenter();
        btnPlay.y = FlxG.height - btnPlay.height - 10;
        add(btnPlay);

        super.create();

        // Cancel the fade
        FlxG.camera.stopFX();
    }

    private function clickPlay():Void {
        close();
        PlayState.getInstance().nextLevel();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void {
        super.update();
    }   
}