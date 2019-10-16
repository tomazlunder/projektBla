extends Area2D

const SPEED = 250
var damage = 20
var direction = Vector2()
var playerID = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_network_master(1)
	pass # Replace with function body.

func _physics_process(delta):
	if($LifeTime.time_left < 1.5):
		var velocity = direction.normalized() * SPEED * delta
		translate(velocity)

func _on_Timer_timeout():
	queue_free()

func _on_Node2D_body_entered(body):
	if(get_tree().multiplayer.is_network_server()):
		if not body.get("Stats") == null:
			var playerID = int(body.name)
			if(playerID == 1):
				MySignals.emit_signal("deal_damage_signal", damage)
			else:
				rpc_id(playerID,"deal_damage")
			rpc("destroy")
	
#Only called on the correct client
remote func deal_damage():
	MySignals.emit_signal("deal_damage_signal", damage)

remotesync func destroy():
	queue_free()
