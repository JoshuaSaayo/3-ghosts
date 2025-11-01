extends AudioStreamPlayer

var fade_duration := 2.0  # seconds before the end to start fading
var start_db := -20.0       # normal volume
var end_db := -80.0       # fade-out target volume

func _process(delta):
	if playing and stream:
		var stream_length = stream.get_length()
		var current_pos = get_playback_position()
		var remaining = stream_length - current_pos

		# Fade out near the end
		if remaining <= fade_duration:
			var t = clamp(1.0 - (remaining / fade_duration), 0.0, 1.0)
			volume_db = lerp(start_db, end_db, t)
		else:
			# Ensure full volume before fade zone
			volume_db = start_db

		# When sound ends, restart (loop)
		if remaining <= 0.05: # small tolerance
			play()
