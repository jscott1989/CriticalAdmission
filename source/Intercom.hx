 package;

 import flixel.FlxG;

/**
 * Intercom that spouts "helpful" hints for the player
 */
 class Intercom extends UIElement {

    public function new(X:Float=0, Y:Float=0, state:PlayState)  {
        super(X, Y, "Intercom", state);
    }
 }