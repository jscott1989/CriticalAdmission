package states.playstate;

 import flixel.FlxSprite;
 import flixel.group.FlxSpriteGroup;

/**
 * This includes the patient and the bed they are on.
 * It also includes all of the holes. Some of them
 * will be covered
 */
 class Patient extends FlxSpriteGroup {
    public var holes:Array<Hole>;
    public var body_holes:Array<BodyHole>;

    // TODO: Fill in these lists
    public static var FIRST_NAMES:Array<String> = ["A", "B"];
    public static var SURNAMES:Array<String> = ["C", "D"];

    private var isMale:Bool;
    public var name:String;

    public function new(X:Float=0, Y:Float=0)  {
        super(X, Y);

        isMale = Std.random(2) == 0;

        // name = FIRST_NAMES[Std.random(FIRST_NAMES.length)] + " " + SURNAMES[Std.random(SURNAMES.length)];
        name = "Test";

        var bedSprite = new FlxSprite();
        bedSprite.loadGraphic("assets/images/Bed.png");
        add(bedSprite);

        var bodySprite = new FlxSprite(-5, -10);
        if (isMale) {
            bodySprite.loadGraphic("assets/images/Man" + (Std.random(3) + 1) + ".png");
        } else {
            bodySprite.loadGraphic("assets/images/Woman" + (Std.random(3) + 1) + ".png");
            bodySprite.x = -70;
            bodySprite.y = -10;
        }
        add(bodySprite);

        var hairSprite = new FlxSprite();
        var hairStyle = Std.random(15)+1;
        hairSprite.loadGraphic("assets/images/Hair" + hairStyle + "-" + (Std.random(3) + 1) + ".png");

        if (hairStyle == 1) {
            hairSprite.x = 225;
            hairSprite.y = 10;
        } else if (hairStyle == 2) {
            hairSprite.x = 205;
            hairSprite.y = 10;
        } else if (hairStyle == 3) {
            hairSprite.x = 215;
            hairSprite.y = -10;
        } else if (hairStyle == 4) {
            hairSprite.x = 175;
            hairSprite.y = -70;
        } else if (hairStyle == 5) {
            hairSprite.x = 110;
            hairSprite.y = 5;
        } else if (hairStyle == 6) {
            hairSprite.x = 215;
            hairSprite.y = -5;
        } else if (hairStyle == 7) {
            hairSprite.x = 225;
            hairSprite.y = -5;
        } else if (hairStyle == 8) {
            hairSprite.x = 310;
            hairSprite.y = -40;
        } else if (hairStyle == 9) {
            hairSprite.x = 245;
            hairSprite.y = 10;
        } else if (hairStyle == 10) {
            hairSprite.x = 220;
            hairSprite.y = -10;
        } else if (hairStyle == 11) {
            hairSprite.x = 270;
            hairSprite.y = -10;
        } else if (hairStyle == 12) {
            hairSprite.x = 222;
            hairSprite.y = -40;
        } else if (hairStyle == 13) {
            hairSprite.x = 172;
            hairSprite.y = 0;
        } else if (hairStyle == 14) {
            hairSprite.x = 200;
            hairSprite.y = -50;
        } else if (hairStyle == 15) {
            hairSprite.x = 240;
            hairSprite.y = 0;
        }
        add(hairSprite);

        
        holes = new Array<Hole>();
        body_holes = new Array<BodyHole>();
        body_holes.push(new BodyHole(275, 60, "Brain", new Organ("Brain"), false, true));
        body_holes.push(new BodyHole(400, 500, "Heart", new Organ("Heart")));
        body_holes.push(new BodyHole(300, 750, "Guts"));
        body_holes.push(new BodyHole(20, 370, "LeftElbow"));
        body_holes.push(new BodyHole(600, 390, "RightElbow", true));
        // body_holes.push(new BodyHole(40, 1300, "LeftFoot"));
        // body_holes.push(new BodyHole(570, 1280, "RightFoot"));
        body_holes.push(new BodyHole(140, 1050, "LeftKnee"));
        body_holes.push(new BodyHole(500, 1050, "RightKnee", true));
        // body_holes.push(new BodyHole(10, 670, "LeftHand"));
        // body_holes.push(new BodyHole(580, 670, "RightHand"));
        body_holes.push(new BodyHole(230, 600, "Lung"));
        // holes.push(new UIHole(100, 1100, new Clipboard(this)));

        for (hole in body_holes) {
            holes.push(hole);
        }

        // Add the hole into the group
        for (hole in holes) {
            add(hole);
        }
    }

    /**
     * Get the Quality Of Life for this patient.
     */
    public function getQOL() {
        var qol:Float = 1.0;

        var total = 0;

        for (hole in body_holes) {
            total += hole.getQOL();
        }

        return Math.floor(total / body_holes.length);
    }
 }