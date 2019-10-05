extends KinematicBody2D

var walkSpeed = 1.5
var runSpeed = 3.5
var showRange = false

onready var AnimatedSprite=$AnimatedSprite
onready var FeetPosition=$FeetPosition

var MyHealthResource = globals.HealthResource.new()

#Used mostly by non masters to change animations
var oldPosition = position
var lastAnim = "idle"
var direction = 0

func _ready():
	MyHealthResource.MaxHealth=100
	
	if(is_network_master()):
		$Camera2D.current = true;
		$NameLabel.hide()
	else:
		var playerName = globals.playerNames[int(name)]
		#var size = $NameLabel.get_font("font").get_string_size(playerName)
		$NameLabel.text = playerName

puppet func setPosition(newPosition):
	position = newPosition

func _process(delta):
	if(is_network_master()): movement()
	animation()
	if(is_network_master()): showRange()
	oldPosition = position

func movement():
	var moveDir = Vector2(0,0)
	var run = false
	if Input.is_action_pressed("ui_left"): moveDir.x += -1
	if Input.is_action_pressed("ui_right"): moveDir.x += 1	
	if Input.is_action_pressed("ui_up"): moveDir.y += -1
	if Input.is_action_pressed("ui_down"): moveDir.y += 1
	if Input.is_action_pressed("ui_run"): run = true
			
	if(moveDir.length() != 0):
		var move = moveDir.normalized()
		if(run): move = move * runSpeed
		else: move = move * walkSpeed
		
		move_and_collide(move)
		#Tell other computers about our new position so they can update
		rpc_unreliable("setPosition",position)

func animation():
	var moved = position - oldPosition
	
	if(moved.length() == 0 && lastAnim != "idle"):
		if(lastAnim == "walkAway"): AnimatedSprite.play("idleAway")
		else: AnimatedSprite.play("idle")
		lastAnim = "idle"
		direction = 0
	
	if(moved.x > 0 && direction != 1):
		AnimatedSprite.play("walk")
		AnimatedSprite.flip_h = false
		lastAnim = "walk"
		direction = 1
	
	if(moved.x < 0 && direction != -1):
		AnimatedSprite.play("walk")
		AnimatedSprite.flip_h = true
		lastAnim = "walk"
		direction = -1
			
	if(moved.y < 0 && moved.x == 0 && lastAnim != "walkAway"):
		AnimatedSprite.play("walkAway")
		lastAnim = "walkAway"
		direction = 0
	
	if(moved.y > 0 && moved.x == 0):
		AnimatedSprite.play("walk")
		lastAnim = "walk"
		direction = 0
			
func showRange():
	if(showRange):
		var tileX = FeetPosition.global_position.x/32
		var tileY = FeetPosition.global_position.y/32
		$greylineRange3.global_position = Vector2(int(tileX)*32+16*retunSign(tileX),int(tileY)*32+16*retunSign(tileY))
		$greylineRange3.visible = true
		
	if(Input.is_action_just_pressed("ui_range")):
		showRange = !showRange
		if(showRange):
			var tileX = FeetPosition.global_position.x/32
			var tileY = FeetPosition.global_position.y/32
			$greylineRange3.global_position = Vector2(int(tileX)*32+16*retunSign(tileX),int(tileY)*32+16*retunSign(tileY))
		else:
			$greylineRange3.visible = false

func retunSign(var num):
	if num >= 0: return 1
	if num < 0: return -1
	else: print("returnSignWrongInput!!!")