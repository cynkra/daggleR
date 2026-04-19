# Send a request to the daggle API

Internal helper used by the API wrappers. Builds an `httr2` request
against the resolved base URL, performs it, and parses the JSON body.
Centralises the boilerplate so each wrapper only declares the path,
method, and optional query/body.

## Usage

``` r
daggle_request(
  path,
  method = c("GET", "POST", "DELETE"),
  query = NULL,
  body = NULL,
  simplify = FALSE,
  base_url = NULL
)
```

## Arguments

- path:

  Character vector of URL path segments appended after the base URL via
  [`httr2::req_url_path_append()`](https://httr2.r-lib.org/reference/req_url.html).
  Example: `c("api", "v1", "dags", name, "runs", run_id)`.

- method:

  HTTP method. One of `"GET"`, `"POST"`, `"DELETE"`.

- query:

  Named list of query parameters, or `NULL`. Elements whose value is
  `NULL` are dropped (so callers can pass optional filters without
  conditional wiring).

- body:

  Named list serialised as a JSON request body, or `NULL`.

- simplify:

  Passed to
  [`httr2::resp_body_json()`](https://httr2.r-lib.org/reference/resp_body_raw.html)
  as `simplifyVector`. Set `TRUE` for collection endpoints that should
  return a data.frame; leave `FALSE` for single-object endpoints that
  should return a list.

- base_url:

  Character string or `NULL`. Passed to
  [`resolve_base_url()`](https://cynkra.github.io/daggleR/reference/resolve_base_url.md).

## Value

Parsed JSON response — a list, or a data.frame when `simplify = TRUE`.
