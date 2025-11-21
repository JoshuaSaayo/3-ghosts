extends AudioStreamPlayer

func _ready():
	play()  # start playing automatically

func _process(delta):
	if playing and stream:
		var stream_length = stream.get_length()
		var current_pos = get_playback_position()
		if current_pos >= stream_length - 0.01:  # small tolerance
			play()  # restart the audio (loop)
