package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef VelocityChange = {
	var startTime:Float;
	var multiplier:Float;
}

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var noteStyle:String;
	var stage:String;
	var validScore:Bool;
	var warning:Bool;
	var charter:String;
	@:optional var sliderVelocities:Array<VelocityChange>;
	@:optional var initialSpeed:Float;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var initialSpeed:Float = 1;
	public var sliderVelocities:Array<VelocityChange>=[];

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = '';
	public var noteStyle:String = '';
	public var stage:String = '';
	public var warning:Bool;
	public var charter:String = '';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		trace(jsonInput);

		// pre lowercasing the folder name
		var folderLowercase = StringTools.replace(folder, " ", "-").toLowerCase();
		switch (folderLowercase) {
			case 'dad-battle': folderLowercase = 'dadbattle';
			case 'philly-nice': folderLowercase = 'philly';
		}
		
		trace('loading ' + folderLowercase + '/' + jsonInput.toLowerCase());

		var rawJson = Assets.getText(Paths.json(folderLowercase + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var cumData = Json.parse(rawJson);
		var swagShit:SwagSong = cast cumData.song;
		swagShit.initialSpeed = swagShit.speed*.45;
		trace(cumData.sliderVelocities);
		if (cumData.sliderVelocities != null)
		{
			var shit:Array<VelocityChange> = cast cumData.sliderVelocities;
			trace(shit);
			swagShit.sliderVelocities = shit;
		}
		else
		{
			swagShit.sliderVelocities = [
				{
					startTime: 0,
					multiplier: 1
				}
			];
		}
		swagShit.validScore = true;
		return swagShit;
	}
}
