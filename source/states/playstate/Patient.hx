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

    public var info:PatientInfo;

    public var bodySprite:FlxSprite;
    public var bedSprite:FlxSprite;

    public function new(info:PatientInfo, X:Float=0, Y:Float=0)  {
        super(X, Y);

        this.info = info;

        bedSprite = new FlxSprite();
        bedSprite.loadGraphic("assets/images/Bed.png");
        add(bedSprite);

        bodySprite = new FlxSprite(-5, -10);
        if (info.isMale) {
            bodySprite.loadGraphic("assets/images/Man" + info.bodySprite + ".png");
        } else {
            bodySprite.loadGraphic("assets/images/Woman" + info.bodySprite + ".png");
            bodySprite.x = -70;
            bodySprite.y = -10;
        }
        add(bodySprite);

        var hairSprite = new FlxSprite();
        hairSprite.loadGraphic("assets/images/Hair" + info.hairStyle + "-" + info.hairColor + ".png");

        if (info.hairStyle == 1) {
            hairSprite.x = 225;
            hairSprite.y = 10;
        } else if (info.hairStyle == 2) {
            hairSprite.x = 205;
            hairSprite.y = 10;
        } else if (info.hairStyle == 3) {
            hairSprite.x = 215;
            hairSprite.y = -10;
        } else if (info.hairStyle == 4) {
            hairSprite.x = 175;
            hairSprite.y = -70;
        } else if (info.hairStyle == 5) {
            hairSprite.x = 110;
            hairSprite.y = 5;
        } else if (info.hairStyle == 6) {
            hairSprite.x = 215;
            hairSprite.y = -5;
        } else if (info.hairStyle == 7) {
            hairSprite.x = 225;
            hairSprite.y = -5;
        } else if (info.hairStyle == 8) {
            hairSprite.x = 310;
            hairSprite.y = -40;
        } else if (info.hairStyle == 9) {
            hairSprite.x = 245;
            hairSprite.y = 10;
        } else if (info.hairStyle == 10) {
            hairSprite.x = 220;
            hairSprite.y = -10;
        } else if (info.hairStyle == 11) {
            hairSprite.x = 270;
            hairSprite.y = -10;
        } else if (info.hairStyle == 12) {
            hairSprite.x = 222;
            hairSprite.y = -40;
        } else if (info.hairStyle == 13) {
            hairSprite.x = 172;
            hairSprite.y = 0;
        } else if (info.hairStyle == 14) {
            hairSprite.x = 200;
            hairSprite.y = -50;
        } else if (info.hairStyle == 15) {
            hairSprite.x = 240;
            hairSprite.y = 0;
        }
        add(hairSprite);

        
        holes = new Array<Hole>();
        body_holes = new Array<BodyHole>();
        body_holes.push(new BodyHole(275, 60, "Brain", createInteractable(info.brain), false, info.brainCovered));
        body_holes.push(new BodyHole(400, 500, "Heart", createInteractable(info.heart), false, info.heartCovered));
        body_holes.push(new BodyHole(230, 600, "Lung", createInteractable(info.lung), false, info.lungCovered));
        body_holes.push(new BodyHole(300, 750, "Guts", createInteractable(info.guts), false, info.gutsCovered));
        body_holes.push(new BodyHole(20, 370, "LeftElbow", createInteractable(info.leftElbow), false, info.leftElbowCovered));
        body_holes.push(new BodyHole(600, 390, "RightElbow", createInteractable(info.rightElbow), true, info.rightElbowCovered));
        // body_holes.push(new BodyHole(40, 1300, "LeftFoot"));
        // body_holes.push(new BodyHole(570, 1280, "RightFoot"));
        body_holes.push(new BodyHole(140, 1050, "LeftKnee", createInteractable(info.leftKnee), false, info.leftKneeCovered));
        body_holes.push(new BodyHole(500, 1050, "RightKnee", createInteractable(info.rightKnee), true, info.rightKneeCovered));
        // body_holes.push(new BodyHole(10, 670, "LeftHand"));
        // body_holes.push(new BodyHole(580, 670, "RightHand"));
        // holes.push(new UIHole(100, 1100, new Clipboard(this)));

        for (hole in body_holes) {
            holes.push(hole);
        }

        // Add the hole into the group
        for (hole in holes) {
            add(hole);
        }
    }

    public static inline function createInteractable(organType:String=null) {
        if (organType == null) {
            return null;
        }
        return new Organ(organType);
    }
 }