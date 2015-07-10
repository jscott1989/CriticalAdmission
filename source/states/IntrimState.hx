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
    private var dayText:FlxText;
    private var scoreText:FlxText;
    private var breakdownText:FlxText;
    private var btnPlay:FlxButton;

    private var day:Int;
    private var score:Int;    

    private var levelScore:Array<Patient>;

    public function new(day:Int, score:Int, levelScore:Array<Patient>)  {
        this.day = day;
        this.score = score;
        this.levelScore = levelScore;
        super();
    }

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        // fill background with black
        var background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(background);

        dayText = new FlxText(50, 50, 0, "Day "+ day + ":", 100);
        add(dayText);

        scoreText = new FlxText(50, 200, 0, "Patients treated so far: "+ score, 50);
        add(scoreText);

        breakdownText = new FlxText(50, 250, 0, "Patient Breakdown:", 50);
        add(breakdownText);

        btnPlay = Utils.createButton("Continue", clickPlay, 5, 30);
        btnPlay.screenCenter();
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