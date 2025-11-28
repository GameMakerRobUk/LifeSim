function Cell(_xx, _yy, _tile) constructor{
	static count = 0;
	cell_x = _xx;
	cell_y = _yy;
	x = cell_x * CELL_SIZE;
	y = cell_y * CELL_SIZE;
	walkable = _tile == 0? true : false;
	
	neighbours = {
		nw : noone,
		n : noone,
		ne : noone,
		e : noone,
		se : noone,
		s : noone,
		sw : noone,
		w : noone,
	}
	
	name = "id_" + string(count);
	count ++;
}