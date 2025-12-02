# Minimal package init for manufacturing_defect_prediction_app
# Add package-level exports here as needed.

__all__ = []

# Optionally expose a version if your project manages one
try:
    # If you have a _version.py (or similar), import it here
    from ._version import __version__  # noqa: F401
except Exception:
    __version__ = "0.0.0"
