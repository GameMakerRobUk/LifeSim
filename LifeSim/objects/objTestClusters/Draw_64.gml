draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (cluster == noone) exit;
draw_text(0, 0, "id: " + cluster.id + "\n" + 
"level: " + string(cluster.level) + "\ncell_x: " + string(cluster.cell_x) + "\ncell_y: " + string(cluster.cell_y))