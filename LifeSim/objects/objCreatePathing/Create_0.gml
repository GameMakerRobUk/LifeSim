#macro CELL_SIZE 16

global.nav = [];
global.cells_h = ceil(room_width / CELL_SIZE);
global.cells_v = ceil(room_height / CELL_SIZE);

// -------------------------
// CREATE ALL CELLS
// -------------------------

var _lay_id = layer_get_id("Collision");
collision_map_id = layer_tilemap_get_id(_lay_id);

create_cells(collision_map_id);
set_neighbours();
create_clusters();