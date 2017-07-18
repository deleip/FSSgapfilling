************* filling data gaps in agricultural data *************

$onlisting
$stars $$$$


$include "C:\Users\Debbora\jrc\incl_d\croptypes.txt"

set hierarchy_0(croptypes) /AGRAREA/;
set hierarchy_1(croptypes) /'B_1','B_2','B_3', 'B_4'/;
set hierarchy_2(croptypes) /'B_1_1','B_1_2' ,'B_1_3' ,'B_1_4','B_1_5','B_1_6','B_1_7','B_1_8', 'B_1_9','B_1_10','B_1_11','B_1_12'
                            'B_3_1','B_3_2' ,'B_3_3'
                            'B_4_1','B_4_2' ,'B_4_3' ,'B_4_4','B_4_5','B_4_6','B_4_7'
                            'B_5_1','B_5_2','B_5_3'/;
set hierarchy_3(croptypes) /'B_1_1_1','B_1_1_2','B_1_1_3','B_1_1_4', 'B_1_1_5','B_1_1_6','B_1_1_7','B_1_1_99'
                            'B_1_2_1','B_1_2_2'
                            'B_1_6_1','B_1_6_2','B_1_6_3' ,'B_1_6_4' ,'B_1_6_5' ,'B_1_6_6', 'B_1_6_7','B_1_6_8','B_1_6_9' ,'B_1_6_10','B_1_6_11','B_1_6_12',  'B_1_6_99'
                            'B_1_7_1','B_1_7_2'
                            'B_1_8_1','B_1_8_2'
                            'B_1_9_1','B_1_9_2'
                            'B_1_12_1','B_1_12_2'
                            'B_4_1_1_1','B_4_1_1_2'
                            'B_4_3_1','B_4_3_2'
                            'B_4_4_1','B_4_4_2','B_4_4_3', 'B_4_4_4'/;
set hierarchy_4(croptypes) /'B_1_7_1_1','B_1_7_1_2'
                            'B_1_9_2_1','B_1_9_2_2','B_1_9_2_99'
                            'B_4_1_1_1','B_4_1_1_2'/;


set hierarchy_mappings(croptypes, croptypes) /
$include "C:\Users\Debbora\jrc\incl_d\crop_sets_d.txt"
/;

*regions
$include "C:\Users\Debbora\jrc\incl_d\all_reg.txt"
$include "C:\Users\Debbora\jrc\incl_d\n0.txt"
$include "C:\Users\Debbora\jrc\incl_d\n1_2.txt"
$include "C:\Users\Debbora\jrc\incl_d\n2_3.txt"
*mappings between different region levels
$include "C:\Users\Debbora\jrc\incl_d\nuts_mappings.txt"



*data on different scale: year 2010, unit ha
table       data_n0(n0, croptypes)
$ondelim
$include "C:\Users\Debbora\jrc\incl_d\nuts0_crops_d.csv"
$offdelim

table       data_n1_2(n1_2, croptypes)
$ondelim
$include "C:\Users\Debbora\jrc\incl_d\nuts1_2_crops_d.csv"
$offdelim

table       data_n2_3(n2_3, croptypes)
$ondelim
$include "C:\Users\Debbora\jrc\incl_d\nuts2_3_crops_d.csv"
$offdelim

************************
* for upper bounds it would be good to have area here, but area is all kaputt
************************

parameter p_data(all_reg, croptypes);
variable v_data(all_reg, croptypes);
v_data.fx(n0, croptypes) $ (data_n0(n0, croptypes) ne 0) = data_n0(n0, croptypes);
v_data.fx(n1_2, croptypes) $ (data_n1_2(n1_2, croptypes) ne 0) = data_n1_2(n1_2, croptypes);
v_data.fx(n2_3, croptypes) $ (data_n2_3(n2_3, croptypes) ne 0) = data_n2_3(n2_3, croptypes);
v_data.lo(all_reg, croptypes) $ (v_data.lo(all_reg, croptypes) = -inf) = 0;
* we believe, that on nuts0 level data is comlete, therefore zeros are "real" zeros and can be fixed
v_data.fx(n0, croptypes) = v_data.lo(n0, croptypes);
* same with "AGRAREA"
v_data.fx(all_reg, "AGRAREA") = v_data.lo(all_reg, "AGRAREA");



*first step: distribute AGRAREA (only element on hierarchy_0 level) on nuts1_2 and nuts2_3 level
*we asume, that regions with AGRAREA=0 aren't data gaps, but really have no AGRAREA (exclaves Cueta and Melila and cityregions in UK)
*therefore, we only need to scale existing data on nuts1_2 (nuts2_3) to fit the matching value on nuts0 (nuts1_2)

scalar agrarea_n0
       sum_agrarea_n12
       agrarea_n12
       sum_agrarea_n23;



