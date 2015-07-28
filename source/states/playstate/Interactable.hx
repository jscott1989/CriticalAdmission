package states.playstate;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.util.FlxPoint;

/**
 * An organ which can be placed in a hole or left on the table
 */
 class Interactable extends FlxSprite {

    public static var flippableInteractables = [
        "Knee", "Elbow", "Tannoy"
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
        "ArtificialJoint",
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

    public static var ELIGIBLE_IN_BODY = JUNK.concat(PROSTHETICS).concat(ORGANS);

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

        var i = 0;
        while (true) {
            i++;
            var f = Reflect.field(AssetPaths, type + "_" + Std.string(i) + "__wav");
            if (f == null) {
                break;
            } else {
                sounds.push(f);
            }
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
 }