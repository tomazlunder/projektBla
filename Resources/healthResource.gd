extends Resource

var maxHealth
var health

func TakeDamage(amount):
	if(amount < 0): 
		print("Negative damage!")
		return
	var math = health - amount
	if math > 0: health = math
	else: health = 0

func HealDamage(amount):
	if(amount < 0): 
		print("Negative heal!")
		return
	var math = health + amount
	if math < maxHealth: health = math
	else: health = maxHealth