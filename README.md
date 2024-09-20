# ecospheres-xslt

Collection of XSLTs to adapt ISO-19139 XML metadata according to https://ecospheres.gitbook.io/recommandations-iso-dcat/.


## Testing

### Running tests

```
pip install -r requirements.txt
pytest run_tests.py
```

### Adding tests

A test case for a given `xslts/$transform.xml` is the combination of:
- An input metadata record: `fixtures/$input.xml`.
- Either:
  - an expected transformed metadata record: `tests/$transform--$input.xml`.
  - an expected error message: `tests/$transform--$input.err`.

### Adding fixtures

- Metadata records copied from real catalogs should be named as `<catalog-name>-<record-id>.xml`.
- Fake test records should be named as `sample-<short-description>.xml`.