loop(n0,
   agrarea_n0 = v_data.lo(n0, "AGRAREA");
   sum_agrarea_n12 = sum(n1_2 $ (nuts_mappings(n0, n1_2)), v_data.lo(n1_2, "AGRAREA"));
   loop(n1_2 $ ((nuts_mappings(n0, n1_2)) AND (agrarea_n0 ne 0)),
      v_data.fx(n1_2, "AGRAREA") $ (v_data.lo(n1_2, "AGRAREA") = v_data.up(n1_2, "AGRAREA")) = v_data.lo(n1_2, "AGRAREA") * (agrarea_n0/sum_agrarea_n12);
      agrarea_n12 = v_data.lo(n1_2, "AGRAREA");
      sum_agrarea_n23 = sum(n2_3 $ (nuts_mappings(n1_2, n2_3)), v_data.lo(n2_3, "AGRAREA"));
      loop(n2_3 $ ((nuts_mappings(n1_2, n2_3)) AND (agrarea_n12 ne 0)),
         v_data.fx(n2_3, "AGRAREA") $ (v_data.lo(n2_3, "AGRAREA") = v_data.up(n2_3, "AGRAREA")) = v_data.lo(n2_3, "AGRAREA") * (agrarea_n12/sum_agrarea_n23)
      );
   );
);


*second step: distribute all cropcategories over nuts0
*as data on nuts0 level is complete, we only have to fix rounding errors by scaling the data

scalar area_h0
       sum_area_h1
       area_h1
       sum_area_h2
       area_h2
       sum_area_h3
       area_h3
       sum_area_h4
       test;


loop(n0,
   area_h0 = v_data.lo(n0, "AGRAREA");
   sum_area_h1 = sum(hierarchy_1 $ hierarchy_mappings("AGRAREA", hierarchy_1), v_data.lo(n0, hierarchy_1));
   loop(hierarchy_1 $ hierarchy_mappings("AGRAREA", hierarchy_1),
      v_data.fx(n0, hierarchy_1) $ (v_data.lo(n0, hierarchy_1) ne 0) = v_data.lo(n0, hierarchy_1) * (area_h0/sum_area_h1);
      area_h1 = v_data.lo(n0, hierarchy_1);
      sum_area_h2 = sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), v_data.lo(n0, hierarchy_2));
      loop(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2),
         v_data.fx(n0, hierarchy_2) $ (v_data.lo(n0, hierarchy_2) ne 0) = v_data.lo(n0, hierarchy_2) * (area_h1/sum_area_h2);
         area_h2 = v_data.lo(n0, hierarchy_2);
         sum_area_h3 = sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), v_data.lo(n0, hierarchy_3));
         loop(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3),
            v_data.fx(n0, hierarchy_3) $ (v_data.lo(n0, hierarchy_3) ne 0) = v_data.lo(n0, hierarchy_3) * (area_h2/sum_area_h3);
            area_h3 = v_data.lo(n0, hierarchy_3);
            sum_area_h4 = sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), v_data.lo(n0, hierarchy_4));
            loop(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4),
               v_data.fx(n0, hierarchy_4) $ (v_data.lo(n0, hierarchy_4) ne 0) = v_data.lo(n0, hierarchy_4) * (area_h3/sum_area_h4);
            );
         );
      );
   );
);


** main step: filling data gaps on finer levels. for each combination (e.g. filling subcategories of b_1 for nuts1_2 in a specific country)
** we optimize, using values calculate using shares as starting values, and the coresponding values on the coarser level (e.g. b_1 and the country)
** as constraints

singleton set    super_region(all_reg)
                 super_cropcategory(croptypes);
set              sub_regions(all_reg)
                 sub_cropcategories(croptypes);

set info_for_batinclude /"n0", "n1_2", "h0", "h1", "h2", "h3"/;

scalar   needed_sum_row
         sum_row
         sum_for_shares;

scalar   std  /0.05/;
variable v_hpd;


equations zeilensummen(all_reg)
          spaltensummen(croptypes)
          opt_hpd;

zeilensummen(sub_regions) .. v_data(sub_regions, super_cropcategory) =e= sum(sub_cropcategories, v_data(sub_regions, sub_cropcategories));
spaltensummen(sub_cropcategories) .. v_data(super_region, sub_cropcategories) =e= sum(sub_regions, v_data(sub_regions, sub_cropcategories));
opt_hpd .. v_hpd =e= sum((sub_regions, sub_cropcategories),sqr((v_data(sub_regions, sub_cropcategories) - p_data(sub_regions, sub_cropcategories))
                                                                 /(std * p_data(sub_regions, sub_cropcategories))));

model tabloe /spaltensummen, zeilensummen, opt_hpd/;


execute_unload "C:\Users\Debbora\jrc\tests\data_a.gdx" v_data;

loop(n0,
   loop(hierarchy_0,
      if(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h0"
      );
   );
);

execute_unload "C:\Users\Debbora\jrc\tests\data_b.gdx" v_data;
$stop


loop(n0,
   loop(hierarchy_1,
      if(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h1"
      );
   );
);

loop(n0,
   loop(hierarchy_2,
      if(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h2"
      );
   );
);


loop(n0,
   loop(hierarchy_3,
      if(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h3"
      );
   );
);


loop(n1_2,
   loop(hierarchy_0,
      if(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h0"
      );
   );
);



loop(n1_2,
   loop(hierarchy_1,
      if(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h1"
      );
   );
);


loop(n1_2,
   loop(hierarchy_2,
      if(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h2"
      );
   );
);


loop(n1_2,
   loop(hierarchy_3,
      if(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h3"
      );
   );
);






execute_unload "C:\Users\Debbora\jrc\tests\data_b.gdx" v_data;

$stop





