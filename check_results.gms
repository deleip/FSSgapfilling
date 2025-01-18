******************************************************************
**************** CHECK IF OTHER PROGRAM IS CORRECT  **************
******************************************************************

$onlisting
$stars ;;;;
$oninline


******** READ IN CROPCATEGORIES **********
$offlisting
$include "./sets/cropcategories.txt"

set hierarchy_0(cropcategories) /AGRAREA, C_LIVEST_L/;
set hierarchy_1(cropcategories) /'B_1','B_2','B_3', 'B_4'
                                C_1_3L, C_4_5_6L/;
*                                 C_1_3L, C_4L, C_5L, C_6L/;
set hierarchy_2(cropcategories) /'B_1_1','B_1_2' ,'B_1_345', 'B_1_6','B_1_7','B_1_8',
                                         'B_1_9','B_1_10_11','B_1_12'
                            'B_3_1','B_3_2' ,'B_3_3'
                            'B_4_1','B_4_2' ,'B_4_3' ,'B_4_4','B_4_5','B_4_6','B_4_7'
                            C_1L, C_21399L, C_4L, C_5L, C_6L/;
*                               C_1L, C_21399L, C_4_1L, C_4_2L, C_4_99L, C_5_1L, C_5_2L, C_5_3L  /;
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
                            C_2L, C_3L, C_4_1L, C_4_2L, C_4_99L, C_5_1L, C_5_2L, C_5_3L/;
*                             C_2L, C_3L/;
set hierarchy_4(cropcategories) / 'B_1_6_7', 'B_1_6_8', 'B_1_6_9', 'B_1_6_10', 'B_1_6_11'
                            'B_1_7_1_1','B_1_7_1_2'
                            'B_1_9_2_1','B_1_9_2_2_99'
                            'B_4_1_1_1','B_4_1_1_2'
                            C_2_1_2_5L, C_2_6_99L, C_3_1L, C_3_2L/;
set hierarchy_5(cropcategories) /B_1_9_2_2, B_1_9_2_99
                                C_2_1L, C_2_2L, C_2_3L, C_2_4L, C_2_5L, C_2_6L, C_2_99L,C_3_1_1L, C_3_1_99L, C_3_2_1L, C_3_2_99L/;


set hierarchy_mappings(cropcategories, cropcategories) /
$include "./sets/crop_sets_d.txt"
/;

$log /read in croptypes/;
******** READ IN REGIONS **********
$offlisting 
$include "./sets/all_reg_to_define_mappings.txt"
$include "./sets/all_reg.txt"
$include "./sets/all_nuts.txt"
$include "./sets/n0.txt"
$include "./sets/n1_2.txt"
$include "./sets/n2_3.txt"
$include "./sets/all_gridunits_to_define_mappings.txt"
$include "./sets/all_gridunits.txt"
$include "./sets/gridunits_10_n23.txt"
$include "./sets/gridunits_10_n12.txt"
$include "./sets/gridunits_20_n12.txt"
$include "./sets/gridunits_60_n12.txt"


*mappings between different region levels
$include "./sets/nuts_mappings.txt"
$include "./sets/mappings_gridunits_levelwise.txt"
$include "./sets/mappings_nuts1_2_gridunits_20.txt"
$include "./sets/mappings_nuts1_2_gridunits_10.txt"
$include "./sets/mappings_nuts1_2_gridunits_10_n23.txt"
$include "./sets/mappings_gridunits_10_n23.txt"

$include "./sets/mappings_n12.txt"
$onlisting

***********************************

file put_errors /"./testing/discrepancies_%checkcountry%.txt"/;

put put_errors ;


***********************************

parameter results_gridunits(all_gridunits, cropcategories)
          data_nuts_results(all_nuts, cropcategories)
          data_nuts(all_nuts, cropcategories);
variable v_data_nuts(all_nuts, cropcategories);
variable v_data(all_nuts, cropcategories);
execute_load "./results/fss2010grid_%checkcountry%.gdx" results_gridunits;
execute_load "./results/data_nuts_results.gdx" data_nuts_results;

data_nuts(all_nuts, cropcategories) = data_nuts_results(all_nuts, cropcategories);

***********************************



***********************************
alias (n1_2, n1_2_alias);
scalar i;
scalar cut /1.e-4/
singleton set test(gridunits_10_n12);
alias (gridunits_10_n12, gridunits_10_n12_alias);

put "GEFUNDENE FEHLER (groesser als)" cut ":"/ / / ;

