extends Node2D

func _ready():
	if(is_network_master()):
		#get_tree().get_node("Camera2D").add_child(self)
		get_node("Camera2D").current = true;
		get_node("NameLabel").hide()
	else:
		var nameStr = globals.playerNames[int(name)]
		var size = get_node("NameLabel").get_font("font").get_string_size(nameStr)
		get_node("NameLabel").text = nameStr
		
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
	var maxSpeed = 3.5
	
	if(is_network_master()):
		if Input.is_action_pressed("ui_left"):
			moveByX = -1
			
		if Input.is_action_pressed("ui_right"):
			moveByX = 1
			
		if Input.is_action_pressed("ui_up"):
			moveByY = -1
			
		if Input.is_action_pressed("ui_down"):
			moveByY = 1
			
		var move = Vector2(moveByX,moveByY)
		if(move.length() != 0):
			move = move.normalized()*maxSpeed
			var newPos = position - move
			#Tell other computers about our new position so they can update
			rpc_unreliable("setPosition",newPos)
			#Move our local player
			translate(move)
		
		#if Input.is_key_pressed(KEY_Q):
		#	if is_network_server():
		#		shutItDown()
		