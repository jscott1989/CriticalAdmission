package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;

/**
 * This gives an overview of progress so far, in between levels
 */
class IntrimState extends FlxSubState {
    private var _dayText:FlxText;
    private var _scoreText:FlxText;
    private var _breakdownText:FlxText;
    private var _btnPlay:FlxButton;
    private var _state:PlayState;

    private var _day:Int;
    private var _score:Int;    

    private var _levelScore:Array<Patient>;

    public function new(state:PlayState, day:Int, score:Int, levelScore:Array<Patient>)  {
        _state = state;
        _day = day;
        _score = score;
        _levelScore = levelScore;
        super();
    }

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        // fill background with black
        var background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
        add(background);

        _dayText = new FlxText(50, 50); // x, y, width
        //_dayText.setFormat("assets/font.ttf", 20, FlxColor.WHITE, "center");
        _dayText.autoSize = true;
        _dayText.text = "Day "+ _day + ":";

        _scoreText = new FlxText(50, 100); // x, y, width
        _scoreText.autoSize = true;
        _scoreText.text = "Patients treated so far: "+ _score;

        _breakdownText = new FlxText(50, 150); // x, y, width
        _breakdownText.autoSize = true;
        _breakdownText.text = "Patient Breakdown:";


        _btnPlay = new FlxButton(0, 0, "Continue", clickPlay);
        _btnPlay.screenCenter();
        add(_btnPlay);

        super.create();
    }

    private function clickPlay():Void {
        _state.nextLevel();
        close();
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