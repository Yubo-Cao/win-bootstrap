import asyncio
from json import loads as _loads
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOWNLOAD_DIR = ROOT / "downloads"
DOWNLOAD_DIR.mkdir(exist_ok=True, parents=True)


def load_config() -> dict[str, any]:
    return _loads((ROOT / "secret" / "passwords.json").read_text(encoding="utf-8"))


async def run(target):
    try:
        # installer usually need asyncio
        await asyncio.create_subprocess_shell(
            str(target),
            cwd=target.parent,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
    except Exception as e:
        print(e)
