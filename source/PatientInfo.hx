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

    private var isMale:Bool;
    private var name:String;
    private var bodySprite:Int;
    private var hairStyle:Int;
    private var hairColor:Int;

    private var brainCovered:Bool = true;
    private var heartCovered:Bool = true;
    private var gutsCovered:Bool = true;
    private var lungCovered:Bool = true;
    private var leftElbowCovered:Bool = true;
    private var rightElbowCovered:Bool = true;
    private var leftKneeCovered:Bool = true;
    private var rightKneeCovered:Bool = true;

    private var brain:String = "Brain";
    private var heart:String = "Heart";
    private var guts:String = "Guts";
    private var lung:String = "Lung";
    private var leftElbow:String = "LeftElbow";
    private var rightElbow:String = "RightElbow";
    private var leftKnee:String = "LeftKnee";
    private var rightKnee:String = "RightKnee";

    public function new()  {
        isMale = Std.random(2) == 0;
        name = FIRST_NAMES[Std.random(FIRST_NAMES.length)] + " " + SURNAMES[Std.random(SURNAMES.length)];

        var bodySprite = Std.random(3) + 1;

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