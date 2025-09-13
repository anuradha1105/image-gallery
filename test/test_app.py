from app.app import app

def test_index_ok():
    app.testing = True
    with app.test_client() as c:
        r = c.get("/")
        assert r.status_code == 200
        assert b"Uploaded images" in r.data
