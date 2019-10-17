extends Node

signal exited_game()

signal attribute_panel_open(Stats)
signal use_attribute_point(Attribute)
signal attributes_changed(Stats)

signal hp_changed(newHp)
signal damage_taken(damage)
signal mana_changed(newMana)
signal stamina_changed(newStamina)
signal player_dead()

signal deal_damage_signal(damage)