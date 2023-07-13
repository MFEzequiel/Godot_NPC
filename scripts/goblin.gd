extends KinematicBody2D

class_name Enemy

export (int) var speed = 30
export (int) var speed_max = 45
export (float) var gravity = 2500
export (float) var time = 3.0
export (bool) var move
export (int) var hp = 3

var dir = Vector2()
var state

onready var spr = $spr
onready var anim = $state
onready var detect = $detect
onready var col_attack = $enemy_sworld/col
onready var player = get_node("//root/world/player")


func _ready():
	state = anim["parameters/playback"]
	state.travel("idle_right")
	#spr.scale.x *= -1
	move = true
	trye_move()


func _physics_process(delta):
	
	$hp.value = hp
	
	if dir.length() > 0:
		dir = dir.normalized() * speed
	
	dead()
	_player_detect()
	
	dir.y += gravity * delta
	dir = move_and_slide(dir)


func _player_detect():
	if detect.is_colliding():
		print("player")
		move = false
		var dir_player = global_position.direction_to(player.position - position)
	else:
		move = true


# void
func trye_move() -> void:
	if move:
		if(rand_range(0,1.1) <0.8):
			_move()
		yield(get_tree().create_timer(time), "timeout")
		trye_move()


func _move():
	match(randi() % 3):
		0:
			state.travel("idle")
			dir = Vector2.ZERO
		1:
			state.travel("run")
			detect.cast_to.x = 100
			if spr.scale.x < 0:
				spr.scale.x *= -1
			if col_attack.scale.x < 0:
				col_attack.scale.x *= -1
			dir.x = speed
		2:
			state.travel("run")
			detect.cast_to.x = -100
			if spr.scale.x > 0:
				spr.scale.x *= -1
			if col_attack.scale.x > 0:
				col_attack.scale.x *= -1
			dir.x -= speed
	state.set("parameters/Flip", spr.scale.x < 0)


func _hurt_box_entered(area):
	if area.name == "player_sword":
		hp -= 10


func dead():
	if hp == 0:
		hide()
		col_attack.set_deferred("disabled", true)
		$col.set_deferred("disabled", true)
		$hurt_box/col.set_deferred("disabled", true)
