package;

import flixel.FlxG;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

/**
 * Useful functions that don't fit anywhere else
 */
class Utils
{
    /**
     * Move a sprite to the front of a members array.
     *
     * Pass in the "inFrontOf" to just move it in front of something else,
     * not to the front.
     */
    public static function bringToFront(members:Array<Dynamic>, member:FlxSprite, inFrontOf:FlxSprite=null) {
        var i = members.indexOf(member);

        var target_index = members.length - 1;
        if (inFrontOf != null) {
            target_index = members.indexOf(inFrontOf);
        }

        while (i < target_index) {
            members[i] = members[i + 1];
            i++;
        }
        members[i] = member;
    }

    /**
     * Apply masks for different sized sprites. They will be centered on each other
     */
    public static function applyMask(original:FlxSprite, mask:FlxSprite) {
        // Create a large version of the original
        var largeOriginal = new FlxSprite();
        largeOriginal.makeGraphic(500, 500, FlxColor.TRANSPARENT, true);

        var copyPoint = new Point((largeOriginal.width / 2) - (original.width / 2), (largeOriginal.height / 2) - (original.height - 2));
        largeOriginal.pixels.copyPixels(original.pixels, new Rectangle(0, 0, original.width, original.height), copyPoint);

        // Create a large version of the mask
        var largeMask = new FlxSprite();
        largeMask.makeGraphic(500, 500, FlxColor.TRANSPARENT, true);

        var maskPoint = new Point((largeMask.width / 2) - (mask.width / 2), (largeMask.height / 2) - (mask.height - 2));
        largeMask.pixels.copyPixels(mask.pixels, new Rectangle(0, 0, mask.width, mask.height), maskPoint);

        // Apply the mask
        var appliedMask = new FlxSprite();
        appliedMask.makeGraphic(500, 500, FlxColor.TRANSPARENT, true);

        FlxSpriteUtil.alphaMaskFlxSprite(largeOriginal, largeMask, appliedMask);

        // Copy the result back to the original
        original.makeGraphic(Std.int(original.width), Std.int(original.height), FlxColor.TRANSPARENT);
        original.pixels.copyPixels(appliedMask.pixels, new Rectangle(copyPoint.x, copyPoint.y, original.width, original.height), new Point(0, 0));

    }

    public static function createButton(text:String, callback:Void->Void, scale:Float, labelSize:Float){
        var button:FlxButton = new FlxButton(0, 0, text, callback);
        button.scale.x = button.scale.y = scale;
        button.width = button.scale.x * button.frameWidth;
        button.height = button.scale.y * button.frameHeight;
        button.centerOffsets(true);
        
        button.label = new FlxText(0, 0, button.width, text);
        button.label.setFormat(null, labelSize, 0x333333, "center");
        button.label.y = 2000;

        return button;
    }
}