class_name Player
extends CharacterBody2D

signal fire
signal destroyed
signal hp_changed(hp, delta)
signal equipped(weapon)
signal collected(stuff, amount)
signal shield_onoff(state)

@export var speed = 500
@export var hp = 5
@export var alive = false
@export var invincible = false
@export var shield = false
#@export var weapons : Array[PackedScene]
#@export var active_weapon

func _ready():
  remove_shield()
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

func level_weapon(level):
  var old_weapon = $weapons.get_children()[0]
  var new_weapon = settings.weapons[level-1].instantiate()
  unequip(old_weapon)
  equip(new_weapon)

func equip(weapon):
  weapon.active = true
  fire.connect(weapon._on_player_fire)
  if !$weapons.get_children().has(weapon):
    $weapons.add_child(weapon)
#  if !alive: return
#  weapon.equipped.emit()
#  equipped.emit(weapon.kind)

func unequip(weapon):
  fire.disconnect(weapon._on_player_fire)
  weapon.active = false
  $weapons.remove_child(weapon)
  weapon.queue_free()
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
  if !alive: return
  $collect.emitting = true
  $audio/collect.play()
  collected.emit(stuff, amount)

func put_shield():
  if !shield:
    shield = true
    shield_onoff.emit(shield)
  if !alive: return
  $audio/shieldup.play()
  $shield.visible = true
  $shield.set_deferred("monitoring", true)
  $shield/collider.set_deferred("disabled", false)
  $shield_timespan.stop()
  $shield_timespan.start()

func remove_shield():
  if shield:
    shield = false
    shield_onoff.emit(shield)
    $anime.play("damage")
  if !alive: return
  $audio/shielddown.play()
  $shield.visible = false
  $shield.set_deferred("monitoring", false)
  $shield/collider.set_deferred("disabled", true)
  $shield_timespan.stop()


func _on_shield_timeout():
  remove_shield()
