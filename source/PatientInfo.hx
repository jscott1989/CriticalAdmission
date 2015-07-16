package;

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

    public var brainCovered:Bool = false;
    public var heartCovered:Bool = false;
    public var gutsCovered:Bool = false;
    public var lungCovered:Bool = false;
    public var leftElbowCovered:Bool = false;
    public var rightElbowCovered:Bool = false;
    public var leftKneeCovered:Bool = false;
    public var rightKneeCovered:Bool = false;

    public var brain:String = "Brain";
    public var heart:String = "Brain";
    public var guts:String = "Guts";
    public var lung:String = "Lung";
    public var leftElbow:String = "Elbow";
    public var rightElbow:String = "Elbow";
    public var leftKnee:String = "Knee";
    public var rightKnee:String = "Knee";

    public var initialQOL:Float = 100;

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
        return (getBrainQOL() + getHeartQOL() + getLungQOL() + getGutsQOL() + getLeftElbowQOL() + getRightElbowQOL() + getLeftKneeQOL() + getRightKneeQOL()) / 8;
    }

    public static function getQOLForHole(objectType:String, holeType:String) {
        if (objectType == null) {
            return 0;
        }

        var h = HealthValues.HEALTH_VALUES.get(objectType);

        if (h == null) {
            return 0;
        }

        if (h.get(holeType) != null) {
            return h.get(holeType);
        }

        return 0;
    }


    public function getBrainQOL() {
        return getQOLForHole(brain, "Brain");
    }

    public function getHeartQOL() {
        return getQOLForHole(heart, "Heart");
    }

    public function getLungQOL() {
        return getQOLForHole(lung, "Lung");
    }

    public function getGutsQOL() {
        return getQOLForHole(guts, "Guts");
    }

    public function getLeftElbowQOL() {
        return getQOLForHole(leftElbow, "LeftElbow");
    }

    public function getRightElbowQOL() {
        return getQOLForHole(rightElbow, "RightElbow");
    }

    public function getLeftKneeQOL() {
        return getQOLForHole(leftKnee, "LeftKnee");
    }

    public function getRightKneeQOL() {
        return getQOLForHole(rightKnee, "RightKnee");
    }
 }