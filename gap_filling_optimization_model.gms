*****************************************************************
************ FILLING DATA GAPS IN AGRICULTURAL DATA *************
*****************************************************************

$eolcom #
$onlisting
$stars ;;;;
$oninline   # inline and multiline comments with /* */

Option NLP = CONOPT3;
Option DNLP = CONOPT3;

$ifi not set rebuildn0 $setglobal rebuildn0 OFF

file batch /putbatch.txt/;

******* READ IN CROPCATEGORIES **********
$offlisting 
$include "./sets/cropcategories.txt"

set hierarchy_0(cropcategories) /AGRAREA, C_LIVEST_L/;
set hierarchy_1(cropcategories) /'B_1','B_2','B_3', 'B_4'
                                'C_1_3L', 'C_4_5_6L'/;
set hierarchy_2(cropcategories) /'B_1_1','B_1_2' ,'B_1_345', 'B_1_6','B_1_7','B_1_8',
                                         'B_1_9','B_1_10_11','B_1_12'
                            'B_3_1','B_3_2' ,'B_3_3'
                            'B_4_1','B_4_2' ,'B_4_3' ,'B_4_4','B_4_5','B_4_6','B_4_7'
                            'C_1L', 'C_21399L', 'C_4L', 'C_5L', 'C_6L'/;
set hierarchy_3(cropcategories) /'B_1_1_1','B_1_1_2','B_1_1_3','B_1_1_4', 'B_1_1_5','B_1_1_6','B_1_1_7','B_1_1_99'
                            'B_1_2_1','B_1_2_2'
                            'B_1_3', 'B_1_4', 'B_1_5'
                            'B_1_10', 'B_1_11'
                            'B_1_12_1','B_1_12_2'
                            'B_1_6_1','B_1_6_2','B_1_6_3' ,'B_1_6_4' ,'B_1_6_5' ,'B_1_6_6', 'B_1_6_7_11',
                                 'B_1_6_12',  'B_1_6_99'
                            'B_1_7_1','B_1_7_2'
                            'B_1_8_1','B_1_8_2'
                            'B_1_9_1','B_1_9_2'
                            'B_4_1_1','B_4_1_2','B_4_1_3'
                            'B_4_3_1','B_4_3_2'
                            'B_4_4_1','B_4_4_2','B_4_4_3', 'B_4_4_4'
                            'C_2L', 'C_3L', 'C_4_1L', 'C_4_2L', 'C_4_99L', 'C_5_1L', 'C_5_2L', 'C_5_3L'/;
set hierarchy_4(cropcategories) / 'B_1_6_7', 'B_1_6_8', 'B_1_6_9', 'B_1_6_10', 'B_1_6_11'
                            'B_1_7_1_1','B_1_7_1_2'
                            'B_1_9_2_1','B_1_9_2_2_99'
                            'B_4_1_1_1','B_4_1_1_2'
                            'C_2_1_2_5L', 'C_2_6_99L', 'C_3_1L', 'C_3_2L'/;
set hierarchy_5(cropcategories) /'B_1_9_2_2', 'B_1_9_2_99'
                                'C_2_1L', 'C_2_2L', 'C_2_3L', 'C_2_4L', 'C_2_5L', 'C_2_6L', 'C_2_99L','C_3_1_1L', 'C_3_1_99L', 'C_3_2_1L', 'C_3_2_99L'/;


set hierarchy_mappings(cropcategories, cropcategories) /
$include "./sets/crop_sets_d.txt"
/;


#******* READ IN REGIONS **********
$include "./sets/all_reg_to_define_mappings.txt"
$include "./sets/all_reg.txt"
$include "./sets/all_nuts.txt"
$include "./sets/n0.txt"
$include "./sets/n1_2.txt"
$include "./sets/n2_3.txt"
$include "./sets/all_gridunits_to_define_mappings.txt"
$include "./sets/all_gridunits.txt"
$include "./sets/gridunits_10_n12.txt"
$include "./sets/gridunits_20_n12.txt"
$include "./sets/gridunits_60_n12.txt"
$include "./sets/gridunits_10_n23.txt"
$include "./sets/grid10.txt"
$include "./sets/extra_flags.txt"


#mappings between different region levels
$include "./sets/nuts_mappings.txt"
$include "./sets/mappings_gridunits_levelwise.txt"
$include "./sets/mappings_nuts1_2_gridunits_20.txt"
$include "./sets/mappings_nuts1_2_gridunits_10.txt"
$include "./sets/mappings_nuts1_2_gridunits_10_n23.txt"
$include "./sets/mappings_gridunits_10_n23.txt"
$include "./sets/mappings_grid10_grid10n12.txt"

#******* READ IN DATA FOR NUTS REGIONS **********
set unit_flag /ha, flg/;
#data on different scale: year 2010, unit ha
table       data_n0(n0all, unit_flag, cropcategories)
$ondelim
$include "./data/nuts0_crops.csv"
$offdelim
;

table       data_n1_2(n1_2, unit_flag, cropcategories)
$ondelim
$include "./data/nuts1_2_crops.csv"
$offdelim
;

table       data_n2_3(n2_3, unit_flag, cropcategories)
$ondelim
$include "./data/nuts2_3_crops.csv"
$offdelim
;
$onlisting

#******* CHECKING iF COUNTRY IS SET *************************
set n0(n0all);
n0(n0all)=yes; 

 
#******* COMBINING DATA FOR NUTS ON NICE PARAMETER **********

parameter p_data_nuts(all_nuts, cropcategories);
parameter data_nuts_results(all_nuts, cropcategories);
parameter p_std_nuts(all_nuts, cropcategories);
variable v_data_nuts(all_nuts, cropcategories);

v_data_nuts.l(n0, cropcategories) = data_n0(n0, "ha", cropcategories);
v_data_nuts.l(n1_2, cropcategories) = data_n1_2(n1_2, "ha", cropcategories);
v_data_nuts.l(n2_3, cropcategories) = data_n2_3(n2_3, "ha", cropcategories);
v_data_nuts.lo(all_nuts, cropcategories)= 0;

p_std_nuts(n0, cropcategories) $ (data_n0(n0, "flg", cropcategories) = 0) = 0.01;
p_std_nuts(n1_2, cropcategories) $ (data_n1_2(n1_2, "flg", cropcategories) = 0) = 0.01;
p_std_nuts(n2_3, cropcategories) $ (data_n2_3(n2_3, "flg", cropcategories) = 0) = 0.01;
p_std_nuts(all_nuts, cropcategories) $ (p_std_nuts(all_nuts, cropcategories) ne 0.01) = 0.05;

# we believe, that on nuts0 level data is comlete, therefore zeros are "real" zeros and can be fixed
v_data_nuts.fx(n0, cropcategories) = v_data_nuts.l(n0, cropcategories);

# same with "AGRAREA" and "C_LIVEST_L"
v_data_nuts.fx(n0, "AGRAREA") = v_data_nuts.l(n0, "AGRAREA");
v_data_nuts.fx(n1_2, "AGRAREA") = v_data_nuts.l(n1_2, "AGRAREA");
v_data_nuts.fx(n0, "C_LIVEST_L") = v_data_nuts.l(n0, "C_LIVEST_L");
v_data_nuts.fx(n1_2, "C_LIVEST_L") = v_data_nuts.l(n1_2, "C_LIVEST_L");


#******* NOW THE ACTUAL WORK STARTS **********

#first step: distribute AGRAREA (only element on hierarchy_0 level) on nuts1_2 level (nuts2_3 will be solved parallel to the grids)
#we asume, that regions with AGRAREA=0 aren't data gaps, but really have no AGRAREA (exclaves Cueta and Melila and cityregions in UK)
#therefore, we only need to scale existing data on nuts1_2 to fit the matching value on nuts0 (nuts1_2)
#* supplement: same procedure for later added livestock


#** - building Nuts0 data base - this is done for all countries and thus does not need to be
#**   repeated


scalar agrarea_n0
       sum_agrarea_n12
       agrarea_n12
       sum_agrarea_n23
       number_subregions_agrarea_n0
       number_subregions_agrarea_n12;


