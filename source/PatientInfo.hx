package;

import flixel.util.FlxRandom;
import flixel.FlxG;

/**
 * Contain stats about a patient
 *
 * Put it here so the actual Patient can be destroyed.
 */
 class PatientInfo {
    public static var FIRST_NAMES:Array<Array<String>> = [
        ["F1", "F2"], // female
        ["M1", "M2"] // male
    ];
    public static var SURNAMES:Array<String> = ["S1", "S2"];

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
    public var heart:String = "Heart";
    public var guts:String = "Guts";
    public var lung:String = "Lung";
    public var leftElbow:String = "Elbow";
    public var rightElbow:String = "Elbow";
    public var leftKnee:String = "Knee";
    public var rightKnee:String = "Knee";

    public var initialQOL:Float = 100;

    public function new(isMale:Bool=null, name:String=null, bodySprite:Int=null, hairStyle:Int=null, hairColor:Int=null, brain:String="Brain", brainCovered:Bool=true, heart:String="Heart", heartCovered:Bool=true, guts:String="Guts", gutsCovered:Bool=true, lung:String="Lung", lungCovered:Bool=true, leftElbow:String="Elbow", leftElbowCovered:Bool=true, rightElbow:String="Elbow", rightElbowCovered:Bool=true, leftKnee:String="Knee", leftKneeCovered:Bool=true, rightKnee:String="Knee", rightKneeCovered:Bool=true)  {
        if (isMale == null) {
            this.isMale = Std.random(2) == 0;
        } else {
            this.isMale = isMale;
        }
        if (name == null) {
            var genderID = 0;
            if (this.isMale) {
                genderID = 1;
            }
            this.name = FIRST_NAMES[genderID][Std.random(FIRST_NAMES.length)] + " " + SURNAMES[Std.random(SURNAMES.length)];
        } else {
            this.name = name;
        }

        if (bodySprite == null) {
            this.bodySprite = Std.random(3) + 1;
        } else {
            this.bodySprite = bodySprite;
        }

        if (hairStyle == null) {
            this.hairStyle = Std.random(15)+1;
        } else {
            this.hairStyle = hairStyle;
        }

        if (hairColor == null) {
            this.hairColor = Std.random(3)+1;
        } else {
            this.hairColor = hairColor;
        }

        // This is ugly, but we can't pass null because of the optional arguments...
        if (brain == "") brain = null;
        if (heart == "") heart = null;
        if (lung == "") lung = null;
        if (guts == "") guts = null;
        if (leftElbow == "") leftElbow = null;
        if (rightElbow == "") rightElbow = null;
        if (leftKnee == "") leftKnee = null;
        if (rightKnee == "") rightKnee = null;

        this.brain = brain;
        this.brainCovered = brainCovered;
        this.heart = heart;
        this.heartCovered = heartCovered;
        this.lung = lung;
        this.lungCovered = lungCovered;
        this.guts = guts;
        this.gutsCovered =  gutsCovered;
        this.leftElbow = leftElbow;
        this.leftElbowCovered = leftElbowCovered;
        this.rightElbow = rightElbow;
        this.rightElbowCovered = rightElbowCovered;
        this.leftKnee = leftKnee;
        this.leftKneeCovered = leftKneeCovered;
        this.rightKnee = rightKnee;
        this.rightKneeCovered = rightKneeCovered;
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

    public function damageOrgans(target:Int){
        var organs:Array<String> = [
            "brain",
            "heart",
            "lung",
            "guts",
            "leftElbow",
            "rightElbow",
            "leftKnee",
            "rightKnee",
        ];

        var damaged:Array<String> = [];

        while(getQOL() > target+10){
            FlxG.log.add(getQOL() +" > " + target+10);
            var organ = FlxRandom.getObject(organs);
            switch organ {
                case "brain" : brain = newOrgan(); organs.remove("brain"); if(damaged.indexOf("brain") == -1){damaged.push("brain");}
                case "heart" : heart = newOrgan(); organs.remove("heart"); if(damaged.indexOf("heart") == -1){damaged.push("heart");}
                case "lung" : lung = newOrgan(); organs.remove("lung"); if(damaged.indexOf("lung") == -1){damaged.push("lung");}
                case "guts" : guts = newOrgan(); organs.remove("guts"); if(damaged.indexOf("guts") == -1){damaged.push("guts");}
                case "leftElbow" : leftElbow = newOrgan(); organs.remove("leftElbow"); if(damaged.indexOf("leftElbow") == -1){damaged.push("leftElbow");}
                case "rightElbow" : rightElbow = newOrgan(); organs.remove("rightElbow"); if(damaged.indexOf("rightElbow") == -1){damaged.push("rightElbow");}
                case "leftKnee" : leftKnee = newOrgan(); organs.remove("leftKnee"); if(damaged.indexOf("leftKnee") == -1){damaged.push("leftKnee");}
                case "rightKnee" : rightKnee = newOrgan(); organs.remove("rightKnee"); if(damaged.indexOf("rightKnee") == -1){damaged.push("rightKnee");}
            }
        }

        //Open up half of the damaged organs
        var numberDamaged:Int = damaged.length;
        while(damaged.length > numberDamaged/2){
            var organ = FlxRandom.getObject(damaged);
            switch organ {
                case "brain" : brainCovered = false; damaged.remove("brain");
                case "heart" : heartCovered = false; damaged.remove("heart");
                case "lung" : lungCovered = false; damaged.remove("lung");
                case "guts" : gutsCovered = false; damaged.remove("guts");
                case "leftElbow" : leftElbowCovered = false; damaged.remove("leftElbow");
                case "rightElbow" : rightElbowCovered = false; damaged.remove("rightElbow");
                case "leftKnee" : leftKneeCovered = false; damaged.remove("leftKnee");
                case "rightKnee" : rightKneeCovered = false; damaged.remove("rightKnee");
            }
        }
    }

    private function newOrgan(){
        var organs = HealthValues.HEALTH_VALUES.keys();
        var i:Int;
        for(i in 0...Math.floor(Math.random()*Lambda.array(HealthValues.HEALTH_VALUES).length)-1){
            organs.next();
        }
        return organs.next();
    }
 }