*loop(n1_2_alias $ sameas("FR61", n1_2_alias) ,
*loop(n1_2_alias $ (nuts_mappings("AT", n1_2_alias)),
loop(n0all $ sameas("%checkcountry%", n0all),
    put / / n0all.tl ":" / /
    loop(hierarchy_0,
       if((sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1) AND
                 (abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), data_nuts(n0all, hierarchy_1)) - data_nuts(n0all, hierarchy_0)) ge cut)),
          i = abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), data_nuts(n0all, hierarchy_1)) - data_nuts(n0all, hierarchy_0));
          put "The sum of the sub cropcategories of " hierarchy_0.tl " does not fit " hierarchy_0.tl " in the region " n0all.tl ":" i/;
       );
    );
    loop(hierarchy_1,
       if((sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1) AND
                 (abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), data_nuts(n0all, hierarchy_2)) - data_nuts(n0all, hierarchy_1)) ge cut)),
          i = abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), data_nuts(n0all, hierarchy_2)) - data_nuts(n0all, hierarchy_1));
          put "The sum of the sub cropcategories of " hierarchy_1.tl " does not fit " hierarchy_1.tl " in the region " n0all.tl ":" i/;
       );
    );
    loop(hierarchy_2,
       if((sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1) AND
                 (abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), data_nuts(n0all, hierarchy_3)) - data_nuts(n0all, hierarchy_2)) ge cut)),
          i = abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), data_nuts(n0all, hierarchy_3)) - data_nuts(n0all, hierarchy_2));
          put "The sum of the sub cropcategories of " hierarchy_2.tl " does not fit " hierarchy_2.tl " in the region " n0all.tl ":" i/;
       );
    );
    loop(hierarchy_3,
       if((sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1) AND
                 (abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), data_nuts(n0all, hierarchy_4)) - data_nuts(n0all, hierarchy_3)) ge cut)),
          i = abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), data_nuts(n0all, hierarchy_4)) - data_nuts(n0all, hierarchy_3));
          put "The sum of the sub cropcategories of " hierarchy_3.tl " does not fit " hierarchy_3.tl " in the region " n0all.tl ":" i/;
       );
    );
    loop(hierarchy_4,
       if((sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1) AND
                 (abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), data_nuts(n0all, hierarchy_5)) - data_nuts(n0all, hierarchy_4)) ge cut)),
          i = abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), data_nuts(n0all, hierarchy_5)) - data_nuts(n0all, hierarchy_4));
          put "The sum of the sub cropcategories of " hierarchy_4.tl " does not fit " hierarchy_4.tl " in the region " n0all.tl ":" i/;
       );
    );
);


