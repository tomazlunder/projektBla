extends Resource

var maxStamina
var stamina

func useStamina(amount):
	if(amount < 0): 
		print("Negative mana use!")
		return
	var math = stamina - amount
	if math > 0:
		stamina = math
		return true
	else:
		stamina = 0
		return false

func gainStamina(amount):
	if(amount < 0): 
		print("Negative mana gain!")
		return
	var math = stamina + amount
	if math < maxStamina:
		stamina = math
	else:
		stamina = maxStamina