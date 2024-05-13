# Ebola articles, models, and parameters are ok

    Code
      head(articles)
    Output
      # A tibble: 6 x 27
        id           covidence_id pathogen first_author_first_n~1 first_author_surname
        <chr>               <int> <chr>    <chr>                  <chr>               
      1 b61683c0d29~           30 Ebola v~ Wan                    Yang                
      2 0a142d4ea03~           41 Ebola v~ T                      Yan                 
      3 67ddf4346e8~           45 Ebola v~ Dan                    Yamin               
      4 99d8421b642~           57 Ebola v~ Zhe                    Xu                  
      5 e0562bbaf51~           65 Ebola v~ Zhi-Qiang              Xia                 
      6 5da422b86ae~          104 Ebola v~ JY                     Wong                
      # i abbreviated name: 1: first_author_first_name
      # i 22 more variables: article_title <chr>, doi <chr>, journal <chr>,
      #   year_publication <int>, volume <int>, issue <int>, page_first <int>,
      #   page_last <int>, paper_copy_only <lgl>, notes <chr>, qa_m1 <int>,
      #   qa_m2 <int>, qa_a3 <int>, qa_a4 <int>, qa_d5 <int>, qa_d6 <int>,
      #   qa_d7 <int>, covidence_id_text <dbl>, double_extracted <dbl>,
      #   article_label <chr>, model_only <dbl>, article_qa_score <dbl>

---

    Code
      tail(articles)
    Output
      # A tibble: 6 x 27
        id           covidence_id pathogen first_author_first_n~1 first_author_surname
        <chr>               <int> <chr>    <chr>                  <chr>               
      1 472ee1ca313~        23719 Ebola v~ A. J.                  Ouemba Tasse        
      2 0c509bf8084~        23720 Ebola v~ Juliana                Taube               
      3 0021aa9f7b1~        23896 Ebola v~ Renu                   Verma               
      4 43bf557b6af~        23964 Ebola v~ PP                     Wang                
      5 15df65237cb~        23986 Ebola v~ Caitlin                Ward                
      6 599531e67b7~        24286 Ebola v~ Y                      Zhang               
      # i abbreviated name: 1: first_author_first_name
      # i 22 more variables: article_title <chr>, doi <chr>, journal <chr>,
      #   year_publication <int>, volume <int>, issue <int>, page_first <int>,
      #   page_last <int>, paper_copy_only <lgl>, notes <chr>, qa_m1 <int>,
      #   qa_m2 <int>, qa_a3 <int>, qa_a4 <int>, qa_d5 <int>, qa_d6 <int>,
      #   qa_d7 <int>, covidence_id_text <dbl>, double_extracted <dbl>,
      #   article_label <chr>, model_only <dbl>, article_qa_score <dbl>

---

    Code
      head(models)
    Output
      # A tibble: 6 x 12
        id                  model_data_id covidence_id pathogen model_type stoch_deter
        <chr>               <chr>                <int> <chr>    <chr>      <chr>      
      1 020d0e0666688ab3ba~ 6ba75ca44fbb~           30 Ebola v~ Compartme~ Determinis~
      2 67ddf4346e8e577b2f~ ca6865504203~           45 Ebola v~ Branching~ Stochastic 
      3 356ee0ccdf13b10103~ 07faa3af5efd~           65 Ebola v~ Compartme~ <NA>       
      4 3dc2fe4e49cbae5ccd~ 1f55465221be~          159 Ebola v~ Compartme~ Determinis~
      5 b7dcb6041b1754b426~ f284b757071c~          206 Ebola v~ Compartme~ Determinis~
      6 6c03358044bc082e47~ d9ed35f03f36~          291 Ebola v~ Compartme~ Stochastic 
      # i 6 more variables: theoretical_model <lgl>, interventions_type <chr>,
      #   code_available <lgl>, transmission_route <chr>, assumptions <chr>,
      #   ebola_variant <chr>

