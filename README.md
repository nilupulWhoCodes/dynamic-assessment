# FYP — local Python setup (moving off Colab)

Score-informed dynamic marking adherence evaluation. This folder replaces the Colab
workflow: same notebook, same numbers, running on your own machine.

## Why venv + pip (not conda)

Both `music21` and `pretty_midi` are pure-Python packages published as wheels on PyPI.
There is nothing to compile and no system libraries to pull in, so `pip install` inside a
virtual environment is the simplest thing that works — conda buys you nothing here. The
Colab line `!pip install music21 pretty_midi -q` becomes a line in `requirements.txt`,
installed once into `.venv` instead of on every session start.

(If a later notebook needs GPU PyTorch for the model, you can still `pip install` the CUDA
build from the PyTorch index — conda is not required for that either.)

## One-time install

**1. Python** — install 3.11 or 3.12 from <https://www.python.org/downloads/>.
During install, tick **"Add python.exe to PATH"**.

**2. Git** — install from <https://git-scm.com/downloads>. Needed because the notebook
clones the (n)ASAP dataset.

**3. Set up this project** — open PowerShell in this folder and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

That creates `.venv`, installs everything in `requirements.txt`, and registers the venv as
a Jupyter kernel named **Python 3 (fyp venv)**.

If you prefer to do it by hand:

```powershell
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install -r requirements.txt
python -m ipykernel install --user --name fyp --display-name "Python 3 (fyp venv)"
```

## Running the notebook

```powershell
.\.venv\Scripts\Activate.ps1
jupyter lab
```

JupyterLab opens at <http://localhost:8888>. Open
`notebooks\Notebook_01_Setup_and_Exploration.ipynb`, make sure the kernel in the top-right
says **Python 3 (fyp venv)**, then run the cells top to bottom.

VS Code works too: open this folder, open the notebook, and pick the `.venv` interpreter as
the kernel.

## What changed from the Colab version

| Colab | Local |
|---|---|
| `!pip install music21 pretty_midi -q` every session | `requirements.txt`, installed once into `.venv` |
| `drive.mount('/content/drive')` | nothing — files live in this folder |
| `BASE = /content/drive/MyDrive/fyp_try2` | `BASE = <project>/fyp_try2` |
| `ASAP_ROOT = /content/asap-dataset` | `ASAP_ROOT = <project>/data/asap-dataset` |
| Dataset re-cloned on every session | cloned once, skipped if `metadata.csv` is already there |

A new **environment check** cell was added at the top. It prints the interpreter path and
each package version — the local equivalent of watching the pip install succeed. If it says
`MISSING`, the venv is not active or `setup.ps1` did not finish.

The analysis cells themselves are untouched.

## Folder layout after the first run

```
fyp/
├─ .venv/                              # virtual environment (not in git)
├─ notebooks/
│  └─ Notebook_01_Setup_and_Exploration.ipynb
├─ data/
│  └─ asap-dataset/                    # cloned by the notebook, ~1.9 GB, 10,314 files
├─ fyp_try2/                           # outputs — what used to go to Drive
│  ├─ cleaned_metadata.csv
│  └─ cleaned_metadata_provenance.json
├─ requirements.txt
├─ setup.ps1
└─ README.md
```

The clone is the slow part: **~1.9 GB**, a few minutes on a decent connection. It only
happens once — after that the cell prints `ASAP dataset already on disk - skipping clone`.

## Expected output of notebook 01

Verified against the real dataset, and it matches your Colab run exactly:

```
shape: (1066, 17)
Unique pieces      : 242
Total performances : 1066
1066 -> 834 performances (232 dropped for unreliable alignment)
Pieces remaining: 187
19 pieces have more than 10 performances (10.2% of pieces)
Now: 834 performances | After cap at assembly: 696 (138 rows trimmed from 19 pieces)
Saved 834 rows (187 pieces) to ...\fyp\fyp_try2\cleaned_metadata.csv
```

## Troubleshooting

- **`git` not found in the notebook, but works in PowerShell** — restart the Jupyter kernel
  (the kernel inherited the old PATH).
- **Wrong kernel** — the env-check cell prints `executable:`. It must point inside
  `fyp\.venv\`. If it points at a system Python, switch the kernel.
- **`ExecutionPolicy` blocks `Activate.ps1`** — run
  `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once, or use
  `.\.venv\Scripts\activate.bat` from cmd.exe.
- **Clone fails on long filenames** — the deepest path in the dataset is 114 characters, so
  this should not bite unless the project sits very deep in your drive. If it does:
  `git config --global core.longpaths true`.
- **`music21` warns about MuseScore** — harmless for this notebook. You only need it if you
  later want music21 to render scores; you already have Muse Hub installed, so
  `python -c "import music21; music21.configure.run()"` would wire it up.
- **Storage** — keep ~3 GB free for the dataset plus the venv.
