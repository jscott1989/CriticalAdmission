package states.playstate;

 import flixel.FlxSprite;
 import flixel.util.FlxColorUtil;

/**
 * This is a hole in the UI - right now the difference is just the background
 * but in future we may want things to act differently if they're on the UI
 * or in a body
 */
 class UIHole extends Hole {

    public function new(ui:Interactable=null, requiresFlip:Bool=false, locked:Bool=false)  {
        var backgroundSprite = new FlxSprite();
        backgroundSprite.makeGraphic(200, 190, FlxColorUtil.makeFromARGB(0.4, 0, 0, 0));
        super(backgroundSprite, ui, requiresFlip, locked, 0, 0);
    }
 }