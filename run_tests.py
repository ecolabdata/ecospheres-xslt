import pytest
import tomllib
from colorama import Fore, init
from difflib import unified_diff
from pathlib import Path
from saxonche import PySaxonProcessor, PySaxonApiError

init()

BASE_PATH = Path(__file__).parent
FIXTURE_DIR = Path("fixtures")
TEST_DIR = Path("tests")
XSLT_FIXTURE_SEP = "."

SAXON_PROC = PySaxonProcessor(license=False)
SAXON_PROC.set_configuration_property("http://saxon.sf.net/feature/strip-whitespace", "all")


# Pytest entry point
def pytest_generate_tests(metafunc):
    argnames = ["standard_name", "xslt_name", "fixture_name", "test_stem", "test_suffix"]
    if not set(argnames) <= set(metafunc.fixturenames):
        raise RuntimeError("Cannot find test function")
    metafunc.parametrize(argnames, list_test_cases())


# Pytest parametrized test function
def test_transform(standard_name, xslt_name, fixture_name, test_stem, test_suffix):
    standard_path = BASE_PATH/standard_name
    xslt_path = resolve(standard_path/f"{xslt_name}.xsl")
    fixture_path = resolve(standard_path/FIXTURE_DIR/f"{fixture_name}.xml")
    expected_path = resolve(standard_path/TEST_DIR/f"{test_stem}.{test_suffix}")
    messages_path = resolve(standard_path/TEST_DIR/f"{test_stem}.msg", silent=True)
    config_path = resolve(standard_path/TEST_DIR/f"{test_stem}.conf", silent=True)

    xslt_proc = SAXON_PROC.new_xslt30_processor()
    xslt_exec = xslt_proc.compile_stylesheet(stylesheet_file=str(xslt_path))
    xslt_exec.set_property("!omit-xml-declaration", "no")
    xslt_exec.set_property("!indent", "yes")
    xslt_exec.set_save_xsl_message(True)
    if config_path:
        with config_path.open(mode="rb") as f:
            params = tomllib.load(f).get("params", {})
            for param_name, param_value in params.items():
                if v := param_value.strip():
                    xslt_exec.set_parameter(param_name, SAXON_PROC.make_string_value(v))

    if test_suffix == "xml":
        actual_tree = xslt_exec.transform_to_value(source_file=str(fixture_path)).head
        expected_tree = SAXON_PROC.parse_xml(xml_file_name=str(expected_path))
        compare_trees(actual_tree, expected_tree)
        if messages_path:
            actual_messages = get_actual_messages(xslt_exec)
            expected_messages = get_expected_messages(messages_path)
            compare_messages(actual_messages, expected_messages)
    elif test_suffix == "err":
        with pytest.raises(PySaxonApiError):
            xslt_exec.transform_to_string(source_file=str(fixture_path))
        actual_messages = get_actual_messages(xslt_exec)
        expected_messages = get_expected_messages(expected_path)
        compare_messages(actual_messages, expected_messages)


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
                yield pytest.param(
                    standard_name,
                    xslt_name,
                    fixture_name,
                    test_stem,
                    test_suffix,
                    id=f"{standard_name}:{test_stem}",
                )


def resolve(path, silent=False):
    if not path.exists():
        if silent:
            return None
        else:
            pytest.skip(f"Missing path: {path}")
    return path


def get_expected_messages(path) -> list[str]:
    return [line for line in path.open() if not line.strip().startswith("#")]


def get_actual_messages(xslt_exec) -> list[str]:
    if messages := xslt_exec.get_xsl_messages():
        return [node.string_value for node in messages]
    else:
        return []


def to_string(tree):
    xquery_proc = SAXON_PROC.new_xquery_processor()
    xquery_proc.set_property("!omit-xml-declaration", "no")
    xquery_proc.set_property("!indent", "yes")
    xquery_proc.set_context(xdm_item=tree)
    return xquery_proc.run_query_to_string(query_text=".")


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
