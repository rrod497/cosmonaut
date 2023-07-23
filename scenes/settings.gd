class_name Settings
extends Node

@export var asteroids_S: Array[PackedScene]
@export var asteroids_M: Array[PackedScene]
@export var asteroids_L: Array[PackedScene]
@export var asteroids_XL: Array[PackedScene]
@export var loot: Array[PackedScene]
@export var bronze: PackedScene
@export var silver: PackedScene
@export var gold: PackedScene
@export var weapons: Array[PackedScene]
@export var powerups: Array[PackedScene]



@onready var _ast_dict = {
  Asteroid.Size.S: asteroids_S,
  Asteroid.Size.M: asteroids_M,
  Asteroid.Size.L: asteroids_L,
  Asteroid.Size.XL: asteroids_XL,
}

func get_asteroids(size = null):
  var res = []
  for s in _ast_dict:
    if size == null or s < size:
      res += _ast_dict[s]
  return res

func get_loot(n):
  var res = []
  for i in n:
    var x = randf_range(0, 2000)
    if x < 10: res.append(gold)
    elif x < 50: res.append(silver)
    elif x < 610: res.append(bronze)
    elif x < 640: res.append(powerups[0])
    elif x < 670: res.append(powerups[1])
    elif x < 600: res.append(powerups[2])
  return res
