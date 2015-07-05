 package;

 import flixel.FlxG;
 import flixel.FlxState;
 import flixel.group.FlxSpriteGroup;
 import flixel.tweens.FlxTween;

/**
 * This includes the patient and the bed they are on.
 * It also includes all of the holes. Some of them
 * will be covered
 */
 class Patient extends FlxSpriteGroup {

    public var _holes:Array<Hole>;

    public function new(X:Float=0, Y:Float=0, state:PlayState)  {
        super(X, Y);
        _holes = new Array<Hole>();
        _holes.push(new BodyHole(0, 0, new Organ(0, 0, "Heart", state)));
        _holes.push(new BodyHole(0, 200));

        for (hole in _holes) {
            add(hole);
        }
    }

    public override function update() {
        super.update();
    }
 }