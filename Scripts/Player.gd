extends KinematicBody2D

var walkSpeed = 1.5
var runSpeed = 3.5
var showRange = false

onready var AnimatedSprite=$AnimatedSprite
onready var FeetPosition=$FeetPosition

var MyHealthResource = globals.HealthResource.new()
var MyManaResource = globals.ManaResource.new()
var MyStaminaResource = globals.StaminaResource.new()

var lastDirPressed = Vector2(1,0)

#Used mostly by non masters to change animations
var oldPosition = position

func _ready():
	MyHealthResource.maxHealth=100
	MyHealthResource.health= 100
	
	MyManaResource.maxMana = 100
	MyManaResource.mana = 100
	
	MyStaminaResource.maxStamina = 100
	MyStaminaResource.stamina = 100
	
	if(is_network_master()):
		$Camera2D.current = true;
		$NameLabel.hide()
	else:
		var playerName = netcode.playerNames[int(name)]
		$NameLabel.text = playerName
		$HUD/Interface.hide()

puppet func setPosition(newPosition):
	position = newPosition

func _process(delta):
	if Input.is_key_pressed(KEY_9):
		MyHealthResource.TakeDamage(1)
	if Input.is_key_pressed(KEY_0):
		MyHealthResource.HealDamage(1)
	if(is_network_master()): movement(delta)
	animation()
	if(is_network_master()): attack()
	if(is_network_master()): showRange()
	if(is_network_master()): updateHud()
	if(is_network_master()): 
		MyManaResource.gainMana(1*delta)
		if($StaimnaRegenTimeout.time_left == 0):
			MyStaminaResource.gainStamina(5*delta)
	oldPosition = position

func movement(delta):
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
		if(MyStaminaResource.useStamina(10 * delta)):
			$StaimnaRegenTimeout.start()
			run = true
			
	if(moveDir.length() != 0):
		var move = moveDir.normalized()
		if(run): move = move * runSpeed
		else: move = move * walkSpeed
		
		move_and_collide(move)
		#Tell other computers about our new position so they can update
		rpc_unreliable("setPosition",position)

func animation():
	var currentAnimation = AnimatedSprite.animation
	
	if(!$SpellTimeout.is_stopped()): return
	
	var moved = position - oldPosition
	
	if(moved.length() == 0 && currentAnimation != "idle" && currentAnimation != "idleAway"):
		if(currentAnimation == "walkAway"): 
			AnimatedSprite.play("idleAway")
		else: 
			AnimatedSprite.play("idle")
	
	if(moved.x > 0 && currentAnimation != "walk_right"):
		AnimatedSprite.play("walk")
		AnimatedSprite.flip_h = false
	
	if(moved.x < 0 && currentAnimation != "walk_left"):
		AnimatedSprite.play("walk")
		AnimatedSprite.flip_h = true
			
	if(moved.y < 0 && moved.x == 0 && currentAnimation != "walkAway"):
		AnimatedSprite.play("walkAway")
	
	if(moved.y > 0 && moved.x == 0 && currentAnimation != "walk"):
		AnimatedSprite.play("walk")
		
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
		if(MyManaResource.useMana(20)):	
			$SpellTimeout.start()
			rpc_unreliable("spawnFireball",get_tree().get_network_unique_id(), lastDirPressed)
		
remotesync func spawnFireball(var playerID, var directionInput):
		var currentAnimation = AnimatedSprite.animation
	
		if(currentAnimation != "walkAway" && currentAnimation != "idleAway"):
			AnimatedSprite.play("cast")
	
		var fireBall = load("res://Scenes/Game/Fireball.tscn").instance()
		fireBall.global_position = global_position
		if(directionInput.x != 0 || directionInput.y < 0): fireBall.global_position += directionInput.normalized()*16
		if(directionInput.y >= 0): fireBall.global_position.y += 0.1
		fireBall.direction = directionInput
		fireBall.playerID = playerID
		get_parent().add_child(fireBall)
		
func updateHud():
	$HUD/Interface/HealthBar.updateValue(float(MyHealthResource.health) / float(MyHealthResource.maxHealth))
	$HUD/Interface/ManaBar.updateValue(float(MyManaResource.mana) / float(MyManaResource.maxMana))
	$HUD/Interface/StaminaBar.updateValue(float(MyStaminaResource.stamina) / float(MyStaminaResource.maxStamina))
	
func retunSign(var num):
	if num >= 0: return 1
	if num < 0: return -1
	else: print("returnSignWrongInput!!!")

func _on_SpellTimeout_timeout():
	AnimatedSprite.play("idle")
