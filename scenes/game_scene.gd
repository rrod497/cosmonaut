extends Node2D

@onready var fuelbar = $HUD_Elements/FuelDisplay/fuel_progress
@onready var hpbar = $HUD_Elements/HPDisplay/hp_bar
@onready var bronze = $HUD_Elements/StorageDisplay/Slot1Shadow/amount
@onready var silver = $HUD_Elements/StorageDisplay/Slot2Shadow/amount
@onready var gold = $HUD_Elements/StorageDisplay/Slot3Shadow/amount
@onready var shield = $HUD_Elements/HPDisplay/shield
@onready var weapon_slider = $HUD_Elements/WeaponDisplay/Slider

func _on_action_scene_player_hp_changed(hp):
  var hpslots = hpbar.get_children()
  for i in hpslots.size():
    var hpslot = hpslots[i]
    if int(hpslot.name.substr(2)) <= hp:
      hpslot.visible = true
    else:
      hpslot.visible = false

func _on_action_scene_equip_changed(level):
  var x = weapon_slider.position.y
  weapon_slider.position.y = 248 - 48*(level - 1)

func _on_action_scene_fuel_changed(remaining):
  fuelbar.value = remaining

func _on_action_scene_minerals_changed(kind, amount):
  match kind:
    Mineral.Kind.Bronze: bronze.text = str(amount)
    Mineral.Kind.Silver: silver.text = str(amount)
    Mineral.Kind.Gold: gold.text = str(amount)

func _on_action_scene_shield_changed(state):
  shield.visible = state

func _on_newgame_pressed():
  $HUD_Elements/HUD_gamestate/newgame.visible = false
  $HUD_BG/BG_SceneDisplay/action_scene.start()

func _on_action_scene_gameover():
  $HUD_Elements/HUD_gamestate/gameover.visible = true
  await get_tree().create_timer(3000).timeout
  $HUD_Elements/HUD_gamestate/gameover.visible = false
  $HUD_Elements/HUD_gamestate/newgame.visible = true
