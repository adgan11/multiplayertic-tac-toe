extends Node2D

var message = ""

func _on_send_pressed():
	if multiplayer.get_unique_id() == 1:
		get_parent().get_node("TicTacToe/MessagePanel/VBoxContainer/Label").text = ("Player 1 (host): " + $LineEdit.text)
	else:
		rpc("send_message", message)
		
@rpc("any_peer")
func send_message(msg):
	get_parent().get_node("TicTacToe/MessagePanel/VBoxContainer/Label2").text = ("Player 2 (client): " + msg)

func _on_line_edit_text_changed(new_text):
	message = new_text
