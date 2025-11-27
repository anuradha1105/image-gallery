# 

from flask import Flask, render_template, request, redirect, url_for, abort
import os
import uuid
from werkzeug.utils import secure_filename

app = Flask(__name__)

# --- config (UPDATED) ---
# Allow tests to override the upload directory with the UPLOAD_DIR env var.
DEFAULT_UPLOAD_DIR = os.path.join(app.root_path, "static", "uploads")
UPLOAD_FOLDER = os.environ.get("UPLOAD_DIR", DEFAULT_UPLOAD_DIR)

ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif", "webp"}
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["MAX_CONTENT_LENGTH"] = 10 * 1024 * 1024  # 10 MB

# Ensure upload folder exists (do NOT try to delete it)
# Ensure upload folder exists (handle file vs folder correctly)
if os.path.exists(UPLOAD_FOLDER):
    if os.path.isdir(UPLOAD_FOLDER):
        # Path exists and is already a directory -> nothing to do
        pass
    else:
        # A file exists where the folder should be -> remove and recreate as directory
        os.remove(UPLOAD_FOLDER)
        os.makedirs(UPLOAD_FOLDER, exist_ok=True)
else:
    # Path does not exist at all -> create directory
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)


def allowed_file(filename: str) -> bool:
    ext = filename.rsplit(".", 1)[-1].lower() if "." in filename else ""
    return ext in ALLOWED_EXTENSIONS

@app.route("/")
def index():
    files = []
    for name in os.listdir(app.config["UPLOAD_FOLDER"]):
        if name.startswith("."):
            continue
        if allowed_file(name):
            files.append(name)
    files.sort()
    image_urls = [url_for("static", filename=f"uploads/{name}") for name in files]
    return render_template("index.html", images=image_urls)

@app.route("/upload", methods=["GET", "POST"])
def upload_file():
    if request.method == "POST":
        if "file" not in request.files:
            abort(400, "No file part")
        f = request.files["file"]
        if not f or f.filename == "":
            abort(400, "No selected file")
        if not allowed_file(f.filename):
            abort(400, "Unsupported file type")
        base = secure_filename(f.filename)
        name, dot, ext = base.rpartition(".")
        if ext:
            unique = f"{name or 'image'}-{uuid.uuid4().hex[:8]}.{ext}"
        else:
            unique = f"{base}-{uuid.uuid4().hex[:8]}"
        dest = os.path.join(app.config["UPLOAD_FOLDER"], unique)
        f.save(dest)
        return redirect(url_for("index"))
    return render_template("upload.html")

if __name__ == "__main__":
    # dev server; containers/VM use gunicorn
    app.run(host="0.0.0.0", port=5000, debug=True)
