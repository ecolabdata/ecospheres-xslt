import pytest
import tomllib
from colorama import Fore, init
from difflib import unified_diff
from lxml import etree
from pathlib import Path

init()

BASE_PATH = Path(__file__).parent
FIXTURE_DIR = Path("fixtures")
TEST_DIR = Path("tests")
XSLT_FIXTURE_SEP = "."


# Pytest entry point
def pytest_generate_tests(metafunc):
    argnames = ["standard_name", "xslt_name", "fixture_name", "test_stem", "test_suffix", "has_config"]
    if not set(argnames) <= set(metafunc.fixturenames):
        raise RuntimeError("Cannot find test function")
    metafunc.parametrize(argnames, list_test_cases())


# Pytest parametrized test function
def test_transform(standard_name, xslt_name, fixture_name, test_stem, test_suffix, has_config):
    standard_path = BASE_PATH/standard_name
    xslt_path = resolve(standard_path/f"{xslt_name}.xsl")
    fixture_path = resolve(standard_path/FIXTURE_DIR/f"{fixture_name}.xml")
    expected_path = resolve(standard_path/TEST_DIR/f"{test_stem}.{test_suffix}")
    messages_path = resolve(standard_path/TEST_DIR/f"{test_stem}.msg", silent=True)
    test_params = (
        load_test_params(resolve(standard_path/TEST_DIR/f"{test_stem}.conf")) if has_config else {}
    )

    transform = etree.XSLT(etree.parse(xslt_path))

    fixture_tree = etree.parse(fixture_path)

    if test_suffix == "xml":
        actual_tree = transform(fixture_tree, **test_params)
        expected_tree = etree.parse(expected_path)
        compare_trees(actual_tree, expected_tree)
        if messages_path:
            actual_messages = [e.message for e in transform.error_log]
            expected_messages = messages_path.open().readlines()
            compare_messages(actual_messages, expected_messages)
    elif test_suffix == "err":
        expected_error = expected_path.open().read().strip()
        with pytest.raises(etree.XSLTApplyError) as e:
            transform(fixture_tree, **test_params)
        assert str(e.value).strip() == expected_error


def list_test_cases():
    standards = sorted(set([p.parent.stem for p in BASE_PATH.glob("*/*.xsl")]))
    for standard_name in standards:
        path = BASE_PATH/standard_name
        for xslt_path in path.glob("*.xsl"):
            xslt_name = xslt_path.stem
            for test_path in (path/TEST_DIR).glob(f"{xslt_name}{XSLT_FIXTURE_SEP}*.*"):
                test_suffix = test_path.suffix[1:]
                if test_suffix not in ("xml", "err"):
                    continue
                test_stem = test_path.stem
                parts = test_stem.split(XSLT_FIXTURE_SEP)
                fixture_name = parts[1]
                has_config = len(parts) > 2
                yield pytest.param(
                    standard_name,
                    xslt_name,
                    fixture_name,
                    test_stem,
                    test_suffix,
                    has_config,
                    id=f"{standard_name}:{test_stem}",
                )


def resolve(path, silent=False):
    if not path.exists():
        if silent:
            return None
        else:
            pytest.skip(f"Missing path: {path}")
    return path


def load_test_params(config_path):
    with config_path.open(mode="rb") as f:
        params = tomllib.load(f).get("params", {})
    return {k: etree.XSLT.strparam(v) for k, v in params.items()}


def to_string(tree):
    etree.indent(tree)
    return etree.tostring(tree, pretty_print=True, encoding="unicode")


def compare_trees(actual_tree, expected_tree):
    actual_lines = to_string(actual_tree).splitlines()
    expected_lines = to_string(expected_tree).splitlines()
    diff = unified_diff(expected_lines, actual_lines, lineterm="")
    if any(d[0] != " " for d in diff):
        print("\n".join(list(color_diff(diff))[1:]))
        pytest.fail("XSLT output != expected\n" + "\n".join(diff), pytrace=False)


def compare_messages(actual_messages, expected_messages):
    actual_lines = [m.strip() for m in actual_messages]
    expected_lines = [m.strip() for m in expected_messages]
    if not all([m in actual_lines for m in expected_lines]):
        diff = unified_diff(expected_lines, actual_lines, lineterm="")
        print("\n".join(list(color_diff(diff))[2:]))
        pytest.fail("MSG output != expected" + "\n".join(diff), pytrace=False)


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