loop(n1_2 $ (nuts_mappings("%checkcountry%", n1_2)),
  
  put / / n1_2.tl ":" / /

  loop(hierarchy_0,
      if((sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1) AND
                (abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), data_nuts(n1_2, hierarchy_1)) - data_nuts(n1_2, hierarchy_0)) ge cut)),
        i = abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), data_nuts(n1_2, hierarchy_1)) - data_nuts(n1_2, hierarchy_0));
        put "The sum of the sub cropcategories of " hierarchy_0.tl " does not fit " hierarchy_0.tl " in the region " n1_2.tl ":" i/;
      );
  );
  loop(hierarchy_1,
      if((sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1) AND
                (abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), data_nuts(n1_2, hierarchy_2)) - data_nuts(n1_2, hierarchy_1)) ge cut)),
        i = abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), data_nuts(n1_2, hierarchy_2)) - data_nuts(n1_2, hierarchy_1));
        put "The sum of the sub cropcategories of " hierarchy_1.tl " does not fit " hierarchy_1.tl " in the region " n1_2.tl ":" i/;
      );
  );
  loop(hierarchy_2,
      if((sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1) AND
                (abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), data_nuts(n1_2, hierarchy_3)) - data_nuts(n1_2, hierarchy_2)) ge cut)),
        i = abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), data_nuts(n1_2, hierarchy_3)) - data_nuts(n1_2, hierarchy_2));
        put "The sum of the sub cropcategories of " hierarchy_2.tl " does not fit " hierarchy_2.tl " in the region " n1_2.tl ":" i/;
      );
  );
  loop(hierarchy_3,
      if((sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1) AND
                (abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), data_nuts(n1_2, hierarchy_4)) - data_nuts(n1_2, hierarchy_3)) ge cut)),
        i = abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), data_nuts(n1_2, hierarchy_4)) - data_nuts(n1_2, hierarchy_3));
        put "The sum of the sub cropcategories of " hierarchy_3.tl " does not fit " hierarchy_3.tl " in the region " n1_2.tl ":" i/;
      );
  );
  loop(hierarchy_4,
      if((sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1) AND
                (abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), data_nuts(n1_2, hierarchy_5)) - data_nuts(n1_2, hierarchy_4)) ge cut)),
        i = abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), data_nuts(n1_2, hierarchy_5)) - data_nuts(n1_2, hierarchy_4));
        put "The sum of the sub cropcategories of " hierarchy_4.tl " does not fit " hierarchy_4.tl " in the region " n1_2.tl ":" i/;
      );
  );

  loop(n2_3 $ mappings_n12(n1_2, n2_3),
      loop(hierarchy_0,
        if((sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1) AND
                  (abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), data_nuts(n2_3, hierarchy_1)) - data_nuts(n2_3, hierarchy_0)) ge cut)),
            i = abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), data_nuts(n2_3, hierarchy_1)) - data_nuts(n2_3, hierarchy_0));
            put "The sum of the sub cropcategories of " hierarchy_0.tl " does not fit " hierarchy_0.tl " in the region " n2_3.tl ":" i /;
        );
      );
      loop(hierarchy_1,
        if((sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1) AND
                  (abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), data_nuts(n2_3, hierarchy_2)) - data_nuts(n2_3, hierarchy_1)) ge cut)),
            i = abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), data_nuts(n2_3, hierarchy_2)) - data_nuts(n2_3, hierarchy_1));
            put "The sum of the sub cropcategories of " hierarchy_1.tl " does not fit " hierarchy_1.tl " in the region " n2_3.tl ":" i /;
        );
      );
      loop(hierarchy_2,
        if((sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1) AND
                  (abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), data_nuts(n2_3, hierarchy_3)) - data_nuts(n2_3, hierarchy_2)) ge cut)),
            put "The sum of the sub cropcategories of " hierarchy_2.tl " does not fit " hierarchy_2.tl " in the region " n2_3.tl ":" i /;
            i = abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), data_nuts(n2_3, hierarchy_3)) - data_nuts(n2_3, hierarchy_2));
        );
      );
      loop(hierarchy_3,
        if((sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1) AND
                  (abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), data_nuts(n2_3, hierarchy_4)) - data_nuts(n2_3, hierarchy_3)) ge cut)),
            i = abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), data_nuts(n2_3, hierarchy_4)) - data_nuts(n2_3, hierarchy_3));
            put "The sum of the sub cropcategories of " hierarchy_3.tl " does not fit " hierarchy_3.tl " in the region " n2_3.tl ":" i /;
        );
      );
      loop(hierarchy_4,
        if((sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1) AND
                  (abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), data_nuts(n2_3, hierarchy_5)) - data_nuts(n2_3, hierarchy_4)) ge cut)),
            i = abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), data_nuts(n2_3, hierarchy_5)) - data_nuts(n2_3, hierarchy_4));
            put "The sum of the sub cropcategories of " hierarchy_4.tl " does not fit " hierarchy_4.tl " in the region " n2_3.tl ":" i/;
        );
      );
  );


  loop(gridunits_60_n12 $ mappings_n12(n1_2, gridunits_60_n12),
      loop(hierarchy_0,
        if((sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1) AND
                  (abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_60_n12, hierarchy_1)) - results_gridunits(gridunits_60_n12, hierarchy_0)) ge cut)),
            i = abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_60_n12, hierarchy_1)) - results_gridunits(gridunits_60_n12, hierarchy_0));
            put "The sum of the sub cropcategories of " hierarchy_0.tl " does not fit " hierarchy_0.tl " in the region " gridunits_60_n12.tl ":" i /;
        );
      );
      loop(hierarchy_1,
        if((sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1) AND
                  (abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_60_n12, hierarchy_2)) - results_gridunits(gridunits_60_n12, hierarchy_1)) ge cut)),
            i = abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_60_n12, hierarchy_2)) - results_gridunits(gridunits_60_n12, hierarchy_1));
            put "The sum of the sub cropcategories of " hierarchy_1.tl " does not fit " hierarchy_1.tl " in the region " gridunits_60_n12.tl ":" i /;
        );
      );
      loop(hierarchy_2,
        if((sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1) AND
                  (abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_60_n12, hierarchy_3)) - results_gridunits(gridunits_60_n12, hierarchy_2)) ge cut)),
            i = abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_60_n12, hierarchy_3)) - results_gridunits(gridunits_60_n12, hierarchy_2));
            put "The sum of the sub cropcategories of " hierarchy_2.tl " does not fit " hierarchy_2.tl " in the region " gridunits_60_n12.tl ":" i /;
        );
      );
      loop(hierarchy_3,
        if((sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1) AND
                  (abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_60_n12, hierarchy_4)) - results_gridunits(gridunits_60_n12, hierarchy_3)) ge cut)),
            i = abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_60_n12, hierarchy_4)) - results_gridunits(gridunits_60_n12, hierarchy_3));
            put "The sum of the sub cropcategories of " hierarchy_3.tl " does not fit " hierarchy_3.tl " in the region " gridunits_60_n12.tl ":" i /;
        );
      );
      loop(hierarchy_4,
        if((sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1) AND
                  (abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_60_n12, hierarchy_5)) - results_gridunits(gridunits_60_n12, hierarchy_4)) ge cut)),
            i = abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_60_n12, hierarchy_5)) - results_gridunits(gridunits_60_n12, hierarchy_4));
            put "The sum of the sub cropcategories of " hierarchy_4.tl " does not fit " hierarchy_4.tl " in the region " gridunits_60_n12.tl ":" i /;
        );
      );
  );



  loop(gridunits_20_n12 $ mappings_n12(n1_2, gridunits_20_n12),
      loop(hierarchy_0,
        if((sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1) AND
                  (abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_20_n12, hierarchy_1)) - results_gridunits(gridunits_20_n12, hierarchy_0)) ge cut)),
            i = abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_20_n12, hierarchy_1)) - results_gridunits(gridunits_20_n12, hierarchy_0));
            put "The sum of the sub cropcategories of " hierarchy_0.tl " does not fit " hierarchy_0.tl " in the region " gridunits_20_n12.tl ":" i /;
        );
      );
      loop(hierarchy_1,
        if((sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1) AND
                  (abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_20_n12, hierarchy_2)) - results_gridunits(gridunits_20_n12, hierarchy_1)) ge cut)),
            i = abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_20_n12, hierarchy_2)) - results_gridunits(gridunits_20_n12, hierarchy_1));
            put "The sum of the sub cropcategories of " hierarchy_1.tl " does not fit " hierarchy_1.tl " in the region " gridunits_20_n12.tl ":" i /;
        );
      );
      loop(hierarchy_2,
        if((sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1) AND
                  (abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_20_n12, hierarchy_3)) - results_gridunits(gridunits_20_n12, hierarchy_2)) ge cut)),
            i = abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_20_n12, hierarchy_3)) - results_gridunits(gridunits_20_n12, hierarchy_2));
            put "The sum of the sub cropcategories of " hierarchy_2.tl " does not fit " hierarchy_2.tl " in the region " gridunits_20_n12.tl ":" i /;
        );
      );
      loop(hierarchy_3,
        if((sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1) AND
                  (abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_20_n12, hierarchy_4)) - results_gridunits(gridunits_20_n12, hierarchy_3)) ge cut)),
            i = abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_20_n12, hierarchy_4)) - results_gridunits(gridunits_20_n12, hierarchy_3));
            put "The sum of the sub cropcategories of " hierarchy_3.tl " does not fit " hierarchy_3.tl " in the region " gridunits_20_n12.tl ":" i /;
        );
      );
      loop(hierarchy_4,
        if((sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1) AND
                  (abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_20_n12, hierarchy_5)) - results_gridunits(gridunits_20_n12, hierarchy_4)) ge cut)),
            i = abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_20_n12, hierarchy_5)) - results_gridunits(gridunits_20_n12, hierarchy_4));
            put "The sum of the sub cropcategories of " hierarchy_4.tl " does not fit " hierarchy_4.tl " in the region " gridunits_20_n12.tl ":" i /;
        );
      );
  );


  loop(gridunits_10_n12 $ mappings_n12(n1_2, gridunits_10_n12),
      loop(hierarchy_0,
        if((sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1) AND
                  (abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_10_n12, hierarchy_1)) - results_gridunits(gridunits_10_n12, hierarchy_0)) ge cut)),
            i = abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_10_n12, hierarchy_1)) - results_gridunits(gridunits_10_n12, hierarchy_0));
            put "The sum of the sub cropcategories of " hierarchy_0.tl " does not fit " hierarchy_0.tl " in the region " gridunits_10_n12.tl ":" i /;
        );
      );
      loop(hierarchy_1,
        if((sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1) AND
                  (abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_10_n12, hierarchy_2)) - results_gridunits(gridunits_10_n12, hierarchy_1)) ge cut)),
            i = abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_10_n12, hierarchy_2)) - results_gridunits(gridunits_10_n12, hierarchy_1));
            put "The sum of the sub cropcategories of " hierarchy_1.tl " does not fit " hierarchy_1.tl " in the region " gridunits_10_n12.tl ":" i /;
        );
      );
      loop(hierarchy_2,
        if((sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1) AND
                  (abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_10_n12, hierarchy_3)) - results_gridunits(gridunits_10_n12, hierarchy_2)) ge cut)),
            i = abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_10_n12, hierarchy_3)) - results_gridunits(gridunits_10_n12, hierarchy_2));
            put "The sum of the sub cropcategories of " hierarchy_2.tl " does not fit " hierarchy_2.tl " in the region " gridunits_10_n12.tl ":" i /;
        );
      );
      loop(hierarchy_3,
        if((sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1) AND
                  (abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_10_n12, hierarchy_4)) - results_gridunits(gridunits_10_n12, hierarchy_3)) ge cut)),
            i = abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_10_n12, hierarchy_4)) - results_gridunits(gridunits_10_n12, hierarchy_3));
            put "The sum of the sub cropcategories of " hierarchy_3.tl " does not fit " hierarchy_3.tl " in the region " gridunits_10_n12.tl ":" i /;
        );
      );
      loop(hierarchy_4,
        if((sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1) AND
                  (abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_10_n12, hierarchy_5)) - results_gridunits(gridunits_10_n12, hierarchy_4)) ge cut)),
            i = abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_10_n12, hierarchy_5)) - results_gridunits(gridunits_10_n12, hierarchy_4));
            put "The sum of the sub cropcategories of " hierarchy_4.tl " does not fit " hierarchy_4.tl " in the region " gridunits_10_n12.tl ":" i /;
        );
      );
  );

  loop(gridunits_10_n23 $ mappings_n12(n1_2, gridunits_10_n23),
      loop(hierarchy_0,
        if((sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), 1) AND
                  (abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_10_n23, hierarchy_1)) - results_gridunits(gridunits_10_n23, hierarchy_0)) ge cut)),
            i = abs(sum(hierarchy_1 $ hierarchy_mappings(hierarchy_0, hierarchy_1), results_gridunits(gridunits_10_n23, hierarchy_1)) - results_gridunits(gridunits_10_n23, hierarchy_0));
            put "The sum of the sub cropcategories of " hierarchy_0.tl " does not fit " hierarchy_0.tl " in the region " gridunits_10_n23.tl ":" i /;
        );
      );
      loop(hierarchy_1,
        if((sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), 1) AND
                  (abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_10_n23, hierarchy_2)) - results_gridunits(gridunits_10_n23, hierarchy_1)) ge cut)),
            i = abs(sum(hierarchy_2 $ hierarchy_mappings(hierarchy_1, hierarchy_2), results_gridunits(gridunits_10_n23, hierarchy_2)) - results_gridunits(gridunits_10_n23, hierarchy_1));
            put "The sum of the sub cropcategories of " hierarchy_1.tl " does not fit " hierarchy_1.tl " in the region " gridunits_10_n23.tl ":" i /;
        );
      );
      loop(hierarchy_2,
        if((sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), 1) AND
                  (abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_10_n23, hierarchy_3)) - results_gridunits(gridunits_10_n23, hierarchy_2)) ge cut)),
            i = abs(sum(hierarchy_3 $ hierarchy_mappings(hierarchy_2, hierarchy_3), results_gridunits(gridunits_10_n23, hierarchy_3)) - results_gridunits(gridunits_10_n23, hierarchy_2));
            put "The sum of the sub cropcategories of " hierarchy_2.tl " does not fit " hierarchy_2.tl " in the region " gridunits_10_n23.tl ":" i /;
        );
      );
      loop(hierarchy_3,
        if((sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), 1) AND
                  (abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_10_n23, hierarchy_4)) - results_gridunits(gridunits_10_n23, hierarchy_3)) ge cut)),
            i = abs(sum(hierarchy_4 $ hierarchy_mappings(hierarchy_3, hierarchy_4), results_gridunits(gridunits_10_n23, hierarchy_4)) - results_gridunits(gridunits_10_n23, hierarchy_3));
            put "The sum of the sub cropcategories of " hierarchy_3.tl " does not fit " hierarchy_3.tl " in the region " gridunits_10_n23.tl ":" i /;
        );
      );
      loop(hierarchy_4,
        if((sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), 1) AND
                  (abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_10_n23, hierarchy_5)) - results_gridunits(gridunits_10_n23, hierarchy_4)) ge cut)),
            i = abs(sum(hierarchy_5 $ hierarchy_mappings(hierarchy_4, hierarchy_5), results_gridunits(gridunits_10_n23, hierarchy_5)) - results_gridunits(gridunits_10_n23, hierarchy_4));
            put "The sum of the sub cropcategories of " hierarchy_4.tl " does not fit " hierarchy_4.tl " in the region " gridunits_10_n23.tl ":" i /;
        );
      );
  );
);
*********************************************


