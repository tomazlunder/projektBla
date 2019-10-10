extends KinematicBody2D

var walkSpeed = 1.5
var runSpeed = 3.5
var showRange = false

onready var AnimatedSprite=$AnimatedSprite
onready var FeetPosition=$FeetPosition

var MyHealthResource = globals.HealthResource.new()

var lastDirPressed = Vector2(1,0)

#Used mostly by non masters to change animations
var oldPosition = position
var lastAnim = "idle"

func _ready():
	MyHealthResource.MaxHealth=100
	
	if(is_network_master()):
		$Camera2D.current = true;
		$NameLabel.hide()
	else:
		var playerName = netcode.playerNames[int(name)]
		#var size = $NameLabel.get_font("font").get_string_size(playerName)
		$NameLabel.text = playerName

puppet func setPosition(newPosition):
	position = newPosition

func _process(delta):
	if(is_network_master()): movement()
	animation()
	if(is_network_master()): attack()
	if(is_network_master()): showRange()
	oldPosition = position

func movement():
	if(!$SpellTimeout.is_stopped()): return
	
	var moveDir = Vector2(0,0)
	var run = false
	if Input.is_action_pressed("ui_up"):
		moveDir.y += -1;
		lastDirPressed = Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		moveDir.y += 1;
		lastDirPressed = Vector2(0,1)
	if Input.is_action_pressed("ui_left"): 
		moveDir.x += -1
		lastDirPressed = Vector2(-1,0)
	if Input.is_action_pressed("ui_right"): 
		moveDir.x += 1;
		lastDirPressed = Vector2(1,0)
	if Input.is_action_pressed("ui_run"):
		run = true
			
	if(moveDir.length() != 0):
		var move = moveDir.normalized()
		if(run): move = move * runSpeed
		else: move = move * walkSpeed
		
		move_and_collide(move)
		#Tell other computers about our new position so they can update
		rpc_unreliable("setPosition",position)

func animation():
	if(!$SpellTimeout.is_stopped()): return
	
	var moved = position - oldPosition
	
	if(moved.length() == 0 && lastAnim != "idle" && lastAnim != "idleAway"):
		if(lastAnim == "walkAway"): 
			AnimatedSprite.play("idleAway")
			lastAnim = "idleAway"
		else: 
			AnimatedSprite.play("idle")
			lastAnim = "idle"
	
	if(moved.x > 0 && lastAnim != "walk_right"):
		AnimatedSprite.play("walk")
		AnimatedSprite.flip_h = false
		lastAnim = "walk_right"
	
	if(moved.x < 0 && lastAnim != "walk_left"):
		AnimatedSprite.play("walk")
		AnimatedSprite.flip_h = true
		lastAnim = "walk_left"
			
	if(moved.y < 0 && moved.x == 0 && lastAnim != "walkAway"):
		AnimatedSprite.play("walkAway")
		lastAnim = "walkAway"
	
	if(moved.y > 0 && moved.x == 0):
		AnimatedSprite.play("walk")
		lastAnim = "walk"
		
func showRange():
	if(showRange):
		var tileX = position.x/32
		var tileY = position.y/32
		$greylineRange3.global_position = Vector2(int(tileX)*32+16*retunSign(tileX),int(tileY)*32+16*retunSign(tileY))
		$greylineRange3.visible = true
		
	if(Input.is_action_just_pressed("ui_range")):
		showRange = !showRange
		if(showRange):
			var tileX = position.x/32
			var tileY = position.y/32
			$greylineRange3.global_position = Vector2(int(tileX)*32+16*retunSign(tileX),int(tileY)*32+16*retunSign(tileY))
		else:
			$greylineRange3.visible = false

func attack():
	if(Input.is_action_just_pressed("ui_attack") && $SpellTimeout.is_stopped()):
		#print("FIRE!")
		$SpellTimeout.start()
		rpc_unreliable("spawnFireball",get_tree().get_network_unique_id(), lastDirPressed)
		
remotesync func spawnFireball(var playerID, var directionInput):
		if(lastAnim != "walkAway" && lastAnim != "idleAway"):
			AnimatedSprite.play("cast")
		lastAnim = "cast"
	
		var fireBall = load("res://Scenes/Game/Fireball.tscn").instance()
		fireBall.global_position = global_position
		if(directionInput.x != 0 || directionInput.y < 0): fireBall.global_position += directionInput.normalized()*16
		if(directionInput.y >= 0): fireBall.global_position.y += 0.1
		#fireBall.global_position += Vector2(-64,-64)
		fireBall.direction = directionInput
		fireBall.playerID = playerID
		get_parent().add_child(fireBall)

func retunSign(var num):
	if num >= 0: return 1
	if num < 0: return -1
	else: print("returnSignWrongInput!!!")

func _on_SpellTimeout_timeout():
	AnimatedSprite.play("idle")
	lastAnim = "idle"
