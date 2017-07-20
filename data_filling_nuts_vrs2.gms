************* filling data gaps in agricultural data *************

$onlisting
$stars $$$$



******** READ IN CROPCATEGORIES **********
$include "C:\Users\Debbora\jrc\incl_d\cropcategories.txt"

set hierarchy_0(cropcategories) /AGRAREA/;
set hierarchy_1(cropcategories) /'B_1','B_2','B_3', 'B_4'/;
set hierarchy_2(cropcategories) /'B_1_1','B_1_2' ,'B_1_3' ,'B_1_4','B_1_5','B_1_6','B_1_7','B_1_8', 'B_1_9','B_1_10','B_1_11','B_1_12'
                            'B_3_1','B_3_2' ,'B_3_3'
                            'B_4_1','B_4_2' ,'B_4_3' ,'B_4_4','B_4_5','B_4_6','B_4_7'
                            'B_5_1','B_5_2','B_5_3'/;
set hierarchy_3(cropcategories) /'B_1_1_1','B_1_1_2','B_1_1_3','B_1_1_4', 'B_1_1_5','B_1_1_6','B_1_1_7','B_1_1_99'
                            'B_1_2_1','B_1_2_2'
                            'B_1_6_1','B_1_6_2','B_1_6_3' ,'B_1_6_4' ,'B_1_6_5' ,'B_1_6_6', 'B_1_6_7','B_1_6_8','B_1_6_9' ,'B_1_6_10','B_1_6_11','B_1_6_12',  'B_1_6_99'
                            'B_1_7_1','B_1_7_2'
                            'B_1_8_1','B_1_8_2'
                            'B_1_9_1','B_1_9_2'
                            'B_1_12_1','B_1_12_2'
                            'B_4_1_1_1','B_4_1_1_2'
                            'B_4_3_1','B_4_3_2'
                            'B_4_4_1','B_4_4_2','B_4_4_3', 'B_4_4_4'/;
set hierarchy_4(cropcategories) /'B_1_7_1_1','B_1_7_1_2'
                            'B_1_9_2_1','B_1_9_2_2','B_1_9_2_99'
                            'B_4_1_1_1','B_4_1_1_2'/;


set hierarchy_mappings(cropcategories, cropcategories) /
$include "C:\Users\Debbora\jrc\incl_d\crop_sets_d.txt"
/;



******** READ IN NUTS REGIONS **********
$include "C:\Users\Debbora\jrc\incl_d\all_reg.txt"
$include "C:\Users\Debbora\jrc\incl_d\n0.txt"
$include "C:\Users\Debbora\jrc\incl_d\n1_2.txt"
$include "C:\Users\Debbora\jrc\incl_d\n2_3.txt"
*mappings between different region levels
$include "C:\Users\Debbora\jrc\incl_d\nuts_mappings.txt"




******** READ IN DATA FOR NUTS REGIONS **********
*data on different scale: year 2010, unit ha
table       data_n0(n0, cropcategories)
$ondelim
$include "C:\Users\Debbora\jrc\incl_d\nuts0_crops_d.csv"
$offdelim

table       data_n1_2(n1_2, cropcategories)
$ondelim
$include "C:\Users\Debbora\jrc\incl_d\nuts1_2_crops_d.csv"
$offdelim

table       data_n2_3(n2_3, cropcategories)
$ondelim
$include "C:\Users\Debbora\jrc\incl_d\nuts2_3_crops_d.csv"
$offdelim



******** COMBIND DATA FOR NUTS ON NICE PARAMETER **********
*parameter startwerte(all_reg, cropcategories);
*variable v_directly_after_solve(all_reg, cropcategories);
parameter p_data(all_reg, cropcategories);
variable v_data(all_reg, cropcategories);
v_data.fx(n0, cropcategories) $ (data_n0(n0, cropcategories) ne 0) = data_n0(n0, cropcategories);
v_data.fx(n1_2, cropcategories) $ (data_n1_2(n1_2, cropcategories) ne 0) = data_n1_2(n1_2, cropcategories);
v_data.fx(n2_3, cropcategories) $ (data_n2_3(n2_3, cropcategories) ne 0) = data_n2_3(n2_3, cropcategories);
v_data.lo(all_reg, cropcategories) $ (v_data.lo(all_reg, cropcategories) = -inf) = 0;
* we believe, that on nuts0 level data is comlete, therefore zeros are "real" zeros and can be fixed
v_data.fx(n0, cropcategories) = v_data.lo(n0, cropcategories);
* same with "AGRAREA"
v_data.fx(all_reg, "AGRAREA") = v_data.lo(all_reg, "AGRAREA");
************************
* for upper bounds it would be good to have area here, but area is all kaputt
************************



******** NOW THE ACTUAL WORK STARTS **********

*first step: distribute AGRAREA (only element on hierarchy_0 level) on nuts1_2 and nuts2_3 level
*we asume, that regions with AGRAREA=0 aren't data gaps, but really have no AGRAREA (exclaves Cueta and Melila and cityregions in UK)
*therefore, we only need to scale existing data on nuts1_2 (nuts2_3) to fit the matching value on nuts0 (nuts1_2)

scalar agrarea_n0
       sum_agrarea_n12
       agrarea_n12
       sum_agrarea_n23;



