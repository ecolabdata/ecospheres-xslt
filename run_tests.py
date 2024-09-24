import pytest
from colorama import Fore, init
from difflib import unified_diff
from lxml import etree
from pathlib import Path

init()

CWD = Path(__file__).parent
FIXTURE_DIR = CWD / "fixtures"
TEST_DIR = CWD / "tests"
XSLT_DIR = CWD / "xslts"
XSLT_FIXTURE_SEP = "."


# Pytest entry point
def pytest_generate_tests(metafunc):
    argnames = ["xslt_name", "fixture_name", "test_suffix"]
    if not set(argnames) <= set(metafunc.fixturenames):
        raise RuntimeError("Cannot find test function")
    metafunc.parametrize(argnames, list_test_cases())


# Pytest parametrized test function
def test_transform(xslt_name, fixture_name, test_suffix):
    xslt_path = resolve(XSLT_DIR / f"{xslt_name}.xsl")
    fixture_path = resolve(FIXTURE_DIR / f"{fixture_name}.xml")
    expected_path = resolve(TEST_DIR / f"{xslt_name}{XSLT_FIXTURE_SEP}{fixture_name}.{test_suffix}")

    transform = make_transform(xslt_path)

    fixture_tree = etree.parse(fixture_path)

    if test_suffix == "xml":
        actual_tree = transform(fixture_tree)
        expected_tree = etree.parse(expected_path)
        compare(actual_tree, expected_tree)
    elif test_suffix == "err":
        expected_error = expected_path.open().read().strip()
        with pytest.raises(etree.XSLTApplyError) as e:
            transform(fixture_tree)
        assert str(e.value) == expected_error


def list_test_cases():
    for xslt_path in XSLT_DIR.glob("*.xsl"):
        xslt_name = xslt_path.stem
        for test_path in TEST_DIR.glob(f"{xslt_name}{XSLT_FIXTURE_SEP}*.*"):
            test_suffix = test_path.suffix[1:]
            if test_suffix not in ("xml", "err"):
                continue
            fixture_name = test_path.stem.split(XSLT_FIXTURE_SEP)[1]
            yield pytest.param(xslt_name, fixture_name, test_suffix, id=test_path.stem)


def resolve(path):
    if not path.exists():
        pytest.skip(f"Missing path: {path}")
    return path


def make_transform(xslt_path):
    xslt_tree = etree.parse(xslt_path)
    transform = etree.XSLT(xslt_tree)
    return lambda tree: transform(tree)


def to_string(tree):
    etree.indent(tree)
    return etree.tostring(tree, pretty_print=True, encoding="unicode")


def compare(actual_tree, expected_tree):
    actual_lines = to_string(actual_tree).splitlines()
    expected_lines = to_string(expected_tree).splitlines()
    diff = unified_diff(expected_lines, actual_lines, lineterm="")
    if any(d[0] != " " for d in diff):
        print("\n".join(color_diff(diff)))
        pytest.fail("Transformation output differs from expected\n" + "\n".join(diff), pytrace=False)


def color_diff(diff):
    for line in diff:
        if line.startswith("+") and not line.startswith("+++"):
            yield Fore.GREEN + line + Fore.RESET
        elif line.startswith("-"):
            yield Fore.RED + line + Fore.RESET
        elif line.startswith("^"):
            yield Fore.BLUE + line + Fore.RESET
        else:
            yield line
