package states.intrimstate;

import flash.filters.GlowFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.effects.FlxSpriteFilter;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * This gives an overview of progress so far, in between levels
 */
class IntrimState extends FlxSubState {

    private var background:FlxSprite;
    private var dayText:FlxText;
    private var infoText:FlxText;
    private var levelText:FlxText;
    private var patientIcons = new Array<PatientIcon>();
    private var btnPlay:FlxButton;

    private var filter:FlxSpriteFilter;
    private var goldFilter:GlowFilter;
    private var filterTween:FlxTween;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        var state = PlayState.getInstance();

        state.nextLevel();

        // fill background with black
        background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        dayText = new FlxText(50, 50, 0, "Day " + state.currentLevel, 70);
        dayText.font = "assets/fonts/Cabin-Bold.ttf";
        dayText.color = FlxColor.BLACK;
        add(dayText);

        infoText = new FlxText(250, 75, 0, "Hospital Reputation: " + state.reputation + "%            Patients treated: " + state.treatedPatients.length, 40);
        infoText.font = "assets/fonts/Cabin-Regular.ttf";
        infoText.color = FlxColor.BLACK;
        add(infoText);

        // var infoText = new FlxText(50, 180, 0, "Time per patient: " + state.levelTime + " seconds", 40);
        // infoText.font = "assets/fonts/Cabin-Regular.ttf";
        // infoText.color = FlxColor.BLACK;
        // add(infoText);

        var state = PlayState.getInstance();

        levelText = new FlxText(50, 180, 950, state.levelText, 45);
        levelText.font = "assets/fonts/Cabin-Regular.ttf";
        levelText.color = FlxColor.BLACK;
        add(levelText);

        // Now add small status images for each patient
        var i = 0;
        for (patient in state.incomingPatients) {
            var p = new PatientIcon(patient);
            patientIcons.push(p);
            p.x = 20 + (i * (200 + 20));
            p.y = (FlxG.height - 500);
            add(p);
            i+= 1;


            if (patient.isVIP) {
                goldFilter = new GlowFilter(FlxColor.GOLDEN, 1, 150, 150, 1.5, 1);
                filter = new FlxSpriteFilter(p.bodySprite);
                filter.addFilter(goldFilter);
                filterTween = FlxTween.tween(goldFilter, { blurX: 50, blurY: 50 }, 0.5, { type: FlxTween.PINGPONG });
            }
        }

        if (state.level.vip != null) {
            var p = new PatientIcon(state.level.vip);
            patientIcons.push(p);
            p.x = FlxG.width - 250;
            p.y = (FlxG.height - 475);
            add(p);

            goldFilter = new GlowFilter(FlxColor.GOLDEN, 1, 150, 150, 1.5, 1);
            filter = new FlxSpriteFilter(p.bodySprite);
            filter.addFilter(goldFilter);
            filterTween = FlxTween.tween(goldFilter, { blurX: 50, blurY: 50 }, 0.5, { type: FlxTween.PINGPONG });
        }

        btnPlay = Utils.createButton("Continue", clickPlay, 5);
        btnPlay.x = 300;
        btnPlay.y = 700;
        add(btnPlay);

        super.create();

        // Cancel the fade
        FlxG.camera.stopFX();
    }

    override function update() {
        super.update();

        if (filter != null) {
            filter.applyFilters();
        }

        if (FlxG.keys.justReleased.SPACE) {
            clickPlay();
        }
    }

    private function clickPlay():Void {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
            PlayState.getInstance().isActive = true;
            close();
            FlxG.camera.stopFX();
        });
    }

    override function destroy() {
        super.destroy();

        background = FlxDestroyUtil.destroy(background);
        dayText = FlxDestroyUtil.destroy(dayText);
        infoText = FlxDestroyUtil.destroy(infoText);
        levelText = FlxDestroyUtil.destroy(levelText);
        btnPlay = FlxDestroyUtil.destroy(btnPlay);

        // filter = FlxDestroyUtil.destroy(filter);
        // goldFilter = FlxDestroyUtil.destroy(goldFilter);
        filterTween = FlxDestroyUtil.destroy(filterTween);

        for (p in patientIcons) {
            FlxDestroyUtil.destroy(p);
        }
        patientIcons = null;
    }
}