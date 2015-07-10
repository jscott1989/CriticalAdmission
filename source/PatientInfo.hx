package;

 import flixel.FlxSprite;
 import flixel.group.FlxSpriteGroup;

/**
 * Contain stats about a patient
 *
 * Put it here so the actual Patient can be destroyed.
 */
 class PatientInfo {
    public static var FIRST_NAMES:Array<String> = ["A", "B"];
    public static var SURNAMES:Array<String> = ["C", "D"];

    public var isMale:Bool;
    public var name:String;
    public var bodySprite:Int;
    public var hairStyle:Int;
    public var hairColor:Int;

    public var brainCovered:Bool = true;
    public var heartCovered:Bool = true;
    public var gutsCovered:Bool = true;
    public var lungCovered:Bool = true;
    public var leftElbowCovered:Bool = true;
    public var rightElbowCovered:Bool = true;
    public var leftKneeCovered:Bool = true;
    public var rightKneeCovered:Bool = true;

    public var brain:String = "Brain";
    public var heart:String = "Heart";
    public var guts:String = "Guts";
    public var lung:String = "Lung";
    public var leftElbow:String = "Elbow";
    public var rightElbow:String = "Elbow";
    public var leftKnee:String = "Knee";
    public var rightKnee:String = "Knee";

    public function new()  {
        isMale = Std.random(2) == 0;
        name = FIRST_NAMES[Std.random(FIRST_NAMES.length)] + " " + SURNAMES[Std.random(SURNAMES.length)];

        bodySprite = Std.random(3) + 1;

        hairStyle = Std.random(15)+1;
        hairColor = Std.random(3)+1;
    }

    /**
     * Get the Quality Of Life for this patient.
     */
    public function getQOL() {
        return 0;
    }
 }