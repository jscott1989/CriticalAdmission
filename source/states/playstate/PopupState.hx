 package states.playstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;

using flixel.util.FlxSpriteUtil;

class PopupState extends FlxSubState {

    private var title:String;
    private var text:String;

    public function new(title:String, text:String) {
        this.title = title;
        this.text = text;
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

        var headerText = new FlxText(0, 0, background.width - 380, title, 80);
        headerText.font = "assets/fonts/Cabin-Bold.ttf";
        headerText.color = FlxColor.BLACK;

        var bodyText = new FlxText(0, 0, background.width - 200, text, 60);
        bodyText.font = "assets/fonts/Cabin-Regular.ttf";
        bodyText.color = FlxColor.BLACK;

        headerText.x = background.x + 280;
        bodyText.x = background.x + 100;

        headerText.y = background.y + 70;
        bodyText.y = background.y + 240;

        add(headerText);
        add(bodyText);

        var continueButton = Utils.createButton("Continue", clickContinue, 5);
        continueButton.x = background.x + background.width - (continueButton.width + 100);
        continueButton.y = background.y + background.height - (continueButton.height + 50);
        add(continueButton);

        var skipButton = Utils.createButton("Skip Tutorial", clickSkip, 5);
        skipButton.x = background.x + 100;
        skipButton.y = continueButton.y;
        add(skipButton);
        super.create();
    }

    function clickContinue() {
        close();
    }

    function clickSkip() {
        PlayState.getInstance().skipTutorial = true;
        close();
    }
}