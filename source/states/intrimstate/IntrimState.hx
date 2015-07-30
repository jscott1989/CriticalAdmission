package states.intrimstate;

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

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        var state = PlayState.getInstance();

        state.nextLevel();

        // fill background with black
        var background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        var dayText = new FlxText(50, 50, 0, "Day " + state.currentLevel, 70);
        dayText.font = "assets/fonts/Cabin-Bold.ttf";
        dayText.color = FlxColor.BLACK;
        add(dayText);

        var infoText = new FlxText(250, 75, 0, "Hospital Reputation: " + state.reputation + "%            Patients treated: " + state.treatedPatients.length, 40);
        infoText.font = "assets/fonts/Cabin-Regular.ttf";
        infoText.color = FlxColor.BLACK;
        add(infoText);

        // var infoText = new FlxText(50, 180, 0, "Time per patient: " + state.levelTime + " seconds", 40);
        // infoText.font = "assets/fonts/Cabin-Regular.ttf";
        // infoText.color = FlxColor.BLACK;
        // add(infoText);

        var levelText = new FlxText(50, 180, 950, PlayState.getInstance().levelText, 40);
        levelText.font = "assets/fonts/Cabin-Regular.ttf";
        levelText.color = FlxColor.BLACK;
        add(levelText);

        // Now add small status images for each patient
        var i = 0;
        for (patient in PlayState.getInstance().incomingPatients) {
            var p = new PatientIcon(patient);
            p.x = 20 + (i * (200 + 20));
            p.y = (FlxG.height - 500);
            add(p);
            i+= 1;
        }



        var btnPlay = Utils.createButton("Continue", clickPlay, 5);
        btnPlay.x = 300;
        btnPlay.y = 700;
        add(btnPlay);

        super.create();

        // Cancel the fade
        FlxG.camera.stopFX();
    }

    private function clickPlay():Void {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
            PlayState.getInstance().isActive = true;
            close();
            FlxG.camera.stopFX();
        });
    }
}