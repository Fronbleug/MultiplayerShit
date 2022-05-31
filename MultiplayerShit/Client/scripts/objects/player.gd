extends KinematicBody2D

enum STATES {normal,blue}

var UpDir = Vector2.UP

var Velocity = Vector2()

var State = STATES.normal
var Jumping = false

var PushBody = null

var PushTimer = 0

var PushedTimer = 0


func _physics_process(delta):
	
	if is_network_master():
		if PushedTimer<=0:
			Velocity.x = 0
		var InputDir = Vector2()
		InputDir.x = Input.get_axis("ui_left","ui_right")
		InputDir.y = Input.get_axis("ui_up","ui_down")
		
		
		match State:
			STATES.blue:
				if PushedTimer<=0:
					if is_on_floor():
						if Input.is_action_just_pressed("ui_up"):
							Jumping = true
							Velocity.y -= 160
					
					else:
						if Jumping:
					
							if not Input.is_action_pressed("ui_up"):
								Velocity.y = 0
								Jumping = false
				Velocity.y += 16
			STATES.normal:
				if PushedTimer <=0:
					Velocity.y = 0
					Velocity.y += InputDir.y * 64
				else:
					Velocity.y = lerp(Velocity.y,0,0.01)
		if PushedTimer <=0:
			Velocity.x += InputDir.x * 64
		else:
			Velocity.x = lerp(Velocity.x,0,0.01)
		if PushTimer >0:
			print("balls")
			Velocity = Vector2()
			PushTimer -= delta
		Velocity = move_and_slide(Velocity,UpDir)
		$PushZone.position = InputDir.normalized() * 14
		
		if PushedTimer >0:
			PushedTimer -= delta
		if PushTimer <= 0:
				if Input.is_action_just_pressed("ui_accept"):
					PushTimer = 1
					if PushBody != null:
						print("pushing")
						rpc_id(1,"pushed",PushBody.name.to_int(), InputDir.normalized() * 320)
						
			

		
		rpc_unreliable_id(1,"update_player",global_transform,Velocity)
remote func update_remote_player(tform,velocity):
	if not is_network_master():
		global_transform = tform
		Velocity=velocity
		
sync func pushed(vel):
	print("balls")
	print("balls2")
	PushedTimer = 1
	Velocity += vel

sync func remove_player():
	queue_free()

func _on_PushZone_body_entered(body):
	if body.is_in_group("Player"):
		if body != self:
			print("in")
			PushBody = body


func _on_PushZone_body_exited(body):
		if body == PushBody:
			PushBody = null
