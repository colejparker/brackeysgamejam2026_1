extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer



func start():
	audio_stream_player.playing = true
	
func stop():
	audio_stream_player.playing = false
