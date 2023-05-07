{% macro sum_events(event_type) %}
    sum((event_type = '{{ event_type }}')::int)
{% endmacro %}