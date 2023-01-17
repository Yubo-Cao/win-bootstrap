import asyncio

from common import DOWNLOAD_DIR, run
from playwright.async_api import async_playwright
import re


async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False)
        page = await browser.new_page()
        await page.goto("https://freefilesync.org/")
        await page.get_by_role("navigation").get_by_role(
            "link", name="Download"
        ).click()
        async with page.expect_download() as download_info:
            await page.get_by_role(
                "link",
                name=re.compile(r"Download FreeFileSync\s*.*\s*Windows"),
            ).click()
        download = await download_info.value
        target = DOWNLOAD_DIR / "freefilesync.exe"
        await download.save_as(target)
        await run(target)


asyncio.run(main())
