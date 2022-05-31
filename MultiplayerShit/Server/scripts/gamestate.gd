extends Node

const PLAYER = preload("res://scenes/objects/player.tscn")

onready var Players = $Players

remote func spawn_players(id):
	var player = PLAYER.instance()
	player.name = str(id)
	Players.add_child(player)
	rpc("spawn_player",id)

	
