function create_nodes(_map_id){
	for (var yy = 0; yy < global.cells_v; yy++) {
	    global.nav[yy] = []; 
	    for (var xx = 0; xx < global.cells_h; xx++) {
			var _tile = tilemap_get(_map_id, xx, yy);
	        global.nav[yy][xx] = new Cell(xx, yy, _tile);
	    }
	}
}