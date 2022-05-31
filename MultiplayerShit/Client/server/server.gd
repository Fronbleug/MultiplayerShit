extends Node


const DEFAULTIP = "127.0.0.1"
const DEFAULTPORT = 6943

var Network = NetworkedMultiplayerENet.new()
var SelectedIP
var SelectedPort

var LocalPlayerId = 0
sync var Players = {}
sync var PlayerData = {}

func _ready():
	SelectedIP = DEFAULTIP
	SelectedPort = DEFAULTPORT
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected",self, "_player_disconnected")
	get_tree().connect("connection_failed",self, "_connection_failed")
	get_tree().connect("server_disconnected",self, "_server_disconnected")
	
func _connect_to_server():
	get_tree().connect("connected_to_server",self,"_connected_ok")
	Network.create_client(SelectedIP,SelectedPort)
	get_tree().set_network_peer(Network)
	
func _player_connected(id):
	print("Player "+ str(id)+" Connected")
func _player_discronnected(id):
	print("Player "+ str(id)+" Connected")
	
func _connected_ok():
	print("Connected")
	register_player()
	rpc_id(1,"send_player_info",LocalPlayerId,PlayerData)
func _connection_fail():
	print("fail")
func _server_disconnected():
	print("disconnected")
func register_player():
	LocalPlayerId = get_tree().get_network_unique_id()
	PlayerData = save.SaveData
	Players[LocalPlayerId] = PlayerData

sync func update_waiting_room():
	print(Players)
	
func load_game():
	print("loading_world")
	rpc_id(1,"load_world")
	
sync func start_game():
	var world = preload("res://scenes/levels/test.tscn").instance()
	print("GameLoaded")
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").queue_free()
