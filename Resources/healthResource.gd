extends Resource

export var MaxHealth = 100
var Health = MaxHealth

func TakeDamage(amount):
	if(amount < 0): print("Negative damage!"); return;
	var math = Health - amount
	if math > 0: Health = math
	else: Health = 0

func HealDamage(amount):
	if(amount < 0): print("Negative heal!"); return;
	var math = Health + amount
	if math < MaxHealth: Health = math
	else: Health = MaxHealth