put / / "Hierarchy 0:" / /
loop(hierarchy_0,
    loop(n0all,
        if((abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_0)) - data_nuts(n0all, hierarchy_0)) ge cut),
          i = abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_0)) - data_nuts(n0all, hierarchy_0));
          put "For " hierarchy_0.tl " the sum of the sub regions of " n0all.tl " does not fit " n0all.tl ":" i /;
        );
    );
    loop(n1_2 $ (nuts_mappings("%checkcountry%", n1_2)),
        if((abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_0)) - data_nuts(n1_2, hierarchy_0)) ge cut),
          i = abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_0)) - data_nuts(n1_2, hierarchy_0));
          put "For " hierarchy_0.tl " the sum of the sub nuts2_3 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        if((abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_0)) - data_nuts(n1_2, hierarchy_0)) ge cut),
          i = abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_0)) - data_nuts(n1_2, hierarchy_0));
          put "For " hierarchy_0.tl " the sum of the sub grid 60 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        loop(gridunits_60_n12 $ mappings_n12(n1_2, gridunits_60_n12),
            if((abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_0)) - results_gridunits(gridunits_60_n12, hierarchy_0)) ge cut),
              i = abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_0)) - results_gridunits(gridunits_60_n12, hierarchy_0));
              put "For " hierarchy_0.tl " the sum of the sub regions of " gridunits_60_n12.tl " does not fit " gridunits_60_n12.tl ":" i /;
            );
        );
        loop(gridunits_20_n12 $ mappings_n12(n1_2, gridunits_20_n12),
            if((abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_0)) - results_gridunits(gridunits_20_n12, hierarchy_0)) ge cut),
              i = abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_0)) - results_gridunits(gridunits_20_n12, hierarchy_0));
              put "For " hierarchy_0.tl " the sum of the sub regions of " gridunits_20_n12.tl " does not fit " gridunits_20_n12.tl ":" i /;
            );
        );
        loop(gridunits_10_n12 $ mappings_n12(n1_2, gridunits_10_n12),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_0)) - results_gridunits(gridunits_10_n12, hierarchy_0)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_0)) - results_gridunits(gridunits_10_n12, hierarchy_0));
              put "For " hierarchy_0.tl " the sum of the sub regions of " gridunits_10_n12.tl " does not fit " gridunits_10_n12.tl ":" i /;
              test(gridunits_10_n12_alias) = NO;
              test(gridunits_10_n12) = YES;
              display test;
            );
        );
        loop(n2_3 $ mappings_n12(n1_2, n2_3),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_0)) - data_nuts(n2_3, hierarchy_0)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_0)) - data_nuts(n2_3, hierarchy_0));
              put "For " hierarchy_0.tl " the sum of the sub regions of " n2_3.tl " does not fit " n2_3.tl ":" i /;
            );
        );
    );
);


