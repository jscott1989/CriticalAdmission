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

        var dayText = new FlxText(50, 50, 0, "Day " + state.currentLevel, 100);
        dayText.font = "assets/fonts/Cabin-Bold.ttf";
        dayText.color = FlxColor.BLACK;
        add(dayText);

        var infoText = new FlxText(50, 200, 0, "Hospital Reputation: " + state.reputation + "%            Patients treated: " + state.treatedPatients.length, 50);
        infoText.font = "assets/fonts/Cabin-Regular.ttf";
        infoText.color = FlxColor.BLACK;
        add(infoText);

        var infoText = new FlxText(50, 350, 0, "Minimum required health: " + state.minimumHealth + "%            Time per patient: " + state.levelTime + " seconds", 50);
        infoText.font = "assets/fonts/Cabin-Regular.ttf";
        infoText.color = FlxColor.BLACK;
        add(infoText);

        var levelText = new FlxText(50, 440, 840, PlayState.getInstance().levelText, 50);
        levelText.font = "assets/fonts/Cabin-Regular.ttf";
        levelText.color = FlxColor.BLACK;
        add(levelText);

        var upcomingPatientsText = new FlxText(50, 940, 0, "Upcoming Patients:", 50);
        upcomingPatientsText.font = "assets/fonts/Cabin-Regular.ttf";
        upcomingPatientsText.color = FlxColor.BLACK;
        add(upcomingPatientsText);

        // Now add small status images for each patient
        var i = 0;
        for (patient in PlayState.getInstance().incomingPatients) {
            var p = new PatientIcon(patient);
            p.x = 20 + (i * (200 + 20));
            p.y = upcomingPatientsText.y + upcomingPatientsText.height + 10;
            add(p);
            i+= 1;
        }



        var btnPlay = Utils.createButton("Continue", clickPlay, 5);
        btnPlay.screenCenter();
        btnPlay.y = FlxG.height - btnPlay.height - 10;
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