package;

import flixel.FlxSprite;

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
}