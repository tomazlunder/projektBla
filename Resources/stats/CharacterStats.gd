extends Resource

class_name CharacterStats

#For future use
signal health_changed(new_health, old_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana)
signal stamina_changed(new_stamina, old_stamina)

export var hp_max : float 
export var hp_regen : float
export var hp : float

export var mana_max : float
export var mana_regen : float
export var mana : float

export var stamina_max : float
export var stamina_regen : float
export var stamina : float

export var walkSpeed : float
export var runSpeed : float

func TakeDamage(amount):
	var hp_old = hp
	if(amount < 0): 
		print("Negative damage!")
		return
	var math = hp - amount
	if math > 0: 
		hp = math
	else: 
		hp = 0
	
	emit_signal("health_changed", hp, hp_old)

func HealDamage(amount):
	if(amount < 0): 
		print("Negative heal!")
		return
	var math = hp + amount
	if math < hp_max: 
		hp = math
	else: 
		hp = hp_max
		
func useMana(amount):
	if(amount < 0): 
		print("Negative mana use!")
		return
	var math = mana - amount
	if math > 0:
		mana = math
		return true
	else:
		mana = 0
		return false

func gainMana(amount):
	if(amount < 0): 
		print("Negative mana gain!")
		return
	var math = mana + amount
	if math < mana_max:
		mana = math
	else:
		mana = mana_max
		
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
	if math < stamina_max:
		stamina = math
	else:
		stamina = stamina_max