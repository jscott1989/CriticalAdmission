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
    public var interactable:Interactable;

    public function new(X:Float=0, Y:Float=0)  {
        super(X, Y);
    }

    /**
     * Spawn an interactable in this hole.
     */
    public function initInteractable(interactable:Interactable) {

        // center it
        interactable.x = x + ((width - interactable.width)/2);
        interactable.y = y + ((height - interactable.height)/2);

        // then add as normal - making sure we don't move it
        addInteractable(interactable, false);
    }

    /**
     * Is this hole empty?
     */
    public function isEmpty() {
        return interactable == null;
    }

    public function addInteractable(interactable:Interactable, position:Bool = true) {
        this.interactable = interactable;
        interactable.hole = this;

        // We get the size BEFORE adding the interactable
        // so that centering works correctly
        var bWidth = width;
        var bHeight = height;
        var bx = interactable.x;
        var by = interactable.y;
        add(interactable);

        // Re-set the interactable position
        interactable.x = bx;
        interactable.y = by;

        if (position) {
            // Then move it to the center
            FlxTween.tween(interactable, {x: x + ((bWidth - interactable.width)/2), y: y + ((bHeight - interactable.height)/2)}, 0.1);
        }

    }

    /**
     * Remove the organ from the hole
     */
    public function removeInteractable() {
        interactable.hole = null;
        remove(interactable, true);
        interactable = null;
    }
 }