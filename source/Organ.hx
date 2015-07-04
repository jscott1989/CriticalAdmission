 package;

 import flixel.FlxSprite;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;

 class Organ extends FlxSprite {

    public var hole:Hole;

    public function new(X:Float=0, Y:Float=0, type:String)  {
        super(X, Y);
        loadGraphic("assets/images/" + type + ".png");
    }

    public override function update() {
        super.update();
    }
 }