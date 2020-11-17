import datetime
import os

from notion.block import BookmarkBlock
from notion.client import NotionClient

# Get env parameters.
service_name = os.environ['INPUT_SERVICE_NAME']
artefact_name = os.environ['INPUT_ARTEFACT_NAME']
latest_tag = os.environ['INPUT_LATEST_TAG']
# JFrog: "https://metroscope.jfrog.io/metroscope/maven-repo/com/metroscope/SERVICE_NAME/LATEST_TAG/ARTEFACT_NAME-LATEST_TAG.jar!/static/index.html"
url_template = os.environ['INPUT_URL_TEMPLATE']

notion_token = os.environ['INPUT_NOTION_TOKEN']
notion_documentation_page = os.environ['INPUT_NOTION_DOCUMENTATION_PAGE']

api_url = url_template \
    .replace("SERVICE_NAME", service_name) \
    .replace("LATEST_TAG", latest_tag) \
    .replace("ARTEFACT_NAME", artefact_name)

# Build Notion client and get documentation page.
# Obtain the `token_v2` value by inspecting your browser cookies on a logged-in (non-guest) session on Notion.so.
client = NotionClient(token_v2=notion_token)
page = client.get_block(notion_documentation_page)

# Update Notion page.
newPage = page.children.add_new(BookmarkBlock,
                                title="Service {} - Release {}".format(service_name, latest_tag),
                                description="Updated on {}".format(datetime.datetime.now().ctime()),
                                link=api_url)
first = page.children.__getitem__(0)
previous = [x for x in page.children if service_name in x.title][0]
previous.remove()
newPage.move_to(first, "after")
