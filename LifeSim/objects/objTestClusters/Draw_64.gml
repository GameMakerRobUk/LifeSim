draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (cluster == noone) exit;

draw_text(0, 0, cluster.id + "\n" + 
				"cluster.level: " + string(cluster.level) + "\n" + 
				"cluster.cell_x: " + string(cluster.level_cell_x) + "\n" + 
				"cluster.cell_y: " + string(cluster.level_cell_y))