put / / "Hierarchy 1:" / /
loop(hierarchy_1,
    loop(n0all,
        if((abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_1)) - data_nuts(n0all, hierarchy_1)) ge cut),
          i = abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_1)) - data_nuts(n0all, hierarchy_1));
          put "For " hierarchy_1.tl " the sum of the sub regions of " n0all.tl " does not fit " n0all.tl ":" i /;
        );
    );
    loop(n1_2 $ (nuts_mappings("%checkcountry%", n1_2)),
        if((abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_1)) - data_nuts(n1_2, hierarchy_1)) ge cut),
          i = abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_1)) - data_nuts(n1_2, hierarchy_1));
          put "For " hierarchy_1.tl " the sum of the sub nuts2_3 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        if((abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_1)) - data_nuts(n1_2, hierarchy_1)) ge cut),
          i = abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_1)) - data_nuts(n1_2, hierarchy_1));
          put "For " hierarchy_1.tl " the sum of the sub grid 60 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        loop(gridunits_60_n12 $ mappings_n12(n1_2, gridunits_60_n12),
            if((abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_1)) - results_gridunits(gridunits_60_n12, hierarchy_1)) ge cut),
              i = abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_1)) - results_gridunits(gridunits_60_n12, hierarchy_1));
              put "For " hierarchy_1.tl " the sum of the sub regions of " gridunits_60_n12.tl " does not fit " gridunits_60_n12.tl ":" i /;
            );
        );
        loop(gridunits_20_n12 $ mappings_n12(n1_2, gridunits_20_n12),
            if((abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_1)) - results_gridunits(gridunits_20_n12, hierarchy_1)) ge cut),
              i = abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_1)) - results_gridunits(gridunits_20_n12, hierarchy_1));
              put "For " hierarchy_1.tl " the sum of the sub regions of " gridunits_20_n12.tl " does not fit " gridunits_20_n12.tl ":" i /;
            );
        );
        loop(gridunits_10_n12 $ mappings_n12(n1_2, gridunits_10_n12),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_1)) - results_gridunits(gridunits_10_n12, hierarchy_1)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_1)) - results_gridunits(gridunits_10_n12, hierarchy_1));
              put "For " hierarchy_1.tl " the sum of the sub regions of " gridunits_10_n12.tl " does not fit " gridunits_10_n12.tl ":" i /;
            );
        );
        loop(n2_3 $ mappings_n12(n1_2, n2_3),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_1)) - data_nuts(n2_3, hierarchy_1)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_1)) - data_nuts(n2_3, hierarchy_1));
              put "For " hierarchy_1.tl " the sum of the sub regions of " n2_3.tl " does not fit " n2_3.tl ":" i /;
            );
        );
    );
);


