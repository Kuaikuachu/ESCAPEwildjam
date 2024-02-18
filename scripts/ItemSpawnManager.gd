extends Node3D

var first_time = true

@onready var large_locations = $"../ItemSpawnLocations/Large"
@onready var small_locations = $"../ItemSpawnLocations/Small"

var large_array
var small_array

@export var do_item_spawn : bool = true

var food_min : int = 7

var guaranteed_amount_big : int = 7
var guaranteed_amount_small : int = 13
var guaranteed_uncommons_big : int = 1
var guaranteed_uncommons_small : int = 2

var food_min_idx
var guaranteed_amount_big_idx
var guaranteed_amount_small_idx
var guaranteed_uncommons_big_idx
var guaranteed_uncommons_small_idx

var extra_common_chance : float = 0.8 # 30%

var item_spawn_chance : float = 0.01 # 1%

@export var foods : Array[PackedScene]
@export var uncommons_big : Array[PackedScene]
@export var commons_big : Array[PackedScene]
@export var uncommons_small : Array[PackedScene]
@export var commons_small : Array[PackedScene]

var SpawnLocationsLarge : Array
var SpawnLocationsSmall : Array

# counting spawned items
var rares_spawned : int = 0
var uncommons_spawned : int = 0
var commons_spawned : int = 0

var total_weight : int = 0
var total_value : int = 0

func initialize_spawning():
	if first_time:
		first_time = false
		food_min_idx = food_min
		guaranteed_amount_big_idx = guaranteed_amount_big
		guaranteed_amount_small_idx = guaranteed_amount_small
		guaranteed_uncommons_big_idx = guaranteed_uncommons_big
		guaranteed_uncommons_small_idx = guaranteed_uncommons_small
	else:
		food_min = food_min_idx 
		guaranteed_amount_big = guaranteed_amount_big_idx
		guaranteed_amount_small = guaranteed_amount_small_idx
		guaranteed_uncommons_big = guaranteed_uncommons_big_idx
		guaranteed_uncommons_small = guaranteed_uncommons_small_idx
	
	randomize()
	if not do_item_spawn:
		return
	
	SpawnLocationsLarge.clear()
	SpawnLocationsSmall.clear()
	
	large_array = large_locations.get_children()
	small_array = small_locations.get_children()
	large_array.shuffle()
	small_array.shuffle()
	
	spawn_and_stuff()

func spawn_and_stuff():
	randomize()
	# WRITE POSITIONS INTO AN ARRAY
	for node in large_array:
		if randf() < item_spawn_chance or guaranteed_amount_big > 0:
			guaranteed_amount_big -= 1
			SpawnLocationsLarge.append(node.global_position)
	for node in small_array:
		if randf() < item_spawn_chance or guaranteed_amount_small > 0:
			guaranteed_amount_small -= 1
			SpawnLocationsSmall.append(node.global_position)
	
	SpawnLocationsLarge.shuffle()
	SpawnLocationsSmall.shuffle()
	# GET ITEM SCENE ARRAY SIZES
	var food_size = foods.size()
	
	var uncommon_size_big = uncommons_big.size()
	var common_size_big = commons_big.size()
	
	var uncommon_size_small = uncommons_small.size()
	var common_size_small = commons_small.size()
	
	# SPAWN COLLECTIBLES IN POSITIONS
	# LARGE
	for pos in SpawnLocationsLarge:
		var random = randf()
		if guaranteed_uncommons_big > 0:
			guaranteed_uncommons_big -= 1
			spawn_item(uncommons_big[randi() % uncommon_size_big], pos)
			uncommons_spawned += 1
			continue
		if random < extra_common_chance:
			spawn_item(commons_big[randi() % common_size_big], pos)
			commons_spawned += 1
		else:
			spawn_item(uncommons_big[randi() % uncommon_size_big], pos)
			uncommons_spawned += 1
	
	for pos in SpawnLocationsSmall:
		# RARE GUARANT
		if guaranteed_uncommons_small > 0:
			guaranteed_uncommons_small -= 1
			spawn_item(uncommons_small[randi() % uncommon_size_small], pos)
			uncommons_spawned += 1
			continue
		if food_min > 0:
			food_min -= 1
			spawn_item(foods[randi() % food_size], pos)
			rares_spawned += 1
			continue
		var random = randf()
		if random < extra_common_chance:
			spawn_item(commons_small[randi() % common_size_small], pos)
			commons_spawned += 1
		else:
			spawn_item(uncommons_small[randi() % uncommon_size_small], pos)
			uncommons_spawned += 1
	if food_min > 0:
		spawn_and_stuff()
		return
	print("commons total: " + str(commons_spawned))
	print("uncommons total: " + str(uncommons_spawned))
	print("food total: " + str(rares_spawned))
	
	print("total weight: " + str(total_weight))
	print("total value: " + str(total_value))

# INSTANTIATE AND POSITION FUNCTION
func spawn_item(scene, pos):
	var item = scene.instantiate()
	item.self_destruct = false
	item.rotation.y = deg_to_rad(randf_range(0,360))
	add_child(item)
	item.global_position = pos
	item.scale = Vector3(0.3,0.3,0.3)
	# add total value and weight
	total_weight += item.object_weight
	total_value += item.object_value
