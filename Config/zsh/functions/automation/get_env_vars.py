#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "playwright",
# ]
# ///

import os
import sys
from playwright.sync_api import Playwright, sync_playwright, expect

ALLOWED_ENVS = ["dev", "hom", "plat", "prod", "root", "sand", "sec"]


def run(playwright: Playwright) -> None:
    # Get the first parameter from command line (python)
    args = sys.argv[1:]
    if len(args) == 0:
        environ = "hom"
    else:
        environ = args[0].lower()

    # Verify if the first arg (environment) is in the allowed environments
    if environ not in ALLOWED_ENVS:
        return -1

    browser = playwright.chromium.launch(headless=True)

    script_path = sys.argv[0]
    script_full_path = os.path.abspath(script_path)
    script_dir = os.path.dirname(script_full_path)

    context = browser.new_context(storage_state=f"{script_dir}/session.json")
    page = context.new_page()
    destination = os.getenv("CURRENT_AWS_AUTH_URL")
    page.goto(destination)

    ACCOUNT_TITLE = ""
    AWS_DEFAULT_REGION = "us-east-1"
    if environ == "dev":
        ACCOUNT_TITLE = os.getenv("AWS_DEV_ACCOUNT")
    elif environ == "hom":
        ACCOUNT_TITLE = os.getenv("AWS_HOM_ACCOUNT")
    elif environ == "plat":
        ACCOUNT_TITLE = os.getenv("AWS_PLT_ACCOUNT")
    elif environ == "prod":
        ACCOUNT_TITLE = os.getenv("AWS_PRD_ACCOUNT")
        AWS_DEFAULT_REGION = "sa-east-1"
    elif environ == "root":
        ACCOUNT_TITLE = os.getenv("AWS_ROT_ACCOUNT")
    elif environ == "sand":
        ACCOUNT_TITLE = os.getenv("AWS_SND_ACCOUNT")
    elif environ == "sec":
        ACCOUNT_TITLE = os.getenv("AWS_SEC_ACCOUNT")
    else:
        return -1

    page.get_by_role("button", name=ACCOUNT_TITLE).click()
    page.get_by_test_id("role-creation-action-button").click()

    ACCESS_KEY = page.get_by_label("AWS access key ID", exact=True).input_value()
    SECRET_KEY = page.get_by_label("AWS secret access key", exact=True).input_value()
    SESSION_TOKEN = page.get_by_label("AWS session token", exact=True).input_value()

    page.close()

    print(ACCESS_KEY)
    print(SECRET_KEY)
    print(SESSION_TOKEN)
    print(AWS_DEFAULT_REGION)
    print(ACCOUNT_TITLE)

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
