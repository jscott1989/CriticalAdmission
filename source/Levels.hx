import states.playstate.PlayState;
import states.playstate.Patient;
import states.playstate.Interactable;

class Level {
    public var text:String;
    public var patients:Array<PatientInfo>;
    public var patientsToTreat:Int;
    public var VIP:PatientInfo;
    public var interactables:Array<Array<Dynamic>>;
    public var uiElements:Array<String>;
    public var minimumHealth:Int;
    public var levelTime:Int;

    public function new(
        text:String,
        patients:Array<PatientInfo>,
        patientsToTreat:Int,
        interactables:Array<Array<Dynamic>>,
        uiElements:Array<String>,
        minimumHealth:Int,
        levelTime:Int
    )  {
        this.text = text;
        this.patients = patients;
        this.patientsToTreat = patientsToTreat;
        this.interactables = interactables;
        this.uiElements = uiElements;
        this.minimumHealth = minimumHealth;
        this.levelTime = levelTime;
    }
}

class Levels {
    public static var LEVELS:Array<Level>;

    public static function populateLevels(){
        LEVELS = [
            new Level(
                "Doctor! We have incoming patients with cardio-, cardi-, vascular... Their hearts are missing and they need new ones! Luckily, there are a few spare from when the junior doctors were having an organ fight...",
                
                [
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                        PlayState.getInstance().showPopup("Day 1", "Doctor! We have incoming patients with cardio-, cardi-, vascular... Their hearts are missing and they need new ones! Luckily, there are a few spare from when the junior doctors were having an organ fight...");
                    }),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true,
                        function(patient:Patient) {
                        PlayState.getInstance().showPopup("Day 1", "Phew! That was a close one. No time to rest now though, there are more incoming and...what do you mean we've run out of hearts? Well, just improvise something: the patient's chart will tell you whether it's any good for them!");
                        PlayState.getInstance().spawnUIElement(Interactable.createInteractable("Clipboard"));
                        PlayState.getInstance().spawnInteractable(new Interactable("Pacemaker"));
                        PlayState.getInstance().spawnInteractable(new Interactable("Pacemaker"));
                        PlayState.getInstance().spawnInteractable(new Interactable("RubberDuck"));
                    }),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "", false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                ],

                6,

                [
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]]
                ],

                [
                    "Next"
                ],

                95,
                999
            ),
            new Level(
                "Great Scott! Lord Wafflington, world renowned explorer, has come to our hospital complaining of stomach pains after a trip to Columbia! We'd better make sure to fix him up to the highest of standards or our reputation (indicated by this handy pressure gauge) will drop! If it drops too far, it's all over for us! HINT: VIPs are so important, you might want to consider taking some useful organs out of the plebs! In this case, the patient just before Lord Wafflington has a perfectly healthy set of guts - we can take those out and still patch him up enough that we won't fail.",
                
                [
                    new PatientInfo(false, null, null, null, null, null, null, false, "Brain", true, "Heart", true, "Guts", false, "GlassShard", false, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(true, true, "Lord Wafflington", null, null, null, 2, false, "Brain", true, "Heart", true, "Drugs", false, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true)
                ],

                2,

                [
                    ["Organ", ["Lung"]]
                ],

                [
                    "PressureGauge"
                ],

                99,
                999
            ),
        new Level(
                "The queues are mounting up around the block! There's nothing else for it; get in there and help those people. You've only got a few seconds to spend fixing each patient - take too long and we'll get someone else to do it, and that patient won't count towards your shift!",
                
                [
                ],

                9,

                [
                ],

                [
                    "Tannoy",
                    "PatientCounter",
                    "Clock"
                ],

                100,
                10
            )
        ];
    }
}