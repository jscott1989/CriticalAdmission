package states.playstate;

 import flixel.FlxG;
 import flixel.tweens.FlxTween;

/**
 * Cat that wanders around the bottom of the screen sometimes
 * it can be used as an organ
 */
 class Cat extends UIElement {

    private var canMove:Bool = true;
    private var isMoving:Bool = false;
    private var movingTween:FlxTween;

    public function new(X:Float=0, Y:Float=0)  {
        super("Cat", X, Y);
    }

    public override function update() {
        if (!isMoving && canMove) {
            // If we're not moving, there's a 1 in 4 chance of starting to move
            if (Std.random(4) == 1) {
                isMoving = true;

                var x = this.x + Std.random(300) - 150;
                var y = FlxG.height + Std.random(300) - 150;

                movingTween = FlxTween.tween(this, {x: x, y: y}, 5, {complete: function(tween:FlxTween) {
                    isMoving = false;
                }});
            }
        }
    }

    public override function pickedUp() {
        movingTween.cancel();
        isMoving = false;
        canMove = false;
    }

    public override function dropped() {

        var closestHole = PlayState.getInstance().getClosestHole();

        if (closestHole != null) {
            return false;
        }

        // Otherwise we drop where we are and continue
        canMove = true;
        return true;
    }
 }