# Ebola articles, models, and parameters are ok

    Code
      head(articles)
    Output
      # A tibble: 6 x 25
        id           covidence_id pathogen first_author_first_n~1 first_author_surname
        <chr>               <dbl> <chr>    <chr>                  <chr>               
      1 a499d565d7b~           30 Ebola v~ Wan                    Yang                
      2 2f603330abb~           41 Ebola v~ T                      Yan                 
      3 1b332278c60~           45 Ebola v~ Dan                    Yamin               
      4 0ec383a2eab~           57 Ebola v~ Zhe                    Xu                  
      5 cebcf7f4833~           65 Ebola v~ Zhi-Qiang              Xia                 
      6 e48a5dda2fc~          104 Ebola v~ JY                     Wong                
      # i abbreviated name: 1: first_author_first_name
      # i 20 more variables: article_title <chr>, doi <chr>, journal <chr>,
      #   year_publication <dbl>, volume <dbl>, issue <dbl>, page_first <dbl>,
      #   page_last <dbl>, paper_copy_only <lgl>, notes <chr>, qa_m1 <chr>,
      #   qa_m2 <chr>, qa_a3 <chr>, qa_a4 <chr>, qa_d5 <chr>, qa_d6 <chr>,
      #   qa_d7 <chr>, double_extracted <dbl>, model_only <dbl>,
      #   article_qa_score <dbl>

---

    Code
      tail(articles)
    Output
      # A tibble: 6 x 25
        id           covidence_id pathogen first_author_first_n~1 first_author_surname
        <chr>               <dbl> <chr>    <chr>                  <chr>               
      1 23c38b6e65f~        23719 Ebola v~ A. J.                  OUEMBA TASSE ́       
      2 fdb9a9802f2~        23720 Ebola v~ Juliana                Taube               
      3 303a2a3ccd5~        23896 Ebola v~ Renu                   Verma               
      4 abc42363269~        23964 Ebola v~ PP                     Wang                
      5 cefa48f3e1d~        23986 Ebola v~ Caitlin                Ward                
      6 2f0d539c74b~        24286 Ebola v~ Y                      Zhang               
      # i abbreviated name: 1: first_author_first_name
      # i 20 more variables: article_title <chr>, doi <chr>, journal <chr>,
      #   year_publication <dbl>, volume <dbl>, issue <dbl>, page_first <dbl>,
      #   page_last <dbl>, paper_copy_only <lgl>, notes <chr>, qa_m1 <chr>,
      #   qa_m2 <chr>, qa_a3 <chr>, qa_a4 <chr>, qa_d5 <chr>, qa_d6 <chr>,
      #   qa_d7 <chr>, double_extracted <dbl>, model_only <dbl>,
      #   article_qa_score <dbl>

---

    Code
      head(models)
    Output
      # A tibble: 6 x 13
        id           model_data_id covidence_id pathogen model_type compartmental_type
        <chr>        <chr>                <dbl> <chr>    <chr>      <chr>             
      1 4c9b2434ef6~ 8d97477b9934~           30 Ebola v~ Compartme~ SEIR              
      2 1b332278c60~ ad73215ab02a~           45 Ebola v~ Branching~ <NA>              
      3 caf3b2db45e~ b5ad59a1c0fe~           65 Ebola v~ Compartme~ Other compartment~
      4 4e123bc06c5~ 9be1b9e1c97f~          159 Ebola v~ Compartme~ SIR               
      5 59106f78738~ 1ab9855708a5~          206 Ebola v~ Compartme~ Other compartment~
      6 d17eb9a8bc6~ 7574aa08b100~          291 Ebola v~ Compartme~ Other compartment~
      # i 7 more variables: stoch_deter <chr>, theoretical_model <lgl>,
      #   interventions_type <chr>, code_available <lgl>, transmission_route <chr>,
      #   assumptions <chr>, ebola_variant <chr>

