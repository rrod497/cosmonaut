extends Node2D

@onready var fuelbar = $HUD_Elements/FuelDisplay/fuel_progress
@onready var hpbar = $HUD_Elements/HPDisplay/hp_bar
@onready var bronze = $HUD_Elements/StorageDisplay/Slot1Shadow/amount
@onready var silver = $HUD_Elements/StorageDisplay/Slot2Shadow/amount
@onready var gold = $HUD_Elements/StorageDisplay/Slot3Shadow/amount

func _on_action_scene_player_hp_changed(hp):
  var hpslots = hpbar.get_children()
  for i in hpslots.size():
    var hpslot = hpslots[i]
    if int(hpslot.name.substr(2)) <= hp:
      hpslot.visible = true
    else:
      hpslot.visible = false

func _on_action_scene_equip_changed(kind):
  print("equip changed " + kind)

func _on_action_scene_fuel_changed(remaining):
  fuelbar.value = remaining

func _on_action_scene_minerals_changed(kind, amount):
  match kind:
    Mineral.Kind.Bronze: bronze.text = str(amount)
    Mineral.Kind.Silver: silver.text = str(amount)
    Mineral.Kind.Gold: gold.text = str(amount)
