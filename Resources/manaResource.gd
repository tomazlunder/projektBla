extends Resource

var maxMana
var mana

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
	if math < maxMana:
		mana = math
	else:
		mana = maxMana