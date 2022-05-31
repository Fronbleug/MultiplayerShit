extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


remote func update_player(tform,vel):
	rpc_unreliable("update_remote_player",tform,vel)
remote func pushed(id,vel):
	get_parent().get_node(str(id)).rpc_id(id,"pushed",vel)

