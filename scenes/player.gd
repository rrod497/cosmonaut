class_name Player
extends CharacterBody2D

signal fire
signal destroyed
signal hp_changed(hp, delta)
signal equipped(weapon)
signal collected(stuff, amount)

@export var speed = 500
@export var hp = 5
@export var alive = true
@export var invincible = false
#@export var weapons : Array[PackedScene]
#@export var active_weapon

func _ready():
  var weapons = $weapons.get_children()
  for weapon in weapons:
#    acquire(weapon)
    equip(weapon)
  #  if !game_state.active_weapon:
#    weapons[0]

func _input(event):
  if !alive: return
  if event.is_action_pressed("fire"):
    fire.emit()

func _process(delta):
  if !alive: return
  var dir = Input.get_vector("left", "right", "forward", "backward")
  velocity = dir * speed
  move_and_slide()
#  for i in get_slide_collision_count():
#    var collision = get_slide_collision(i)

func equip(weapon):
  fire.connect(weapon._on_player_fire)
  weapon.active = true
#  if !alive: return
#  weapon.equipped.emit()
#  equipped.emit(weapon.kind)

func unequip(weapon):
  fire.disconnect(weapon._on_player_fire)
  weapon.active = false
#  if !alive: return
#  weapon.unequipped.emit()
#  equipped.emit(weapon.kind)

func destroy():
  if !alive: return
  alive = false
  destroyed.emit()
  set_deferred("monitoring", false)
  $collider.set_deferred("disabled", true)
  $anime.play("destroy")
  await $anime.animation_finished
  queue_free()

func damage(points):
  if !alive: return
  if invincible: return
  var pts = min(hp, points)
  hp -= pts
  hp_changed.emit(hp, pts)
  if hp > 0:
    $anime.play("damage")
  else:
    destroy()

func collect(stuff, amount):
  $collect.emitting = true
  collected.emit(stuff, amount)
