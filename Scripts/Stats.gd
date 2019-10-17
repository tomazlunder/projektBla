extends Node

var level = 0
var experience = 0
var attribute_points = 10

var hp_max : float 
var hp_regen : float
var hp : float

var mana_max : float
var mana_regen : float
var mana : float

var stamina_max : float
var stamina_regen : float
var stamina : float

var speed_walk : float
var speed_run : float

var rank_hp_max = 0
var rank_hp_regen = 0
var rank_mana_max = 0
var rank_mana_regen = 0
var rank_stamina_max = 0
var rank_stamina_regen = 0
var rank_speed_walk = 0
var rank_speed_run = 0

func _ready():
	hp_max = constants.getAttributeValue(constants.Attributes.HP_MAX,rank_hp_max)
	hp_regen = constants.getAttributeValue(constants.Attributes.HP_REGEN,rank_hp_regen)
	mana_max = constants.getAttributeValue(constants.Attributes.MANA_MAX,rank_mana_max)
	mana_regen = constants.getAttributeValue(constants.Attributes.MANA_REGEN,rank_mana_regen)
	stamina_max = constants.getAttributeValue(constants.Attributes.STAMINA_MAX,rank_stamina_max)
	stamina_regen = constants.getAttributeValue(constants.Attributes.STAMINA_REGEN,rank_stamina_regen)
	speed_walk = constants.getAttributeValue(constants.Attributes.SPEED_WALK,rank_speed_walk)
	speed_run = constants.getAttributeValue(constants.Attributes.SPEED_RUN,rank_speed_run)
	
	hp = hp_max
	mana = mana_max
	stamina = stamina_max
	
puppet func updatePuppetResources(newHp, newMana, newStamina):
	hp = newHp
	mana = newMana
	stamina = newStamina

func connectSignals():
	#UI related
	MySignals.connect("use_attribute_point", self, "_rankUpAttribute")
	
	#Network related
	MySignals.connect("deal_damage_signal", self, "TakeDamage")

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
		MySignals.emit_signal("player_dead")
	
	MySignals.emit_signal("hp_changed", hp)
	MySignals.emit_signal("damage_taken", amount)

func HealDamage(amount):
	if(amount < 0): 
		print("Negative heal!")
		return
	var math = hp + amount
	if math < hp_max: 
		hp = math
	else: 
		hp = hp_max
		
	MySignals.emit_signal("hp_changed", hp)
	
func useMana(amount):
	if(amount < 0): 
		print("Negative mana use!")
		return
	var math = mana - amount
	if math > 0:
		mana = math
		MySignals.emit_signal("mana_changed", mana)
		return true
	else:
		mana = 0
		MySignals.emit_signal("mana_changed", mana)
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
	
	MySignals.emit_signal("mana_changed", mana)
		
func useStamina(amount):
	if(amount < 0): 
		print("Negative mana use!")
		return
	var math = stamina - amount
	if math > 0:
		stamina = math
		MySignals.emit_signal("stamina_changed", stamina)
		return true
	else:
		stamina = 0
		MySignals.emit_signal("stamina_changed", stamina)
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
		
	MySignals.emit_signal("stamina_changed", stamina)
		
func regenerate(delta, doHealth, doStamina):
	gainMana(mana_regen * delta)
	if(doHealth):
		HealDamage(hp_regen * delta)
	if(doStamina):
		gainStamina(stamina_regen*delta)
		
	rpc("updatePuppetResources", hp, mana, stamina)
	
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
	
	print("Leveled up attribute ("+constants.AttributeNames[attribute]+")")
	
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
