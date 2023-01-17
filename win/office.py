import asyncio
from json import loads
from pathlib import Path

from playwright.async_api import Page, async_playwright, Download

ROOT = Path(__file__).resolve().parent.parent


async def login(page: Page) -> None:
    """Login to GCPS

    Args:
        page (Page): Page object
    """

    await page.goto("https://publish.gwinnett.k12.ga.us/gcps/home/gcpslogin")

    for control, content in zip(
        [page.get_by_placeholder(holder) for holder in ["USER ID", "PASSWORD"]],
        [load_config()["gcps"][key] for key in ["username", "password"]],
    ):
        await control.fill(content)
    await page.get_by_placeholder("PASSWORD").press("Enter")


def load_config() -> dict[str, any]:
    return loads((ROOT / "secret" / "passwords.json").read_text(encoding="utf-8"))


async def download_offce(page: Page) -> Download:
    """Download office from GCPS

    Args:
        page (Page): The page object
    """

    async with page.expect_popup() as download_page_info:
        await page.get_by_role("link", name="Microsoft 365").click()
    download_page = await download_page_info.value
    await download_page.get_by_role("button", name="Install apps").click()
    async with download_page.expect_download() as download_info:
        await download_page.get_by_role(
            "option",
            name="Install apps. Includes Outlook, OneDrive for Business, Word, Excel, PowerPoint, and more.. Select this button to download the installer and open a dialogue with additional help.",
        ).get_by_text("Microsoft 365 apps").click()
    return await download_info.value


async def main():
    async with async_playwright() as page:
        browser = await page.chromium.launch(headless=False)
        page = await browser.new_page()
        await login(page)
        download = await download_offce(page)
        target = ROOT / "downloads" / "office.exe"
        target.parent.mkdir(parents=True, exist_ok=True)
        await download.save_as(target)
        try:
            # it will needs admin, so it will throw but still run
            await asyncio.create_subprocess_shell(
                str(target),
                cwd=target.parent,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
        except Exception as e:
            print(e)
        finally:
            await browser.close()


asyncio.run(main())
