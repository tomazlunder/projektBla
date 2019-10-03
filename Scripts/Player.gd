extends Node2D

func _ready():
	if(is_network_master()):
		$Camera2D.current = true;
		$NameLabel.hide()
	else:
		var playerName = globals.playerNames[int(name)]
		#var size = $NameLabel.get_font("font").get_string_size(playerName)
		$NameLabel.text = playerName

puppet func setPosition(newPosition):
	position = newPosition

master func shutItDown():
	rpc("shutDown")
	
sync func shutDown():
	get_tree().quit()


#Used mostly by non masters to change animations
var oldPosition = position
var lastAnim = "idle"
var direction = 0

func _process(delta):
	var moveByX = 0
	var moveByY = 0
	var maxSpeed = 3.5
	
	if(is_network_master()):
		if Input.is_action_pressed("ui_left"):
			$AnimatedSprite.flip_h = true
			moveByX = -1
			
		if Input.is_action_pressed("ui_right"):
			$AnimatedSprite.flip_h = false
			moveByX = 1
			
		if Input.is_action_pressed("ui_up"):
			moveByY = -1
			
		if Input.is_action_pressed("ui_down"):
			moveByY = 1
			
		var move = Vector2(moveByX,moveByY)
		if(move.length() != 0):
			if(move.y < 0 && move.x == 0):
				lastAnim = "walkAway"
				$AnimatedSprite.play("walkAway")
			else:
				lastAnim = "walk"
				$AnimatedSprite.play("walk")
			move = move.normalized()*maxSpeed
			var newPos = position - move
			#Tell other computers about our new position so they can update
			rpc_unreliable("setPosition",newPos)
			#Move our local player
			translate(move)
		else:
			if(lastAnim == "walkAway"):
				$AnimatedSprite.play("idleAway")
			else: 
				$AnimatedSprite.play("idle")
	
	if not is_network_master():
		var moved = position - oldPosition
		if(moved.length() == 0 && lastAnim != "idle"):
			if(lastAnim == "walkAway"):
				$AnimatedSprite.play("idleAway")
			else:
				$AnimatedSprite.play("idle")
			lastAnim = "idle"
			direction = 0
	
		if(moved.x > 0 && direction != 1):
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
			lastAnim = "walk"
			direction = 1
	
		if(moved.x < 0 && direction != -1):
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
			lastAnim = "walk"
			direction = -1
			
		if(moved.y < 0 && moved.x == 0 && lastAnim != "walkAway"):
			$AnimatedSprite.play("walkAway")
			lastAnim = "walkAway"
			direction = 0
			
		if(moved.y > 0 && moved.x == 0):
			$AnimatedSprite.play("walk")
			lastAnim = "walk"
			direction = 1
			
	oldPosition = position
	
		#if Input.is_key_pressed(KEY_Q):
		#	if is_network_server():
		#		shutItDown()
		