---

    Code
      tail(models)
    Output
      # A tibble: 6 x 13
        id           model_data_id covidence_id pathogen model_type compartmental_type
        <chr>        <chr>                <dbl> <chr>    <chr>      <chr>             
      1 5ea47522639~ 85cdf31d429b~        23674 Ebola v~ Compartme~ SEIR              
      2 a0860c3f673~ ef9b24a7e9b8~        23719 Ebola v~ Compartme~ Other compartment~
      3 303a2a3ccd5~ ac0a3ae4d21e~        23896 Ebola v~ Compartme~ Other compartment~
      4 abc42363269~ 1d730a295280~        23964 Ebola v~ Compartme~ Other compartment~
      5 cefa48f3e1d~ ee952b8d50da~        23986 Ebola v~ Compartme~ SEIR              
      6 2f0d539c74b~ 9f8b0f15f0cb~        24286 Ebola v~ Branching~ Not compartmental 
      # i 7 more variables: stoch_deter <chr>, theoretical_model <lgl>,
      #   interventions_type <chr>, code_available <lgl>, transmission_route <chr>,
      #   assumptions <chr>, ebola_variant <chr>

---

    Code
      head(params)
    Output
      # A tibble: 6 x 61
        id      parameter_data_id covidence_id pathogen parameter_type parameter_value
        <chr>   <chr>                    <dbl> <chr>    <chr>                    <dbl>
      1 a499d5~ 081c0b3a32a08b22~           30 Ebola v~ Human delay -~            NA  
      2 4c9b24~ 1143f2c5c127d884~           30 Ebola v~ Reproduction ~            NA  
      3 4c9b24~ c0f3fd31921663be~           30 Ebola v~ Human delay -~            NA  
      4 082986~ 5b9703f8c6cb62d7~           41 Ebola v~ Human delay -~             9.2
      5 082986~ 284f9d8943d9a114~           41 Ebola v~ Severity - ca~            60  
      6 082986~ 1f5fd6fe141c935d~           41 Ebola v~ Human delay -~             5.8
      # i 55 more variables: exponent <dbl>, parameter_unit <chr>,
      #   parameter_lower_bound <dbl>, parameter_upper_bound <dbl>,
      #   parameter_value_type <chr>, parameter_uncertainty_single_value <dbl>,
      #   parameter_uncertainty_singe_type <chr>,
      #   parameter_uncertainty_lower_value <dbl>,
      #   parameter_uncertainty_upper_value <dbl>, parameter_uncertainty_type <chr>,
      #   cfr_ifr_numerator <dbl>, cfr_ifr_denominator <dbl>, ...

---

    Code
      tail(params)
    Output
      # A tibble: 6 x 61
        id      parameter_data_id covidence_id pathogen parameter_type parameter_value
        <chr>   <chr>                    <dbl> <chr>    <chr>                    <dbl>
      1 23c38b~ 1a92ddadde92a106~        23719 Ebola v~ Reproduction ~           0.33 
      2 fdb9a9~ 620d5397c45ccb46~        23720 Ebola v~ Reproduction ~          NA    
      3 fdb9a9~ 6fc1d91677f118fd~        23720 Ebola v~ Overdispersion           0.24 
      4 cefa48~ 33e80f2c9ed950b0~        23986 Ebola v~ Human delay -~          NA    
      5 cefa48~ d021c9ef87c6c64e~        23986 Ebola v~ Reproduction ~          NA    
      6 2f0d53~ 0392351ecd9780b6~        24286 Ebola v~ Overdispersion           0.065
      # i 55 more variables: exponent <dbl>, parameter_unit <chr>,
      #   parameter_lower_bound <dbl>, parameter_upper_bound <dbl>,
      #   parameter_value_type <chr>, parameter_uncertainty_single_value <dbl>,
      #   parameter_uncertainty_singe_type <chr>,
      #   parameter_uncertainty_lower_value <dbl>,
      #   parameter_uncertainty_upper_value <dbl>, parameter_uncertainty_type <chr>,
      #   cfr_ifr_numerator <dbl>, cfr_ifr_denominator <dbl>, ...

