# Temporary runtime shim: load the hyphenated-folder package by path and
# inject as manufacturing_defect_prediction_app into sys.modules.
# Use only for quick testing. Place this at the top of your entrypoint
# (before other imports) if you cannot rename yet.

import importlib.util
import sys
import pathlib

HYphenated = "Manufacturing-Defect-Prediction-App"
# If your package is under src/, set this accordingly: pathlib.Path("src") / HYphenated
pkg_path = pathlib.Path(HYphenated) / "__init__.py"

if pkg_path.exists():
    spec = importlib.util.spec_from_file_location("manufacturing_defect_prediction_app", str(pkg_path))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)  # type: ignore
    sys.modules["manufacturing_defect_prediction_app"] = module
else:
    # Try fallback: main module file
    maybe = pathlib.Path(HYphenated)
    py_files = list(maybe.glob("*.py")) if maybe.exists() else []
    if py_files:
        # load a single top-level module file under the hyphenated folder
        spec = importlib.util.spec_from_file_location("manufacturing_defect_prediction_app", str(py_files[0]))
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)  # type: ignore
        sys.modules["manufacturing_defect_prediction_app"] = module
    else:
        # No hyphenated package found — nothing to shim.
        pass

# After this runs, code can `import manufacturing_defect_prediction_app` (temporary).
