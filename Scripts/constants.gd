extends Node

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

func getAttributeValue(attribute, rank):
	if(attribute == Attributes.HP_MAX):
		return 100 + rank * 10
	if(attribute == Attributes.HP_REGEN):
		return 1 + 0.3 * rank
	if(attribute == Attributes.MANA_MAX):
		return 100 + 10 * rank
	if(attribute == Attributes.MANA_REGEN):
		return 1 + 0.3 * rank
	if(attribute == Attributes.STAMINA_MAX):
		return 100 + 10 * rank
	if(attribute == Attributes.STAMINA_REGEN):
		return 10 + 1 * rank
	if(attribute == Attributes.SPEED_WALK):
		return 100 + 5 * rank
	if(attribute == Attributes.SPEED_RUN):
		return 200 + 5 * rank