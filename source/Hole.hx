 package;

 import flixel.FlxG;
 import flixel.FlxState;
 import flixel.group.FlxSpriteGroup;
 import flixel.tweens.FlxTween;

 class Hole extends FlxSpriteGroup {

    public var _organ:Organ;

    public function new(X:Float=0, Y:Float=0)  {
        super(X, Y);
    }

    /**
     * Spawn an organ in this hole.
     */
    public function initOrgan(organ:Organ) {
        organ.x = x + ((width - organ.width)/2);
        organ.y = y + ((height - organ.height)/2);
        addOrgan(organ, false);
    }

    public override function update() {
        super.update();
    }

    public function isEmpty() {
        return _organ == null;
    }

    public function addOrgan(organ:Organ, position:Bool = true) {
        FlxG.log.add("Add organ");
        _organ = organ;
        _organ.hole = this;
        var bWidth = width;
        var bHeight = height;
        var bx = _organ.x;
        var by = _organ.y;
        add(_organ);
        _organ.x = bx;
        _organ.y = by;

        if (position) {
            FlxTween.tween(_organ, {x: x + ((bWidth - organ.width)/2), y: y + ((bHeight - organ.height)/2)}, 0.1);
        }

    }

    public function removeOrgan() {
        FlxG.log.add("Remove organ");
        _organ.hole = null;
        remove(_organ, true);
        _organ = null;
    }
 }