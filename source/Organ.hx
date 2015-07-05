 package;

 import flixel.FlxSprite;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;

 class Organ extends FlxSprite {

    public var hole:Hole;
    public var state:PlayState;

    public function new(X:Float=0, Y:Float=0, type:String, pState:PlayState)  {
        super(X, Y);
        loadGraphic("assets/images/" + type + ".png");
        state = pState;
    }

    public override function update() {
        super.update();
    }

    public function click() {
    }
 }