put / / "Hierarchy 2:" / /
loop(hierarchy_2,
    loop(n0all,
        if((abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_2)) - data_nuts(n0all, hierarchy_2)) ge cut),
          i = abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_2)) - data_nuts(n0all, hierarchy_2));
          put "For " hierarchy_2.tl " the sum of the sub regions of " n0all.tl " does not fit " n0all.tl ":" i /;
        );
    );
    loop(n1_2 $ (nuts_mappings("%checkcountry%", n1_2)),
        if((abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_2)) - data_nuts(n1_2, hierarchy_2)) ge cut),
          i = abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_2)) - data_nuts(n1_2, hierarchy_2));
          put "For " hierarchy_2.tl " the sum of the sub nuts2_3 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        if((abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_2)) - data_nuts(n1_2, hierarchy_2)) ge cut),
          i = abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_2)) - data_nuts(n1_2, hierarchy_2));
          put "For " hierarchy_2.tl " the sum of the sub grid 60 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        loop(gridunits_60_n12 $ mappings_n12(n1_2, gridunits_60_n12),
            if((abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_2)) - results_gridunits(gridunits_60_n12, hierarchy_2)) ge cut),
              i = abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_2)) - results_gridunits(gridunits_60_n12, hierarchy_2));
              put "For " hierarchy_2.tl " the sum of the sub regions of " gridunits_60_n12.tl " does not fit " gridunits_60_n12.tl ":" i /;
            );
        );
        loop(gridunits_20_n12 $ mappings_n12(n1_2, gridunits_20_n12),
            if((abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_2)) - results_gridunits(gridunits_20_n12, hierarchy_2)) ge cut),
              i = abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_2)) - results_gridunits(gridunits_20_n12, hierarchy_2));
              put "For " hierarchy_2.tl " the sum of the sub regions of " gridunits_20_n12.tl " does not fit " gridunits_20_n12.tl ":" i /;
            );
        );
        loop(gridunits_10_n12 $ mappings_n12(n1_2, gridunits_10_n12),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_2)) - results_gridunits(gridunits_10_n12, hierarchy_2)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_2)) - results_gridunits(gridunits_10_n12, hierarchy_2));
              put "For " hierarchy_2.tl " the sum of the sub regions of " gridunits_10_n12.tl " does not fit " gridunits_10_n12.tl ":" i /;
            );
        );
        loop(n2_3 $ mappings_n12(n1_2, n2_3),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_2)) - data_nuts(n2_3, hierarchy_2)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_2)) - data_nuts(n2_3, hierarchy_2));
              put "For " hierarchy_2.tl " the sum of the sub regions of " n2_3.tl " does not fit " n2_3.tl ":" i /;
            );
        );
    );
);


