# ecospheres-xslt

Collection of XSLTs to adapt ISO-19139 XML metadata according to https://github.com/ecolabdata/ecospheres/wiki/Recommandations-ISO-DCAT.

Some XSLTs might be ported to support other input standards on an as-needed basis.
When available, these XSLTs are not guaranteed to be iso-functional.


## Repository structure

```
./
  iso-19115-3/
    transformation-1.xsl
    transformation-1.md
    ...
    fixtures/
    tests/
  iso-19139/
    transformation-1.xsl
    transformation-1.md
    ...
    fixtures/
    tests/
```

Identical transformations in different standards should use the same name.


## Testing

### Running tests

```
pip install -r requirements.txt
pytest run_tests.py
```

### Adding tests

A test case for a given `$transformation.xsl` is the combination of:
- An input metadata record: `fixtures/$input.xml`.
- Either:
  - An expected transformed metadata record: `tests/$transformation.$input.xml`.
  - An expected error message: `tests/$transformation.$input.err`.

### Adding fixtures

- Metadata records copied from real catalogs should be named as `<catalog-name>--<record-id>.xml`.
- Fake test records should be named as `sample--<short-description>.xml`.