loop(n0,
   agrarea_n0 = v_data_nuts.l(n0, "AGRAREA");
   sum_agrarea_n12 = sum(n1_2 $ (nuts_mappings(n0, n1_2)), v_data_nuts.l(n1_2, "AGRAREA"));
   number_subregions_agrarea_n0 = sum(n1_2 $ nuts_mappings(n0, n1_2), 1);
   loop(n1_2 $ ((nuts_mappings(n0, n1_2)) AND (agrarea_n0 ne 0)),
      if(sum_agrarea_n12 ne 0,
         v_data_nuts.fx(n1_2, "AGRAREA") $ (v_data_nuts.lo(n1_2, "AGRAREA") = v_data_nuts.up(n1_2, "AGRAREA")) = v_data_nuts.l(n1_2, "AGRAREA") * (agrarea_n0/sum_agrarea_n12);
      elseif(sum_agrarea_n12 = 0 AND agrarea_n0 ne 0),
         v_data_nuts.fx(n1_2, "AGRAREA") $ (v_data_nuts.lo(n1_2, "AGRAREA") = v_data_nuts.up(n1_2, "AGRAREA")) = agrarea_n0/number_subregions_agrarea_n0
      );
   );
);

v_data_nuts.fx(n0, "AGRAREA") = v_data_nuts.l(n0, "AGRAREA");
v_data_nuts.fx(n1_2, "AGRAREA") = v_data_nuts.l(n1_2, "AGRAREA");

scalar livestock_n0
       sum_livestock_n12
       livestock_n12
       sum_livestock_n23
       number_subregions_livestock_n0
       number_subregions_livestock_n12;


loop(n0,
   livestock_n0 = v_data_nuts.l(n0, "C_LIVEST_L");
   sum_livestock_n12 = sum(n1_2 $ (nuts_mappings(n0, n1_2)), v_data_nuts.l(n1_2, "C_LIVEST_L"));
   number_subregions_livestock_n0 = sum(n1_2 $ nuts_mappings(n0, n1_2), 1);
   loop(n1_2 $ ((nuts_mappings(n0, n1_2)) AND (livestock_n0 ne 0)),
      if(sum_livestock_n12 ne 0,
         v_data_nuts.fx(n1_2, "C_LIVEST_L") $ (v_data_nuts.lo(n1_2, "C_LIVEST_L") = v_data_nuts.up(n1_2, "C_LIVEST_L")) = v_data_nuts.l(n1_2, "C_LIVEST_L") * (livestock_n0/sum_livestock_n12);
      elseif(sum_livestock_n12 = 0 AND livestock_n0 ne 0),
         v_data_nuts.fx(n1_2, "C_LIVEST_L") $ (v_data_nuts.lo(n1_2, "C_LIVEST_L") = v_data_nuts.up(n1_2, "C_LIVEST_L")) = livestock_n0/number_subregions_livestock_n0
      );
   );
);

v_data_nuts.fx(n0, "C_LIVEST_L") = v_data_nuts.l(n0, "C_LIVEST_L");
v_data_nuts.fx(n1_2, "C_LIVEST_L") = v_data_nuts.l(n1_2, "C_LIVEST_L");

#second step: distribute all cropcategories over nuts0
#as data on nuts0 level is complete, we only have to fix rounding errors by scaling the data


scalar area_h0
       sum_area_h1
       area_h1
       sum_area_h2
       area_h2
       sum_area_h3
       area_h3
       sum_area_h4
       area_h4
       sum_area_h5
       test
       number_subcategories_h0
       number_subcategories_h1
       number_subcategories_h2
       number_subcategories_h3
       number_subcategories_h4;

loop(n0,
 loop(hierarchy_0,
   area_h0 = v_data_nuts.l(n0, hierarchy_0);
   sum_area_h1 = sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), v_data_nuts.l(n0, hierarchy_1));
   number_subcategories_h0 = sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1);
   loop(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1),
      if(sum_area_h1 ne 0,
         v_data_nuts.fx(n0, hierarchy_1) $ (v_data_nuts.lo(n0, hierarchy_1) ne 0) = v_data_nuts.l(n0, hierarchy_1) * (area_h0/sum_area_h1);
      elseif (sum_area_h1 = 0 AND area_h0 ne 0),
         v_data_nuts.fx(n0, hierarchy_1) = area_h0/number_subcategories_h0
      );
      area_h1 = v_data_nuts.l(n0, hierarchy_1);
      sum_area_h2 = sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), v_data_nuts.l(n0, hierarchy_2));
      number_subcategories_h1 = sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1);
      loop(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2),
         if(sum_area_h2 ne 0,
            v_data_nuts.fx(n0, hierarchy_2) $ (v_data_nuts.lo(n0, hierarchy_2) ne 0) = v_data_nuts.l(n0, hierarchy_2) * (area_h1/sum_area_h2);
         elseif (sum_area_h2 = 0 AND area_h1 ne 0),
            v_data_nuts.fx(n0, hierarchy_2) = area_h1/number_subcategories_h1
         );
         area_h2 = v_data_nuts.l(n0, hierarchy_2);
         sum_area_h3 = sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), v_data_nuts.l(n0, hierarchy_3));
         number_subcategories_h2 = sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1);
         loop(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3),
            if(sum_area_h3 ne 0,
               v_data_nuts.fx(n0, hierarchy_3) $ (v_data_nuts.lo(n0, hierarchy_3) ne 0) = v_data_nuts.l(n0, hierarchy_3) * (area_h2/sum_area_h3);
            elseif (sum_area_h3 = 0 AND area_h2 ne 0),
               v_data_nuts.fx(n0, hierarchy_3) = area_h2/number_subcategories_h2
            );
            area_h3 = v_data_nuts.l(n0, hierarchy_3);
            sum_area_h4 = sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), v_data_nuts.l(n0, hierarchy_4));
            number_subcategories_h3 = sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1);
            loop(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4),
               if(sum_area_h4 ne 0,
                 v_data_nuts.fx(n0, hierarchy_4) $ (v_data_nuts.lo(n0, hierarchy_4) ne 0) = v_data_nuts.l(n0, hierarchy_4) * (area_h3/sum_area_h4);
               elseif (sum_area_h4 = 0 AND area_h3 ne 0),
                 v_data_nuts.fx(n0, hierarchy_4) = area_h3/number_subcategories_h3
               );
               area_h4 = v_data_nuts.l(n0, hierarchy_4);
               sum_area_h5 = sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), v_data_nuts.l(n0, hierarchy_5));
               number_subcategories_h4 = sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1);
               loop(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5),
                 if(sum_area_h5 ne 0,
                    v_data_nuts.fx(n0, hierarchy_5) $ (v_data_nuts.lo(n0, hierarchy_5) ne 0) = v_data_nuts.l(n0, hierarchy_5) * (area_h4/sum_area_h5);
                 elseif (sum_area_h5 = 0 AND area_h4 ne 0),
                    v_data_nuts.fx(n0, hierarchy_5) = area_h4/number_subcategories_h4
                 );
               );
            );
         );
      );
   );
 );
);

v_data_nuts.fx(n0, cropcategories) = v_data_nuts.l(n0, cropcategories);




#* third step: filling data gaps on nuts1_2 level. for each combination (e.g. filling subcategories of b_1 for nuts1_2 in a specific country)
#* we optimize, using values calculated using shares as starting values, and the coresponding values on the coarser level (e.g. b_1 and the country)
#* as constraints

singleton set    super_region(all_nuts)
                 super_cropcategory(cropcategories);
set              sub_regions(all_nuts)
                 sub_cropcategories(cropcategories);

set info_for_batinclude /"n0", "n1_2", "h0", "h1", "h2", "h3", "h4"/;

scalar   needed_sum_row
         sum_row
         sum_for_shares_row
         needed_sum_column
         sum_column
         sum_for_shares_column;


variable v_hpd;


equations zeilensummen(all_nuts)
          spaltensummen(cropcategories)
          opt_hpd;

zeilensummen(sub_regions) .. v_data_nuts(sub_regions, super_cropcategory) =e= sum(sub_cropcategories, v_data_nuts(sub_regions, sub_cropcategories));
spaltensummen(sub_cropcategories) .. v_data_nuts(super_region, sub_cropcategories) =e= sum(sub_regions, v_data_nuts(sub_regions, sub_cropcategories));
opt_hpd .. v_hpd =e= sum((sub_regions, sub_cropcategories), sqr((v_data_nuts(sub_regions, sub_cropcategories) - p_data_nuts(sub_regions, sub_cropcategories))
                                                                  /(p_std_nuts(sub_regions, sub_cropcategories) * p_data_nuts(sub_regions, sub_cropcategories) + 0.1)));

model single_table /spaltensummen, zeilensummen, opt_hpd/;
single_table.OptFile = 1;

single_table.limrow = 0;
single_table.limcol = 0;
single_table.solprint = 0;


