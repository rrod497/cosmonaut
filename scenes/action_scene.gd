class_name ActionScene
extends Node2D

signal player_hp_changed(hp)
signal fuel_changed(remaining)
signal minerals_changed(kind, amount)
signal equip_changed(kind)

@export var asteroids : Array[PackedScene]
var _running = false
var time = 60
#var minerals =

@onready var top = $visible/bounds/top.shape.a.y
@onready var bottom = $visible/bounds/bottom.shape.a.y
@onready var left = $visible/bounds/top.shape.a.x
@onready var right = $visible/bounds/top.shape.b.x

func _ready():
  game_state.player = $player
  game_state.action = self
  _running = true

func _on_asteroid_spawn_timeout():
  var asteroid = settings.get_asteroids().pick_random().instantiate()
  add_child(asteroid)
  asteroid.position.y = top - 100
  asteroid.position.x = randf_range(left, right)
  asteroid.rotation = rotation
  asteroid.direction = Vector2(randf_range(-0.5, 0.5), 1)
#  $player.collect()

func _on_player_hp_changed(hp, delta):
  player_hp_changed.emit(hp)

func _on_clock_timeout():
  if !_running: return
  time -= 1
  fuel_changed.emit(time)

func _on_player_collected(stuff, amount = 1):
  if stuff is Mineral:
    var mineral = stuff as Mineral
    game_state.minerals[mineral.kind] += amount
    minerals_changed.emit(mineral.kind, game_state.minerals[mineral.kind])
  elif stuff is Equip:
    var equip = stuff as Equip
    if equip.kind == "weapon":
#      game_state.weapons += equip.content
      equip_changed.emit(equip.kind)

func _on_visible_area_exited(area):
  if area.is_in_group("asteroids"):
    if area.position.x < left:
      area.position.x = right + 40
    elif area.position.x > right:
      area.position.x = left - 40
    if area.position.y < bottom:
      return
    else:
      pass
  await get_tree().create_timer(1000).timeout
  area.queue_free()