put / / "Hierarchy 3:" / /
loop(hierarchy_3,
    loop(n0all,
        if((abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_3)) - data_nuts(n0all, hierarchy_3)) ge cut),
          i = abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_3)) - data_nuts(n0all, hierarchy_3));
          put "For " hierarchy_3.tl " the sum of the sub regions of " n0all.tl " does not fit " n0all.tl ":" i /;
        );
    );
    loop(n1_2 $ (nuts_mappings("%checkcountry%", n1_2)),
        if((abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_3)) - data_nuts(n1_2, hierarchy_3)) ge cut),
          i = abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_3)) - data_nuts(n1_2, hierarchy_3));
          put "For " hierarchy_3.tl " the sum of the sub nuts2_3 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        if((abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_3)) - data_nuts(n1_2, hierarchy_3)) ge cut),
          i = abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_3)) - data_nuts(n1_2, hierarchy_3));
          put "For " hierarchy_3.tl " the sum of the sub grid 60 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        loop(gridunits_60_n12 $ mappings_n12(n1_2, gridunits_60_n12),
            if((abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_3)) - results_gridunits(gridunits_60_n12, hierarchy_3)) ge cut),
              i = abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_3)) - results_gridunits(gridunits_60_n12, hierarchy_3));
              put "For " hierarchy_3.tl " the sum of the sub regions of " gridunits_60_n12.tl " does not fit " gridunits_60_n12.tl ":" i /;
            );
        );
        loop(gridunits_20_n12 $ mappings_n12(n1_2, gridunits_20_n12),
            if((abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_3)) - results_gridunits(gridunits_20_n12, hierarchy_3)) ge cut),
              i = abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_3)) - results_gridunits(gridunits_20_n12, hierarchy_3));
              put "For " hierarchy_3.tl " the sum of the sub regions of " gridunits_20_n12.tl " does not fit " gridunits_20_n12.tl ":" i /;
            );
        );
        loop(gridunits_10_n12 $ mappings_n12(n1_2, gridunits_10_n12),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_3)) - results_gridunits(gridunits_10_n12, hierarchy_3)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_3)) - results_gridunits(gridunits_10_n12, hierarchy_3));
              put "For " hierarchy_3.tl " the sum of the sub regions of " gridunits_10_n12.tl " does not fit " gridunits_10_n12.tl ":" i /;
            );
        );
        loop(n2_3 $ mappings_n12(n1_2, n2_3),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_3)) - data_nuts(n2_3, hierarchy_3)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_3)) - data_nuts(n2_3, hierarchy_3));
              put "For " hierarchy_3.tl " the sum of the sub regions of " n2_3.tl " does not fit " n2_3.tl ":" i /;
            );
        );
    );
);


put / / "Hierarchy 4:" / /
loop(hierarchy_4,
    loop(n0all,
        if((abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_4)) - data_nuts(n0all, hierarchy_4)) ge cut),
          i = abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_4)) - data_nuts(n0all, hierarchy_4));
          put "For " hierarchy_4.tl " the sum of the sub regions of " n0all.tl " does not fit " n0all.tl ":" i /;
        );
    );
    loop(n1_2 $ (nuts_mappings("%checkcountry%", n1_2)),
        if((abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_4)) - data_nuts(n1_2, hierarchy_4)) ge cut),
          i = abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_4)) - data_nuts(n1_2, hierarchy_4));
          put "For " hierarchy_4.tl " the sum of the sub nuts2_3 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        if((abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_4)) - data_nuts(n1_2, hierarchy_4)) ge cut),
          i = abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_4)) - data_nuts(n1_2, hierarchy_4));
          put "For " hierarchy_4.tl " the sum of the sub grid 60 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        loop(gridunits_60_n12 $ mappings_n12(n1_2, gridunits_60_n12),
            if((abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_4)) - results_gridunits(gridunits_60_n12, hierarchy_4)) ge cut),
              i = abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_4)) - results_gridunits(gridunits_60_n12, hierarchy_4));
              put "For " hierarchy_4.tl " the sum of the sub regions of " gridunits_60_n12.tl " does not fit " gridunits_60_n12.tl ":" i /;
            );
        );
        loop(gridunits_20_n12 $ mappings_n12(n1_2, gridunits_20_n12),
            if((abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_4)) - results_gridunits(gridunits_20_n12, hierarchy_4)) ge cut),
              i = abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_4)) - results_gridunits(gridunits_20_n12, hierarchy_4));
              put "For " hierarchy_4.tl " the sum of the sub regions of " gridunits_20_n12.tl " does not fit " gridunits_20_n12.tl ":" i /;
            );
        );
        loop(gridunits_10_n12 $ mappings_n12(n1_2, gridunits_10_n12),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_4)) - results_gridunits(gridunits_10_n12, hierarchy_4)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_4)) - results_gridunits(gridunits_10_n12, hierarchy_4));
              put "For " hierarchy_4.tl " the sum of the sub regions of " gridunits_10_n12.tl " does not fit " gridunits_10_n12.tl ":" i /;
            );
        );
        loop(n2_3 $ mappings_n12(n1_2, n2_3),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_4)) - data_nuts(n2_3, hierarchy_4)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_4)) - data_nuts(n2_3, hierarchy_4));
              put "For " hierarchy_4.tl " the sum of the sub regions of " n2_3.tl " does not fit " n2_3.tl ":" i /;
            );
        );
    );
);

