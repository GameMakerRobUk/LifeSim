// A* Heuristic: Manhattan Distance (for grid movement)
function heuristic(_cell, _end_x, _end_y) {
	if (_cell == noone || _cell == undefined){
		show_debug_message("heuristic cell is undefined")	
	}

    return abs(_cell.cell_x - _end_x) + abs(_cell.cell_y - _end_y);
}

function heuristic_cluster(_cluster, _goal_cluster) {
    if (_cluster == noone || _cluster == undefined) {
        show_debug_message("heuristic_cluster: cluster undefined");
        return 999999; // fail-safe
    }

    return abs(_cluster.cell_x - _goal_cluster.cell_x)
         + abs(_cluster.cell_y - _goal_cluster.cell_y);
}

function find_path(_start_x, _start_y, _end_x, _end_y){
	
	var _keys = [
        "nw", "n", "ne",
        "w", "e",
        "sw", "s", "se"
    ];

    // 1. Input Validation and Setup
    var _start_cell = global.nav[_start_y][_start_x];
    var _end_cell = global.nav[_end_y][_end_x];
	
    if (!_start_cell.walkable || !_end_cell.walkable) {
        return []; // Return empty path if start or end is blocked
    }
    if (_start_cell == _end_cell) {
        return [{x: _end_x, y: _end_y}]; // Return just the end point if already there
    }

    // Use a DS priority queue (Min-Heap) for efficient open list management
    var _open_list = ds_priority_create();
    // Use a map to keep track of visited cells and their A* data
    var _cell_data = ds_map_create();
    
    // Initialize start node data (G-cost=0, F-cost=heuristic)
    var _start_data = {
        cell: _start_cell,
        g_cost: 0,
        f_cost: heuristic(_start_cell, _end_x, _end_y),
        parent: noone
    };
    
    ds_priority_add(_open_list, _start_cell, _start_data.f_cost);
    ds_map_add(_cell_data, _start_cell, _start_data);

    // 2. Main A* Loop
    while (!ds_priority_empty(_open_list)) {
        // Get the cell with the lowest F-cost from the priority queue
        var _current_cell = ds_priority_delete_min(_open_list);
        var _current_data = _cell_data[? _current_cell];

        // Check if we reached the destination
        if (_current_cell == _end_cell) {
            // Path found! Reconstruct it.
            var _path = [];
            var _curr = _current_data;
            while (_curr != noone) {
                // Prepend to the path array (GameMaker arrays grow efficiently)
                array_insert(_path, 0, {x: _curr.cell.cell_x, y: _curr.cell.cell_y});
                _curr = _curr.parent;
            }
            
            // Clean up data structures before returning the path
            ds_priority_destroy(_open_list);
            ds_map_destroy(_cell_data);
            return _path;
        }

        // 3. Explore Neighbors
        var _neighbours = _current_cell.neighbours;
        
        // Loop through the neighbour struct (which was populated by set_neighbours() earlier)
		for (var i = 0; i < array_length(_keys); i ++){
			var _key = _keys[i];
			var _neighbor_cell = _neighbours[$ _key];
			
			if (_neighbor_cell == noone || _neighbor_cell == undefined) continue;
			

            // Calculate G-cost: 1 for cardinal, approx 1.414 (sqrt(2)) for diagonal
            var _move_cost = (_key == "n" || _key == "s" || _key == "e" || _key == "w") ? 1 : 1.414;
            var _new_g_cost = _current_data.g_cost + _move_cost;

            // Check if this neighbor has already been visited or if this new path is better
            var _neighbor_data = _cell_data[? _neighbor_cell];
                
            if (is_undefined(_neighbor_data) || _new_g_cost < _neighbor_data.g_cost) {
                // This is a new path or a better path
                    
                if (is_undefined(_neighbor_data)) {
                        // Initialize data if new
                        _neighbor_data = {
	                        cell: _neighbor_cell,
	                        parent: noone
	                        };
                        ds_map_add(_cell_data, _neighbor_cell, _neighbor_data);
                }
                    
                _neighbor_data.g_cost = _new_g_cost;
                _neighbor_data.f_cost = _new_g_cost + heuristic(_neighbor_cell, _end_x, _end_y);
                _neighbor_data.parent = _current_data;

                // Add or update neighbor in the open list (priority queue handles updates internally)
                ds_priority_add(_open_list, _neighbor_cell, _neighbor_data.f_cost);
            }
        }
    }

    // 4. No Path Found (Open list is empty and goal was never reached)
    ds_priority_destroy(_open_list);
    ds_map_destroy(_cell_data);
    return [];
}