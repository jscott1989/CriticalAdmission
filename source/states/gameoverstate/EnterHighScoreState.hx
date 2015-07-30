 package states.gameoverstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import sounds.SoundManager;

using flixel.util.FlxSpriteUtil;

class EnterHighScoreState extends FlxSubState {

    private var level:Int;
    private var patients:Int;

    public function new(level:Int, patients:Int) {
        this.level = level;
        this.patients = patients;
        SoundManager.getInstance().playSound(AssetPaths.popup__wav);
        super();
    }

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        var i = new FlxSprite(0, 0);
        i.makeGraphic(FlxG.width, FlxG.height, FlxColorUtil.makeFromARGB(0.8, 0, 0, 0));
        add(i);

        // fill background with black
        var background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/Popup.png");

        background.screenCenter();

        background.y = (FlxG.height / 2) - (background.height / 2);

        add(background);

        var headerText = new FlxText(0, 0, background.width - 380, "HIGH SCORE", 80);
        headerText.font = "assets/fonts/Cabin-Bold.ttf";
        headerText.color = FlxColor.BLACK;

        var bodyText = new FlxText(0, 0, background.width - 200, "You have a new high score!", 60);
        bodyText.font = "assets/fonts/Cabin-Regular.ttf";
        bodyText.color = FlxColor.BLACK;

        headerText.x = background.x + 280;
        bodyText.x = background.x + 100;

        headerText.y = background.y + 70;
        bodyText.y = background.y + 240;

        add(headerText);
        add(bodyText);

        var nameText = new FlxText(0, 0, 0, "Name", 60);
        nameText.x = background.x + 100;
        nameText.y = background.y + 400;
        add(nameText);

        var highscoreName = new FlxInputText(background.x + 300, background.y + 400, 900, "", 70, FlxColor.BLACK, FlxColor.WHITE);
        add(highscoreName);

        var highscoreButton = Utils.createButton("Save", function() {
            states.HighscoreState.addHighscore(highscoreName.text, this.level, this.patients);
            clickCancel();
        }, 5);
        highscoreButton.x = background.x + 100;
        highscoreButton.y = background.y + background.height - (highscoreButton.height + 50);
        add(highscoreButton);

        var cancelButton = Utils.createButton("Cancel", clickCancel, 5);
        cancelButton.x = background.x + background.width - (cancelButton.width + 100);
        cancelButton.y = background.y + background.height - (cancelButton.height + 50);
        add(cancelButton);
    }

    function clickCancel() {
        SoundManager.getInstance().playSound(AssetPaths.popdown__wav);
        close();
    }
}