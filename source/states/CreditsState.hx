package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.plugin.MouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;
import flash.Lib;
import flash.net.URLRequest;

/**
 * Game's menu. Disabled at the moment.
 */
class CreditsState extends FlxSubState {

    private var btnBack:FlxButton;

    private var overGrenade = false;
    private var tooltipText:FlxText;
    private var tooltipSprite:FlxSprite;

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

        var intro = new FlxText(100, 330, 700, "Critical Admission is a game created in one month for the Something Awful Gamedev Challenge X (theme: Critical Omission).\n\nIt was created by Jonathan Scott, Tom Blount, David Millard, Priyanka Singh, and Devasena Prasad.\n\nThe receptionist was voiced by Melanie Ehrlich.", 40);
        intro.font = "assets/fonts/Cabin-Bold.ttf";
        intro.color = FlxColor.BLACK;
        add(intro);

        tooltipText = new FlxText(0, 0, 0, "SAGDCX", 50); 
        tooltipText.font = "assets/fonts/Cabin-Regular.ttf";
        tooltipSprite = new FlxSprite();
        tooltipSprite.makeGraphic(Std.int(tooltipText.width + 50), Std.int(tooltipText.height), FlxColor.BLACK);
        add(tooltipText);
        add(tooltipSprite);

        var grenade = new FlxSprite(0,0);
        grenade.loadGraphic("assets/images/Grenade.png");
        grenade.x = FlxG.width - grenade.width;
        grenade.y = FlxG.height - grenade.height;

        var tween:FlxTween = null;

        MouseEventManager.add(grenade, function(sprite:FlxSprite) {
            if (tween != null) tween.cancel();
            tween = FlxTween.tween(sprite.scale,{"x": 1.2, "y": 1.2}, 0.1);
        }, function(sprite:FlxSprite) {
            if (tween != null) tween.cancel();
            tween = FlxTween.tween(sprite.scale,{"x": 1, "y": 1}, 0.1);
            Lib.getURL (new URLRequest ("http://awfuljams.com"));
        }, function(sprite:FlxSprite) {
            overGrenade = true;
        }, function(sprite:FlxSprite) {
            if (tween != null) tween.cancel();
            tween = FlxTween.tween(sprite.scale,{"x": 1, "y": 1}, 0.1);
            overGrenade = false;
        });
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
        close();
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
        if (overGrenade) {
            tooltipText.x = FlxG.mouse.x - (tooltipText.width / 2);
            tooltipText.y = FlxG.mouse.y + tooltipText.height + 20;

            Utils.bringToFront(members, tooltipSprite);
            Utils.bringToFront(members, tooltipText, tooltipSprite);

            tooltipSprite.x = tooltipText.x - 25;
            tooltipSprite.y = tooltipText.y;
        } else {
            tooltipText.x = -1000;
            tooltipText.y = -1000;
            tooltipSprite.x = -1000;
            tooltipSprite.y = -1000;

        }
        super.update();
    }   
}