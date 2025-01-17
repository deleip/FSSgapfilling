********************************************************************
************** AGGREGATING AREA FROM GRIDUNITS10 *******************
********************************************************************

$onlisting
$stars $$$$

*********** READ IN NECESSARY SETS *************
$include "./area/all_reg_to_define_mappings.txt"
$include "./area/all_reg.txt"
$include "./area/n0.txt"
$include "./area/n1_2.txt"
$include "./area/n2_3.txt"
$include "./area/gridunits_10_n12.txt"
$include "./area/gridunits_20_n12.txt"
$include "./area/gridunits_60_n12.txt"
$include "./area/gridunits_10_n23.txt"

*mappings between different region levels
$include "./area/mappings_levelwise.txt"
$include "./area/mappings_gridunits_10_n23.txt"

*********** READ IN DATA **************
set type /total, nogo/;
table area_readin(gridunits_10_n23, type)
$ondelim
$include "./area/area_grid10n23.csv"
$offdelim


*********** INITALIZE PARAMETERS *************
parameter area_gridunits10_n23(gridunits_10_n23, type)
          area_gridunits10_n12(gridunits_10_n12, type)
          area_gridunits20_n12(gridunits_20_n12, type)
          area_gridunits60_n12(gridunits_60_n12, type)
          area_nuts1_2(n1_2, type)
          area_nuts2_3(n2_3, type)
          area_nuts0(n0, type)
          area(all_reg, type);



*********** FILL PARAMETERS ***********
area_gridunits10_n23(gridunits_10_n23, type) = area_readin(gridunits_10_n23, type);
area_gridunits10_n12(gridunits_10_n12, type) = sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), area_gridunits10_n23(gridunits_10_n23, type));
area_gridunits20_n12(gridunits_20_n12, type) = sum(gridunits_10_n12 $ mappings_levelwise(gridunits_20_n12, gridunits_10_n12), area_gridunits10_n12(gridunits_10_n12, type));
area_gridunits60_n12(gridunits_60_n12, type) = sum(gridunits_20_n12 $ mappings_levelwise(gridunits_60_n12, gridunits_20_n12), area_gridunits20_n12(gridunits_20_n12, type));
area_nuts1_2(n1_2, type) = sum(gridunits_60_n12 $ mappings_levelwise(n1_2, gridunits_60_n12), area_gridunits60_n12(gridunits_60_n12, type));
area_nuts0(n0, type) = sum(n1_2 $ mappings_levelwise(n0, n1_2), area_nuts1_2(n1_2, type));
area_nuts2_3(n2_3, type) = sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), area_gridunits10_n23(gridunits_10_n23, type));

area(gridunits_10_n23, type) = area_gridunits10_n23(gridunits_10_n23, type);
area(gridunits_10_n12, type) = area_gridunits10_n12(gridunits_10_n12, type);
area(gridunits_20_n12, type) = area_gridunits20_n12(gridunits_20_n12, type);
area(gridunits_60_n12, type) = area_gridunits60_n12(gridunits_60_n12, type);
area(n1_2, type) = area_nuts1_2(n1_2, type);
area(n0, type) = area_nuts0(n0, type);


set meta /"All areas are given in ha"/;

execute_unload "./area/area.gdx"       area_gridunits10_n23
                                       area_gridunits10_n12
                                       area_gridunits20_n12
                                       area_gridunits60_n12
                                       area_nuts2_3
                                       area_nuts1_2
                                       area_nuts0
                                       area
                                       meta;

