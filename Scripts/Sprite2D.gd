extends Sprite2D

func _ready():
	set_multiplayer_authority(multiplayer.get_unique_id())
