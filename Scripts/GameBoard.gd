extends Control

@export var press_chance = true

func _ready():
	for i in get_child(1).get_child(0).get_children():
		for y in i.get_children():
			y.toggle_mode = true
			y.pressed.connect(on_board_button_pressed.bind(y))

func on_board_button_pressed(y: Button):
	if y.button_pressed:
		if multiplayer.get_unique_id() == 1 and press_chance:
			y.text = "X"
			press_chance = !press_chance
		elif multiplayer.get_unique_id() != 1 and not press_chance:
			rpc("set_button", y.get_path())
			
func _process(delta):
	var row_1_but_1 = $GameBoard/Column/Row/Button.text
	var row_1_but_2 = $GameBoard/Column/Row/Button2.text
	var row_1_but_3 = $GameBoard/Column/Row/Button3.text
	var row_2_but_1 = $GameBoard/Column/Row2/Button.text
	var row_2_but_2 = $GameBoard/Column/Row2/Button2.text
	var row_2_but_3 = $GameBoard/Column/Row2/Button3.text
	var row_3_but_1 = $GameBoard/Column/Row3/Button.text
	var row_3_but_2 = $GameBoard/Column/Row3/Button2.text
	var row_3_but_3 = $GameBoard/Column/Row3/Button3.text
	
	for i in get_child(1).get_child(0).get_children():
		for y in i.get_children():
			if has_node(y.get_path()):
				if press_chance and y.text == "":
					y.modulate = Color.RED
				elif not press_chance and y.text == "":
					y.modulate = Color.BLUE
					
	if row_1_but_1 == row_1_but_2 and row_1_but_2 == row_1_but_3:
		if row_1_but_1 != "" and row_1_but_2 != "" and row_1_but_3 != "":
			if row_1_but_1 == "X":
				show_game_over("X")
			else:
				show_game_over("O")
	if row_2_but_1 == row_2_but_2 and row_2_but_2 == row_2_but_3:
		if row_2_but_1 != "" and row_2_but_2 != "" and row_2_but_3 != "":
			if row_2_but_1 == "X":
				show_game_over("X")
			else:
				show_game_over("O")
	if row_3_but_1 == row_3_but_2 and row_3_but_2 == row_3_but_3:
		if row_3_but_1 != "" and row_3_but_2 != "" and row_3_but_3 != "":
			if row_3_but_1 == "X":
				show_game_over("X")
			else:
				show_game_over("O")
	if row_1_but_1 == row_2_but_1 and row_2_but_1 == row_3_but_1:
		if row_1_but_1 != "" and row_2_but_1 != "" and row_3_but_1 != "":
			if row_1_but_1 == "X":
				show_game_over("X")
			else:
				show_game_over("O")
	if row_1_but_2 == row_2_but_2 and row_2_but_2 == row_3_but_2:
		if row_1_but_2 != "" and row_2_but_2 != "" and row_3_but_2 != "":
			if row_1_but_2 == "X":
				show_game_over("X")
			else:
				show_game_over("O")
	if row_1_but_3 == row_2_but_3 and row_2_but_3 == row_3_but_3:
		if row_1_but_3 != "" and row_2_but_3 != "" and row_3_but_3 != "":
			if row_1_but_3 == "X":
				show_game_over("X")
			else:
				show_game_over("O")
	if row_1_but_1 == row_2_but_2 and row_2_but_2 == row_3_but_3:
		if row_1_but_1 != "" and row_2_but_2 != "" and row_3_but_3 != "":
			if row_1_but_1 == "X":
				show_game_over("X")
			else:
				show_game_over("O")
	if row_1_but_3 == row_2_but_2 and row_2_but_2 == row_3_but_1:
		if row_1_but_3 != "" and row_2_but_2 != "" and row_3_but_1 != "":
			if row_1_but_3 == "X":
				show_game_over("X")
			else:
				show_game_over("O")

@rpc("any_peer")
func set_button(path) -> void:
	var button = get_node(path)
	button.text = "O"
	press_chance = !press_chance
	
func show_game_over(winner):
	if winner == "X":
		$GameOver/Label.text = "Player 1 (Host) win!"
		$GameOver.show()
	else:
		$GameOver/Label.text = "Player 2 (Client) win!"
		$GameOver.show()

func _on_restart_pressed():
	for i in get_child(1).get_child(0).get_children():
		for y in i.get_children():
			y.text = ""
			y.button_pressed = false
			$GameOver.hide()

