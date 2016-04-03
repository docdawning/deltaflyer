// Carriage for 1515 aluminum extrusion and Graber wheels.
// 
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

// Note: assumes a layer height of 0.2mm.

$fn = 90;

// All measurements in mm.
smidge              = 0.1;
m3Radius            = (3.0 + 0.2) / 2;
m3LooseRadius		= m3Radius + 0.2;
m3HeadHeight        = 3.0;
m3LooseHeadRadius   = (5.4 + 0.6) / 2;
m3NutRadius         = (6.25 + 0.75) / 2;
m3NutHeight         = 4.0;
bodyWidth           = 38.0; // Along X axis.
bodyHeight          = 12.0; // Along Z axis.
straightBodyLength  = 36.0;
curvedBodyRadius    = bodyWidth/2;
bodyLength          = straightBodyLength + curvedBodyRadius; // Along Y axis.
centerYOffset       = bodyLength/2 - curvedBodyRadius;
rollerXOffset       = 14.0;
rollerYOffset       = 18.0;
rollerYCenter       = centerYOffset + 5.0;
hiwinYOffset		= 10.0;
hiwinGridSpacing	= 20.0;
tighteningGap		= 2.0;


module body()
{
	difference()
	{
		// The basic shield-shaped body.
		union()
		{
			translate([0, straightBodyLength/2, bodyHeight/2])
			roundedBox([bodyWidth, straightBodyLength, bodyHeight], 5, true);
			translate([-bodyWidth/2, 0, 0])
			cube([bodyWidth, straightBodyLength/2, bodyHeight]);
			cylinder(r=curvedBodyRadius, h=bodyHeight);
		}

		// Cut out the center shield.
		translate([0, 5, -smidge/2])
		union()
		{
			// Take out half of an ellipse.
			intersection()
			{
				translate([-curvedBodyRadius/2, -curvedBodyRadius, 0])
				cube([curvedBodyRadius,
					  curvedBodyRadius,
					  bodyHeight+smidge]);
				scale([0.5, 1, 1])
				cylinder(r=curvedBodyRadius, h=bodyHeight+smidge);
			}

			// Take out a round cornered rectangle.
			translate([0, straightBodyLength/4-5, (bodyHeight+smidge)/2])
			roundedBox([bodyWidth/2,
						-5+straightBodyLength/2,
						bodyHeight+smidge],
					   2.5, true);
		
			// Take out the upper left hand corner, for tightening.
			translate([-bodyWidth/4, -10+straightBodyLength/2, 0])
			cube([2.5, 2.5, bodyHeight+smidge]);
		}

		// Three holes for the M3x25 SHCS for the axles for the rollers.
		translate([rollerXOffset, rollerYCenter+rollerYOffset, -smidge/2])
		m3x25(bodyHeight+smidge, 2);
		
		translate([-rollerXOffset, rollerYCenter, -smidge/2])
		m3x25(bodyHeight+smidge, 2);

		translate([rollerXOffset, rollerYCenter-rollerYOffset, -smidge/2])
		m3x25(bodyHeight+smidge, 2);

		// Three holes for M3 SHCS in a 20x20 grid to match
		// HIWIN rails.
		// upper left
		translate([-hiwinGridSpacing/2,
				   centerYOffset+hiwinYOffset+hiwinGridSpacing/2,
				   -smidge/2])
		underM3x25(bodyHeight+smidge);

		// upper right
		translate([hiwinGridSpacing/2,
				   centerYOffset+hiwinYOffset+hiwinGridSpacing/2,
				   -smidge/2])
		underM3x25(bodyHeight+smidge);

		// lower right
		translate([hiwinGridSpacing/2,
				   centerYOffset+hiwinYOffset-hiwinGridSpacing/2,
				   -smidge/2])
		underM3x25(bodyHeight+smidge);

		// Cut out the L-shaped tighteningGap in the top.
		translate([-bodyWidth/4, 15-smidge/2, -smidge/2])
		{
			cube([tighteningGap, 8+smidge, bodyHeight+smidge]);
			translate([-bodyWidth/4-smidge, 8, 0])
			cube([bodyWidth/4+tighteningGap+smidge, tighteningGap/2, bodyHeight+smidge]);
		}
		
		// A horizontal M3x35 SHCS and nyloc nut trap for tightening.
		translate([-(bodyWidth+smidge)/2, 18.75, bodyHeight/2])
		rotate([0, 90, 0])
		union()
		{
			cylinder(r=m3LooseRadius, h=bodyWidth+smidge);
			cylinder(r=m3LooseHeadRadius, h=m3HeadHeight);
			translate([0, 0, bodyWidth+smidge-m3NutHeight])
			cylinder(r=m3NutRadius, h=m3NutHeight, $fn=6);
		}
	}

	difference()
	{
		// Reinforce the area around the third HIWIN M3 hole.
		translate([hiwinGridSpacing/2,
				   centerYOffset+hiwinYOffset-hiwinGridSpacing/2,
				   0])
		cylinder(r=4.5, h=bodyHeight);

		translate([hiwinGridSpacing/2,
				   centerYOffset+hiwinYOffset-hiwinGridSpacing/2,
				   -smidge/2])
		underM3x25(bodyHeight+smidge);
	}
}


module m3x25(h, countersunkHead=0)
{
	cylinder(r=m3LooseRadius, h=h);
	translate([0, 0, h - m3HeadHeight - countersunkHead])
	cylinder(r=m3LooseHeadRadius, h=m3HeadHeight + countersunkHead);
}


module underM3x25(h)
{
	// This is an M3 screw hole, with room for a nyloc nut on the bottom.
	cylinder(r=m3LooseRadius, h=h);
	cylinder(r=m3NutRadius, h=m3NutHeight, $fn=6);
}


// size is a vector [x, y, z], always draws from center!
module roundedBox(size, radius, sidesonly)
{
	rot = [ [0,0,0], [90,0,90], [90,90,0] ];
   	if (sidesonly)
	{
   		cube(size - [2*radius,0,0], true);
      	cube(size - [0,2*radius,0], true);
      	for (x = [radius-size[0]/2, -radius+size[0]/2],
      		  y = [radius-size[1]/2, -radius+size[1]/2])
		{
      		translate([x,y,0])
				cylinder(r=radius, h=size[2], center=true);
      }
   }
	else
	{
   		cube([size[0], size[1]-radius*2, size[2]-radius*2], 
			  center=true);
      cube([size[0]-radius*2, size[1], size[2]-radius*2],
			  center=true);
      cube([size[0]-radius*2, size[1]-radius*2, size[2]],
			  center=true);

      for (axis = [0:2])
		{
      		for (x = [radius-size[axis]/2, -radius+size[axis]/2],
              y = [radius-size[(axis+1)%3]/2, 
						-radius+size[(axis+1)%3]/2])
			{
         		rotate(rot[axis]) 
					translate([x,y,0]) 
                	cylinder(h=size[(axis+2)%3]-2*radius, 
								   r=radius, center=true);
			}
		}
   		for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2],
           z = [radius-size[2]/2, -radius+size[2]/2])
		{
      		translate([x,y,z]) sphere(radius);
      }
	}
}


body();