$iftheni %rebuildn0%==ON
  loop(n0,
    loop(hierarchy_0,
        if(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1),
          $$batinclude "solve_single_table_grids.gms" "n0" "h0"
        );
    );
  );

  loop(n0,
    loop(hierarchy_1,
        if(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1),
          $$batinclude "solve_single_table_grids.gms" "n0" "h1"
        );
    );
  );


  loop(n0,
    loop(hierarchy_2,
        if(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1),
          $$batinclude "solve_single_table_grids.gms" "n0" "h2"
        );
    );
  );

  loop(n0,
    loop(hierarchy_3,
        if(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1),
          $$batinclude "solve_single_table_grids.gms" "n0" "h3"
        );
    );
  );

  loop(n0,
    loop(hierarchy_4,
        if(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1),
          $$batinclude "solve_single_table_grids.gms" "n0" "h4"
        );
    );
  );

  data_nuts_results(n0, cropcategories) = v_data_nuts.l(n0, cropcategories);
  data_nuts_results(n1_2, cropcategories) = v_data_nuts.l(n1_2, cropcategories);
  execute_unload "./results/data_nuts_results.gdx" data_nuts_results;
  execute_unload "./results/data_nuts_halfway.gdx" v_data_nuts;
$else
  execute_load "./results/data_nuts_halfway.gdx" v_data_nuts;
$endif

display n0;
#$stop
#$offtext
$ifi set checkcountry n0(n0all)$(not sameas(n0all,"%checkcountry%"))=no;

#* fourth step: nuts2_3 have to be filled toghether with gridunits, as both regiontypes are subregions of nuts1_2.
#* this means we have much more different constraints to be fullfilled, but the structure stays the same (only changes in
#* the subprogram which does the actual solving)

#*********** FILLING AGRAREA FOR GRIDUNITS ************
#* the subprogram "solve_parallel_tables_new.gms" works with existant row/column sums. Therefore we need data for the highest regional and cropcategrorical level.
#* We have values for nuts1_2, but we don't have values for AGRAREA for all gridunits. Therefore we have to fill those first!

#****** MODEL FOR AOLVING AGRAREA FOR GRIDUNTIS *******
set      sub_regions_nuts2_3(n2_3)
         sub_regions_gridunits_60_n12(gridunits_60_n12)
         sub_regions_gridunits_20_n12(gridunits_20_n12)
         sub_regions_gridunits_10_n12(gridunits_10_n12)
         sub_regions_gridunits_10_n23(gridunits_10_n23);
singleton set   super_region_n12(n1_2);
$offlisting
set type /total, nogo/;
parameter area(all_reg_to_define_mappings, type);
execute_load "./area/area.gdx" area;
parameter upper_bounds(all_reg_to_define_mappings);
upper_bounds(all_reg) = area(all_reg, "total") - area(all_reg, "nogo");
parameter total_area(all_reg_to_define_mappings);
total_area(all_reg) = area(all_reg, "total");
set value /B_3_99/;
table       fodder_area(all_reg_to_define_mappings, unit_flag, value)
$ondelim
$include "./area/fodder_area.csv"
$offdelim
;
$onlisting

parameter p_data_gridunits(*, cropcategories);
parameter p_std_gridunits(*, cropcategories);
variable v_data_gridunits(*, cropcategories);
parameter results_gridunits(*, cropcategories);

# need to unload results_gridunits, so it won't create error when reading in in first iteration
execute_unload "./results/results_gridunits.gdx" results_gridunits;

alias (gridunits_10_n12,gridunits_10_n12b);

$iftheni %rebuildn0%==ON
  $$offlisting
  table       data_gridunits_10(gridunits_10_n12, unit_flag, cropcategories)
  $$ondelim
  $$include "./data/grid10_nuts1_2_crops.csv"
  $$offdelim
  ;

  table       data_gridunits_20(gridunits_20_n12, unit_flag, cropcategories)
  $$ondelim
  $$include "./data/grid20_nuts1_2_crops.csv"
  $$offdelim
  ;

  table       data_gridunits_60(gridunits_60_n12, unit_flag, cropcategories)
  $$ondelim
  $$include "./data/grid60_nuts1_2_crops.csv"
  $$offdelim
  ;
  $$onlisting

  results_gridunits(gridunits_10_n12, cropcategories) = data_gridunits_10(gridunits_10_n12, "ha", cropcategories);
  results_gridunits(gridunits_20_n12, cropcategories) = data_gridunits_20(gridunits_20_n12, "ha", cropcategories);
  results_gridunits(gridunits_60_n12, cropcategories) = data_gridunits_60(gridunits_60_n12, "ha", cropcategories);
  execute_unload "./analysis/startwerte.gdx"  results_gridunits;
  
  # we want to add some flags: in cases where a nuts12 border devides a grid10 into two or more grid10_n12, this can cause mistakes,
  # as often one smaller part has value 0 without flag, as the area is registered in the other area, even though some of it is in the
  # small region. of course this problem can't only happen at borders, but it's more often here, as small areas exist, where the probability
  # that no farmer has his home there is high. Therefore we flag this areas with value 0

  data_gridunits_10(gridunits_10_n12, "flg", cropcategories)

  #        Select gridunits_10_n12b which belong to grid10      ... for those grid10 which belong to gri_10_n12     .... if there are more than one
    $((sum(mappings_grid10_grid10n12(grid10, gridunits_10_n12b) $mappings_grid10_grid10n12(grid10, gridunits_10_n12), 1) > 1)
  #        ... but only of there is no value set
        and (data_gridunits_10(gridunits_10_n12, "ha", cropcategories) =  0))
    =-1;

  # furthermore there was some problems with big comunes in FR and PL, therefore we have a list of gridunits_10_n12 which we set 0 and flag
  data_gridunits_10(extra_flags, "ha", cropcategories) = 0;
  data_gridunits_10(extra_flags, "flg", cropcategories) = -1;

  execute_unload "./data/data_gridunits.gdx"  data_gridunits_10, data_gridunits_20, data_gridunits_60;

  Option clear = data_gridunits_10;
  Option clear = data_gridunits_20;
  Option clear = data_gridunits_60;
$else
  table   data_gridunits_10(gridunits_10_n12, unit_flag, cropcategories);
  table   data_gridunits_20(gridunits_20_n12, unit_flag, cropcategories);
  table   data_gridunits_60(gridunits_60_n12, unit_flag, cropcategories);
  execute_load "./analysis/startwerte.gdx"  results_gridunits;
$endif

scalar   needed_agrarea
         sum_agrarea
         sum_for_shares_agrarea;
scalar   needed_livestock
         sum_livestock
         sum_for_shares_livestock;

alias (n1_2, n1_2_alias);

******* MODEL FOR SOLVING AGRAREA ON GRIDUNITS LEVEL **********

variable v_hpd_agrarea
equations agrarea_to_n12(n1_2_alias)
          agrarea_to_gridunits60(gridunits_60_n12)
          agrarea_to_gridunits20(gridunits_20_n12)
          agrarea_to_gridunits10(gridunits_10_n12)
          agrarea_to_nuts23(n2_3)
          agrarea_n23_to_n12(n1_2_alias)
          opt_hpd_agrarea;

agrarea_n23_to_n12(n1_2_alias) .. v_data_nuts(super_region_n12, "AGRAREA") =e= sum(sub_regions_nuts2_3, v_data_nuts(sub_regions_nuts2_3, "AGRAREA"));
agrarea_to_n12(n1_2_alias) .. v_data_nuts(super_region_n12, "AGRAREA") =e= sum(sub_regions_gridunits_60_n12, v_data_gridunits(sub_regions_gridunits_60_n12, "AGRAREA"));
agrarea_to_gridunits60(sub_regions_gridunits_60_n12) .. v_data_gridunits(sub_regions_gridunits_60_n12, "AGRAREA") =e= sum(sub_regions_gridunits_20_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12),
                                                                                                  v_data_gridunits(sub_regions_gridunits_20_n12, "AGRAREA"));
agrarea_to_gridunits20(sub_regions_gridunits_20_n12) .. v_data_gridunits(sub_regions_gridunits_20_n12, "AGRAREA") =e= sum(sub_regions_gridunits_10_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12),
                                                                                                  v_data_gridunits(sub_regions_gridunits_10_n12, "AGRAREA"));
agrarea_to_gridunits10(sub_regions_gridunits_10_n12) .. v_data_gridunits(sub_regions_gridunits_10_n12, "AGRAREA") =e= sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23),
                                                                                                  v_data_gridunits(sub_regions_gridunits_10_n23, "AGRAREA"));
agrarea_to_nuts23(sub_regions_nuts2_3) .. v_data_nuts(sub_regions_nuts2_3, "AGRAREA") =e= sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_nuts2_3, sub_regions_gridunits_10_n23),
                                                                 v_data_gridunits(sub_regions_gridunits_10_n23, "AGRAREA"));
