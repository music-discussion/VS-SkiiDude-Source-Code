package;

import flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode;
//import cpp.abi.Abi;
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditsState extends MusicBeatState
{
    override function create()
    {
        #if windows
        // Updating Discord Rich Presence
        DiscordClient.changePresence("Viewing the Credits for Skii Dude", null);
        #end

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        add(bg);
        
        super.create();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.sound.music.volume < 0.8)
        {
            FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
        }

            if (controls.BACK)
            {
                FlxG.switchState(new MainMenuState());
                FlxG.sound.play(Paths.sound('cancelMenu'));
            }
        }
}