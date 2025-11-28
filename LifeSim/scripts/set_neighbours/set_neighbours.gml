function set_neighbours(){
    // Define relative offsets for all 8 directions: [dx, dy]
    var _directions = [
        [-1, -1], [ 0, -1], [ 1, -1], // NW, N, NE
        [-1,  0],          [ 1,  0], // W, E
        [-1,  1], [ 0,  1], [ 1,  1]  // SW, S, SE
    ];
    
    // Define corresponding keys for the 'neighbours' struct in the Cell object
    var _keys = [
        "nw", "n", "ne",
        "w", "e",
        "sw", "s", "se"
    ];

    for (var yy = 0; yy < global.cells_v; yy++) {
        for (var xx = 0; xx < global.cells_h; xx++) {
            var _cell = global.nav[yy][xx];
            
            // Only set neighbours for walkable cells (optional but efficient)
            if (!_cell.walkable) continue; 
            
            var _neighbours_struct = _cell.neighbours;
            
            // Loop through all 8 directions
            for (var i = 0; i < array_length(_directions); i++) {
                var _dx = _directions[i][0];
                var _dy = _directions[i][1];
                var _nx = xx + _dx;
                var _ny = yy + _dy;
                var _key = _keys[i];
                
                // Check if the potential neighbor coordinates are within the grid bounds
                if (_nx >= 0 && _nx < global.cells_h && _ny >= 0 && _ny < global.cells_v) {
                    var _neighbour_cell = global.nav[_ny][_nx];
                    
                    // Check if the neighbor cell itself is walkable
                    if (_neighbour_cell.walkable) {
                        _neighbours_struct[$ _key] = _neighbour_cell;
                    }
                }
            }
        }
    }
}
