extends KinematicBody2D

var walkSpeed = 1.5
var runSpeed = 3.5
var showRange = false

var HUD_attribute_panel_open = false
var spawn

onready var AnimatedSprite=$AnimatedSprite

onready var Stats = $Stats

var lastDirPressed = Vector2(1,0)

#TODO: IMPLEMENT THIS
var inCombat = false

#Used mostly by non masters to change animations
var oldPosition = position

func _ready():
	#Stats = preload("res://Resources/stats/startingStats.tres")
	if(is_network_master()):
		Stats.connectSignals()
		MySignals.connect("hp_changed",self,"_on_hp_changed")
		MySignals.connect("player_dead",self,"onPlayerDeath")
		MySignals.connect("damage_taken", self, "_on_damage_taken")
	
	if(is_network_master()):
		$Camera2D.current = true;
		$NameLabel.hide()
	else:
		var playerName = netcode.playerNames[int(name)]
		$NameLabel.text = playerName

puppet func setPosition(newPosition):
	position = newPosition

func _process(delta):
	#TODO: These are temporaray...
	if(is_network_master()):
		if Input.is_key_pressed(KEY_9):
			Stats.TakeDamage(1)
		if Input.is_key_pressed(KEY_0):
			Stats.HealDamage(1)
		if Input.is_action_just_pressed("ui_attributes"):
			MySignals.emit_signal("attribute_panel_open", Stats)
	if(is_network_master()): movement(delta)
	animation()
	if(is_network_master()): attack()
	if(is_network_master()): showRange()
	if(is_network_master()): 
		Stats.regenerate(delta, $InCombatTimer.is_stopped(), $StaimnaRegenTimeout.is_stopped())
	#if(!is_network_master()):
	$HPLabel.text = str(int(Stats.hp))
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
		if(Stats.useStamina(10 * delta)):
			$StaimnaRegenTimeout.start()
			run = true
			
	if(moveDir.length() != 0):
		var move = moveDir.normalized()
		if(run): move = move * Stats.speed_run * delta
		else: move = move * Stats.speed_walk * delta
		
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
		if(Stats.useMana(20)):	
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
		
func retunSign(var num):
	if num >= 0: return 1
	if num < 0: return -1
	else: print("returnSignWrongInput!!!")

func _on_SpellTimeout_timeout():
	AnimatedSprite.play("idle")
	
func _on_hp_changed(hp):
	$HPLabel.text = str(int(hp))
	
func _on_damage_taken(damage):
	print("HEAL STOPPED")
	$InCombatTimer.start()
	
func onPlayerDeath():
	position = spawn
	Stats.hp = Stats.hp_max
	Stats.mana = Stats.mana_max
	Stats.stamina = Stats.stamina_max
	rpc_unreliable("setPosition",position)