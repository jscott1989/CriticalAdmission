 package;

 import flixel.FlxG;
 import flixel.FlxState;
 import flixel.FlxSprite;
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

        var backgroundSprite = new FlxSprite(0, 0);
        backgroundSprite.loadGraphic("assets/images/Body.png");
        add(backgroundSprite);

        // TODO: They should have all of the holes - but some should be
        // covered and disabled
        _holes = new Array<Hole>();
        _holes.push(new BodyHole(50, 10));
        _holes.push(new BodyHole(50, 80, new Organ(0, 0, "Heart", state)));
        _holes.push(new BodyHole(50, 160));

        // Add the hole into the group
        for (hole in _holes) {
            add(hole);
        }
    }
 }