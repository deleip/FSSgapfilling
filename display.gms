************* filling data gaps in agricultural data *************

$stars $$$$

$offlisting
$include "./sets/croptypes_sum.txt"
$include "./sets/croptypes_for_display.txt"

set hierarchy_mappings(croptypes, croptypes) /
$include "./sets/crop_sets_d.txt"
/;

*regions
$include "./sets/all_reg_to_define_mappings_sum.txt"
$include "./sets/all_reg_to_define_mappings_for_display.txt"
$include "./sets/all_reg.txt"
*mappings between different region levels
$include "./sets/nuts_mappings.txt"
$include "./sets/mappings_gridunits_10_n23.txt"
$include "./sets/mappings_gridunits_levelwise.txt"

parameter p_data(all_reg_to_define_mappings_sum, croptypes_sum);
parameter data_nuts_results(all_reg, croptypes);
parameter results_gridunits(all_reg, croptypes);
execute_load "./results/data_nuts_results.gdx" data_nuts_results;
execute_load "./results/fss2010grid_%country%.gdx" results_gridunits;
*v_data_nuts.l(all_reg, croptypes) = v_data.l(all_reg, croptypes);
*results_gridunits(all_reg, croptypes) $ (results_gridunits(all_reg, croptypes)=0) = eps;

** je nachdem welche tabelle man sehen will:
** 1: haupt- und unterregionen sind nuts
** 2: hauptregion ist gridunits_10_n12 mit unterregionen gridunits_10_n23
** 3: hauptregion nuts2_3 und unterregion gridunits_10_n23
** 4: hauptregion nuts1_2 und unterregionen gridunits_60_n12
** 5: haupt- und unterregionen gridunits (aber nicht als schnitt mit nuts2_3, dafuer ist ja fall 2)
**** geht vermutlich sinnvoller als mit fuenf if sachen, aber hat sich nach und nach zusammengebaut...
**** 4 und 5 hab ich auch jetzt erst ergaenzt, evtl ist da noch ein fehler drin


*scalar i /4/;
*singleton set region(all_reg) /UKM6/;
*singleton set croptype(croptypes) /AGRAREA/;

$onlisting
scalar i /%i%/;
singleton set region(all_reg) /%region%/;
singleton set croptype(croptypes) /%croptype%/;


if(i = 1,
p_data(region, croptype) = data_nuts_results(region, croptype);
p_data(all_reg, croptype) $ nuts_mappings(region, all_reg) = data_nuts_results(all_reg, croptype);
p_data(region, croptypes)  $ hierarchy_mappings(croptype, croptypes) = data_nuts_results(region, croptypes);
p_data(all_reg, croptypes)  $ (nuts_mappings(region, all_reg) AND hierarchy_mappings(croptype, croptypes))
         = data_nuts_results(all_reg, croptypes);

p_data("summe", croptype) = sum(all_reg $ nuts_mappings(region, all_reg), p_data(all_reg, croptype));
p_data("summe", croptypes) $ hierarchy_mappings(croptype, croptypes) = sum(all_reg $ nuts_mappings(region, all_reg), p_data(all_reg, croptypes));
p_data(region, "summe") = sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(region, croptypes));
p_data(all_reg, "summe") $ nuts_mappings(region, all_reg) =  sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(all_reg, croptypes));
);

if(i = 2,
p_data(region, croptype) = results_gridunits(region, croptype);
p_data(all_reg, croptype) $ mappings_gridunits_10_n23(region, all_reg) = results_gridunits(all_reg, croptype);
p_data(region, croptypes)  $ hierarchy_mappings(croptype, croptypes) = results_gridunits(region, croptypes);
p_data(all_reg, croptypes)  $ (mappings_gridunits_10_n23(region, all_reg) AND hierarchy_mappings(croptype, croptypes))
         = results_gridunits(all_reg, croptypes);

p_data("summe", croptype) = sum(all_reg $ mappings_gridunits_10_n23(region, all_reg), p_data(all_reg, croptype));
p_data("summe", croptypes) $ hierarchy_mappings(croptype, croptypes) = sum(all_reg $ mappings_gridunits_10_n23(region, all_reg), p_data(all_reg, croptypes));
p_data(region, "summe") = sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(region, croptypes));
p_data(all_reg, "summe") $ mappings_gridunits_10_n23(region, all_reg) =  sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(all_reg, croptypes));
);

if(i = 3,
p_data(region, croptype) = data_nuts_results(region, croptype);
p_data(all_reg, croptype) $ mappings_gridunits_10_n23(region, all_reg) = results_gridunits(all_reg, croptype);
p_data(region, croptypes)  $ hierarchy_mappings(croptype, croptypes) = data_nuts_results(region, croptypes);
p_data(all_reg, croptypes)  $ (mappings_gridunits_10_n23(region, all_reg) AND hierarchy_mappings(croptype, croptypes))
         = results_gridunits(all_reg, croptypes);

p_data("summe", croptype) = sum(all_reg $ mappings_gridunits_10_n23(region, all_reg), p_data(all_reg, croptype));
p_data("summe", croptypes) $ hierarchy_mappings(croptype, croptypes) = sum(all_reg $ mappings_gridunits_10_n23(region, all_reg), p_data(all_reg, croptypes));
p_data(region, "summe") = sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(region, croptypes));
p_data(all_reg, "summe") $ mappings_gridunits_10_n23(region, all_reg) =  sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(all_reg, croptypes));
);


if(i = 4,
p_data(region, croptype) = data_nuts_results(region, croptype);
p_data(all_reg, croptype) $ mappings_gridunits_levelwise(region, all_reg) = results_gridunits(all_reg, croptype);
p_data(region, croptypes)  $ hierarchy_mappings(croptype, croptypes) = data_nuts_results(region, croptypes);
p_data(all_reg, croptypes)  $ (mappings_gridunits_levelwise(region, all_reg) AND hierarchy_mappings(croptype, croptypes))
         = results_gridunits(all_reg, croptypes);

p_data("summe", croptype) = sum(all_reg $ mappings_gridunits_levelwise(region, all_reg), p_data(all_reg, croptype));
p_data("summe", croptypes) $ hierarchy_mappings(croptype, croptypes) = sum(all_reg $ mappings_gridunits_levelwise(region, all_reg), p_data(all_reg, croptypes));
p_data(region, "summe") = sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(region, croptypes));
p_data(all_reg, "summe") $ mappings_gridunits_levelwise(region, all_reg) =  sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(all_reg, croptypes));
);

if(i = 5,
p_data(region, croptype) = results_gridunits(region, croptype);
p_data(all_reg, croptype) $ mappings_gridunits_levelwise(region, all_reg) = results_gridunits(all_reg, croptype);
p_data(region, croptypes) $ hierarchy_mappings(croptype, croptypes) = data_nuts_results(region, croptypes);
p_data(all_reg, croptypes) $ (mappings_gridunits_levelwise(region, all_reg) AND hierarchy_mappings(croptype, croptypes))
         = results_gridunits(all_reg, croptypes);

p_data("summe", croptype) = sum(all_reg $ mappings_gridunits_levelwise(region, all_reg), p_data(all_reg, croptype));
p_data("summe", croptypes) $ hierarchy_mappings(croptype, croptypes) = sum(all_reg $ mappings_gridunits_levelwise(region, all_reg), p_data(all_reg, croptypes));
p_data(region, "summe") = sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(region, croptypes));
p_data(all_reg, "summe") $ mappings_gridunits_levelwise(region, all_reg) =  sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(all_reg, croptypes));
);


option decimals=8;
display p_data;
