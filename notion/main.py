import datetime
import logging
import os

from notion.block import BookmarkBlock
from notion.client import NotionClient

# Get env parameters.
service_name = os.environ['INPUT_SERVICE_NAME']
artefact_name = os.environ['INPUT_ARTEFACT_NAME']
latest_tag = os.environ['INPUT_LATEST_TAG']
url_template = os.environ['INPUT_URL_TEMPLATE']
notion_token = os.environ['INPUT_NOTION_TOKEN']
notion_documentation_page = os.environ['INPUT_NOTION_DOCUMENTATION_PAGE']

# Build documentation url.
api_url = url_template \
    .replace("SERVICE_NAME", service_name) \
    .replace("LATEST_TAG", latest_tag) \
    .replace("ARTEFACT_NAME", artefact_name)
logging.info("Api url is {}.".format(api_url))

# Build Notion client and get documentation page.
client = NotionClient(token_v2=notion_token)
page = client.get_block(notion_documentation_page)

# Create element.
new_content = page.children.add_new(BookmarkBlock,
                                    title="Service {} - Release {}".format(service_name, latest_tag),
                                    description="Updated on {}".format(datetime.datetime.now().ctime()),
                                    link=api_url)

# Delete previous element.
first_element_in_page = page.children.__getitem__(0)
previous_content = [x for x in page.children if service_name in x.title][0]
previous_content.remove()
logging.info("Previous element ({}) deleted.".format(previous_content.title))

# Move element.
new_content.move_to(first_element_in_page, "after")

logging.info("Notion page has been updated !")
