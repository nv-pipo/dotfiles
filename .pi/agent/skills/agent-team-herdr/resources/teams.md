# Agent teams (herdr)

## base

~~~mermaid
flowchart TD
  scout --> planner
  planner --> builder
  builder --> reviewer
  reviewer --> scout
~~~

## full

~~~mermaid
flowchart TD
  scout --> planner
  planner --> builder
  builder --> reviewer
  reviewer --> red-team
  red-team --> documenter
  documenter --> scout
~~~
