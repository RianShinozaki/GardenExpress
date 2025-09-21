class_name MonumentData
extends Resource

enum MONUMENT_TYPE {BLUEFLOWER, ORANGEFLOWER, FOUNTAIN, PAVILION, TREE, STATUE}

@export var texture: Texture2D
@export var monument_type: MONUMENT_TYPE
@export var radius: int
