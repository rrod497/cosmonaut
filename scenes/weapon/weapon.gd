class_name Weapon
extends Node2D

@export var kind : String
@export var projectile : PackedScene
@export var active = false

func shoot():
  for muzzle in $muzzles.get_children():
    fire(muzzle)

func fire(muzzle):
  var bullet = projectile.instantiate()
  game_state.action.add_child(bullet)
  bullet.start(muzzle.global_position, muzzle.dir)

func _on_player_fire():
  if !active: return
  shoot()

func _on_player_equipped():
  active = true

func _on_player_unequipped():
  active = false
