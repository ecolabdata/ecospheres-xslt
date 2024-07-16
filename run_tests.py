import pytest
from difflib import ndiff, unified_diff
from lxml import etree
from pathlib import Path


def list_test_cases(cwd):
  xslt_dir = cwd / 'xslt'
  test_dir = cwd / 'test'
  for xslt_path in xslt_dir.glob('*.xsl'):
    for input_path in test_dir.glob(f'{xslt_path.stem}--*--input.xml'):
      input_name = input_path.stem[:-len('--input')]
      expected_path = input_path.with_stem(f'{input_name}--expected')
      yield (xslt_path, input_path, expected_path)

def make_transform(xslt_path):
  xslt_tree = etree.parse(xslt_path)
  transform = etree.XSLT(xslt_tree)
  return lambda tree: transform(tree, CoupledResourceLookUp="'disabled'")

def to_string(tree):
  etree.indent(tree)
  return etree.tostring(tree, pretty_print=True, encoding='unicode')

def compare(actual_tree, expected_tree):
  actual_lines = to_string(actual_tree).splitlines(keepends=True)
  expected_lines = to_string(expected_tree).splitlines(keepends=True)
  # diff = unified_diff(actual_lines, expected_lines, lineterm='')
  diff = ndiff(actual_lines, expected_lines)
  has_diff = any(d[0] != ' ' for d in diff)
  return ''.join(diff) if has_diff else None


def pytest_generate_tests(metafunc):
  argnames = ['xslt_path', 'input_path', 'expected_path']
  if not set(argnames) <= set(metafunc.fixturenames):
    raise RuntimeError('Cannot find test function')
  cwd = Path(metafunc.module.__file__).parent
  argvalues = list_test_cases(cwd)
  metafunc.parametrize(argnames, argvalues)


def test_transform(xslt_path, input_path, expected_path):
  if not xslt_path.exists():
    pytest.skip(f'Missing "xslt" file: {xslt_path.name}')
  if not input_path.exists():
    pytest.skip(f'Missing "input" file: {input_path.name}')
  if not expected_path.exists():
    pytest.skip(f'Missing "expected" file: {expected_path.name}')

  transform = make_transform(xslt_path)

  input_tree = etree.parse(input_path)
  actual_tree = transform(input_tree)
  expected_tree = etree.parse(expected_path)

  # print('input:\n', to_string(input_tree))
  # print('actual:\n', to_string(actual_tree))
  # print('expected:\n', to_string(expected_tree))

  diff = compare(actual_tree, expected_tree)
  
  if diff:
    print(diff)
    pytest.fail(f'{xslt_path.name}/{input_path.name}', pytrace=False)
