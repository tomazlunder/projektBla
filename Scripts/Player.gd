extends Node2D

func _ready():
	pass # Replace with function body.

puppet func setPosition(pos):
	position = pos

master func shutItDown():
	rpc("shutDown")
	
sync func shutDown():
	get_tree().quit()
	
func _process(delta):
	var moveByX = 0
	var moveByY = 0
	if(is_network_master()):
		if Input.is_key_pressed(KEY_LEFT):
			moveByX = -5
			
		if Input.is_key_pressed(KEY_RIGHT):
			moveByX = 5
			
		if Input.is_key_pressed(KEY_UP):
			moveByY = -5
			
		if Input.is_key_pressed(KEY_DOWN):
			moveByY = 5
			
		#Tell other computers about our new position so they can update
		rpc_unreliable("setPosition",Vector2(position.x - moveByX, position.y))
		
		#Move our local player
		translate(Vector2(moveByX, moveByY))
		
		
		#if Input.is_key_pressed(KEY_Q):
		#	if is_network_server():
		#		shutItDown()
		