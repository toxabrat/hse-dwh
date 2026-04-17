{% macro get_mart_target_date() %}
    {% set target_date = var('target_date', modules.datetime.date.today() - modules.datetime.timedelta(days=1)) %}
    {{ return(target_date) }}
{% endmacro %}
