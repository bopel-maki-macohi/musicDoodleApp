package;

import lime.media.AudioBuffer;
import openfl.media.Sound;
import openfl.display.LoaderInfo;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.FileFilter;
import lime.ui.FileDialog;
import openfl.net.FileReference;
import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	var instructions:FlxText;
	var instructionsArray:Array<String> = ['CTRL + O : Open Music File',];

	override public function create()
	{
		super.create();

		instructions = new FlxText();
		instructions.text = instructionsArray.join('\n');
		add(instructions);
		instructions.x = instructions.y = instructions.size;

		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
	}

	override function destroy()
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKey);
		super.destroy();
	}

	function onKey(event:KeyboardEvent)
	{
		if (event.controlKey && event.keyCode == FlxKey.O)
		{
			this.openMusicFile();
			return;
		}
	}

	function openMusicFile()
	{
		var fr = new FileReference();

		function oncancel(e:Event)
		{
			trace('Cancelled MF Selection');
		}

		function onselect(e:Event)
		{
			trace('Selected MF : ${fr.name}');

			function onload(e:Event)
			{
				trace('Loaded MF Data');

				fr.removeEventListener(Event.COMPLETE, onload);
				FlxG.sound.playMusic(Sound.fromAudioBuffer(AudioBuffer.fromBytes(fr.data)), null, 1, true);
			}

			fr.addEventListener(Event.COMPLETE, onload, false, 0, true);
			fr.load();
		}

		fr.addEventListener(Event.CANCEL, oncancel);
		fr.addEventListener(Event.SELECT, onselect);

		fr.browse([
			new FileFilter('OGG Files', '*.ogg'),
			new FileFilter('MP3 Files', '*.mp3'),
			new FileFilter('WAV Files', '*.wav'),
		]);
	}
}
