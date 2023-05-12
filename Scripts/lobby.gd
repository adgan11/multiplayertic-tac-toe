extends Node2D

const PORT = 4433


@export var pl_name = ""

@onready var scene = preload("res://Scenes/player.tscn")
@onready var item = preload("res://Scenes/player_item.tscn")
@onready var texture = preload("res://icon.svg")

var connected_peers = []

var items = []

func _ready():
	if DisplayServer.get_name() == "headless":
		print("Automatically starting the server...")

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server...")
		return
	multiplayer.multiplayer_peer = peer
	add_level(1)
	multiplayer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1.0).timeout
			add_level(new_peer_id)
	)


func _on_join_pressed():
	# Start as client.
	var txt = $IP.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer

func add_level(peer_id):
	connected_peers.append(peer_id)
	var player_item = item.instantiate()
	player_item.bg_color = Color.RED if peer_id == 1 else Color.BLUE
	player_item.player_id = str(peer_id)
	player_item.sprite_text = texture
	player_item.pressed_button.connect(selected_button)
	rpc("update_player_item", peer_id)
	rpc_id(peer_id, "update_old_player_item", connected_peers)
	$PlayerList/VBoxContainer.add_child(player_item)
	$PlayerList.show()
	var player = scene.instantiate()
	player.set_multiplayer_authority(peer_id)
	if peer_id == 1:
		$TicTacToe/GameBoard/Player1.text = str(peer_id)
	else:
		$TicTacToe/GameBoard/Player2.text = str(peer_id)
	add_child(player, true)
	
@rpc
func update_player_item(p_id):
	var player_item = item.instantiate()
	player_item.bg_color = Color.RED if p_id == 1 else Color.BLUE
	player_item.player_id = str(p_id)
	player_item.sprite_text = texture
	$PlayerList/VBoxContainer.add_child(player_item)
	
@rpc
func update_old_player_item(p_id):
	for peer in p_id:
		if peer != multiplayer.get_unique_id():
			update_player_item(peer)


func _on_name_text_changed(new_text):
	pl_name = new_text

func selected_button(p_id):
	print(p_id)
	rpc_id(str(p_id).to_int(), "start_game")
	$TicTacToe.show()

@rpc("call_remote")
func start_game():
	$TicTacToe.show()