put / / "Hierarchy 5:" / /
loop(hierarchy_5,
    loop(n0all,
        if((abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_5)) - data_nuts(n0all, hierarchy_5)) ge cut),
          i = abs(sum(n1_2 $ nuts_mappings(n0all, n1_2), data_nuts(n1_2, hierarchy_5)) - data_nuts(n0all, hierarchy_5));
          put "For " hierarchy_5.tl " the sum of the sub regions of " n0all.tl " does not fit " n0all.tl ":" i /;
        );
    );
    loop(n1_2 $ (nuts_mappings("%checkcountry%", n1_2)),
        if((abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_5)) - data_nuts(n1_2, hierarchy_5)) ge cut),
          i = abs(sum(n2_3 $ nuts_mappings(n1_2, n2_3), data_nuts(n2_3, hierarchy_5)) - data_nuts(n1_2, hierarchy_5));
          put "For " hierarchy_5.tl " the sum of the sub nuts2_3 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        if((abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_5)) - data_nuts(n1_2, hierarchy_5)) ge cut),
          i = abs(sum(gridunits_60_n12 $ mappings_gridunits_levelwise(n1_2, gridunits_60_n12), results_gridunits(gridunits_60_n12, hierarchy_5)) - data_nuts(n1_2, hierarchy_5));
          put "For " hierarchy_5.tl " the sum of the sub grid 60 of " n1_2.tl " does not fit " n1_2.tl ":" i /;
        );
        loop(gridunits_60_n12 $ mappings_n12(n1_2, gridunits_60_n12),
            if((abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_5)) - results_gridunits(gridunits_60_n12, hierarchy_5)) ge cut),
              i = abs(sum(gridunits_20_n12 $ mappings_gridunits_levelwise(gridunits_60_n12, gridunits_20_n12), results_gridunits(gridunits_20_n12, hierarchy_5)) - results_gridunits(gridunits_60_n12, hierarchy_5));
              put "For " hierarchy_5.tl " the sum of the sub regions of " gridunits_60_n12.tl " does not fit " gridunits_60_n12.tl ":" i /;
            );
        );
        loop(gridunits_20_n12 $ mappings_n12(n1_2, gridunits_20_n12),
            if((abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_5)) - results_gridunits(gridunits_20_n12, hierarchy_5)) ge cut),
              i = abs(sum(gridunits_10_n12 $ mappings_gridunits_levelwise(gridunits_20_n12, gridunits_10_n12), results_gridunits(gridunits_10_n12, hierarchy_5)) - results_gridunits(gridunits_20_n12, hierarchy_5));
              put "For " hierarchy_5.tl " the sum of the sub regions of " gridunits_20_n12.tl " does not fit " gridunits_20_n12.tl ":" i /;
            );
        );
        loop(gridunits_10_n12 $ mappings_n12(n1_2, gridunits_10_n12),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_5)) - results_gridunits(gridunits_10_n12, hierarchy_5)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(gridunits_10_n12, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_5)) - results_gridunits(gridunits_10_n12, hierarchy_5));
              put "For " hierarchy_5.tl " the sum of the sub regions of " gridunits_10_n12.tl " does not fit " gridunits_10_n12.tl ":" i /;
            );
        );
        loop(n2_3 $ mappings_n12(n1_2, n2_3),
            if((abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_5)) - data_nuts(n2_3, hierarchy_5)) ge cut),
              i = abs(sum(gridunits_10_n23 $ mappings_gridunits_10_n23(n2_3, gridunits_10_n23), results_gridunits(gridunits_10_n23, hierarchy_5)) - data_nuts(n2_3, hierarchy_5));
              put "For " hierarchy_5.tl " the sum of the sub regions of " n2_3.tl " does not fit " n2_3.tl ":" i /;
            );
        );
    );
);