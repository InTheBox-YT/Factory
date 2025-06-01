extends MeshInstance3D

@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer

func _ready():
	if audio_player.stream:
		audio_player.play()
	audio_player.connect("finished", _on_audio_finished)
func _on_audio_finished():
	audio_player.play()
