package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

foreach selType {Block Domain Connector} {
    if { ![pwio::utils::getSelection $selType selectedEnts errMsg] } {
        puts $errMsg
        continue;
    }
    puts "$selType selection:"
    foreach ent $selectedEnts {
        set baseType [pwio::utils::entBaseType $ent subType]
        puts "  [$ent getName]($ent) baseType='$baseType' subType='$subType'"
    }
}

# Output:
# Block selection:
#   blk-4(::pw::BlockStructured_1) baseType='Block' subType='Structured'
#   blk-5(::pw::BlockStructured_2) baseType='Block' subType='Structured'
# Domain selection:
#   dom-14(::pw::DomainUnstructured_2) baseType='Domain' subType='Unstructured'
#   dom-27(::pw::DomainStructured_14) baseType='Domain' subType='Structured'
# Connector selection:
#   con-44(::pw::Connector_20) baseType='Connector' subType='Connector'
#   con-56(::pw::Connector_33) baseType='Connector' subType='Connector'