opt_hpd_agrarea ..  v_hpd_agrarea =e= sum(all_gridunits, sqr((v_data_gridunits(all_gridunits, "AGRAREA") - p_data_gridunits(all_gridunits, "AGRAREA"))
                                                                  /(p_std_gridunits(all_gridunits, "AGRAREA") * p_data_gridunits(all_gridunits, "AGRAREA") + 0.1)))
                                      + sum(all_gridunits, sqr(sqr((max(0, v_data_gridunits(all_gridunits, "AGRAREA") - max(upper_bounds(all_gridunits), p_data_gridunits(all_gridunits, "AGRAREA")))))
                                                                 /(0.01 * max(upper_bounds(all_gridunits), p_data_gridunits(all_gridunits, "AGRAREA")) + 0.1)))
                                      + sum(n2_3, sqr((v_data_nuts(n2_3, "AGRAREA") - p_data_nuts(n2_3, "AGRAREA"))
                                                                  /(p_std_nuts(n2_3, "AGRAREA") * p_data_nuts(n2_3, "AGRAREA") + 0.1)))
                                      + sum(n2_3, sqr(sqr((max(0, v_data_nuts(n2_3, "AGRAREA") - max(upper_bounds(n2_3), p_data_nuts(n2_3, "AGRAREA")))))
                                                                 /(0.01 * max(upper_bounds(n2_3), p_data_nuts(n2_3, "AGRAREA")) + 0.1)));
$ontext
opt_hpd_agrarea ..  v_hpd_agrarea =e= sum(gridunits_60_n12, sqr((v_data_gridunits(gridunits_60_n12, "AGRAREA") - p_data_gridunits(gridunits_60_n12, "AGRAREA"))
                                                                  /(p_std_gridunits(gridunits_60_n12, "AGRAREA") * p_data_gridunits(gridunits_60_n12, "AGRAREA") + 0.1)))
                                      + sum(gridunits_60_n12, sqr(sqr((max(0, v_data_gridunits(gridunits_60_n12, "AGRAREA") - max(upper_bounds(gridunits_60_n12), p_data_gridunits(gridunits_60_n12, "AGRAREA")))))
                                                                 /(0.01 * max(upper_bounds(gridunits_60_n12), p_data_gridunits(gridunits_60_n12, "AGRAREA")) + 0.1)))
                                      + sum(gridunits_20_n12, sqr((v_data_gridunits(gridunits_20_n12, "AGRAREA") - p_data_gridunits(gridunits_20_n12, "AGRAREA"))
                                                                  /(p_std_gridunits(gridunits_20_n12, "AGRAREA") * p_data_gridunits(gridunits_20_n12, "AGRAREA") + 0.1)))
                                      + sum(gridunits_20_n12, sqr(sqr((max(0, v_data_gridunits(gridunits_20_n12, "AGRAREA") - max(upper_bounds(gridunits_20_n12), p_data_gridunits(gridunits_20_n12, "AGRAREA")))))
                                                                 /(0.01 * max(upper_bounds(gridunits_20_n12), p_data_gridunits(gridunits_20_n12, "AGRAREA")) + 0.1)))
                                      + sum(gridunits_10_n12, sqr((v_data_gridunits(gridunits_10_n12, "AGRAREA") - p_data_gridunits(gridunits_10_n12, "AGRAREA"))
                                                                  /(p_std_gridunits(gridunits_10_n12, "AGRAREA") * p_data_gridunits(gridunits_10_n12, "AGRAREA") + 0.1)))
                                      + sum(gridunits_10_n12, sqr(sqr((max(0, v_data_gridunits(gridunits_10_n12, "AGRAREA") - max(upper_bounds(gridunits_10_n12), p_data_gridunits(gridunits_10_n12, "AGRAREA")))))
                                                                 /(0.01 * max(upper_bounds(gridunits_10_n12), p_data_gridunits(gridunits_10_n12, "AGRAREA")) + 0.1)))
                                      + sum(n2_3, sqr((v_data_nuts(n2_3, "AGRAREA") - p_data_nuts(n2_3, "AGRAREA"))
                                                                  /(p_std_nuts(n2_3, "AGRAREA") * p_data_nuts(n2_3, "AGRAREA") + 0.1)))
                                      + sum(n2_3, sqr(sqr((max(0, v_data_nuts(n2_3, "AGRAREA") - max(upper_bounds(n2_3), p_data_nuts(n2_3, "AGRAREA")))))
                                                                 /(0.01 * max(upper_bounds(n2_3), p_data_nuts(n2_3, "AGRAREA")) + 0.1)));
$offtext

model table_agrarea /agrarea_to_n12
                      agrarea_to_gridunits60
                      agrarea_to_gridunits20
                      agrarea_to_gridunits10
                      agrarea_to_nuts23
                      agrarea_n23_to_n12
                      opt_hpd_agrarea/;
table_agrarea.OptFile = 1;
table_agrarea.limrow = 0;
table_agrarea.limcol = 0;
table_agrarea.solprint = 0;


******* MODEL FOR SOLVING AGRAREA ON GRIDUNITS LEVEL *********
#

variable v_hpd_livestock
equations livestock_to_n12(n1_2_alias)
          livestock_to_gridunits60(gridunits_60_n12)
          livestock_to_gridunits20(gridunits_20_n12)
          livestock_to_gridunits10(gridunits_10_n12)
          livestock_to_nuts23(n2_3)
          livestock_n23_to_n12(n1_2_alias)
          opt_hpd_livestock;

livestock_n23_to_n12(n1_2_alias) .. v_data_nuts(super_region_n12, "C_LIVEST_L") =e= sum(sub_regions_nuts2_3, v_data_nuts(sub_regions_nuts2_3, "C_LIVEST_L"));
livestock_to_n12(n1_2_alias) .. v_data_nuts(super_region_n12, "C_LIVEST_L") =e= sum(sub_regions_gridunits_60_n12, v_data_gridunits(sub_regions_gridunits_60_n12, "C_LIVEST_L"));
livestock_to_gridunits60(sub_regions_gridunits_60_n12) .. v_data_gridunits(sub_regions_gridunits_60_n12, "C_LIVEST_L") =e= sum(sub_regions_gridunits_20_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12),
                                                                                                  v_data_gridunits(sub_regions_gridunits_20_n12, "C_LIVEST_L"));
livestock_to_gridunits20(sub_regions_gridunits_20_n12) .. v_data_gridunits(sub_regions_gridunits_20_n12, "C_LIVEST_L") =e= sum(sub_regions_gridunits_10_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12),
                                                                                                  v_data_gridunits(sub_regions_gridunits_10_n12, "C_LIVEST_L"));
livestock_to_gridunits10(sub_regions_gridunits_10_n12) .. v_data_gridunits(sub_regions_gridunits_10_n12, "C_LIVEST_L") =e= sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23),
                                                                                                  v_data_gridunits(sub_regions_gridunits_10_n23, "C_LIVEST_L"));
livestock_to_nuts23(sub_regions_nuts2_3) .. v_data_nuts(sub_regions_nuts2_3, "C_LIVEST_L") =e= sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_nuts2_3, sub_regions_gridunits_10_n23),
                                                                 v_data_gridunits(sub_regions_gridunits_10_n23, "C_LIVEST_L"));
opt_hpd_livestock ..  v_hpd_livestock =e= sum(all_gridunits, sqr((v_data_gridunits(all_gridunits, "C_LIVEST_L") - p_data_gridunits(all_gridunits, "C_LIVEST_L"))
                                                                  /(p_std_gridunits(all_gridunits, "C_LIVEST_L") * p_data_gridunits(all_gridunits, "C_LIVEST_L") + 0.1)))
                                      + sum(n2_3, sqr((v_data_nuts(n2_3, "C_LIVEST_L") - p_data_nuts(n2_3, "C_LIVEST_L"))
                                                                  /(p_std_nuts(n2_3, "C_LIVEST_L") * p_data_nuts(n2_3, "C_LIVEST_L") + 0.1)));
$ontext
opt_hpd_livestock ..  v_hpd_livestock =e= sum(gridunits_60_n12, sqr((v_data_gridunits(gridunits_60_n12, "C_LIVEST_L") - p_data_gridunits(gridunits_60_n12, "C_LIVEST_L"))
                                                                  /(p_std_gridunits(gridunits_60_n12, "C_LIVEST_L") * p_data_gridunits(gridunits_60_n12, "C_LIVEST_L") + 0.1)))
                                      + sum(gridunits_20_n12, sqr((v_data_gridunits(gridunits_20_n12, "C_LIVEST_L") - p_data_gridunits(gridunits_20_n12, "C_LIVEST_L"))
                                                                  /(p_std_gridunits(gridunits_20_n12, "C_LIVEST_L") * p_data_gridunits(gridunits_20_n12, "C_LIVEST_L") + 0.1)))
                                      + sum(gridunits_10_n12, sqr((v_data_gridunits(gridunits_10_n12, "C_LIVEST_L") - p_data_gridunits(gridunits_10_n12, "C_LIVEST_L"))
                                                                  /(p_std_gridunits(gridunits_10_n12, "C_LIVEST_L") * p_data_gridunits(gridunits_10_n12, "C_LIVEST_L") + 0.1)))
                                      + sum(n2_3, sqr((v_data_nuts(n2_3, "C_LIVEST_L") - p_data_nuts(n2_3, "C_LIVEST_L"))
                                                                  /(p_std_nuts(n2_3, "C_LIVEST_L") * p_data_nuts(n2_3, "C_LIVEST_L") + 0.1)));
