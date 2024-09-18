import pytest
from difflib import ndiff, unified_diff
from lxml import etree
from pathlib import Path

CWD = Path(__file__).parent
XSLT_DIR = CWD / "xslt"
TEST_DIR = CWD / "test"
FIXTURE_DIR = TEST_DIR / "fixtures"


# Pytest entry point
def pytest_generate_tests(metafunc):
  argnames = ["xslt_name", "fixture_name"]
  if not set(argnames) <= set(metafunc.fixturenames):
    raise RuntimeError("Cannot find test function")
  metafunc.parametrize(argnames, list_test_cases())


# Parametrized test function
def test_transform(xslt_name, fixture_name):
  xslt_path = resolve(XSLT_DIR / f"{xslt_name}.xsl")
  fixture_path = resolve(FIXTURE_DIR / f"{fixture_name}.xml")
  expected_path = resolve(TEST_DIR /f"{xslt_name}--{fixture_name}.xml")

  transform = make_transform(xslt_path)

  fixture_tree = etree.parse(fixture_path)
  actual_tree = transform(fixture_tree)
  expected_tree = etree.parse(expected_path)

  # print("fixture:\n", to_string(fixture_tree))
  # print("actual:\n", to_string(actual_tree))
  # print("expected:\n", to_string(expected_tree))

  diff = compare(actual_tree, expected_tree)
  if diff:
    print(diff)
    pytest.fail(f"{xslt_path.name}/{fixture_path.name}", pytrace=False)


# Helper functions

def list_test_cases():
  for xslt_path in XSLT_DIR.glob("*.xsl"):
    xslt_name = xslt_path.stem
    for test_path in TEST_DIR.glob(f"{xslt_name}--*.xml"):
      fixture_name = test_path.stem.split("--")[1]
      yield pytest.param(xslt_name, fixture_name, id=test_path.stem)

def resolve(path):
  if not path.exists():
    pytest.skip(f"Missing path: {path}")
  return path

def make_transform(xslt_path):
  xslt_tree = etree.parse(xslt_path)
  transform = etree.XSLT(xslt_tree)
  return lambda tree: transform(tree, CoupledResourceLookUp="'disabled'")

def to_string(tree):
  etree.indent(tree)
  return etree.tostring(tree, pretty_print=True, encoding="unicode")

def compare(actual_tree, expected_tree):
  actual_lines = to_string(actual_tree).splitlines(keepends=True)
  expected_lines = to_string(expected_tree).splitlines(keepends=True)
  # diff = unified_diff(actual_lines, expected_lines, lineterm="")
  diff = ndiff(actual_lines, expected_lines)
  has_diff = any(d[0] != " " for d in diff)
  return "".join(diff) if has_diff else None
