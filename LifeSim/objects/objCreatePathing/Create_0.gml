#macro CELL_SIZE 16

global.cluster_sizes = [4, 8, 16, 32];
#macro TOTAL_CLUSTER_LEVELS array_length(global.cluster_sizes)

/*
	cluster widths/heights : 
	[0] = 8 x 16
	[1] = 8 x 16 x 4
	[2] = 8 x 16 x 4 x 4
	[3] = 8 x 16 x 4 x 4
	
*/

global.nav = [];
global.cells_h = 100;
global.cells_v = 100;

// -------------------------
// CREATE ALL CELLS
// -------------------------

var _lay_id = layer_get_id("Collision");
collision_map_id = layer_tilemap_get_id(_lay_id);

create_nodes(collision_map_id);
set_neighbours();

// -------------------------
// CREATE CLUSTER LEVELS
// -------------------------
global.clusters = [];


alarm[0] = 60;
level_display_index = 0;