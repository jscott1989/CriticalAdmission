package;

import flixel.FlxG;
import flixel.util.FlxRandom;
import states.playstate.Interactable;
import states.playstate.Patient;

/**
 * Contain stats about a patient
 *
 * Put it here so the actual Patient can be destroyed.
 */
 class PatientInfo {
    public static var FIRST_NAMES:Array<Array<String>> = [
        ["Mrs", "Miss", "Ms"], // female
        ["Mr"], // male
        ["Dame", "Lady", "Baroness", "Countess", "Viscountess", "Duchess", "Princess", "Queen"], // female VIP
        ["Sir", "Lord", "Baron", "Earl", "Viscount", "Duke", "Prince", "King"] // male VIP
    ];
    public static var SURNAMES:Array<String> = ["Smith", "Jones", "Taylor", "Brown", "Williams", "Wilson", "Johnson", "Davies", "Robinson", "Wright", "Thompson", "Evans", "Walker", "White", "Roberts", "Green", "Hall", "Wood", "Jackson", "Clarke", "Patel", "Thomas", "Khan", "Lewis", "James", "Phillips", "Ali", "Mason", "Mitchell", "Rose", "Davis", "Rodriguez", "Cox", "Alexander"];

    public static var INJURIES:Array<String> = ["Achilles Tendonitis", "Achilles Tendon Ruptures", "Altitude Illness", "Ankle Sprain", "Ankle Fracture", "Anorexia", "Arthritis of the Shoulder", "Athlete's Foot", "Back Pain", "Blisters", "Bulimia", "Calf Strain", "Carpal Tunnel Syndrome", "Cervical Fracture", "Clavicle Fracture", "Frostbite", "Hypothermia", "Compulsive Exercise", "Concussion", "Cramping Muscles", "Diabetes", "Finger Fracture", "Frozen Shoulder", "Golfer's Elbow", "Growth Plate Injuries", "Hamstring Pull", "Hamstring Tear", "Head Injuries", "Hyponatremia", "Plica Syndrome", "Lateral Epicondylitis", "Low Back Pain", "Noisy Joints", "Neck Strain", "Osteoarthritis of the Knee", "Osteoarthritis", "Osgood-Schlatter Disease", "Overuse Syndrome", "Patellofemoral Pain Syndrome", "Sciatica", "Side Stitch", "Shin Splints", "Shoulder Dislocation", "Shoulder Separation", "Shoulder Fracture", "Shoulder Tendinitis", "Tendonitis", "Whiplash", "Water Intoxication"];

    public var isVIP:Bool;
    public var isMale:Bool;
    public var name:String;
    public var bodySprite:Int;
    public var hairStyle:Int;
    public var hairColor:Int;
    public var crown:Int;
    public var medals:Bool;

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

    public var onExitCallback:Patient -> Void;
    public var onEnterCallback:Patient -> Void;

    public var initialQOL:Float = 100;

    public var injury:String;

    public function new(isVIP:Bool=false, isMale:Bool=null, name:String=null, bodySprite:Int=null, hairStyle:Int=null, hairColor:Int=null, crown:Int=null, medals:Bool=false, brain:String="Brain", brainCovered:Bool=true, heart:String="Heart", heartCovered:Bool=true, guts:String="Guts", gutsCovered:Bool=true, lung:String="Lung", lungCovered:Bool=true, leftElbow:String="Elbow", leftElbowCovered:Bool=true, rightElbow:String="Elbow", rightElbowCovered:Bool=true, leftKnee:String="Knee", leftKneeCovered:Bool=true, rightKnee:String="Knee", rightKneeCovered:Bool=true, onEnterCallback:Patient -> Void = null, onExitCallback:Patient -> Void = null, injury:String = null)  {
        this.isVIP = isVIP;

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

            if (isVIP) {
                this.name = FIRST_NAMES[genderID+2][Std.random(FIRST_NAMES[genderID+2].length)] + " " + SURNAMES[Std.random(SURNAMES.length)];
            } else {
                this.name = FIRST_NAMES[genderID][Std.random(FIRST_NAMES[genderID].length)] + " " + SURNAMES[Std.random(SURNAMES.length)];
            }
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

        if (injury == null) {
            this.injury = INJURIES[Std.random(INJURIES.length)];
        } else {
            this.injury = injury;
        }

        if (isVIP) {
            if (crown == null) {
                this.crown = Std.random(3);
                if (this.crown == 0) {
                    this.medals = true;
                } else {
                    this.medals = Std.random(3) == 0;
                }
            } else {
                this.crown = crown;
                this.medals = medals;
            }
        }

        this.onExitCallback = onExitCallback;
        this.onEnterCallback = onEnterCallback;

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
        return (((getBrainQOL() + getHeartQOL() + getLungQOL() + getGutsQOL() + getLeftElbowQOL() + getRightElbowQOL() + getLeftKneeQOL() + getRightKneeQOL()) / 8) * 0.8) + 20;
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

    public function damageOrgans(target:Float){

        FlxG.log.add(target);
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

        while(getQOL() > (target+10)){
            var organ = FlxRandom.getObject(organs);
            switch organ {
                case "brain" : brain = newInteractable(); if(damaged.indexOf("brain") == -1){damaged.push("brain");}
                case "heart" : heart = newInteractable(); if(damaged.indexOf("heart") == -1){damaged.push("heart");}
                case "lung" : lung = newInteractable(); if(damaged.indexOf("lung") == -1){damaged.push("lung");}
                case "guts" : guts = newInteractable(); if(damaged.indexOf("guts") == -1){damaged.push("guts");}
                case "leftElbow" : leftElbow = newInteractable(); if(damaged.indexOf("leftElbow") == -1){damaged.push("leftElbow");}
                case "rightElbow" : rightElbow = newInteractable(); if(damaged.indexOf("rightElbow") == -1){damaged.push("rightElbow");}
                case "leftKnee" : leftKnee = newInteractable(); if(damaged.indexOf("leftKnee") == -1){damaged.push("leftKnee");}
                case "rightKnee" : rightKnee = newInteractable(); if(damaged.indexOf("rightKnee") == -1){damaged.push("rightKnee");}
            }
        }

        //Open up half of the damaged organs
        var numberDamaged:Int = damaged.length;
        while(damaged.length > numberDamaged/2 && damaged.length > 0){
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

        //Open up between zero and half of the "good" organs
        var toOpen = FlxRandom.intRanged(0, Std.int((8-numberDamaged)/2));
        var goodOrgans = organs.filter(function(o){return damaged.indexOf(o) == -1;});
        for (i in 0...toOpen) {
            var organ = FlxRandom.getObject(goodOrgans);
            switch organ {
                case "brain" : brainCovered = false; goodOrgans.remove("brain");
                case "heart" : heartCovered = false; goodOrgans.remove("heart");
                case "lung" : lungCovered = false; goodOrgans.remove("lung");
                case "guts" : gutsCovered = false; goodOrgans.remove("guts");
                case "leftElbow" : leftElbowCovered = false; goodOrgans.remove("leftElbow");
                case "rightElbow" : rightElbowCovered = false; goodOrgans.remove("rightElbow");
                case "leftKnee" : leftKneeCovered = false; goodOrgans.remove("leftKnee");
                case "rightKnee" : rightKneeCovered = false; goodOrgans.remove("rightKnee");
            }
        }
    }

    private var possibleInteractables = [];

    private function newInteractable(){
        if (possibleInteractables.length == 0) {
            possibleInteractables = Utils.randomArray(Interactable.JUNK.concat(Interactable.PROSTHETICS).concat(Interactable.PROSTHETICS).concat(Interactable.ORGANS).concat(Interactable.ORGANS).concat(Interactable.ORGANS));
        }
        return possibleInteractables.pop();
    }

    public function contains(obj:String):Bool {
        return (brain == obj || heart == obj || lung == obj || guts == obj || leftElbow == obj || rightElbow == obj || leftKnee == obj || rightKnee == obj);
    }

    public function containsVisible(obj:String):Bool {
        return ((brain == obj && !brainCovered) || 
                (heart == obj && !heartCovered) || 
                (lung == obj && !lungCovered) || 
                (guts == obj && !gutsCovered) ||
                (leftElbow == obj && !leftElbowCovered) ||
                (rightElbow == obj && !rightElbowCovered) ||
                (leftKnee == obj && !leftKneeCovered) ||
                (rightKnee == obj && !rightKneeCovered));
    }
 }