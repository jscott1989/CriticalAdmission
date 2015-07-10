package states.playstate;

 import flixel.FlxG;
 import flixel.util.FlxRandom;

/**
 * Scalpel that allows the opening of holes
 */
 class Scalpel extends UIElement {

    public function new(X:Float=0, Y:Float=0)  {
        super("Scalpel", X, Y);
    }

    public override function dropped() {

        var closestHole = PlayState.getInstance().getClosestHole(FlxG.mouse.x, FlxG.mouse.y, true, true);

        if (closestHole != null && Type.getClass(closestHole) == BodyHole && closestHole.isHidden) {

            // Open the hole
            closestHole.show();

            // Put the scalpel back
            PlayState.getInstance().returnDragged();

            return true;
        }
        return false;
    }
 }