import states.playstate.Patient;
import states.playstate.PlayState;
import states.playstate.Patient;
import states.playstate.Interactable;
import flixel.FlxG;

class Level {
    public var text:String;
    public var patients:Array<PatientInfo>;
    public var patientsToTreat:Int;
    public var VIP:PatientInfo;
    public var interactables:Array<Array<Dynamic>>;
    public var uiElements:Array<String>;
    public var levelTime:Int;

    public function new(
        text:String,
        patients:Array<PatientInfo>,
        patientsToTreat:Int,
        interactables:Array<Array<Dynamic>>,
        uiElements:Array<String>,
        levelTime:Int
    )  {
        this.text = text;
        this.patients = patients;
        this.patientsToTreat = patientsToTreat;
        this.interactables = interactables;
        this.uiElements = uiElements;
        this.levelTime = levelTime;
    }
}

class Levels {
    public static var LEVELS:Array<Level>;

    public static function populateLevels(){
        LEVELS = [
            new Level(
                "Doctor! Incoming patients, get to the operating room, stat!",
                
                [
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "Doctor! We have incoming patients with cardio-, cardi-, vascular... Their hearts are missing and they need new ones! Luckily, there are a few spare from when the junior doctors were having an organ fight...");
                        },
                        function(patient:Patient) {
                            if (patient.info.heart != "Heart"){
                                PlayState.getInstance().showPopup("Tutorial", "Doctor what are you doing? These people need hearts! Drag the organ from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart != "Heart"){
                                PlayState.getInstance().showPopup("Tutorial", "Doctor what are you doing? These people need hearts! Drag the organ from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart != "Heart"){
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
                            if (patient.info.heart != "Pacemaker" && patient.info.heart != "RubberDuck"){
                                PlayState.getInstance().showPopup("Tutorial", "I know it's a little unconventional Doctor, but we need to put SOMETHING in there! Drag the prosthetic organ (or....duck) from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart != "Pacemaker" && patient.info.heart != "RubberDuck"){
                                PlayState.getInstance().showPopup("Tutorial", "I know it's a little unconventional Doctor, but we need to put SOMETHING in there! Drag the prosthetic organ (or....duck) from the table into the chest cavity.");
                            }
                        }
                    ),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {},
                        function(patient:Patient) {
                            if (patient.info.heart != "Pacemaker" && patient.info.heart != "RubberDuck"){
                                PlayState.getInstance().showPopup("Tutorial", "I know it's a little unconventional Doctor, but we need to put SOMETHING in there! Drag the prosthetic organ (or....duck) from the table into the chest cavity.");
                            }
                        }
                    )
                ],

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
                "Great Scott! Lord Wafflington, world renowned explorer, has come to our hospital complaining of stomach pains after a trip to Columbia! We'd better make sure to fix him up to the highest of standards or our reputation will suffer",
                
                [
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "Heart", true, "Guts", false, "GlassShard", false, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "Lord Wafflington really needs a new set of guts Doctor, and I'm sure this patient can do without, so long as we take out that nasty shard of glass. HINT: VIPs are so important, you might want to consider taking some useful organs out of the plebs!");
                        },
                        function(patient:Patient) {
                            if (patient.info.lung == "GlassShard" && patient.info.guts == "Guts"){
                                PlayState.getInstance().showPopup("Tutorial", "Lord Wafflington really need those guts Doctor, and I'm sure this patient can do without, so long as we take out that nasty shard of glass");
                            }
                        }
                    ),
                    new PatientInfo(true, true, "Lord Wafflington", null, null, null, 2, false, "Brain", true, "Heart", true, "Drugs", false, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                            PlayState.getInstance().showPopup("Tutorial", "Reputation (indicated by this handy pressure gauge) is the lifeblood of our hospital; if we fix patients it goes up, if we don't it drops. If it drops too far, it's all over for us! HINT: VIPs are worth considerably more reputation than ordinary patients");
                        },
                        function(patient:Patient) {
                            if (patient.info.guts != "Guts"){
                                PlayState.getInstance().showPopup("Tutorial", "You MUST prioritise fixing the VIPs Doctor!");
                            }
                        }
                    )
                ],

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
                "Now its time to get cutting!",
                
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
                "The queues are mounting up around the block! There's nothing else for it; get in there and help those people. You've only got a few seconds to spend fixing each patient: take too long and they'll kick the bucket. Even worse, that patient won't count towards finishing your shift! HINT: Press spacebar to quickly get the next patient",
                
                [
                ],

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