$offtext


model table_livestock /livestock_to_n12
                      livestock_to_gridunits60
                      livestock_to_gridunits20
                      livestock_to_gridunits10
                      livestock_to_nuts23
                      livestock_n23_to_n12
                      opt_hpd_livestock/;
table_livestock.OptFile = 1;

table_livestock.limrow = 0;
table_livestock.limcol = 0;
table_livestock.solprint = 0;

#$stop
****** MODEL FOR SOLVING n1_2 TO n2_3 AND GRIDUNTIS ********

scalar scalar_hpd;


variable v_hpd_multi;


equations zeilensummen_nuts23(all_reg)
          zeilensummen_gridunits_60(gridunits_60_n12)
          zeilensummen_gridunits_20(gridunits_20_n12)
          zeilensummen_gridunits_10(gridunits_10_n12)
          zeilensummen_gridunits_10_n23(gridunits_10_n23)
          spaltensummen_n23_n12(cropcategories)
          spaltensummen_gridunits60_n12(cropcategories)
          spaltensummen_gridunits20_gridunits_60(cropcategories, gridunits_60_n12)
          spaltensummen_gridunits10_gridunits_20(cropcategories, gridunits_20_n12)
          spaltensummen_gridunits10n23_gridunits_10(cropcategories, gridunits_10_n12)
          spaltensummen_gridunits10n23_nuts2_3(cropcategories, n2_3)
          opt_hpd_multi
          opt_hpd_multi_nuts
          opt_hpd_multi_60
          opt_hpd_multi_20
          opt_hpd_multi_10;

zeilensummen_nuts23(sub_regions_nuts2_3) .. v_data_nuts(sub_regions_nuts2_3, super_cropcategory)
                                                         =e= sum(sub_cropcategories, v_data_nuts(sub_regions_nuts2_3, sub_cropcategories));
zeilensummen_gridunits_60(sub_regions_gridunits_60_n12) .. v_data_gridunits(sub_regions_gridunits_60_n12, super_cropcategory)
                                                         =e= sum(sub_cropcategories, v_data_gridunits(sub_regions_gridunits_60_n12, sub_cropcategories));
zeilensummen_gridunits_20(sub_regions_gridunits_20_n12) ..  v_data_gridunits(sub_regions_gridunits_20_n12, super_cropcategory)
                                                         =e= sum(sub_cropcategories, v_data_gridunits(sub_regions_gridunits_20_n12, sub_cropcategories));
zeilensummen_gridunits_10(sub_regions_gridunits_10_n12) ..  v_data_gridunits(sub_regions_gridunits_10_n12, super_cropcategory)
                                                         =e= sum(sub_cropcategories, v_data_gridunits(sub_regions_gridunits_10_n12, sub_cropcategories));
zeilensummen_gridunits_10_n23(sub_regions_gridunits_10_n23) .. v_data_gridunits(sub_regions_gridunits_10_n23, super_cropcategory)
                                                         =e= sum(sub_cropcategories, v_data_gridunits(sub_regions_gridunits_10_n23, sub_cropcategories));

spaltensummen_n23_n12(sub_cropcategories) .. v_data_nuts(super_region_n12, sub_cropcategories)
                                                         =e= sum(sub_regions_nuts2_3, v_data_nuts(sub_regions_nuts2_3, sub_cropcategories));
spaltensummen_gridunits60_n12(sub_cropcategories) .. v_data_nuts(super_region_n12, sub_cropcategories)
                                                         =e= sum(sub_regions_gridunits_60_n12 $ mappings_gridunits_levelwise(super_region_n12, sub_regions_gridunits_60_n12),
                                                                                 v_data_gridunits(sub_regions_gridunits_60_n12, sub_cropcategories));
spaltensummen_gridunits20_gridunits_60(sub_cropcategories, sub_regions_gridunits_60_n12) .. v_data_gridunits(sub_regions_gridunits_60_n12, sub_cropcategories)
                                                         =e= sum(sub_regions_gridunits_20_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12),
                                                                                 v_data_gridunits(sub_regions_gridunits_20_n12, sub_cropcategories));
spaltensummen_gridunits10_gridunits_20(sub_cropcategories, sub_regions_gridunits_20_n12) .. v_data_gridunits(sub_regions_gridunits_20_n12, sub_cropcategories)
                                                         =e= sum(sub_regions_gridunits_10_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12),
                                                                                 v_data_gridunits(sub_regions_gridunits_10_n12, sub_cropcategories));
spaltensummen_gridunits10n23_gridunits_10(sub_cropcategories, sub_regions_gridunits_10_n12) .. v_data_gridunits(sub_regions_gridunits_10_n12, sub_cropcategories)
                                                         =e= sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23),
                                                                                 v_data_gridunits(sub_regions_gridunits_10_n23, sub_cropcategories));
spaltensummen_gridunits10n23_nuts2_3(sub_cropcategories, sub_regions_nuts2_3) .. v_data_nuts(sub_regions_nuts2_3, sub_cropcategories)
                                                         =e= sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_nuts2_3, sub_regions_gridunits_10_n23),
                                                                                 v_data_gridunits(sub_regions_gridunits_10_n23, sub_cropcategories));

opt_hpd_multi .. v_hpd_multi =e= sum((sub_regions_nuts2_3, sub_cropcategories), sqr((v_data_nuts(sub_regions_nuts2_3, sub_cropcategories) - p_data_nuts(sub_regions_nuts2_3, sub_cropcategories))
                                                                  /(p_std_nuts(sub_regions_nuts2_3, sub_cropcategories) * p_data_nuts(sub_regions_nuts2_3, sub_cropcategories) + 0.1)))
                                 +  sum((gridunits_60_n12, sub_cropcategories) $ sub_regions_gridunits_60_n12(gridunits_60_n12),
                                                                            sqr((v_data_gridunits(gridunits_60_n12, sub_cropcategories) - p_data_gridunits(gridunits_60_n12, sub_cropcategories))
                                                                  /(p_std_gridunits(gridunits_60_n12, sub_cropcategories) * p_data_gridunits(gridunits_60_n12, sub_cropcategories) + 0.1)))
                                 +  sum((gridunits_20_n12, sub_cropcategories) $ sub_regions_gridunits_20_n12(gridunits_20_n12),
                                                                            sqr((v_data_gridunits(gridunits_20_n12, sub_cropcategories) - p_data_gridunits(gridunits_20_n12, sub_cropcategories))
                                                                  /(p_std_gridunits(gridunits_20_n12, sub_cropcategories) * p_data_gridunits(gridunits_20_n12, sub_cropcategories) + 0.1)))
                                 +  sum((gridunits_10_n12, sub_cropcategories) $ sub_regions_gridunits_10_n12(gridunits_10_n12),
                                                                            sqr((v_data_gridunits(gridunits_10_n12, sub_cropcategories) - p_data_gridunits(gridunits_10_n12, sub_cropcategories))
                                                                  /(p_std_gridunits(gridunits_10_n12, sub_cropcategories) * p_data_gridunits(gridunits_10_n12, sub_cropcategories) + 0.1)))
                                 +  sum((gridunits_10_n23, sub_cropcategories) $ sub_regions_gridunits_10_n23(gridunits_10_n23),
                                                                            sqr((v_data_gridunits(gridunits_10_n23, sub_cropcategories) - p_data_gridunits(gridunits_10_n23, sub_cropcategories))
                                                                  /(p_std_gridunits(gridunits_10_n23, sub_cropcategories) * p_data_gridunits(gridunits_10_n23, sub_cropcategories) + 0.1)));


model multi_table /zeilensummen_nuts23
                    zeilensummen_gridunits_60
                    zeilensummen_gridunits_20
                    zeilensummen_gridunits_10
                    zeilensummen_gridunits_10_n23
                    spaltensummen_n23_n12
                    spaltensummen_gridunits60_n12
                    spaltensummen_gridunits20_gridunits_60
                    spaltensummen_gridunits10_gridunits_20
                    spaltensummen_gridunits10n23_gridunits_10
                    spaltensummen_gridunits10n23_nuts2_3
                    opt_hpd_multi/;
