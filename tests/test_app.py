import os, sys

# Use a temp folder inside the container for tests
os.environ.setdefault("UPLOAD_DIR", "/tmp/test-uploads")

# Ensure repo root (where app.py lives) is importable inside Docker
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

import app  # imports your app.py

def test_index_ok():
    app.app.testing = True
    with app.app.test_client() as client:
        r = client.get("/")
        assert r.status_code == 200