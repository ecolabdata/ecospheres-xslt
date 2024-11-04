import pytest
import tomllib
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
    argnames = ["xslt_name", "fixture_name", "test_stem", "test_suffix", "has_config"]
    if not set(argnames) <= set(metafunc.fixturenames):
        raise RuntimeError("Cannot find test function")
    metafunc.parametrize(argnames, list_test_cases())


# Pytest parametrized test function
def test_transform(xslt_name, fixture_name, test_stem, test_suffix, has_config):
    xslt_path = resolve(XSLT_DIR / f"{xslt_name}.xsl")
    fixture_path = resolve(FIXTURE_DIR / f"{fixture_name}.xml")
    expected_path = resolve(TEST_DIR / f"{test_stem}.{test_suffix}")
    test_params = (
        load_test_params(resolve(TEST_DIR / f"{test_stem}.conf")) if has_config else {}
    )

    transform = make_transform(xslt_path)

    fixture_tree = etree.parse(fixture_path)

    if test_suffix == "xml":
        actual_tree = transform(fixture_tree, **test_params)
        expected_tree = etree.parse(expected_path)
        compare(actual_tree, expected_tree)
    elif test_suffix == "err":
        expected_error = expected_path.open().read().strip()
        with pytest.raises(etree.XSLTApplyError) as e:
            transform(fixture_tree, **test_params)
        assert str(e.value).strip() == expected_error


def list_test_cases():
    for xslt_path in XSLT_DIR.glob("*.xsl"):
        xslt_name = xslt_path.stem
        for test_path in TEST_DIR.glob(f"{xslt_name}{XSLT_FIXTURE_SEP}*.*"):
            test_suffix = test_path.suffix[1:]
            if test_suffix not in ("xml", "err"):
                continue
            test_stem = test_path.stem
            parts = test_stem.split(XSLT_FIXTURE_SEP)
            fixture_name = parts[1]
            has_config = len(parts) > 2
            yield pytest.param(
                xslt_name,
                fixture_name,
                test_stem,
                test_suffix,
                has_config,
                id=test_stem,
            )


def resolve(path, silent=False):
    if not path.exists():
        if silent:
            return None
        else:
            pytest.skip(f"Missing path: {path}")
    return path


def make_transform(xslt_path):
    xslt_tree = etree.parse(xslt_path)
    transform = etree.XSLT(xslt_tree)
    return lambda tree, *args, **kw: transform(tree, *args, **kw)


def load_test_params(config_path):
    with config_path.open(mode="rb") as f:
        params = tomllib.load(f).get("params", {})
    return {k: etree.XSLT.strparam(v) for k, v in params.items()}


def to_string(tree):
    etree.indent(tree)
    return etree.tostring(tree, pretty_print=True, encoding="unicode")


def compare(actual_tree, expected_tree):
    actual_lines = to_string(actual_tree).splitlines()
    expected_lines = to_string(expected_tree).splitlines()
    diff = unified_diff(expected_lines, actual_lines, lineterm="")
    if any(d[0] != " " for d in diff):
        print("\n".join(color_diff(diff)))
        pytest.fail("XSLT output != expected\n" + "\n".join(diff), pytrace=False)


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
