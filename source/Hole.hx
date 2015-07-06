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
    public var _organ:Organ;

    public function new(X:Float=0, Y:Float=0)  {
        super(X, Y);
    }

    /**
     * Spawn an organ in this hole.
     */
    public function initOrgan(organ:Organ) {

        // center it
        organ.x = x + ((width - organ.width)/2);
        organ.y = y + ((height - organ.height)/2);

        // then add as normal - making sure we don't move it
        addOrgan(organ, false);
    }

    /**
     * Is this hole empty?
     */
    public function isEmpty() {
        return _organ == null;
    }

    public function addOrgan(organ:Organ, position:Bool = true) {
        _organ = organ;
        _organ.hole = this;

        // We get the size BEFORE adding the organ
        // so that centering works correctly
        var bWidth = width;
        var bHeight = height;
        var bx = _organ.x;
        var by = _organ.y;
        add(_organ);

        // Re-set the organ position
        _organ.x = bx;
        _organ.y = by;

        if (position) {
            // Then move it to the center
            FlxTween.tween(_organ, {x: x + ((bWidth - organ.width)/2), y: y + ((bHeight - organ.height)/2)}, 0.1);
        }

    }

    /**
     * Remove the organ from the hole
     */
    public function removeOrgan() {
        _organ.hole = null;
        remove(_organ, true);
        _organ = null;
    }
 }