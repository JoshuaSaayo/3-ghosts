extends Node
class_name dialog_manager


var dialog : Dictionary = {
	1:{
		"pre": {
			"monologue||Player": [
				"She cursed me and swore I was the monster who killed her children.",
				"Their ghosts haunt the night now. Tonight I'll capture them and drag the witch out into the open.",
				"She'll pay for what she's done."
			]
		},
		"post": {
			"confrontation||Player": [
				"I caught you! Now tell me, brat ghost! Who sent you?!"
			],
			"teasing||Yuna": [
				"mmm~ what will you do then?."
			],
			"threat||Player": [
				"Obviously fuck you hard! You horny brat ghost!"
			]
		}
	},
	2:{
		"pre": {
			"determination||Player": [
				"That was a tough sex. Maybe this time I will capture and make her talk."
			]
		},
		"post": {
			"seduction||Yuna": [
				"mmmm you have amazing cock right there~",
				"mmmm fill my mouth~",
				"she will suck you hard until you die at 7th night~"
			],
			"resistance||Player": [
				"What the hell do you think you are doing?!",
				"Wait tell me about the witch!",
				"ahh shit!"
			]
		}
	},
	3:{
		"pre": {
			"planning||Player": [
				"hmm on 7th night? I hope she will come. I have to survive for the nights and keep fucking these ghosts hard."
			]
		},
		"post": {
			"seduction||Nino": [
				"What a fine gentleman, are you horny now?"
			],
			"resistance||Player": [
				"You are seducing me so hard right now… Don't distract me and tell me about the Witch first."
			],
			"distraction||Nino": [
				"ahh what are you talking about? I can't think hard without your cum in my pussy~"
			],
			"anger||Player": [
				"Fuck you!"
			]
		}
	},
	4:{
		"pre": {
			"resignation||Player": [
				"Another night to survive. Guess I have to keep going… This is an everlasting nightmare."
			]
		},
		"post": {
			"confrontation||Nino": [
				"Why are you staring at me like that? You want my boobs? My ass?"
			],
			"anger||Player": [
				"You fucking know who I am after!"
			],
			"information||Nino": [
				"The witch you mean?! Ask my girlfriend Margarete, she knows her well."
			],
			"demand||Player": [
				"who is supposedly that margarete?"
			],
			"seduction||Nino": [
				"Let me grab that cock first my dear~"
			]
		}
	},
	5:{
		"pre": {
			"caution||Player": [
				"Today is Margarete's appearance… I have to be cautious. Nino said I shouldn't flash her. I will just let her roam around and she will disappear."
			]
		},
		"post": {
			"seduction||Margarete": [
				"I know what you are after handsome."
			],
			"frustration||Player": [
				"I am tired of your shenanigans… I need to know and y'all will leave me in peace!"
			],
			"offer||Margarete": [
				"you are so hard, why don't we spice up the moment and I will tell you exactly where is she now~"
			],
			"warning||Margarete": [
				"After all, I want you to be prepared for her arrival tomorrow."
			]
		}
	}
}


func _get_dialog(time : String):
	var dict = dialog[Globals.day][time]
	return dict
