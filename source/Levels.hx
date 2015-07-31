import flixel.FlxG;
import sounds.speech.Receptionist;
import states.playstate.Interactable;
import states.playstate.Patient;
import states.playstate.PlayState;

class Level {
    public var level:Int;
    public var text:String;
    public var patients:Array<PatientInfo>;
    public var vip:PatientInfo;
    public var patientsToTreat:Int;
    public var interactables:Array<Array<Dynamic>>;
    public var uiElements:Array<String>;
    public var levelTime:Int;

    public function new(
        level:Int,
        text:String,
        patients:Array<PatientInfo>,
        vip:PatientInfo,
        patientsToTreat:Int,
        interactables:Array<Array<Dynamic>>,
        uiElements:Array<String>,
        levelTime:Int
    )  {
        this.level = level;
        this.text = text;
        this.patients = patients;
        this.vip = vip;
        this.patientsToTreat = patientsToTreat;
        this.interactables = interactables;
        this.uiElements = uiElements;
        this.levelTime = levelTime;

        while (this.patients.length < patientsToTreat - 1) {
            this.patients.push(PlayState.generatePatientInfo(level));
        }

        if (vip == null && text == null) {
            if (Levels.VIPS.length > 0) {
                var vv = Levels.VIPS.pop();
                this.vip = new PatientInfo(true, vv.isMale, vv.name);
                this.text = vv.text;
            } else {
                this.text = Receptionist.FILLER.get(Utils.randomArray(Receptionist.FILLER_KEYS).pop());
                this.vip = new PatientInfo(true);
            }
        }
    }
}

class Vip {
    public var text:String;
    public var isMale:Bool;
    public var name:String;

    public function new(text:String, isMale:Bool, name:String) {
        this.text = text;
        this.isMale = isMale;
        this.name = name;
    }
}

class Levels {
    public static var LEVELS:Array<Level>;

    public static var VIPS:Array<Vip> = Utils.randomArray([
        new Vip("lololol", true, "King LOL")
    ]);

    public static function populateLevels(){
        LEVELS = [
            new Level(
                1,
                "Doctor! Incoming patients, get to the operating room, stat!",
                
                [
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "Doctor, we have incoming patients with missing hearts! Luckily, there are a few spare from when the junior doctors were having an organ fight...");
                        },
                        function(patient:Patient) {
                            trace(patient.info.heart);
                            if (patient.info.heart == null){
                                PlayState.getInstance().showPopup("Tutorial", "Doctor what are you doing? These people need hearts! Drag the organ from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart == null){
                                PlayState.getInstance().showPopup("Tutorial", "Doctor what are you doing? These people need hearts! Drag the organ from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart == null){
                                PlayState.getInstance().showPopup("Tutorial", "Doctor what are you doing? These people need hearts! Drag the organ from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "Phew! That was a close one. No time to rest now though, there are more incoming and...what do you mean we've run out of hearts? Well, just improvise something: the patient's chart will tell you whether it's any good for them!");
                            PlayState.getInstance().spawnUIElement(Interactable.createInteractable("Clipboard"));
                            PlayState.getInstance().spawnInteractable(new Interactable("Pacemaker"));
                            PlayState.getInstance().spawnInteractable(new Interactable("Pacemaker"));
                            PlayState.getInstance().spawnInteractable(new Interactable("RubberDuck"));
                        },
                        function(patient:Patient) {
                            FlxG.log.add(patient.info.heart);
                            if (patient.info.heart == null){
                                PlayState.getInstance().showPopup("Tutorial", "I know it's a little unconventional Doctor, but we need to put SOMETHING in there! Drag the prosthetic organ (or....duck) from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart == null){
                                PlayState.getInstance().showPopup("Tutorial", "I know it's a little unconventional Doctor, but we need to put SOMETHING in there! Drag the prosthetic organ (or....duck) from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart == null){
                                PlayState.getInstance().showPopup("Tutorial", "I know it's a little unconventional Doctor, but we need to put SOMETHING in there! Drag the prosthetic organ (or....duck) from the table into the chest cavity.");
                            }
                        }
                    )
                ],

                null,

                6,

                [
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]]
                ],

                [
                    "Next",
                    "Clock"
                ],

                120
            ),
            new Level(
                2,
                "Great Scott! Lord Wafflington, world renowned explorer, has come to our hospital complaining of stomach pains after a trip to Columbia! We'd better make sure to fix him up to the highest of standards or our reputation will suffer",
                
                [
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "Heart", true, "Guts", false, "GlassShard", false, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "Lord Wafflington really needs a new set of guts Doctor, and I'm sure this patient can do without, so long as we take out that nasty shard of glass.");
                            PlayState.getInstance().showPopup("Tutorial", "HINT: VIPs are so important, you might want to consider taking some useful organs out of the ordinary patients!");
                        },
                        function(patient:Patient) {
                            if (patient.info.lung == "GlassShard" && patient.info.guts == "Guts"){
                                PlayState.getInstance().showPopup("Tutorial", "Lord Wafflington really need those guts Doctor, and I'm sure this patient can do without, so long as we take out that nasty shard of glass");
                            }
                        }
                    ),
                    new PatientInfo(true, true, "Lord Wafflington", null, null, null, 2, false, "Brain", true, "Heart", true, "Drugs", false, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "Reputation (indicated by this handy pressure gauge) is the lifeblood of our hospital; if we fix patients it goes up, if we don't it drops. If it drops too far, it's all over for us!");
                            PlayState.getInstance().showPopup("Tutorial", "HINT: VIPs are worth double the reputation gain (and loss!) compared to ordinary patients");

                        },
                        function(patient:Patient) {
                            if (patient.info.guts != "Guts"){
                                PlayState.getInstance().showPopup("Tutorial", "You MUST prioritise fixing the VIPs Doctor! Reputation gains and losses are doubled when treating a VIP!");
                            }
                        }
                    )
                ],

                null,

                2,

                [
                    ["Organ", ["Lung"]]
                ],

                [
                    "PressureGauge"
                ],

                120
            ),
            new Level(
<<<<<<< HEAD
                3,
                "Looks like you've finally found your scalpel, so now it's time to get cutting! HINT: You only need to fix ordinary patients up to 80% (and VIPs to 90%); don't worry about making them perfect.",
                
                [
                    new PatientInfo(false, null, null, null, null, null, null, false, "", true, "Heart", true, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "This patient has something wrong with their brain, but we can't get at it yet; try opening them up with the scalpel! (Don't worry about closing them up again)");
                        },
                        function(patient:Patient) {
                            if (patient.info.brain != "Brain"){
                                PlayState.getInstance().showPopup("Tutorial", "Make sure to open the patient's head to add the new brain! Click and drag the scalpel onto their head to open them up, then drag the brain into the slot.");
                            }
                            PlayState.getInstance().moveToTable("Scalpel");
                        }
                    )
                ],

                null,

                1,

                [
                    ["Organ", ["Brain"]]
                ],

                [
                    "Scalpel"
                ],

                120
            ),
        new Level(
                4,
                "The queues are mounting up around the block! There's nothing else for it; get in there and help those people. You've only got a few seconds to spend fixing each patient: take too long and they'll kick the bucket. Even worse, that patient won't count towards finishing your shift! HINT: Press spacebar to quickly get the next patient",
                
                [
                ],

                new PatientInfo(true),

                9,

                [
                ],

                [
                    "Tannoy",
                    "PatientCounter"
                ],

                60
            )
        ];
    }
}