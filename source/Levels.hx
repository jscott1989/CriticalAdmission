class Level {
    public var text:String;
    public var patients:Array<PatientInfo>;
    public var interactables:Array<Array<Dynamic>>;
    public var minimumImprovement:Int;
    public var levelTime:Int;

    public function new(
        text:String,
        patients:Array<PatientInfo>,
        interactables:Array<Array<Dynamic>>,
        minimumImprovement:Int,
        levelTime:Int
    )  {
        this.text = text;
        this.patients = patients;
        this.interactables = interactables;
        this.minimumImprovement = minimumImprovement;
        this.levelTime = levelTime;
    }
}

class Levels {
    public static var LEVELS:Array<Level>;

    public static function populateLevels(){
        LEVELS = [];/*
            new Level(
                "Level 1 yo...",
                
                [
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true),
                    new PatientInfo(null, null, null, null, null, "Brain", true, "",   false, "Guts", true, "Lung", true, "Elbow", true, "Elbow", true, "Knee", true, "Knee", true)
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

                0,
                60
            )
        ];
        */
    }
}