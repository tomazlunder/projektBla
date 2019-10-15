extends Node

var maxPlayers = 4

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
