from pathlib import Path
from http.server import ThreadingHTTPServer
from urllib.parse import urlparse

import app


class Handler(app.Handler):
    def do_GET(self):
        path = urlparse(self.path).path
        if path == '/download/report':
            f = app.RESULTS / 'BEANS_FULL_REPORT.md'
            if not f.exists():
                return self.send_bytes(b'Report not ready.', code=404)
            return self.send_bytes(
                f.read_bytes(),
                'text/markdown; charset=utf-8',
                200,
                'attachment; filename="BEANS_FULL_REPORT.md"',
            )
        if path == '/download/archive':
            f = app.RESULTS / 'beans_adas_run_archive.json'
            if not f.exists():
                return self.send_bytes(b'Archive not ready.', code=404)
            return self.send_bytes(
                f.read_bytes(),
                'application/json',
                200,
                'attachment; filename="beans_adas_run_archive.json"',
            )
        return super().do_GET()


if __name__ == '__main__':
    print('BEANS UI ready at http://127.0.0.1:8765', flush=True)
    ThreadingHTTPServer(('0.0.0.0', 8765), Handler).serve_forever()
