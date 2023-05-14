extends Control

@export var bg_color: Color
@export var sprite_text: Texture2D
@export var player_id: String
@export var selected: bool
signal pressed_button(peer_id)

func _enter_tree():
	$ColorRect.color = bg_color
	$Sprite2D.set_texture(sprite_text)
	$Label.text = player_id
	$Button.button_pressed = selected


func _on_button_pressed():
	pressed_button.emit($Label.text)

	
