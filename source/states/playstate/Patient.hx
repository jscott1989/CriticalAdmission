package states.playstate;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxSpriteGroup;
 import flixel.util.FlxDestroyUtil;

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

    private var hairSprite:FlxSprite;
    private var medalSprite:FlxSprite;
    private var crownSprite:FlxSprite;

    public function new(info:PatientInfo, X:Float=0, Y:Float=0)  {
        super(X, Y);

        // TODO: Clone it so it doesn't damage the original
        this.info = info;
        this.info.initialQOL = this.info.getQOL();

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

        hairSprite = new FlxSprite();
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

        if (info.isVIP) {
            if (info.crown > 0) {
                crownSprite = new FlxSprite();
                crownSprite.loadGraphic("assets/images/Crown-" + info.crown + ".png");
                crownSprite.x = 150;
                crownSprite.y = -155;
                if (info.crown == 2) {
                    crownSprite.x = 226;
                    crownSprite.y = -125;
                }
                add(crownSprite);
            }

            if (info.medals) {
                medalSprite = new FlxSprite();
                medalSprite.loadGraphic("assets/images/Medals.png");
                medalSprite.x = 100;
                medalSprite.y = 550;
                add(medalSprite);
            }
        }

        
        holes = new Array<Hole>();
        body_holes = new Array<BodyHole>();
        body_holes.push(new BodyHole(this, 275, 60, "Brain", Interactable.createInteractable(info.brain), false, info.brainCovered));
        body_holes.push(new BodyHole(this, 400, 500, "Heart", Interactable.createInteractable(info.heart), false, info.heartCovered));
        body_holes.push(new BodyHole(this, 230, 600, "Lung", Interactable.createInteractable(info.lung), false, info.lungCovered));
        body_holes.push(new BodyHole(this, 300, 750, "Guts", Interactable.createInteractable(info.guts), false, info.gutsCovered));
        body_holes.push(new BodyHole(this, 20, 370, "LeftElbow", Interactable.createInteractable(info.leftElbow), false, info.leftElbowCovered));
        body_holes.push(new BodyHole(this, 600, 390, "RightElbow", Interactable.createInteractable(info.rightElbow), true, info.rightElbowCovered));
        body_holes.push(new BodyHole(this, 140, 1050, "LeftKnee", Interactable.createInteractable(info.leftKnee), false, info.leftKneeCovered));
        body_holes.push(new BodyHole(this, 500, 1050, "RightKnee", Interactable.createInteractable(info.rightKnee), true, info.rightKneeCovered));

        for (hole in body_holes) {
            holes.push(hole);
        }

        // Add the hole into the group
        for (hole in holes) {
            add(hole);
        }
    }

    public function die() {
        if (info.isMale) {
            bodySprite.loadGraphic("assets/images/Man" + info.bodySprite + "-dead.png");
        } else {
            bodySprite.loadGraphic("assets/images/Woman" + info.bodySprite + "-dead.png");
        }
    }

    public override function destroy() {
        super.destroy();
        for (hole in holes) {
            hole = FlxDestroyUtil.destroy(hole);
        }

        holes = null;
        body_holes = null;

        bodySprite = FlxDestroyUtil.destroy(bodySprite);
        bedSprite = FlxDestroyUtil.destroy(bedSprite);

        hairSprite = FlxDestroyUtil.destroy(hairSprite);
        medalSprite = FlxDestroyUtil.destroy(medalSprite);
        crownSprite = FlxDestroyUtil.destroy(crownSprite);
    }
 }