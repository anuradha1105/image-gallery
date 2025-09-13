from flask import Flask, render_template, request, redirect, url_for, abort
import os, uuid
from werkzeug.utils import secure_filename

app = Flask(__name__)

# Config
UPLOAD_FOLDER = os.path.join(app.root_path, "static", "uploads")
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif", "webp"}
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["MAX_CONTENT_LENGTH"] = 10 * 1024 * 1024  # 10 MB

# Ensure upload folder exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def allowed_file(filename: str) -> bool:
    ext = filename.rsplit(".", 1)[-1].lower() if "." in filename else ""
    return ext in ALLOWED_EXTENSIONS

@app.route("/")
def index():
    # Only show image files; hide dotfiles
    files = []
    for name in os.listdir(app.config["UPLOAD_FOLDER"]):
        if name.startswith("."):
            continue
        if allowed_file(name):
            files.append(name)
    files.sort()
    # Build static URLs
    image_urls = [url_for("static", filename=f"uploads/{name}") for name in files]
    return render_template("index.html", images=image_urls)

@app.route("/upload", methods=["GET", "POST"])
def upload_file():
    if request.method == "POST":
        if "file" not in request.files:
            abort(400, description="No file part")
        f = request.files["file"]
        if not f or f.filename == "":
            abort(400, description="No selected file")
        if not allowed_file(f.filename):
            abort(400, description="Unsupported file type")
        # safe name + de-duplicate
        base = secure_filename(f.filename)
        name, dot, ext = base.rpartition(".")
        unique = f"{name or 'image'}-{uuid.uuid4().hex[:8]}.{ext}" if ext else f"{base}-{uuid.uuid4().hex[:8]}"
        dest = os.path.join(app.config["UPLOAD_FOLDER"], unique)
        f.save(dest)
        return redirect(url_for("index"))
    return render_template("upload.html")

if __name__ == "__main__":
    # For local dev; use Gunicorn in production: `gunicorn -b 0.0.0.0:5000 app:app`
    app.run(host="0.0.0.0", port=5000, debug=True)
