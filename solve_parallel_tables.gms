*****************************

*        %2 e.g. "h2"                    the hierarchical level of the supercategory of the cropcategories that should be filled, i.e. either h0, h1, h2 or h3


*****************************
*                    sub_cropcategories  super_cropcategory
*                    | b_1 b_2 b_3 b_4 | AGRAREA                                     where:                            here, the supercategory of the regions
*     e.g          __|_________________|___                                                                            would be "SK", and therefore %1 "n0".
*               SK01 |                 | data("SK01", "AGRAREA")                d1 = data("SK", "b_1")                 the supercategory of the cropcategories
*  sub_regions  SK02 |                 | data("SK02", "AGRAREA")                d2 = data("SK", "b_2")                 would be "AGRAREA", and %2 "h0"
*               SK03 |                 | data("SK012, "AGRAREA")                d3 = data("SK", "b_3")
*               SK04_|_________________|_data("SK012, "AGRAREA")                d4 = data("SK", "b_4")                 interior of table: data(sub_regions, sub_cropcategories)
*  super_region  SK  | d1  d2  d3  d4  | data_n0("SK", "AGRAREA")                                                      super_region = "SK", super_cropcategories = "AGRAREA"
*
** the sums are given, the interior of the table can be everything between completly filled and completly empty
** to use a solve statement, we need startvalues in the interior of the table. Therefore, this program first distributes
** missing area on data.l in each row (missing area = real row sum - needed row sum (e.g. data("SK01", "AGRAREA"))),
** using the column sums as shares and then solves the table.

** here we apply this concept for gridunits_10 as subregions of gridunits_20 (for all gridunits_20 in the superregion!), gridunits_20 as subregions of
** gridunits_60 (for all gridunits_60 in the superregion!), gridunits_60 as subregions of nuts1_2(=super_region) and of course
** nuts2_3 as subregions of nuts1_2(=super_region).

** Later we will try to find a way to include the relation between gridunits and nuts2_3, probably by setting upper and lower bounds.

*****************************



* first we have to find out how the tables look like, i.e. fill the sets for sub/super regions/cropcategories correctly!

super_cropcategory(cropcategories) = NO;

if(sameas("%1", "h0"),
     super_cropcategory(hierarchy_0) = YES;
     elseif sameas("%1", "h1"),
         super_cropcategory(hierarchy_1) = YES;
         elseif sameas("%1", "h2"),
             super_cropcategory(hierarchy_2) = YES;
             elseif sameas("%1", "h3"),
                 super_cropcategory(hierarchy_3) = YES;
                 elseif sameas("%1", "h4"),
                     super_cropcategory(hierarchy_4) = YES;
);




sub_cropcategories(cropcategories) = NO;
sub_cropcategories(cropcategories) = YES $ hierarchy_mappings(super_cropcategory, cropcategories);


*********** STARTVALUES TABLE NUTS2_3 -> NUTS1_2 **************

loop(sub_regions_nuts2_3,
     needed_sum_row = v_data_nuts.l(sub_regions_nuts2_3, super_cropcategory);
     sum_row = sum(sub_cropcategories, v_data_nuts.l(sub_regions_nuts2_3, sub_cropcategories));
     sum_for_shares_row = sum(sub_cropcategories $ (p_std_nuts(sub_regions_nuts2_3, sub_cropcategories) = 0.05), v_data_nuts.l(super_region_n12, sub_cropcategories));
     if((sum_for_shares_row ne 0) AND (needed_sum_row - sum_row gt 0),
         loop(sub_cropcategories $ (p_std_nuts(sub_regions_nuts2_3, sub_cropcategories) = 0.05),
             v_data_nuts.l(sub_regions_nuts2_3, sub_cropcategories) = v_data_nuts.l(sub_regions_nuts2_3, sub_cropcategories) +
                                 (needed_sum_row - sum_row) * (v_data_nuts.l(super_region_n12, sub_cropcategories) / sum_for_shares_row)
         );
     );
);



*********** STARTVALUES TABLE GRIDUNITS_60_n12 -> NUTS1_2 **************
* should work exactly like above

loop(sub_regions_gridunits_60_n12,
     needed_sum_row = v_data_gridunits.l(sub_regions_gridunits_60_n12, super_cropcategory);
     sum_row = sum(sub_cropcategories, v_data_gridunits.l(sub_regions_gridunits_60_n12, sub_cropcategories));
     sum_for_shares_row = sum(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_60_n12, sub_cropcategories) = 0.05), v_data_nuts.l(super_region_n12, sub_cropcategories));
     if((sum_for_shares_row ne 0) AND (needed_sum_row - sum_row gt 0),
         loop(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_60_n12, sub_cropcategories) = 0.05),
             v_data_gridunits.l(sub_regions_gridunits_60_n12, sub_cropcategories) = v_data_gridunits.l(sub_regions_gridunits_60_n12, sub_cropcategories) +
                         (needed_sum_row - sum_row) * (v_data_nuts.l(super_region_n12, sub_cropcategories) / sum_for_shares_row)
         );
     );
);

*********** STARTVALUES TABLE GRIDUNITS_20_n12 -> GRIDUNITS_60_n12 **************
* loop over all gridunits_60_n12, inside that loop it's like above (just that we don't have the equivalent to "sub_regions" set, and therefore have to calculate it every time)

