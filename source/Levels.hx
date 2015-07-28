class Level {
    public var text:String;
    public var patients:Array<PatientInfo>;
    public var VIP:PatientInfo;
    public var interactables:Array<Array<Dynamic>>;
    public var uiElements:Array<String>;
    public var minimumHealth:Int;
    public var levelTime:Int;

    public function new(
        text:String,
        patients:Array<PatientInfo>,
        interactables:Array<Array<Dynamic>>,
        uiElements:Array<String>,
        minimumHealth:Int,
        levelTime:Int
    )  {
        this.text = text;
        this.patients = patients;
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
                "Level 1 yo...",
                
                [
                    new PatientInfo(false, null, null, null, null, null, "Brain", true, "ArtificialJoint",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(true, null, null, null, null, null, "Brain", true, "Balloon",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(false, null, null, null, null, null, "Brain", true, "Spring",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                ],

                [
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]],
                    ["Organ", ["Heart"]]
                ],

                [
                    "Next",
                    "Tannoy",
                    "Clipboard",
                    "PressureGauge"
                ],

                70,
                20
            ),
            new Level(
                    "Level 2...",
                    
                    [
                    ],

                    [
                        
                    ],

                    [
                        "PatientCounter",
                        "MedicalBook"
                    ],

                    100,
                    5
            )
        ];
    }
}