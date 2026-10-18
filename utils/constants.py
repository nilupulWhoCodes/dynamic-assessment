from pathlib import Path

PROJECT = Path(__file__).resolve().parent.parent
DATASET_LOCATION = PROJECT / "data" / "asap-dataset"
ARTIFACTS_LOCATION = PROJECT / "artifacts"
SYNTH_ROOT = ARTIFACTS_LOCATION / 'synthetic-data'
SYNTHETIC_XML_OUTPUT_LOCATION = SYNTH_ROOT / 'xml'
SYNTHETIC_MIDI_OUTPUT_LOCATION = SYNTH_ROOT / 'midi'

PRIMARY_COLOR = "#12355B"    # Deep navy
SECONDARY_COLOR = "#420039"  # Deep plum
ACCENT_COLOR = "#4F6D7A"     # Steel blue
TERTIARY_COLOR = "#56A3A6"   # Teal
BACKGROUND_COLOR = "#B8DBD9"  # Light mint

LEVEL_ORDER = ["ppp", "pp", "p", "mp", "mf", "f", "ff", "fff"]
CONSTANT_INVERSION = {
    "ppp": "fff", "pp": "ff", "p": "f", "mp": "mf",
    "mf": "mp", "f": "p", "ff": "pp", "fff": "ppp",
}
WEDGE_INVERSION = {"crescendo": "diminuendo", "diminuendo": "crescendo"}
VELOCITY_MAP = {
    "ppp": 16, "pp": 33, "p": 49, "mp": 64,
    "mf": 80, "f": 96, "ff": 112, "fff": 126,
}
DEFAULT_DYNAMIC = "mf"

CAP = 13
SYNTH_RATIO = 0.3
FULL_INVERSION_SHARE = 0.25 
WEDGE_FLIP_PROB = 0.5
SEED = 42