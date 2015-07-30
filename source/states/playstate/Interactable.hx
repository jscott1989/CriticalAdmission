package states.playstate;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.util.FlxPoint;

/**
 * An organ which can be placed in a hole or left on the table
 */
 class Interactable extends FlxSprite {

    public static var flippableInteractables = [
        "Knee", "Elbow", "Tannoy", "ArtificialKnee", "ArtificialElbow"
    ];

    public static var ORGANS = [
        "Brain",
        "Elbow",
        "Guts",
        "Heart",
        "Knee",
        "Lung"
    ];

    public static var PROSTHETICS = [
        "ArtificialKnee",
        "ArtificialElbow",
        "MetalGuts",
        "MetalLungs",
        "Pacemaker",
        "PositronicBrain"
    ];

    public static var UIELEMENTS = [
        "Clipboard",
        "Clock",
        "MedicalBook",
        "Next",
        "PressureGauge",
        "Scalpel"
    ];

    public static var JUNK = [
        "AlarmClock",
        "AmericanFootball",
        "Balloon",
        "Basketball",
        "Drugs",
        "Football",
        "GlassShard",
        "Grenade",
        "Hosepipe",
        "Knife",
        "MobilePhone",
        "Radio",
        "RubberBands",
        "RubberDuck",
        "Spring",
        "Stethoscope",
        "TennisBall",
        "TinCan",
        "WindshieldWiper"
    ];

    public static var SPECIAL = [
        "Cat"
    ];

    public static var SOUNDS:Map<String,Array<String>> = [
        "Cat" => [AssetPaths.Cat_1__wav, AssetPaths.Cat_2__wav, AssetPaths.Cat_3__wav, AssetPaths.Cat_4__wav, AssetPaths.Cat_5__wav],
        "AlarmClock" => [AssetPaths.AlarmClock_1__wav],
        "AmericanFootball" => [AssetPaths.Ball_1__wav, AssetPaths.Ball_2__wav, AssetPaths.Ball_3__wav, AssetPaths.Ball_4__wav],
        "Balloon" => [AssetPaths.Balloon_1__wav, AssetPaths.Balloon_2__wav, AssetPaths.Balloon_3__wav, AssetPaths.Balloon_4__wav],
        "Basketball" => [AssetPaths.Ball_1__wav, AssetPaths.Ball_2__wav, AssetPaths.Ball_3__wav, AssetPaths.Ball_4__wav],
        "Drugs" => [AssetPaths.Drugs_1__wav, AssetPaths.Drugs_2__wav, AssetPaths.Drugs_3__wav, AssetPaths.Drugs_4__wav],
        "Football" => [AssetPaths.Ball_1__wav, AssetPaths.Ball_2__wav, AssetPaths.Ball_3__wav, AssetPaths.Ball_4__wav],
        "GlassShard" => [AssetPaths.GlassShard_1__wav, AssetPaths.GlassShard_2__wav, AssetPaths.GlassShard_3__wav],
        "Grenade" => [AssetPaths.Grenade_1__wav, AssetPaths.Grenade_2__wav, AssetPaths.Grenade_3__wav],
        "Hosepipe" => [AssetPaths.Hosepipe_1__wav, AssetPaths.Hosepipe_2__wav],
        "Knife" => [AssetPaths.Knife_1__wav, AssetPaths.Knife_2__wav],
        "MobilePhone" => [AssetPaths.MobilePhone_1__wav, AssetPaths.MobilePhone_2__wav, AssetPaths.MobilePhone_3__wav, AssetPaths.MobilePhone_4__wav],
        "Radio" => [AssetPaths.Radio_1__wav, AssetPaths.Radio_2__wav, AssetPaths.Radio_3__wav, AssetPaths.Radio_4__wav],
        "RubberBands" => [AssetPaths.RubberBands_1__wav, AssetPaths.RubberBands_2__wav, AssetPaths.RubberBands_3__wav, AssetPaths.RubberBands_4__wav],
        "RubberDuck" => [AssetPaths.RubberDuck_1__wav, AssetPaths.RubberDuck_2__wav, AssetPaths.RubberDuck_3__wav, AssetPaths.RubberDuck_4__wav],
        "Spring" => [AssetPaths.Spring_1__wav, AssetPaths.Spring_2__wav, AssetPaths.Spring_3__wav, AssetPaths.Spring_4__wav, AssetPaths.Spring_5__wav, AssetPaths.Spring_6__wav],
        "Stethoscope" => [AssetPaths.Stethoscope_1__wav, AssetPaths.Stethoscope_2__wav],
        "TennisBall" => [AssetPaths.Ball_1__wav, AssetPaths.Ball_2__wav, AssetPaths.Ball_3__wav, AssetPaths.Ball_4__wav],
        "TinCan" => [AssetPaths.TinCan_1__wav, AssetPaths.TinCan_2__wav, AssetPaths.TinCan_3__wav, AssetPaths.TinCan_4__wav],
        "WindshieldWiper" => [AssetPaths.WindshieldWiper_1__wav, AssetPaths.WindshieldWiper_2__wav, AssetPaths.WindshieldWiper_3__wav],
        "Brain" => [AssetPaths.Brain_1__wav],
        "Elbow" => [AssetPaths.Elbow_1__wav, AssetPaths.Elbow_2__wav, AssetPaths.Elbow_3__wav, AssetPaths.Elbow_4__wav],
        "Guts" => [AssetPaths.Guts_1__wav],
        "Heart" => [AssetPaths.Heart_1__wav, AssetPaths.Heart_2__wav],
        "Knee" => [AssetPaths.Knee_1__wav, AssetPaths.Knee_2__wav, AssetPaths.Knee_3__wav, AssetPaths.Knee_4__wav],
        "Lung" => [AssetPaths.Lung_1__wav],
        "ArtificialElbow" => [AssetPaths.ArtificialJoint_1__wav],
        "ArtificialKnee" => [AssetPaths.ArtificialJoint_1__wav],
        "MetalGuts" => [AssetPaths.MetalGuts_1__wav],
        "MetalLungs" => [AssetPaths.MetalLungs_1__wav, AssetPaths.MetalLungs_2__wav, AssetPaths.MetalLungs_3__wav, AssetPaths.MetalLungs_4__wav],
        "Pacemaker" => [AssetPaths.Pacemaker_1__wav],
        "PositronicBrain" => [AssetPaths.PositronicBrain_1__wav, AssetPaths.PositronicBrain_2__wav, AssetPaths.PositronicBrain_3__wav, AssetPaths.PositronicBrain_4__wav, AssetPaths.PositronicBrain_5__wav],
        "Tannoy" => [AssetPaths.Tannoy_1__wav],
        "PatientCounter" => [AssetPaths.Clipboard_1__wav, AssetPaths.Clipboard_2__wav, AssetPaths.Clipboard_3__wav],
        "Next" => [AssetPaths.Clipboard_1__wav, AssetPaths.Clipboard_2__wav, AssetPaths.Clipboard_3__wav],
        "Pause" => [AssetPaths.Clipboard_1__wav, AssetPaths.Clipboard_2__wav, AssetPaths.Clipboard_3__wav],
        "PressureGauge" => [AssetPaths.Clipboard_1__wav, AssetPaths.Clipboard_2__wav, AssetPaths.Clipboard_3__wav],
        "Clipboard" => [AssetPaths.Clipboard_1__wav, AssetPaths.Clipboard_2__wav, AssetPaths.Clipboard_3__wav],
        "Clock" => [AssetPaths.Clock_1__wav],
        "MedicalBook" => [AssetPaths.MedicalBook_1__wav, AssetPaths.MedicalBook_2__wav, AssetPaths.MedicalBook_3__wav, AssetPaths.MedicalBook_4__wav],
        "Scalpel" => [AssetPaths.Knife_1__wav, AssetPaths.Knife_2__wav]
    ];

    // public static var ELIGIBLE_IN_BODY = JUNK.concat(PROSTHETICS).concat(ORGANS);

    private var sounds:Array<String> = [];
    private var eligibleSounds:Array<String> = [];

    // The hole it's contained in (if any)
    public var hole:Hole;

    public var dragging = false;

    public var type:String;
    public var label:String;

    private var canBeFlipped = false;

    public var fixedDragOffset:FlxPoint = null;

    public function new(type:String, X:Float=0, Y:Float=0)  {
        super(X, Y);
        this.type = type;
        this.label = Utils.splitCamelCase(type);
        this.canBeFlipped = flippableInteractables.lastIndexOf(type) != -1;
        // Load the correct type onto this sprite
        loadGraphic("assets/images/" + type + ".png");

        if (SOUNDS.exists(type)) {
            sounds = SOUNDS.get(type);
        }
    }

    public function setHole(hole:Hole) {
        this.hole = hole;

        if (canBeFlipped && this.hole.requiresFlip) {
            this.flipX = true;
        } else {
            this.flipX = false;
        }
    }

    public function resetHole() {
        this.hole = null;
    }

    public function getHole() {
        return hole;
    }

    public override function update() {
        super.update();
    }

    public function click() {
    }
    
    public function interaction() {
    }

    public function pickedUp() {
        
    }

    /**
     * The Interactable has been dropped.
     * Returning True means that we have dealt with it.
     * false will leave it to the playstate
     */
    public function dropped() {
        return false;
    }

    public static inline function createInteractable(organType:String=null):Interactable {
        if (organType == null) {
            return null;
        }

        if (ORGANS.indexOf(organType) != -1) {
            return new Organ(organType);
        } else if (UIELEMENTS.indexOf(organType) != -1){
            Clipboard;
            Clock;
            MedicalBook;
            Next;
            PressureGauge;
            Scalpel;
            return Type.createInstance(Type.resolveClass("states.playstate." + organType), []);
        } else {
            return new Interactable(organType);
        }
    }

    public function playSound() {
        if (sounds.length == 0) {
            return;
        }

        if (eligibleSounds.length == 0) {
            eligibleSounds = Utils.randomArray(sounds);
        }

        var sound = eligibleSounds.pop();
        PlayState.getInstance().soundManager.playSound(sound);
    }

    // public function asArray():Array<{}> {
    //     var arguments:Array<{}> = [type, Std.string(x), Std.string(y)];
    //     return ["Interactable", arguments];
    // }

    // public override function destroy() {
    //     backgroundSprite = FlxDestroyUtil.destroy(backgroundSprite);
    // }
 }