loop(sub_regions_gridunits_60_n12,
         loop(sub_regions_gridunits_20_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_60_n12, sub_regions_gridunits_20_n12),
              needed_sum_row = v_data_gridunits.l(sub_regions_gridunits_20_n12, super_cropcategory);
              sum_row = sum(sub_cropcategories, v_data_gridunits.l(sub_regions_gridunits_20_n12, sub_cropcategories));
              sum_for_shares_row = sum(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_20_n12, sub_cropcategories) = 0.05), v_data_gridunits.l(sub_regions_gridunits_60_n12, sub_cropcategories));
              if((sum_for_shares_row ne 0) AND (needed_sum_row - sum_row gt 0),
                  loop(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_20_n12, sub_cropcategories) = 0.05),
                      v_data_gridunits.l(sub_regions_gridunits_20_n12, sub_cropcategories) = v_data_gridunits.l(sub_regions_gridunits_20_n12, sub_cropcategories) +
                                 (needed_sum_row - sum_row) * (v_data_gridunits.l(sub_regions_gridunits_60_n12, sub_cropcategories) / sum_for_shares_row)
                  );
              );
         );
);


*********** STARTVALUES TABLE GRIDUNITS_10_n12 -> GRIDUNITS_20_n12 **************
* loop over all gridunits_20_n12

loop(sub_regions_gridunits_20_n12,
         loop(sub_regions_gridunits_10_n12 $ mappings_gridunits_levelwise(sub_regions_gridunits_20_n12, sub_regions_gridunits_10_n12),
              needed_sum_row = v_data_gridunits.l(sub_regions_gridunits_10_n12, super_cropcategory);
              sum_row = sum(sub_cropcategories, v_data_gridunits.l(sub_regions_gridunits_10_n12, sub_cropcategories));
              sum_for_shares_row = sum(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_10_n12, sub_cropcategories) = 0.05), v_data_gridunits.l(sub_regions_gridunits_20_n12, sub_cropcategories));
              if((sum_for_shares_row ne 0) AND (needed_sum_row - sum_row gt 0),
                  loop(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_10_n12, sub_cropcategories) = 0.05),
                      v_data_gridunits.l(sub_regions_gridunits_10_n12, sub_cropcategories) =  v_data_gridunits.l(sub_regions_gridunits_10_n12, sub_cropcategories) +
                                         (needed_sum_row - sum_row) * (v_data_gridunits.l(sub_regions_gridunits_20_n12, sub_cropcategories) / sum_for_shares_row)
                  );
              );
         );
);



*********** STARTVALUES TABLE GRIDUNITS_10_n23 -> GRIDUNITS_10_n12 (AND NUTS2_3) **************
* loop over all gridunits_10_n12


loop(sub_regions_gridunits_10_n12,
         loop(sub_regions_gridunits_10_n23 $ mappings_gridunits_10_n23(sub_regions_gridunits_10_n12, sub_regions_gridunits_10_n23),
              needed_sum_row = v_data_gridunits.l(sub_regions_gridunits_10_n23, super_cropcategory);
              sum_row = sum(sub_cropcategories, v_data_gridunits.l(sub_regions_gridunits_10_n23, sub_cropcategories));
              sum_for_shares_row = sum(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_10_n23, sub_cropcategories) = 0.05), v_data_gridunits.l(sub_regions_gridunits_10_n12, sub_cropcategories));
              if((sum_for_shares_row ne 0) AND (needed_sum_row - sum_row gt 0),
                  loop(sub_cropcategories $ (p_std_gridunits(sub_regions_gridunits_10_n23, sub_cropcategories) = 0.05),
                      v_data_gridunits.l(sub_regions_gridunits_10_n23, sub_cropcategories) = v_data_gridunits.l(sub_regions_gridunits_10_n23, sub_cropcategories) +
                         (needed_sum_row - sum_row) * (v_data_gridunits.l(sub_regions_gridunits_10_n12, sub_cropcategories) / sum_for_shares_row)
                  );
              );
         );
);



*********** SOLVING **************

p_data_nuts(all_nuts, cropcategories) = v_data_nuts.l(all_nuts, cropcategories);
p_data_gridunits(all_gridunits, cropcategories) = v_data_gridunits.l(all_gridunits, cropcategories);
                                                                                     
results_gridunits(all_gridunits, cropcategories) = v_data_gridunits.l(all_gridunits, cropcategories);

solve multi_table USING NLP MINIMIZING v_hpd_multi;


*********** FIXING RESULTS **************

* after solving we need to fix the results, as we need them for filling the next level
v_data_nuts.fx(sub_regions_nuts2_3, sub_cropcategories) = v_data_nuts.l(sub_regions_nuts2_3, sub_cropcategories);
v_data_gridunits.fx(sub_regions_gridunits_60_n12, sub_cropcategories) = v_data_gridunits.l(sub_regions_gridunits_60_n12, sub_cropcategories);
v_data_gridunits.fx(sub_regions_gridunits_20_n12, sub_cropcategories) = v_data_gridunits.l(sub_regions_gridunits_20_n12, sub_cropcategories);
v_data_gridunits.fx(sub_regions_gridunits_10_n12, sub_cropcategories) = v_data_gridunits.l(sub_regions_gridunits_10_n12, sub_cropcategories);
v_data_gridunits.fx(sub_regions_gridunits_10_n23, sub_cropcategories) = v_data_gridunits.l(sub_regions_gridunits_10_n23, sub_cropcategories);
