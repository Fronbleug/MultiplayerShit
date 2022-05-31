extends Node


var Network = NetworkedMultiplayerENet.new()
var Port = 6943
var MaxPlayers = 4

var Players = {}

func _ready():
	start_server()
	
func start_server():
	Network.create_server(Port,MaxPlayers)
	get_tree().set_network_peer(Network)
	Network.connect("peer_connected",self,"_player_connected")
	Network.connect("peer_disconnected",self,"_player_disconnected")
	
	print("ServerStarted")
	
func _player_connected(player_id):
	print("Player " + str(player_id) + "con")

func _player_disconnected(player_id):
	print("Player " + str(player_id) + "dis")
	Players.erase(player_id)
	rset("Players",Players)
	print("data "+str(Players))
	
remote func send_player_info(id,playerdata):
	Players[id] = playerdata
	rset("Players",Players)
	print("data "+str(Players))
	rpc("update_waiting_room")

remote func load_world():
	rpc("start_game")
	var world = preload("res://scenes/levels/test.tscn").instance()
	get_tree().get_root().add_child(world)
