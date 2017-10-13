# This state configures the timezone.

{%- set timezone = salt['pillar.get']('timezone:name', 'Europe/Berlin') %}
{%- set utc = salt['pillar.get']('timezone:utc', True) %}
{% from "timezone/map.jinja" import confmap with context %}

timezone_setting:
  timezone.system:
    - name: {{ timezone }}
    - utc: {{ utc }}

{% if confmap.pkgname != False -%}
timezone_packages:
  pkg.installed:
    - name: {{ confmap.pkgname }}
{%- endif %}

timezone_symlink:
  file.symlink:
    - name: {{ confmap.path_localtime }}
    - target: {{ confmap.path_zoneinfo }}{{ timezone }}
    - force: true
    {% if confmap.pkgname != False -%}
    - require:
      - pkg: {{ confmap.pkgname }}
    {%- endif %}

