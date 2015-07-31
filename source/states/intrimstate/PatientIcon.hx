package states.intrimstate;

 import flixel.FlxSprite;
 import flixel.group.FlxSpriteGroup;
 import flixel.util.FlxColor;
 import flixel.util.FlxColorUtil;
 import flixel.util.FlxDestroyUtil;

 using flixel.util.FlxSpriteUtil;

/**
 * This includes the patient in a smaller form, and has dots indicating
 * the QoL value of different parts
 */
 class PatientIcon extends FlxSpriteGroup {
    public var info:PatientInfo;

    public var bodySprite:FlxSprite;
    public var hairSprite:FlxSprite;
    public var crownSprite:FlxSprite;
    public var medalSprite:FlxSprite;

    public static inline var SCALE = 0.3;

    public static function generateHealthDot(health:Int, size:Int, x:Float=0, y:Float=0) {

        var s = new FlxSprite(x, y);
        s.makeGraphic(size, size, FlxColor.TRANSPARENT, true);

        if (health < 100){
            s.drawCircle(size/2,size/2,size/2, FlxColor.RED);
            if (health > 0) {
                s.drawCircle(size/2,size/2,size/2, FlxColorUtil.makeFromARGB(health / 100, 255, 191, 0));
            }
        }
        return s;
    }

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

        hairSprite = new FlxSprite();
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

        if (info.isVIP) {
            if (info.crown > 0) {
                crownSprite = new FlxSprite();
                crownSprite.loadGraphic("assets/images/Crown-" + info.crown + ".png");
                crownSprite.scale.set(SCALE, SCALE);
                crownSprite.x = -130;
                crownSprite.y = -170;
                if (info.crown == 2) {
                    crownSprite.x = -50;
                    crownSprite.y = -120;
                }
                add(crownSprite);
            }

            if (info.medals) {
                medalSprite = new FlxSprite();
                medalSprite.loadGraphic("assets/images/Medals.png");
                medalSprite.scale.set(SCALE, SCALE);
                medalSprite.x = -80;
                medalSprite.y = 25;
                add(medalSprite);
            }

            trace("VIP", info.name, info.getQOL());
        }

        add(generateHealthDot(info.getBrainQOL(), 30, 325 * SCALE, 90 * SCALE));
        add(generateHealthDot(info.getHeartQOL(), 30, 400 * SCALE, 500 * SCALE));
        add(generateHealthDot(info.getLungQOL(),  30, 270 * SCALE, 600 * SCALE));
        add(generateHealthDot(info.getGutsQOL(),  30, 350 * SCALE, 790 * SCALE));
        add(generateHealthDot(info.getLeftElbowQOL(), 30, 50 * SCALE, 420 * SCALE));
        add(generateHealthDot(info.getRightElbowQOL(), 30, 630 * SCALE, 420 * SCALE));
        add(generateHealthDot(info.getLeftKneeQOL(), 30, 170 * SCALE, 1150 * SCALE));
        add(generateHealthDot(info.getRightKneeQOL(), 30, 530 * SCALE, 1150 * SCALE));
    }

    override function destroy() {
        super.destroy();

        FlxDestroyUtil.destroy(bodySprite);
        FlxDestroyUtil.destroy(hairSprite);
        FlxDestroyUtil.destroy(crownSprite);
        FlxDestroyUtil.destroy(medalSprite);
    }
 }