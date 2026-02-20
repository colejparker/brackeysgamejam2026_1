extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _play_sound(sample: AudioStreamWAV):
	if Game.fx_on:
		audio_stream_player.stream = sample
		audio_stream_player.playing = true
