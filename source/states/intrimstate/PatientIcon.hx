package states.intrimstate;

 import flixel.FlxSprite;
 import flixel.group.FlxSpriteGroup;
 import flixel.util.FlxPoint;

/**
 * This includes the patient in a smaller form, and has dots indicating
 * the QoL value of different parts
 */
 class PatientIcon extends FlxSpriteGroup {
    public var info:PatientInfo;

    public var bodySprite:FlxSprite;

    public static inline var SCALE = 0.3;

    public function new(info:PatientInfo, X:Float=0, Y:Float=0)  {
        super(X, Y);

        this.info = info;

        bodySprite = new FlxSprite(-5, -10);
        if (info.isMale) {
            bodySprite.loadGraphic("assets/images/Man" + info.bodySprite + ".png");
            bodySprite.scale.set(SCALE, SCALE);
            bodySprite.updateHitbox();
        } else {
            bodySprite.loadGraphic("assets/images/Woman" + info.bodySprite + ".png");
            bodySprite.scale.set(SCALE, SCALE);
            bodySprite.updateHitbox();
            bodySprite.x = (-70 * SCALE);
            bodySprite.y = (-10 * SCALE);
        }
        add(bodySprite);

        var hairSprite = new FlxSprite();
        hairSprite.loadGraphic("assets/images/Hair" + info.hairStyle + "-" + info.hairColor + ".png");
        hairSprite.scale.set(SCALE, SCALE);
        hairSprite.updateHitbox();

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

        hairSprite.x *= SCALE;
        hairSprite.y *= SCALE;
        add(hairSprite);
    }
 }