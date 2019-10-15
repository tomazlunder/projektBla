extends Resource

class_name CharacterStats

#For future use
signal health_changed(new_health, old_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana)
signal stamina_changed(new_stamina, old_stamina)

export var level : int
export var experience : int
export var attribute_points : int

export var hp_max : float 
export var hp_regen : float
export var hp : float

export var mana_max : float
export var mana_regen : float
export var mana : float

export var stamina_max : float
export var stamina_regen : float
export var stamina : float

export var speed_walk : float
export var speed_run : float

var rank_hp_max = 0
var rank_hp_regen = 0
var rank_mana_max = 0
var rank_mana_regen = 0
var rank_stamina_max = 0
var rank_stamina_regen = 0
var rank_speed_walk = 0
var rank_speed_run = 0

func connectSignals():
	MySignals.connect("use_attribute_point", self, "_rankUpAttribute")

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
		
func regenerate(delta, inCombat):
	gainMana(mana_regen * delta)
	if(!inCombat):
		HealDamage(hp_regen * delta)
		gainStamina(stamina_regen*delta)
	
func getAllAttributes():
	var attributeMap = {
		constants.Attributes.HP_MAX : hp_max,
		constants.Attributes.HP_REGEN : hp_regen,
		constants.Attributes.MANA_MAX : mana_max,
		constants.Attributes.MANA_REGEN : mana_regen,
		constants.Attributes.STAMINA_MAX : stamina_max,
		constants.Attributes.STAMINA_REGEN : stamina_regen,
		constants.Attributes.SPEED_WALK : speed_walk,
		constants.Attributes.SPEED_RUN : speed_run
	}
	return attributeMap
	
func getAllAttributeRanks():
	var attributeMap = {
		constants.Attributes.HP_MAX : rank_hp_max,
		constants.Attributes.HP_REGEN : rank_hp_regen,
		constants.Attributes.MANA_MAX : rank_mana_max,
		constants.Attributes.MANA_REGEN : rank_mana_regen,
		constants.Attributes.STAMINA_MAX : rank_stamina_max,
		constants.Attributes.STAMINA_REGEN : rank_stamina_regen,
		constants.Attributes.SPEED_WALK : rank_speed_walk,
		constants.Attributes.SPEED_RUN : rank_speed_run
	}
	return attributeMap
	
func _rankUpAttribute(attribute):
	if(attribute_points > 0):
		attribute_points-= 1
	else:
		print("Tried to rank up an attribute without having attribute points :S")
		return
	
	print("OK")
	
	if(attribute == constants.Attributes.HP_MAX):
		rank_hp_max+=1
		hp_max = constants.getAttributeValue(constants.Attributes.HP_MAX, rank_hp_max)
	if(attribute == constants.Attributes.HP_REGEN):
		rank_hp_regen+=1
		hp_regen = constants.getAttributeValue(constants.Attributes.HP_REGEN, rank_hp_regen)
	if(attribute == constants.Attributes.MANA_MAX):
		rank_mana_max+=1
		mana_max = constants.getAttributeValue(constants.Attributes.MANA_MAX, rank_mana_max)
	if(attribute == constants.Attributes.MANA_REGEN):
		rank_mana_regen+=1
		mana_regen = constants.getAttributeValue(constants.Attributes.MANA_REGEN, rank_mana_regen)
	if(attribute == constants.Attributes.STAMINA_MAX):
		rank_stamina_max+=1
		stamina_max = constants.getAttributeValue(constants.Attributes.STAMINA_MAX, rank_stamina_max)
	if(attribute == constants.Attributes.STAMINA_REGEN):
		rank_stamina_regen+=1
		stamina_regen = constants.getAttributeValue(constants.Attributes.STAMINA_REGEN, rank_stamina_regen)
	if(attribute == constants.Attributes.SPEED_WALK):
		rank_speed_walk+=1
		speed_walk = constants.getAttributeValue(constants.Attributes.SPEED_WALK, rank_speed_walk)
	if(attribute == constants.Attributes.SPEED_RUN):
		rank_speed_run+=1
		speed_run = constants.getAttributeValue(constants.Attributes.SPEED_RUN, rank_speed_run)
	
	MySignals.emit_signal("attributes_changed", self)