multi_table.OptFile = 1;

multi_table.limrow = 0;
multi_table.limcol = 0;
multi_table.solprint = 0;

#*********** STARTING LOOP FOR SOLVING *************
# Doing it for all data at once caused memory problems, as the gridunits have a huge amount of data
# Therefore we have a loop over all nuts1_2 and kill all unneeded  data directly after reading in.

scalar variante;

loop(n0,
# loop(n0 $ (sameas(n0, "IT")),
   loop(n1_2 $ nuts_mappings(n0, n1_2),
#   loop(n1_2 $ sameas("AT11", n1_2),

    #****** filling sets for the loop **********
    super_region_n12(n1_2_alias) = NO;;
    super_region_n12(n1_2) = YES;

    sub_regions_nuts2_3(n2_3) = NO;
    sub_regions_nuts2_3(n2_3) = YES $ nuts_mappings(super_region_n12, n2_3);

    sub_regions_gridunits_60_n12(gridunits_60_n12) = NO;
    sub_regions_gridunits_60_n12(gridunits_60_n12) = YES $ mappings_gridunits_levelwise(super_region_n12, gridunits_60_n12);

    sub_regions_gridunits_20_n12(gridunits_20_n12) = NO;
    sub_regions_gridunits_20_n12(gridunits_20_n12) = YES $ mappings_nuts1_2_gridunits_20(super_region_n12, gridunits_20_n12);

    sub_regions_gridunits_10_n12(gridunits_10_n12) = NO;
    sub_regions_gridunits_10_n12(gridunits_10_n12) = YES $ mappings_nuts1_2_gridunits_10(super_region_n12, gridunits_10_n12);

    sub_regions_gridunits_10_n23(gridunits_10_n23) = NO;
    sub_regions_gridunits_10_n23(gridunits_10_n23) = YES $ mappings_nuts1_2_gridunits_10_n23(super_region_n12, gridunits_10_n23);

    #***** reading in data *******

    execute_load "./data/data_gridunits.gdx"  data_gridunits_10, data_gridunits_20, data_gridunits_60;
    
    #***** filtering needed data and set std values ********
    v_data_gridunits.l(sub_regions_gridunits_10_n12, cropcategories) = data_gridunits_10(sub_regions_gridunits_10_n12, "ha", cropcategories);
    v_data_gridunits.l(sub_regions_gridunits_20_n12, cropcategories) = data_gridunits_20(sub_regions_gridunits_20_n12, "ha", cropcategories);
    v_data_gridunits.l(sub_regions_gridunits_60_n12, cropcategories) = data_gridunits_60(sub_regions_gridunits_60_n12, "ha", cropcategories);
    v_data_gridunits.lo(sub_regions_gridunits_10_n12, cropcategories) = 0;
    v_data_gridunits.lo(sub_regions_gridunits_20_n12, cropcategories) = 0;
    v_data_gridunits.lo(sub_regions_gridunits_60_n12, cropcategories) = 0;
    v_data_gridunits.lo(sub_regions_gridunits_10_n23, cropcategories) = 0;
    p_std_gridunits(sub_regions_gridunits_10_n12, cropcategories) $ (data_gridunits_10(sub_regions_gridunits_10_n12, "flg", cropcategories) = 0)= 0.01;
    p_std_gridunits(sub_regions_gridunits_20_n12, cropcategories) $ (data_gridunits_20(sub_regions_gridunits_20_n12, "flg", cropcategories) = 0)= 0.01;
    p_std_gridunits(sub_regions_gridunits_60_n12, cropcategories) $ (data_gridunits_60(sub_regions_gridunits_60_n12, "flg", cropcategories) = 0)= 0.01;
    p_std_gridunits(sub_regions_gridunits_10_n12, cropcategories) $ (p_std_gridunits(sub_regions_gridunits_10_n12, cropcategories) ne 0.01) = 0.05;
    p_std_gridunits(sub_regions_gridunits_20_n12, cropcategories) $ (p_std_gridunits(sub_regions_gridunits_20_n12, cropcategories) ne 0.01) = 0.05;
    p_std_gridunits(sub_regions_gridunits_60_n12, cropcategories) $ (p_std_gridunits(sub_regions_gridunits_60_n12, cropcategories) ne 0.01) = 0.05;
    p_std_gridunits(sub_regions_gridunits_10_n23, cropcategories) = 0.05;

    Option Clear = data_gridunits_10;
    Option Clear = data_gridunits_20;
    Option Clear = data_gridunits_60;


    #****** calculate startvalues for solving AGRAREA *********

    execute_unload  "./analysis/vor_startwerten.gdx"  v_data_nuts, v_data_gridunits;

    needed_agrarea = v_data_nuts.l(n1_2, "AGRAREA");
    variante = 0;
    sum_agrarea = sum(sub_regions_gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, sub_regions_gridunits_60_n12), v_data_gridunits.l(sub_regions_gridunits_60_n12, "AGRAREA"));
    sum_for_shares_agrarea = sum(sub_regions_gridunits_60_n12 $ (mappings_gridunits_levelwise(n1_2, sub_regions_gridunits_60_n12) AND (p_std_gridunits(sub_regions_gridunits_60_n12, "AGRAREA") = 0.05)),
                                                    upper_bounds(sub_regions_gridunits_60_n12));
    if(sum_for_shares_agrarea = 0,
        display "bing1";
        sum_for_shares_agrarea = sum(sub_regions_gridunits_60_n12 $ (mappings_gridunits_levelwise(n1_2, sub_regions_gridunits_60_n12) AND (p_std_gridunits(sub_regions_gridunits_60_n12, "AGRAREA") = 0.05)),
                                                    total_area(sub_regions_gridunits_60_n12));
        variante = 1;
    );
    if((sum_for_shares_agrarea ne 0) AND ((needed_agrarea - sum_agrarea) gt 0),
        loop(sub_regions_gridunits_60_n12 $ (mappings_gridunits_levelwise(n1_2, sub_regions_gridunits_60_n12) AND (p_std_gridunits(sub_regions_gridunits_60_n12, "AGRAREA") = 0.05)),
            if(variante = 0,
                  v_data_gridunits.l(sub_regions_gridunits_60_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_60_n12, "AGRAREA") +
                                  (needed_agrarea - sum_agrarea) * (upper_bounds(sub_regions_gridunits_60_n12) / sum_for_shares_agrarea);
            else
                  v_data_gridunits.l(sub_regions_gridunits_60_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_60_n12, "AGRAREA") +
                                  (needed_agrarea - sum_agrarea) * (total_area(sub_regions_gridunits_60_n12) / sum_for_shares_agrarea);
            );
        );
    );

    needed_agrarea = v_data_nuts.l(n1_2, "AGRAREA");
    variante = 0;
    sum_agrarea = sum(sub_regions_nuts2_3 $ nuts_mappings(n1_2, sub_regions_nuts2_3), v_data_nuts.l(sub_regions_nuts2_3, "AGRAREA"));
    sum_for_shares_agrarea = sum(sub_regions_nuts2_3 $ (nuts_mappings(n1_2, sub_regions_nuts2_3) AND (p_std_nuts(sub_regions_nuts2_3, "AGRAREA") = 0.05)),
                                                    upper_bounds(sub_regions_nuts2_3));
    if(sum_for_shares_agrarea = 0,
        display "bing2";
        sum_for_shares_agrarea = sum(sub_regions_nuts2_3 $ (nuts_mappings(n1_2, sub_regions_nuts2_3) AND (p_std_nuts(sub_regions_nuts2_3, "AGRAREA") = 0.05)),
                                                    total_area(sub_regions_nuts2_3));
        variante = 1;
    );
    if((sum_for_shares_agrarea ne 0) AND ((needed_agrarea - sum_agrarea) gt 0),
        loop(sub_regions_nuts2_3 $ (nuts_mappings(n1_2, sub_regions_nuts2_3) AND (p_std_nuts(sub_regions_nuts2_3, "AGRAREA") = 0.05)),
            if(variante = 0,
                  v_data_nuts.l(sub_regions_nuts2_3, "AGRAREA") = v_data_nuts.l(sub_regions_nuts2_3, "AGRAREA") +
                          (needed_agrarea - sum_agrarea) * (upper_bounds(sub_regions_nuts2_3) / sum_for_shares_agrarea);
            else
                  v_data_nuts.l(sub_regions_nuts2_3, "AGRAREA") = v_data_nuts.l(sub_regions_nuts2_3, "AGRAREA") +
                          (needed_agrarea - sum_agrarea) * (total_area(sub_regions_nuts2_3) / sum_for_shares_agrarea);
            );
        );
    );

    loop(sub_regions_gridunits_60_n12,
          needed_agrarea = v_data_gridunits.l(sub_regions_gridunits_60_n12, "AGRAREA");
          variante = 0;
          sum_agrarea = sum(sub_regions_gridunits_20_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12), v_data_gridunits.l(sub_regions_gridunits_20_n12, "AGRAREA"));
          sum_for_shares_agrarea = sum(sub_regions_gridunits_20_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12) AND (p_std_gridunits(sub_regions_gridunits_20_n12, "AGRAREA") = 0.05)),
                                                            upper_bounds(sub_regions_gridunits_20_n12));
          if(sum_for_shares_agrarea = 0,
                  display "bing3";
                  sum_for_shares_agrarea = sum(sub_regions_gridunits_20_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12) AND (p_std_gridunits(sub_regions_gridunits_20_n12, "AGRAREA") = 0.05)),
                                                            total_area(sub_regions_gridunits_20_n12));
                  variante = 1;
          );
          if((sum_for_shares_agrarea ne 0) AND ((needed_agrarea - sum_agrarea) gt 0),
              loop(sub_regions_gridunits_20_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12) AND (p_std_gridunits(sub_regions_gridunits_20_n12, "AGRAREA") = 0.05)),
                  if(variante = 0,
                        v_data_gridunits.l(sub_regions_gridunits_20_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_20_n12, "AGRAREA") +
                                          (needed_agrarea - sum_agrarea) * (upper_bounds(sub_regions_gridunits_20_n12) / sum_for_shares_agrarea);
                  else
                        v_data_gridunits.l(sub_regions_gridunits_20_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_20_n12, "AGRAREA") +
                                          (needed_agrarea - sum_agrarea) * (total_area(sub_regions_gridunits_20_n12) / sum_for_shares_agrarea);
                  );
              );
          );
    );

    loop(sub_regions_gridunits_20_n12,
          needed_agrarea = v_data_gridunits.l(sub_regions_gridunits_20_n12, "AGRAREA");
          variante = 0;
          sum_agrarea = sum(sub_regions_gridunits_10_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12), v_data_gridunits.l(sub_regions_gridunits_10_n12, "AGRAREA"));
          sum_for_shares_agrarea = sum(sub_regions_gridunits_10_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12) AND (p_std_gridunits(sub_regions_gridunits_10_n12, "AGRAREA") = 0.05)),
                                                            upper_bounds(sub_regions_gridunits_10_n12));
          if(sum_for_shares_agrarea = 0,
                  display "bing4";
                  sum_for_shares_agrarea = sum(sub_regions_gridunits_10_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12) AND (p_std_gridunits(sub_regions_gridunits_10_n12, "AGRAREA") = 0.05)),
                                                            total_area(sub_regions_gridunits_10_n12));
                  variante = 1;
          );
          if((sum_for_shares_agrarea ne 0)  AND ((needed_agrarea - sum_agrarea) gt 0),
              loop(sub_regions_gridunits_10_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12) AND (p_std_gridunits(sub_regions_gridunits_10_n12, "AGRAREA") = 0.05)),
                  if(variante = 0,
                        v_data_gridunits.l(sub_regions_gridunits_10_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_10_n12, "AGRAREA") +
                                  (needed_agrarea - sum_agrarea) * (upper_bounds(sub_regions_gridunits_10_n12) / sum_for_shares_agrarea);
                  else
                        v_data_gridunits.l(sub_regions_gridunits_10_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_10_n12, "AGRAREA") +
                                  (needed_agrarea - sum_agrarea) * (total_area(sub_regions_gridunits_10_n12) / sum_for_shares_agrarea);
                  );
              );
          );
    );

    loop(sub_regions_gridunits_10_n12,
          needed_agrarea = v_data_gridunits.l(sub_regions_gridunits_10_n12, "AGRAREA");    
          if(sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23),1) = 1,
                  v_data_gridunits.l(sub_regions_gridunits_10_n23, "AGRAREA") $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23) = needed_agrarea;
          else
                  variante = 0;
                  sum_agrarea = sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23), v_data_gridunits.l(sub_regions_gridunits_10_n23, "AGRAREA"));
                  sum_for_shares_agrarea = sum(sub_regions_gridunits_10_n23 $ (mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23) AND (p_std_gridunits(sub_regions_gridunits_10_n23, "AGRAREA") = 0.05)),
                                                            upper_bounds(sub_regions_gridunits_10_n23));
                  if(sum_for_shares_agrarea = 0,
                          display "bing5";
                          sum_for_shares_agrarea = sum(sub_regions_gridunits_10_n23 $ (mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23) AND (p_std_gridunits(sub_regions_gridunits_10_n23, "AGRAREA") = 0.05)),
                                                            total_area(sub_regions_gridunits_10_n23));
                          variante = 1;
                  );
                  if((sum_for_shares_agrarea ne 0)  AND ((needed_agrarea - sum_agrarea) gt 0),
                          loop(sub_regions_gridunits_10_n23 $ (mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23) AND (p_std_gridunits(sub_regions_gridunits_10_n23, "AGRAREA") = 0.05)),
                                  if(variante = 0,
                                          v_data_gridunits.l(sub_regions_gridunits_10_n23, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_10_n23, "AGRAREA") +
                                                          (needed_agrarea - sum_agrarea) * (upper_bounds(sub_regions_gridunits_10_n23) / sum_for_shares_agrarea);
                                  else
                                          v_data_gridunits.l(sub_regions_gridunits_10_n23, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_10_n23, "AGRAREA") +
                                                          (needed_agrarea - sum_agrarea) * (total_area(sub_regions_gridunits_10_n23) / sum_for_shares_agrarea);
                                  );
                          );
                  );
          );
    );

    execute_unload  "./analysis/nach_startwerten.gdx"  v_data_nuts, v_data_gridunits;

    p_data_gridunits(all_gridunits, cropcategories) = v_data_gridunits.l(all_gridunits, cropcategories);
    p_data_nuts(n2_3, "AGRAREA") = v_data_nuts.l(n2_3, "AGRAREA");

    solve table_agrarea USING DNLP MINIMIZING v_hpd_agrarea;

    execute_unload  "./analysis/nach_solve.gdx"  v_data_nuts, v_data_gridunits;


    v_data_nuts.fx(sub_regions_nuts2_3, "AGRAREA") = v_data_nuts.l(sub_regions_nuts2_3, "AGRAREA");
    v_data_gridunits.fx(sub_regions_gridunits_10_n23, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_10_n23, "AGRAREA");
    v_data_gridunits.fx(sub_regions_gridunits_10_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_10_n12, "AGRAREA");
    v_data_gridunits.fx(sub_regions_gridunits_20_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_20_n12, "AGRAREA");
    v_data_gridunits.fx(sub_regions_gridunits_60_n12, "AGRAREA") = v_data_gridunits.l(sub_regions_gridunits_60_n12, "AGRAREA");


    needed_livestock = v_data_nuts.l(n1_2, "C_LIVEST_L");
    sum_livestock = sum(sub_regions_gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, sub_regions_gridunits_60_n12), v_data_gridunits.l(sub_regions_gridunits_60_n12, "C_LIVEST_L"));
    sum_for_shares_livestock = sum(sub_regions_gridunits_60_n12 $ (mappings_gridunits_levelwise(n1_2, sub_regions_gridunits_60_n12) AND (p_std_gridunits(sub_regions_gridunits_60_n12, "C_LIVEST_L") = 0.05)),
                                                        area(sub_regions_gridunits_60_n12, "total"));
    if((sum_for_shares_livestock ne 0) AND ((needed_livestock - sum_livestock) gt 0),
        loop(sub_regions_gridunits_60_n12 $ (mappings_gridunits_levelwise(n1_2, sub_regions_gridunits_60_n12) AND (p_std_gridunits(sub_regions_gridunits_60_n12, "C_LIVEST_L") = 0.05)),
                v_data_gridunits.l(sub_regions_gridunits_60_n12, "C_LIVEST_L") = v_data_gridunits.l(sub_regions_gridunits_60_n12, "C_LIVEST_L") +
                                 (needed_livestock - sum_livestock) * (area(sub_regions_gridunits_60_n12, "total") / sum_for_shares_livestock)
        );
    );


    needed_livestock = v_data_nuts.l(n1_2, "C_LIVEST_L");
    sum_livestock = sum(sub_regions_nuts2_3 $ nuts_mappings(n1_2, sub_regions_nuts2_3), v_data_nuts.l(sub_regions_nuts2_3, "C_LIVEST_L"));
    sum_for_shares_livestock = sum(sub_regions_nuts2_3 $ (nuts_mappings(n1_2, sub_regions_nuts2_3) AND (p_std_nuts(sub_regions_nuts2_3, "C_LIVEST_L") = 0.05)),
                                                    area(sub_regions_nuts2_3, "total"));
    if((sum_for_shares_livestock ne 0) AND ((needed_livestock - sum_livestock) gt 0),
        loop(sub_regions_nuts2_3 $ (nuts_mappings(n1_2, sub_regions_nuts2_3) AND (p_std_nuts(sub_regions_nuts2_3, "C_LIVEST_L") = 0.05)),
                v_data_nuts.l(sub_regions_nuts2_3, "C_LIVEST_L") =  v_data_nuts.l(sub_regions_nuts2_3, "C_LIVEST_L") +
                                 (needed_livestock - sum_livestock) * (area(sub_regions_nuts2_3, "total") / sum_for_shares_livestock)
        );
    );


    loop(sub_regions_gridunits_60_n12,
         needed_livestock = v_data_gridunits.l(sub_regions_gridunits_60_n12, "C_LIVEST_L");
         sum_livestock = sum(sub_regions_gridunits_20_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12), v_data_gridunits.l(sub_regions_gridunits_20_n12, "C_LIVEST_L"));
         sum_for_shares_livestock = sum(sub_regions_gridunits_20_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12) AND (p_std_gridunits(sub_regions_gridunits_20_n12, "C_LIVEST_L") = 0.05)),
                                                                  area(sub_regions_gridunits_20_n12, "total"));
         if((sum_for_shares_livestock ne 0) AND ((needed_livestock - sum_livestock) gt 0),
             loop(sub_regions_gridunits_20_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12) AND (p_std_gridunits(sub_regions_gridunits_20_n12, "C_LIVEST_L") = 0.05)),
                   v_data_gridunits.l(sub_regions_gridunits_20_n12, "C_LIVEST_L") = v_data_gridunits.l(sub_regions_gridunits_20_n12, "C_LIVEST_L") +
                                 (needed_livestock - sum_livestock) * (area(sub_regions_gridunits_20_n12, "total") / sum_for_shares_livestock)
             );
         );
    );

    loop(sub_regions_gridunits_20_n12,
         needed_livestock = v_data_gridunits.l(sub_regions_gridunits_20_n12, "C_LIVEST_L");
         sum_livestock = sum(sub_regions_gridunits_10_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12), v_data_gridunits.l(sub_regions_gridunits_10_n12, "C_LIVEST_L"));
         sum_for_shares_livestock = sum(sub_regions_gridunits_10_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12) AND (p_std_gridunits(sub_regions_gridunits_10_n12, "C_LIVEST_L") = 0.05)),
                                                            area(sub_regions_gridunits_10_n12, "total"));
         if((sum_for_shares_livestock ne 0)  AND ((needed_livestock - sum_livestock) gt 0),
             loop(sub_regions_gridunits_10_n12 $ (mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12) AND (p_std_gridunits(sub_regions_gridunits_10_n12, "C_LIVEST_L") = 0.05)),
                   v_data_gridunits.l(sub_regions_gridunits_10_n12, "C_LIVEST_L") = v_data_gridunits.l(sub_regions_gridunits_10_n12, "C_LIVEST_L") +
                                 (needed_livestock - sum_livestock) * (area(sub_regions_gridunits_10_n12, "total") / sum_for_shares_livestock)
             );
         );
    );

    loop(sub_regions_gridunits_10_n12,
         needed_livestock = v_data_gridunits.l(sub_regions_gridunits_10_n12, "C_LIVEST_L");
         sum_livestock = sum(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23), v_data_gridunits.l(sub_regions_gridunits_10_n23, "C_LIVEST_L"));
         sum_for_shares_livestock = sum(sub_regions_gridunits_10_n23 $ (mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23) AND (p_std_gridunits(sub_regions_gridunits_10_n23, "C_LIVEST_L") = 0.05)),
                                                           area(sub_regions_gridunits_10_n23, "total"));
         if((sum_for_shares_livestock ne 0)  AND ((needed_livestock - sum_livestock) gt 0),
             loop(sub_regions_gridunits_10_n23 $ (mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23) AND (p_std_gridunits(sub_regions_gridunits_10_n23, "C_LIVEST_L") = 0.05)),
                   v_data_gridunits.l(sub_regions_gridunits_10_n23, "C_LIVEST_L") =  v_data_gridunits.l(sub_regions_gridunits_10_n23, "C_LIVEST_L") +
                                 (needed_livestock - sum_livestock) * (area(sub_regions_gridunits_10_n23, "total") / sum_for_shares_livestock)
             );
         );
    );

    p_data_gridunits(all_gridunits, cropcategories) = v_data_gridunits.l(all_gridunits, cropcategories);
    p_data_nuts(n2_3, "C_LIVEST_L") = v_data_nuts.l(n2_3, "C_LIVEST_L");

    solve table_livestock USING DNLP MINIMIZING v_hpd_livestock;

    v_data_nuts.fx(sub_regions_nuts2_3, "C_LIVEST_L") = v_data_nuts.l(sub_regions_nuts2_3, "C_LIVEST_L");
    v_data_gridunits.fx(sub_regions_gridunits_10_n23, "C_LIVEST_L") = v_data_gridunits.l(sub_regions_gridunits_10_n23, "C_LIVEST_L");
    v_data_gridunits.fx(sub_regions_gridunits_10_n12, "C_LIVEST_L") = v_data_gridunits.l(sub_regions_gridunits_10_n12, "C_LIVEST_L");
    v_data_gridunits.fx(sub_regions_gridunits_20_n12, "C_LIVEST_L") = v_data_gridunits.l(sub_regions_gridunits_20_n12, "C_LIVEST_L");
    v_data_gridunits.fx(sub_regions_gridunits_60_n12, "C_LIVEST_L") = v_data_gridunits.l(sub_regions_gridunits_60_n12, "C_LIVEST_L");

    # execute_unload "test%system.incline%.gdx" v_data_nuts,v_data_gridunits,results_gridunits,sub_regions_gridunits_10_n23,cropcategories;


    loop(hierarchy_0,
        if(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1),
          $$batinclude "solve_parallel_tables.gms" "h0"
        );
    );


    loop(hierarchy_1,
        if(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1),
          $$batinclude "solve_parallel_tables.gms" "h1"
        );
    );

    loop(hierarchy_2,
        if(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1),
          $$batinclude "solve_parallel_tables.gms" "h2"
        );
    );

    loop(hierarchy_3,
        if(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1),
          $$batinclude "solve_parallel_tables.gms" "h3"
        );
    );

    loop(hierarchy_4,
        if(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1),
          $$batinclude "solve_parallel_tables.gms" "h4"
        );
    );

    #****** add newly calculated resulst to results of earlier loopiterations
    execute_load "./results/results_gridunits.gdx" results_gridunits;
    results_gridunits(sub_regions_gridunits_10_n23, cropcategories) = v_data_gridunits.l(sub_regions_gridunits_10_n23, cropcategories);
    results_gridunits(sub_regions_gridunits_10_n12, cropcategories) = v_data_gridunits.l(sub_regions_gridunits_10_n12, cropcategories);
    results_gridunits(sub_regions_gridunits_20_n12, cropcategories) = v_data_gridunits.l(sub_regions_gridunits_20_n12, cropcategories);
    results_gridunits(sub_regions_gridunits_60_n12, cropcategories) = v_data_gridunits.l(sub_regions_gridunits_60_n12, cropcategories);
    # execute_unload "test%system.incline%.gdx" v_data_nuts,v_data_gridunits,results_gridunits,sub_regions_gridunits_10_n23,cropcategories;
    execute_unload "./results/results_gridunits.gdx" results_gridunits;
    Option Clear = results_gridunits;
    Option Clear = v_data_gridunits;

    execute_load "./results/data_nuts_results.gdx" data_nuts_results;
    data_nuts_results(sub_regions_nuts2_3, cropcategories) = v_data_nuts.l(sub_regions_nuts2_3, cropcategories)
    execute_unload "./results/data_nuts_results.gdx" data_nuts_results;
    Option Clear = data_nuts_results;
  );

  execute_load "./results/results_gridunits.gdx" results_gridunits;
  put_utility batch 'gdxout' / "./results/fss2010grid_" n0.tl:2 ".gdx";
      execute_unload results_gridunits;
  put_utility batch 'shell' / 'exec gams ./check_results.gms -logOption=2 --checkcountry=' n0.tl:2
  execute_unload "./results/results_gridunits.gdx" results_gridunits;
  option kill = results_gridunits;
);


$stop





