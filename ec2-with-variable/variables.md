variable "example_var" {
    description = "example input variable"
    type = string
    default = "default_value"
}

resource "example_instance" "example" {
    name = var.example_var
    # other resource configurations
}