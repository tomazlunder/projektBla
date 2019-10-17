extends Node

#ATTRIBUTES
enum Attributes{
	HP_MAX,
	HP_REGEN,
	MANA_MAX,
	MANA_REGEN,
	STAMINA_MAX,
	STAMINA_REGEN,
	SPEED_WALK,
	SPEED_RUN
}

var AttributeNames = {
	Attributes.HP_MAX : "Maximum Health",
	Attributes.HP_REGEN : "Health Regeneration",
	Attributes.MANA_MAX : "Maximum Mana",
	Attributes.MANA_REGEN : "Mana Regeneration",
	Attributes.STAMINA_MAX : "Maximum Stamina",
	Attributes.STAMINA_REGEN : "Stamina Regeneration",
	Attributes.SPEED_WALK : "Walking Speed",
	Attributes.SPEED_RUN : "Running Speed"
}

var starting_HP_MAX = 100
var starting_HP_REGEN = 1
var starting_MANA_MAX = 100
var starting_MANA_REGEN = 1
var starting_STAMINA_MAX = 100
var starting_STAMINA_REGEN = 10
var starting_SPEED_WALK = 90
var starting_SPEED_RUN = 210

func getAttributeValue(attribute, rank):
	if(attribute == Attributes.HP_MAX):
		return starting_HP_MAX + rank * 10
	if(attribute == Attributes.HP_REGEN):
		return starting_HP_REGEN + 0.3 * rank
	if(attribute == Attributes.MANA_MAX):
		return starting_MANA_MAX + 10 * rank
	if(attribute == Attributes.MANA_REGEN):
		return starting_MANA_REGEN + 0.3 * rank
	if(attribute == Attributes.STAMINA_MAX):
		return starting_STAMINA_MAX + 10 * rank
	if(attribute == Attributes.STAMINA_REGEN):
		return starting_STAMINA_REGEN + 1 * rank
	if(attribute == Attributes.SPEED_WALK):
		return starting_SPEED_WALK + 5 * rank
	if(attribute == Attributes.SPEED_RUN):
		return starting_SPEED_RUN + 5 * rank
		
#SPELLS
enum Spells{
	FIREBALL,
	ICEWALL
}
