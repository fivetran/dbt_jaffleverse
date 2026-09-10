{#
    Maps a customer segment to a sortable integer, so segments can be ordered by
    commercial weight rather than alphabetically.

    Adding a segment? Add a `when` branch and bump the numbers around it.
#}

{% macro jaffleverse_segment_rank(segment_column) -%}

    case
        when {{ segment_column }} = 'enterprise' then 4
        when {{ segment_column }} = 'reseller' then 3
        when {{ segment_column }} = 'small_business' then 2
        when {{ segment_column }} = 'consumer' then 1
        else 0
    end

{%- endmacro %}
