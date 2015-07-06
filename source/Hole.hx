 package;

 import flixel.FlxG;
 import flixel.FlxState;
 import flixel.group.FlxSpriteGroup;
 import flixel.tweens.FlxTween;

/**
 * A hole is used to contain an Organ
 */
 class Hole extends FlxSpriteGroup {

    // The contained organ
    public var _inter:Interactable;

    public function new(X:Float=0, Y:Float=0)  {
        super(X, Y);
    }

    /**
     * Spawn an interactable in this hole.
     */
    public function initInteractable(inter:Interactable) {

        // center it
        inter.x = x + ((width - inter.width)/2);
        inter.y = y + ((height - inter.height)/2);

        // then add as normal - making sure we don't move it
        addInteractable(inter, false);
    }

    /**
     * Is this hole empty?
     */
    public function isEmpty() {
        return _inter == null;
    }

    public function addInteractable(inter:Interactable, position:Bool = true) {
        _inter = inter;
        _inter.hole = this;

        // We get the size BEFORE adding the interactable
        // so that centering works correctly
        var bWidth = width;
        var bHeight = height;
        var bx = _inter.x;
        var by = _inter.y;
        add(_inter);

        // Re-set the interactable position
        _inter.x = bx;
        _inter.y = by;

        if (position) {
            // Then move it to the center
            FlxTween.tween(_inter, {x: x + ((bWidth - inter.width)/2), y: y + ((bHeight - inter.height)/2)}, 0.1);
        }

    }

    /**
     * Remove the organ from the hole
     */
    public function removeInteractable() {
        _inter.hole = null;
        remove(_inter, true);
        _inter = null;
    }
 }