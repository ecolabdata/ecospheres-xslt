# ecospheres-mdfix

Collection of XSLT to fix ISO-19139 XML metadata according to https://ecospheres.gitbook.io/recommandations-iso-dcat/.


## Running tests

```
pip install -r requirements.txt
pytest run_tests.py
```

## Adding tests

A test case `$bar` for `xslt/$foo.xsl` consists of the following pair of XML files :
- `test/$foo--$bar--input.xml`: Input XML fed to `$foo.xsl`. 
- `test/$foo--$bar--expected.xml`: Corresponding expected XML output.