loop(n0,
   agrarea_n0 = v_data.l(n0, "AGRAREA");
   sum_agrarea_n12 = sum(n1_2 $ (nuts_mappings(n0, n1_2)), v_data.l(n1_2, "AGRAREA"));
   loop(n1_2 $ ((nuts_mappings(n0, n1_2)) AND (agrarea_n0 ne 0)),
      v_data.fx(n1_2, "AGRAREA") $ (v_data.lo(n1_2, "AGRAREA") = v_data.up(n1_2, "AGRAREA")) = v_data.l(n1_2, "AGRAREA") * (agrarea_n0/sum_agrarea_n12);
      agrarea_n12 = v_data.l(n1_2, "AGRAREA");
      sum_agrarea_n23 = sum(n2_3 $ (nuts_mappings(n1_2, n2_3)), v_data.l(n2_3, "AGRAREA"));
      loop(n2_3 $ ((nuts_mappings(n1_2, n2_3)) AND (agrarea_n12 ne 0)),
         v_data.fx(n2_3, "AGRAREA") $ (v_data.lo(n2_3, "AGRAREA") = v_data.up(n2_3, "AGRAREA")) = v_data.l(n2_3, "AGRAREA") * (agrarea_n12/sum_agrarea_n23)
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
   area_h0 = v_data.l(n0, "AGRAREA");
   sum_area_h1 = sum(hierarchy_1 $ hierarchy_mappings("AGRAREA", hierarchy_1), v_data.l(n0, hierarchy_1));
   loop(hierarchy_1 $ hierarchy_mappings("AGRAREA", hierarchy_1),
      v_data.fx(n0, hierarchy_1) $ (v_data.lo(n0, hierarchy_1) ne 0) = v_data.l(n0, hierarchy_1) * (area_h0/sum_area_h1);
      area_h1 = v_data.l(n0, hierarchy_1);
      sum_area_h2 = sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), v_data.l(n0, hierarchy_2));
      loop(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2),
         v_data.fx(n0, hierarchy_2) $ (v_data.lo(n0, hierarchy_2) ne 0) = v_data.l(n0, hierarchy_2) * (area_h1/sum_area_h2);
         area_h2 = v_data.l(n0, hierarchy_2);
         sum_area_h3 = sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), v_data.l(n0, hierarchy_3));
         loop(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3),
            v_data.fx(n0, hierarchy_3) $ (v_data.lo(n0, hierarchy_3) ne 0) = v_data.l(n0, hierarchy_3) * (area_h2/sum_area_h3);
            area_h3 = v_data.l(n0, hierarchy_3);
            sum_area_h4 = sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), v_data.l(n0, hierarchy_4));
            loop(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4),
               v_data.fx(n0, hierarchy_4) $ (v_data.lo(n0, hierarchy_4) ne 0) = v_data.l(n0, hierarchy_4) * (area_h3/sum_area_h4);
            );
         );
      );
   );
);



** main step: filling data gaps on finer levels. for each combination (e.g. filling subcategories of b_1 for nuts1_2 in a specific country)
** we optimize, using values calculate using shares as starting values, and the coresponding values on the coarser level (e.g. b_1 and the country)
** as constraints

singleton set    super_region(all_reg)
                 super_cropcategory(cropcategories);
set              sub_regions(all_reg)
                 sub_cropcategories(cropcategories);

set info_for_batinclude /"n0", "n1_2", "h0", "h1", "h2", "h3"/;

scalar   needed_sum_row
         sum_row
         sum_for_shares_row
         needed_sum_column
         sum_column
         sum_for_shares_column;

scalar   std  /0.05/;
variable v_hpd;


equations zeilensummen(all_reg)
          spaltensummen(cropcategories)
          opt_hpd;

zeilensummen(sub_regions) .. v_data(sub_regions, super_cropcategory) =e= sum(sub_cropcategories, v_data(sub_regions, sub_cropcategories));
spaltensummen(sub_cropcategories) .. v_data(super_region, sub_cropcategories) =e= sum(sub_regions, v_data(sub_regions, sub_cropcategories));
opt_hpd .. v_hpd =e= sum((sub_regions, sub_cropcategories), sqr((v_data(sub_regions, sub_cropcategories) - p_data(sub_regions, sub_cropcategories))
                                                                  /(std * p_data(sub_regions, sub_cropcategories) + 0.1)));

model tabloe /spaltensummen, zeilensummen, opt_hpd/;


*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_0.gdx" v_data;

loop(n0,
   loop(hierarchy_0,
      if(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h0"
      );
   );
);

*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_1.gdx" v_data;

loop(n0,
   loop(hierarchy_1,
      if(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h1"
      );
   );
);

*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_2.gdx" v_data;

loop(n0,
   loop(hierarchy_2,
      if(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h2"
      );
   );
);

*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_3.gdx" v_data;

loop(n0,
   loop(hierarchy_3,
      if(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n0" "h3"
      );
   );
);

*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_4.gdx" v_data;

loop(n1_2,
   loop(hierarchy_0,
      if(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h0"
      );
   );
);

*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_5.gdx" v_data;

loop(n1_2,
   loop(hierarchy_1,
      if(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h1"
      );
   );
);

*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_6.gdx" v_data;

loop(n1_2,
   loop(hierarchy_2,
      if(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h2"
      );
   );
);

*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_7.gdx" v_data;

loop(n1_2,
   loop(hierarchy_3,
      if(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1),
$batinclude "C:\Users\Debbora\jrc\incl_d\solve_single_table.gms" "n1_2" "h3"
      );
   );
);


execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\data_8.gdx" v_data;
*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\startwerte.gdx" startwerte;
*execute_unload "C:\Users\Debbora\jrc\tests\complete_run3\directly_after_solve.gdx" v_directly_after_solve;

$stop





