get_serial_interval <- function(params) {
    
    assert_params(params)
    x <- params[params$parameter_type %in% "Human delay - serial interval", ]
}