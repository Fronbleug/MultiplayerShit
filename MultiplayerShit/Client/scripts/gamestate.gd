extends Node2D

const PLAYER = preload("res://scenes/objects/player.tscn")

onready var PlayerSpawn = $PlayerSpawn
onready var Players = $Players

func _ready():
	rpc_id(1,"spawn_players",server.LocalPlayerId)
	
remote func spawn_player(id):
	var player = PLAYER.instance()
	player.name = str(id)
	Players.add_child(player)
	player.set_network_master(id)
	player.position =  Vector2(rand_range(PlayerSpawn.position.x -64,PlayerSpawn.position.x + 64),  PlayerSpawn.position.y)