---

    Code
      tail(models)
    Output
      # A tibble: 6 x 12
        id                  model_data_id covidence_id pathogen model_type stoch_deter
        <chr>               <chr>                <int> <chr>    <chr>      <chr>      
      1 8ca1f2ce46414ffb76~ 49fe2fadb8fd~        23674 Ebola v~ Compartme~ Determinis~
      2 a737f814573de4bdae~ 9bfcf0867891~        23719 Ebola v~ Compartme~ Determinis~
      3 0021aa9f7b139541af~ 0e6c69123f26~        23896 Ebola v~ Compartme~ Determinis~
      4 43bf557b6afee69b3a~ 497360d138b6~        23964 Ebola v~ Compartme~ Stochastic 
      5 15df65237cb7e9f17e~ 2ac291b170c2~        23986 Ebola v~ Compartme~ Stochastic 
      6 599531e67b7163c5e7~ 1ce2dbd7bfcf~        24286 Ebola v~ Branching~ Stochastic 
      # i 6 more variables: theoretical_model <lgl>, interventions_type <chr>,
      #   code_available <lgl>, transmission_route <chr>, assumptions <chr>,
      #   ebola_variant <chr>

---

    Code
      head(params)
    Output
      # A tibble: 6 x 73
        id      parameter_data_id covidence_id pathogen parameter_type parameter_value
        <chr>   <chr>                    <int> <chr>    <chr>                    <dbl>
      1 b61683~ 6f5cb18602d0dfec~           30 Ebola v~ Human delay -~            NA  
      2 b61683~ b5af335082c4306f~           30 Ebola v~ Reproduction ~            NA  
      3 b61683~ 55766cedfbf75a9c~           30 Ebola v~ Human delay -~            NA  
      4 0a142d~ 3ae1f6b55d0f1cc5~           41 Ebola v~ Human delay -~             9.2
      5 0a142d~ 22dc037c9e54b6fa~           41 Ebola v~ Severity - ca~            60  
      6 0a142d~ f0a0191af0663265~           41 Ebola v~ Human delay -~             5.8
      # i 67 more variables: exponent <dbl>, parameter_unit <chr>,
      #   parameter_lower_bound <dbl>, parameter_upper_bound <dbl>,
      #   parameter_value_type <chr>, parameter_uncertainty_single_value <dbl>,
      #   parameter_uncertainty_singe_type <chr>,
      #   parameter_uncertainty_lower_value <dbl>,
      #   parameter_uncertainty_upper_value <dbl>, parameter_uncertainty_type <chr>,
      #   cfr_ifr_numerator <int>, cfr_ifr_denominator <int>, ...

---

    Code
      tail(params)
    Output
      # A tibble: 6 x 73
        id      parameter_data_id covidence_id pathogen parameter_type parameter_value
        <chr>   <chr>                    <int> <chr>    <chr>                    <dbl>
      1 472ee1~ a97b0a0cd787228e~        23719 Ebola v~ Reproduction ~           0.33 
      2 0c509b~ 11d81564515a34a3~        23720 Ebola v~ Reproduction ~          NA    
      3 0c509b~ db04bdf59a23a7fe~        23720 Ebola v~ Overdispersion           0.24 
      4 15df65~ 1207265630d7c9ee~        23986 Ebola v~ Human delay -~          NA    
      5 15df65~ e732743fc1995d5c~        23986 Ebola v~ Reproduction ~          NA    
      6 599531~ 908ac4700d1248d0~        24286 Ebola v~ Overdispersion           0.065
      # i 67 more variables: exponent <dbl>, parameter_unit <chr>,
      #   parameter_lower_bound <dbl>, parameter_upper_bound <dbl>,
      #   parameter_value_type <chr>, parameter_uncertainty_single_value <dbl>,
      #   parameter_uncertainty_singe_type <chr>,
      #   parameter_uncertainty_lower_value <dbl>,
      #   parameter_uncertainty_upper_value <dbl>, parameter_uncertainty_type <chr>,
      #   cfr_ifr_numerator <int>, cfr_ifr_denominator <int>, ...

