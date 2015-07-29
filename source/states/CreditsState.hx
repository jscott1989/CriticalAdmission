package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;

/**
 * Game's menu. Disabled at the moment.
 */
class CreditsState extends FlxSubState {

    private var btnBack:FlxButton;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        // Fill background with black
        var background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        var logo = new FlxSprite(0,0);
        logo.loadGraphic("assets/images/Logo.png");
        add(logo);

        var intro = new FlxText(100, 330, 700, "Critical Admission was a game created in one month for the Something Awful Gamedev Challenge X (theme: Critical Omission).\n\nIt was created by Jonathan Scott, Tom Blount, David Millard, Priyanka Singh, and Devasena Prasad.\n\nThe receptionist was voiced by Melanie Ehrlich.", 40);
        intro.font = "assets/fonts/Cabin-Bold.ttf";
        intro.color = FlxColor.BLACK;
        add(intro);

        var grenade = new FlxSprite(0,0);
        grenade.loadGraphic("assets/images/Grenade.png");
        grenade.x = FlxG.width - grenade.width;
        grenade.y = FlxG.height - grenade.height;
        add(grenade);

        btnBack = Utils.createButton("Back", clickBack, 5);
        btnBack.screenCenter();
        btnBack.y = 1375;
        add(btnBack);

        super.create();

        // Cancel the fade
        FlxG.camera.stopFX();
    }

    private function clickBack():Void {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
            close();
            FlxG.camera.stopFX();
        });
    }
    
    /**
     * Function that is called when this state is destroyed - you might want to 
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void {
        super.destroy();

        btnBack = FlxDestroyUtil.destroy(btnBack);
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void {
        super.update();
    }   
}